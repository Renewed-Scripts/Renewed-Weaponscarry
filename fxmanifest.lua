fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

game 'gta5'

description 'Renewed Weaponscarry'
version '2.1.1'

shared_script '@ox_lib/init.lua'

client_scripts {
    'client/weapons.lua',
    'client/vehicles.lua',
}
server_script 'server.lua'
files {
    'config.lua',
    'utils/client.lua',
}