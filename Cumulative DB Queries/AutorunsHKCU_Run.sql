Select Path__RegistryPath, count(*) as cnt

from 
	dbo.uvw_mocAutoruns

where 
	
	Path__RegistryPath like 'HKEY_CURRENT_USER\%Version\run %'
	AND Path__RegistryPath NOT LIKE '%GoogleChromeAutoLaunch_%'
	AND Path__RegistryPath NOT LIKE '%Bomgar_Cleanup_%'
	AND Path__RegistryPath NOT LIKE '%@HP %'
	GROUP BY Path__RegistryPath having count(Path__RegistryPath)  < 10

ORDER BY 
	Path__RegistryPath desc
	--cnt asc