# tuncion_xp
A complete XP Handler with a lot of features for FiveM

See the Documentation: https://docs.tuncion.de/scripts/tuncion-xp

# Installation
1. Download the latest version from [here](https://github.com/Tuncion/tuncion_xp)
2. Upload to your server
3. Add `ensure tuncion_xp` to your server.cfg
4. Insert the SQL File into your Database
5. Restart your server (or start the resource)

# Features
- [x] XP Handler inclusive Level System
- [x] Lot of exports
- [x] XP Log System
- [x] Discord Webhooks for each export
- [x] NUI Notify

# Exports

**Getter**
- getGlobalXP
- getGlobalRank
- getTotalXP
- getXP
- getNeededXP
- getRank
- getRankStage
- getXPLog
 
**Setter**
- addXP
- removeXP
- setXP
- addRank
- removeRank
- setRank
- resetPlayer
- resetPlayerXP

# Events

| Event                          | Type           | Description                                  | Parameter                                       |
|--------------------------------|----------------|----------------------------------------------|-------------------------------------------------|
| `tuncion_xp:log:addXP`         | **Serverside** | Event occurs when a player gains XP          | `source`, `{ newRank: Bool, change: Integer }`  |
| `tuncion_xp:log:removeXP`      | **Serverside** | Event occurs when a player loses XP          | `source`, `{ newRank: Bool, change: Integer }`  |
| `tuncion_xp:log:setXP`         | **Serverside** | Event occurs when a player's XP is set       | `source`, `{ newRank: Bool, totalXP: Integer }` |
| `tuncion_xp:log:addRank`       | **Serverside** | Event occurs when a player's rank is added   | `source`, `{ rank: Integer, totalXP: Integer }` |
| `tuncion_xp:log:removeRank`    | **Serverside** | Event occurs when a player's rank is removed | `source`, `{ rank: Integer, totalXP: Integer }` |
| `tuncion_xp:log:setRank`       | **Serverside** | Event occurs when a player's rank is set     | `source`, `{ rank: Integer, totalXP: Integer }` |
| `tuncion_xp:log:resetPlayer`   | **Serverside** | Event occurs when a player is reset          | `source`                                        |
| `tuncion_xp:log:resetPlayerXP` | **Serverside** | Event occurs when a player's XP is reset     | `source`, `{ rank: Integer, totalXP: Integer }` |
| `tuncion_xp:log:addXP`         | **Clientside** | Event occurs when a player gains XP          | `{ newRank: Bool, change: Integer }`            |
| `tuncion_xp:log:removeXP`      | **Clientside** | Event occurs when a player loses XP          | `{ newRank: Bool, change: Integer }`            |
| `tuncion_xp:log:setXP`         | **Clientside** | Event occurs when a player's XP is set       | `{ newRank: Bool, totalXP: Integer }`           |
| `tuncion_xp:log:addRank`       | **Clientside** | Event occurs when a player's rank is added   | `{ rank: Integer, totalXP: Integer }`           |
| `tuncion_xp:log:removeRank`    | **Clientside** | Event occurs when a player's rank is removed | `{ rank: Integer, totalXP: Integer }`           |
| `tuncion_xp:log:setRank`       | **Clientside** | Event occurs when a player's rank is set     | `{ rank: Integer, totalXP: Integer }`           |
| `tuncion_xp:log:resetPlayer`   | **Clientside** | Event occurs when a player is reset          | /                                               |
| `tuncion_xp:log:resetPlayerXP` | **Clientside** | Event occurs when a player's XP is reset     | `{ rank: Integer, totalXP: Integer }`           |

# Images

**🪙 Gain XP**\
![AddXP](https://i.imgur.com/3sEH9nx.gif)

**📈 Remove XP**\
![RemoveXP](https://i.imgur.com/YackvQQ.gif)

**🚀 Reach new Level**\
![ReachLevel](https://i.imgur.com/Ox8TBbT.gif)

**👀 Webhooks for each export**\
![NotifyWebhook](https://i.imgur.com/K54u0yM.png)\
_This is just a example for [addXP](https://docs.tuncion.de/scripts/tuncion-xp/server/setter/addxp)_

# To Do
- [x] Add Events
- [x] Export: neededXP
- [ ] Level Multiplier
- [x] Level Stages
- [x] Command: See own Level
- [ ] XP Categories
- [ ] XP Categories Front-End