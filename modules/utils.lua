local ox_items = exports.ox_inventory:Items()
local Utils = {}

local playerSlots = {
	{ -- Bigger weapons such as bats, crowbars, Assaultrifles, and also good place for wet weed.
		{ bone = 24817, pos = vec3(0.04, -0.15, 0.12), rot = vec3(0.0, 0.0, 0.0) },
		{ bone = 24817, pos = vec3(0.04, -0.17, 0.02), rot = vec3(0.0, 0.0, 0.0) },
		{ bone = 24817, pos = vec3(0.04, -0.19, -0.08), rot = vec3(0.0, 0.0, 0.0) },
	},

	{ -- Use this for katana knives etc. stuff that goes sideways on the players body
		{ bone = 24817, pos = vec3(-0.13, -0.16, -0.14), rot = vec3(5.0, 62.0, 0.0) },
		{ bone = 24817, pos = vec3(-0.13, -0.15, 0.10), rot = vec3(5.0, 124.0,0.0) },
	},

	{ -- Contraband like Drugs and shit
		{ bone = 24817, pos = vec3(-0.28, -0.14, 0.15), rot = vec3(0.0, 92.0, -13.0) },
		{ bone = 24817, pos = vec3(-0.27, -0.14, 0.15), rot = vec3(0.0, 92.0, 13.0) },
	},
}

function Utils.resetSlots()
    for i = 1, #playerSlots do
        for v = 1, #playerSlots[i] do
            playerSlots[i][v].isBusy = false
        end
    end
end

function Utils.removeEntities(data)
    for i = 1, #data do
        local entity = data[i]?.entity

        if entity then
            DeleteEntity(entity)
        end
    end
end

function Utils.hasFlashLight(components)
    if components and table.type(components) ~= 'empty' then
        for i = 1, #components do
            local component = components[i]

            if component:find('flashlight') then
                return true
            end
        end
    end

    return false
end

function Utils.checkFlashState(weapon)
    local flashState = LocalPlayer.state.flashState

    if flashState and flashState[weapon.serial] and Utils.hasFlashLight(weapon.components) then
        return true
    end

    return false
end

function Utils.hasVarMod(hash, components)
    for i = 1, #components do
        local component = ox_items[components[i]]

        if component.type == 'skin' or component.type == 'upgrade' then
            local weaponComp = component.client.component
            for j = 1, #weaponComp do
                local weaponComponent = weaponComp[j]
                if DoesWeaponTakeWeaponComponent(hash, weaponComponent) then
                    return GetWeaponComponentTypeModel(weaponComponent)
                end
            end
        end
    end
end

function Utils.getWeaponComponents(name, hash, components)
    local weaponComponents = {}
    local amount = 0
    local hadClip = false
    local varMod = Utils.hasVarMod(hash, components)

    for i = 1, #components do
        local weaponComp = ox_items[components[i]]
        for j = 1, #weaponComp.client.component do
            local weaponComponent = weaponComp.client.component[j]
            if DoesWeaponTakeWeaponComponent(hash, weaponComponent) and varMod ~= weaponComponent then
                amount += 1
                weaponComponents[amount] = weaponComponent

                if weaponComp.type == 'magazine' then
                    hadClip = true
                end

                break
            end
        end
    end

    if not hadClip then
        amount += 1
        weaponComponents[amount] = joaat(('COMPONENT_%s_CLIP_01'):format(name:sub(8)))
    end


    return varMod, weaponComponents, hadClip
end

function Utils.findOpenSlot(tier)
    local slotTier = playerSlots[tier]

    if slotTier then
        local slotAmount = #slotTier

        for i = 1, slotAmount do
            local slot = slotTier[i]

            if not slot.isBusy then
                slot.isBusy = true
                return slot
            end
        end

        return slotTier[slotAmount]
    end
end

function Utils.formatData(itemData, itemConfig, ignoreSlot)
    local isWeapon = itemData.name:find('WEAPON_')

    local slot = not ignoreSlot and itemConfig.slot and Utils.findOpenSlot(itemConfig.slot)

    return {
        name = itemData.name,
        hash = isWeapon and itemConfig.hash or joaat(itemData.name),
        components = isWeapon and itemData?.metadata?.components,
        tint = isWeapon and itemData?.metadata?.tint,
        serial = isWeapon and itemData?.metadata?.serial,
        model = itemConfig.model,
        pos = itemConfig.pos or slot?.pos,
        rot = itemConfig.rot or slot?.rot,
        bone = itemConfig.bone or slot?.bone,
    }
end


function Utils.getEntityFromStateBag(bagName, keyName)

    if bagName:find('entity:') then
        local netId = tonumber(bagName:gsub('entity:', ''), 10)

        local entity =  lib.waitFor(function()
            if NetworkDoesEntityExistWithNetworkId(netId) then return NetworkGetEntityFromNetworkId(netId) end
        end, ('%s received invalid entity! (%s)'):format(keyName, bagName), 10000)

        return entity
    elseif bagName:find('player:') then
        local serverId = tonumber(bagName:gsub('player:', ''), 10)
        local playerId = GetPlayerFromServerId(serverId)

        local entity = lib.waitFor(function()
            local ped = GetPlayerPed(playerId)
            if ped > 0 then return ped end
        end, ('%s received invalid entity! (%s)'):format(keyName, bagName), 10000)

        return playerId, entity
    end

end

function Utils.AttachEntityToPlayer(item, entity, pedHandle)
    local pos, rot = item.pos, item.rot

    if pos and rot then
        AttachEntityToEntity(entity, pedHandle, GetPedBoneIndex(pedHandle, item.bone), pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, true, true, false, false, 2, true)
    end
end

local function createObject(item)
    lib.requestModel(item.model, 1000)
    local Object = CreateObject(item.model, 0.0, 0.0, 0.0, false, false, false)
    SetModelAsNoLongerNeeded(item.model)

    return Object
end

local function createWeapon(item)
    local _, hash = pcall(function()
		return lib.requestWeaponAsset(item.hash, 5000, 31, 0)
	end)

    if hash and hash ~= 0 then
        local hasLuxeMod, components, hadClip = Utils.getWeaponComponents(item.name, hash, item.components)

        if hasLuxeMod then
            lib.requestModel(hasLuxeMod, 500)
        end

        local showDefault = true

        if hasLuxeMod and hadClip then
            showDefault = false
        end

        ---@diagnostic disable-next-line: redundant-parameter
        local weaponObject = CreateWeaponObject(hash, 0, 0.0, 0.0, 0.0, showDefault, 1.0, hasLuxeMod or 0, false, true)

        for i = 1, #components do
            GiveWeaponComponentToWeaponObject(weaponObject, components[i])
        end

        if item.tint then
            SetWeaponObjectTintIndex(weaponObject, item.tint)
        end

        if Utils.checkFlashState(item) then
            SetCreateWeaponObjectLightSource(weaponObject, true)
            Wait(0) -- We need to skip a frame before attaching the object for the lightsource to be created
        end

        if hasLuxeMod then
            SetModelAsNoLongerNeeded(hasLuxeMod)
        end

        RemoveWeaponAsset(hash)

        return weaponObject
    end

    return 0
end

function Utils.getEntity(payload)
    if payload?.model then
        return createObject(payload)
    elseif payload?.hash then
        return createWeapon(payload)
    end

    return 0
end


return Utils