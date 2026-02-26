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

RegisterNetEvent("L-foodelivery:buyDeliveryItem", function(quantity)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    quantity = math.floor(tonumber(quantity) or 0)
    if quantity <= 0 then return end

    local total = quantity * Config_FoodDelivery.ItemPrice
    local cash  = Player.PlayerData.money['cash']
    local bank  = Player.PlayerData.money['bank']

    if cash >= total then
        Player.Functions.RemoveMoney('cash', total, 'bought_delivery_item')
        AddItem(src, Config_FoodDelivery.DeliveryItem, quantity)
        TriggerClientEvent('QBCore:Notify', src, 'Bought ' .. quantity .. 'x ' .. Config_FoodDelivery.DeliveryItem .. ' for $' .. total .. ' (cash).', 'success')
    elseif bank >= total then
        Player.Functions.RemoveMoney('bank', total, 'bought_delivery_item')
        AddItem(src, Config_FoodDelivery.DeliveryItem, quantity)
        TriggerClientEvent('QBCore:Notify', src, 'Bought ' .. quantity .. 'x ' .. Config_FoodDelivery.DeliveryItem .. ' for $' .. total .. ' (bank).', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Not enough money! Total cost: $' .. total .. '.', 'error')
    end
end)

RegisterNetEvent("L-foodelivery:applyVehicleLostFine", function()
    local src = source
    if not ActiveDeliveries[src] then return end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Fine is applied regardless of available balance (requirement: deduct $5000 no matter what)
    local currentBank = Player.PlayerData.money['bank']
    Player.Functions.SetMoney('bank', currentBank - 5000, 'delivery_vehicle_lost_fine')
    TriggerClientEvent('QBCore:Notify', src, 'You lost the delivery vehicle! $5,000 has been deducted from your bank account.', 'error')

    ActiveDeliveries[src] = nil
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
