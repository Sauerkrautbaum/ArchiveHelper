local AH = _G.ArchiveHelper
local tomeName = GetString(_G.ARCHIVEHELPER_TOMESHELL):lower()
local lastStun = 0
local lastMapId = 0
local sourceIds = {}

local function onSelectorHiding()
    if (AH.Notice) then
        AH.Release("Notice")
    end

    if (AH.QuestReminder) then
        AH.Release("QuestReminder")
    end

    zo_callLater(
        function()
            AH.ShowingBuffs = false
            CALLBACK_MANAGER:FireCallbacks("ArchiveHelperBuffSelectorClosing")
        end,
        1500
    )
end

local function encode(abilityId, count)
    return tonumber(string.format("%d%06d%d", AH.SHARE.ABILITY, abilityId, count))
end

local function onChoiceCommitted()
    if (AH.SelectedBuff) then
        local avatar = AH.IsAvatar(AH.SelectedBuff)

        if (avatar) then
            AH.Vars.AvatarVisionCount[avatar] = AH.Vars.AvatarVisionCount[avatar] + 1

            if (AH.Vars.AvatarVisionCount[avatar] == 4) then
                AH.Vars.AvatarVisionCount[avatar] = 0
            end
        end

        local selected = AH.SelectedBuff

        zo_callLater(
            function()
                local abilityInfo = AH.ABILITIES[selected]
                local abilityType = abilityInfo.type or AH.TYPES.VERSE
                local count

                if (avatar) then
                    count = AH.Vars.AvatarVisionCount[avatar] or 0
                else
                    local counts = ENDLESS_DUNGEON_MANAGER:GetAbilityStackCountTable(abilityType)
                    count = counts[selected] or 0
                end

                AH.GroupChat(encode(selected, count))
                AH.ShareData(AH.SHARE.ABILITY, selected, nil, count)
                CALLBACK_MANAGER:FireCallbacks("ArchiveHelperBuffSelectionCommitted")
            end,
            500
        )

        AH.SelectedBuff = nil
    end
end

local function checkNotice()
    local message = nil
    local stageCounter, cycleCounter = ENDLESS_DUNGEON_MANAGER:GetProgression()
    local stageTarget, cycleTarget = 2, 5

    if (AH.IsInUnknown()) then
        stageTarget = 3
    end

    if (stageCounter == stageTarget and cycleCounter ~= cycleTarget) then
        message = AH.Format(_G.ARCHIVEHELPER_CYCLE_BOSS)
    elseif (cycleCounter == cycleTarget and stageCounter == stageTarget) then
        message = AH.Format(_G.ARCHIVEHELPER_ARC_BOSS)
    end

    if (message) then
        AH.ShowNotice(message)
    end

    AH.ShowQuestReminder()
end

local function onShowing()
    AH.OnBuffSelectorShowing()
    AH.ShowingBuffs = true
    checkNotice()
    CALLBACK_MANAGER:FireCallbacks("ArchiveHelperBuffSelectorShowing")
end

local function onSelecting(_, buffControl)
    AH.SelectedBuff = GetEndlessDungeonBuffSelectorBucketTypeChoice(buffControl.bucketType)
end

local function onCompassUpdate()
    if (AH.InsideArchive and AH.Vars.CheckQuestItems and AH.InCombet) then
        if (AH.FoundQuestItem == false) then
            local numPins = COMPASS.container:GetNumCenterOveredPins()

            if (numPins > 0) then
                for pin = 1, numPins do
                    local pinType = COMPASS.container:GetCenterOveredPinType(pin)
                    if (pinType == _G.MAP_PIN_TYPE_QUEST_INTERACT) then
                        AH.FoundQuestItem = true
                    end
                end
            end
        end
    end
end

local tomesFound = 0
local tomesTotal = 0

local function tomeCheck(...)
    local result = select(2, ...)
    local sourceName, _, targetName = select(7, ...)

    if (result == _G.ACTION_RESULT_DIED or result == _G.ACTION_RESULT_DIED_XP) then
        targetName = AH.Format(targetName):lower()
        sourceName = AH.Format(sourceName):lower()

        if (targetName:find(tomeName, 1, true) or sourceName:find(tomeName, 1, true)) then
            tomesFound = tomesFound + 1
            tomesTotal = tomesTotal + 1
            AH.PlayAlarm(AH.Sounds.Tomeshell)

            if (AH.TomeGroupType ~= _G.ENDLESS_DUNGEON_GROUP_TYPE_SOLO) then
                AH.ShareData(AH.SHARE.TOME, tomesFound, true)
            end

            local tomesLeft = AH.MaxTomes - tomesTotal

            tomesLeft = (tomesLeft < 0) and 0 or tomesLeft

            local message = zo_strformat(_G.SI_SCREEN_NARRATION_TIMER_BAR_DESCENDING_FORMATTER, tomesLeft)

            AH.TomeCount:SetText(message)
            CALLBACK_MANAGER:FireCallbacks("ArchiveHelperTomeshellKilled")
        end
    end
end

local function startTomeCheck()
    -- for the purposes of this check, players with companions count as solo
    AH.TomeGroupType = AH.GetActualGroupType()
    AH.MaxTomes = AH.TomeGroupType == _G.ENDLESS_DUNGEON_GROUP_TYPE_SOLO and AH.Tomeshells.Solo or AH.Tomeshells.Duo

    local message = zo_strformat(_G.SI_SCREEN_NARRATION_TIMER_BAR_DESCENDING_FORMATTER, AH.MaxTomes)

    AH.ShowTomeshellCount()
    AH.TomeCount:SetText(message)

    EVENT_MANAGER:RegisterForEvent(AH.Name .. "_Tome", _G.EVENT_COMBAT_EVENT, tomeCheck)
end

local function stopTomeCheck()
    if (AH.TomeCount) then
        AH.TomeCount:SetHidden(true)
        AH.Release("TomeCount")
    end

    EVENT_MANAGER:UnregisterForEvent(AH.Name .. "_Tome", _G.EVENT_COMBAT_EVENT)
end

local function checkSharing()
    AH.ShareData(AH.SHARE.SHARING, 1)
end

local function zoneCheck()
    local mapId = GetCurrentMapId()

    if (mapId == AH.MAPS.ECHOING_DEN.id) then
        checkSharing()
        AH.IsInEchoingDen = true
        AH.DenStarted = true
        AH.ShowTimer()
    elseif (mapId == AH.MAPS.TREACHEROUS_CROSSING.id) then
        checkSharing()
        AH.IsInCrossing = true
        AH.ShowCrossingHelper()
    else
        AH.IsInEchoingDen = false
        AH.DenStarted = false
        AH.IsInCrossing = false

        if (AH.Timer) then
            AH.HideTimer()
        end

        if (AH.CrossingHelper) then
            AH.HideCrossingHelper()
        end
    end
end

local function onPlayerActivated()
    local mapId = GetCurrentMapId()

    if (lastMapId ~= mapId) then
        lastMapId = mapId

        if (AH.Vars.ShowTimer) then
            zoneCheck()
        end

        if (AH.Vars.CountTomes and mapId == AH.MAPS.FILERS_WING.id) then
            AH.IsInFilersWing = true
        else
            AH.IsInFilersWing = false

            if (AH.TomeCount) then
                stopTomeCheck()
            end
        end
    end

    AH.GetActualGroupType()
end

local function checkMessage(messageParams)
    if (not IsInstanceEndlessDungeon()) then
        return
    end

    if (not AH.DenStarted) then
        onPlayerActivated()
    end

    -- Herd the Ghost Lights
    if (AH.IsInEchoingDen) then
        local message = AH.Format(messageParams:GetMainText()):lower()
        local secondaryMessage = AH.Format(messageParams:GetSecondaryText() or ""):lower()
        local start = AH.Format(_G.ARCHIVEHELPER_HERD):lower()
        local fail = AH.Format(_G.ARCHIVEHELPER_HERD_FAIL):lower()
        local success = AH.Format(_G.ARCHIVEHELPER_HERD_SUCCESS):lower()

        if (message:find(start, 1, true)) then
            AH.DenDone = false
            AH.StartTimer()
        elseif
            (message:find(fail, 1, true) or message:find(success, 1, true) or secondaryMessage:find(fail, 1, true) or
                secondaryMessage:find(success, 1, true))
         then
            AH.StopTimer()
            AH.DenDone = true
        end
    end

    -- Treacherous Crossing
    if (AH.IsInCrossing) then
        local message = AH.Format(messageParams:GetMainText()):lower()
        local secondaryMessage = AH.Format(messageParams:GetSecondaryText() or ""):lower()
        local fail = AH.Format(_G.ARCHIVEHELPER_CROSSING_FAIL):lower()
        local success = AH.Format(_G.ARCHIVEHELPER_CROSSING_SUCCESS):lower()

        if
            (message:find(fail, 1, true) or message:find(success, 1, true) or secondaryMessage:find(fail, 1, true) or
                secondaryMessage:find(success, 1, true))
         then
            AH.HideCrossingHelper()
        end
    end
end

local function onMessage(_, messageParams)
    if (not messageParams) then
        return
    end

    if (AH.Vars.ShowTimer) then
        checkMessage(messageParams)
    end

    return false
end

local function resetValues()
    ZO_ClearNumericallyIndexedTable(AH.bosses)
    ZO_ClearNumericallyIndexedTable(sourceIds)
    AH.FoundQuestItem = false
    AH.InsideArchive = IsInstanceEndlessDungeon() and (GetCurrentMapId() ~= AH.ArchiveIndex)
    ZO_ClearNumericallyIndexedTable(AH.Shards)
    tomesFound = 0
    tomesTotal = 0

    for _, info in pairs(AH.MARKERS) do
        info.manual = false
    end
end

-- minimise false zone change detections
local function onStunned(_, stunned)
    if (stunned and not IsUnitInCombat("player")) then
        local now = GetTimeStamp()

        if ((now - lastStun) > 2) then
            zo_callLater(
                function()
                    if (not AH.ShowingBuffs) then
                        resetValues()
                    end
                end,
                1000
            )
            lastStun = now
        end
    end
end

local function onDungeonInitialised()
    local visionCount = ENDLESS_DUNGEON_MANAGER:GetAbilityStackCountTable(_G.ENDLESS_DUNGEON_BUFF_TYPE_VISION)

    AH.Vars.AvatarVisionCount = {ICE = 0, WOLF = 0, IRON = 0}

    if (visionCount) then
        for avatar, data in pairs(AH.AVATAR) do
            for _, abilityId in ipairs(data.abilityIds) do
                if (abilityId ~= data.transform) then
                    local count = visionCount[abilityId] or 0

                    AH.Vars.AvatarVisionCount[avatar] = AH.Vars.AvatarVisionCount[avatar] + count
                end
            end
        end
    end
end

local function onQuestCounterChanged(_, journalIndex)
    local indexes = AH.GetArchiveQuestIndexes(true)

    if (ZO_IsElementInNumericallyIndexedTable(indexes, journalIndex)) then
        AH.FoundQuestItem = false
    end
end

local function onHotBarChange(_, changed, shouldUpdate, category)
    if (AH.IsInFilersWing) then
        if ((category == _G.HOTBAR_CATEGORY_TEMPORARY) and shouldUpdate and changed) then
            checkSharing()
            startTomeCheck()
        end

        if ((category == _G.HOTBAR_CATEGORY_PRIMARY) and changed and not shouldUpdate) then
            stopTomeCheck()
        end
    end
end

local player = GetUnitName("player")

local function getOtherPlayer()
    local groupSize = GetGroupSize()

    if (groupSize == 0) then
        return
    end

    for unit = 1, groupSize do
        if (IsUnitOnline(string.format("group%d", unit))) then
            local name = GetUnitName(string.format("group%d", unit))
            if (name ~= player) then
                return name
            end
        end
    end
end

local function onCrossingChange(selections)
    if (not AH.IsLeader and AH.CrossingHelper) then
        selections = selections:gsub("0", " ")

        AH.CrossingHelperFrame.box1.SetSelected(selections[1])
        AH.CrossingHelperFrame.box2.SetSelected(selections[2])
        AH.CrossingHelperFrame.box3.SetSelected(selections[3])
        AH.selectedBox[1] = selections[1]
        AH.selectedBox[2] = selections[2]
        AH.CrossingUpdate(3, selections[3], true)
    end
end

local function onLeaderUpdate()
    if (not AH.CrossingHelperFrame:IsHidden()) then
        AH.SetDisableCombos()
    end
end

function AH.ShareData(shareType, value, instant, stackCount)
    if ((not AH.Share) and (not AH.DEBUG)) then
        return
    end

    local encoded

    if (stackCount) then
        encoded = encode(value, stackCount)
    else
        encoded = tonumber(string.format("%d%d", shareType, value))
    end

    if (AH.Share) then
        if (instant) then
            AH.Share:SendData(encoded)
        else
            AH.Share:QueueData(encoded)
        end
    end

    AH.Debug("Shared: " .. encoded)
end

function AH.HandleDataShare(_, info)
    local shareType = tonumber(tostring(info):sub(1, 1))
    local shareData = tonumber(tostring(info):sub(2))

    if (shareType == AH.SHARE.TOME) then
        tomesTotal = tomesFound + shareData

        local tomesLeft = AH.MaxTomes - tomesTotal

        tomesLeft = (tomesLeft < 0) and 0 or tomesLeft

        local message = zo_strformat(_G.SI_SCREEN_NARRATION_TIMER_BAR_DESCENDING_FORMATTER, tomesLeft)

        AH.TomeCount:SetText(message)
        AH.PlayAlarm(AH.Sounds.Tomeshell)
        AH.Debug("Received tome data: " .. shareData)
    elseif (shareType == AH.SHARE.MARK) then
        if (shareData and (shareData > 0) and (shareData < 8)) then
            AH.MARKERS[shareData].used = true
            AH.MARKERS[shareData].manual = true
            AH.Debug("Received mark data: " .. shareData)
        end
    elseif (shareType == AH.SHARE.UNMARK) then
        if (shareData and (shareData > 0) and (shareData < 8)) then
            AH.MARKERS[shareData].manual = false
            AH.Debug("Received unmark data: " .. shareData)
        end
    elseif (shareType == AH.SHARE.GW) then
        if (shareData and (shareData > 0) and (not AH.FOUND_GW)) then
            AH.PlayAlarm(AH.Sounds.Gw)
            AH.FOUND_GW = true
            AH.Debug("Received Gw detection")
        end
    elseif (shareType == AH.SHARE.ABILITY) then
        if (shareData) then
            local data = tostring(info)

            if (data:len() > 7) then
                AH.GroupChat(data, getOtherPlayer())
            end
            AH.Debug("Received ability data: " .. shareData)
        end
    elseif (shareType == AH.SHARE.CROSSING) then
        onCrossingChange(tostring(info):sub(2))
        AH.Debug("Received crossing data: " .. tostring(info):sub(2))
    elseif (shareType == AH.SHARE.SHARING) then
        AH.AH_SHARING = true
        AH.Debug("Received sharing notification")
    end
end

function AH.SetupHooks()
    SecurePostHook(_G[AH.SELECTOR], "OnHiding", onSelectorHiding)
    SecurePostHook(_G[AH.SELECTOR], "CommitChoice", onChoiceCommitted)
    SecurePostHook(_G[AH.SELECTOR], "OnShowing", onShowing)
    SecurePostHook(_G[AH.SELECTOR], "SelectBuff", onSelecting)
    SecurePostHook(COMPASS, "OnUpdate", onCompassUpdate)
    SecurePostHook(CENTER_SCREEN_ANNOUNCE, "AddMessageWithParams", onMessage)
    ZO_PreHook(BOSS_BAR, "AddBoss", AH.OnNewBoss)
end

function AH.SetupEvents()
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ACHIEVEMENT_UPDATED, AH.FindMissingAbilityIds)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ACHIEVEMENT_AWARDED, AH.FindMissingAbilityIds)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_PLAYER_ACTIVATED, onPlayerActivated)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ENDLESS_DUNGEON_INITIALIZED, onDungeonInitialised)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_QUEST_CONDITION_COUNTER_CHANGED, onQuestCounterChanged)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_PLAYER_STUNNED_STATE_CHANGED, onStunned)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ACTION_SLOTS_ACTIVE_HOTBAR_UPDATED, onHotBarChange)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_LEADER_UPDATE, onLeaderUpdate)

    if (AH.Vars.FabledCheck and AH.CompatibilityCheck()) then
        EVENT_MANAGER:RegisterForEvent(AH.Name .. "_Fabled", _G.EVENT_PLAYER_COMBAT_STATE, AH.CombatCheck)
    end

    if (AH.Vars.AutoCheck) then
        AH.UpdateSlottedSkills()
        EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ACTION_SLOTS_ALL_HOTBARS_UPDATED, AH.UpdateSlottedSkills)
    end
end
