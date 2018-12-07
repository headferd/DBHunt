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
	la.LaunchArguments like '%ssh %-i%' OR
	env.Environment LIKE '%SSH_CONNECTION=%.%.%.% [0-9] %.%.%.% 22%' OR
	env.Environment LIKE '%BROKEN FILENAMES=%'	OR							-- Process with Broken Filenames in process environemnt context 
	la.LaunchArguments like '%smbclient %' OR
	env.Environment LIKE '%ssh_connectio% USER=oracle%'	OR					--Oracle account used for SSH
	la.LaunchArguments LIKE '% //% cmd % -U %'	OR							-- suspicious command
	la.LaunchArguments LIKE '%base64 %'			