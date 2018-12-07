SELECT  mn.MachineName, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments

FROM
	[dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE
-- Possible Recon (Level 1 may require filtering)
	(
	 se.BehaviorProcessCreateProcess = 1 AND
	 (
	  (
	   se.LaunchArguments_Target LIKE '%nltest %' AND mn.machinename not in ('GBAHES1300','GBAHES1','UKAHES1002')) OR -- example: nltest /Trusted_Domains or ntltest /domain_trusts
	   se.LaunchArguments_Target LIKE '% dsquery %' OR -- example: dsquery [computer|user|contact|subnet|group|ou|site]
	   se.LaunchArguments_Target LIKE '%cmdkey% /list%' OR -- example: cmdkey /list
	   se.LaunchArguments_Target LIKE '%dnscmd%' -- example: dnscmd.exe /enumrecords [domain.name]
	  ) 
	  AND sla.LaunchArguments NOT LIKE '%GetADTrusts.cmd'
	  AND sla.LaunchArguments NOT LIKE '%scriptIE.bat%'
	)
 -- Possible recon
	OR	
	(
	 se.FileName_Target IN ('net.exe','net1.exe') 
		AND 
		(
			[se].[LaunchArguments_Target] LIKE '%net group domain%'				-- Domain groups recon
			OR [se].[LaunchArguments_Target] LIKE '%net localgroup%'			-- Local group recon
			OR [se].[LaunchArguments_Target] LIKE '%net user % /domain'			-- Domain user recon
			OR [se].[LaunchArguments_Target] LIKE '%domain /trusted_domains%'	-- Trusted domain recon
		)
		AND se.LaunchArguments_Target NOT LIKE '%/DELETE%'
		AND sla.LaunchArguments NOT LIKE '%dlauncher.usage%'
	)
	OR
	 (
 	   sfn.FileName IN ('cmd.exe','powershell.exe') AND
	   se.LaunchArguments_Target LIKE '%ping%-n%google%'
	 )