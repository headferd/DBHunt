SELECT  mn.MachineName, mn.operatingsystem, se.EventUTCTime, sfn.Filename, se.FileName_Target, se.Path_Target, se.LaunchArguments_Target, sla.LaunchArguments

FROM
	--[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	[dbo].[WinTrackingEvents_P1] AS [se] WITH(NOLOCK)
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
	
	AND ([sfn].[FileName] IN ('W3WP.EXE','PHP.EXE','HTTPD.exe','APACHE.EXE')	-- Source FileName
		 OR [sfn].[FileName] LIKE 'COLDFUSION%.EXE'			-- Source FileName
		 OR [sfn].[FileName] LIKE 'TOMCAT%.EXE')				-- Source FileName
			
	AND se.Path_Target NOT LIKE '%\ABCGecko\%'
	AND se.LaunchArguments_Target NOT LIKE '%\ImageMagick%'
	AND se.LaunchArguments_Target NOT LIKE '%lsb_release%'
	AND se.LaunchArguments_Target NOT LIKE '%start /B run.bat%'
	AND se.LaunchArguments_Target NOT LIKE '%stty -a |grep%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%lic\license.lic%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%/smartcms/%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%rotatelogs%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\data\tnt\thumbnails\%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%\xampp\%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%infoserv -tu -n%'
	AND [se].[LaunchArguments_Target] NOT LIKE 'cmd.exe '
	AND [se].[LaunchArguments_Target] NOT LIKE 'cmd.exe /c "".\php.exe" -v"'
	AND [se].[LaunchArguments_Target] NOT LIKE '%java%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%/c ds%'
	AND [se].[LaunchArguments_Target] NOT LIKE '%/Sistemas/telematica%'
	AND [se].[LaunchArguments_Target] NOT LIKE 'cmd.exe /c set'
	AND [se].[LaunchArguments_Target] NOT LIKE 'cmd /c vol c:'
	AND [se].[LaunchArguments_Target] NOT LIKE 'cmd /c wmic pagefile list /format:list'
	
	ORDER BY se.EventUTCTime desc