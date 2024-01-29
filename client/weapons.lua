local Config = require 'config'
local Utils = require 'utils.client'

local Players = {}

SetFlashLightKeepOnWhileMoving(true)

local function removePlayer(playerId)
    local Player = Players[playerId]

    if Player and next(Player) then
        Utils.removeEntities(Player)
        Players[playerId] = nil
    end
end

CreateThread(function()
    local NetworkIsPlayerActive = NetworkIsPlayerActive

    while true do
        for playerId, weapons in pairs(Players) do
            if weapons and next(weapons) and not NetworkIsPlayerActive(playerId) then
                removePlayer(playerId)
            end
        end

        Wait(2000)
    end
end)

local function createItem(item)
    if item and item.model then
        return Utils.createObject(item)
    elseif item and item.hash then
        return Utils.createWeapon(item)
    end
end

local function attachObject(item, entity, pedHandle)
    local pos, rot = item.pos, item.rot

    if pos and rot then
        AttachEntityToEntity(entity, pedHandle, GetPedBoneIndex(pedHandle, item.bone), pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, true, true, false, false, 2, true)
    end
end

local function createAllObjects(pedHandle, addItems, currentTable, amount)
    for i = 1, #addItems do
        local item = addItems[i]
        local name = item.name:lower()

        if Config[name] then
            local object = createItem(item)

            attachObject(item, object, pedHandle)

            SetEntityCompletelyDisableCollision(object, false, true)

            amount += 1
            currentTable[amount] = {
                name = item.name,
                entity = object,
            }
        end
    end
end

AddStateBagChangeHandler('weapons_carry', nil, function(bagName, _, value, _, replicated)
    if replicated then
        return
    end

    local playerId = GetPlayerFromStateBagName(bagName)

    if playerId and not value then
        return removePlayer(playerId)
    end

    local pedHandle = playerId == cache.playerId and cache.ped or lib.waitFor(function()
        local ped = GetPlayerPed(playerId)
        if ped > 0 then return ped end
    end, ('%s Player didnt exsist in time! (%s)'):format(playerId, bagName), 10000)

    if pedHandle > 0 then
        local currentTable = Players[playerId] or {}
        local amount = #currentTable

        if amount > 0 then
            Utils.removeEntities(currentTable)
            table.wipe(currentTable)
            amount = 0
        end

        if next(value) then
            createAllObjects(pedHandle, value, currentTable, amount)
        end

        Players[playerId] = currentTable
    end
end)


local myInventory = {}
local playerState = LocalPlayer.state
local currentWeapon


local function updateState()
    while playerState.weapons_carry == nil do
        Wait(0)
    end

    local items = Utils.formatPlayerInventory(myInventory, currentWeapon)
    local myAttached = playerState.weapons_carry

    if not playerState.hide_props and not lib.table.matches(items, myAttached) then
        playerState:set('weapons_carry', items, true)
    end
end

local function flashLightLoop()
    local weaponSerial = currentWeapon.metadata.serial

    if not weaponSerial then
        return
    end

    local flashState = playerState.flashState and playerState.flashState[weaponSerial] or false

    if flashState then
        SetFlashLightEnabled(cache.ped, true)
    end

    while currentWeapon do
        local currentState = IsFlashLightOn(cache.ped)
        if currentState ~= flashState then
            flashState = currentState
        end

        Wait(100)
    end

    playerState.flashState = flashState and {
        [weaponSerial] = flashState
    } or false
end

AddEventHandler('ox_inventory:currentWeapon', function(weapon)
    local name = weapon and weapon.name

    if weapon then
        local searchName = name:lower()
        if Config[searchName] then
            local hasFlashLight = Utils.hasFlashLight(weapon.metadata.components)

            if hasFlashLight then
                SetTimeout(0, flashLightLoop)
            end
        end
    end


    if weapon then
        for _, v in pairs(myInventory) do
            if v?.name == name then
                currentWeapon = weapon
                return updateState()
            end
        end
    elseif currentWeapon then
        currentWeapon = weapon
        return SetTimeout(100, updateState)
    end
end)

local function previousItemCheck(slot, item)
    local name = item and item.name:lower()
    local previousItem = not item and myInventory[slot]

    if previousItem then
        local prevName = previousItem.name:lower()

        return Config[prevName]
    end

    return Config[name]
end

AddEventHandler('ox_inventory:updateInventory', function(changes)
    if not changes then
        return
    end

    local weaponsChanged = false

    for slot, item in pairs(changes) do
        if not weaponsChanged then
            weaponsChanged = previousItemCheck(slot, item)
        end

        myInventory[slot] = item
    end

    if weaponsChanged then
        updateState()
    end
end)


---- Refresh Weapon Conditions ----

local function refreshWeapons()
    if playerState.weapons_carry and next(playerState.weapons_carry) then
        playerState:set('weapons_carry', false, true)

        updateState()
    end
end

local function refreshLocalProps()
    if Players[cache.playerId] then
        Utils.removeEntities(Players[cache.playerId])

        table.wipe(Players[cache.playerId])

        local Items = Utils.formatPlayerInventory(myInventory, currentWeapon)

        createAllObjects(cache.ped, Items, Players[cache.playerId], 0)
    end
end

AddStateBagChangeHandler('hide_props', ('player:%s'):format(cache.serverId), function(_, _, value)
    if value then
        local items = playerState.weapons_carry

        if items and next(items) then
            playerState:set('weapons_carry', false, true)
        end
    else
        return SetTimeout(100, updateState)
    end
end)

lib.onCache('ped', function()
    refreshWeapons()
end)

lib.onCache('vehicle', function(value)
    if not value then
        local items = playerState.weapons_carry

        if items and next(items) then
            for i = 1, #items do
                local item = items[i]

                if item.components and next(item.components) then
                    return refreshWeapons()
                end
            end
        end
    end
end)

AddStateBagChangeHandler('instance', ('player:%s'):format(cache.serverId), function(_, _, value)
    if value == 0 then
        if playerState.weapons_carry and next(playerState.weapons_carry) then
            refreshLocalProps()
        end
    end
end)

-- txAdmin noclip handling
RegisterNetEvent('txcl:setPlayerMode', function(mode)
    if mode == "noclip" then
        playerState:set("hide_props", true, true)
    elseif mode == "none" and playerState.hide_props then
        playerState:set("hide_props", false, true)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, v in pairs(Players) do
            if v then
                Utils.removeEntities(v)
            end
        end
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        myInventory = exports.ox_inventory:GetPlayerItems()
        refreshWeapons()
    end
end)