local QBCore = exports['qb-core']:GetCoreObject()
local ActiveDeliveries = {}

RegisterNetEvent("L-foodelivery:registerDelivery", function()
    local src = source
    ActiveDeliveries[src] = true
end)

RegisterNetEvent("L-foodelivery:tryDeliver", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not ActiveDeliveries[src] then
        print("[Lcts] Player " .. src .. " nak duit free werk werk.")
        DropPlayer(src, "FARM ELOK-ELOK JANGAN NAK DUIT FREE.")
        return
    end

    -- Legitimate delivery check
    if HasItem(src, Config_FoodDelivery.DeliveryItem) then
        RemoveItem(src, Config_FoodDelivery.DeliveryItem, 1)
        AddMoney(src, 'cash', Config_FoodDelivery.DeliveryReward)
        TriggerClientEvent("L-foodelivery:completeDelivery", src)
    else
        TriggerClientEvent("L-foodelivery:failDelivery", src)
    end

    -- Clear flag so they can't repeat-reward
    ActiveDeliveries[src] = nil
end)

RegisterNetEvent("L-foodelivery:buyDeliveryItem", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local price = Config_FoodDelivery.ItemPrice
    local cash = Player.PlayerData.money['cash']

    if cash >= price then
        Player.Functions.RemoveMoney('cash', price, 'bought_delivery_item')
        AddItem(src, Config_FoodDelivery.DeliveryItem, 1)
        TriggerClientEvent('QBCore:Notify', src, 'You bought a ' .. Config_FoodDelivery.DeliveryItem .. ' for $' .. price .. '.', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'You do not have enough cash. Need $' .. price .. '.', 'error')
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    ActiveDeliveries[src] = nil
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        print("^1[INFO]^0 L-foodelivery server script stopped.")
    end
end)
