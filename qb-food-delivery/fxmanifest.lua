fx_version 'cerulean'
game 'gta5'

author 'Lcts'
description 'L-FoodDelivery'
version '3.0.0'

lua54 'yes'

dependencies {
    'qb-core',
    'qb-target',
    'qb-inventory',
    'qb-input',
    'illenium-appearance',
}

shared_scripts {
    'shared/config_*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}