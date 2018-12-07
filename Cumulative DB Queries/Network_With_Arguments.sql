SELECT mn.MachineName, na.FirstConnectionUTC, na.LastConnectionUTC, pp.path, pn.Filename, sfn.Filename, na.NonRoutable, na.Port, dom.Domain, na.IP, la.LaunchArguments ,na.UserAgent
--SELECT dom.Domain, count(dom.Domain) as cnt
--SELECT pp.path, count(*) as cnt
--SELECT pn.FileName, count(*) as cnt
FROM
	[dbo].[mocNetAddresses] AS [na] WITH(NOLOCK)

		INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [na].[FK_MachineModulePaths])
		INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
		INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [na].[FK_Machines]
		INNER JOIN [dbo].[Filenames] AS [pn] WITH(NOLOCK) ON ([pn].[PK_FileNames] = [na].[FK_FileNames__Process])
		INNER JOIN [dbo].[Domains] AS [dom]  WITH(NOLOCK) ON ([dom].[PK_Domains] = [na].[FK_Domains__DomainHost])
		INNER JOIN [dbo].[LaunchArguments] AS [la] WITH(NOLOCK) ON [la].[PK_LaunchArguments] = [na].[FK_LaunchArguments]
		INNER JOIN [dbo].[Paths] AS [pp] WITH(NOLOCK) ON [pp].[PK_Paths] = [na].[FK_Paths__Process]
		
WHERE
	na.NonRoutable = 0
	--AND NOT pn.FileName = 'svchost.exe'
	AND pp.Path LIKE '%windows\temp\'
	AND la.LaunchArguments NOT LIKE ''
	AND pn.FileName NOT LIKE 'Install_______%'
	AND pn.FileName NOT LIKE 'GoogleUpdate.exe_%'
	AND pn.FileName NOT LIKE '%.tmp'
	AND pn.FileName NOT IN ('OfficeClickToRun.exe.bak', 'SecurityScan_Release.exe','SecurePro.exe', 'CreativeCloudSet-Up.exe','ccmsetup.exe')
	ORDER BY pn.filename
	--and pn.FileName IN ('hqghumeayln.exe', 'nw.exe','vs14-kb3165756.exe', 'updater.exe','et.exe','wps.exe')
	--and pn.FileName LIKE '%.tmp'
	--group by pn.FileName
	--order by cnt desc

/*
	na.FirstConnectionUTC >= DATEADD(DAY, -1, GETUTCDATE()) 			-- Time
	AND na.FirstConnectionUTC <= GETUTCDATE()						-- Filter
*/	
	--[pn].[FileName] LIKE 'powershell.exe'
	--[pn].[FileName] LIKE 'wscript.exe'
	--[pn].[FileName] LIKE 'wordpad.exe'
	

	--AND ([pn].[FileName] LIKE '%Floatin%' OR sfn.FileName like '%Floating%')
	
	--AND pn.FileName NOT IN ('YoukuMediaCenter.exe', 'CompatTelRunner.exe','E_YATIJ6E.EXE')
	--AND la.LaunchArguments LIKE '%HKCU%'
	--AND la.LaunchArguments NOT LIKE '"SyncAppv%'
	
	--AND la.LaunchArguments NOT LIKE 'SCODEF%'
	--AND la.LaunchArguments NOT LIKE 'http%'
	--AND la.LaunchArguments NOT LIKE '"http%'
	--AND la.LaunchArguments NOT LIKE '-restart%'
	--AND la.LaunchArguments NOT LIKE '-Embedding%'
	--AND la.LaunchArguments NOT LIKE '-private%'
	--AND la.LaunchArguments NOT LIKE '-newtab'
	--AND la.LaunchArguments NOT LIKE '\\'

	--group by dom.domain
	--order by dom.domain
	--ORDER BY la.LaunchArguments

--ORDER BY na.FirstConnectionUTC DESC
