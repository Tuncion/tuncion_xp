function Player(source, identifier, xp, xpLog)
    local self = {}
    self.source = source
    self.identifier = identifier
    self.totalXP = xp or 0
    self.rank = CalculateRank(xp) or Config.DefaultLevel
    self.stage = CalculateRankStage(self.rank) or Config.RankStage[Config.DefaultLevel]
    self.xp = CalculateXP(xp) or 0
    self.xpLog = xpLog or {}

    function self.getXP()
        return self.xp
    end

    function self.getNeededXP()
        local TotalXP = self.getTotalXP()
        return CalculateNeededXPToUprank(TotalXP)
    end

    function self.getTotalXP()
        return self.totalXP
    end

    function self.getRank()
        return self.rank
    end

    function self.getRankStage()
        return self.stage
    end

    function self.getXPLog()
        return self.xpLog
    end

    function self.addXP(xp, reason)
        local LastRank = self.getRank()
        self.totalXP = self.getTotalXP() + xp
        self.xp = CalculateXP(self.totalXP)
        self.rank = CalculateRank(self.totalXP)
        self.stage = CalculateRankStage(self.rank)

        MySQL.Async.execute('UPDATE player_xp SET xp = @xp WHERE identifier = @identifier', {
            ['@identifier'] = self.identifier,
            ['@xp'] = self.getTotalXP()
        })

        MySQL.Async.execute('INSERT INTO player_xpLog (`identifier`, `type`, `change`, `oldXP`, `newXP`, `reason`, `timestamp`) VALUES (@identifier, @type, @change, @oldXP, @newXP, @reason, @timestamp)', {
            ['@identifier'] = self.identifier,
            ['@type'] = 'addXP',
            ['@change'] = xp,
            ['@oldXP'] = self.getTotalXP() - xp,
            ['@newXP'] = self.getTotalXP(),
            ['@reason'] = reason,
            ['@timestamp'] = os.date('%Y-%m-%d %H:%M:%S', os.time())
        })

        SendDiscordWebhook(self.source, {
            link = Config.DiscordWebhook.addXP,
            includeIdentifiers = true,
            color = Config.DiscordWebhook.WebhookColor,
            thumbnail = Config.DiscordWebhook.WebhookIconURL,
            author = {
                name = Config.DiscordWebhook.WebhookAuthor,
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
            title = "🪙 Add XP",
            description = ("**Player:** `%s` (`%s`)\n**Change:** `%sXP` **->** `%sXP`\n**Rank:** `Level %s`\n**Reason:** `%s`\n**Time:** <t:%s:f> (<t:%s:R>)"):format(GetPlayerName(self.source), self.source, self.getTotalXP() - xp, self.getTotalXP(), self.getRank(), reason or '/', os.time(), os.time()),
            footer = {
                text  = "Made with ❤️ by Tuncion",
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
        })

        TriggerEvent('tuncion_xp:log:addXP', self.source, { ['newRank'] = LastRank ~= self.getRank(), ['change'] = xp })
        TriggerClientEvent('tuncion_xp:log:addXP', self.source, { ['newRank'] = LastRank ~= self.getRank(), ['change'] = xp })
        TriggerClientEvent('tuncion_xp:client:NUIAnim', self.source, {
            ['type'] = 'addXP',
            ['change'] = xp,
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        })

        return {
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['rankStage'] = self.getRankStage(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        }
    end

    function self.removeXP(xp, reason)
        local LastRank = self.getRank()
        self.totalXP = self.getTotalXP() - xp
        self.xp = CalculateXP(self.totalXP)
        self.rank = CalculateRank(self.totalXP)
        self.stage = CalculateRankStage(self.rank)

        MySQL.Async.execute('UPDATE player_xp SET xp = @xp WHERE identifier = @identifier', {
            ['@identifier'] = self.identifier,
            ['@xp'] = self.getTotalXP()
        })

        MySQL.Async.execute('INSERT INTO player_xpLog (`identifier`, `type`, `change`, `oldXP`, `newXP`, `reason`, `timestamp`) VALUES (@identifier, @type, @change, @oldXP, @newXP, @reason, @timestamp)', {
            ['@identifier'] = self.identifier,
            ['@type'] = 'removeXP',
            ['@change'] = xp,
            ['@oldXP'] = self.getTotalXP() + xp,
            ['@newXP'] = self.getTotalXP(),
            ['@reason'] = reason,
            ['@timestamp'] = os.date('%Y-%m-%d %H:%M:%S', os.time())
        })

        SendDiscordWebhook(self.source, {
            link = Config.DiscordWebhook.removeXP,
            includeIdentifiers = true,
            color = Config.DiscordWebhook.WebhookColor,
            thumbnail = Config.DiscordWebhook.WebhookIconURL,
            author = {
                name = Config.DiscordWebhook.WebhookAuthor,
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
            title = "🪙 Remove XP",
            description = ("**Player:** `%s` (`%s`)\n**Change:** `%sXP` **->** `%sXP`\n**Rank:** `Level %s`\n**Reason:** `%s`\n**Time:** <t:%s:f> (<t:%s:R>)"):format(GetPlayerName(self.source), self.source, self.getTotalXP() + xp, self.getTotalXP(), self.getRank(), reason or '/', os.time(), os.time()),
            footer = {
                text  = "Made with ❤️ by Tuncion",
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
        })

        TriggerEvent('tuncion_xp:log:removeXP', self.source, { ['newRank'] = LastRank ~= self.getRank(), ['change'] = xp })
        TriggerClientEvent('tuncion_xp:log:removeXP', self.source, { ['newRank'] = LastRank ~= self.getRank(), ['change'] = xp })
        TriggerClientEvent('tuncion_xp:client:NUIAnim', self.source, {
            ['type'] = 'removeXP',
            ['change'] = xp,
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        })

        return {
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['rankStage'] = self.getRankStage(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        }
    end

    function self.setXP(xp, reason)
        local LastRank = self.getRank()
        local LastXP = self.getTotalXP()
        self.totalXP = xp
        self.xp = CalculateXP(self.totalXP)
        self.rank = CalculateRank(self.totalXP)
        self.stage = CalculateRankStage(self.rank)

        MySQL.Async.execute('UPDATE player_xp SET xp = @xp WHERE identifier = @identifier', {
            ['@identifier'] = self.identifier,
            ['@xp'] = self.getTotalXP()
        })

        MySQL.Async.execute('INSERT INTO player_xpLog (`identifier`, `type`, `change`, `oldXP`, `newXP`, `reason`, `timestamp`) VALUES (@identifier, @type, @change, @oldXP, @newXP, @reason, @timestamp)', {
            ['@identifier'] = self.identifier,
            ['@type'] = 'setXP',
            ['@change'] = xp,
            ['@oldXP'] = LastXP,
            ['@newXP'] = self.getTotalXP(),
            ['@reason'] = reason,
            ['@timestamp'] = os.date('%Y-%m-%d %H:%M:%S', os.time())
        })

        SendDiscordWebhook(self.source, {
            link = Config.DiscordWebhook.setXP,
            includeIdentifiers = true,
            color = Config.DiscordWebhook.WebhookColor,
            thumbnail = Config.DiscordWebhook.WebhookIconURL,
            author = {
                name = Config.DiscordWebhook.WebhookAuthor,
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
            title = "🪙 Set XP",
            description = ("**Player:** `%s` (`%s`)\n**Change:** `%sXP` **->** `%sXP`\n**Rank:** `Level %s`\n**Reason:** `%s`\n**Time:** <t:%s:f> (<t:%s:R>)"):format(GetPlayerName(self.source), self.source, LastXP, self.getTotalXP(), self.getRank(), reason or '/', os.time(), os.time()),
            footer = {
                text  = "Made with ❤️ by Tuncion",
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
        })

        TriggerEvent('tuncion_xp:log:setXP', self.source, { ['newRank'] = LastRank ~= self.getRank(), ['totalXP'] = self.getTotalXP() })
        TriggerClientEvent('tuncion_xp:log:setXP', self.source, { ['newRank'] = LastRank ~= self.getRank(), ['totalXP'] = self.getTotalXP() })
        TriggerClientEvent('tuncion_xp:client:NUIAnim', self.source, {
            ['type'] = 'setXP',
            ['change'] = self.getRank(),
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        })

        return {
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['rankStage'] = self.getRankStage(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        }
    end

    function self.addRank(rank, reason)
        local LastRank = self.getRank()
        local LastXP = self.getTotalXP()
        self.totalXP = CalculateXPToRank(LastRank + rank)
        self.xp = CalculateXP(self.totalXP)
        self.rank = CalculateRank(self.totalXP)
        self.stage = CalculateRankStage(self.rank)

        MySQL.Async.execute('UPDATE player_xp SET xp = @xp WHERE identifier = @identifier', {
            ['@identifier'] = self.identifier,
            ['@xp'] = self.getTotalXP()
        })

        MySQL.Async.execute('INSERT INTO player_xpLog (`identifier`, `type`, `change`, `oldXP`, `newXP`, `reason`, `timestamp`) VALUES (@identifier, @type, @change, @oldXP, @newXP, @reason, @timestamp)', {
            ['@identifier'] = self.identifier,
            ['@type'] = 'addRank',
            ['@change'] = rank,
            ['@oldXP'] = LastXP,
            ['@newXP'] = self.getTotalXP(),
            ['@reason'] = reason,
            ['@timestamp'] = os.date('%Y-%m-%d %H:%M:%S', os.time())
        })

        SendDiscordWebhook(self.source, {
            link = Config.DiscordWebhook.addRank,
            includeIdentifiers = true,
            color = Config.DiscordWebhook.WebhookColor,
            thumbnail = Config.DiscordWebhook.WebhookIconURL,
            author = {
                name = Config.DiscordWebhook.WebhookAuthor,
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
            title = "🥇 Add Rank",
            description = ("**Player:** `%s` (`%s`)\n**Change:** `Level %s` **->** `Level %s`\n**XP:** `%sXP`\n**Reason:** `%s`\n**Time:** <t:%s:f> (<t:%s:R>)"):format(GetPlayerName(self.source), self.source, CalculateRank(LastXP), CalculateRank(self.getTotalXP()), self.getTotalXP(), reason or '/', os.time(), os.time()),
            footer = {
                text  = "Made with ❤️ by Tuncion",
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
        })

        TriggerEvent('tuncion_xp:log:addRank', self.source, { ['rank'] = self.getRank(), ['totalXP'] = self.getTotalXP() })
        TriggerClientEvent('tuncion_xp:log:addRank', self.source, { ['rank'] = self.getRank(), ['totalXP'] = self.getTotalXP() })
        TriggerClientEvent('tuncion_xp:client:NUIAnim', self.source, {
            ['type'] = 'addRank',
            ['change'] = self.getRank(),
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        })

        return {
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['rankStage'] = self.getRankStage(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        }
    end

    function self.removeRank(rank, reason)
        local LastRank = self.getRank()
        local LastXP = self.getTotalXP()
        self.totalXP = CalculateXPToRank(LastRank - rank)
        self.xp = CalculateXP(self.totalXP)
        self.rank = CalculateRank(self.totalXP)
        self.stage = CalculateRankStage(self.rank)

        MySQL.Async.execute('UPDATE player_xp SET xp = @xp WHERE identifier = @identifier', {
            ['@identifier'] = self.identifier,
            ['@xp'] = self.getTotalXP()
        })

        MySQL.Async.execute('INSERT INTO player_xpLog (`identifier`, `type`, `change`, `oldXP`, `newXP`, `reason`, `timestamp`) VALUES (@identifier, @type, @change, @oldXP, @newXP, @reason, @timestamp)', {
            ['@identifier'] = self.identifier,
            ['@type'] = 'removeRank',
            ['@change'] = rank,
            ['@oldXP'] = LastXP,
            ['@newXP'] = self.getTotalXP(),
            ['@reason'] = reason,
            ['@timestamp'] = os.date('%Y-%m-%d %H:%M:%S', os.time())
        })

        SendDiscordWebhook(self.source, {
            link = Config.DiscordWebhook.removeRank,
            includeIdentifiers = true,
            color = Config.DiscordWebhook.WebhookColor,
            thumbnail = Config.DiscordWebhook.WebhookIconURL,
            author = {
                name = Config.DiscordWebhook.WebhookAuthor,
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
            title = "🥇 Remove Rank",
            description = ("**Player:** `%s` (`%s`)\n**Change:** `Level %s` **->** `Level %s`\n**XP:** `%sXP`\n**Reason:** `%s`\n**Time:** <t:%s:f> (<t:%s:R>)"):format(GetPlayerName(self.source), self.source, CalculateRank(LastXP), CalculateRank(self.getTotalXP()), self.getTotalXP(), reason or '/', os.time(), os.time()),
            footer = {
                text  = "Made with ❤️ by Tuncion",
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
        })

        TriggerEvent('tuncion_xp:log:removeRank', self.source, { ['rank'] = self.getRank(), ['totalXP'] = self.getTotalXP() })
        TriggerClientEvent('tuncion_xp:log:removeRank', self.source, { ['rank'] = self.getRank(), ['totalXP'] = self.getTotalXP() })
        TriggerClientEvent('tuncion_xp:client:NUIAnim', self.source, {
            ['type'] = 'removeRank',
            ['change'] = self.getRank(),
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        })

        return {
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['rankStage'] = self.getRankStage(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        }
    end

    function self.setRank(rank, reason)
        local LastRank = self.getRank()
        local LastXP = self.getTotalXP()
        self.totalXP = CalculateXPToRank(rank)
        self.xp = CalculateXP(self.totalXP)
        self.rank = CalculateRank(self.totalXP)
        self.stage = CalculateRankStage(self.rank)

        MySQL.Async.execute('UPDATE player_xp SET xp = @xp WHERE identifier = @identifier', {
            ['@identifier'] = self.identifier,
            ['@xp'] = self.getTotalXP()
        })

        MySQL.Async.execute('INSERT INTO player_xpLog (`identifier`, `type`, `change`, `oldXP`, `newXP`, `reason`, `timestamp`) VALUES (@identifier, @type, @change, @oldXP, @newXP, @reason, @timestamp)', {
            ['@identifier'] = self.identifier,
            ['@type'] = 'setRank',
            ['@change'] = rank,
            ['@oldXP'] = LastXP,
            ['@newXP'] = self.getTotalXP(),
            ['@reason'] = reason,
            ['@timestamp'] = os.date('%Y-%m-%d %H:%M:%S', os.time())
        })

        SendDiscordWebhook(self.source, {
            link = Config.DiscordWebhook.setRank,
            includeIdentifiers = true,
            color = Config.DiscordWebhook.WebhookColor,
            thumbnail = Config.DiscordWebhook.WebhookIconURL,
            author = {
                name = Config.DiscordWebhook.WebhookAuthor,
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
            title = "🥇 Set Rank",
            description = ("**Player:** `%s` (`%s`)\n**Change:** `Level %s` **->** `Level %s`\n**XP:** `%sXP`\n**Reason:** `%s`\n**Time:** <t:%s:f> (<t:%s:R>)"):format(GetPlayerName(self.source), self.source, CalculateRank(LastXP), CalculateRank(self.getTotalXP()), self.getTotalXP(), reason or '/', os.time(), os.time()),
            footer = {
                text  = "Made with ❤️ by Tuncion",
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
        })

        TriggerEvent('tuncion_xp:log:setRank', self.source, { ['rank'] = self.getRank(), ['totalXP'] = self.getTotalXP() })
        TriggerClientEvent('tuncion_xp:log:setRank', self.source, { ['rank'] = self.getRank(), ['totalXP'] = self.getTotalXP() })
        TriggerClientEvent('tuncion_xp:client:NUIAnim', self.source, {
            ['type'] = 'setRank',
            ['change'] = self.getRank(),
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        })

        return {
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['rankStage'] = self.getRankStage(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        }
    end

    function self.resetPlayer()
        local LastRank = self.getRank()
        local LastXP = self.getTotalXP()
        self.totalXP = 0
        self.xp = CalculateXP(self.totalXP)
        self.rank = CalculateRank(self.totalXP)
        self.stage = CalculateRankStage(self.rank)
        self.xpLog = {}

        MySQL.Async.execute('UPDATE player_xp SET xp = @xp WHERE identifier = @identifier', {
            ['@identifier'] = self.identifier,
            ['@xp'] = self.getTotalXP()
        })

        MySQL.Async.execute('DELETE FROM player_xpLog WHERE identifier = @identifier', {
            ['@identifier'] = self.identifier
        })

        SendDiscordWebhook(self.source, {
            link = Config.DiscordWebhook.resetPlayer,
            includeIdentifiers = true,
            color = Config.DiscordWebhook.WebhookColor,
            thumbnail = Config.DiscordWebhook.WebhookIconURL,
            author = {
                name = Config.DiscordWebhook.WebhookAuthor,
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
            title = "🔨 Reset Player",
            description = ("**Player:** `%s` (`%s`)\n**Change:** `%sXP` **->** `%sXP`\n**Rank:** `Level %s`\n**Time:** <t:%s:f> (<t:%s:R>)"):format(GetPlayerName(self.source), self.source, LastXP, self.getTotalXP(), self.getRank(), os.time(), os.time()),
            footer = {
                text  = "Made with ❤️ by Tuncion",
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
        })

        TriggerEvent('tuncion_xp:log:resetPlayer', self.source)
        TriggerClientEvent('tuncion_xp:log:resetPlayer', self.source)

        return {
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['rankStage'] = self.getRankStage(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        }
    end

    function self.resetPlayerXP()
        local LastRank = self.getRank()
        local LastXP = self.getTotalXP()
        self.totalXP = CalculateXPToRank(LastRank)
        self.xp = CalculateXP(self.totalXP)
        self.rank = CalculateRank(self.totalXP)
        self.stage = CalculateRankStage(self.rank)
        self.xpLog = {}

        MySQL.Async.execute('UPDATE player_xp SET xp = @xp WHERE identifier = @identifier', {
            ['@identifier'] = self.identifier,
            ['@xp'] = self.getTotalXP()
        })

        MySQL.Async.execute('DELETE FROM player_xpLog WHERE identifier = @identifier', {
            ['@identifier'] = self.identifier
        })

        SendDiscordWebhook(self.source, {
            link = Config.DiscordWebhook.resetPlayerXP,
            includeIdentifiers = true,
            color = Config.DiscordWebhook.WebhookColor,
            thumbnail = Config.DiscordWebhook.WebhookIconURL,
            author = {
                name = Config.DiscordWebhook.WebhookAuthor,
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
            title = "🔨 Reset Player XP",
            description = ("**Player:** `%s` (`%s`)\n**Change:** `%sXP` **->** `%sXP`\n**Rank:** `Level %s`\n**Time:** <t:%s:f> (<t:%s:R>)"):format(GetPlayerName(self.source), self.source, LastXP, self.getTotalXP(), self.getRank(), os.time(), os.time()),
            footer = {
                text  = "Made with ❤️ by Tuncion",
                icon_url = Config.DiscordWebhook.WebhookIconURL
            },
        })

        TriggerEvent('tuncion_xp:log:resetPlayerXP', self.source, { ['rank'] = self.getRank(), ['totalXP'] = self.getTotalXP() })
        TriggerClientEvent('tuncion_xp:log:resetPlayerXP', self.source, { ['rank'] = self.getRank(), ['totalXP'] = self.getTotalXP() })

        return {
            ['newRank'] = LastRank ~= self.getRank(),
            ['rank'] = self.getRank(),
            ['rankStage'] = self.getRankStage(),
            ['totalXP'] = self.getTotalXP(),
            ['xp'] = self.getXP(),
            ['xpLog'] = self.getXPLog()
        }
    end

    return self
end

function CalculateRank(xp)
    local rank = Config.DefaultLevel
    local xpNeeded = Config.XPLevelThreshold

    while xp >= xpNeeded do
        rank = rank + 1
        xp = xp - xpNeeded
        xpNeeded = xpNeeded + Config.XPIncreasement
    end

    return rank
end

function CalculateXP(xp)
    local rank = Config.DefaultLevel
    local xpNeeded = Config.XPLevelThreshold

    while xp >= xpNeeded do
        rank = rank + 1
        xp = xp - xpNeeded
        xpNeeded = xpNeeded + Config.XPIncreasement
    end

    return xp
end

function CalculateXPToRank(rank)
    local xp = 0
    local xpNeeded = Config.XPLevelThreshold

    while rank > 1 do
        xp = xp + xpNeeded
        xpNeeded = xpNeeded + Config.XPIncreasement
        rank = rank - 1
    end

    return xp
end

function CalculateNeededXPToUprank(xp)
    local rank = Config.DefaultLevel
    local xpNeeded = Config.XPLevelThreshold

    while xp >= xpNeeded do
        rank = rank + 1
        xp = xp - xpNeeded
        xpNeeded = xpNeeded + Config.XPIncreasement
    end

    return math.floor(xpNeeded - xp)
end

function CalculateRankStage(level)
    local stage = nil
    local minLevel = 0
    for k, v in pairs(Config.RankStage) do
        if minLevel < k then
            if level >= k then
                stage = v
                minLevel = k
            end
        end
    end
    return stage
end

function SendDiscordWebhook(source, WebhookData)
    local source = source;
    local EmbedDataArray = {};
    local EmbedData = {};

    EmbedData.color = WebhookData.color;

    if WebhookData.author then
        EmbedData.author = {};
        EmbedData.author.name = WebhookData.author.name;
        EmbedData.author.icon_url = WebhookData.author.icon_url;
    end;

    if WebhookData.title then
        EmbedData.title = WebhookData.title;
    end;

    if WebhookData.thumbnail then
        EmbedData.thumbnail = {};
        EmbedData.thumbnail.url = WebhookData.thumbnail;
    end;

    if WebhookData.includeIdentifiers then
        EmbedData.description = WebhookData.description .. GetIdentifierString(source);
    else
        EmbedData.description = WebhookData.description;
    end;

    if WebhookData.footer then
        EmbedData.footer = {};
        EmbedData.footer.text = WebhookData.footer.text;
        EmbedData.footer.icon_url = WebhookData.footer.icon_url;
    end;

    table.insert(EmbedDataArray, EmbedData);

    PerformHttpRequest(WebhookData.link, function(err, text, headers) end, 'POST', json.encode({embeds = EmbedDataArray}), { ['Content-Type'] = 'application/json' })
end

function GetIdentifierString(source)
    local source = source;
    local CurrentStringData = '```';
    CurrentStringData = CurrentStringData .. '\n' .. 'ID: ' .. source;
    CurrentStringData = CurrentStringData .. '\n' .. 'Ping: ' .. GetPlayerPing(source) .. 'ms';

    -- Add Identifiers
    local CurrentLicense = false;
    local CurrentSteamID = false;
    local CurrentDiscordID = false;
    local CurrentXboxID = false;
    local CurrentLiveID	= false;
    local CurrentIPv4 = false;

    for k,v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            CurrentLicense = v:gsub('license:', '');
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            CurrentSteamID = v:gsub('steam:', '');
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            CurrentDiscordID = v:gsub('discord:', '');
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            CurrentXboxID  = v:gsub('xbl:', '');
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            CurrentLiveID = v:gsub('live:', '');
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            CurrentIPv4 = v:gsub('ip:', '');
        end;
    end;

    if CurrentLicense then
        CurrentStringData = CurrentStringData .. '\n' .. 'Identifier: ' .. CurrentLicense;
    end;

    if GetPlayerName(source) then
        CurrentStringData = CurrentStringData .. '\n' .. 'SteamName: ' .. GetPlayerName(source);
    end;

    if CurrentSteamID then
        CurrentStringData = CurrentStringData .. '\n' .. 'SteamID: ' .. CurrentSteamID;
    end;

    if CurrentDiscordID then
        CurrentStringData = CurrentStringData .. '\n' .. 'DiscordID: ' .. CurrentDiscordID;
    end;

    if CurrentXboxID then
        CurrentStringData = CurrentStringData .. '\n' .. 'XboxID: ' .. CurrentXboxID;
    end;

    if CurrentLiveID then
        CurrentStringData = CurrentStringData .. '\n' .. 'LiveID: ' .. CurrentLiveID;
    end;

    if CurrentIPv4 then
        CurrentStringData = CurrentStringData .. '\n' .. 'IPv4: ' .. CurrentIPv4;
    end;

    CurrentStringData = CurrentStringData .. '\n' .. '```';
    return CurrentStringData;
end