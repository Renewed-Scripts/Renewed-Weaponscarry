local weaponModule = require 'modules.weapons'
local carryModule = require 'modules.carry'
local weaponsConfig = require 'data.weapons'
local carryConfig = require 'data.carry'

local Inventory = exports.ox_inventory:GetPlayerItems() or {}
local playerState = LocalPlayer.state
local currentWeapon = {}

local hasFlashLight = require 'modules.utils'.hasFlashLight
AddEventHandler('ox_inventory:currentWeapon', function(weapon)
    if weapon then
        local searchName = weapon.name:lower()
        if weaponsConfig[searchName] then

            if hasFlashLight(weapon.metadata.components) then
                CreateThread(function()
                    weaponModule.loopFlashlight(weapon.metadata.serial)
                end)
            end

            currentWeapon = weapon
            return weaponModule.updateWeapons(Inventory, weapon)
        end
    elseif currentWeapon and table.type(currentWeapon) ~= 'empty' then
        table.wipe(currentWeapon)
        weaponModule.updateWeapons(Inventory, currentWeapon)
    end
end)


--- Checks if the item in the slot has changed and returns the config for the item
--- @param slot number
--- @param item table
--- @return string
local function itemChanged(slot, item)
    local name = item and item.name:lower()
    local previousItem = not item and Inventory[slot]

    if previousItem then
        local prevName = previousItem.name:lower()

        return weaponsConfig[prevName] and 'weapon' or carryConfig[prevName] and 'carry' or ''
    end

    return weaponsConfig[name] and 'weapon' or carryConfig[name] and 'carry' or ''
end


AddEventHandler('ox_inventory:updateInventory', function(changes)
    if not changes then
        return
    end

    local typeUpdate = ''

    for slot, item in pairs(changes) do
        if not forceUpdate then
            typeUpdate = itemChanged(slot, item)
        end

        Inventory[slot] = item
    end

    if typeUpdate == 'weapon' then
        weaponModule.updateWeapons(Inventory, currentWeapon)
    elseif typeUpdate == 'carry' then
        carryModule.updateCarryState(Inventory)
    end
end)


AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)

        local weaponsCarry = playerState.weapons_carry

        if weaponsCarry and table.type(weaponsCarry) ~= 'empty' then
            playerState:set('weapons_carry', false, true)

            weaponModule.updateWeapons(Inventory, currentWeapon)
        end

        local carryItems = playerState.carry_items

        if carryItems and table.type(carryItems) ~= 'empty' then
            playerState:set('carry_items', false, true)

            carryModule.updateCarryState(Inventory)
        end
    end
end)








--[[
    Utility functions for handling updates such as going into different instances, vehicles, ped changes etc.
]]

local function refreshWeapons()
    if playerState.weapons_carry and table.type(playerState.weapons_carry) ~= 'empty' then
        playerState:set('weapons_carry', false, true)

        weaponModule.updateWeapons(Inventory, currentWeapon)
    end
end

AddStateBagChangeHandler('hide_props', ('player:%s'):format(cache.serverId), function(_, _, value)
    if value then
        local items = playerState.weapons_carry

        if items and table.type(items) ~= 'empty' then
            playerState:set('weapons_carry', false, true)
        end
    else
        CreateThread(function()
            weaponModule.updateWeapons(Inventory, currentWeapon)
        end)
    end
end)

-- To be fair I don't know if this is needed but it's here just in case
lib.onCache('ped', function()
   refreshWeapons()
end)

-- Some components like flashlights are being removed whenever a player enters a vehicle so we need to refresh the weapons_carry state when they exit
lib.onCache('vehicle', function(value)
    if not value then
        local items = playerState.weapons_carry

        if items and table.type(items) ~= 'empty' then
            for i = 1, #items do
                local item = items[i]

                if item.components and table.type(item.components) ~= 'empty' then
                    return refreshWeapons()
                end
            end
        end
    end
end)

AddStateBagChangeHandler('instance', ('player:%s'):format(cache.serverId), function(_, _, value)
    if value == 0 then
        if playerState.weapons_carry and table.type(playerState.weapons_carry) ~= 'empty' then
            weaponModule.refreshProps(Inventory, currentWeapon)
        end
    end
end)