
local Utils = require 'modules.utils'
local Vehicles = {}

CreateThread(function()
    while true do

        for bagname, _ in pairs(Vehicles) do
            local baggedVehicles = Vehicles[bagname]

            if baggedVehicles and table.type(baggedVehicles) ~= 'empty' then
                for entity, props in pairs(baggedVehicles) do
                    if not DoesEntityExist(entity) and props and table.type(props) ~= 'empty' then
                        Utils.removeEntities(props)
                        Vehicles[bagname][entity] = nil
                    end
                end
            end
        end
        Wait(1500)
    end
end)

local function attachObject(item, entity, vehicle)
    local pos, rot = item.pos, item.rot

    if pos and rot then
        AttachEntityToEntity(entity, vehicle, item.bone and GetEntityBoneIndexByName(entity, item.bone) or 0, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, true, true, true, false, 5, true)
    end
end


local function createAllObjects(vehicle, addItems, currentTable, amount)
    for i = 1, #addItems do
        local item = addItems[i]
        local object = Utils.getEntity(item)

        SetEntityCollision(object, false, false)

        attachObject(item, object, vehicle)
        amount += 1
        currentTable[amount] = {
            name = item.name,
            entity = object,
        }
    end
end

local function addVehicleStateBag(name)
    AddStateBagChangeHandler(name, '', function(bagName, keyName, value, _, replicated)
        if replicated then
            return
        end

        local entity = Utils.getEntityFromStateBag(bagName, keyName)

        if entity == 0 then
            return error(('%s received invalid entity! (%s)'):format(keyName, bagName))
        end

        if entity then
            if not Vehicles[keyName] then
                Vehicles[keyName] = {}
            end

            local currentTable = Vehicles[keyName][entity] or {}

            if table.type(currentTable) ~= 'empty' then
                Utils.removeEntities(currentTable)
                table.wipe(currentTable)
            end

            if value and next(value) then
               createAllObjects(entity, value, currentTable, 0)
            end

            Vehicles[keyName][entity] = currentTable
        end
    end)

end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then

        for bagname, _ in pairs(Vehicles) do
            if Vehicles[bagname] and table.type(Vehicles[bagname]) ~= 'empty' then
                for _, props in pairs(Vehicles[bagname]) do
                    if props and table.type(props) ~= 'empty' then
                        Utils.removeEntities(props)
                    end
                end
            end
        end
    end
end)

return {
    addVehicleStateBag = addVehicleStateBag
}