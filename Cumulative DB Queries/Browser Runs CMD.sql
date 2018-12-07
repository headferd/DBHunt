SELECT  mn.MachineName, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments

FROM
	[dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE 
	[se].[BehaviorProcessCreateProcess] = 1
	AND sfn.FileName IN ('chrome.exe','iexplore.exe','firefox.exe') 
	AND se.FileName_Target = 'cmd.exe'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\WCChromeNativeMessaging%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%chrome-ext%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\Program Files%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\CiscoWebExstart.exe%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\CiscoWebExstart.exe%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%p01pw\%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\rhs\%'

	
	ORDER BY [se].[LaunchArguments_Target]