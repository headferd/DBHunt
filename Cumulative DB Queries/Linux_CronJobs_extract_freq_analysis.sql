SELECT
	count(REPLACE(CAST(la.LaunchArguments COLLATE SQL_Latin1_General_CP1_CI_AS AS varchar(max)), CHAR(0), ' ')) as cnt,
	un.UserName, lm.Size, fp.Path, fn.FileName, REPLACE(CAST(la.LaunchArguments COLLATE SQL_Latin1_General_CP1_CI_AS AS varchar(max)), CHAR(0), ' ') AS LaunchArguments
	
	
FROM
	dbo.mocLinuxCrons AS wt WITH (NOLOCK) 
	--left outer JOIN [dbo].[Environment] AS [env] WITH(NOLOCK) ON ([env].[PK_Environment] = [lp].[FK_Environment])
	left outer JOIN [dbo].[UserNames] AS [un] WITH(NOLOCK) ON ([un].[PK_UserNames] = [wt].[FK_UserNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON ([mn].[PK_Machines] = [wt].[FK_Machines])
	left outer JOIN [dbo].[LaunchArguments] AS [la] WITH(NOLOCK) ON ([la].PK_LaunchArguments = [wt].[FK_LaunchArguments])
	INNER JOIN dbo.LinuxMachineModulePaths as lmp with(nolock) on (lmp.PK_LinuxMachineModulePaths = wt.FK_LinuxMachineModulePaths)
	INNER JOIN dbo.LinuxModules as lm with(nolock) on (lm.PK_LinuxModules = lmp.FK_LinuxModules)
	INNER JOIN dbo.FileNames as fn with(nolock) on (fn.PK_FileNames = lm.FK_FileNames__ModuleName)
	INNER JOIN dbo.Paths as fp with(nolock) on (fp.PK_Paths = lmp.FK_Paths)

	group by un.username, lm.Size, fp.Path, fn.Filename, LaunchArguments
	order by cnt desc


SELECT
	mn.machineName,
	un.UserName,
	lm.Size,
	fn.FileName,
	fp.Path,
	wt.TriggerString,
	REPLACE(CAST(la.LaunchArguments COLLATE SQL_Latin1_General_CP1_CI_AS AS varchar(max)), CHAR(0), ' ') AS LaunchArguments
	--REPLACE(CAST(env.Environment COLLATE SQL_Latin1_General_CP1_CI_AS AS varchar(max)), CHAR(0), ' ') AS Environment
	
FROM
	dbo.mocLinuxCrons AS wt WITH (NOLOCK) 
	--left outer JOIN [dbo].[Environment] AS [env] WITH(NOLOCK) ON ([env].[PK_Environment] = [lp].[FK_Environment])
	left outer JOIN [dbo].[UserNames] AS [un] WITH(NOLOCK) ON ([un].[PK_UserNames] = [wt].[FK_UserNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON ([mn].[PK_Machines] = [wt].[FK_Machines])
	left outer JOIN [dbo].[LaunchArguments] AS [la] WITH(NOLOCK) ON ([la].PK_LaunchArguments = [wt].[FK_LaunchArguments])
	INNER JOIN dbo.LinuxMachineModulePaths as lmp with(nolock) on (lmp.PK_LinuxMachineModulePaths = wt.FK_LinuxMachineModulePaths)
	INNER JOIN dbo.LinuxModules as lm with(nolock) on (lm.PK_LinuxModules = lmp.FK_LinuxModules)
	INNER JOIN dbo.FileNames as fn with(nolock) on (fn.PK_FileNames = lm.FK_FileNames__ModuleName)
	INNER JOIN dbo.Paths as fp with(nolock) on (fp.PK_Paths = lmp.FK_Paths)