local Config = require 'data.carry'
local Utils = require 'modules.utils'
local playerState = LocalPlayer.state




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

local function carryLoop(itemConfig)

    local dict, anim, flag = itemConfig.dict, itemConfig.anim, itemConfig.flag or 1
    local animLength
    if dict and anim then
        lib.requestAnimDict(dict)

        animLength = GetAnimDuration(dict, anim)

        TaskPlayAnim(cache.ped, dict, anim, 8.0, 8.0, animLength, flag, 0, false, false, false)
    end

    local disableKeys = itemConfig.disableKeys

    while carryingItem do
        if not IsEntityPlayingAnim(cache.ped, dict, anim, 3) then
            TaskPlayAnim(cache.ped, dict, anim, 8.0, 8.0, animLength, flag, 0, false, false, false)
        end

        if disableKeys then
            for i = 1, #disableKeys do
                DisableControlAction(0, disableKeys[i], true)
            end
        end

        Wait(0)
    end
end

AddStateBagChangeHandler('carry_loop', ('player:%s'):format(cache.serverId), function(_, _, value)
    if value and table.type(value) ~= 'empty' then
        if carryingItem then
            carryingItem = false
            Wait(25)
        end

        carryingItem = true

        carryLoop(value)
    elseif carryingItem then
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

    if table.type(carryItem) ~= 'empty' then
        playerState:set('carry_items', carryItem, true)

        if itemConfig.anim or itemConfig.disableKeys then
            playerState.carry_loop = itemConfig
        elseif playerState.carry_loop then
            playerState.carry_loop = false
        end
    end
end

















return {
    updateCarryState = updateState,
}