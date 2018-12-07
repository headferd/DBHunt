
--===== RSA_IR-MAGIC ========--

--/* ---- DB QUERY ----
SELECT  mn.MachineName, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments

FROM
	[dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE 
	-- Powershell Connecting to Exchange (Level 1)
	se.LaunchArguments_Target LIKE '%Microsoft.Exchange% -ConnectionURI%' OR
	
	-- Possible China Chopper (Level 0)
	se.LaunchArguments_Target LIKE '%echo _S_&cd&echo _E_%' OR

	-- Possible Recon (Level 1 may require filtering)
	se.LaunchArguments_Target LIKE '%nltest %' OR -- example: nltest /Trusted_Domains or ntltest /domain_trusts
	se.LaunchArguments_Target LIKE '% dsquery %' OR -- example: dsquery [computer|user|contact|subnet|group|ou|site]
	se.LaunchArguments_Target LIKE '%cmdkey %' OR -- example: cmdkey /list
	se.LaunchArguments_Target LIKE '%dnscmd%' OR -- example: dnscmd.exe /enumrecords [domain.name]
	
	
	-- Process dump of lsass process
	(se.LaunchArguments_Target LIKE '%lsass%' AND se.LaunchArguments_Target NOT LIKE '_:\Windows\system32\lsass.exe') OR
	
	-- Lateral Movement with creds (may require filtering)
	se.LaunchArguments_Target LIKE '%/user:%/password:%' OR
	se.LaunchArguments_Target LIKE '%/u:%/p:%' OR
	se.LaunchArguments_Target LIKE '%net%use%\\% /user:"%' OR
	se.LaunchArguments_Target LIKE '%net%use%\\% /u:"%' OR
	
	
	-- Possible Recon (query user)
	se.LaunchArguments_Target LIKE '%query%user%' OR
	
	-- Powershell Port Scanner
	se.LaunchArguments_Target LIKE '%-ScanOnPingFail%' OR
	se.LaunchArguments_Target LIKE '%PSnmap.ps1 -Comp%' OR
	se.LaunchArguments_Target LIKE '%-Dns%-HideProgress%' OR
	se.LaunchArguments_Target LIKE '%$p2=$null;$p2 = %' OR
	
	
	-- vssadmin usage
	(
		([se].[FileName_Target] = 'vssadmin.exe' OR [sfn].[FileName] = 'vssadmin.exe')
		AND [sfn].[FileName] NOT IN ('cqmghost.exe','ccmexec.exe')
	) OR
	
	
	-- NTDS.DIT reference in command line (hash dumping process)
	se.LaunchArguments_Target LIKE '%ntds.dit%' OR
	sla.LaunchArguments LIKE '%ntds.dit%' OR
	
	-- MakeCab activity
	(
		[se].[BehaviorProcessCreateProcess] = 1 AND
		sfn.Filename like 'cmd.exe' AND 
		se.FileName_Target like 'makecab.exe'
	) OR
	
	-- Possible Recon PING
	(
		[se].[BehaviorProcessCreateProcess] = 1 AND
		(
			se.LaunchArguments_Target LIKE '%ping%-n%1%' OR
			se.LaunchArguments_Target LIKE '%ping%-n%google%'
		)
		AND se.LaunchArguments_Target NOT LIKE '% -f l %'
		AND se.LaunchArguments_Target NOT LIKE '% -w %'	
	) OR

	-- Remote registry activity
	se.LaunchArguments_Target LIKE '%reg%add%\\%' OR
	se.LaunchArguments_Target LIKE '%reg%query%\\%' OR		
	
	-- WMIC remote activity
	se.LaunchArguments_Target LIKE '%/node:%' OR
	
	-- Sensitive Registry keys
	se.LaunchArguments_Target LIKE '%SecurityProviders\WDigest%' OR
	
	--Remote file traversal
	se.LaunchArguments_Target LIKE '%dir %\\%$%' OR

	-- Loopback with 3389
	se.LaunchArguments_Target LIKE '%127.0.0.1%3389%' 

	




