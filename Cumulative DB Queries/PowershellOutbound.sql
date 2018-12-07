SELECT mn.MachineName, na.FirstConnectionUTC, na.LastConnectionUTC, pn.Filename, sfn.Filename, na.Port, dom.Domain, na.IP, la.LaunchArguments ,na.UserAgent
--SELECT dom.Domain, count(dom.Domain) as cnt
--SELECT pn.FileName, count(pn.Filename) as cnt
--SELECT na.UserAgent, count(na.UserAgent) as cnt


FROM
	[dbo].[mocNetAddresses] AS [na] WITH(NOLOCK)

		INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [na].[FK_MachineModulePaths])
		INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
		INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [na].[FK_Machines]
		INNER JOIN [dbo].[Filenames] AS [pn] WITH(NOLOCK) ON ([pn].[PK_FileNames] = [na].[FK_FileNames__Process])
		INNER JOIN [dbo].[Domains] AS [dom]  WITH(NOLOCK) ON ([dom].[PK_Domains] = [na].[FK_Domains__DomainHost])
		INNER JOIN [dbo].[LaunchArguments] AS [la] WITH(NOLOCK) ON [la].[PK_LaunchArguments] = [na].[FK_LaunchArguments]
		
WHERE

	--na.UserAgent like '%torrent%'
/*
	--[pn].[FileName] LIKE 'powershell.exe'
	[pn].[FileName] LIKE 'wscript.exe'
	--[pn].[FileName] LIKE 'wordpad.exe'
	--[pn].[FileName] LIKE 'explorer.exe'

	--dom.domain like '%:%'
		--[pn].[FileName] IN ('wordpad.exe','wmic.exe','wget.exe','u3cffszmrzylujw1etaoy354636138800818950791_1.exe','sffr0cxjtriguzitwafojncm636150127006578873_1.exe','Setup.tmp','scrnsave.scr','php.exe','op.tmp','msupdate.exe','jmp.exe','hqghumeayln.exe','d4vlv2qyywgg343patamjxn1636083287317210551_1.exe','cwbunnav.exe','2lgh21wo4as45w303olzhila636087720525077526_1.exe','2bh4cjcdrtqvoqkugvnbgblh636111194949952390_1.exe')

	AND [na].[IP] NOT LIKE '172.1[6-9].%'
	AND [na].[IP] NOT LIKE '172.2[0-9].%'
	AND [na].[IP] NOT LIKE '172.3[0-1].%'
	
	AND [na].[IP] NOT LIKE '10.%'
	AND [na].[IP] NOT LIKE '192.168%'
	AND [na].[IP] NOT LIKE '127.0.0.1'
	AND [na].[IP] NOT LIKE '169.254.%'
	AND [na].[IP] NOT LIKE '23.4.%'
	AND [na].[IP] NOT LIKE '168.136.%'
	
	AND [dom].[Domain] NOT LIKE '%.microsoft.com'
	AND [dom].[Domain] NOT LIKE '%.windowsupdate.com'
	AND [dom].[Domain] NOT LIKE '%.verisign.com'
	AND [dom].[Domain] NOT LIKE '%.geotrust.com'
	AND [dom].[Domain] NOT LIKE '%.digicert.com'
	AND [dom].[Domain] NOT LIKE '%.emn.com'
	AND [dom].[Domain] NOT LIKE 'emn.com'
	AND [dom].[Domain] NOT LIKE '%.eastman.com'
	AND [dom].[Domain] NOT LIKE '%.turner.com'
	AND [dom].[Domain] NOT LIKE '%.office.com'
	AND [dom].[Domain] NOT LIKE '%.lync.com'
	AND [dom].[Domain] NOT LIKE '%.live.com'
	AND [dom].[Domain] NOT LIKE '%.office365.com'
	AND [dom].[Domain] NOT LIKE 'msftncsi.com'
	AND [dom].[Domain] NOT LIKE '%.scansafe.net'
	AND [dom].[Domain] NOT LIKE '%.wayport.net'
	AND [dom].[Domain] NOT LIKE '%.solutia.com'
*/
	na.FirstConnectionUTC >= DATEADD(DAY, -1, GETUTCDATE()) 			-- Time
	AND na.FirstConnectionUTC <= GETUTCDATE()						-- Filter
	
	AND pn.FileName NOT IN ('YoukuMediaCenter.exe', 'CompatTelRunner.exe','E_YATIJ6E.EXE')
	AND la.LaunchArguments LIKE '%HKCU%'
	--ORDER BY na.FirstConnectionUTC DESC
	--AND dom.domain in ('lawassumewitthe.xyz','licensecanadian.ru','s113113582.onlinehome.us','ufeescircumwodiscl.xyz')

	




	--AND ([dom].[Domain] LIKE '%.%' OR
	--	[dom].[Domain] LIKE '')
	--AND [dom].[Domain] LIKE 'doktrine.fr'
	--AND [na].[IP] = '101.96.10.45'
/*
	AND ( 
			na.UserAgent like '%bitorrent%' OR
			na.UserAgent like '%ie 11.0%' OR
			na.UserAgent like '%87d9003f3f175e566a16d31aa3c2d713%'
		)
*/
--Group BY dom.Domain
--order by dom.domain
--Group BY pn.FileName
--Group BY na.UserAgent --having count(na.UserAgent) < 100
--ORDER BY 
	--cnt DESC
	--na.ip desca
	--dom.domain desc
--mn.MachineName
--na.FirstConnectionUTC DESC
--sfn.FileName
--*/