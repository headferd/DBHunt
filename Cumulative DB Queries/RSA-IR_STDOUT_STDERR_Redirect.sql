-- RSA-IR_STDOUT_STDERR_Redirect --
 
--/* 
SELECT  mn.MachineName, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments
 
FROM
    [dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
    --[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
    INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
    INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
    INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
    INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]
 
WHERE
	se.FileName_Target NOT IN ('sh.exe') AND
	(
		se.LaunchArguments_Target like '%2>&1%' 
		AND se.LaunchArguments_Target NOT LIKE '%\programdata\rsa\%'
		AND se.LaunchArguments_Target NOT LIKE '%\landesk\%' 
		AND se.LaunchArguments_Target NOT LIKE '%\ldprovisioning\%'
		AND se.LaunchArguments_Target NOT LIKE '%splunk%'
		AND se.LaunchArguments_Target NOT LIKE '%\scripts\%'
		AND se.LaunchArguments_Target NOT LIKE '%\ipconfig.out%'
		--sla.LaunchArguments like '% dir %users\%'
	)
	order by se.LaunchArguments_Target
 
--*/


/* IIOC Query
SELECT DISTINCT
    [se].[FK_Machines],
    [se].[FK_MachineModulePaths],
    [se].[PK_WinTrackingEvents] AS [FK_mocSentinelEvents]
FROM
    [dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]
   
     
WHERE
    se.FileName_Target NOT IN ('sh.exe') AND
	(
		se.LaunchArguments_Target like '%2>&1%' 
		AND se.LaunchArguments_Target NOT LIKE '%\programdata\rsa\%'
		AND se.LaunchArguments_Target NOT LIKE '%\landesk\%' 
		AND se.LaunchArguments_Target NOT LIKE '%\ldprovisioning\%'
		AND se.LaunchArguments_Target NOT LIKE '%splunk%'
		AND se.LaunchArguments_Target NOT LIKE '%\scripts\%'
		AND se.LaunchArguments_Target NOT LIKE '%\ipconfig.out%'
	)
	*/