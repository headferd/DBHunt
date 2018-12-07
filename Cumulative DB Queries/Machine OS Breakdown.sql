SELECT  OperatingSystem, COUNT(*) AS Count
  FROM [ECAT$PRIMARY].[dbo].[Machines]
  WHERE OperatingSystem != ''
  GROUP BY OperatingSystem
  ORDER BY Count DESC
  
  
  
  
  
  
  SELECT OSType, COUNT(*) AS Count  FROM (SELECT  
  CASE        
            WHEN OperatingSystem LIKE '%server%' THEN 'Server'
            ELSE  'Workstation'
  END AS OSType
  FROM [ECAT$PRIMARY].[dbo].[Machines]) as t
  GROUP BY OSType
  ORDER BY Count DESC