# 🌟 tuncion_xp  
A complete XP & Level system for FiveM with rich features and full customization.  

📖 **Documentation:** [docs.tuncion.de/scripts/tuncion-xp](https://docs.tuncion.de/scripts/tuncion-xp)  

---

## 🚀 Installation  
1. Download the latest release from [here](https://github.com/Tuncion/tuncion_xp/releases)  
2. Upload to your server  
3. Add `ensure tuncion_xp` to your `server.cfg`  
4. Import the SQL file into your database  
5. Restart your server (or start the resource)

---

## ✨ Features  
- [x] Complete XP handler with **Level System**  
- [x] Multiple **exports** for developers  
- [x] Built-in **XP log system**  
- [x] **Discord Webhooks** for every export  
- [x] Clean **NUI notifications**  

---

## 🖼️ Images  

**🪙 Gain XP**  
![AddXP](https://i.imgur.com/3sEH9nx.gif)  

**📈 Remove XP**  
![RemoveXP](https://i.imgur.com/YackvQQ.gif)  

**🚀 Reach new Level**  
![ReachLevel](https://i.imgur.com/Ox8TBbT.gif)  

**👀 Webhooks for each export**  
![NotifyWebhook](https://i.imgur.com/K54u0yM.png)  
_Example for [addXP](https://docs.tuncion.de/scripts/tuncion-xp/server/setter/addxp)_  


---

## 🔌 Scripts with Built-In Integration  

The following **FiveM Scripts** already include automatic XP integration out of the box:  

- 🚔 **[Dream Police Impound (dream_policeimpound)](https://github.com/Dream-Services/dream_policeimpound)** **(🆓 Free)**
- 🪙 **[Dream Cryptomining (dream_cryptomining)](https://shop.dream-services.eu/shop/product/6243620)**  
- 🚙 **[Dream Fakeplates (dream_fakeplates)](https://shop.dream-services.eu/shop/product/6235257)**  
- ♻️ **[Dream Junkyard (dream_junkyard)](https://shop.dream-services.eu/shop/product/6989336)**  
- 🔌 **[Dream Solarjob (dream_solarjob)](https://shop.dream-services.eu/shop/product/6543495)**  
- ⚡ **[Dream Solarsystem (dream_solarsystems)](https://shop.dream-services.eu/shop/product/6547610)**  
- 🚗 **[Dream Used Cardealer (dream_usedcardealer)](https://shop.dream-services.eu/shop/product/6782499)**  
- 🎰 **[Dream Vending (dream_vending)](https://shop.dream-services.eu/shop/product/6859945)**  

💡 Community-made integrations are also welcome!  
If you’ve created an integration, feel free to **contact us to have it added to this list**.  


---

## 🛠️ Exports  

**Getter**  
- `getGlobalXP`  
- `getGlobalRank`  
- `getTotalXP`  
- `getXP`  
- `getNeededXP`  
- `getRank`  
- `getRankStage`  
- `getXPLog`  

**Setter**  
- `addXP`  
- `removeXP`  
- `setXP`  
- `addRank`  
- `removeRank`  
- `setRank`  
- `resetPlayer`  
- `resetPlayerXP`  

---

## 📡 Events  

| Event                          | Type           | Description                                  | Parameter                                       |
|--------------------------------|----------------|----------------------------------------------|-------------------------------------------------|
| `tuncion_xp:log:addXP`         | **Server**     | Triggered when a player gains XP             | `source`, `{ newRank: Bool, change: Integer }`  |
| `tuncion_xp:log:removeXP`      | **Server**     | Triggered when a player loses XP             | `source`, `{ newRank: Bool, change: Integer }`  |
| `tuncion_xp:log:setXP`         | **Server**     | Triggered when a player's XP is set          | `source`, `{ newRank: Bool, totalXP: Integer }` |
| `tuncion_xp:log:addRank`       | **Server**     | Triggered when a player's rank is added      | `source`, `{ rank: Integer, totalXP: Integer }` |
| `tuncion_xp:log:removeRank`    | **Server**     | Triggered when a player's rank is removed    | `source`, `{ rank: Integer, totalXP: Integer }` |
| `tuncion_xp:log:setRank`       | **Server**     | Triggered when a player's rank is set        | `source`, `{ rank: Integer, totalXP: Integer }` |
| `tuncion_xp:log:resetPlayer`   | **Server**     | Triggered when a player is reset             | `source`                                        |
| `tuncion_xp:log:resetPlayerXP` | **Server**     | Triggered when a player's XP is reset        | `source`, `{ rank: Integer, totalXP: Integer }` |
| `tuncion_xp:log:addXP`         | **Client**     | Triggered when a player gains XP             | `{ newRank: Bool, change: Integer }`            |
| `tuncion_xp:log:removeXP`      | **Client**     | Triggered when a player loses XP             | `{ newRank: Bool, change: Integer }`            |
| `tuncion_xp:log:setXP`         | **Client**     | Triggered when a player's XP is set          | `{ newRank: Bool, totalXP: Integer }`           |
| `tuncion_xp:log:addRank`       | **Client**     | Triggered when a player's rank is added      | `{ rank: Integer, totalXP: Integer }`           |
| `tuncion_xp:log:removeRank`    | **Client**     | Triggered when a player's rank is removed    | `{ rank: Integer, totalXP: Integer }`           |
| `tuncion_xp:log:setRank`       | **Client**     | Triggered when a player's rank is set        | `{ rank: Integer, totalXP: Integer }`           |
| `tuncion_xp:log:resetPlayer`   | **Client**     | Triggered when a player is reset             | /                                               |
| `tuncion_xp:log:resetPlayerXP` | **Client**     | Triggered when a player's XP is reset        | `{ rank: Integer, totalXP: Integer }`           |

---

## 📌 To Do  
- [x] Add Events  
- [x] Export: neededXP  
- [ ] Level Multiplier  
- [x] Level Stages  
- [x] Command: View own Level  
- [ ] XP Categories  
- [ ] XP Categories Front-End  
