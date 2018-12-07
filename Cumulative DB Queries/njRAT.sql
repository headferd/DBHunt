
SELECT DISTINCT
      [mp].[FK_Machines] AS [FK_Machines],
      [mp].[PK_MachineModulePaths] AS [FK_MachineModulePaths],
      [na].[PK_mocNetAddresses] AS [PK_mocNetAddresses]
FROM
      [dbo].[mocNetAddresses] AS [na] WITH(NOLOCK)
      INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [na].[FK_MachineModulePaths])
      INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [na].[FK_Machines]
WHERE
      na.FirstConnectionUTC >= DATEADD(DAY, -3, GETUTCDATE()) 		-- Time
      AND na.FirstConnectionUTC <= GETUTCDATE()			-- Filter
      AND (UserAgent LIKE '%'+ MachineName + '%' AND LEN(MachineName) > 4
      AND UserAgent NOT LIKE 'ixos ixhttp%' 
      AND UserAgent NOT LIKE 'accclient%'
      AND UserAgent NOT LIKE 'trchosecuri%'
      AND UserAgent NOT LIKE '%esafe%'
      AND UserAgent NOT LIKE '%realshotmanager%' )
      OR UserAgent LIKE '%<|>%'
      OR UserAgent LIKE '%{*}%'