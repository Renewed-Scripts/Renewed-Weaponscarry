-- Intiate the statebag for the player
AddEventHandler('Renewed-Lib:server:playerRemoved', function(source)
    local playerState = Player(source).state

    playerState:set('weapons_carry', false, true)
    playerState:set('carry_items', false, true)
end)

AddEventHandler('Renewed-Lib:server:playerLoaded', function(source)
    local playerState = Player(source).state

    playerState:set('weapons_carry', false, true)
    playerState:set('carry_items', false, true)
end)