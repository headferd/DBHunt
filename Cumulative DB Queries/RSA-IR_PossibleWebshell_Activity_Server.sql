
--===== RSA-IR_PossibleWebshell_Activity_Server ========--

 ---- DB QUERY ----
SELECT  mn.MachineName, mn.operatingsystem, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments

FROM
	--[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	[dbo].[WinTrackingEvents_P0] AS [se] WITH(NOLOCK)
	--[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	LEFT JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE 
		mn.OperatingSystem LIKE '%Server%' AND
		(
			([se].[BehaviorFileWriteExecutable] = 1				-- Event behavior
			AND [se].[FileName_Target] LIKE '%.exe')	
		OR 
			([se].[BehaviorFileRenameToExecutable] = 1 AND se.FileName_Target NOT LIKE '%.class')			-- Event Behavior
		OR
			(
			[se].[BehaviorProcessCreateProcess] = 1			-- Event behavior
			AND ([se].[FileName_Target] = 'cmd.exe' OR [se].[FileName_Target] = 'powershell.exe')  -- Target filename
			)					
		)
	
		AND ([sfn].[FileName] = 'W3WP.EXE'						-- Source FileName
			OR [sfn].[FileName] LIKE 'COLDFUSION%.EXE'			-- Source FileName
			OR [sfn].[FileName] LIKE 'TOMCAT%.EXE'				-- Source FileName
			OR [sfn].[FileName] LIKE 'PHP.EXE'
			OR [sfn].[FileName] LIKE 'HTTPD.EXE')				-- Source FileName
	
		AND se.Path_Target NOT LIKE '%Microsoft.NET\Framework%'
		AND se.Path_Target NOT LIKE '%\TIBCO\%'
		AND se.Path_Target NOT LIKE '%\assembly\%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%\Birst_Home\%'		
		AND [se].[LaunchArguments_Target] NOT LIKE '%\Phase_II\%'	
		AND [se].[LaunchArguments_Target] NOT LIKE '%ca_sowblackbox%'	
		AND [se].[LaunchArguments_Target] NOT LIKE '%getmac%'
		AND [se].[LaunchArguments_Target] NOT LIKE 'cmd.exe '
		AND [se].[LaunchArguments_Target] NOT LIKE '%rotatelogs%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%wmic process%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%jpctdchkinst%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%jpcinslist%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%\install\awk.exe%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%echo __os__%'
		AND [se].[LaunchArguments_Target] NOT LIKE '"cmd.exe"'
		AND [se].[LaunchArguments_Target] NOT LIKE 'cmd.exe /c set'
		AND [se].[LaunchArguments_Target] NOT LIKE 'cmd /c set'
	ORDER BY se.EventUTCTime desc



/* IIOC QUERY
SELECT DISTINCT
	[mp].[FK_Machines] AS [FK_Machines],
	[mp].[PK_MachineModulePaths] AS [FK_MachineModulePaths],
	[se].[PK_WinTrackingEvents] AS [FK_mocSentinelEvents]

FROM
	[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines]
	
WHERE 
		mn.OperatingSystem LIKE '%Server%' AND
		(
			([se].[BehaviorFileWriteExecutable] = 1				-- Event behavior
			AND [se].[FileName_Target] LIKE '%.exe')	
		OR 
			([se].[BehaviorFileRenameToExecutable] = 1 AND se.FileName_Target NOT LIKE '%.class')			-- Event Behavior
		OR
			(
			[se].[BehaviorProcessCreateProcess] = 1			-- Event behavior
			AND ([se].[FileName_Target] = 'cmd.exe' OR [se].[FileName_Target] = 'powershell.exe')  -- Target filename
			)					
		)
	
		AND ([sfn].[FileName] = 'W3WP.EXE'						-- Source FileName
			OR [sfn].[FileName] LIKE 'COLDFUSION%.EXE'			-- Source FileName
			OR [sfn].[FileName] LIKE 'TOMCAT%.EXE'				-- Source FileName
			OR [sfn].[FileName] LIKE 'PHP.EXE'
			OR [sfn].[FileName] LIKE 'HTTPD.EXE')				-- Source FileName
	
		AND se.Path_Target NOT LIKE '%Microsoft.NET\Framework%'
		AND se.Path_Target NOT LIKE '%\TIBCO\%'
		AND se.Path_Target NOT LIKE '%\assembly\%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%\Birst_Home\%'		
		AND [se].[LaunchArguments_Target] NOT LIKE '%\Phase_II\%'	
		AND [se].[LaunchArguments_Target] NOT LIKE '%ca_sowblackbox%'	
		AND [se].[LaunchArguments_Target] NOT LIKE '%getmac%'
		AND [se].[LaunchArguments_Target] NOT LIKE 'cmd.exe '
		AND [se].[LaunchArguments_Target] NOT LIKE '%rotatelogs%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%wmic process%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%jpctdchkinst%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%jpcinslist%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%\install\awk.exe%'
		AND [se].[LaunchArguments_Target] NOT LIKE '%echo __os__%'
		AND [se].[LaunchArguments_Target] NOT LIKE '"cmd.exe"'
		AND [se].[LaunchArguments_Target] NOT LIKE 'cmd.exe /c set'
		AND [se].[LaunchArguments_Target] NOT LIKE 'cmd /c set'

		*/