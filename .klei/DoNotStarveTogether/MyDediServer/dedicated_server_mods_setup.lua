--There are two functions that will install mods, ServerModSetup and ServerModCollectionSetup. Put the calls to the functions in this file and they will be executed on boot.
 
--ServerModSetup takes a string of a specific mod's Workshop id. It will download and install the mod to your mod directory on boot.
    --The Workshop id can be found at the end of the url to the mod's Workshop page.
    --Example: http://steamcommunity.com/sharedfiles/filedetails/?id=350811795
    --ServerModSetup("350811795")
 
--ServerModCollectionSetup takes a string of a specific mod's Workshop id. It will download all the mods in the collection and install them to the mod directory on boot.
    --The Workshop id can be found at the end of the url to the collection's Workshop page.
    --Example: http://steamcommunity.com/sharedfiles/filedetails/?id=379114180
    --ServerModCollectionSetup("379114180")
 



-- mod_id 可从 steam 饥荒社区创意工坊中 mod 的 url 的 id=xxx... 得到。
ServerModSetup("347079953")           -- display food values(显示食物属性)
ServerModSetup("661253977")           -- 灵魂携带物品
ServerModSetup("2078243581")          -- display attack range(显示攻击距离)
ServerModSetup("375850593")           -- extra equio slots(5 装备栏)
ServerModSetup("1207269058")          -- 简易血条
ServerModSetup("374550642")           -- increased stack size(增加堆叠)
ServerModSetup("378160973")           -- global positions(全局共享位置)
ServerModSetup("758532836")           -- global pause(全局暂停)
ServerModSetup("466732225")           -- no thermal stone durability(暖石无耐久)
-- ServerModSetup("462372013")           -- always fresh(冰箱永久保鲜)
-- ServerModSetup("1422039508")          -- gorge crops(农场)
-- ServerModSetup("356930882")           -- infinite tent uses(帐篷无耐久)
-- ServerModSetup("972148976")           -- 双层冰箱(保鲜和永久保鲜)
-- ServerModSetup("501385076")           -- 快速采集
-- ServerModSetup("666155465")           -- show me(显示物品详细信息)
-- ServerModSetup("656256171")           -- slot machine(老虎机)
-- ServerModSetup("623749604")           -- storeroom(地窖)
-- ServerModSetup("346968521")           -- DST in wilson's house(威尔逊小屋)
-- ServerModSetup("356435289")           -- 蜂蜜鱼塘
-- ServerModSetup("1153998909")          -- more armor(更多护甲)
-- ServerModSetup("1079538195")          -- 移动盒子
-- ServerModSetup("797304209")           -- 没有草蜥蜴
-- ServerModSetup("930852872")           -- 自动铺挖地皮
-- ServerModSetup("509723993")           -- wall health regen(墙血量自动恢复)
-- ServerModSetup("404983266")           -- pickle it(泡菜桶)
-- ServerModSetup("873937141")           -- 拉屎
-- ServerModSetup("887567225")           -- 丢屎
-- ServerModSetup("1323923443")          -- 吃屎
-- ServerModSetup("1229419678")          -- 吃屎带全局通告
-- 
-- 
-- ServerModSetup("1402122582")          -- giant size
-- ServerModSetup("1908933602")          -- feast and famine
-- ServerModSetup("925172054")           -- ganja
-- ServerModSetup("898982040")           -- evening flower
-- ServerModSetup("1349799880")          -- basements
-- ServerModSetup("1951468597")          -- Sweet House(甜蜜小屋)
-- ServerModSetup("860400649")           -- A water mod(水 mod)
-- ServerModSetup("908071894")           -- thirst release(水 mod)
-- ServerModSetup("726432903")           -- Multi-Worlds DST
-- ServerModSetup("1938752683")          -- reforged(炼钢)(与其他 mod 不兼容)
-- ServerModSetup("1811475804")          -- Whispering Wisespy
-- ServerModSetup("1392778117")          -- Legion(棱镜)
-- ServerModSetup("1918927570")          -- re-gorge-itated(暴食)
-- ServerModSetup("2039181790")          -- [beta] uncompromising mode(困难模式)
-- ServerModSetup("422321826")           -- the palms(沙漠椰子树)
-- ServerModSetup("861013495")           -- More Fruits(更多水果)
-- ServerModSetup("1085586145")          -- additional item package
-- ServerModSetup("522117250")           -- birds and berries and trees and flowers for friends(生物改变)
-- ServerModSetup("381565292")           -- waiter 101
-- ServerModSetup("519266302")           -- season starting items
-- ServerModSetup("1420569394")          -- Sugarwood Forest Biome
-- ServerModSetup("2140654891")          -- the food pack(outdatad)
-- 
-- 
-- ServerModSetup("1378549454")          -- [API]gem core(API 模块)
-- 
-- 
-- ServerModSetup("1467214795")          -- island adventyres(海难 mod)
-- ServerModSetup("1467200656")          -- island adventures assets(海难 mod 额外内容)
-- 
-- ServerModSetup("1505270912")          -- Tropical Experience | The Volcano Biome(海难 mod)
-- ServerModSetup("1754423272")          -- Tropical Experience Return of Them Complement(海难 mod 额外内容 1)
-- ServerModSetup("1754437018")          -- Tropical Experience Return of Them Complement 2(海难 mod 额外内容 2)
-- 
-- ServerModSetup("1985761462")          -- Creeps in the Deeps Tropical Experience(海底世界依赖 Tropical Experience)
-- ServerModSetup("2085762931")          -- Creeps in the Deeps(海底世界)
-- 
-- ServerModSetup("1615010027")          -- EPIC
-- 
-- ServerModSetup("1289779251")          -- cherry forest(樱桃森林)
-- 
-- 
-- ServerModSetup("1699194522")          -- 神话书说角色
-- ServerModSetup("1991746508")          -- 神话书说
-- 
-- ServerModSetup("1108032281")          -- WhaRang(千年狐)
-- ServerModSetup("949808360")           -- 卡尼猫Carney
