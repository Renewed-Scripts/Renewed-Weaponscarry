local weaponModule = require 'modules.weapons'
local carryModule = require 'modules.carry'
local weaponsConfig = require 'data.weapons'

local Inventory = exports.ox_inventory:GetPlayerItems() or {}
local playerState = LocalPlayer.state
local currentWeapon = {}

local hasFlashLight = require 'modules.utils'.hasFlashLight
AddEventHandler('ox_inventory:currentWeapon', function(weapon)
    if weapon and weapon.name then
        local searchName = weapon.name:lower()
        if weaponsConfig[searchName] then
            currentWeapon = weapon

            if hasFlashLight(currentWeapon.metadata.components) then
                CreateThread(function()
                    weaponModule.loopFlashlight(currentWeapon.metadata.serial)
                end)
            end

            return weaponModule.updateWeapons(Inventory, currentWeapon)
        end
    else
        local weaponName = currentWeapon?.name and currentWeapon.name:lower()

        currentWeapon = {}

        if weaponName and weaponsConfig[weaponName] then
            return weaponModule.updateWeapons(Inventory, {})
        end
    end
end)

--- Updates the inventory with the changes
AddEventHandler('ox_inventory:updateInventory', function(changes)
    if not changes then
        return
    end

    for slot, item in pairs(changes) do
        Inventory[slot] = item
    end

    weaponModule.updateWeapons(Inventory, currentWeapon)
    carryModule.updateCarryState(Inventory)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        if table.type(playerState.weapons_carry or {}) ~= 'empty' then
            playerState:set('weapons_carry', false, true)

            weaponModule.updateWeapons(Inventory, currentWeapon)
        end

        if table.type(playerState.carry_items or {}) ~= 'empty' then
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
        Inventory = exports.ox_inventory:GetPlayerItems()

        playerState:set('weapons_carry', false, true)

        weaponModule.updateWeapons(Inventory, currentWeapon)
    end
end exports("RefreshWeapons", refreshWeapons)


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