SELECT
	mn.machineName,
	un.UserName,
	REPLACE(CAST(la.LaunchArguments COLLATE SQL_Latin1_General_CP1_CI_AS AS varchar(max)), CHAR(0), ' ') AS LaunchArguments,
	REPLACE(CAST(env.Environment COLLATE SQL_Latin1_General_CP1_CI_AS AS varchar(max)), CHAR(0), ' ') AS Environment
	
FROM
	[dbo].[mocLinuxProcesses] AS [lp] WITH(NOLOCK)
	left outer JOIN [dbo].[Environment] AS [env] WITH(NOLOCK) ON ([env].[PK_Environment] = [lp].[FK_Environment])
	left outer JOIN [dbo].[UserNames] AS [un] WITH(NOLOCK) ON ([un].[PK_UserNames] = [lp].[FK_UserNames])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON ([mn].[PK_Machines] = [lp].[FK_Machines])
	left outer JOIN [dbo].[LaunchArguments] AS [la] WITH(NOLOCK) ON ([la].PK_LaunchArguments = [lp].[FK_LaunchArguments])
where
--	la.LaunchArguments like '%dnscrypt%'	a
mn.MachineName like 'xsj-dvcsdmz01'
