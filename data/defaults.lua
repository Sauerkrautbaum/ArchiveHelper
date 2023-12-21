_G.ArchiveHelper = {
    Defaults = {
        EchoingDenTimer = 60,
        Favourites = {},
        MarkAchievements = true,
        MarkAvatar = true,
        MarkFavourites = true,
        Notify = true,
        NotifyChat = true,
        NotifyScreen = true,
        ShowNotice = true,
        ShowStacks = true,
        ShowTimer = true
    },
    Name = "ArchiveHelper",
    LF = string.char(10),
    ICONS = {
        ACH = {name = "login/login_icon_yield", colour = {1, 0, 0, 1}},
        FAV = {name = "campaign/overview_indexicon_bonus_down", colour = {0, 1, 0, 1}},
        IRON = {name = "icons/achievement_u40_ed2_iron_atronach", colour = {1, 1, 1, 1}},
        WOLF = {name = "icons/achievement_u40_ed2_werewolf_behemoth", colour = {1, 1, 1, 1}},
        ICE = {name = "icons/achievement_u40_ed2_ice_avatar", colour = {1, 1, 1, 1}}
    },
    MAPS = {
        HAEFELS_BUTCHERY = {id = 2421, name = "Haefel's Butchery"},
        FILERS_WING = {id = 2422, name = "Filer's Wing"},
        ECHOING_DEN = {id = 2423, name = "Echoing Den"},
        THEATRE_OF_WAR = {id = 2424, name = "Theatre of War"},
        DESTOZUNOS_LIBRARY={id=2425,name="Destozuno's Library"},
        --THE_PATH={id=0,name=""}
    },
    InEchoingDen = false
}
