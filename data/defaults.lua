_G.ArchiveHelper = {
    Defaults = {
        AvatarVisionCount = {IRON = 0, WOLF = 0, ICE = 0},
        CheckQuestItems = true,
        CountTomes = true,
        EchoingDenTimer = 60,
        FabledCheck = true,
        Favourites = {},
        GwCheck = true,
        GwPlay = true,
        Ignore = {},
        MarauderCheck = true,
        MarauderPlay = true,
        MarkAchievements = true,
        MarkAvatar = true,
        MarkFavourites = true,
        MarkIgnore = false,
        Notify = true,
        NotifyChat = true,
        NotifyScreen = true,
        ShardCheck = true,
        ShardIgnore = true,
        ShowNotice = true,
        ShowSelection = true,
        ShowStacks = true,
        ShowTimer = true
    },
    ArchiveIndex = 2407,
    ArchiveQuests = {GetQuestName(7091), GetQuestName(7101), GetQuestName(7102)},
    CrossingOptions = {
        "1542L36",
        "25143",
        "3R1465L2",
        "35142L6",
        "51423",
        "514236",
        "52L643R1",
        "5R34126"
    },
    FoundQuestItem = false,
    InEchoingDen = false,
    Keys = {},
    Marauders = {"gothmau", "hilkarax", "ulmor"},
    Name = "ArchiveHelper",
    SearchText = {},
    Shards = {},
    Tomeshells = {Solo = 4, Duo = 8},
    COLOURS = {
        BLUE="3a92ff",
        GOLD="ccaa1a",
        GREEN="2dc50e",
        PURPLE="a02ef7"
    },
    DATA_ID = 28, -- map id for libDataShare
    ICONS = {
        ACH = {name = "login/login_icon_yield", colour = {1, 0, 0, 1}},
        FAV = {name = "campaign/overview_indexicon_bonus_down", colour = {0, 1, 0, 1}},
        IRON = {name = "icons/achievement_u40_ed2_iron_atronach", colour = {1, 1, 1, 1}},
        WOLF = {name = "icons/achievement_u40_ed2_werewolf_behemoth", colour = {1, 1, 1, 1}},
        ICE = {name = "icons/achievement_u40_ed2_ice_avatar", colour = {1, 1, 1, 1}},
        AVOID = {name = "castbar/forbiddenaction", colour = {1, 0, 0, 1}}
    },
    LF = string.char(10),
    MAPS = {
        TREACHEROUS_CROSSING = {id = 2420, name = "Treacherous Crossing"},
        HAEFELS_BUTCHERY = {id = 2421, name = "Haefel's Butchery"},
        FILERS_WING = {id = 2422, name = "Filer's Wing"},
        ECHOING_DEN = {id = 2423, name = "Echoing Den"},
        THEATRE_OF_WAR = {id = 2424, name = "Theatre of War"},
        DESTOZUNOS_LIBRARY = {id = 2425, name = "Destozuno's Library"}
    },
    OAKENSOUL = 187658,
    SHARE = {
        TOME = 1,
        MARK = 2,
        UNMARK = 3,
        GW = 4,
        ABILITY = 5
    },
    SKILL_TYPE_PET = 999,
    SORCERER = 2,
    SUPPORT_SKILL_LINE = 71,
    WARDEN = 4
}
