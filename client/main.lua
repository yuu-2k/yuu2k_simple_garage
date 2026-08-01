local function OpenVehicleMenu(title, vehicles, garage, action)
    local options = {}
    for _, vehicle in ipairs(vehicles) do
        local props = json.decode(vehicle.vehicle)
        options[#options + 1] = {
            title = ('%s | %s'):format(GetDisplayNameFromVehicleModel(props.model), props.plate),
            description = action == 'impound' and locale('impound_fee', Config.Zone[garage].impound.price) or vehicle.plate,            
            onSelect = function()
                local spawn = Config.Zone[garage].spawn
                if not ESX.Game.IsSpawnPointClear(
                    vector3(spawn.x, spawn.y, spawn.z),
                    3.0
                ) then
                    return lib.notify({
                        type = 'error',
                        description = locale('spawn_blocked'),
                    })
                end
                TriggerServerEvent('yuu2k_simple_garage:spawnVehicle', vehicle.plate, garage, action)
            end
        }
    end
    lib.registerContext({
        id = title,
        title = title,
        options = options
    })
    lib.showContext(title)
end

local function OpenVehicleList(state, title, garage, action)
    local vehicles = lib.callback.await('yuu2k_simple_garage:getVehicles', false, state, garage)
    if not vehicles or #vehicles == 0 then
        return lib.notify({
            title = title,
            description = state == Config.Stored.Garage and locale('no_vehicle_garage') or locale('no_vehicle_impound'),
            type = 'error'
        })
    end
    OpenVehicleMenu(title, vehicles, garage, action)
end

local Actions = {}

Actions.retrieve = {
    canInteract = function()
        return not IsPedInAnyVehicle(cache.ped, false)
    end,
    text = locale('spawn_vehicle'),
    interact = function(point)
        OpenVehicleList(Config.Stored.Garage , locale('garage'), point.garage, 'retrieve')
    end
}

Actions.store = {
    canInteract = function()
        return IsPedInAnyVehicle(cache.ped, false)
    end,
    text = locale('store_vehicle_text'),
    interact = function(point)
        TriggerEvent('yuu2k_simple_garage:storeVehicle', point.garage)
    end
}

Actions.impound = {
    canInteract = function()
        return not IsPedInAnyVehicle(cache.ped, false)
    end,
    text = locale('impound_text'),
    interact = function(point)
        OpenVehicleList(Config.Stored.Impound, locale('impound'), point.garage, 'impound')
    end
}

CreateThread(function()
    for garageName, garage in pairs(Config.Zone) do
        if garage.blip then
            local blipData = Config.Blip[garage.blip]
            local blip = AddBlipForCoord(garage.spawn.xyz)
            SetBlipSprite(blip, blipData.sprite)
            SetBlipColour(blip, blipData.colour)
            SetBlipScale(blip, blipData.scale)
            SetBlipAsShortRange(blip, blipData.shortRange)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(blipData.name)
            EndTextCommandSetBlipName(blip)
        end
        for _, pointData in ipairs(garage.points) do
            local point = lib.points.new({
                coords = pointData.coords,
                distance = 10.0,
                garage = garageName,
                action = pointData.action,
                marker = pointData.marker
            })
            function point:nearby()
                local actionData = Actions[self.action]
                if not actionData or not actionData.canInteract() then
                    lib.hideTextUI()
                    return
                end
                local marker = Config.Marker[self.marker]
                DrawMarker(
                    marker.type,
                    self.coords.x,
                    self.coords.y,
                    self.coords.z - 1.0,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    marker.scale.x,
                    marker.scale.y,
                    marker.scale.z,
                    marker.color.r,
                    marker.color.g,
                    marker.color.b,
                    marker.color.a,
                    marker.bobUpAndDown,
                    marker.faceCamera,
                    2,
                    marker.rotate,
                    nil,
                    nil,
                    false
                )
                if self.currentDistance > 2.0 then
                    lib.hideTextUI()
                    return
                end
                lib.showTextUI(actionData.text)
                if IsControlJustReleased(0, 38) then
                    actionData.interact(self)
                end
            end
            function point:onExit()
                lib.hideTextUI()
            end
        end
    end
end)

RegisterNetEvent('yuu2k_simple_garage:storeVehicle', function(garage)
    local vehicle = GetVehiclePedIsIn(cache.ped, false)
    if vehicle == 0 then
        return lib.notify({
            title = locale('garage'),
            description = locale('must_be_in_vehicle'),
            type = 'error'
        })
    end
    local vehicleType = GetVehicleType(vehicle)
    if not Config.Zone[garage].types[vehicleType] then
        return lib.notify({
            type = 'error',
            description = locale('invalid_vehicle_type')
        })
    end
    local properties = lib.getVehicleProperties(vehicle)
    local success = lib.callback.await('yuu2k_simple_garage:storeVehicle', false, properties)
    if not success then
        return lib.notify({
            title = locale('garage'),
            description = locale('cannot_store'),
            type = 'error'
        })
    end
    DeleteVehicle(vehicle)
    lib.notify({
        title = locale('garage'),
        description = locale('vehicle_stored'),
        type = 'success'
    })
end)