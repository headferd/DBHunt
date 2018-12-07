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
	--INNER JOIN [dbo].[Modules] AS [mo] WITH(NOLOCK) ON ([mo].[PK_Modules] = [mp].[FK_Modules])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	--INNER JOIN [dbo].[LinkedServers] AS [ls] WITH(NOLOCK) ON [ls].[PK_LinkedServers] = [mn].[FK_LinkedServers] 
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE 

	[se].[EventUTCTime] >= DATEADD(DAY, -3, GETUTCDATE()) 		-- Time
	 AND [se].[EventUTCTime] <= GETUTCDATE()
	 AND	

/*
	[se].[BehaviorProcessCreateProcess] = 1
	AND se.FileName_Target = 'WMIC.exe'
	--AND sfn.FileName = 'WMIC.exe'
	--AND se.LaunchArguments_Target LIKE '%process list%'
	--GROUP BY se.LaunchArguments_Target
	--Order by se.LaunchArguments_Target
*/	



/* 
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName = 'taskeng.exe'
	AND se.FileName_Target = 'cmd.exe'
	GROUP BY se.LaunchArguments_Target
	ORDER by cnt asc
*/	
	
--*/


/* 
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName = 'taskeng.exe'
	AND se.FileName_Target = 'wscript.exe'
	AND se.LaunchArguments_Target NOT LIKE '%SyncAppvPublishing%'
	AND se.LaunchArguments_Target NOT LIKE '%\Batch%'
	AND se.LaunchArguments_Target NOT LIKE '%\EastmanBatchJobs\%'
	AND se.LaunchArguments_Target NOT LIKE '%Eastman chemical Company\%'
	AND se.LaunchArguments_Target NOT LIKE '%\script%'
	AND se.LaunchArguments_Target NOT LIKE '%\TiamoExport%'
	AND se.LaunchArguments_Target NOT LIKE '%\GCIN_%'
	AND se.LaunchArguments_Target NOT LIKE '%\scom\%'
	AND se.LaunchArguments_Target NOT LIKE '%\Program Files%'
	AND se.LaunchArguments_Target NOT LIKE '%\RobocopyStartup%'
	AND se.LaunchArguments_Target NOT LIKE '%\softInst\%'
	ORDER BY se.LaunchArguments_Target
*/

/* 
	[se].[BehaviorFileRenameToExecutable] = 1
	AND [sfn].FileName = 'cmd.exe'
	AND NOT se.Path_Target LIKE '%\product\%'
	AND NOT se.Path_Target LIKE '%\avamar\%'
	AND NOT se.Path_Target LIKE '%\GoFileRoom\%'
	AND NOT se.FileName_Target = 'HPSSFUpdater.exe'
	--GROUP BY sfn.FileName
	--GROUP BY se.FileName_Target
	--ORDER BY cnt ASC
*/


/*
	[se].[BehaviorFileWriteExecutable] = 1
	AND [sfn].FileName = 'wscript.exe'
	AND se.FileName_Target NOT IN ('robocopy.exe', 'BackupUserData.vbs','mpam-fe.exe')
	AND se.Path_Target NOT LIKE 'c:\scripts\backup_uti%'
	AND se.Path_Target NOT LIKE 'd:\scep_definition_exes%'
	--GROUP BY se.FileName_Target
	--ORDER BY cnt ASC
*/

/* Too noisy for IIOC
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName IN ('winword.exe', 'excel.exe', 'powerpnt.exe')
	AND se.FileName_Target = 'cmd.exe'
	ORDER BY se.EventUTCTime DESC
*/

/*
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName IN ('winword.exe', 'excel.exe', 'powerpnt.exe')
	AND se.FileName_Target IN ('cscript.exe','wscript.exe')
	AND se.LaunchArguments_Target NOT LIKE '%Cellulose Coordination Tools%'
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

/* Possible Office Exploit
	[se].[BehaviorProcessCreateRemoteThread] = 1
	AND [sfn].FileName IN ('winword.exe', 'excel.exe', 'powerpnt.exe')
	AND NOT se.FileName_Target = 'csrss.exe'
*/


/*
	[se].[BehaviorFileWriteExecutable] = 1
	AND [sfn].FileName IN ('winword.exe', 'excel.exe', 'powerpnt.exe')
	AND NOT se.FileName_Target LIKE '%.0.vb'
	AND NOT se.FileName_Target LIKE 'SET%.tmp'
	AND NOT se.Path_Target LIKE '%AppData\Local\Assembly\tmp\%'
	AND NOT se.Path_Target LIKE 'c:\programdata\safenet sentinel\%'
	AND NOT se.Path_Target LIKE '%\SogouPY\'

	ORDER BY se.FileName_Target DESC
*/


/*
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName = 'cmd.exe'
	AND se.FileName_Target = 'powershell.exe'
	AND NOT se.LaunchArguments_Target LIKE '%c:\PDFs\%'
	AND NOT se.LaunchArguments_Target LIKE '%c:\BatchJobs\%'
	AND NOT se.LaunchArguments_Target LIKE '%c:\SSISWorking\%'
	AND NOT se.LaunchArguments_Target LIKE '%.ps1%'
	AND NOT se.LaunchArguments_Target LIKE '%\BI Administration%'
	AND NOT se.LaunchArguments_Target LIKE '%\Program Files%'
	AND NOT se.LaunchArguments_Target LIKE '%$ep = get-executionpolicy;%'
	AND NOT se.LaunchArguments_Target = 'powershell'
	--AND NOT se.LaunchArguments_Target LIKE '%%'
	ORDER BY se.LaunchArguments_Target
	--ORDER BY se.EventUTCTime DESC
	--GROUP BY se.LaunchArguments_Target having count(se.LaunchArguments_Target) < 10
	--ORDER BY cnt ASC
	--AND NOT se.LaunchArguments_Target LIKE '%RemoteSigned%set-ex%'
	--AND NOT sla.LaunchArguments LIKE '%OfficeCacheNuke.bat""'
	--ORDER BY se.LaunchArguments_Target
*/


/*
	[se].[BehaviorProcessCreateProcess] = 1
	AND [sfn].FileName = 'powershell.exe'
	AND se.FileName_Target = 'schtasks.exe'
	AND se.LaunchArguments_Target LIKE '%/create%/tn%'
	AND se.LaunchArguments_Target NOT LIKE '%BlockedApps%'
	ORDER BY se.eventutctime DESC
*/



/* Created Scheduled Tasks
	 [se].[BehaviorProcessCreateProcess] = 1 AND 
	 se.FileName_Target = 'schtasks.exe'
	 AND se.LaunchArguments_Target LIKE '%/create%/tn%'
	 AND sfn.FileName NOT IN ('OfficeClicktoRun.exe', 'wsqmcons.exe','integrator.exe', 'msiexec.exe', 'Samsung Portable SSD Daemon.exe', 'MotoHelperservice.exe', 'Teamviewer_.exe')
	 AND NOT se.LaunchArguments_Target LIKE '%/tn "LanDesk Agent Health bootstrap Task%'
	 AND NOT se.LaunchArguments_Target LIKE '%/tn Backup-utility-task%'
	 AND NOT se.LaunchArguments_Target LIKE '%/tn SogouImemgr%'
	 AND NOT se.LaunchArguments_Target LIKE '%BlockedApps%'
	 AND NOT se.LaunchArguments_Target LIKE '%RuiDongUpdateChecking%'
	 AND NOT se.LaunchArguments_Target LIKE '%Amazon Music Helper%'
	 AND NOT se.LaunchArguments_Target LIKE '%\Program Files%'
	 AND NOT se.LaunchArguments_Target LIKE '%\INEBACKUP\%'
	 --ORDER BY se.EventUTCTime DESC
	 ORDER BY se.LaunchArguments_Target
	 --group by sfn.FileName
	 --group by se.LaunchArguments_Target
	 --order by cnt desc

*/


/*
	-- cmd.exe creates executable files
	[se].[BehaviorFileWriteExecutable] = 1
	AND [sfn].FileName = 'cmd.exe'
	AND se.FileName_Target NOT IN ('getadmin.vbs', 'arkUpdate.vbs', 'RedShirtOfficeWizardLaunch.exe', 'vpncerts', 'sed.exe','scinfo.bat','scbypass.exe','emnpasswordprovider.dll','complianceAudit_new.bat')
	AND se.Path_Target NOT LIKE 'c:\Program Files%'
	AND se.Path_Target NOT LIKE '%Documents\SC3000%'
	AND se.FileName_Target NOT LIKE '%-%-%-%'
	AND sla.LaunchArguments NOT LIKE '%/S /D /c" set /p "%'
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
	AND se.FileName_Target LIKE '%.txt.bat'
	ORDER by se.EventUTCTime
*/


/*
	-- Powershell creates vbs
	[se].[BehaviorFileWriteExecutable] = 1
	AND [sfn].FileName = 'powershell.exe'	
	--AND se.FileName_Target LIKE '%.vbs'
	AND NOT se.FileName_Target LIKE '%.ps1'
	AND NOT se.FileName_Target LIKE '%.exe'
	AND NOT se.FileName_Target LIKE '%.dll'
	AND se.Path_Target NOT LIKE '%\psappdeploytoolkit%'
	AND se.Path_Target NOT LIKE '%\grpdata\%'

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
	Group By se.FileName_Target having count(se.FileName_Target) < 10
	order by cnt desc
*/


/* Use frequency analysis to find uncommon files openeing lsass.exe
	[se].[BehaviorProcessOpenOSProcess] = 1
	--[se].[BehaviorProcessCreateRemoteThread] = 1
	--AND sfn.FileName NOT LIKE '%.tmp'
	AND [se].[FileName_Target] = N'LSASS.EXE'
	
	--Group By sfn.Filename having count(sfn.Filename) < 20
	--order by cnt desc
	AND sfn.Filename IN ('powershell.exe','npmonz.exe')
*/


/*Uncommon MSHTA Process activity
	[se].[BehaviorProcessCreateProcess] = 1 and
	sfn.FileName = 'mshta.exe' 
	--se.FileName_Target = 'mshta.exe'
	AND se.LaunchArguments_Target NOT LIKE '%Program Files%HP%'
	AND se.LaunchArguments_Target NOT LIKE '%c:\scripts\%'
	AND se.LaunchArguments_Target NOT LIKE '%ProgramData%HP%'
	AND se.LaunchArguments_Target NOT LIKE '%printui.dll,printuientry%'
	AND se.Path_Target NOT LIKE '%Program Files%HP%'
	AND se.FileName_Target NOT IN ('saplogon.exe','dotnetfx35.exe','dxsetup.exe','msiexec.exe','silverlight.configuration.exe')
	
	
	/* AND (
		se.LaunchArguments_Target LIKE '%javascript%'
		OR se.LaunchArguments_Target LIKE '%ActiveXObject%'
	) */
	ORDER BY [se].[LaunchArguments_Target]
*/



--=======================================================================================

/*
	[se].[BehaviorFileWriteExecutable] = 1
	AND sfn.FileName = 'rundll32.exe'
	AND se.Path_Target LIKE '%\users\%'
	AND se.FileName_Target NOT LIKE '%.com'
	AND se.FileName_Target NOT LIKE 'CorpTax.%'
	AND se.FileName_Target NOT LIKE 'Grammarly.%'
	AND se.FileName_Target NOT LIKE 'SET%.tmp'
	AND se.FileName_Target NOT LIKE 'OLD%.tmp'
	AND se.FileName_Target NOT LIKE 'Microsoft.%.%.dll'
	AND se.FileName_Target NOT LIKE 'System.%.%.dll'
	AND se.Path_Target NOT LIKE '%.tmp-\'
	AND se.Path_Target NOT LIKE '%DD997\'
	AND se.Path_Target NOT LIKE '%\Grammarly\%'
	
	--Group By se.FileName_Target having count(se.FileName_Target) < 5
	ORDER BY 
	--cnt desc
	se.FileName_Target
	--AND [se].[LaunchArguments_Target] LIKE '%http%://%'
*/


/*
	[se].[BehaviorProcessCreateProcess] = 1
	--AND sfn.FileName = 'iexplore.exe'
	AND sfn.FileName = 'chrome.exe' 
	AND se.FileName_Target = 'cmd.exe'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\softinst\%'
	
	
	ORDER BY [se].[LaunchArguments_Target]
*/


/*
	[se].[BehaviorProcessCreateProcess] = 1
	AND sfn.FileName = 'cmd.exe' AND se.FileName_Target = 'wscript.exe'
	AND [se].[LaunchArguments_Target] NOT LIKE '%arkUpdate.vbs%'

	ORDER BY se.EventUTCTime DESC
	
*/


/*
	[se].[BehaviorFileWriteExecutable] = 1
	AND sfn.FileName = 'cmd.exe' AND se.FileName_Target LIKE '%.vbs'
	AND NOT se.FileName_Target = 'arkUpdate.vbs'
	AND NOT se.FileName_Target = 'getadmin.vbs'
	AND se.FileName_Target NOT LIKE  '%-%-%-%.vbs'

	ORDER BY se.FileName_Target
*/



/*
	--Write EXE on system32
	[se].[BehaviorFileWriteExecutable] = 1
	AND NOT (se.FileName_Target LIKE '%.exe'
		OR  se.FileName_Target LIKE '%.dll')
	AND [se].[Path_Target] LIKE 'c:\windows\system32\'
	AND se.LaunchArguments_Target NOT LIKE 'C:\WINDOWS\system32\msiexec.exe /V"'
	ORDER BY se.FileName_Target DESC 
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
	*/
--==============================================================================================--
	

--==============================================================================================--
	/* -- Event Log erasing activity
		[se].[LaunchArguments_Target] LIKE '%call ClearEventlog%'			-- EventLog Cleanup
		OR 
		[se].[LaunchArguments_Target] LIKE '%/node:%'			-- EventLog Cleanup

	*/
--==============================================================================================--
	
	
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
	/* -- Loopback with port on command line
	
		[se].[BehaviorProcessCreateProcess] = 1
		
		AND [se].[LaunchArguments_Target] LIKE '%127.0.0.1:%'

		--- Fileters ---
		--AND [se].[LaunchArguments_Target] NOT LIKE '%ping %'
		AND NOT se.FileName_Target LIKE 'vnc% .exe'
		AND NOT se.FileName_Target = 'CuraEngine.exe'
		AND [se].[LaunchArguments_Target] NOT LIKE '%java%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%http%://127%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%cntrsrv.exe"%'
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
	*/
--==============================================================================================--

--==============================================================================================--
	/* -- Possible recon

		[se].[LaunchArguments_Target] LIKE '%net group “domain%'			-- Domain groups recon
		OR [se].[LaunchArguments_Target] LIKE '%net localgroup%'			-- Local group recon
		OR [se].[LaunchArguments_Target] LIKE '%net user % /domain'		-- Domain user recon
		OR [se].[LaunchArguments_Target] LIKE '%domain /trusted_domains%'  -- Trusted domain recon
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
	--/* --Remote share mounting --
		[se].[BehaviorProcessCreateProcess] = 1 AND
		--[se].[FileName_Target] like 'net.exe' AND
		(
			[se].[LaunchArguments_Target] LIKE '%\c$%' OR
			[se].[LaunchArguments_Target] LIKE '%\admin$%' OR
			[se].[LaunchArguments_Target] LIKE '%\ipc$%'
		)
		ORDER BY se.EventUTCTime desc
	--*/
--==============================================================================================--

/*
ORDER BY
	--[se].[LaunchArguments_Target] DESC
	--sfn.FileName
	se.EventUTCTime DESC
	*/