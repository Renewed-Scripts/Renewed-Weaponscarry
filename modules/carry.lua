local Config = require 'data.carry'
local Utils = require 'modules.utils'
local playerState = LocalPlayer.state

local Players = {}

local function removePlayer(playerId)
    local entity = Players[playerId]

    if entity then
        DeleteObject(entity)
        Players[playerId] = nil
    end
end

local function formatPlayerInventory(inventory)
    for _, itemData in pairs(inventory) do
        local name = itemData and itemData.name:lower()

        local itemConfig = Config[name]

        if name and itemConfig then
            return Utils.formatData(itemData, itemConfig, true), itemConfig
        end
    end

    return {}, {}
end


local carryingItem = false
local disableAttacks = {
    24, -- disable attack
    25, -- disable aim
    47, -- disable weapon
    58, -- disable weapon
    263, -- disable melee
    264, -- disable melee
    257, -- disable melee
    140, -- disable melee
    141, -- disable melee
    142, -- disable melee
    143 -- disable melee
}

local function getDisabledKeys(disabledKeys)
    local keys = {}
    local amount = 0

    if disabledKeys then
        if disabledKeys.disableAttack then
            for i = 1, #disableAttacks do
                amount += 1
                keys[amount] = disableAttacks[i]
            end
        end

        if disabledKeys.disableJump then
            amount += 1
            keys[amount] = 22
        end

        if disabledKeys.disableSprint then
            amount += 1
            keys[amount] = 21
        end

        if disabledKeys.disableVehicle then
            amount += 1
            keys[amount] = 23
        end
    end

    return keys, amount
end


local DisableControlAction = DisableControlAction
local IsEntityPlayingAnim = IsEntityPlayingAnim
local function carryLoop(itemConfig)
    local dict, anim, flag = itemConfig.dict, itemConfig.anim, itemConfig.flag or 49

    if dict then
        lib.requestAnimDict(dict)
    end

    local disableKeys, amount = getDisabledKeys(itemConfig.disableKeys)

    while carryingItem do
        if dict and not IsEntityPlayingAnim(cache.ped, dict, anim, 3) then
            TaskPlayAnim(cache.ped, dict, anim, 8.0, -8, -1, flag, 0, 0, 0, 0)
        end

        if amount > 0 then
            for i = 1, amount do
                DisableControlAction(0, disableKeys[i], true)
            end
        end

        Wait(0)
    end

    if dict then
        if IsEntityPlayingAnim(cache.ped, dict, anim, 3) then
            StopEntityAnim(cache.ped, anim, dict, 3)
        end

        RemoveAnimDict(dict)
    end
end

AddStateBagChangeHandler('carry_items', nil, function(bagName, keyName, value, _, replicated)
    if replicated then
        return
    end

    local playerId, pedHandle = Utils.getEntityFromStateBag(bagName, keyName)

    if playerId and not value then
        return removePlayer(playerId)
    end

    if pedHandle > 0 then
        local currentEntity = Players[playerId]
        local entity

        if currentEntity and DoesEntityExist(currentEntity) then
            DeleteEntity(currentEntity)
        end

        if value and table.type(value) ~= 'empty' then
            entity = Utils.getEntity(value)

            if entity > 0 then
                Utils.AttachEntityToPlayer(value, entity, pedHandle)
            end
        end

        Players[playerId] = entity
    end
end)

AddStateBagChangeHandler('carry_loop', ('player:%s'):format(cache.serverId), function(_, _, value)
    if value and table.type(value) ~= 'empty' then
        if carryingItem then
            carryingItem = false
            Wait(25)
        end

        carryingItem = true

        carryLoop(value)
    else
        carryingItem = false
    end
end)

local function updateState(inventory)
    if playerState.carry_items == nil then
        while playerState.carry_items == nil do
            Wait(0)
        end
    end

    local carryItem, itemConfig = formatPlayerInventory(inventory)

    if not lib.table.matches(playerState.carry_items or {}, carryItem) then
        playerState:set('carry_items', carryItem, true)

        if itemConfig.dict or itemConfig.disableKeys then
            playerState.carry_loop = itemConfig
        elseif playerState.carry_loop then
            playerState.carry_loop = false
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
        for k, _ in pairs(Players) do
            removePlayer(k)
        end
   end
end)


return {
    updateCarryState = updateState,
}