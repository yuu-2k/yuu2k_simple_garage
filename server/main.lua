lib.callback.register('yuu2k_simple_garage:getVehicles', function(source, state, garage)
    local xPlayer = ESX.Player(source)
    local vehicles = MySQL.query.await('SELECT * FROM owned_vehicles WHERE owner = ? AND stored = ?', { xPlayer.getIdentifier(), state })
    local filtered = {}
    for _, vehicle in ipairs(vehicles) do
        if Config.Zone[garage].types[vehicle.type] then
            filtered[#filtered + 1] = vehicle
        end
    end
    return filtered
end)

lib.callback.register('yuu2k_simple_garage:storeVehicle', function(source, properties)
    local source = source
    local xPlayer = ESX.Player(source)
    local vehicle = MySQL.single.await('SELECT * FROM owned_vehicles WHERE owner = ? AND plate = ?', { xPlayer.getIdentifier(), properties.plate })
    if not vehicle then
        return false
    end
    MySQL.update.await('UPDATE owned_vehicles SET stored = 1, vehicle = ? WHERE plate = ?', { json.encode(properties), properties.plate })
    return true
end)

RegisterNetEvent('yuu2k_simple_garage:spawnVehicle', function(plate, garage, action)
    local source = source
    local xPlayer = ESX.Player(source)
    local identifier = xPlayer.getIdentifier()
    local result = MySQL.single.await('SELECT vehicle FROM owned_vehicles WHERE owner = ? AND plate = ? AND stored IN (0,1)',{ identifier, plate })
    if not result then
        return
    end
    if action == 'impound' then
        local impound = Config.Zone[garage].impound
        if impound then
            local account = xPlayer.getAccount(impound.account)
            if account.money < impound.price then
                lib.notify(source, {
                    title = locale('impound'),
                    description = locale('not_enough_money', impound.price),
                    type = 'error'
                })
                return
            end
            xPlayer.removeAccountMoney(impound.account, impound.price, 'test')
            if impound.society then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
                    account.addMoney(impound.price)
                end)
            end
        end
    end
    local props = json.decode(result.vehicle)
    local spawn = Config.Zone[garage].spawn
    ESX.OneSync.SpawnVehicle(
        props.model,
        vector3(spawn.x, spawn.y, spawn.z),
        spawn.w,
        props
    )
    MySQL.update.await('UPDATE owned_vehicles SET stored = 2 WHERE owner = ? AND plate = ?', { identifier, plate })
end)