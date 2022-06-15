fx_version 'cerulean'
game 'gta5'
author 'negbook'

lua54 'yes'

client_scripts {
'client.lua',
'commands/client.lua'
}

server_scripts {
'server.lua',
'commands/receiver.lua'
}

shared_scripts {
    'config.lua',
    'callback.lua'
    
}

dependencies {
	'oxmysql'
}