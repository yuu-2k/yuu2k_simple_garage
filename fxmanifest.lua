fx_version 'cerulean'

game 'gta5'
lua54 'yes'

description 'Y Simple Garage'
author 'yuu-Studio'

version '1.0.0'

shared_script {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
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