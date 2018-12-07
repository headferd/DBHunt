--SELECT dom.Domain, count(dom.Domain) as cnt
SELECT pn.FileName, count(pn.Filename) as cnt
--SELECT na.UserAgent, count(na.UserAgent) as cnt
--SELECT na.UserAgent, count(na.IP) as cnt

FROM
	[dbo].[mocNetAddresses] AS [na] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [na].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [na].[FK_Machines]
	INNER JOIN [dbo].[Filenames] AS [pn] WITH(NOLOCK) ON ([pn].[PK_FileNames] = [na].[FK_FileNames__Process])
	INNER JOIN [dbo].[Domains] AS [dom]  WITH(NOLOCK) ON ([dom].[PK_Domains] = [na].[FK_Domains__DomainHost])
		
WHERE
	--[pn].[FileName] LIKE 'powershell.exe'
	--[pn].[FileName] LIKE 'wscript.exe'
	
	[pn].[FileName] IN ('wordpad.exe','wmic.exe','wget.exe','u3cffszmrzylujw1etaoy354636138800818950791_1.exe','sffr0cxjtriguzitwafojncm636150127006578873_1.exe','Setup.tmp','scrnsave.scr','php.exe','op.tmp','msupdate.exe','jmp.exe','hqghumeayln.exe','d4vlv2qyywgg343patamjxn1636083287317210551_1.exe','cwbunnav.exe','2lgh21wo4as45w303olzhila636087720525077526_1.exe','2bh4cjcdrtqvoqkugvnbgblh636111194949952390_1.exe')

	--pn.filename NOT LIKE '%_webex%.exe'

	AND [na].[IP] NOT LIKE '172.1[6-9].%'
	AND [na].[IP] NOT LIKE '172.2[0-9].%'
	AND [na].[IP] NOT LIKE '172.3[0-1].%'
	AND [na].[IP] NOT LIKE '10.%'
	AND [na].[IP] NOT LIKE '192.168%'
	AND [na].[IP] NOT LIKE '127.0.0.1'
	AND [na].[IP] NOT LIKE '169.254.%'
	
	AND [dom].[Domain] NOT LIKE '%.microsoft.com'
	AND [dom].[Domain] NOT LIKE '%.windowsupdate.com'
	AND [dom].[Domain] NOT LIKE '%.verisign.com'
	AND [dom].[Domain] NOT LIKE '%.geotrust.com'
	AND [dom].[Domain] NOT LIKE '%.digicert.com'
	AND [dom].[Domain] NOT LIKE '%.emn.com'
	AND [dom].[Domain] NOT LIKE 'emn.com'
	AND [dom].[Domain] NOT LIKE '%.wayport.net'
	AND [dom].[Domain] NOT LIKE '%.eastman.com'

	/*
	AND ([dom].[Domain] LIKE '%.%' OR
		[dom].[Domain] LIKE '')
	*/

--GROUP BY dom.Domain HAVING count(dom.Domain) < 10
--ORDER BY dom.Domain DESC
	--cnt DESC


--GROUP BY na.IP HAVING count(na.IP) < 10
--ORDER BY na.IP DESC

--GROUP BY na.UserAgent HAVING count(na.UserAgent) < 10
--ORDER BY na.UserAgent DESC

--GROUP BY pn.FileName HAVING count(pn.FileName) < 20
--ORDER BY pn.FileName DESC
