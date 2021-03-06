SELECT mn.MachineName, se.EventUTCTime, sfn.Filename,

CASE 
		WHEN SE.BehaviorFileOpenPhysicalDrive = 1 THEN 'OpenPhysicalDrive'
		WHEN SE.BehaviorFileReadDocument = 1 THEN 'ReadDocument'
		WHEN SE.BehaviorFileRenameToExecutable = 1 OR SE.BehaviorFileWriteExecutable = 1 THEN 'WriteExecutable'
		WHEN SE.BehaviorProcessCreateProcess = 1 THEN 'CreateProcess'
		WHEN SE.BehaviorProcessCreateRemoteThread = 1 THEN 'CreateRemoteThread'
		WHEN SE.BehaviorProcessOpenOSProcess = 1 THEN 'OpenOSProcess'
		WHEN SE.BehaviorProcessOpenProcess = 1 THEN 'OpenProcess'
		WHEN SE.BehaviorFileSelfDeleteExecutable = 1 THEN 'SelfDelete'
		WHEN SE.BehaviorFileDeleteExecutable = 1 THEN 'DeleteExecutable'
		WHEN SE.BehaviorRegistryModifyBadCertificateWarningSetting = 1 THEN 'ModifyBadCertificateWarningSetting'
		WHEN SE.BehaviorRegistryModifyFirewallPolicy = 1 THEN 'ModifyFirewallPolicy'
		WHEN SE.BehaviorRegistryModifyInternetZoneSettings = 1 THEN 'ModifyInternetZoneSettings'
		WHEN SE.BehaviorRegistryModifyIntranetZoneBrowsingNotificationSetting = 1 THEN 'ModifyIntranetZoneBrowsingNotificationSetting'
		WHEN SE.BehaviorRegistryModifyLUASetting = 1 THEN 'ModifyLUASetting'
		WHEN SE.BehaviorRegistryModifyRegistryEditorSetting = 1 THEN 'ModifyRegistryEditorSetting'
		WHEN SE.BehaviorRegistryModifyRunKey = 1 THEN 'ModifyRunKey '
		WHEN SE.BehaviorRegistryModifySecurityCenterConfiguration = 1 THEN 'ModifySecurityCenterConfiguration'
		WHEN SE.BehaviorRegistryModifyServicesImagePath = 1 THEN 'ModifyServicesImagePath'
		WHEN SE.BehaviorRegistryModifyTaskManagerSetting = 1 THEN 'ModifyTaskManagerSetting'
		WHEN SE.BehaviorRegistryModifyWindowsSystemPolicy = 1 THEN 'ModifyWindowsSystemPolicy'
		WHEN SE.BehaviorRegistryModifyZoneCrossingWarningSetting = 1 THEN 'ModifyZoneCrossingWarningSetting'
	END AS Action,
 tfn.Filename, pa2.path, tla.LaunchArguments, sla.LaunchArguments

FROM
	[dbo].[mocSentinelEvents] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [tfn] WITH(NOLOCK) ON ([tfn].[PK_FileNames] = [se].[FK_FileNames__TargetProcessImageFileName])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[Paths] AS [pa2] WITH(NOLOCK) ON [pa2].[PK_Paths] = [se].[FK_Paths__TargetProcessPathName]
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [se].[FK_Machines] 
	--INNER JOIN [dbo].[Modules] AS [mo] WITH(NOLOCK) ON ([mo].[PK_Modules] = [mp].[FK_Modules])
	INNER JOIN [dbo].[LaunchArguments] AS [tla] WITH(NOLOCK) ON [tla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__TargetCommandLine]
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

ORDER by
mn.MachineName