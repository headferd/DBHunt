SELECT	mn.MachineName,
		mproc.CreateUTCTime AS 'ProcessCreateTime',
		cu.name AS 'UserName',
		procfn.Filename AS 'ProcessName',
		pfn.Filename AS 'ParentFilename',
		pa2.Path AS 'ParentPath',
		--mproc.WindowTitle,
		la.LaunchArguments AS  'CommandArguments'
FROM
	[dbo].[mocProcesses] AS [mproc] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [mproc].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [pfn] WITH(NOLOCK) ON ([pfn].[PK_FileNames] = [mproc].[FK_FileNames__ParentFileName])
	LEFT JOIN [dbo].[CurrentUser] AS [cu] WITH(NOLOCK) ON ([cu].[PK_CurrentUser] = [mproc].[FK_UserNames])
	INNER JOIN [dbo].[FileNames] AS [procfn] WITH(NOLOCK) ON ([procfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [mproc].[FK_Machines] 
	INNER JOIN [dbo].LaunchArguments AS [la] WITH(NOLOCK) on [la].PK_LaunchArguments = [mproc].[FK_LaunchArguments]
	INNER JOIN [dbo].[Paths] AS [pa2] WITH(NOLOCK) ON [pa2].[PK_Paths] = [mproc].[FK_Paths__ParentPath]

WHERE
	procfn.FileName LIKE 'powershell.exe'
	AND NOT (la.LaunchArguments like '' OR la.LaunchArguments like ' ')
	AND pfn.FileName NOT IN ('winpty-agent.exe')
	AND la.LaunchArguments NOT LIKE '%Management.automation.host.size%'
	AND la.LaunchArguments NOT LIKE '%\RemoteExchange.ps1%'
	AND la.LaunchArguments NOT LIKE '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" '
	AND la.LaunchArguments NOT LIKE '%import-module ActiveDirectory%'
	ORDER BY la.LaunchArguments