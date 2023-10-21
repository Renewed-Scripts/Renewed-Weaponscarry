local QBCore = exports['qb-core']:GetCoreObject()

--[[
  This is PlayerSlots here we define the Category of the weapons that goes on the Player
  This means that instead of giving each weapon a designated slot on the back, we can just add a weapon with the designated slot
  This will also allow for weapons to feel and look more natural when added.

  All items that go on your back -> MUST have a SLOT CATEGORY
]]
local PlayerSlots = {
	[1] = { -- Bigger weapons such as bats, crowbars, Assaultrifles, and also good place for wet weed.
		[1] = { bone = 24817, x = 0.04, y = -0.15, z = 0.12, xr = 0.0, yr = 0.0, zr = 0.0, isBusy = false },
		[2] = { bone = 24817, x = 0.04, y = -0.17, z = 0.02, xr = 0.0, yr = 0.0, zr = 0.0, isBusy = false },
		[3] = { bone = 24817, x = 0.04, y = -0.15, z = -0.12, xr = 0.0, yr = 0.0, zr = 0.0, isBusy = false },
	},

	[2] = { -- Use this for katana knives etc. stuff that goes sideways on the players body
		[1] = { bone = 24817, x = -0.13, y = -0.16, z = -0.14, xr = 5.0, yr = 62.0, zr = 0.0, isBusy = false },
		[2] = { bone = 24817, x = -0.13, y = -0.15, z = 0.10, xr = 5.0, yr = 124.0, zr = 0.0, isBusy = false },
	},

	[3] = { -- Contraband like Drugs and shit
		[1] = { bone = 24817, x = -0.28, y = -0.14, z = 0.15, xr = 0.0, yr = 92.0, zr = -13.0 },
		[2] = { bone = 24817, x = -0.27, y = -0.14, z = 0.15, xr = 0.0, yr = 92.0, zr = 13.0 },
	},

	[4] = { -- I use this for the pelts for hunting
		[1] = { bone = 24817, x = -0.18, y = -0.26, z = -0.02, xr = 0.0, yr = 91.0, zr = 5.0 },
		[2] = { bone = 24817, x = 0.10, y = -0.26, z = -0.02, xr = 0.0, yr = 91.0, zr = 5.0 },
		[3] = { bone = 24817, x = 0.38, y = -0.21, z = -0.02, xr = 0.0, yr = 91.0, zr = 5.0 },
	},

	[5] = { -- I use this for chains, make sure your CHAIN is a CUSTOM prop, will NOT work with a clothing item, if you want to add a CHAIN make sure to have a chain = true as it will not work the same as weapons --
		[1] = { bone = 10706, x = 0.11, y = 0.080, z = -0.473, xr = -366.0, yr = 19.0, zr = -163.0 },
	},
}

local props = Config.itemProps

local items_attatched = {}
local itemSlots = {}
local override = false

local PlayerData = QBCore.Functions.GetPlayerData()

local FullyLoaded = LocalPlayer.state.isLoggedIn

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ** Weapon Functions ** --

local function getFreeSlot(tier)
	local amount = 0

	for i = 1, #PlayerSlots[tier] do
		if not PlayerSlots[tier][i].isBusy then
			amount = amount + 1
		end
	end

	return amount
end

local function UseSlot(tier)
	local slot = nil
	for i = 1, #PlayerSlots[tier] do
		if not PlayerSlots[tier][i].isBusy then
			PlayerSlots[tier][i].isBusy = true
			slot = i
			break
		end
	end

	return slot
end

local function calcOffsets(x, y, z, xr, yr, zr, item)
	local X, Y, Z, XR, YR, ZR = x, y, z, xr, yr, zr

	if props[item].x then
		X = props[item].x
	end

	if props[item].y then
		Y = props[item].y
	end

	if props[item].z then
		Z = props[item].z
	end

	if props[item].xr then
		XR = props[item].xr
	end


	if props[item].yr then
		YR = props[item].yr
	end

	if props[item].zr then
		ZR = props[item].zr
	end

	return X, Y, Z, XR, YR, ZR
end

local function AttachWeapon(attachModel, modelHash, tier, item)
	local hash = joaat(attachModel)
	local slot = UseSlot(tier)
	if not slot then return end

	local v = PlayerSlots[tier][slot]
	local bone = GetPedBoneIndex(cache.ped, v.bone)

	lib.requestModel(hash)

	items_attatched[attachModel] = {
		hash = modelHash,
		handle = CreateObject(attachModel, 1.0, 1.0, 1.0, true, true, false),
		slot = slot,
		tier = tier
	}

	local x, y, z, xr, yr, zr = calcOffsets(v.x, v.y, v.z, v.xr, v.yr, v.zr, item)

	AttachEntityToEntity(items_attatched[attachModel].handle, cache.ped, bone, x, y, z, xr, yr, zr, 1, 1, 0, 0, 2, 1)
	SetModelAsNoLongerNeeded(hash)
	SetEntityCompletelyDisableCollision(items_attatched[attachModel].handle, false, true)
end

local WeapDelete = false
local function DeleteWeapon(item)
	local hash = items_attatched[item].hash
	if WeapDelete then return end

	WeapDelete = true
	local wait = 0 -- if above 3 seconds then return this function
	while GetSelectedPedWeapon(cache.ped) ~= hash do
		Wait(100)
		wait = wait + 1
		if wait >= 30 then return end -- If they figure out a way to spam then this we just return the function
	end

	if items_attatched[item] then

		DeleteObject(items_attatched[item].handle)

		if items_attatched[item].slot then
			PlayerSlots[items_attatched[item].tier][items_attatched[item].slot].isBusy = false
		end

		items_attatched[item] = nil

	end
	WeapDelete = false
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local carryingChain = nil

local function AttatchChain(attachModel, modelHash, tier, item)
	if carryingChain then return end
	carryingChain = attachModel
	local slot = UseSlot(tier)
	if not slot then return end

	local v = PlayerSlots[tier][slot]
	local bone = GetPedBoneIndex(cache.ped, v.bone)

	lib.requestModel(modelHash)

	ClearPedTasks(cache.ped)

	items_attatched[attachModel] = {
		hash = modelHash,
		handle = CreateObject(attachModel, 1.0, 1.0, 1.0, true, true, false),
		slot = slot,
		tier = tier,
		chain = true,
	}

	local x, y, z, xr, yr, zr = calcOffsets(v.x, v.y, v.z, v.xr, v.yr, v.zr, item)

	AttachEntityToEntity(items_attatched[attachModel].handle, cache.ped, bone, x, y, z, xr, yr, zr, 1, 1, 0, 0, 2, 1)
	SetModelAsNoLongerNeeded(modelHash)
	SetEntityCompletelyDisableCollision(items_attatched[attachModel].handle, false, true)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--** Generic Functions **--

local function getItemByhash(hash)
	for k, v in pairs(props) do
		if v.hash == hash or hash == joaat(v.model) then
			return k
		end
	end
end

local function removeItems()
	if items_attatched then
		for k, v in pairs(items_attatched) do
			local hasitem = false
			local item = getItemByhash(v.hash)
			if item then
				if itemSlots[item] then
					hasitem = true
				end

				if not hasitem or (props[item] and props[item].busy) then
					DeleteObject(v.handle)

					if v.slot then
						PlayerSlots[v.tier][v.slot].isBusy = false
					end

					if v.chain then
						carryingChain = nil
					end

					items_attatched[k] = nil
				end
			end
		end
	end
end

local PlayerId = PlayerId()
local doingCheck = false
local function DoItemCheck()
	if not FullyLoaded then return end
	if doingCheck then return end
	if IsPedShooting(cache.ped) or IsPlayerFreeAiming(PlayerId) then return end -- reduces the shooting spamming
	doingCheck = true
	Wait(math.random(1, 100)) -- When shooting a gun, the event is called HUNDREDS of times, this here is to prevent that from affecting the players MS too much at a time.
	local items = PlayerData.items
	itemSlots = {}
	if items then
		for _, item in pairs(items) do
			item.name = item.name:lower()
			if item and item.name and props and props[item.name] and not itemSlots[item.name] then
				itemSlots[item.name] = props[item.name]
				if props[item.name].chain then
					if not carryingChain then
						AttatchChain(props[item.name].model, props[item.name].hash, props[item.name].tier, item.name)
					end
				elseif not items_attatched[props[item.name].model] and GetSelectedPedWeapon(cache.ped) ~= props[item.name].hash and
					getFreeSlot(props[item.name].tier) >= 1 then
					AttachWeapon(props[item.name].model, props[item.name].hash, props[item.name].tier, item.name)
				end
			end
		end
	end

	removeItems()

	Wait(math.random(1, 100)) -- When shooting a gun, the event is called HUNDREDS of times, this here is to prevent that from affecting the players MS too much at a time.
	doingCheck = false
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ** EXPORTS ** --
local function toggleProps()
	if override then
		if items_attatched then
			for k, v in pairs(items_attatched) do

				DeleteObject(v.handle)

				if v.slot then
					PlayerSlots[v.tier][v.slot].isBusy = false
				end

				if v.chain then
					carryingChain = nil
				end

				items_attatched[k] = nil
			end
		end
		override = false
	else
		override = true

		if items_attatched then
			for k, v in pairs(items_attatched) do

				DeleteObject(v.handle)

				if v.slot then
					PlayerSlots[v.tier][v.slot].isBusy = false
				end

				if v.chain then
					carryingChain = nil
				end

				items_attatched[k] = nil
			end
		end
	end
end

exports("toggleProps", toggleProps)

local function isCarryingAnObject(item)
	if items_attatched[props[item].model] then return true else return false end
end

exports('isCarryingAnObject', isCarryingAnObject)

local function GetPlayerCarryItems()
	return items_attatched
end

exports('GetPlayerCarryItems', GetPlayerCarryItems)

local function refreshProps()
	if not FullyLoaded then return end
	if items_attatched then
		for k, v in pairs(items_attatched) do
			DeleteObject(v.handle)

			if v.slot then
				PlayerSlots[v.tier][v.slot].isBusy = false
			end

			if v.chain then
				carryingChain = nil
			end

			items_attatched[k] = nil
		end
	end

	DoItemCheck()
end

exports('refreshProps', refreshProps)

local function makeObjectBusy(item, state)
	if not FullyLoaded then return end
	if not item or not state then return print("YOU ARE MISSING ARGS FOR THIS EXPORT") end
	if not props[item] then return print("ITEM: " .. item .. " DOES NOT EXIST") end
	if props[item] and props[item].busy == nil then return print("ITEM: " .. item .. " CANNOT BE SET TO BUSY") end
	props[item].busy = state
	DoItemCheck()
end

exports('makeObjectBusy', makeObjectBusy)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ** GENERIC EVENTS ** --
AddEventHandler('ox_inventory:currentWeapon', function(data)
	if not FullyLoaded then return end
	if override then return end
	if data then
		data.name = data.name:lower()
		if props[data.name] and items_attatched[props[data.name].model] then
			DeleteWeapon(props[data.name].model)
		end
	else
		Wait(1000)
		DoItemCheck()
	end
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon', function(data)
	if data and LocalPlayer.state.isLoggedIn then
		if props[data.name] and items_attatched[props[data.name].model] then
			DeleteWeapon(props[data.name].model)
		end
	elseif not data and LocalPlayer.state.isLoggedIn then
		Wait(1000)
		if not override then DoItemCheck() elseif override and PlayerData.metadata.inside.apartment.apartmentId then DoItemCheck() end
	end
end)

-- Handles state right when the player selects their character and location.
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	Wait(20000)
	PlayerData = QBCore.Functions.GetPlayerData()
	FullyLoaded = true
	Wait(250)
	if not override then DoItemCheck() elseif override and PlayerData.metadata.inside.apartment.apartmentId then DoItemCheck() end
end)

-- Resets state on logout, in case of character change.
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
	PlayerData = nil
	FullyLoaded = false
end)

-- Handles state when PlayerData is changed. We're just looking for inventory updates.
RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
	PlayerData = val
	Wait(50)
	if not override then DoItemCheck() elseif override and PlayerData.metadata.inside.apartment.apartmentId then DoItemCheck() end
end)

-- Handles state if resource is restarted live.
AddEventHandler('onResourceStart', function(resource)
	if GetCurrentResourceName() == resource then
		Wait(100)
		if not FullyLoaded then return end
		DoItemCheck()
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for key, attached_object in pairs(items_attatched) do
			DeleteObject(attached_object.handle)
			items_attatched[key] = nil
		end
	end
end)
