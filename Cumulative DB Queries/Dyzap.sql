SELECT  DISTINCT mn.MachineName, UserAgent

FROM
	[dbo].[mocNetAddresses]  AS [na] WITH(NOLOCK)
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [na].[FK_Machines]

WHERE 
UserAgent LIKE '%inferno%'