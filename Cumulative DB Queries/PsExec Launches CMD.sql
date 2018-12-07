SELECT  mn.MachineName, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments

FROM
	[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE 
		(
			[se].[BehaviorProcessCreateProcess] = 1
			AND ([sfn].[FileName] = 'PSEXESVC.exe')
			AND ([sla].[LaunchArguments] = 'cmd.exe' OR [se].[LaunchArguments_Target] LIKE '%cmd%')
		)
		OR
		(
			[se].[BehaviorProcessCreateProcess] = 1
			AND ([se].[FileName_Target] = 'PsExec.exe' OR [se].[FileName_Target] = 'PsExec64.exe')
			AND ([sla].[LaunchArguments] LIKE '%cmd%' OR [se].[LaunchArguments_Target] LIKE '%cmd%')
		)
		ORDER BY se.EventUTCTime DESC