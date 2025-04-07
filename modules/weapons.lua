local Config = require 'data.weapons'
local Utils = require 'modules.utils'
local playerSlots = Utils.playerSlots

local Players = {}

SetFlashLightKeepOnWhileMoving(true)

---@param serverId number
local function removePlayer(serverId)
    local Player = Players[serverId]

    if Player and table.type(Player) ~= 'empty' then
        Utils.removeEntities(Player)
        Players[serverId] = nil
    end
end

RegisterNetEvent('onPlayerDropped', function(serverId)
    removePlayer(serverId)
end)

---@param inventory table
---@param currentWeapon table | nil
---@return table
local function formatPlayerInventory(inventory, currentWeapon)
    local items = {}
    local amount = 0
    local usedSlots = {}
    local playerSlots = Utils.playerSlots

    for _, itemData in pairs(inventory) do
        local name = itemData and itemData.name:lower()
        if name and Config[name] then
            local slotType = Config[name].slot
            usedSlots[slotType] = usedSlots[slotType] or 0
        end
    end

    for _, itemData in pairs(inventory) do
        local name = itemData and itemData.name:lower()
        
        if currentWeapon and itemData and currentWeapon.name == itemData.name and lib.table.matches(itemData.metadata.components, currentWeapon.metadata.components) then
            currentWeapon = nil
        elseif name and Config[name] then
            local slotType = Config[name].slot
            if playerSlots[slotType] and usedSlots[slotType] < #playerSlots[slotType] then
                amount += 1
                items[amount] = Utils.formatData(itemData, Config[name])
                usedSlots[slotType] += 1
            end
        end
    end

    Utils.resetSlots()

    if amount > 1 then
        table.sort(items, function(a, b)
            if not a or not b or not a.slot or not b.slot then return false end
            return a.slot < b.slot
        end)
    end

    return items
end






---@param pedHandle number
---@param addItems table
---@param currentTable table
---@param amount number
local function createAllObjects(pedHandle, addItems, currentTable, amount)
    for i = 1, #addItems do
        local item = addItems[i]
        local name = item.name:lower()

        if Config[name] then
            local object = Utils.getEntity(item)

            if object > 0 then
                Utils.AttachEntityToPlayer(item, object, pedHandle)

                SetEntityCompletelyDisableCollision(object, false, true)

                amount += 1
                currentTable[amount] = {
                    name = item.name,
                    entity = object,
                }
            end
        end
    end
end

AddStateBagChangeHandler('weapons_carry', nil, function(bagName, keyName, value, _, replicated)
    if replicated then
        return
    end

    local serverId, pedHandle = Utils.getEntityFromStateBag(bagName, keyName)

    if serverId and not value then
        return removePlayer(serverId)
    end

    if pedHandle > 0 then
        local currentTable = Players[serverId] or {}
        local amount = #currentTable

        if amount > 0 then
            Utils.removeEntities(currentTable)
            table.wipe(currentTable)
            amount = 0
        end

        if value and table.type(value) ~= 'empty' then
            createAllObjects(pedHandle, value, currentTable, amount)
        end

        Players[serverId] = currentTable
    end
end)

local playerState = LocalPlayer.state

---@param inventory table
---@param currentWeapon table
local function updateState(inventory, currentWeapon)
    while playerState.weapons_carry == nil do
        Wait(0)
    end

    local items = formatPlayerInventory(inventory, currentWeapon)

    if not playerState.hide_props and not lib.table.matches(items, playerState.weapons_carry or {}) then
        playerState:set('weapons_carry', items, true)
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, v in pairs(Players) do
            if v then
                Utils.removeEntities(v)
            end
        end
    end
end)

---@param items table
---@param weapon table | nil
local function refreshProps(items, weapon)
    if Players[cache.serverId] then
        Utils.removeEntities(Players[cache.serverId])

        table.wipe(Players[cache.serverId])

        local Items = formatPlayerInventory(items, weapon)

        createAllObjects(cache.ped, Items, Players[cache.serverId], 0)
    end
end

---@param serial string
local function flashLightLoop(serial)
    serial = serial or 'scratched' 

    local flashState = playerState.flashState?[serial]

    if flashState then
        SetFlashLightEnabled(cache.ped, true)
    end

    while cache.weapon do
        local currentState = IsFlashLightOn(cache.ped)
        if currentState ~= flashState then
            flashState = currentState
        end

        Wait(100)
    end

    playerState.flashState = flashState and {
        [serial] = flashState
    }
end


return {
    updateWeapons = updateState,
    loopFlashlight = flashLightLoop,
    refreshProps = refreshProps,
}