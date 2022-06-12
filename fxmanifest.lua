fx_version 'cerulean'
game 'gta5'
author 'negbook'

lua54 'yes'

escrow_ignore {
    'module/shared/*.*',
	'callback.lua',
    'client.lua',
    'config.lua',
    'server.lua',
    'commands/*.lua'
}

client_scripts {
'client.lua',
'module/shared/*.js',
'module/shared/*.lua',
'module/*.lua',
'commands/client.lua'
--'example.lua'
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