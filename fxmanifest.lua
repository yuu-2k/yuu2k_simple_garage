fx_version 'cerulean'

game 'gta5'
lua54 'yes'

description 'Yuu2k Simple Garage'
author 'Yuu2k'

version '1.0.0'

shared_script {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'shared.lua',
    'shared/*.lua',
}

client_scripts {
    'client/*.lua'
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

files {
  'locales/*.json'
}