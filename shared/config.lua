Config = Config or {}

Config.itemProps = {
    ---- ** Drugs ** ----
    -- Weed
    ["wetbud"] = {
        model = "bkr_prop_weed_drying_02a",
        hash = joaat("bkr_prop_weed_drying_02a"),
        tier = 1,
        yr = 90.0
    },
    -- meth
    ["meth"] = {
        model = "hei_prop_pill_bag_01",
        hash = joaat("hei_prop_pill_bag_01"),
        tier = 3
    },
    -- Contraband
    ["markedbills"] = {
        model = "prop_money_bag_01",
        hash = joaat("prop_money_bag_01"),
        tier = 3,
        x = -0.47,
        zr = 0
    }, -- If you put any x,y,z,xr,yr,zr it will offset it from the slots to make it fit perfectly

    -- Custom Weapons Tier 1
    ["weapon_assaultrifle"]  = {
        model = "w_ar_assaultrifle",
        hash = joaat("weapon_assaultrifle"),
        tier = 1
    },
    ["weapon_carbinerifle"]  = {
        model = "w_ar_carbinerifle",
        hash = joaat("weapon_carbinerifle"),
        tier = 1
    },
    ["weapon_advancedrifle"] = {
        model = "w_ar_advancedrifle",
        hash = joaat("weapon_advancedrifle"),
        tier = 1
    },
    ["weapon_combatpdw"]     = {
        model = "w_sb_mpx",
        hash = joaat("weapon_combatpdw"),
        tier = 1
    },
    ["weapon_compactrifle"]  = {
        model = "w_ar_draco",
        hash = joaat("weapon_compactrifle"),
        tier = 1
    },
    ["weapon_m4"]            = {
        model = "w_ar_m4",
        hash = joaat("weapon_m4"),
        tier = 1
    },

    -- tier2
    ["weapon_bats"]      = {
        model = "w_me_baseball_bat_barbed",
        hash = joaat("weapon_bats"),
        tier = 2
    },
    ["weapon_katana"]    = {
        model = "katana_sheath", -- Use the weapon model if you do not own npas-props
        hash = joaat("weapon_katana"),
        tier = 2,
        zr = -90.0, xr = -40.0,
        y = -0.14, x = 0.2, z = -0.08
    },
    ["weapon_golfclub"]  = {
        model = "w_me_gclub",
        hash = joaat("weapon_golfclub"),
        tier = 2
    },
    ["weapon_battleaxe"] = {
        model = "w_me_battleaxe",
        hash = joaat("weapon_battleaxe"),
        tier = 2
    },
    ["weapon_crowbar"]   = {
        model = "w_me_crowbar",
        hash = joaat("weapon_crowbar"),
        tier = 2
    },
    ["weapon_wrench"]    = {
        model = "w_me_wrench",
        hash = joaat("weapon_wrench"),
        tier = 2
    },
}