
---===== RSA-IR_cmd_with_escape_character ========--
-- Created: February 2017

 ---- DB QUERY ----
SELECT  mn.MachineName, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments

FROM
	--[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	[dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE	

	[se].[BehaviorProcessCreateProcess] = 1  
	AND sfn.Filename = 'cmd.exe'
	AND se.FileName_Target NOT LIKE 'findstr.exe'
	AND [sla].[LaunchArguments] LIKE '%^%'
	AND [sla].[LaunchArguments] NOT LIKE '%^[$&\<>^|)[]%'
	
ORDER BY se.LaunchArguments_Target




/* IIOC QUERY
SELECT DISTINCT
	[mp].[FK_Machines] AS [FK_Machines],
	[mp].[PK_MachineModulePaths] AS [FK_MachineModulePaths],
	[se].[PK_WinTrackingEvents] AS [FK_mocSentinelEvents]

FROM
	[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE	

	[se].[BehaviorProcessCreateProcess] = 1  
	AND sfn.Filename = 'cmd.exe'
	AND se.FileName_Target NOT LIKE 'findstr.exe'
	AND [sla].[LaunchArguments] LIKE '%^%'
	AND [sla].[LaunchArguments] NOT LIKE '%^[$&\<>^|)[]%'
	
	*/