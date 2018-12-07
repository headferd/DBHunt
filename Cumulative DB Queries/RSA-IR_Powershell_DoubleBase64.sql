   
-- RSA-IR_Powershell_DoubleBase64 --




SELECT  mn.MachineName, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments

FROM
	[dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE
	(
		se.Filename_Target = 'powershell.exe' OR 
		sfn.Filename = 'powershell.exe'
	)
	AND
	(
		se.LaunchArguments_Target LIKE '%ADYANABTAHQAcgBpAG4AZ%' OR
		se.LaunchArguments_Target LIKE '%ZQA2ADQAUwB0AHIAaQBuA%' OR
		se.LaunchArguments_Target LIKE 'UANgA0AFMAdAByAGkAbgB%' OR
		sla.launchArguments LIKE '%ADYANABTAHQAcgBpAG4AZ%' OR
		sla.launchArguments LIKE '%ZQA2ADQAUwB0AHIAaQBuA%' OR
		sla.launchArguments LIKE '%UANgA0AFMAdAByAGkAbgB%'
	)





/*
SELECT DISTINCT
	[se].[FK_Machines],
	[se].[FK_MachineModulePaths],
	[se].[PK_WinTrackingEvents] AS [FK_mocSentinelEvents]
FROM
	[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]
	
WHERE
	(
		se.Filename_Target = 'powershell.exe' OR 
		sfn.Filename = 'powershell.exe'
	)
	AND
	(
		se.LaunchArguments_Target LIKE '%ADYANABTAHQAcgBpAG4AZ%' OR
		se.LaunchArguments_Target LIKE '%ZQA2ADQAUwB0AHIAaQBuA%' OR
		se.LaunchArguments_Target LIKE 'UANgA0AFMAdAByAGkAbgB%' OR
		sla.launchArguments LIKE '%ADYANABTAHQAcgBpAG4AZ%' OR
		sla.launchArguments LIKE '%ZQA2ADQAUwB0AHIAaQBuA%' OR
		sla.launchArguments LIKE '%UANgA0AFMAdAByAGkAbgB%'
	)
	*/