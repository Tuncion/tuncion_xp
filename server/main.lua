-- Give me Credits ❤️
print("\27[1;46m[Tuncion-XP]\27[0m \27[1;37m The ^3Tuncion XP Handler^7\27[1;37m is now available ✅^7")
print("\27[1;46m[Tuncion-XP]\27[0m \27[1;37m Made with ❤️ by ^3Tuncion^7")

-- Variables
local Players = {}

function ErrorMessage(msg)
    print(("\27[1;46m[Tuncion-XP]\27[0m \27[1;37m %s^7"):format(msg))
end

-- Load Players
RegisterNetEvent("tuncion_xp:server:RegisterPlayer")
AddEventHandler("tuncion_xp:server:RegisterPlayer", function()
    local PlayerID = source
    local PlayerIdentifier = GetPlayerLicense(PlayerID)

    if PlayerIdentifier then
        CreatePlayerInstance(PlayerID, PlayerIdentifier)
    else
        ErrorMessage(("There is no license found for player %s (%s)"):format(GetPlayerName(PlayerID), PlayerID))
    end
end)

-- Register Commands
for k, v in pairs(Config.LevelCommand) do
    RegisterCommand(v, function(source, args, rawCommand)
        LevelCommand(source)
    end, false)
end

function CreatePlayerInstance(PlayerID, PlayerIdentifier)
    MySQL.Async.fetchAll('SELECT * FROM player_xp WHERE identifier = @identifier', {
        ['@identifier'] = PlayerIdentifier
    }, function(MySQLData)
        if not MySQLData then
            ErrorMessage(("There was an error while loading player %s (%s)"):format(GetPlayerName(PlayerID), PlayerID))
            return
        end
        local PlayerData = MySQLData[1]

        if PlayerData then
            MySQL.Async.fetchAll('SELECT * FROM player_xpLog WHERE identifier = @identifier LIMIT @limit', {
                ['@identifier'] = PlayerIdentifier,
                ['@limit'] = Config.XPLogLimit
            }, function(MySQLData2)
                Players[PlayerID] = Player(PlayerID, PlayerIdentifier, PlayerData.xp, MySQLData2)
            end)
        else
            -- Create Player Data
            MySQL.Async.execute('INSERT INTO player_xp (identifier) VALUES (@identifier)', {
                ['@identifier'] = PlayerIdentifier
            }, function(result)
                if result > 0 then
                    Players[PlayerID] = Player(PlayerID, PlayerIdentifier, 0, {})
                else
                    ErrorMessage(("There was an error while creating player %s (%s)"):format(GetPlayerName(PlayerID), PlayerID))
                    return
                end
            end)
        end
    end)
end

function GetPlayerLicense(PlayerID)
    local PlayerIdentifier = nil

    -- Get Player Identifier
    for k, v in pairs(GetPlayerIdentifiers(PlayerID)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            PlayerIdentifier = v:gsub("license:", "")
        end
    end

    return PlayerIdentifier
end

function LevelCommand(source)
    local Message = ("~f~Your XP Card~s~ (~f~%s~s~):\n~c~Stage:~s~ ~o~%s~s~\n~c~Level:~s~ %s (~g~%sXP left~s~)"):format(source, getRankStage(source), getRank(source), getNeededXP(source))
    TriggerClientEvent('tuncion_xp:client:Notify', source, Message)
end

---- Exports ----

-- Getter
function getGlobalXP(CurrentlyOnline)
    local TotalXP = 0
    local IsReady = false

    if CurrentlyOnline then
        for k, v in pairs(Players) do
            TotalXP = TotalXP + v.getTotalXP()
        end
        IsReady = true
    else
        MySQL.Async.fetchAll('SELECT * FROM player_xp', {}, function(MySQLData)
            if MySQLData then
                for k, v in pairs(MySQLData) do
                    TotalXP = TotalXP + v.xp
                end
                IsReady = true
            end
        end)
    end
    while not IsReady do Citizen.Wait(500) end

    return TotalXP
end

function getGlobalRank(CurrentlyOnline)
    local TotalRank = 0
    local IsReady = false

    if CurrentlyOnline then
        for k, v in pairs(Players) do
            TotalRank = TotalRank + v.getRank()
        end
        IsReady = true
    else
        MySQL.Async.fetchAll('SELECT * FROM player_xp', {}, function(MySQLData)
            if MySQLData then
                for k, v in pairs(MySQLData) do
                    TotalRank = TotalRank + CalculateRank(v.xp)
                end
                IsReady = true
            end
        end)
    end
    while not IsReady do Citizen.Wait(500) end

    return TotalRank
end

function getGlobalRank(CurrentServer)
    local TotalRank = 0
    local IsReady = false

    if CurrentServer then
        for k, v in pairs(Players) do
            TotalRank = TotalRank + v.getRank()
        end
        IsReady = true
    else
        MySQL.Async.fetchAll('SELECT * FROM player_xp', {}, function(MySQLData)
            if MySQLData then
                for k, v in pairs(MySQLData) do
                    TotalRank = TotalRank + CalculateRank(v.xp)
                end
                IsReady = true
            end
        end)
    end
    while not IsReady do Citizen.Wait(500) end

    return TotalRank
end

function getTotalXP(PlayerID)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        return PlayerData.getTotalXP()
    else
        return nil
    end
end

function getXP(PlayerID)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        return PlayerData.getXP()
    else
        return nil
    end
end

function getNeededXP(PlayerID)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        return PlayerData.getNeededXP()
    else
        return nil
    end
end

function getRank(PlayerID)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        return PlayerData.getRank()
    else
        return nil
    end
end

function getRankStage(PlayerID)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        return PlayerData.getRankStage()
    else
        return nil
    end
end

function getXPLog(PlayerID)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        return PlayerData.getXPLog()
    else
        return nil
    end
end

-- Setter
function addXP(PlayerID, XP, Reason)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        return PlayerData.addXP(XP, Reason)
    else
        return false
    end
end

function removeXP(PlayerID, XP, Reason)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        if PlayerData.getXP() - XP < 0 then
            XP = PlayerData.getXP()
        end
        return PlayerData.removeXP(XP, Reason)
    else
        return false
    end
end

function setXP(PlayerID, XP, Reason)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        return PlayerData.setXP(XP, Reason)
    else
        return false
    end
end

function addRank(PlayerID, Rank, Reason)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        return PlayerData.addRank(Rank, Reason)
    else
        return false
    end
end

function removeRank(PlayerID, Rank, Reason)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        if PlayerData.getRank() - Rank < Config.DefaultLevel then
            Rank = Config.DefaultLevel
        end
        return PlayerData.removeRank(Rank, Reason)
    else
        return false
    end
end

function setRank(PlayerID, Rank, Reason)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        return PlayerData.setRank(Rank, Reason)
    else
        return false
    end
end

function resetPlayer(PlayerID)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        return PlayerData.resetPlayer()
    else
        return false
    end
end

function resetPlayerXP(PlayerID)
    local PlayerData = Players[PlayerID]

    if PlayerData then
        return PlayerData.resetPlayerXP()
    else
        return false
    end
end
