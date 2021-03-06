--Search for a machinename based on the hash of a module
select mn.machinename, mo.HashSHA256
from
    [dbo].[MachineModulePaths] AS mp
    INNER JOIN [dbo].[Machines] AS [mn] WITH(NOLOCK) ON ([mn].[PK_Machines] = [mp].[FK_Machines])
    INNER JOIN [dbo].[Modules] AS [mo] WITH(NOLOCK) ON ([mo].[PK_Modules] = [mp].[FK_Modules])
where
    --mo.HashMD5 = 0xCEDC22719DE1B1316BDC556FED989335
    --mo.HashSHA256 = 0x069F24378A0A6EEA078D30D971542741D0F51E1F933EEEB23FDB559763FF0ACD
    --mo.HashSHA1 = 0x39E0F0F2F64B50FB9783A49B7940BF326D7B6B65
-- First Stage
mo.HashSHA256 = 0x04bed8e35483d50a25ad8cf203e6f157e0f2fe39a762f5fbacd672a3495d6a11
OR mo.HashSHA256 = 0x0564718b3778d91efd7a9972e11852e29f88103a10cb8862c285b924bc412013
OR mo.HashSHA256 = 0x1a4a5123d7b2c534cb3e3168f7032cf9ebf38b9a2a97226d0fdb7933cf6030ff
OR mo.HashSHA256 = 0x276936c38bd8ae2f26aab14abff115ea04f33f262a04609d77b0874965ef7012
OR mo.HashSHA256 = 0x2fe8cfeeb601f779209925f83c6248fb4f3bfb3113ac43a3b2633ec9494dcee0
OR mo.HashSHA256 = 0x3c0bc541ec149e29afb24720abc4916906f6a0fa89a83f5cb23aed8f7f1146c3
OR mo.HashSHA256 = 0x4f8f49e4fc71142036f5788219595308266f06a6a737ac942048b15d8880364a
OR mo.HashSHA256 = 0x7bc0eaf33627b1a9e4ff9f6dd1fa9ca655a98363b69441efd3d4ed503317804d
OR mo.HashSHA256 = 0xa013538e96cd5d71dd5642d7fdce053bb63d3134962e2305f47ce4932a0e54af
OR mo.HashSHA256 = 0xbd1c9d48c3d8a199a33d0b11795ff7346edf9d0305a666caa5323d7f43bdcfe9
OR mo.HashSHA256 = 0xc92acb88d618c55e865ab29caafb991e0a131a676773ef2da71dc03cc6b8953e
OR mo.HashSHA256 = 0xe338c420d9edc219b45a81fe0ccf077ef8d62a4ba8330a327c183e4069954ce1
OR mo.HashSHA256 = 0x36b36ee9515e0a60629d2c722b006b33e543dce1c8c2611053e0651a0bfdb2e9
OR mo.HashSHA256 = 0x6f7840c77f99049d788155c1351e1560b62b8ad18ad0e9adda8218b9f432f0a9
OR mo.HashSHA256 = 0xa3e619cd619ab8e557c7d1c18fc7ea56ec3dfd13889e3a9919345b78336efdb2
OR mo.HashSHA256 = 0x0d4f12f4790d2dfef2d6f3b3be74062aad3214cb619071306e98a813a334d7b8
OR mo.HashSHA256 = 0x9c205ec7da1ff84d5aa0a96a0a77b092239c2bb94bcb05db41680a9a718a01eb
OR mo.HashSHA256 = 0xbea487b2b0370189677850a9d3f41ba308d0dbd2504ced1e8957308c43ae4913
OR mo.HashSHA256 = 0x3a34207ba2368e41c051a9c075465b1966118058f9b8cdedd80c19ef1b5709fe
OR mo.HashSHA256 = 0x19865df98aba6838dcc192fbb85e5e0d705ade04a371f2ac4853460456a02ee3
-- Second Stage
OR mo.HashSHA256 = 0xdc9b5e8aa6ec86db8af0a7aa897ca61db3e5f3d2e0942e319074db1aaccfdc83
OR mo.HashSHA256 = 0xa414815b5898ee1aa67e5b2487a11c11378948fcd3c099198e0f9c6203120b15
OR mo.HashSHA256 = 0x7ac3c87e27b16f85618da876926b3b23151975af569c2c5e4b0ee13619ab2538
OR mo.HashSHA256 = 0x4ae8f4b41dcc5e8e931c432aa603eae3b39e9df36bf71c767edb630406566b17
OR mo.HashSHA256 = 0xb3badc7f2b89fe08fdee9b1ea78b3906c89338ed5f4033f21f7406e60b98709e
OR mo.HashSHA256 = 0xa6c36335e764b5aae0e56a79f5d438ca5c42421cae49672b79dbd111f884ecb5