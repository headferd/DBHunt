   
-- RSA-IR_LateralShareMountingWithCreds --

 --DB Query


SELECT  mn.MachineName, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments

FROM
	[dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE
	se.BehaviorProcessCreateProcess = 1 AND
	--se.FileName_Target = 'net.exe' AND
-- Lateral Movement with creds (may require filtering)
	(
		se.LaunchArguments_Target LIKE '%/user:%/password:%' OR
		se.LaunchArguments_Target LIKE '%/u:%/p:%'
	)
	AND
	(
		[se].[LaunchArguments_Target] LIKE '%\c$%' OR
		[se].[LaunchArguments_Target] LIKE '%\admin$%' OR
		[se].[LaunchArguments_Target] LIKE '%\ipc$%'
	)
	AND se.Path_Target NOT LIKE '%netlogon%'
	AND se.Path_Target NOT LIKE '%persistent%'


/*

SELECT DISTINCT
	[se].[FK_Machines],
	[se].[FK_MachineModulePaths],
	[se].[PK_WinTrackingEvents] AS [FK_mocSentinelEvents]
FROM
	[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	--INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	--INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]
WHERE
-- Lateral Movement with creds (may require filtering)
		(
		se.LaunchArguments_Target LIKE '%/user:%/password:%' OR
		se.LaunchArguments_Target LIKE '%/u:%/p:%'
	)
	AND
	(
		[se].[LaunchArguments_Target] LIKE '%\c$%' OR
		[se].[LaunchArguments_Target] LIKE '%\admin$%' OR
		[se].[LaunchArguments_Target] LIKE '%\ipc$%'
	)
	AND se.Path_Target NOT LIKE '%netlogon%'
	AND se.Path_Target NOT LIKE '%persistent%'
*/