   
-- RSA-IR_CommandsOfInterest --




SELECT  mn.MachineName, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments

FROM
	--[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	[dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE

(
	-- Loopback with 3389
	se.LaunchArguments_Target LIKE '%127.0.0.1%3389%' AND
	se.FileName_Target NOT LIKE 'vncserver.exe'
	) OR


	--Remote file traversal
	se.LaunchArguments_Target LIKE '%dir %\\%$%'
	OR

	-- Sensitive Registry keys
	se.LaunchArguments_Target LIKE '%SecurityProviders\WDigest%' 
	OR

	(
	-- Active Directory DB (ntds.dit) -- possible password hash extraction acivity
	(se.LaunchArguments_Target LIKE '%ntds.dit%' AND se.LaunchArguments_Target NOT LIKE '%\Veritas\%')
	)
	OR
	

	(
	-- Process dump of lsass process
	se.LaunchArguments_Target LIKE '%lsass%' AND 
	se.LaunchArguments_Target NOT LIKE '_:\Windows\system32\lsass.exe' AND 
	se.LaunchArguments_Target NOT LIKE '%\Agent\Health Service State\%'
	)
	OR



	-- Possible China Chopper (Level 0)
	se.LaunchArguments_Target LIKE '%echo _S_&cd&echo _E_%'
	OR



	-- Powershell Connecting to Exchange (Level 1)
	se.LaunchArguments_Target LIKE '%Microsoft.Exchange% -ConnectionURI%'




