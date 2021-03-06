--Sticky Keys Calls Net.exe
SELECT  mn.MachineName, 
		se.EventUTCTime, 
		pa.Path as 'SourcePath', 
		fn.Filename as 'SourceFile', 
		se.Path_Target, 
		se.FileName_Target, 
		se.LaunchArguments_Target, 
		la.LaunchArguments as 'SourceArguments',
		se.Username
FROM
	--[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	[dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	--INNER JOIN [dbo].[Modules] AS [mo] WITH(NOLOCK) ON ([mo].[PK_Modules] = [mp].[FK_Modules])
	INNER JOIN [dbo].[FileNames] AS [fn] WITH(NOLOCK) ON ([fn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	--INNER JOIN [dbo].[LinkedServers] AS [ls] WITH(NOLOCK) ON [ls].[PK_LinkedServers] = [mn].[FK_LinkedServers] 
	INNER JOIN [dbo].[LaunchArguments] AS [la] WITH(NOLOCK) ON [la].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]
    INNER JOIN [dbo].[paths] as [pa] with(NOLOCK) on [mp].[FK_Paths] = [pa].[PK_Paths]


    LEFT JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])

    LEFT JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]
    LEFT JOIN [dbo].[paths] as [spa] with(NOLOCK) on [mp].[FK_Paths] = [spa].[PK_Paths]
WHERE 
		[se].[BehaviorProcessCreateProcess] = 1			-- Event behavior
		AND sfn.filename in ('sethc.exe','osk.exe','utilman.exe')
		AND [se].[FileName_Target]= N'net.exe'
		
UNION

SELECT  mn.MachineName, 
		se.EventUTCTime, 
		pa.Path as 'SourcePath', 
		fn.Filename as 'SourceFile', 
		se.Path_Target, 
		se.FileName_Target, 
		se.LaunchArguments_Target, 
		la.LaunchArguments as 'SourceArguments',
		se.Username
FROM
	--[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	[dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	--INNER JOIN [dbo].[Modules] AS [mo] WITH(NOLOCK) ON ([mo].[PK_Modules] = [mp].[FK_Modules])
	INNER JOIN [dbo].[FileNames] AS [fn] WITH(NOLOCK) ON ([fn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	--INNER JOIN [dbo].[LinkedServers] AS [ls] WITH(NOLOCK) ON [ls].[PK_LinkedServers] = [mn].[FK_LinkedServers] 
	INNER JOIN [dbo].[LaunchArguments] AS [la] WITH(NOLOCK) ON [la].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]
    INNER JOIN [dbo].[paths] as [pa] with(NOLOCK) on [mp].[FK_Paths] = [pa].[PK_Paths]


    LEFT JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])

    LEFT JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]
    LEFT JOIN [dbo].[paths] as [spa] with(NOLOCK) on [mp].[FK_Paths] = [spa].[PK_Paths]
WHERE 
		[se].[BehaviorProcessCreateProcess] = 1			-- Event behavior
		AND sfn.filename in ('sethc.exe','osk.exe','utilman.exe')
		AND [se].[FileName_Target]= N'net.exe'
		
ORDER BY
	se.EventUTCTime DESC