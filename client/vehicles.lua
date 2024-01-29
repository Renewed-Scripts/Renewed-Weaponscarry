
local Utils = require 'utils.client'
local Vehicles = {}

CreateThread(function()
    while true do
        for entity, props in pairs(Vehicles) do
            if not DoesEntityExist(entity) and props and table.type(props) ~= 'empty' then
                Utils.removeEntities(props)
                Vehicles[entity] = nil
            end
        end
        Wait(1500)
    end
end)

function getEntityFromStateBagName(bagName, keyName)
    local netId = tonumber(bagName:gsub('entity:', ''), 10)

    lib.waitFor(function()
        if NetworkDoesEntityExistWithNetworkId(netId) then return true end
    end, ('%s received invalid entity! (%s)'):format(keyName, bagName), 10000)

    return NetworkGetEntityFromNetworkId(netId)
end

local function attachObject(item, entity, vehicle)
    local pos, rot = item.pos, item.rot

    if pos and rot then
        AttachEntityToEntity(entity, vehicle, item.bone and GetEntityBoneIndexByName(entity, item.bone) or 0, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, true, true, true, false, 5, true)
    end
end


local function createAllObjects(vehicle, addItems, currentTable, amount)
    for i = 1, #addItems do
        local item = addItems[i]
        local object = Utils.createObject(item)

        SetEntityCollision(object, false, false)

        attachObject(item, object, vehicle)
        amount += 1
        currentTable[amount] = {
            name = item.name,
            entity = object,
        }
    end
end

AddStateBagChangeHandler('vehicle_objects', '', function(bagName, keyName, value, _, replicated)
    if replicated then
        return
    end

    local entity = getEntityFromStateBagName(bagName, keyName)

    if entity == 0 then
        return error(('%s received invalid entity! (%s)'):format(keyName, bagName))
    end

    if entity then
        local currentTable = Vehicles[entity] or {}

        if table.type(currentTable) ~= 'empty' then
            Utils.removeEntities(currentTable)
            table.wipe(currentTable)
        end

        if value and next(value) then
           createAllObjects(entity, value, currentTable, 0)
        end

        Vehicles[entity] = currentTable
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, props in pairs(Vehicles) do
            if props and table.type(props) ~= 'empty' then
                Utils.removeEntities(props)
            end
        end
    end
end)