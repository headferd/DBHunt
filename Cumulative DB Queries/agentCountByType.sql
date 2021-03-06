--Agent Count
--select count(distinct machinename) as 'Agent Count'
--FROM dbo.Machines as mn
--where mn.MarkedAsDeleted = 0

-- Agent Classification by type
SELECT OSName, OSType, COUNT(*) AS Count  FROM (SELECT  
  CASE        
            WHEN OperatingSystem LIKE N'%server%' AND FK_OSTypes = 1 AND MarkedAsDeleted = 0 THEN 'Server'
            WHEN FK_OSTypes = 1 AND MarkedAsDeleted = 0 THEN 'Workstation'
            WHEN MarkedAsDeleted = 1 THEN 'Deleted'
            ELSE  'Other'
  END AS OSType, OSName
  FROM [ECAT$PRIMARY].[dbo].[Machines] as mn
  INNER  JOIN [ECAT$PRIMARY].[dbo].[OSTypes] as os ON mn.FK_OSTypes = os.PK_OSTypes) as t
  GROUP BY OSType, OSName
  ORDER BY Count DESC
/*
  --Agent Count by OS
  SELECT  OperatingSystem, COUNT(*) AS Count
  FROM [ECAT$PRIMARY].[dbo].[Machines] as mn
  WHERE mn.OperatingSystem != '' and mn.MarkedAsDeleted = 0
  GROUP BY OperatingSystem
  ORDER BY Count DESC

  -- Machine Counts by Admin Status
SELECT ad.Description as AdminStatus, COUNT(ad.Description) AS Count 
from dbo.uvw_Machines as ma
INNER JOIN [dbo].[AdminStatus] AS [ad] WITH(NOLOCK) ON [ad].[PK_Adminstatus] = [ma].[FK_AdminStatus]
group by ad.Description

/*
--Machine Info with AdminStatus Detail
select ma.MachineName
  ,ad.Description as AdminStatus
  ,ma.Comment
from dbo.uvw_Machines as ma
INNER JOIN [dbo].[AdminStatus] AS [ad] WITH(NOLOCK) ON [ad].[PK_Adminstatus] = [ma].[FK_AdminStatus]
*/


--Black/Grey ModuleStatus Count
select 
      CASE 
        WHEN [bs].BiasStatus = -2 THEN 'Blacklisted'
        WHEN [bs].BiasStatus = 0 THEN 'Neutral'
        WHEN [bs].BiasStatus = 1 THEN 'Graylisted'
        WHEN [bs].BiasStatus = 2 THEN 'Whitelisted'
    END As ModuleStatus
    ,COUNT(bs.BiasStatus) AS Count 

  FROM [dbo].[Modules] as [mo] WITH(NOLOCK)
  INNER JOIN [dbo].[ModuleStatistics] AS [mp] WITH(NOLOCK) ON ([mp].[FK_Modules] = [mo].[PK_Modules])
  INNER JOIN [dbo].[ModuleIOC] AS [mi] WITH(NOLOCK) ON ([mi].[FK_Modules] = [mo].[PK_Modules])
  INNER JOIN [dbo].[ModuleBiasStatus] AS [bs] WITH(NOLOCK) ON ([bs].[FK_Modules] = [mo].[PK_Modules])

  where bs.BiasStatus = -2 OR bs.BiasStatus = 1
  group by bs.BiasStatus

/*
  --All ModuleStatus Count
select 
      CASE 
        WHEN [bs].BiasStatus = -2 THEN 'Blacklisted'
        WHEN [bs].BiasStatus = 0 THEN 'Neutral'
        WHEN [bs].BiasStatus = 1 THEN 'Graylisted'
        WHEN [bs].BiasStatus = 2 THEN 'Whitelisted'
    END As ModuleStatus
    ,COUNT(bs.BiasStatus) AS Count 

  FROM [dbo].[Modules] as [mo] WITH(NOLOCK)
  INNER JOIN [dbo].[ModuleStatistics] AS [mp] WITH(NOLOCK) ON ([mp].[FK_Modules] = [mo].[PK_Modules])
  INNER JOIN [dbo].[ModuleIOC] AS [mi] WITH(NOLOCK) ON ([mi].[FK_Modules] = [mo].[PK_Modules])
  INNER JOIN [dbo].[ModuleBiasStatus] AS [bs] WITH(NOLOCK) ON ([bs].[FK_Modules] = [mo].[PK_Modules])

  group by bs.BiasStatus
*/

--Module Status Detail
/*
SELECT [mo].HashMD5 
      ,CASE 
        WHEN [bs].BiasStatus = -2 THEN 'Blacklisted'
        WHEN [bs].BiasStatus = 0 THEN 'Neutral'
        WHEN [bs].BiasStatus = 1 THEN 'Graylisted'
        WHEN [bs].BiasStatus = 2 THEN 'Whitelisted'
      END AS Status
      , '' AS VTResultRatio
      , '' AS VTResult
      , '' AS VTScanDate
      , '' AS VTResultPositives
      , '' AS VTResultTotal
      , [mp].GlobalMachineCount 
      , substring((
          SELECT TOP 5 '|'+[mn].MachineName AS [text()]
          FROM  [ECAT$PRIMARY].[dbo].[Machines] AS [mn] WITH(NOLOCK) 
          INNER JOIN  [ECAT$PRIMARY].[dbo].[MachinesModules] AS [mm] WITH(NOLOCK) ON ([mn].[PK_Machines] = [mm].[FK_Machines])
          WHERE ([mm].[FK_Modules] = [mo].[PK_Modules]) 
          For XML PATH ('')
          ), 2, 1000) [Machines]
--      ,[mo].HashSHA256

      ,'"'+[mp].RemotePath+'"' As RemotePath
      ,'"'+[mp].RemoteFileName+'"' As RemoteFilename

  FROM [dbo].[Modules] as [mo] WITH(NOLOCK)
  INNER JOIN [dbo].[ModuleStatistics] AS [mp] WITH(NOLOCK) ON ([mp].[FK_Modules] = [mo].[PK_Modules])
  INNER JOIN [dbo].[ModuleIOC] AS [mi] WITH(NOLOCK) ON ([mi].[FK_Modules] = [mo].[PK_Modules])
  INNER JOIN [dbo].[ModuleBiasStatus] AS [bs] WITH(NOLOCK) ON ([bs].[FK_Modules] = [mo].[PK_Modules])

  WHERE ([mi].IOCLevel1 > 0 OR [mi].IOCLevel0 > 0) AND 
        ([mo].ModuleTypeEXE = 1 OR [mo].ModuleTypeDLL =1) AND
        mp.DownloadedUTCTime IS NOT NULL AND
        mp.GlobalMachineCount < 20 AND
        [mo].PK_Modules > 0 
  ORDER BY [mo].PK_Modules DESC
*/

/*
select BiasStatus, BiasStatusComment, size, RemotePath, RemoteFileName, description, BlacklistCategory, IIOCScore, AnalyticsScore, GlobalMachineCount from uvw_Modules
where BiasStatuscomment <> ''
*/
*/