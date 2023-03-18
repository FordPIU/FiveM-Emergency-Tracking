local aBlips = nil
local function AccurateTrack()
    if aBlips ~= nil then
        for _,v in pairs(aBlips) do
            RemoveBlip(v)
        end
        aBlips = nil
    else
        local GamePool = GetGamePool('CVehicle')
        aBlips = {}

        for i,v in pairs(GamePool) do
            if GetVehicleClass(v) == 18 then
                local Coords = GetEntityCoords(v)
                local b = AddBlipForCoord(Coords[1], Coords[2], Coords[3])
                SetBlipSprite(b, 225)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Emergency Vehicle')
                EndTextCommandSetBlipName(b)
                table.insert(aBlips, b)
            end
        end
    end
end

local uBlips = nil
local function UnaccurateTrack()
    if uBlips ~= nil then
        for _,v in pairs(uBlips) do
            RemoveBlip(v)
        end
        uBlips = nil
    else
        local GamePool = GetGamePool('CVehicle')
        uBlips = {}

        for i,v in pairs(GamePool) do
            if GetVehicleClass(v) == 18 then
                local Coords = GetEntityCoords(v)
                local b = AddBlipForRadius(Coords[1] + math.random(-50, 50), Coords[2] + math.random(-50, 50), Coords[3], 200.0)
                SetBlipAlpha(b, 60)
                table.insert(uBlips, b)
            end
        end
    end
end

local is1Tracking = false
local is2Tracking = false
local function ToggleTracking(type, toggle)
    if type == 1 then
        is1Tracking = toggle
    elseif type == 2 then
        is2Tracking = toggle
    end
end

RegisterKeyMapping('Tracking', 'Take your Keys out of your Car', 'KEYBOARD', 'RSHIFT')
RegisterCommand('Tracking', function()
    ToggleTracking(1, not is1Tracking)
end)

Citizen.CreateThread(function()
    while true do
        Wait(2000)
        local cVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if cVehicle ~= 0 then
            if GetVehicleClass(cVehicle) == 18 then
                local id = NetworkGetNetworkIdFromEntity(cVehicle)
                SetNetworkIdExistsOnAllMachines(id, true)
                SetNetworkIdCanMigrate(id, true)
                SetEntityAsMissionEntity(cVehicle, true, true)
                TriggerServerEvent('cr_Etrack_1252151275_SETCULL', id, true)
                ToggleTracking(2, true)
            else
                ToggleTracking(2, false)
            end
        else
            ToggleTracking(2, false)
        end
    end
end)

Citizen.CreateThread(function()
    local waitTime = 1000
    if is1Tracking == true and is2Tracking == false then
        waitTime = 10000
    end
    while true do
        Wait(waitTime)
        if is1Tracking == true and is2Tracking == false and waitTime ~= 10000 then
            waitTime = 10000
        elseif is2Tracking == true and waitTime ~= 1000 then
            waitTime = 1000
        end

        if is1Tracking == true and is2Tracking == false then
            UnaccurateTrack()
            Wait(5000)
            UnaccurateTrack()
        elseif is2Tracking == true then
            AccurateTrack()
            Wait(2500)
            AccurateTrack()
        end
    end
end)