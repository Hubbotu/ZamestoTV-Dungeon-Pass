local addonName, addon = ...

-- Define the default NPC_LIST table
local defaultNPC_LIST = {
    ["Book of Translocation"] = {56056, 56247, 56248, 56250, 56251, 56378}, -- selects option 1, then 3
    ["Bronze Dragonflight Recruiter"] = {107081},
    ["Blue Dragonflight Recruiter"] = {107082},
    ["Green Dragonflight Recruiter"] = {107083},
    ["Red Dragonflight Recruiter"] = {107088},
    ["Black Dragonflight Recruiter"] = {107065},
    -- Russian localized names
    ["Книга транслокации"] = {56056, 56247, 56248, 56250, 56251, 56378},
    ["Бронзовая вербовщица"] = {107081},
    ["Синяя вербовщица"] = {107082},
    ["Зеленый вербовщик"] = {107083},
    ["Красная вербовщица"] = {107088},
    ["Черный вербовщик"] = {107065},
    -- German localized names
    ["Buch der Translokation"] = {56056, 56247, 56248, 56250, 56251, 56378},
    ["Rekrutiererin des bronzenen Drachenschwarms"] = {107081},
    ["Rekrutiererin des blauen Drachenschwarms"] = {107082},
    ["Rekrutierer des grünen Drachenschwarms"] = {107083},
    ["Rekrutiererin des roten Drachenschwarms"] = {107088},
    ["Rekrutierer des schwarzen Drachenschwarms"] = {107065},
    -- French localized names
    ["Livre de transposition"] = {56056, 56247, 56248, 56250, 56251, 56378},
    ["Recruteuse du Vol draconique de bronze"] = {107081},
    ["Recruteuse du Vol draconique bleu"] = {107082},
    ["Recruteur du Vol draconique vert"] = {107083},
    ["Recruteuse du Vol draconique rouge"] = {107088},
    ["Recruteur du Vol draconique noir"] = {107065},
    -- Chinese localized names
    ["转移之书"] = {56056, 56247, 56248, 56250, 56251, 56378},
    ["青铜龙军团招募员"] = {107081},
    ["蓝龙军团招募员"] = {107082},
    ["绿龙军团招募员"] = {107083},
    ["红龙军团招募员"] = {107088},
    ["黑龙军团招募员"] = {107065},   
}

local NPC_LIST = defaultNPC_LIST

-- Create the frame for automatic gossip handling
local AutoGossip = CreateFrame("Frame")

-- Function to get the localized NPC name
local function GetLocalizedNPCName(npcName)
    local localizedNPCName = nil
    -- Add more language checks if needed
    if GetLocale() == "ruRU" then
        for name, gossips in pairs(NPC_LIST) do
            if gossips == npcName then
                localizedNPCName = name
                break
            end
        end
    elseif GetLocale() == "deDE" then
        for name, gossips in pairs(NPC_LIST) do
            if gossips == npcName then
                localizedNPCName = name
                break
            end
        end
    elseif GetLocale() == "frFR" then
        for name, gossips in pairs(NPC_LIST) do
            if gossips == npcName then
                localizedNPCName = name
                break
            end
        end
    elseif GetLocale() == "zhCN" then
        for name, gossips in pairs(NPC_LIST) do
            if gossips == npcName then
                localizedNPCName = name
                break
            end
        end
    end
    return localizedNPCName or npcName
end

-- Function to handle gossip interaction
local function HandleGossipInteraction(_, type)
    if IsShiftKeyDown() then return end
    if type ~= Enum.PlayerInteractionType.Gossip then return end
    local npcName = GossipFrame.TitleContainer.TitleText:GetText()
    if not npcName then return end
    local gossips = NPC_LIST[npcName]
    if not gossips then
        -- Try to find localized NPC name if not found in the default language
        npcName = GetLocalizedNPCName(npcName)
        gossips = NPC_LIST[npcName]
        if not gossips then return end
    end
    local options = C_GossipInfo.GetOptions()
    if not options then return end
    for _, option in ipairs(options) do
        if tContains(gossips, option.gossipOptionID) then
            C_GossipInfo.SelectOption(option.gossipOptionID)
            return
        end
    end
end

-- Set script for gossip interaction event
AutoGossip:SetScript("OnEvent", HandleGossipInteraction)
AutoGossip:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")

-- Function to load saved variables
local function LoadSavedVariables()
    if AutoGossipSavedVarsonon and AutoGossipSavedVarsonon.NPC_LIST then
        -- Replace the default NPC_LIST with the saved one
        NPC_LIST = AutoGossipSavedVarsonon.NPC_LIST
    end
end

-- Function to save variables
local function SaveSavedVariables()
    if not AutoGossipSavedVarsonon then
        AutoGossipSavedVarsonon = {}
    end
    -- Save the NPC_LIST
    AutoGossipSavedVarsonon.NPC_LIST = NPC_LIST
end

-- Function to handle player logout event
local function OnPlayerLogout()
    SaveSavedVariables()
end

-- Event registration for addon loaded and player logout
AutoGossip:RegisterEvent("ADDON_LOADED")
AutoGossip:RegisterEvent("PLAYER_LOGOUT")

-- Event handler for addon loaded and player logout
AutoGossip:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        LoadSavedVariables()
        self:UnregisterEvent("ADDON_LOADED")
    elseif event == "PLAYER_LOGOUT" then
        OnPlayerLogout()
    else
        HandleGossipInteraction(event, arg1)
    end
end)
