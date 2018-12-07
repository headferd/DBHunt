
--===== RSA-IR-OfficeEXE_over_SMB ========--

--/* DB QUERY 
SELECT mn.MachineName, na.FirstConnectionUTC, na.LastConnectionUTC, pp.path, pn.Filename, sfn.Filename, na.NonRoutable, na.Port, dom.Domain, na.IP, la.LaunchArguments ,na.UserAgent

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
	--na.FirstConnectionUTC >= DATEADD(DAY, -1, GETUTCDATE()) 		-- Time
	--AND na.FirstConnectionUTC <= GETUTCDATE()		AND				-- Filter
	--na.NonRoutable = 0 AND

	pn.FileName IN  ('WINWORD.EXE','EXCEL.EXE','POWERPNT.EXE') AND		-- pn = process name	
	na.port = 445
	
	ORDER BY na.FirstConnectionUTC DESC
--*/


-- IIOC Code --
/*
SELECT DISTINCT
	[mp].[FK_Machines] AS [FK_Machines],
	[mp].[PK_MachineModulePaths] AS [FK_MachineModulePaths],
	[na].[PK_mocNetAddresses] AS [PK_mocNetAddresses]

FROM
	[dbo].[mocNetAddresses] AS [na] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [na].[FK_MachineModulePaths])
	INNER JOIN [dbo].[Filenames] AS [pn] WITH(NOLOCK) ON ([pn].[PK_FileNames] = [na].[FK_FileNames__Process])
	--INNER JOIN [dbo].[Paths] AS [pp] WITH(NOLOCK) ON [pp].[PK_Paths] = [na].[FK_Paths__Process]
	--INNER JOIN [dbo].[Domains] AS [dom]  WITH(NOLOCK) ON ([dom].[PK_Domains] = [na].[FK_Domains__DomainHost])	

WHERE
	na.FirstConnectionUTC >= DATEADD(DAY, -1, GETUTCDATE()) 		-- Time
	AND na.FirstConnectionUTC <= GETUTCDATE()						-- Filter

	AND	pn.FileName IN  ('WINWORD.EXE','EXCEL.EXE','POWERPNT.EXE') 	-- pn = process name	
	AND na.port = 445
	
	*/
