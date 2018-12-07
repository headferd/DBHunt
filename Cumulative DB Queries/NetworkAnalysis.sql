SELECT mn.MachineName, na.FirstConnectionUTC, na.LastConnectionUTC, pn.Filename, sfn.Filename, na.Port, dom.Domain, na.IP, na.UserAgent

FROM
	[dbo].[mocNetAddresses] AS [na] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [na].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [na].[FK_Machines]
	INNER JOIN [dbo].[Filenames] AS [pn] WITH(NOLOCK) ON ([pn].[PK_FileNames] = [na].[FK_FileNames__Process])
	INNER JOIN [dbo].[Domains] AS [dom]  WITH(NOLOCK) ON ([dom].[PK_Domains] = [na].[FK_Domains__DomainHost])
		
WHERE
	--[pn].[FileName] LIKE 'powershell.exe'
	[pn].[FileName] LIKE 'wscript.exe'
	--[pn].[FileName] LIKE 'cscript.exe'
	AND mn.MachineName like 'CNU305BJ99-A'

ORDER BY
	mn.MachineName
