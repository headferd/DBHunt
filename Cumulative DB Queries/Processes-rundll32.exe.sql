--SELECT mn.MachineName, sfn.Filename, mproc.CreateUTCTime, pa2.Path, la.LaunchArguments
SELECT la.LaunchArguments, count(la.launcharguments) AS cnt
FROM
	[dbo].[mocProcesses] AS [mproc] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [mproc].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [mproc].[FK_Machines] 
	INNER JOIN [dbo].LaunchArguments AS [la] WITH(NOLOCK) on [la].PK_LaunchArguments = [mproc].[FK_LaunchArguments]
	INNER JOIN [dbo].[Paths] AS [pa2] WITH(NOLOCK) ON [pa2].[PK_Paths] = [mproc].[FK_Paths__ParentPath]

WHERE
	--sfn.FileName LIKE 'cmd.exe'
	sfn.FileName LIKE 'rundll32.exe'
	AND la.LaunchArguments not like '%,TrayApp'
	AND la.LaunchArguments not like '%HPStatusBL.dll%'
	AND la.LaunchArguments not like '%,PwrMgrBkGndMonitor'
	AND la.LaunchArguments not like '%,SetAndWaitBtMmHook'
	AND la.LaunchArguments not like '%aepdu.dll,AePduRunUpdate%'
	AND la.LaunchArguments not like '%tsworkspace,%'
	AND la.LaunchArguments not like '%MonitorPrintJobStatus%'
	AND la.LaunchArguments not like '%pla.dll,PlaHost%'
	AND la.LaunchArguments not like '%.dll,CheckDevice /pname%'
	AND la.LaunchArguments not like '%Hotkey\hotkey.dll%'
	AND la.LaunchArguments not like '%dxCap%.dll,DX%'
	AND la.LaunchArguments not like '%PhotoAndVideoAcquire%'
	AND la.LaunchArguments not like '%NDFRunDllDuplicateIPDefendingSystem'
	AND la.LaunchArguments not like '%shell32.dll,%'				--?
	group by la.LaunchArguments having count(la.launcharguments) < 10
ORDER BY
	cnt desc
	--la.LaunchArguments