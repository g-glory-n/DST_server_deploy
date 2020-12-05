return {
    override_enabled = true,
    preset = "SURVIVAL_TOGETHER",               -- "SURVIVAL_TOGETHER", "MOD_MISSING", "SURVIVAL_TOGETHER_CLASSIC", "SURVIVAL_DEFAULT_PLUS", "COMPLETE_DARKNESS", "DST_CAVE", "DST_CAVE_PLUS"
    overrides = {
        -- 可选选项（排除拥有提示选项的）："never", "rare", "default", "often", "always"

        -- 森林世界
        task_set = "default",                   -- 创世界生物群落："classic", "default", "cave_default"
        start_location = "default",             -- 创世界出生点："caves", "default", "plus", "darkness"
        world_size = "huge",                    -- 创世界大小："small", "medium", "default", "huge"
        branching = "default",                  -- 创世界分支："never", "least", "default", "most"
        loop = "default",                       -- 创世界循环："never", "default", "always"
        specialevent = "default",               -- 活动："default", "winters_feast", "year_of_the_carrat", ...
        autumn = "verylongseason",              -- 秋："noseason", "veryshortseason", "shortseason", "default", "longseason", "verylongseason", "random"
        winter = "shortseason",                 -- 冬："noseason", "veryshortseason", "shortseason", "default", "longseason", "verylongseason", "random"
        spring = "shortseason",                 -- 春："noseason", "veryshortseason", "shortseason", "default", "longseason", "verylongseason", "random"
        summer = "shortseason",                 -- 夏："noseason", "veryshortseason", "shortseason", "default", "longseason", "verylongseason", "random"
        season_start = "default",               -- 起始季节："default", "winter", "spring", "summer", "autumnorspring", "winterorsummer", "random"
        day = "longday",                        -- 昼夜选项："default", "longday", "longdusk", "longnight", "noday", "nodusk", "nonight", "onlyday", "onlydusk", "onlynight"
        weather = "rare",                       -- 雨
        lightning = "default",                  -- 闪电
        frograin = "rare",                      -- 青蛙雨
        wildfires = "never",                    -- 野火
        regrowth = "default",                   -- 世界再生："veryslow", "slow", "default", "fast", "veryfast"
        touchstone = "default",                 -- 试金石
        disease_delay = "none",                 -- 疾病："none", "random", "slow", "default", "fast"
        boons = "often",                        -- 失败的冒险家
        prefabswaps_start = "highly random",    -- 开始资源多样化："classic", "default", "highly random"
        petrification = "few",                  -- 森林石化："none", "few", "default", "fast", "max"

        -- 森林资源
        flowers = "often",                      -- 花，邪恶花
        grass = "default",                      -- 草
        sapling = "default",                    -- 树苗
        marshbush = "default",                  -- 尖灌木
        tumbleweed = "default",                 -- 风滚草
        reeds = "default",                      -- 芦苇
        trees = "default",                      -- 树
        flint = "default",                      -- 燧石
        rock = "default",                       -- 巨石
        rock_ice = "default",                   -- 迷你冰川
        meteorspawner = "never",                -- 流星区域
        meteorshowers = "never",                -- 流星频率

        -- 森林食物
        berrybush = "default",                  -- 浆果丛
        carrot = "default",                     -- 胡萝卜
        mushroom = "default",                   -- 蘑菇
        cactus = "default",                     -- 仙人掌

        -- 森林动物
        rabbits = "default",                    -- 兔子
        moles = "default",                      -- 鼹鼠
        butterfly = "default",                  -- 蝴蝶
        birds = "default",                      -- 鸟
        buzzard = "default",                    -- 秃鹰
        catcoon = "default",                    -- 浣猫
        perd = "default",                       -- 火鸡
        pigs = "often",                         -- 猪
        lightninggoat = "default",              -- 伏特羊
        beefalo = "default",                    -- 皮弗娄牛
        beefaloheat = "default",                -- 皮弗娄牛交配频率
        hunt = "default",                       -- 狩猎
        alternatehunt = "often",                -- 追猎惊喜
        penguins = "default",                   -- 企鹅
        ponds = "default",                      -- 池塘
        bees = "default",                       -- 蜜蜂
        angrybees = "default",                  -- 杀人蜂
        tallbirds = "default",                  -- 高脚鸟

        -- 森林怪物
        spiders = "default",                    -- 蜘蛛
        hounds = "rare",                        -- 猎犬袭击
        houndmound = "default",                 -- 猎犬丘
        merm = "default",                       -- 渔人
        tentacles = "default",                  -- 触手
        chess = "default",                      -- 发条装置
        lureplants = "default",                 -- 食人花
        walrus = "default",                     -- 海象营地
        liefs = "default",                      -- 树精守卫
        deciduousmonster = "default",           -- 毒桦栗树
        krampus = "often",                      -- 坎普斯
        bearger = "default",                    -- 熊獾
        deerclops = "default",                  -- 独眼巨鹿
        goosemoose = "default",                 -- 麋鹿鹅
        dragonfly = "default",                  -- 龙蝇
        antliontribute="default",               -- 蚁狮贡品
    },
}
