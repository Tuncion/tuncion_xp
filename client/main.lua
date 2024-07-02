-- NUI Animation Event Handler
RegisterNetEvent('tuncion_xp:client:NUIAnim')
AddEventHandler('tuncion_xp:client:NUIAnim', function(data)
    local Type = data.type
    local Change = data.change
    local NewRank = data.newRank
    local Rank = data.rank

    if Type == 'addXP' then
        SendNUIMessage({ type = 'addXP', change = Change })
        if NewRank then
            Citizen.Wait(750)
            SendNUIMessage({ type = 'newRank', change = Rank })
        end
    elseif Type == 'removeXP' then
        SendNUIMessage({ type = 'removeXP', change = Change })
        if NewRank then
            Citizen.Wait(750)
            SendNUIMessage({ type = 'newRank', change = Change })
        end
    elseif Type == 'addRank' or Type == 'removeRank' or Type == 'setRank' or Type == 'setXP' then
        if NewRank then
            SendNUIMessage({ type = 'newRank', change = Change })
        end
    end
end)

-- Notification Event Handler
RegisterNetEvent('tuncion_xp:client:Notify')
AddEventHandler('tuncion_xp:client:Notify', function(msg)
    ShowNotify(msg)
end)

-- Notify Function
function ShowNotify(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(false, true)
end
