local AH = _G.ArchiveHelper

AH.LAM = _G.LibAddonMenu2

local panel = {
    type = "panel",
    name = "Archive Helper",
    displayName = zo_iconFormat("/esoui/art/icons/poi/poi_endlessdungeon_complete.dds") .. "|cff9900Archive Helper|r",
    author = "Flat Badger",
    version = "1.0.8",
    registerForRefresh = true
}
local favouriteChoices = {}
local favouriteChoiceValues = {}

local function doSort(tin, tout1, tout2)
    table.sort(
        tin,
        function(a, b)
            return a.name < b.name
        end
    )

    for _, choice in ipairs(tin) do
        table.insert(tout1, choice.name)
        table.insert(tout2, choice.id)
    end
end

do
    local tmpTable = {}

    for abilityId, _ in pairs(AH.ABILITIES) do
        table.insert(tmpTable, {id = abilityId, name = GetAbilityName(abilityId)})
    end

    doSort(tmpTable, favouriteChoices, favouriteChoiceValues)
end

local removeChoices = {}
local removeChoiceValues = {}

local function populateRemovableOptions(doNotFill)
    local choices = AH.Vars.Favourites

    if (#choices == 0) then
        return {}
    end

    local tmpTable = {}

    for _, choice in ipairs(choices) do
        local name = GetAbilityName(choice)
        local icon = GetAbilityIcon(choice)

        table.insert(tmpTable, {id = choice, name = name, icon = icon})
    end

    if (not doNotFill) then
        doSort(tmpTable, removeChoices, removeChoiceValues)
    end

    return tmpTable
end

local function getFavourites()
    local removed = populateRemovableOptions(true)
    local text = ""

    if (#removed > 0) then
        table.sort(
            removed,
            function(a, b)
                return a.name < b.name
            end
        )

        for _, ability in ipairs(removed) do
            text = text .. zo_iconFormat(ability.icon, 24, 24)
            text = text .. " " .. ability.name .. AH.LF
        end
    end

    return text
end

local function updateFavourites()
    _G.ARCHIVE_HELPER_FAVOURITES_LIST.data.text = getFavourites()
    _G.ARCHIVE_HELPER_FAVOURITES_LIST:UpdateValue()
end

local function getSecondsOptions()
    local seconds = {}

    for sec = 20, 60, 5 do
        table.insert(seconds, sec)
    end

    return seconds
end

local function buildOptions()
    populateRemovableOptions()

    local options = {
        [1] = {
            type = "header",
            name = AH.Format(_G.SI_BINDING_NAME_TOGGLE_NOTIFICATIONS),
            width = "full"
        },
        [2] = {
            type = "checkbox",
            name = AH.Format(_G.ARCHIVEHELPER_PROGRESS_ACHIEVEMENT),
            getFunc = function()
                return AH.Vars.Notify
            end,
            setFunc = function(value)
                AH.Vars.Notify = value
            end,
            width = "full"
        },
        [3] = {
            type = "checkbox",
            name = AH.Format(_G.ARCHIVEHELPER_PROGRESS_CHAT),
            tooltip = AH.Format(_G.ARCHIVEHELPER_REQUIRES),
            getFunc = function()
                return AH.Vars.NotifyChat
            end,
            setFunc = function(value)
                AH.Vars.NotifyChat = value
            end,
            disabled = function()
                return (not AH.Vars.Notify) or (not AH.Chat)
            end,
            width = "full"
        },
        [4] = {
            type = "checkbox",
            name = AH.Format(_G.ARCHIVEHELPER_PROGRESS_SCREEN),
            getFunc = function()
                return AH.Vars.NotifyScreen
            end,
            setFunc = function(value)
                AH.Vars.NotifyScreen = value
            end,
            disabled = function()
                return not AH.Vars.Notify
            end,
            width = "full"
        },
        [5] = {
            type = "header",
            name = AH.Format(_G.SI_ITEMFILTERTYPE5),
            width = "full"
        },
        [6] = {
            type = "checkbox",
            name = AH.Format(_G.ARCHIVEHELPER_REMINDER),
            tooltip = AH.Format(_G.ARCHIVE_HELPER_REMINDER_TOOLTIP),
            getFunc = function()
                return AH.Vars.ShowNotice
            end,
            setFunc = function(value)
                AH.Vars.ShowNotice = value
            end,
            width = "full"
        },
        [7] = {
            type = "checkbox",
            name = AH.Format(_G.ARCHIVEHELPER_SHOW_ECHO),
            getFunc = function()
                return AH.Vars.ShowTimer
            end,
            setFunc = function(value)
                AH.Vars.ShowTimer = value
                AH.TimerCheck()
            end,
            width = "full"
        },
        [8] = {
            type = "dropdown",
            name = string.format(
                "%s (%s)",
                AH.Format(_G.SI_ABILITY_TOOLTIP_DURATION_LABEL),
                AH.Format(_G.ARCHIVEHELPER_SECONDS):lower()
            ),
            choices = getSecondsOptions(),
            getFunc = function()
                return AH.Vars.EchoingDenTimer
            end,
            setFunc = function(value)
                AH.Vars.EchoingDenTimer = value
            end,
            disabled = function()
                return not AH.Vars.ShowTimer
            end,
            width = "full"
        },
        [9] = {
            type = "checkbox",
            name = AH.Format(_G.ARCHIVEHELPER_MARAUDER_INCOMING_PLAY),
            getFunc = function()
                return AH.Vars.MarauderPlay or false
            end,
            setFunc = function(value)
                AH.Vars.MarauderPlay = value
            end,
            width = "full"
        },
        [10] = {
            type = "checkbox",
            name = AH.Format(_G.ARCHIVEHELPER_REMINDER_QUEST),
            getFunc = function()
                return AH.Vars.CheckQuestItems
            end,
            setFunc = function(value)
                AH.Vars.CheckQuestItems = value
            end,
            width = "full"
        },
        [11] = {
            type = "checkbox",
            name = AH.Format(_G.ARCHIVEHELPER_FABLED_MARKER),
            tooltip = function()
                if (not AH.CompatibilityCheck()) then
                    return AH.Format(_G.ARCHIVEHELPER_FABLED_TOOLTIP)
                end
            end,
            getFunc = function()
                return AH.Vars.FabledCheck
            end,
            setFunc = function(value)
                AH.Vars.FabledCheck = value
            end,
            disabled = function()
                return not AH.CompatibilityCheck()
            end,
            width = "full"
        },
        [12] = {
            type = "checkbox",
            name = AH.Format(_G.ARCHIVEHELPER_SHARD_MARKER),
            getFunc = function()
                return AH.Vars.ShardCheck
            end,
            setFunc = function(value)
                AH.Vars.ShardCheck = value
            end,
            width = "full"
        },
        [13] = {
            type = "checkbox",
            name = zo_iconFormat("/esoui/art/targetmarkers/target_white_skull_64.dds", 24, 24) ..
                AH.Format(_G.ARCHIVEHELPER_MARAUDER_MARKER),
            getFunc = function()
                return AH.Vars.MarauderCheck
            end,
            setFunc = function(value)
                AH.Vars.MarauderCheck = value
            end,
            width = "full"
        }
    }

    options[#options + 1] = {
        type = "header",
        name = AH.Format(_G.SI_INTERFACE_OPTIONS_INDICATORS),
        width = "full"
    }

    options[#options + 1] = {
        type = "checkbox",
        name = AH.ColourIcon(string.format("/esoui/art/%s.dds", AH.ICONS.ACH.name), "ff0000") ..
            " " .. AH.Format(_G.SI_ZONECOMPLETIONTYPE3),
        getFunc = function()
            return AH.Vars.MarkAchievements
        end,
        setFunc = function(value)
            AH.Vars.MarkAchievements = value
        end,
        width = "full"
    }

    options[#options + 1] = {
        type = "checkbox",
        name = zo_iconFormat(string.format("/esoui/art/%s.dds", AH.ICONS.WOLF.name), 24, 24) ..
            " " .. AH.Format(_G.SI_ENDLESS_DUNGEON_SUMMARY_AVATAR_VISIONS_HEADER),
        getFunc = function()
            return AH.Vars.MarkAvatar
        end,
        setFunc = function(value)
            AH.Vars.MarkAvatar = value
        end,
        width = "full"
    }

    options[#options + 1] = {
        type = "checkbox",
        name = "|cffff00(1)|r   " .. AH.Format(_G.ARCHIVEHELPER_STACKS),
        getFunc = function()
            return AH.Vars.ShowStacks
        end,
        setFunc = function(value)
            AH.Vars.ShowStacks = value
        end,
        width = "full"
    }

    options[#options + 1] = {
        type = "checkbox",
        name = AH.ColourIcon(string.format("/esoui/art/%s.dds", AH.ICONS.FAV.name), "00ff00") ..
            "|r " .. AH.Format(_G.SI_COLLECTIONS_FAVORITES_CATEGORY_HEADER),
        getFunc = function()
            return AH.Vars.MarkFavourites
        end,
        setFunc = function(value)
            AH.Vars.MarkFavourites = value
        end,
        width = "full"
    }

    options[#options + 1] = {
        type = "header",
        name = AH.Format(_G.SI_COLLECTIONS_FAVORITES_CATEGORY_HEADER),
        width = "full"
    }

    options[#options + 1] = {
        type = "dropdown",
        name = AH.Format(_G.SI_COLLECTIBLE_ACTION_ADD_FAVORITE),
        choices = favouriteChoices,
        choicesValues = favouriteChoiceValues,
        getFunc = function()
        end,
        setFunc = function(value)
            if (ZO_IsElementInNumericallyIndexedTable(AH.Vars.Favourites, value)) then
                return
            end

            table.insert(AH.Vars.Favourites, value)
            updateFavourites()
        end
    }

    options[#options + 1] = {
        type = "dropdown",
        name = AH.Format(_G.SI_COLLECTIBLE_ACTION_REMOVE_FAVORITE),
        choices = removeChoices,
        choicesValues = removeChoiceValues,
        getFunc = function()
        end,
        setFunc = function(value)
            if (ZO_IsElementInNumericallyIndexedTable(AH.Vars.Favourites, value)) then
                AH.Vars.Favourites =
                    AH.Filter(
                    AH.Vars.Favourites,
                    function(v)
                        return v ~= value
                    end
                )

                updateFavourites()
            end
        end,
        disabled = function()
            return #AH.Vars.Favourites == 0
        end
    }

    options[#options + 1] = {
        type = "description",
        text = "|cff0000" .. AH.Format(_G.ARCHIVEHELPER_WARNING) .. "|r",
        width = "full"
    }

    options[#options + 1] = {
        type = "description",
        text = getFavourites(),
        width = "full",
        reference = "ARCHIVE_HELPER_FAVOURITES_LIST"
    }

    return options
end

function AH.RegisterSettings()
    local options = buildOptions()

    AH.OptionsPanel = AH.LAM:RegisterAddonPanel("ArchiveHelperOptionsPanel", panel)
    AH.LAM:RegisterOptionControls("ArchiveHelperOptionsPanel", options)
end
