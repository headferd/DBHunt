/* 
Author: 			HB
Created Date:		May 2016
Modified Date:		May 2016
IIOC Type:			Machine
IIOC Level:			3
Notes: 				This IIOC will identify events that are associated with the insertion of removable media. As such it is only meant as informative in nature.
*/

SELECT DISTINCT
	[mp].[FK_Machines] AS [FK_Machines],
	[mp].[PK_MachineModulePaths] AS [FK_MachineModulePaths]
FROM
	[dbo].[WinTrackingEventsCache] AS [se] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [se].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[LaunchArguments] AS [sla] WITH(NOLOCK) ON [sla].[PK_LaunchArguments] = [se].[FK_LaunchArguments__SourceCommandLine]

WHERE
		(
			[se].[BehaviorProcessCreateProcess] = 1	
			AND [sfn].[FileName] = 'rundll32.exe'				-- Source Filename
			AND [se].[FileName_Target] = 'dinotify.exe'
			AND [sla].[LaunchArguments] LIKE 'rundll32.exe C:\WINDOWS\system32\newdev.dll,pDiDeviceInstallNotification%'					
		)
		OR
		(
			[se].[BehaviorProcessOpenOSProcess] = 1	
			AND [sfn].[FileName] = 'drvinst.exe'				-- Source Filename
			AND [se].[FileName_Target] = 'svchost.exe'
			AND [sla].[LaunchArguments] LIKE 'DrvInst.exe%USB\%'					
		)
		