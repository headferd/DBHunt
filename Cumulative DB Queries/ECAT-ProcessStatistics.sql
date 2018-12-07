with preferences as (
    select time_span    = 60,                   --span in minutes (60 is good for monitoring)
           utc_offset   = -4.0,                 --UTC+X in hours
           the_time_now = getutcdate(),         --not recommended to change this one
           time_format  = 'yyyy/MM/dd - HH\hmm' --format used to display timestamps
), t2 as (
    select n = row_number() over (order by [object_id])-1 from sys.all_objects
	union select -1  --comment this line to disable the "Future" row
)
select top 100
    case when n >= 0 then 'T+'+convert(varchar, n)+' x'+convert(varchar,max(p2.time_span))+' min'
		 else 'Future' end as Time_Span,
    case when n >= 0 then format(dateadd(HOUR, -n+max(utc_offset), max(the_time_now)),max(time_format))
		 else 'Queued; To be Merged' end as BPM_Time,
	
    case when n<0 then '|_' else '|' end [|],
	case when n<0 then '' when max(timestamp) is null then null else convert(varchar,count(p1_timestamp)+count(p0_timestamp)) end Tot_Done,
	case when n<0 then '' when max(errors) is null then null else convert(varchar,sum(p1_errors)+sum(p0_errors)) end Tot_Err,
	case when n<0 then cast(max(datediff(ss, pQ_timestamp, GETUTCDATE()))/(3600.) as decimal(18,2))
		 when max(timestamp) is null then null 
		 else cast(max(datediff(ss, timestamp, mergetime))/(3600.) as decimal(18,2)) end as Tot_WaitHrs,
	
	case when n<0 then '|_' else '|' end [|],
	case when max(p1_timestamp) is null then '' when max(timestamp) is null then null 
		else format(dateadd(HOUR,max(utc_offset),min(p1_timestamp)),max(time_format)) end P1_OldestDate,
	case when max(timestamp) is null then null when max(p1_timestamp) is null then 0 else count(p1_timestamp) end P1_Tot,
	case when max(timestamp) is null then null when max(p1_timestamp) is null then 0 else sum(p1_id) end MachineId,
	case when max(timestamp) is null then null when max(p1_timestamp) is null then 0 else sum(p1_track) end TrackReq,
	case when max(timestamp) is null then null when max(p1_timestamp) is null then 0 else sum(p1_schedscan) end SchedScan,
	case when max(timestamp) is null then null when max(p1_timestamp) is null then 0 else sum(p1_pcscan) end NewPCScan,
	case when max(timestamp) is null then null when max(p1_timestamp) is null then 0 else sum(p1_modscan) end NewModScan,
	case when max(timestamp) is null then null when max(p1_errors) is null then 0 else sum(p1_errors) end P1_Err,
	case when n<0 and max(pQ1_timestamp) is null then cast(0 as decimal(18,2))
		when n<0 then cast(max(datediff(ss, pQ1_timestamp, GETUTCDATE()))/(3600.) as decimal(18,2))
		when max(timestamp) is null then null when max(p1_timestamp) is null then 0
		else cast(max(datediff(ss, p1_timestamp, p1_mergetime))/(3600.) as decimal(18,2)) end as P1_WaitHrs,

   case when n<0 then '|_' else '|' end [|],
	case when max(timestamp) is null then null when max(p0_timestamp) is null then '' 
		else format(dateadd(HOUR,max(utc_offset),min(p0_timestamp)),max(time_format)) end P0_OldestDate,
	case when max(timestamp) is null then null when max(p0_timestamp) is null then '' 
		else convert(varchar,count(p0_timestamp)) end P0_Tot,
	case when max(timestamp) is null then null when max(p0_timestamp) is null then '' 
		else convert(varchar,sum(p0_id)) end MachineId,
	case when max(timestamp) is null then null when max(p0_timestamp) is null then '' 
		else convert(varchar,sum(p0_userscan)) end UserScan,
	case when max(timestamp) is null then null when max(p0_timestamp) is null then '' 
		else convert(varchar,sum(p0_errors)) end P0_Err,
	case when n<0 and max(pQ0_timestamp) is null then ''
		 when n<0 then convert(varchar,cast(max(datediff(ss, pQ0_timestamp, GETUTCDATE()))/(3600.) as decimal(18,2))) 
		when max(timestamp) is null then null when max(p0_timestamp) is null then ''
		else convert(varchar,cast(max(datediff(ss, p0_timestamp, p0_mergetime))/(3600.) as decimal(18,2))) end as P0_WaitHrs,
	case when n<0 then '|_' else '|' end [|]

from t2 left join (
    select
	delta = case when LastMergeAttemptUTCTime is null then -1 else 
		datediff(ss, LastMergeAttemptUTCTime, getutcdate())/(time_span*60) end,
	timestamp = BatchTimeStamp,
	pQ_timestamp = case when LastMergeAttemptUTCTime is null then BatchTimeStamp else NULL end,

	pQ0_timestamp = case when LastMergeAttemptUTCTime is null and isAutomatic = 0 then BatchTimeStamp else NULL end,
	pQ1_timestamp = case when LastMergeAttemptUTCTime is null and isAutomatic = 1 then BatchTimeStamp else NULL end,
	p0_timestamp = case when isAutomatic = 0 then BatchTimeStamp else NULL end,
	p1_timestamp = case when isAutomatic = 1 then BatchTimeStamp else NULL end,
	mergetime = LastMergeAttemptUTCTime,
	p0_mergetime = case when isAutomatic = 0 then LastMergeAttemptUTCTime else NULL end,
	p1_mergetime = case when isAutomatic = 1 then LastMergeAttemptUTCTime else NULL end,
	errors = case when (ab.ErrorMessage is null or ab.ErrorMessage = '') then 0 else 1 end,
	p0_errors = case when isAutomatic = 0 and ab.ErrorMessage is not null and ab.ErrorMessage != '' then 1 else 0 end,
	p1_errors = case when isAutomatic = 1 and ab.ErrorMessage is not null and ab.ErrorMessage != '' then 1 else 0 end,

	p0_userscan = case when type = 257 and isSentinelScan = 0 and isAutomatic = 0 then 1 else 0 end,
	p0_id = case when type = 515 and isAutomatic = 0 then 1 else 0 end,

	p1_schedscan = case when type = 257 and isSentinelScan = 0 and isAutomatic = 1 and ScheduleExecutionUTCTime is not null then 1 else 0 end,
	p1_track = case when type = 257 and isSentinelScan = 1 then 1 else 0 end,
	p1_pcscan = case when type = 257 and issentinelscan = 0 and isautomatic=1 and comment = 'First Time Scan Request' then 1 else 0 end,
	p1_modscan = case when type = 257 and issentinelscan = 0 and isautomatic=1 and comment = 'Quick Scan request - New modules found' then 1 else 0 end,
	p1_id = case when type = 515 and isAutomatic = 1 then 1 else 0 end

    from AgentBatches ab
	inner join MachineCommands mc on ab.FK_MachineCommands = mc.PK_MachineCommands
    cross join preferences p1
) as t1 on t2.n = t1.delta
cross join preferences as p2
group by n
order by n