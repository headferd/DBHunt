
SELECT
	mn.machineName,
	lp.CreateUTCTime AS ProcessCreateTime,
	mmp.Suid,
	mmp.FileUTCTimeAccessed,
	mmp.FileUTCTimeAttribModified,
	mmp.FileUTCTimeModified,
	un.UserName,
	REPLACE(CAST(la.LaunchArguments COLLATE SQL_Latin1_General_CP1_CI_AS AS varchar(max)), CHAR(0), ' ') AS LaunchArguments,
	REPLACE(CAST(env.Environment COLLATE SQL_Latin1_General_CP1_CI_AS AS varchar(max)), CHAR(0), ' ') AS Environment
	
	
FROM
	[dbo].[mocLinuxProcesses] AS [lp] WITH(NOLOCK)
	left outer JOIN [dbo].[Environment] AS [env] WITH(NOLOCK) ON ([env].[PK_Environment] = [lp].[FK_Environment])
	left outer JOIN [dbo].[UserNames] AS [un] WITH(NOLOCK) ON ([un].[PK_UserNames] = [lp].[FK_UserNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON ([mn].[PK_Machines] = [lp].[FK_Machines])
	left outer JOIN [dbo].[LaunchArguments] AS [la] WITH(NOLOCK) ON ([la].PK_LaunchArguments = [lp].[FK_LaunchArguments])
	INNER JOIN dbo.LinuxMachineModulePaths as mmp with(nolock) on (mmp.PK_LinuxMachineModulePaths = lp.FK_LinuxMachineModulePaths)
	
WHERE
	mn.MachineName like 'xsjfburton40'
	order by lp.CreateUTCTime