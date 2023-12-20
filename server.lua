-- Intiate the statebag for the player
AddEventHandler('Renewed-Lib:server:playerRemoved', function(source)
    Player(source).state:set('weapons_carry', false, true)
end)

AddEventHandler('Renewed-Lib:server:playerLoaded', function(source)
    Player(source).state:set('weapons_carry', false, true)
end)