SELECT	mn.MachineName,
		se.EventUTCTime, 
		sfn.Filename, 
		CASE 
			WHEN se.[BehaviorFileCreateAutorun] = 1 THEN 'Create Autorun'
			WHEN se.[BehaviorFileCreateBrowserExtension] = 1 THEN 'Create Browser Extension' 
			WHEN se.[BehaviorFileDeleteExecutable] = 1 THEN 'Delete Executable' 
			WHEN se.[BehaviorFileReadDocument] = 1 THEN 'Read Document' 
			WHEN se.[BehaviorFileWriteExecutable] = 1 THEN 'Write Executable' 
			WHEN se.[BehaviorFileWriteToPlist] = 1 THEN 'Write To Plist' 
			WHEN se.[BehaviorFileRenameToExecutable] = 1 THEN 'Rename To Executable' 
			WHEN se.[BehaviorFileSelfDeleteExecutable] = 1 THEN 'Self Delete Executable'
			WHEN se.[BehaviorProcessAllocateRemoteMemory] = 1 THEN 'Process Allocate Remote Memory'
			WHEN se.[BehaviorProcessCreateProcess] = 1 THEN 'Create Process'
			WHEN se.[BehaviorProcessCreateRemoteThread] = 1 THEN 'Create Remote Thread' 
			WHEN se.[BehaviorProcessOpenBrowserProcess] = 1 THEN 'Open Browser Process' 
			WHEN se.[BehaviorProcessOpenOSProcess] = 1 THEN 'Open OS Process' 
			WHEN se.[BehaviorProcessOpenProcess] = 1 THEN 'Open Process'
			WHEN se.[BehaviorProcessSetRemoteThreadState] = 1 THEN 'Set Remote Thread State' 
		END AS Event,
		tfn.Filename AS 'TargetFilename', 
		tla.LaunchArguments AS 'TargetLaunchArgs', 
		sla.LaunchArguments AS 'SourceLaunchArgs'

FROM
	[dbo].[mocMacTrackingEvents] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MacMachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MacMachineModulePaths] = [se].[FK_MacMachineModulePaths])
	inner JOIN dbo.MacMachineModulePaths AS tmp WITH (NOLOCK) ON se.FK_MacMachineModulePaths__TargetModule = tmp.PK_MacMachineModulePaths
	INNER JOIN [dbo].[FileNames] AS [tfn] WITH(NOLOCK) ON ([tfn].[PK_FileNames] = [tmp].[FK_FileNames])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines] 
	INNER JOIN [dbo].[LaunchArguments] AS [tla] WITH(NOLOCK) ON [tla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__Target]
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__Source]

WHERE 
	--mn.MachineName = 'MCHIC02TM2QQ'
	--se.BehaviorProcessCreateRemoteThread = 1
	--se.BehaviorFileCreateAutorun = 1
	--se.BehaviorProcessAllocateRemoteMemory = 1
	se.BehaviorProcessOpenOSProcess = 1
order by 
	--se.EventUTCTime desc
	sfn.FileName