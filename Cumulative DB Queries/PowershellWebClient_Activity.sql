SELECT mn.MachineName, EventUTCTime, FileUTCTimeCreated, FilenameUTCTimeCreated, sfn.Filename as 'SourceFilename', Path, tfn.FileName as 'TargetFilename', sla.LaunchArguments as 'SourceLaunchArguments', tla.LaunchArguments as 'TargetLaunchArguments'
--SELECT sla.LaunchArguments, count (*) as cnt

FROM
	[dbo].[mocSentinelEvents] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [tfn] WITH(NOLOCK) ON ([tfn].[PK_FileNames] = [se].[FK_FileNames__TargetProcessImageFileName])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[Paths] AS [pa2] WITH(NOLOCK) ON [pa2].[PK_Paths] = [se].[FK_Paths__TargetProcessPathName]
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines] 
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]
	INNER JOIN [dbo].[LaunchArguments] AS [tla] WITH(NOLOCK) ON [tla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__TargetCommandLine]

WHERE	

	[se].[BehaviorProcessCreateProcess] = 1  
	AND sfn.Filename = 'cmd.exe'
	AND tfn.FileName LIKE 'powershell.exe'
	AND ([sla].[LaunchArguments] LIKE '%Webclient%' OR
		[tla].[LaunchArguments] LIKE '%Webclient%')