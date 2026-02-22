fx_version 'cerulean'
game 'gta5'

author 'DakotaScripts'
description 'Delivery Job Script for Qbcore BETA'

version '0.0.1'

repository 'https://github.com/DakotaOhItxScripts'

client_scripts {
    'client/cl_*.lua',
}

shared_scripts {
    'config.lua',
    --'@es_extended/imports.lua' --[[ Uncomment if using ESX ]]
    --'@ND_Core/init.lua'        --[[ Uncomment if using ND-Core ]]
}

server_scripts {
    'server/sv_*.lua',
}