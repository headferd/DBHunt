SELECT  pa.path,mn.MachineName, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments
--select se.LaunchArguments_Target, count (*) as cnt
--select sla.LaunchArguments, count (*) as cnt

FROM
	--[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	[dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	--INNER JOIN [dbo].[Modules] AS [mo] WITH(NOLOCK) ON ([mo].[PK_Modules] = [mp].[FK_Modules])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	--INNER JOIN [dbo].[LinkedServers] AS [ls] WITH(NOLOCK) ON [ls].[PK_LinkedServers] = [mn].[FK_LinkedServers] 
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]
	INNER JOIN [dbo].[Paths] AS [pa] WITH(NOLOCK) ON ([pa].[PK_Paths] = [mp].[FK_Paths])

	WHERE EventUTCTime LIKE '2018%'
	AND se.BehaviorProcessCreateProcess = 1
	AND pa.Path LIKE '%\\[A-Z0-9]%'

	order by EventUTCTime desc