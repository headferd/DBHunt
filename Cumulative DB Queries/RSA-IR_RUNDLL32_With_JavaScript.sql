SELECT DISTINCT
	[mp].[FK_Machines] AS [FK_Machines],
	[mp].[PK_MachineModulePaths] AS [FK_MachineModulePaths]

FROM
	[dbo].[mocSentinelEvents] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [tfn] WITH(NOLOCK) ON ([tfn].[PK_FileNames] = [se].[FK_FileNames__TargetProcessImageFileName])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[LaunchArguments] AS [tla] WITH(NOLOCK) ON [tla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__TargetCommandLine]

WHERE 
	[se].[EventUTCTime] >= DATEADD(DAY, -3, GETUTCDATE()) 		-- Time
	 AND [se].[EventUTCTime] <= GETUTCDATE()						
	AND
	[se].[BehaviorProcessCreateProcess] = 1
	AND (sfn.FileName = 'rundll32.exe' OR
		tfn.FileName = 'rundll32.exe')
	AND tla.LaunchArguments LIKE  'rundll32.exe javascript%'