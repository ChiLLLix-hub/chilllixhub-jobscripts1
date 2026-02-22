local dTruck = nil
local destBlip = nil
local hasPackage = false
local box = nil
local firstDest = true
local isOnDeliveryDuty = false
local myJobPoint = 1
local drops = {}
local currentDest = nil

-- ─────────────────────────────────────────────────────────────────────────────
-- Job-location blips + qb-target zones (start / end duty)
-- ─────────────────────────────────────────────────────────────────────────────
Citizen.CreateThread(function()
    for k, b in pairs(Config.JobLoc) do
        local blip = AddBlipForCoord(b.v)
        SetBlipSprite(blip, 351)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 1.2)
        SetBlipColour(blip, 43)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Delivery Job")
        EndTextCommandSetBlipName(blip)

        exports['qb-target']:AddCircleZone("nexus_delivery_job_" .. k, b.v, 3.0, {
            name = "nexus_delivery_job_" .. k,
            debugPoly = Config.Debug,
            useZ = false,
        }, {
            options = {
                {
                    type = "client",
                    event = "nexus-delivery:client:startJob",
                    icon = "fas fa-truck",
                    label = "Start Delivery Job",
                    canInteract = function()
                        return not isOnDeliveryDuty and not IsPedInAnyVehicle(PlayerPedId())
                    end,
                    jobNum = k,
                },
                {
                    type = "client",
                    event = "nexus-delivery:client:endJob",
                    icon = "fas fa-times-circle",
                    label = "End Delivery Job",
                    canInteract = function() return isOnDeliveryDuty end,
                },
            },
            distance = 3.0,
        })
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- qb-target event handlers
-- ─────────────────────────────────────────────────────────────────────────────
RegisterNetEvent("nexus-delivery:client:startJob")
AddEventHandler("nexus-delivery:client:startJob", function(data)
    StartDeliveryJob(PlayerPedId(), data.jobNum)
end)

RegisterNetEvent("nexus-delivery:client:endJob")
AddEventHandler("nexus-delivery:client:endJob", function()
    DelTruckGoOffDuty()
end)

RegisterNetEvent("nexus-delivery:client:pickupPackage")
AddEventHandler("nexus-delivery:client:pickupPackage", function()
    if hasPackage or not dTruck then return end
    local ped = PlayerPedId()
    LoadAnimation("anim@heists@box_carry@")
    TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 5.0, -1, -1, 50, 0, false, false, false)
    box = CreateObject(GetHashKey("prop_cs_cardbox_01"), GetEntityCoords(ped), true, false, true)
    AttachEntityToEntity(box, ped, GetPedBoneIndex(ped, 18905), 0.04, 0.04, 0.28, 52.0, 294.0, 177.0, 20.0, true, true, false, true, 1.0, true)
    hasPackage = true
    if Config.Debug then
        local coords = GetEntityCoords(ped)
        print("^5Debug^7: ^1Prop ^2Pick-Up^7: '^6".."prop_cs_cardbox_01".."^7' | ^2Hash^7: ^7'^6"..(GetHashKey("prop_cs_cardbox_01")).."^7' | ^2Coord^7: ^5vec3^7(^6"..(coords.x).."^7, ^6"..(coords.y).."^7, ^6"..(coords.z).."^7)")
    end
end)

RegisterNetEvent("nexus-delivery:client:dropPackage")
AddEventHandler("nexus-delivery:client:dropPackage", function()
    if not hasPackage then return end
    local ped = PlayerPedId()
    DropPackage()
    ClearPedTasks(ped)
    exports['qb-target']:RemoveZone("nexus_delivery_dropoff")
    TriggerServerEvent("nexus-delivery:delivery_complete")
    if #drops > 0 then
        lib.notify({ title = 'Post OP', description = 'Head to next delivery.', type = 'inform' })
        NextDestination()
    else
        lib.notify({ title = 'Post OP', description = 'All deliveries complete! Return to base.', type = 'success' })
        FinishedRoute()
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Delivery route event (server → client)
-- ─────────────────────────────────────────────────────────────────────────────
RegisterNetEvent("nexus-delivery:delivery_routes")
AddEventHandler("nexus-delivery:delivery_routes", function(places)
    local myPos = GetEntityCoords(PlayerPedId())
    drops = {}
    for _, v in pairs(places) do
        local vec = vector3(v.x, v.y, v.z)
        if #(myPos - vec) < 4000 then
            table.insert(drops, vec)
        end
    end
    PickDestination()
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────────────────────────
function LoadAnimation(dict)
    if not HasAnimDictLoaded(dict) then
        if Config.Debug then
            print("^5Debug^7: ^2Loading Anim Dictionary^7: '^6" .. dict .. "^7'")
        end
        while not HasAnimDictLoaded(dict) do
            RequestAnimDict(dict)
            Citizen.Wait(5)
        end
    end
end

function compare(a, b)
    return a.d < b.d
end

function RecalculateDistance()
    local temp = drops
    drops = {}
    local myPos = GetEntityCoords(PlayerPedId())
    for _, v in pairs(temp) do
        local dist = GetDistanceBetweenCoords(myPos.x, myPos.y, myPos.z, v.x, v.y, v.z, false)
        table.insert(drops, { x = v.x, y = v.y, z = v.z, d = dist })
    end
    table.sort(drops, compare)
end

function SetDestination(d)
    currentDest = d
    SetNewWaypoint(d.x, d.y)
    if DoesBlipExist(destBlip) then
        RemoveBlip(destBlip)
    end
    destBlip = AddBlipForCoord(d.x, d.y, 0.0)
    SetBlipSprite(destBlip, 66)
    SetBlipDisplay(destBlip, 2)
    SetBlipScale(destBlip, 1.0)
    SetBlipColour(destBlip, 10)
    SetBlipAsShortRange(destBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Delivery")
    EndTextCommandSetBlipName(destBlip)

    exports['qb-target']:RemoveZone("nexus_delivery_dropoff")
    exports['qb-target']:AddCircleZone("nexus_delivery_dropoff", vector3(d.x, d.y, d.z), 2.0, {
        name = "nexus_delivery_dropoff",
        debugPoly = Config.Debug,
        useZ = false,
    }, {
        options = {
            {
                type = "client",
                event = "nexus-delivery:client:dropPackage",
                icon = "fas fa-box-open",
                label = "Drop Off Package",
                canInteract = function() return hasPackage end,
            },
        },
        distance = 2.0,
    })
end

function FinishedRoute()
    SetWaypointOff()
    currentDest = nil
    if DoesBlipExist(destBlip) then
        RemoveBlip(destBlip)
    end
    exports['qb-target']:RemoveZone("nexus_delivery_dropoff")
end

function NextDestination()
    if #drops > 0 then
        PickDestination()
    else
        FinishedRoute()
    end
end

function PickDestination()
    local dropNum = 1
    if firstDest then
        dropNum = math.random(#drops)
        firstDest = false
    else
        RecalculateDistance()
    end
    local destination = table.remove(drops, dropNum)
    SetWaypointOff()
    SetDestination(destination)
end

function DropPackage()
    if not hasPackage then return end
    if box then
        DeleteObject(box)
        box = nil
    end
    local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.32, 0.0, -0.07)
    local tempBox = CreateObject(GetHashKey("prop_cs_cardbox_01"), offset.x, offset.y, offset.z, true, false, true)
    ActivatePhysics(tempBox)
    FreezeEntityPosition(tempBox, false)
    hasPackage = false
    if Config.Debug then
        print("^5Debug^7: ^1Prop ^2Drop-off^7: '^6".."prop_cs_cardbox_01".."^7' | ^2Hash^7: ^7'^6"..(GetHashKey("prop_cs_cardbox_01")).."^7' | ^2Coord^7: ^5vec3^7(^6"..(offset.x).."^7, ^6"..(offset.y).."^7, ^6"..(offset.z).."^7)")
    end
    Citizen.CreateThread(function()
        Citizen.Wait(30000)
        if DoesEntityExist(tempBox) then
            DeleteObject(tempBox)
        end
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Start / stop delivery job
-- ─────────────────────────────────────────────────────────────────────────────
function StartDeliveryJob(ped, sNum)
    DoScreenFadeOut(400)
    Citizen.Wait(600)

    if dTruck then
        TaskLeaveVehicle(ped, dTruck, 16)
        DeleteVehicle(dTruck)
        dTruck = nil
    end

    local veh = GetHashKey(Config.JobLoc[sNum].veh)
    RequestModel(veh)
    while not HasModelLoaded(veh) do
        Citizen.Wait(1)
    end

    dTruck = CreateVehicle(veh, Config.Spawns[sNum].x, Config.Spawns[sNum].y, Config.Spawns[sNum].z, Config.Spawns[sNum].w, true, false)

    if Config.Debug then
        print("^5Debug^7: ^1Vehicle ^2Spawned^7: '^6"..Config.JobLoc[sNum].veh.."^7' | ^2Hash^7: ^7'^6"..veh.."^7' | ^2Coord^7: ^5vec3^7(^6"..Config.Spawns[sNum].x.."^7, ^6"..Config.Spawns[sNum].y.."^7, ^6"..Config.Spawns[sNum].z.."^7, ^6"..Config.Spawns[sNum].w.."^7)")
    end

    Citizen.Wait(100)
    DecorRegister("OwnerId", 3)
    DecorSetInt(dTruck, "OwnerId", GetPlayerServerId(PlayerId()))
    SetVehicleOnGroundProperly(dTruck)
    SetVehicleColours(dTruck, 112, 83)
    SetModelAsNoLongerNeeded(veh)
    SetEntityAsMissionEntity(dTruck, true, true)
    SetPedIntoVehicle(ped, dTruck, -1)

    local QBCore = exports["qb-core"]:GetCoreObject()
    TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(dTruck))

    exports['qb-target']:AddTargetEntity(dTruck, {
        options = {
            {
                type = "client",
                event = "nexus-delivery:client:pickupPackage",
                icon = "fas fa-box",
                label = "Pick Up Package",
                canInteract = function()
                    return not hasPackage and not IsPedInVehicle(PlayerPedId(), dTruck)
                end,
            },
        },
        distance = 2.5,
    })

    isOnDeliveryDuty = true
    TriggerServerEvent("nexus-delivery:delivery_getroutes")
    lib.notify({ title = 'Post OP', description = 'Head to your destination and complete the job!', type = 'inform' })
    TriggerServerEvent("nexus-delivery:delivery_duty", true)
    myJobPoint = sNum

    DoScreenFadeIn(1000)
    Citizen.Wait(400)
end

function DelTruckGoOffDuty()
    isOnDeliveryDuty = false
    currentDest = nil

    if dTruck then
        if IsPedInAnyVehicle(PlayerPedId()) then
            TaskLeaveVehicle(PlayerPedId(), dTruck, 16)
            Citizen.Wait(100)
        end
        DeleteVehicle(dTruck)
        dTruck = nil
    end

    if box then
        DeleteObject(box)
        box = nil
    end
    hasPackage = false

    exports['qb-target']:RemoveZone("nexus_delivery_dropoff")
    drops = {}
    firstDest = true
    SetWaypointOff()
    if DoesBlipExist(destBlip) then
        RemoveBlip(destBlip)
    end
    lib.notify({ title = 'Post OP', description = 'Come again soon.', type = 'inform' })
    TriggerServerEvent("nexus-delivery:delivery_duty", false)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Main render loop: destination marker + auto-drop while on duty.
-- Sleeps longer when off duty to avoid unnecessary CPU use.
-- ─────────────────────────────────────────────────────────────────────────────
Citizen.CreateThread(function()
    DoScreenFadeIn(100)
    while true do
        if not isOnDeliveryDuty then
            Citizen.Wait(500)
        else
            Citizen.Wait(0)
            if currentDest then
                DrawMarker(1, currentDest.x, currentDest.y, currentDest.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 1.25, 0, 255, 0, 90, false, false, 1.0, false)
            end
            if hasPackage then
                local ped = PlayerPedId()
                if IsPlayerFreeAiming(ped) then
                    DropPackage()
                elseif IsControlJustPressed(1, 24) or IsControlJustPressed(1, 25) then
                    if GetSelectedPedWeapon(PlayerPedId()) ~= -1569615261 then
                        DropPackage()
                    end
                elseif IsControlJustPressed(1, 23) or IsControlJustPressed(1, 45) then
                    if GetSelectedPedWeapon(PlayerPedId()) ~= -1569615261 then
                        DropPackage()
                    end
                elseif IsPedInAnyVehicle(ped, true) then
                    DropPackage()
                end
            end
        end
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Distance-check loop (low frequency – runs every 2 s while on duty).
-- Kicks player off duty if they stray too far from the truck without a package.
-- ─────────────────────────────────────────────────────────────────────────────
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        if isOnDeliveryDuty and dTruck and not hasPackage then
            if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(dTruck)) > 80.0 then
                DelTruckGoOffDuty()
            end
        end
    end
end)
