return {

    -- Used in Renewed-Fuel
    oilbarrel = {
        slowMovement = 10, -- Slow playermovement by percentage, 100 = cant walk, 0 = normal speed. (recommend 10-20)
        model = `prop_barrel_exp_01a`,
        pos = vec3(0.01, -0.27, 0.27),
        rot = vec3(3.0, 0.0, 0.0),
        bone = 28422,
        dict = 'anim@heists@box_carry@',
        anim = 'idle',
        disableKeys = {
            disableSprint = true,
            disableJump = true,
            disableAttack = true,
            disableDriving = true,
            disableVehicleEnter = true
        }
    },


    -- Used in Renewed-Garbagejob
    trashbag = {
        model = `prop_cs_rub_binbag_01`,
        pos = vec3(0.0, 0.0, 0.0),
        rot = vec3(180.0, 200.0, 80.0),
        bone = 28422,
        dict = 'anim@heists@narcotics@trash',
        anim = 'walk',
        disableKeys = {
            disableSprint = false,
            disableJump = true,
            disableAttack = true,
            disableVehicle = true
        }
    },
}
