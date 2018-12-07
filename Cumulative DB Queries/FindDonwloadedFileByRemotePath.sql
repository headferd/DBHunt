SELECT md.utctime, mn.MachineName, rp.path, rfn.filename 

FROM
	[dbo].[MachineDownloaded] AS [md] WITH(NOLOCK)
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [md].[FK_Machines] 
	INNER JOIN [dbo].[Paths] AS [rp] WITH(NOLOCK) ON [rp].[PK_Paths] = [md].[FK_Paths__RemotePath]	
	INNER JOIN [dbo].[FileNames] AS [rfn] WITH(NOLOCK) ON ([rfn].[PK_FileNames] = [md].[FK_FileNames__RemoteFileName])
	
WHERE
	rp.path like 'c:\system~1\'

ORDeR BY
	rfn.FileName
