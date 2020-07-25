--There are two functions that will install mods, ServerModSetup and ServerModCollectionSetup. Put the calls to the functions in this file and they will be executed on boot.
 
--ServerModSetup takes a string of a specific mod's Workshop id. It will download and install the mod to your mod directory on boot.
    --The Workshop id can be found at the end of the url to the mod's Workshop page.
    --Example: http://steamcommunity.com/sharedfiles/filedetails/?id=350811795
    --ServerModSetup("350811795")
 
--ServerModCollectionSetup takes a string of a specific mod's Workshop id. It will download all the mods in the collection and install them to the mod directory on boot.
    --The Workshop id can be found at the end of the url to the collection's Workshop page.
    --Example: http://steamcommunity.com/sharedfiles/filedetails/?id=379114180
    --ServerModCollectionSetup("379114180")
 


ServerModSetup("462372013")           -- always fresh
ServerModSetup("347079953")           -- display food values
ServerModSetup("661253977")           -- 灵魂携带物品
ServerModSetup("2078243581")          -- display attack range
ServerModSetup("375850593")           -- extra equio slots
ServerModSetup("2140654891")          -- the food pack(outdatad)
ServerModSetup("758532836")           -- global pause
ServerModSetup("378160973")           -- global positions
ServerModSetup("1422039508")          -- gorge crops
ServerModSetup("375859599")           -- health info
ServerModSetup("374550642")           -- increased stack size
ServerModSetup("356930882")           -- infinite tent uses(帐篷无耐久)
ServerModSetup("972148976")           -- 双层冰箱(保鲜和永久保鲜)
ServerModSetup("466732225")           -- no thermal stone durability(暖石无耐久)
ServerModSetup("501385076")           -- 快速采集
ServerModSetup("666155465")           -- show me(显示详细信息)
ServerModSetup("1207269058")          -- 简易血条
ServerModSetup("656256171")           -- slot machine(老虎机)
ServerModSetup("623749604")           -- storeroom(地窖)
ServerModSetup("356435289")           -- 蜂蜜鱼塘

ServerModSetup("1378549454")          -- [API]gem core

ServerModSetup("1467214795")          -- island adventyres(海难 mod)
ServerModSetup("1467200656")          -- island adventures assets

ServerModSetup("1699194522")          -- 神话书说角色
ServerModSetup("1991746508")          -- 神话书说

ServerModSetup("1108032281")          -- WhaRang(千年狐)
ServerModSetup("949808360")           -- 卡尼猫Carney
