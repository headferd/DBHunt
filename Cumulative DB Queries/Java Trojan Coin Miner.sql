--SELECT  mn.MachineName, mn.LocalIP, na.FirstConnectionUTC, na.LastConnectionUTC, pp.path, pn.Filename, sfn.Filename, na.Port, dom.Domain, na.IP, la.LaunchArguments ,na.UserAgent, na.ConnectCount, na.TotalSent, na.TotalReceived
SELECT DISTINCT
      [mp].[FK_Machines] AS [FK_Machines],
      [mp].[PK_MachineModulePaths] AS [FK_MachineModulePaths],
      [na].[PK_mocNetAddresses] AS [PK_mocNetAddresses]
FROM
      [dbo].[mocNetAddresses] AS [na] WITH(NOLOCK)

		INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [na].[FK_MachineModulePaths])
--		INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
--		INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [na].[FK_Machines]
		INNER JOIN [dbo].[Filenames] AS [pn] WITH(NOLOCK) ON ([pn].[PK_FileNames] = [na].[FK_FileNames__Process])
--		INNER JOIN [dbo].[Domains] AS [dom]  WITH(NOLOCK) ON ([dom].[PK_Domains] = [na].[FK_Domains__DomainHost])
		INNER JOIN [dbo].[LaunchArguments] AS [la] WITH(NOLOCK) ON [la].[PK_LaunchArguments] = [na].[FK_LaunchArguments]
    	INNER JOIN [dbo].[Paths] AS [pp] WITH(NOLOCK) ON [pp].[PK_Paths] = [na].[FK_Paths__Process]
--        INNER JOIN [dbo].[MachineAdminInfo] AS [MAI] WITH(NOLOCK) ON [mn].[PK_Machines] = [MAI].[FK_Machines]
WHERE
      na.FirstConnectionUTC >= DATEADD(DAY, -3, GETUTCDATE()) 		-- Time
      AND na.FirstConnectionUTC <= GETUTCDATE()			-- Filter
 AND (
		(pn.FileName = 'javaw.exe' AND pp.Path LIKE '%\AppData\%')
		OR
		(pn.FileName = 'vbc.exe' AND LaunchArguments LIKE '%http://%')
	)