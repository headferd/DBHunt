SELECT mn.MachineName, fn.Filename, fp.Path 

FROM
	[dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK)
	INNER JOIN [dbo].[FileNames] AS [fn] WITH(NOLOCK) ON ([fn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[Paths] AS [fp] WITH(NOLOCK) ON [fp].[PK_Paths] = [mp].[FK_Paths]
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [mp].[FK_Machines] 

WHERE
	fn.filename like 'cmd.exe'
	--AND fp.Path LIKE '%partofpathname%'