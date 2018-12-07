SELECT  mn.MachineName, un.username, bh.Command

FROM
	[dbo].[mocLinuxBashHistory] AS [bh] WITH(NOLOCK)
	INNER JOIN [dbo].[UserNames] AS [un] WITH(NOLOCK) ON ([un].[PK_UserNames] = [bh].[FK_UserName])
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON [mn].[PK_Machines] = [bh].[FK_Machines]

WHERE

		bh.Command like '% 3389:%:3389'
		OR bh.Command like '%UserKnownHosts=%/dev/null%'
		OR bh.Command like '%StrictHostKeyChecking=no%'
	OR
	--bh.Command like '%ssh %-i%' OR
	--bh.Command LIKE '%SSH_CONNECTION=%.%.%.% [0-9] %.%.%.% 22%' OR
	--bh.Command LIKE '%BROKEN FILENAMES=%'	OR							-- Process with Broken Filenames in process environemnt context 
	bh.Command like '%smbclient %' OR
	--bh.Command LIKE '%ssh_connectio% USER=oracle%'	OR					--Oracle account used for SSH
	bh.Command LIKE '% //% cmd % -U %'	OR							-- suspicious command
	bh.Command LIKE '%base64 %'										-- Base64 


	
--bh.Command like '%g0ld%kellyb%' OR


	--bh.Command LIKE '% //% cmd % -U %'		-- suspicious command
	--bh.Command LIKE '% //%'		-- suspicious command
	--bh.Command LIKE '%rm %-rf%'		-- bash history
	--bh.Command LIKE '%cmd /c%'
	--bh.Command LIKE '%uuencode%'	
	
	
	--bh.Command LIKE '%tar %'

	ORDER BY 
	bh.Command DESC
		--mn.MachineName