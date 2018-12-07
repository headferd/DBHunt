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
	[se].[BehaviorProcessCreateProcess] = 1 AND
	[se].[FileName_Target] NOT IN ('notepad.exe','xcopy.exe','bcompare.exe','liteditw.exe','mspaint.exe','rundll32.exe') AND
	(
		[se].[LaunchArguments_Target] LIKE '%\c$%' OR
		[se].[LaunchArguments_Target] LIKE '%\admin$%' OR
		[se].[LaunchArguments_Target] LIKE '%\ipc$%' OR

		[sla].[LaunchArguments] LIKE '%\c$%' OR
		[sla].[LaunchArguments] LIKE '%\admin$%' OR
		[sla].[LaunchArguments] LIKE '%\ipc$%'
	)
		--AND se.LaunchArguments_Target NOT LIKE '%'
		ORDER BY se.EventUTCTime desc