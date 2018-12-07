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
	(	[se].[BehaviorFileWriteExecutable] = 1 OR
		se.FileName_Target LIKE '%.vbs' OR
		se.FileName_Target LIKE '%.vbe' OR
		se.FileName_Target LIKE '%.wsh' OR
		se.FileName_Target LIKE '%.wsf' OR
		se.FileName_Target LIKE '%.vb' OR
		se.FileName_Target LIKE '%.cmd' OR
		se.FileName_Target LIKE '%.ps1' OR
		se.FileName_Target LIKE '%.bat'
	) AND

	(	se.Path_Target LIKE '%\TfsStore%' OR
		se.Path_Target LIKE '%\Tfs_DAV%'
	)
	
ORDER BY se.LaunchArguments_Target