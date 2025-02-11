Config = {}

 -- Change the Event that should be used when to register the Player after it's loaded!
Config.ReadyEvent = function(LoadPlayerFunc)
    -- This function defines the event name from when the player is ready/loaded. 
    -- For frameworks such as ESX/QBCore, it is important to start the registration after the player has been successfully loaded. 
    -- This is to ensure that the player's identifiers are available and can be used to create the player instance.
    -- ⚠️ If you have changed the default resource name of the framework e.g. "es_extended" --> "fivem_framework", then you have to adjust this in the GetResourceState.

    -- Check if ESX Framework is started
    if GetResourceState("es_extended") == 'started' then
        RegisterNetEvent('esx:playerLoaded')
        AddEventHandler('esx:playerLoaded', function(player, xPlayer, isNew)
            LoadPlayerFunc(xPlayer.source)
        end)

    -- Check if QBCore Framework is started
    elseif GetResourceState("qb-core") == 'started' then
        RegisterNetEvent('QBCore:Server:PlayerLoaded')
        AddEventHandler('QBCore:Server:PlayerLoaded', function(QBPlayer)
            LoadPlayerFunc(QBPlayer.PlayerData.source)
        end)

    -- If no framework has been started, we use the normal standalone player connection event from FiveM
    else
        RegisterNetEvent('playerConnecting')
        AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
            LoadPlayerFunc(source)
        end)
    end
end
Config.GetPlayerIdentifier = function(PlayerID) -- Function to get the Player Identifier
    -- This function defines the function to get the player's Identifier. 
    -- For frameworks such as ESX/QBCore with multi-character, it is important to use the correct function to get the player's identifier. 
    -- ⚠️ If you have changed the default resource name of the framework e.g. "es_extended" --> "fivem_framework", then you have to adjust this in the GetResourceState.

    -- Check if ESX Framework is started
    if GetResourceState("es_extended") == 'started' then
        local ESX = exports["es_extended"]:getSharedObject()
        local xPlayer = ESX.GetPlayerFromId(PlayerID)

        if xPlayer then
            return xPlayer.getIdentifier()
        else
            return nil
        end

    -- Check if QBCore Framework is started
    elseif GetResourceState("qb-core") == 'started' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local Player = QBCore.Functions.GetPlayer(PlayerID)

        if Player then
            return Player.PlayerData.citizenid
        else
            return nil
        end

    -- If no framework has been started, we use the normal rockstar license identifier
    else
        local PlayerIdentifier = nil
        for k, v in pairs(GetPlayerIdentifiers(PlayerID)) do
            if string.sub(v, 1, string.len("license:")) == "license:" then
                PlayerIdentifier = v:gsub("license:", "")
            end
        end
        return PlayerIdentifier
    end
end
Config.DefaultLevel = 1 -- Default Level for new players
Config.XPLevelThreshold = 100 -- XP needed to level up
Config.XPIncreasement = 25 -- XP Increasement for each Level (Level 1: 100 XP, Level 2: 125 XP, Level 3: 150 XP, etc.)
Config.XPLogLimit = 15 -- How many XP Logs should be stored internal
Config.LevelCommand = { 'level', 'xp' } -- Command to see your own Level/XP etc.
Config.RankStage = { -- Rank Stages for the Level System
    [1] = "Newbie",
    [5] = "Beginner",
    [10] = "Amateur",
    [15] = "Advanced",
    [20] = "Professional",
    [25] = "Expert",
    [30] = "Master",
    [35] = "Legend",
    [40] = "Godlike"
    -- You can add more Rank Stages here
}
Config.DiscordWebhook = {
    addXP = "https://discord.com/api/webhooks/XXX/XXX",
    removeXP = "https://discord.com/api/webhooks/XXX/XXX",
    setXP = "https://discord.com/api/webhooks/XXX/XXX",
    addRank = "https://discord.com/api/webhooks/XXX/XXX",
    removeRank = "https://discord.com/api/webhooks/XXX/XXX",
    setRank = "https://discord.com/api/webhooks/XXX/XXX",
    resetPlayer = "https://discord.com/api/webhooks/XXX/XXX",
    resetPlayerXP = "https://discord.com/api/webhooks/XXX/XXX",

    WebhookColor = '16591698', -- Change the Color of the Webhook
    WebhookAuthor = 'Tuncion', -- Change the Author of the Webhook
    WebhookIconURL = 'https://i.ibb.co/km51K0S/Logo-Grau.jpg', -- Change the IconURL of the Webhook

    WebhookWithIdentifiers = true -- If you want to send the Identifiers data with the Webhook
}
