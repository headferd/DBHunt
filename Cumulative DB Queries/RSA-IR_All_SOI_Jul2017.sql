SELECT  mn.MachineName, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments
--SELECT se.FileName_Target, count(se.FileName_Target) as cnt
--SELECT sfn.FileName, count(sfn.FileName) as cnt
--select se.LaunchArguments_Target, count (*) as cnt
--select sla.LaunchArguments, count (*) as cnt

FROM
	--[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	[dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	--INNER JOIN [dbo].[Modules] AS [mo] WITH(NOLOCK) ON ([mo].[PK_Modules] = [mp].[FK_Modules])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	--INNER JOIN [dbo].[LinkedServers] AS [ls] WITH(NOLOCK) ON [ls].[PK_LinkedServers] = [mn].[FK_LinkedServers] 
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE 
/*
	[se].[EventUTCTime] >= DATEADD(DAY, -3, GETUTCDATE()) 		-- Time
	 AND [se].[EventUTCTime] <= GETUTCDATE()
	 AND	
*/

/*
[se].[BehaviorProcessCreateProcess] = 1 AND
	[se].[FileName_Target] = 'POWERSHELL.EXE' AND
	(
		[se].[LaunchArguments_Target] LIKE '%.DownloadString%' OR
		[se].[LaunchArguments_Target] LIKE '%.DownloadFile%' OR
		[se].[LaunchArguments_Target] LIKE '%.DownloadData%'
	)
	AND [se].[LaunchArguments_Target] NOT LIKE "%.in.gov%'
*/
/* Use frequency analysis to find uncommon files openeing lsass.exe
	[se].[BehaviorProcessOpenOSProcess] = 1
	--[se].[BehaviorProcessCreateRemoteThread] = 1
	--AND sfn.FileName NOT LIKE '%.tmp'
	AND [se].[FileName_Target] = N'LSASS.EXE'
	
	Group By sfn.Filename having count(sfn.Filename) < 20
	order by cnt desc
	--AND sfn.Filename IN ('powershell.exe','npmonz.exe')
*/


/* -- IIOC monitored exe renaming files to exe
	[se].[BehaviorFileRenameToExecutable] = 1
	AND [sfn].FileName IN ('powershell.exe','wscript.exe','cscript.exe')
	AND se.FileName_Target NOT IN ('rpcnet.exe','ServiceMaxx.exe','HPSSFUpdater.exe')
	AND se.FileName_Target NOT IN ('HPSFUpdater.exe','HPResources.exe','Autologon.exe')
	AND se.FileName_Target NOT LIKE 'vcredist%'
	AND se.FileName_Target NOT LIKE 'vmware_____%'
	order by se.FileName_Target
*/


/*
	[se].[BehaviorProcessCreateProcess] = 1
	AND se.FileName_Target = 'WMIC.exe'
	AND sfn.FileName NOT IN ('svchost.exe','jp2launcher.exe','truekey.exe') 
	--AND se.LaunchArguments_Target LIKE '%process list%'
	--GROUP BY se.LaunchArguments_Target
	Order by se.LaunchArguments_Target
*/	



/* 
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName = 'taskeng.exe'
	AND se.FileName_Target = 'cmd.exe'
	AND se.LaunchArguments_Target NOT LIKE '%Oracle_stuff%'
	AND se.LaunchArguments_Target NOT LIKE '%OWB_11g_%'
	AND se.LaunchArguments_Target NOT LIKE '%Program Files%'
	AND se.LaunchArguments_Target NOT LIKE '%Robocopy\%'
	AND se.LaunchArguments_Target NOT LIKE '%RHS MAR%'
	AND se.LaunchArguments_Target NOT LIKE '%DisableIEWarning%'
	ORDER BY se.LaunchArguments_Target
	--GROUP BY se.LaunchArguments_Target
	--ORDER by cnt asc
*/	



/* 
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName = 'taskeng.exe'
	AND se.FileName_Target = 'wscript.exe'
	AND se.LaunchArguments_Target NOT LIKE '%\softInst\%'
	AND se.LaunchArguments_Target NOT LIKE '%\SchdTsks\%'
	ORDER BY se.LaunchArguments_Target
*/



/*
	[se].[BehaviorFileWriteExecutable] = 1
	AND [sfn].FileName = 'wscript.exe'
	AND se.FileName_Target NOT IN ('ssmypics.scr')
	AND se.Path_Target NOT LIKE '%\Daily Activities\%'
	AND se.Path_Target NOT LIKE '%\Interact\%'
	AND se.Path_Target NOT LIKE '%\DeploymentScripts\'
	--AND se.Path_Target NOT LIKE 'd:\scep_definition_exes%'
	--GROUP BY se.FileName_Target
	--ORDER BY cnt ASC
	ORDER BY se.FileName_Target
*/

/* IIOC
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName IN ('winword.exe', 'excel.exe', 'powerpnt.exe')
	AND se.FileName_Target = 'cmd.exe'
	ORDER BY se.EventUTCTime DESC
*/

/*IIOC
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName IN ('winword.exe', 'excel.exe', 'powerpnt.exe')
	AND se.FileName_Target IN ('cscript.exe','wscript.exe')
	--AND se.FileName_Target IN ('schtasks.exe', 'cscript.exe','wscript.exe')
	ORDER BY se.EventUTCTime DESC
 --group by se.FileName_Target
 --group by se.LaunchArguments_Target
 --order by cnt desc
*/


/*
	[se].[BehaviorProcessOpenOSProcess] = 1
	AND [sfn].FileName IN ('winword.exe', 'excel.exe', 'powerpnt.exe')
	AND NOT se.FileName_Target = 'explorer.exe'
*/

/* IIOC - Possible Office Exploit
	[se].[BehaviorProcessCreateRemoteThread] = 1
	AND [sfn].FileName IN ('winword.exe', 'excel.exe', 'powerpnt.exe')
	AND NOT se.FileName_Target = 'csrss.exe'
*/


/* IIOC - RSA_IR-New-OfficeWritesExecutable-RareEvent
	[se].[BehaviorFileWriteExecutable] = 1
	AND [sfn].FileName IN ('winword.exe', 'excel.exe', 'powerpnt.exe')
	AND NOT se.FileName_Target LIKE '%.live.com'
	AND NOT se.Path_Target LIKE '%AppData\Local\Assembly\tmp\%'
	AND NOT se.Path_Target LIKE '%\Bin\JBIPS%'
	
	ORDER BY se.FileName_Target DESC
*/


/* IIOC
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName = 'cmd.exe'
	AND se.FileName_Target = 'powershell.exe'
	AND NOT se.LaunchArguments_Target LIKE '%\shared\%'
	AND NOT se.LaunchArguments_Target LIKE 'powershell'
	AND NOT se.LaunchArguments_Target LIKE '%.in.gov%'
	AND NOT se.LaunchArguments_Target LIKE '%.in.us%'
	AND NOT se.LaunchArguments_Target LIKE '%\Program Files%'
	AND NOT se.LaunchArguments_Target LIKE '%\vmware-system%'
	AND NOT se.LaunchArguments_Target LIKE '%\rvplayer\%'
	AND NOT se.LaunchArguments_Target LIKE '%\Oracle\Operations%'
	AND NOT se.LaunchArguments_Target LIKE '%badge_activate.ps1'
	AND NOT se.LaunchArguments_Target LIKE '%Error Handling Wrapper%'
	AND NOT se.LaunchArguments_Target LIKE '%[D-Z]:\%'
	
	ORDER BY se.eventutctime DESC
*/



/* IIOC Rare Created Scheduled Tasks
	 [se].[BehaviorProcessCreateProcess] = 1  
	 AND se.FileName_Target = 'schtasks.exe'
	 AND sfn.FileName NOT IN ('OfficeClicktoRun.exe', 'wsqmcons.exe','integrator.exe', 'msiexec.exe', 'Teamviewer_.exe','DellClientSystemUpdate.exe','mfesetup.exe')
	 AND se.LaunchArguments_Target LIKE '%/create%/tn%'
	 AND NOT se.LaunchArguments_Target LIKE '%2Pint Software%'
	 AND NOT se.LaunchArguments_Target LIKE '%\Program Files%'
	 AND NOT se.LaunchArguments_Target LIKE '%WsqmUploaderTask%'
	 AND NOT se.LaunchArguments_Target LIKE '%\support\%'
	 AND NOT se.LaunchArguments_Target LIKE '%\TeamViewer\%'
	 AND NOT se.LaunchArguments_Target LIKE '%Amazon Music Helper" /xml%'
	
	 ORDER BY se.EventUTCTime DESC
	 --ORDER BY se.LaunchArguments_Target
	 --group by sfn.FileName
	 --group by se.LaunchArguments_Target
	 --order by cnt desc

*/


/*
	-- IIOC RARE event cmd.exe creates executable files
	[se].[BehaviorFileWriteExecutable] = 1
	AND [sfn].FileName = 'cmd.exe'
	AND NOT se.FileName_Target IN ('adobeconnectaddin.exe','VPNDriveMapping.bat','sdk manager.exe')
	AND se.Path_Target NOT LIKE '%WinmdWorkingFolder\%'
	AND se.Path_Target NOT LIKE '%\bin\%'
	AND se.Path_Target NOT LIKE '%\Spiceworks\%'
	AND se.Path_Target NOT LIKE '%\Program Files%'
	AND se.Path_Target NOT LIKE '%\fssa_qa_testing\%'

	--ORDER BY sla.LaunchArguments
	--ORDER by se.FileName_Target 
	ORDER by se.EventUTCTime 
*/


/*
	--Powershell_Starts_nslookup
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName = 'powershell.exe' 
	AND se.FileName_Target LIKE 'nslookup.exe'
	ORDER by se.EventUTCTime
*/

/*
	-- Powershell with .txt.bat files
	[se].[BehaviorFileRenameToExecutable] = 1
	AND [sfn].FileName = 'powershell.exe'	
	--AND se.FileName_Target LIKE '%.txt.bat'
	ORDER by se.EventUTCTime
*/

/*
	-- IIOC - Powershell creates vbs
	[se].[BehaviorFileWriteExecutable] = 1
	AND [sfn].FileName = 'powershell.exe'
	AND NOT se.FileName_Target LIKE '%.___.ps1'
	AND NOT se.FileName_Target IN ('BITSBCReporter.exe')
	
	ORDER BY se.FileName_Target
*/

/*
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName = 'cmd.exe' 
	AND se.LaunchArguments_Target LIKE '%.0-255'
*/

/*
	([se].[FileName_Target] = 'vssadmin.exe'	OR
	[sfn].[FileName] = 'vssadmin.exe')	AND
	[se].[LaunchArguments_Target] LIKE '%delete%'
*/	


-- Hash dumping
/*
	[se].[BehaviorFileWriteExecutable] = 1
	AND [sfn].[FileName] = N'LSASS.EXE'
	Group By se.FileName_Target having count(se.FileName_Target) < 30
	order by cnt desc
*/




/* IIOC _ Uncommon Source MSHTA Process activity
	[se].[BehaviorProcessCreateProcess] = 1 
	AND sfn.FileName = 'mshta.exe'
	AND se.LaunchArguments_Target NOT LIKE '%HP Officejet%'
	AND se.LaunchArguments_Target NOT LIKE '%\HP\%'
	AND se.LaunchArguments_Target NOT LIKE '%\AddPrinterScript.vbs"'
	AND se.LaunchArguments_Target NOT LIKE '%\installs$\%'
	AND se.LaunchArguments_Target NOT LIKE '"C:\Windows\System32\PING.EXE" 127.0.0.1 -n 2'

	ORDER BY [se].[LaunchArguments_Target]
*/


/* IIOC _ Uncommon Target MSHTA Process activity
	[se].[BehaviorProcessCreateProcess] = 1 
	AND se.FileName_Target = 'mshta.exe'
	AND se.FileName_Target NOT IN ('TeamViewer.exe','PowerInRoads.exe')
	AND se.LaunchArguments_Target NOT LIKE '%\Program Files%'
	AND se.LaunchArguments_Target NOT LIKE '%\setup.log%'
	AND se.LaunchArguments_Target NOT LIKE '%.hta%'
	
	ORDER BY [se].[EventUTCTime] DESC
*/

--=======================================================================================

/* IIOC - Uncommon RunDLL Creates EXE
	[se].[BehaviorFileWriteExecutable] = 1
	AND sfn.FileName = 'rundll32.exe'
	AND NOT (len(se.Path_Target) = 53 AND se.Path_Target LIKE 'c:\windows\temp\%')
	AND NOT (len(se.Path_Target) = 59 AND se.Path_Target LIKE 'c:\windows\temp\%')
	AND NOT (len(se.Path_Target) = 55 AND se.Path_Target LIKE 'c:\windows\temp\%')
	AND se.FileName_Target NOT LIKE 'SET%.tmp'
	AND se.FileName_Target NOT LIKE '%.%.com'
	AND sla.LaunchArguments NOT LIKE '%zzzzInvokeManagedCustomActionOutofProc%'
	AND sla.LaunchArguments NOT LIKE 'rundll32.exe acmigration.dll,ApplyMigrationShims'
	AND sla.LaunchArguments NOT LIKE '%coin99%.dll,RunSoftwareInstall'
	AND sla.LaunchArguments NOT LIKE '%\Program Files%'
	AND sla.LaunchArguments NOT LIKE '%\spool\drivers\%'
	
	ORDER BY sla.LaunchArguments 
	
*/


/* IIOC Uncommon IE behavior
	[se].[BehaviorProcessCreateProcess] = 1
	AND sfn.FileName = 'iexplore.exe'
	AND se.FileName_Target = 'cmd.exe'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\softinst\%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\publish$\%'
	
	ORDER BY [se].[LaunchArguments_Target]
*/

/* IIOC RSA_IR-New-UncommonEvent_CHROME_CreatesCMD
	[se].[BehaviorProcessCreateProcess] = 1
	AND sfn.FileName = 'chrome.exe' 
	AND se.FileName_Target = 'cmd.exe'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\WCChromeNativeMessaging%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%chrome-ext%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\Program Files%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\CiscoWebExstart.exe%'

	ORDER BY [se].[LaunchArguments_Target]
*/


/* IIOC RSA_IR-New-UncommonEvent_Firefox_CreatesCMD
	[se].[BehaviorProcessCreateProcess] = 1
	AND sfn.FileName = 'firefox.exe' 
	AND se.FileName_Target = 'cmd.exe'
	

	ORDER BY [se].[LaunchArguments_Target]
*/


/* IIOC cmd starts wscript
	[se].[BehaviorProcessCreateProcess] = 1
	AND sfn.FileName = 'cmd.exe' AND se.FileName_Target = 'wscript.exe'
	AND [se].[LaunchArguments_Target] NOT LIKE '%spiceworks_upload.vbs%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\netlogon\%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\installs$\%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\Program Files%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%system32\slmgr.vbs"%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%$\Scripts\%'


	ORDER BY [se].[LaunchArguments_Target]
	--ORDER BY se.EventUTCTime DESC
*/


/* IIOC RSA_IR-New-CMD_Creates_VBS
	[se].[BehaviorFileWriteExecutable] = 1
	AND sfn.FileName = 'cmd.exe' 
	AND (
		se.FileName_Target LIKE '%.vbs' OR
		se.FileName_Target LIKE '%.vb' OR
		se.FileName_Target LIKE '%.vbe' OR
		se.FileName_Target LIKE '%.wsh' OR
		se.FileName_Target LIKE '%.wsf' OR
		se.FileName_Target LIKE '%.bat' OR
		se.FileName_Target LIKE '%.cmd' OR
		se.FileName_Target LIKE '%.reg' OR
		se.FileName_Target LIKE '%.js'
		)
	AND se.Path_Target NOT LIKE '%\progra~%' 
	AND se.Path_Target NOT LIKE '%\program %'
	AND se.Path_Target NOT LIKE '%\scripts %'
	AND se.Path_Target NOT LIKE '%\IBM_%'
	AND se.FileName_Target NOT IN ('Sleep2Seconds.vbs', 'spiceworks_upload.vbs', 'VPNDriveMapping.bat')

	ORDER BY se.FileName_Target
*/



/*
	--Write EXE on system32
	[se].[BehaviorFileWriteExecutable] = 1
	AND NOT (se.FileName_Target LIKE '%.exe'
		OR  se.FileName_Target LIKE '%.dll')
	AND se.FileName_Target NOT LIKE 'SET%.tmp'
	AND se.FileName_Target NOT LIKE 'FlashPlayerCPLApp.cpl'
	AND sfn.FileName NOT IN ('op_capture_server.exe', 'igfxCUIService.exe','msiexec.exe')
	AND [se].[Path_Target] LIKE 'c:\windows\system32\'
	
	ORDER BY sfn.FileName DESC 
*/



/*
	[sfn].[FileName] = N'plink.EXE'
	OR  [se].[FileName_Target] = N'plink.EXE'
*/


--Single Character Executables
/*
	[se].[BehaviorFileWriteExecutable] = 1
	AND [se].[FileName_Target] LIKE '_.___'
*/


/*
	[se].[BehaviorProcessCreateProcess] = 1 AND 
	([sfn].[FileName] = N'WINEXESVC.EXE'
	OR  [se].[FileName_Target] = N'WINEXESVC.EXE')
*/


--==============================================================================================--
	/* -- Archive Creation	
	[se].[BehaviorProcessCreateProcess] = 1 AND
		(
		 [se].[LaunchArguments_Target] LIKE '% a % -r%'
		 OR [se].[LaunchArguments_Target] LIKE '% a % -hp%'
		)
		AND [se].[LaunchArguments_Target] NOT LIKE '%\WinRAR\WinRAR.exe"%'
	*/
--==============================================================================================--


--==============================================================================================--
/* -- Suspicious Powershell Commands
	[se].[BehaviorProcessCreateProcess] = 1
	AND 
		([sfn].[FileName] = N'powershell.exe'
		OR [se].[FileName_Target] = N'powershell.exe')
		
		AND
		(
			(
			[se].[LaunchArguments_Target] LIKE '%-w hidden %'		
			OR [se].[LaunchArguments_Target] LIKE '%-nop %'
			OR [se].[LaunchArguments_Target] LIKE '% iex%'
			OR [se].[LaunchArguments_Target] LIKE '% "iex%'
			OR [se].[LaunchArguments_Target] LIKE '%-enc %'
			OR [se].[LaunchArguments_Target] LIKE '%downloadstring%'
			)
			AND
			(
			[se].[LaunchArguments_Target] NOT LIKE '%; if ($ep%' AND
			[se].[LaunchArguments_Target] NOT LIKE '%-Version %' AND
			[se].[LaunchArguments_Target] NOT LIKE '%c:\windows\ccm\s%' AND
			[se].[LaunchArguments_Target] NOT LIKE '%-Poll %'
			)
		)
*/
--==============================================================================================--

--==============================================================================================--
/* -- Service stop
		[se].[BehaviorProcessCreateProcess] = 1
		AND
			( 
				[se].[LaunchArguments_Target] LIKE '%net stop%'	OR
				[se].[LaunchArguments_Target] LIKE '%sc stop%'
			)
		AND se.LaunchArguments_Target NOT LIKE '%abtsvchost'
		AND se.LaunchArguments_Target NOT LIKE '%wctsys%'
		AND se.LaunchArguments_Target NOT LIKE '%SingClientService'
		AND se.LaunchArguments_Target NOT LIKE '% oleup'
		AND se.LaunchArguments_Target NOT LIKE 'net stop "dns%'

		ORDER BY se.LaunchArguments_Target
*/
--==============================================================================================--
	
	

--==============================================================================================--
	/* -- Registry Modifications
		[se].[BehaviorProcessCreateProcess] = 1
		AND
			( 
				[se].[LaunchArguments_Target] LIKE '%reg delete%'			--Delete registry key
				OR [se].[LaunchArguments_Target] LIKE '%reg add%'			-- Add/modify registry key
				OR [se].[LaunchArguments_Target] LIKE '%reg import%'		-- Add/modify registry key
			)
			AND se.LaunchArguments_Target NOT LIKE '%EnableAutoUpgrade%'
			AND se.LaunchArguments_Target NOT LIKE '%bomgar-scc%'

			ORDER BY se.LaunchArguments_Target
	*/
--==============================================================================================--
	

--==============================================================================================--
/* -- Event Log erasing activity
		[se].[BehaviorProcessOpenProcess] = 1
		AND se.FileName_Target = 'wmic.exe'
	--	AND sfn.FileName NOT LIKE 'ruby.exe'
		--AND [se].[LaunchArguments_Target] LIKE '%/node:%'			-- EventLog Cleanup
		AND [se].[LaunchArguments_Target] NOT LIKE '%manufacturer%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%get model%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%EvaluatePassportCert%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%get uuid%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%get serialnumber%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%get hotfixid%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%get locale%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%ParentProcessid%'
		ORDER BY se.LaunchArguments_Target
		
*/
--==============================================================================================--
	--[se].[LaunchArguments_Target] LIKE '%call ClearEventlog%'			-- EventLog Cleanup
	
--==============================================================================================--		
	/* -- Possible Webshell Activity --
		(
			([se].[BehaviorFileWriteExecutable] = 1				-- Event behavior
			AND [se].[FileName_Target] LIKE '%.exe')	
		OR 
			([se].[BehaviorFileRenameToExecutable] = 1)			-- Event Behavior
		OR
			([se].[BehaviorProcessCreateProcess] = 1			-- Event behavior
			AND [se].[FileName_Target]= N'cmd.exe')					-- Target filename
		)
	
		AND ([sfn].[FileName] = N'W3WP.EXE'						-- Source FileName
			OR [sfn].[FileName] LIKE 'COLDFUSION%.EXE'			-- Source FileName
			OR [sfn].[FileName] LIKE 'TOMCAT%.EXE'				-- Source FileName
			OR [sfn].[FileName] LIKE 'PHP.EXE')				-- Source FileName
	
		AND [se].[Path_Target] NOT LIKE '%Microsoft.net%'		-- Target Path
		--AND [sla].[LaunchArguments] NOT LIKE '%\\.\pipe\%'
		--AND [sla].[LaunchArguments] NOT LIKE '%//RS//%'
		--AND [sla].[LaunchArguments] NOT LIKE 'cmd.exe /c ".\install\awk.exe%'
	*/
--==============================================================================================--


--==============================================================================================--
	/* --Suspicious Batch job--
		[se].[FileName_Target] LIKE 'CMD.EXE'
		AND [se].[LaunchArguments_Target] LIKE '"cmd.exe" /s /k pushd %'
	*/
--==============================================================================================--

/*
	[se].[FileName_Target] = 'regsvr32.exe'
	AND [se].[LaunchArguments_Target] LIKE 'regsvr32 %/s%'	
*/	

/*
	[se].[LaunchArguments_Target] LIKE '%\7zipsfx.%'
	OR [se].[LaunchArguments_Target] LIKE '%\rarsfx.%'
*/


--==============================================================================================--
	/* --Interesting commands
		[se].[FileName_Target] = N'whoami.exe'
		--/*	
		OR
		(	[se].[FileName_Target] = N'query.exe'
			AND [se].[LaunchArguments_Target] LIKE 'query %user'		-- query user in command line
		)
		OR
		[se].[LaunchArguments_Target] LIKE '%ping%-n _ 127.0.0.1%'	
		--*/
	*/	
--==============================================================================================--


--==============================================================================================--

/* --port 3389 on command line
	
		[se].[BehaviorProcessCreateProcess] = 1
		AND [se].[LaunchArguments_Target] LIKE '%:3389%'
		AND NOT se.FileName_Target = 'ISServerExec.exe'
*/
--==============================================================================================--

--==============================================================================================--
/* -- IIOC Loopback with port on command line
	
		[se].[BehaviorProcessCreateProcess] = 1
		AND [se].[LaunchArguments_Target] LIKE '%127.0.0.1:%'
		AND NOT se.FileName_Target LIKE 'vnc%.exe'
		AND NOT se.FileName_Target IN ('CuraEngine.exe','nunit-agent.exe','pinentry.exe','DriverSupport.exe')
		AND se.Path_Target NOT LIKE '%\zoc_\'
		AND [se].[LaunchArguments_Target] NOT LIKE '%http%://127%'
				
*/
--==============================================================================================--

--==============================================================================================--
	/* -- Psexec Creates Shell 
		(	
			(
				[se].[BehaviorProcessCreateProcess] = 1
				AND [sfn].[FileName] = N'PSEXESVC.EXE'
				AND [se].[FileName_Target] = N'cmd.exe'
			)
			OR
			(
				[se].[BehaviorFileWriteExecutable] = 1
				AND [se].[FileName_Target] = N'PSEXESVC.EXE'
				AND [sla].[LaunchArguments] LIKE '%\\% cmd% /c %'
			)
		)
		ORDER BY se.EventUTCTime DESC
	*/
--==============================================================================================--

--==============================================================================================--
	/* -- Possible recon
		
		se.FileName_Target IN ('net.exe','net1.exe') 
		AND (
			[se].[LaunchArguments_Target] LIKE '%net group domain%'				-- Domain groups recon
			OR [se].[LaunchArguments_Target] LIKE '%net localgroup%'			-- Local group recon
			OR [se].[LaunchArguments_Target] LIKE '%net user % /domain'			-- Domain user recon
			OR [se].[LaunchArguments_Target] LIKE '%domain /trusted_domains%'	-- Trusted domain recon
			)
	*/
--==============================================================================================--


/* -- Runas command
	[se].[FileName_Target] LIKE 'runas.exe'
*/

--==============================================================================================--
	/* --Possible Mimikatz --
		[se].[BehaviorProcessOpenOSProcess] = 1
		AND [se].[FileName_Target] = N'lsass.exe'
		AND ([sla].[LaunchArguments] LIKE '%::%' OR 
				[se].[launchArguments_Target] LIKE '%::%')
	*/
--==============================================================================================--


--==============================================================================================--
	/* -- Possible Remote Shell 
		[se].[BehaviorProcessCreateProcess] = 1
		AND [sfn].[FileName] = N'CMD.EXE'
		AND [sla].LaunchArguments = N'cmd.exe'
		AND [se].[LaunchArguments_Target] = N'\??\C:\Windows\system32\conhost.exe 0xffffffff'
	*/
--==============================================================================================--


--==============================================================================================--
	/* --Password Dumping WSC--
		[se].[BehaviorProcessCreateProcess] = 1
		AND [se].[LaunchArguments_Target] LIKE '%.exe -u >%'
	*/ --Password Dumping --
--==============================================================================================--


--==============================================================================================--
	/*  --RSA-IR_Supsicious_CMD_Activity --
		[se].[BehaviorProcessCreateProcess] = 1 AND
		[sla].[LaunchArguments] = N'"cmd"' AND
			(	[se].[Path_Target] LIKE '_:\' OR
				[se].[Path_Target] LIKE 'C:\Windows' OR
				[se].[Path_Target] LIKE 'C:\Windows\system32'
			)
	*/
--==============================================================================================--


--==============================================================================================--
	/* --Remote share mounting --
		[se].[BehaviorProcessCreateProcess] = 1 AND
		[se].[FileName_Target] like 'net.exe' AND
		(
			[se].[LaunchArguments_Target] LIKE '%\c$%' OR
			[se].[LaunchArguments_Target] LIKE '%\admin$%' OR
			[se].[LaunchArguments_Target] LIKE '%\ipc$%'
		)
		--AND se.LaunchArguments_Target NOT LIKE '%pw_work'
		--AND se.LaunchArguments_Target NOT LIKE '%\program files'
		--AND se.LaunchArguments_Target NOT LIKE '%\'

		ORDER BY se.EventUTCTime desc
	*/
--==============================================================================================--

/*
ORDER BY
	--[se].[LaunchArguments_Target] DESC
	--sfn.FileName
	se.EventUTCTime DESC
	*/