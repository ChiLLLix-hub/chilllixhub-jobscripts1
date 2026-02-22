local drivers = {}

RegisterServerEvent("nexus-delivery:delivery_duty")
AddEventHandler("nexus-delivery:delivery_duty", function(onDuty)
    local src = source
    if onDuty then
        drivers[src] = GetGameTimer()
    else
        drivers[src] = nil
    end
end)

RegisterServerEvent("nexus-delivery:delivery_complete")
AddEventHandler("nexus-delivery:delivery_complete", function()
    local src = source
    local QBCore = exports["qb-core"]:GetCoreObject()
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if drivers[src] and drivers[src] < GetGameTimer() then
        drivers[src] = GetGameTimer() + 5000
        local payoutAmount = Config.Payouts[math.random(#Config.Payouts)]()
        Player.Functions.AddMoney("bank", payoutAmount, "Delivery Job")
    end
end)

RegisterServerEvent("nexus-delivery:delivery_getroutes")
AddEventHandler("nexus-delivery:delivery_getroutes", function()
    local src = source
    TriggerClientEvent("nexus-delivery:delivery_routes", src, Config.DropOffs)
end)
