Config = {}

Config.DefaultLevel = 1 -- Default Level for new players
Config.XPLevelThreshold = 100 -- XP needed to level up
Config.XPIncreasement = 25 -- XP Increasement for each Level (Level 1: 100 XP, Level 2: 125 XP, Level 3: 150 XP, etc.)
Config.XPLogLimit = 15 -- How many XP Logs should be stored internal
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