SELECT md.utctime, mn.MachineName, rp.path, rfn.filename, lp.Path, lfn.FileName
--SELECT mo.HashSHA256, lfn.FileName
FROM
	[dbo].[MachineDownloaded] AS [md] WITH(NOLOCK)
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [md].[FK_Machines] 
	LEFT OUTER JOIN [dbo].[Paths] AS [rp] WITH(NOLOCK) ON [rp].[PK_Paths] = [md].[FK_Paths__RemotePath]	
	LEFT OUTER JOIN [dbo].[FileNames] AS [rfn] WITH(NOLOCK) ON ([rfn].[PK_FileNames] = [md].[FK_FileNames__RemoteFileName])
	LEFT OUTER JOIN [dbo].[Paths] AS [lp] WITH(NOLOCK) ON [lp].[PK_Paths] = [md].[FK_Paths__RelativePath]	
	LEFT OUTER JOIN [dbo].[FileNames] AS [lfn] WITH(NOLOCK) ON ([lfn].[PK_FileNames] = [md].[FK_FileNames__RelativeFileName])
	LEFT OUTER JOIN [dbo].[Modules] AS [mo]  WITH(NOLOCK) ON ([mo].PK_Modules = md.FK_Modules)

Where
	lfn.FileName LIKE '%_b87e%' and 
	rfn.FileName like '$mft'