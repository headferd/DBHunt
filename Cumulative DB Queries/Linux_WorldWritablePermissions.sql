DECLARE @PERMISSION AS INT = 511
SELECT
	ma.machineName,
	un.UserName,
	ua.UserName AS UserGroup,
	mp.modulemod,
	mo.HashSHA256,
	fn.FileName,
	pa.Path

FROM
	dbo.LinuxMachineModulePaths AS mp WITH (NOLOCK) 
	INNER JOIN dbo.Machines AS ma WITH (NOLOCK) ON mp.FK_Machines = ma.PK_Machines 
	INNER JOIN dbo.LinuxModules AS mo WITH (NOLOCK) ON mp.FK_LinuxModules = mo.PK_LinuxModules 
	LEFT OUTER JOIN dbo.Paths AS pa WITH (NOLOCK) ON pa.PK_Paths = mp.FK_Paths 
	LEFT OUTER JOIN dbo.FileNames AS fn WITH (NOLOCK) ON fn.PK_FileNames = mp.FK_FileNames 
	LEFT OUTER JOIN dbo.UserNames AS un WITH (NOLOCK) ON un.PK_UserNames = mp.FK_UserNames__FileOwner 
	LEFT OUTER JOIN dbo.UserNames AS ua WITH (NOLOCK) ON ua.PK_UserNames = mp.FK_UserNames__FileOwnerGroup 
where
	un.UserName = 'root' and
	--ma.MachineName = 'dcbf3'
	[mp].[ModuleMod] & @PERMISSION = @PERMISSION