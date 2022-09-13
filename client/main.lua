local QBCore = exports['qb-core']:GetCoreObject()

--[[
  This is PlayerSlots here we define the Category of the weapons that goes on the Player
  This means that instead of giving each weapon a designated slot on the back, we can just add a weapon with the designated slot
  This will also allow for weapons to feel and look more natural when added.

  All items that go on your back -> MUST have a SLOT CATEGORY, everything that we CARRY must have Carry = true
]]
local PlayerSlots = {
  [1] = { -- Bigger weapons such as bats, crowbars, Assaultrifles, and also good place for wet weed.
    [1] = {bone = 24817, x = 0.04, y = -0.15, z = 0.12, xr = 0.0, yr = 0.0, zr = 0.0, isBusy = false},
    [2] = {bone = 24817, x = 0.04, y = -0.17, z = 0.02, xr = 0.0, yr = 0.0, zr = 0.0, isBusy = false},
    [3] = {bone = 24817, x = 0.04, y = -0.15, z = -0.12, xr = 0.0, yr = 0.0, zr = 0.0, isBusy = false},
  },

  [2] = { -- Use this for katana knives etc. stuff that goes sideways on the players body
    [1] = {bone = 24817, x = -0.13, y = -0.16, z = -0.14, xr = 5.0, yr = 62.0, zr = 0.0, isBusy = false},
    [2] = {bone = 24817, x = -0.13, y =  -0.15, z =  0.10, xr = 5.0, yr = 124.0, zr = 0.0, isBusy = false},
  },

  [3] = { -- Contraband like Drugs and shit
    [1] = {bone = 24817, x = -0.28, y = -0.14, z = 0.15, xr = 0.0, yr = 92.0, zr = -13.0},
    [2] = {bone = 24817, x = -0.27, y = -0.14, z = 0.15, xr = 0.0, yr = 92.0, zr = 13.0},
  },

  [4] = { -- I use this for the pelts for hunting
    [1] = {bone = 24817, x = -0.18, y = -0.26, z = -0.02, xr = 0.0, yr = 91.0, zr = 5.0},
    [2] = {bone = 24817, x = 0.10, y = -0.26, z = -0.02, xr = 0.0, yr = 91.0, zr = 5.0},
    [3] = {bone = 24817, x = 0.38, y = -0.21, z = -0.02, xr = 0.0, yr = 91.0, zr = 5.0},
  },

  [5] = { -- I use this for chains, make sure your CHAIN is a CUSTOM prop, will NOT work with a clothing item, if you want to add a CHAIN make sure to have a chain = true as it will not work the same as weapons --
    [1] = {bone = 10706, x = 0.11, y = 0.080, z = -0.473, xr = -366.0, yr = 19.0, zr = -163.0},
  },
}



-- Add your items here --
local props = {
  ---- ** Drugs ** ----
  -- Weed
  ["wetbud"]                    = { model = "bkr_prop_weed_drying_02a", hash = joaat("bkr_prop_weed_drying_02a"), tier = 1, yr = 90.0}, -- This is more of an item that deserves a

  -- meth
  ["meth"]                      = { model = "hei_prop_pill_bag_01", hash = joaat("hei_prop_pill_bag_01"), tier = 3},

  -- Contraband
  ["markedbills"]               = { model = "prop_money_bag_01",  hash = joaat("prop_money_bag_01"), tier = 3, x = -0.47, zr = 0}, -- If you put any x,y,z,xr,yr,zr it will offset it from the slots to make it fit perfectly

  -- Custom Weapons Tier 1
  ["weapon_assaultrifle"]       = { model = "w_ar_assaultrifle",        hash = joaat("weapon_assaultrifle"), tier = 1},
  ["weapon_carbinerifle"]       = { model = "w_ar_carbinerifle",        hash = joaat("weapon_carbinerifle"), tier = 1},
  ["weapon_advancedrifle"]      = { model = "w_ar_advancedrifle",       hash = joaat("weapon_advancedrifle"), tier = 1},
  ["weapon_combatpdw"]          = { model = "w_sb_mpx",                 hash = joaat("weapon_combatpdw"), tier = 1},
  ["weapon_compactrifle"]       = { model = "w_ar_draco",               hash = joaat("weapon_compactrifle"), tier = 1},
  ["weapon_m4"]                 = { model = "w_ar_m4",                  hash = joaat("weapon_m4"), tier = 1},


  -- tier2
  ["weapon_bats"]               = { model = "w_me_baseball_bat_barbed", hash = joaat("weapon_bats"), tier = 2},
  ["weapon_katana"]             = { model = "katana_sheath",            hash = joaat("weapon_katana"), tier = 2, zr = -90.0, xr = -40.0, y = -0.14, x = 0.2, z = -0.08},
  ["weapon_golfclub"]           = { model = "w_me_gclub",               hash = joaat("weapon_golfclub"), tier = 2},
  ["weapon_battleaxe"]          = { model = "w_me_battleaxe",           hash = joaat("weapon_battleaxe"), tier = 2},
  ["weapon_crowbar"]            = { model = "w_me_crowbar",             hash = joaat("weapon_crowbar"), tier = 2},
  ["weapon_wrench"]             = { model = "w_me_wrench",              hash = joaat("weapon_wrench"), tier = 2},

  -- These Utilize the NoPixel pelts from their packages get them here: https://3dstore.nopixel.net/package/5141816 --
  ["deer_pelt_1"]               = { model = "hunting_pelt_01_a",        hash = joaat("hunting_pelt_01_a"), tier = 4},
  ["deer_pelt_2"]               = { model = "hunting_pelt_01_b",        hash = joaat("hunting_pelt_01_b"), tier = 4},
  ["deer_pelt_3"]               = { model = "hunting_pelt_01_c",        hash = joaat("hunting_pelt_01_c"), tier = 4},


  -- I use these for my house robbery when they steal the objects --
  ["telescope"]                 = { carry = true,   model = "prop_t_telescope_01b",   bone = 24817, x = -0.23,  y = 0.43, z = 0.05, xr = -10.0, yr = 93.0,   zr = 0.0,    blockAttack = true, blockCar = true, blockRun = true,},
  ["pcequipment"]               = { carry = true,   model = "prop_dyn_pc_02",         bone = 24817, x = 0.09,   y = 0.43, z = 0.05, xr = 91.0,  yr = 0.0,    zr = -265.0, blockAttack = true, blockCar = true, blockRun = true},
  ["coffeemaker"]               = { carry = true,   model = "prop_coffee_mac_02",     bone = 24817, x = 0.00,   y = 0.43, z = 0.05, xr = 91.0,  yr = 0.0,    zr = -265.0, blockAttack = true, blockCar = true, blockRun = true},
  ["musicequipment"]            = { carry = true,   model = "prop_speaker_06",        bone = 24817, x = 0.00,   y = 0.43, z = 0.05, xr = 91.0,  yr = 0.0,    zr = -265.0, blockAttack = true, blockCar = true, blockRun = true},
  ["microwave"]                 = { carry = true,   model = "prop_microwave_1",       bone = 24817, x = -0.20,  y = 0.43, z = 0.05, xr = 91.0,  yr = 0.0,    zr = -265.0, blockAttack = true, blockCar = true, blockRun = true},

}

local items_attatched = {}
local itemSlots = {}
local override = false

local PlayerData = QBCore.Functions.GetPlayerData()

local FullyLoaded = LocalPlayer.state.isLoggedIn



local function loadmodel(hash)
  if HasModelLoaded(hash) then return end
	RequestModel(hash)
  while not HasModelLoaded(hash) do
    Wait(0)
  end
end


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

local function AttachWeapon(attachModel,modelHash, tier, item)
  local hash = joaat(attachModel)
  local slot = UseSlot(tier)
  if not slot then return end

  local v = PlayerSlots[tier][slot]
  local bone = GetPedBoneIndex(PlayerPedId(), v.bone)

  loadmodel(hash)

  items_attatched[attachModel] = {
    hash = modelHash,
    handle = CreateObject(attachModel, 1.0, 1.0, 1.0, true, true, false),
    slot = slot,
    tier = tier
  }

  local x, y, z, xr, yr, zr = calcOffsets(v.x, v.y, v.z, v.xr, v.yr, v.zr, item)

	AttachEntityToEntity(items_attatched[attachModel].handle, PlayerPedId(), bone, x, y, z, xr, yr, zr, 1, 1, 0, 0, 2, 1)
  SetModelAsNoLongerNeeded(hash)
  SetEntityCompletelyDisableCollision(items_attatched[attachModel].handle, false, true)
end

local WeapDelete = false
local function DeleteWeapon(item)
  local ped = PlayerPedId()
  local hash = items_attatched[item].hash
  if WeapDelete then return end

  WeapDelete = true
  local wait = 0 -- if above 3 seconds then return this function
  while GetSelectedPedWeapon(ped) ~= hash do
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
local carryingBox = nil

local function requestAnimDict(animDict)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Wait(0)
		end
	end
end


-- Should probably allow for different animations for different items down the line --
local function doAnim(item)
  if carryingBox then return end -- Only allow the function to be run once at a time
  carryingBox = item
  local ped = PlayerPedId()
  local dict, anim = props[items].dict or 'anim@heists@box_carry@', props[item].anim or 'idle'

  requestAnimDict(dict)
  CreateThread(function()
    while carryingBox do
      if not anim == 'none' and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, 49, 0, 0, 0, 0)
      end

      if props[carryingBox].blockAttack then
        DisableControlAction(0, 24, true) -- disable attack
        DisableControlAction(0, 25, true) -- disable aim
        DisableControlAction(0, 47, true) -- disable weapon
        DisableControlAction(0, 58, true) -- disable weapon
        DisableControlAction(0, 263, true) -- disable melee
        DisableControlAction(0, 264, true) -- disable melee
        DisableControlAction(0, 257, true) -- disable melee
        DisableControlAction(0, 140, true) -- disable melee
        DisableControlAction(0, 141, true) -- disable melee
        DisableControlAction(0, 142, true) -- disable melee
        DisableControlAction(0, 143, true) -- disable melee
      end

      if props[carryingBox].blockCar and IsPedGettingIntoAVehicle(ped) then
        ClearPedTasksImmediately(ped) -- Stops all tasks for the ped
      end

      if props[carryingBox].blockRun then
        DisableControlAction(0, 22, true) -- disable jumping
        DisableControlAction(0, 21, true) -- disable sprinting
      end

      Wait(1)
    end

    ClearPedTasks(ped)
  end)
end



local function AttatchProp(item)
  if carryingBox then return end
  local ped = PlayerPedId()
  local attachModel = props[item].model
  local hash = joaat(props[item].model)
  local bone = GetPedBoneIndex(ped, props[item].bone)
  SetCurrentPedWeapon(ped, 0xA2719263)
  loadmodel(hash)

  items_attatched[attachModel] = {
    hash = hash,
    handle = CreateObject(attachModel, 1.0, 1.0, 1.0, true, true, false),
    carry = true
  }

  local x, y, z, xr, yr, zr = props[item].x,props[item].y,props[item].z,props[item].xr,props[item].yr,props[item].zr
  AttachEntityToEntity(items_attatched[attachModel].handle, ped, bone, x, y, z, xr, yr, zr, 1, 1, 0, 0, 2, 1)
  SetModelAsNoLongerNeeded(hash)
  SetEntityCompletelyDisableCollision(items_attatched[attachModel].handle, false, true)
  doAnim(item)
end

local tempBox = nil

-- Exports to trick the script into thinking we got an item we can carry --
local function carryProp(item)
  if not item then return print("ITEM NOT DEFINED") end
  if not props[item] then return print("ITEM NOT REGISTERED IN THE CONFIG") end
  if carryingBox then return print("PED IS ALREADY CARRYING AN OBJECT") end
  tempBox = item
  AttatchProp(item)
end exports('carryProp', carryProp)

local function removeProp(item)
  if not item then return print("ITEM NOT DEFINED") end
  if not props[item] then return print("ITEM NOT REGISTERED IN THE CONFIG") end
  if carryingBox ~= item then return print("Item is not whats being carried...") end
  DeleteObject(items_attatched[props[item].model].handle)
  items_attatched[props[item].model] = nil
  carryingBox = nil
  tempBox = nil
end exports('removeProp', removeProp)



local carryingChain = nil

local function AttatchChain(attachModel, modelHash, tier, item)
  if carryingChain then return end
  carryingChain = attachModel
  local slot = UseSlot(tier)
  if not slot then return end

  local v = PlayerSlots[tier][slot]
  local bone = GetPedBoneIndex(PlayerPedId(), v.bone)

  loadmodel(modelHash)

  ClearPedTasks(PlayerPedId())


  items_attatched[attachModel] = {
    hash = modelHash,
    handle = CreateObject(attachModel, 1.0, 1.0, 1.0, true, true, false),
    slot = slot,
    tier = tier,
    chain = true,
  }

  local x, y, z, xr, yr, zr = calcOffsets(v.x, v.y, v.z, v.xr, v.yr, v.zr, item)

	AttachEntityToEntity(items_attatched[attachModel].handle, PlayerPedId(), bone, x, y, z, xr, yr, zr, 1, 1, 0, 0, 2, 1)
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
    for k, v in pairs(items_attatched)do
      local hasitem = false
      local item = getItemByhash(v.hash)
      if item then
        if tempBox ~= item then
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

            if v.carry then
              carryingBox = nil
            end

            items_attatched[k] = nil
          end
        end
      end
    end
  end
end


local doingCheck = false
local function DoItemCheck()
  if not FullyLoaded then return end
  if doingCheck then return end
  doingCheck = true
  Wait(math.random(1, 100)) -- When shooting a gun, the event is called HUNDREDS of times, this here is to prevent that from affecting the players MS too much at a time.
  local ped = PlayerPedId()
  local items = PlayerData.items
  itemSlots = {}
  if items then
    for _, item in pairs(items) do
      if item and item.name and props and props[item.name] and not itemSlots[item.name] then
        itemSlots[item.name] = props[item.name]
        if props[item.name].carry then
          if not carryingBox then
            AttatchProp(item.name)
          end
        elseif props[item.name].chain then
          if not carryingChain then
            AttatchChain(props[item.name].model, props[item.name].hash, props[item.name].tier, item.name)
          end
        elseif not items_attatched[props[item.name].model] and GetSelectedPedWeapon(ped) ~= props[item.name].hash and getFreeSlot(props[item.name].tier) >= 1 then
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

        if v.carry then
          carryingBox = nil
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

          if v.carry then
            carryingBox = nil
          end

          if v.chain then
            carryingChain = nil
          end

          items_attatched[k] = nil
        end
      end
  end
end exports("toggleProps", toggleProps)

local function isCarryingObject()
  return carryingBox ~= nil and true or false
end exports('isCarryingObject', isCarryingObject)

local function GetPlayerCarryItems()
  return items_attatched
end exports('GetPlayerCarryItems', GetPlayerCarryItems)

local function refreshProps()
  if not FullyLoaded then return end
  if items_attatched then
    for k, v in pairs(items_attatched) do
      DeleteObject(v.handle)

      if v.slot then
        PlayerSlots[v.tier][v.slot].isBusy = false
      end

      if v.carry then
        carryingBox = nil
      end

      if v.chain then
        carryingChain = nil
      end

      items_attatched[k] = nil
    end
  end

  DoItemCheck()
end exports('refreshProps', refreshProps)

local function makeObjectBusy(item, state)
  if not FullyLoaded then return end
  if not item or not state then return print("YOU ARE MISSING ARGS FOR THIS EXPORT") end
  if not props[item] then return print("ITEM: "..item.." DOES NOT EXIST") end
  if props[item] and props[item].busy == nil then return print("ITEM: "..item.." CANNOT BE SET TO BUSY") end
  props[item].busy = state
  DoItemCheck()
end exports('makeObjectBusy', makeObjectBusy)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ** GENERIC EVENTS ** --
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
