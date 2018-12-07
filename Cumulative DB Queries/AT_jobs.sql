--SELECT mn.MachineName, sfn.Filename, wt.LastRunUTCTime, wt.TaskName, la.LaunchArguments
SELECT wt.TaskName, count(*) as cnt
FROM
	[dbo].[mocWindowsTasks] AS [wt] WITH(NOLOCK)
	INNER JOIN [dbo].[MachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_MachineModulePaths] = [wt].[FK_MachineModulePaths])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON ([mn].[PK_Machines] = [wt].[FK_Machines]) 
	INNER JOIN [dbo].LaunchArguments AS [la] WITH(NOLOCK) on [la].PK_LaunchArguments = [wt].[FK_LaunchArguments]

WHERE
	wt.TaskName NOT LIKE '\{%' AND 
	wt.TaskName NOT LIKE '%}' AND
	wt.TaskName NOT LIKE '%-%-%-%' AND
	wt.TaskName NOT LIKE '%.job' AND
	wt.TaskName NOT LIKE '\Microsoft Office%
	' AND
	wt.TaskName NOT LIKE '\Adobe%' 
GROUP BY wt.TaskName having count(wt.taskname) < 20
ORDER BY 
	--cnt ASC
	wt.TaskName
--WHERE
/*	
	sfn.FileName LIKE '%cmd.exe%' AND
	(la.LaunchArguments LIKE '%c:%' OR
	la.LaunchArguments LIKE '%>%' OR	
	la.LaunchArguments LIKE '%.bat%' OR
	la.LaunchArguments LIKE '%.ps1')
*/
	--wt.taskname LIKE '_At%'		-- All At jobs
	--AND la.LaunchArguments not like '%windows\udi'
	
--ORDER BY
	--wt.LastRunUTCTime DESC