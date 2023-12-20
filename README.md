# Renewed Weaponscarry 2.0
### Support my free work here
<a href='https://ko-fi.com/FjamZoo' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' />
</a>

## [Renewed Discord](https://discord.gg/P3RMrbwA8n)

# Description
Renewed Weaponscarry 2.0 is a brand new version of weaponscarry boast some of the best features for Roleplay such as.

- Synced Components | Skins  and Tints
- Client sided objects, NO NETWORKED ENTITIES
- Entity Lockdown Mode support
- Filter Request Control 4 support
- All done via statebags no shittery
- Plug and Play for ox_inventory

# How to install
1. Download the latest version of the script
2. Extract the files to your server root directory
3. Add the following line to your server.cfg file `ensure Renewed-Weaponscarry`
4. ENJOY!

# Dependencies
1. [ox_inventory](https://github.com/overextended/ox_inventory)
2. [ox_lib](https://github.com/overextended/ox_lib/tree/master)
3. [Renewed-Lib](https://github.com/Renewed-Scripts/Renewed-Lib)


# How to add new Items

Here's everything you need to know about adding new items to the script

## Creating a new Player Slot
First off you would need to create a new player slot, this is done by adding a new line to the `local PlayerSlots` table in utils/client.lua, here's an example of how it would look like

```lua
    { -- More contraband that will be on a player somewhere
        {bone = 24817, pos = vec3(-0.38, -0.24, 0.15), rot = vec3(0.0, 92.0, -13.0)},
        {bone = 24817, pos = vec3(-0.37, -0.24, 0.15), rot = vec3(0.0, 92.0, 13.0)},
    },

    -- It can be quite hard to get the actual placements I have used this one and I would highly recommend it
    -- https://forum.cfx.re/t/paid-dev-tool-prop-attach-to-ped-tool/4782266
```

Note that this is actually not real placements just a showcase of how its done

## Adding a new Weapon
Here you must have have a PlayerSlot thats ready and defined heres an example of how to add a new weapon, in this case I will use player slot number 1 which is used for bigger weapons that should stick out of the players back.

```lua
    weapon_rpg = {
        slot = 1
    },
```

### Misc Information.
How to locate the different props I normally use this website: https://forge.plebmasters.de/
For bones its either trial or error with the tool above or you can use this website: https://wiki.rage.mp/index.php?title=Bones
