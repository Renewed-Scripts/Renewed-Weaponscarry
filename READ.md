# Renewed Weapons and Carry Script
<a href='https://ko-fi.com/FjamZoo' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' />
</a>

[Renewed Discord](https://discord.gg/P3RMrbwA8n)

# Description

Welcome to Renewed Weapons and Carry Script, this script allows user to define Player slots when it comes to weapons / items on the players back along with a few other features such as.

Carrying items that can affect how the player reacts such as stopping them from sprint, getting in vehicles and much more!

[Preview](https://streamable.com/deh7tk)

# How to install
Step 3 and 4 are skippable if you do not use qb-apartments or dont use qb-apartments with routing buckets

1. Download the latest version of the script
2. Extract the files to your server root directory
3. Head over to your qb-apartments and add this `exports['qb-smallresources']:toggleProps()` to line 256 right under Wait(250) in the function EnterApartment
4. Now scroll down till you find `local function LeaveApartment` and past this right under it around line 317 `exports['qb-smallresources']:toggleProps()`
5. Add the following line to your server.cfg file `ensure Renewed-Weaponscarry`
6. ENJOY!

# Additional Information // Exports

1. `exports["Renewed-Weaponscarry"]:GetPlayerCarryItems()` - Returns a table of all the items the player is carrying

2. `exports["Renewed-Weaponscarry"]:toggleProps()` - Toggles the props for the player and wont load them untill they are toggled back on OR if they are in their apartments

3. `exports["Renewed-Weaponscarry"]:refreshProps()` - Refreshes the props for the player toggle this at at the END of your refreshskin events to make sure the props get removed and refreshed the proper way

4. `exports["Renewed-Weaponscarry"]:isCarryingObject()` - Returns true if the player is carrying an any item

5. `exports["Renewed-Weaponscarry"]:makeObjectBusy(item, toggle)` - This acts as if the particular item was removed or used by the player, this is useful for items that can be used multiple times such as a fishing rod, this would allow the player to when they start using the rod for it to be removed on the back untill they are done using it

6. `exports["Renewed-Weaponscarry"]:carryProp(item)` - Acts as if the player was given x item to carry, this DOES NOT work with weapons on back ONLY CARRYABLE items

7. `exports["Renewed-Weaponscarry"]:removeProp(item)` - Acts as if x item was removed from the player, this DOES NOT work with weapons on back ONLY CARRYABLE items

# How to add new Items

Here's everything you need to know about adding new items to the script

## Creating a new Player Slot
First off you would need to create a new player slot, this is done by adding a new line to the `local PlayerSlots` table, here's an example of how it would look like

```lua
    [6] = { -- More contraband that will be on a player somewhere
        [1] = {bone = 24817, x = -0.38, y = -0.24, z = 0.15, xr = 0.0, yr = 92.0, zr = -13.0},
        [2] = {bone = 24817, x = -0.37, y = -0.24, z = 0.15, xr = 0.0, yr = 92.0, zr = 13.0},
    },

    x = the x position of the Players Slot, y = y etc. you get the idea.
    It can be quite hard to get the actual placements I have used this one and I would highly recommend it
    https://forum.cfx.re/t/paid-dev-tool-prop-attach-to-ped-tool/4782266
```

Note that this is actually not real placements just a showcase of how its done

## Adding a new Weapon
Here you must have have a PlayerSlot thats ready and defined heres an example of how to add a new weapon, in this case I will use player slot number 1 which is used for bigger weapons that should stick out of the players back.

```lua
    ["weapon_rpg"] = { model = "w_lr_rpg", hash = joaat("w_lr_rpg"), tier = 1},
```

The name in the brackets is the actual name of the weapon thats in your shared. The model name is the name of the model of the gun in this case I found a RPG model. The hash is the hash of the weapon, and the tier is the player slot it should be in, in this case 1

If the prop for some reason do not fit the slot you can add a custom offset by adding x = smt or y = smt or z = smt or xr = smt or yr = smt or zr = smt, just depends on how the rotation of the item you are trying to add is different from the other items in the slot.

## Adding a new Carryable Item
Here's how you add a new item to be Carryable, in this demonstration I used a oil barrel that can be used to whatever you would want or just as a cool prop to hold.

```lua
    ["oil_barrel"] = { carry = true, model = "prop_barrel_exp_01a", bone = 28422, x = 0.01, y = -0.27, z =  0.27, xr = 3.0, yr = 0.0, zr = 0.0, blockAttack = true, blockCar = true, blockRun = true},

    If an item you want to carry then make sure it says carry = true.
    The model is the model of the item you want to carry, in this case I used a oil barrel.
    The bone is the bone you want the item to be attached to, in this case I used the bone 28422
    the xyr and xr yr zr are all the cordinates and rotations which you can find by using the tool above.
    blockAttack = true means that the player will not be able to attack while carrying this item
    blockCar = true means that the player will not be able to get in a vehicle while carrying this item
    blockRun = true means that the player will not be able to run or jump while carrying this item
```


### Misc Information.
How to locate the different props I normally use this website: https://forge.plebmasters.de/
For bones its either trial or error with the tool above or you can use this website: https://wiki.rage.mp/index.php?title=Bones