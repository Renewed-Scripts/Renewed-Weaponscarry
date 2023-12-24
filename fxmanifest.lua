fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

game 'gta5'

description 'Renewed Weaponscarry'
version '2.1.0'

shared_script '@ox_lib/init.lua'

client_script 'client/weapons.lua'
server_script 'server.lua'
files {
    'config.lua',
    'utils/client.lua',
}