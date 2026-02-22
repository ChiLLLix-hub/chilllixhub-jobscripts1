local QBCore = exports['qb-core']:GetCoreObject()

function HasItem(src, item)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player and Player.Functions.GetItemByName(item) ~= nil
end

function RemoveItem(src, item, amount)
    amount = amount or 1
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end
    return Player.Functions.RemoveItem(item, amount)
end

function AddItem(src, item, amount, meta)
    amount = amount or 1
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end
    return Player.Functions.AddItem(item, amount, false, meta)
end

function AddMoney(src, account, amount, reason)
    account = account or 'bank'
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end
    Player.Functions.AddMoney(account, amount, reason or 'food_delivery')
    return true
end

-- Target helpers (qb-target only)
function AddTargetToEntity(entity, label, icon, action)
    exports['qb-target']:AddTargetEntity(entity, {
        options = {{
            icon   = icon or 'fa-solid fa-box',
            label  = label or 'Start Delivery',
            action = action
        }},
        distance = 2.0
    })
end

function RemoveTargetFromEntity(entity)
    exports['qb-target']:RemoveTargetEntity(entity)
end
