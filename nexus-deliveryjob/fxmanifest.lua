fx_version 'cerulean'
game 'gta5'

author 'DakotaScripts'
description 'Delivery Job Script for QBCore'

version '0.0.1'

repository 'https://github.com/DakotaOhItxScripts'

dependencies {
    'qb-core',
    'qb-target',
    'ox_lib',
}

client_scripts {
    'client/cl_*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

server_scripts {
    'server/sv_*.lua',
}