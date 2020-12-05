return {
    override_enabled = true,
    preset = "DST_CAVE",                        -- "SURVIVAL_TOGETHER", "MOD_MISSING", "SURVIVAL_TOGETHER_CLASSIC", "SURVIVAL_DEFAULT_PLUS", "COMPLETE_DARKNESS", "DST_CAVE", "DST_CAVE_PLUS"
    overrides = {
        -- 可选选项（排除拥有提示选项的）："never", "rare", "default", "often", "always"
  
        -- 洞穴世界
        task_set = "cave_default",              -- 创世界生物群落："classic", "default", "cave_default"
        start_location = "default",             -- 创世界出生点："caves", "default", "plus", "darkness"
        world_size = "huge",                    -- 创世界大小："small", "medium", "default", "huge"
        branching = "default",                  -- 创世界分支："never", "least", "default", "most"
        loop = "default",                       -- 创世界循环："never", "default", "always"
        specialevent = "default",               -- 活动："default", "winters_feast", "year_of_the_carrat", ...
        weather = "default",                    -- 雨
        earthquakes = "default",                -- 地震
        regrowth = "default",                   -- 世界再生："veryslow", "slow", "default", "fast", "veryfast"
        touchstone = "default",                 -- 试金石
        boons = "often",                        -- 失败的冒险家
        cavelight = "slow",                     -- 洞穴光照："veryslow", "slow", "default", "fast", "veryfast"
        disease_delay="none",                   -- 疾病："none", "random", "slow", "default", "fast"
        prefabswaps_start = "highly random",    -- 开始资源多样化："classic", "default", "highly random"
  
        -- 洞穴资源
        grass = "default",                      -- 草
        sapling = "default",                    -- 树苗
        marshbush = "default",                  -- 尖灌木
        reeds = "default",                      -- 芦苇
        trees = "default",                      -- 树
        flint = "default",                      -- 燧石
        rock = "default",                       -- 巨石
        mushtree = "default",                   -- 磨菇树
        fern = "default",                       -- 洞穴蕨类
        flower_cave = "often",                  -- 发光花
        wormlights = "often",                   -- 发光浆果
  
        -- 洞穴食物
        berrybush = "default",                  -- 浆果丛
        mushroom = "default",                   -- 蘑菇
        banana = "often",                       -- 洞穴香蕉
        lichen = "default",                     -- 苔藓
  
        -- 洞穴动物
        cave_ponds = "default",                 -- 池塘
        slurper = "default",                    -- 缀食者
        bunnymen = "default",                   -- 兔人
        slurtles = "default",                   -- 蜗牛龟
        rocky = "default",                      -- 石虾
        monkey = "default",                     -- 猴子
  
        -- 洞穴怪物
        cave_spiders = "default",               -- 蜘蛛
        tentacles = "default",                  -- 触手
        chess = "default",                      -- 发条装置
        lureplants = "default",                 -- 食人花
        liefs = "default",                      -- 树精守卫
        bats = "default",                       -- 蝙蝠
        fissure = "rare",                       -- 梦魇裂隙
        wormattacks="rare",                     -- 洞穴蠕虫攻击
        worms = "rare",                         -- 洞穴蠕虫
    },
}
