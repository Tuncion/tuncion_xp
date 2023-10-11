-- Do not change anything in this file if you do not know what you are doing!

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "Tuncion"
description "This resource is a complete XP Handler for your server"
version "1.0.1"

shared_scripts {
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

ui_page 'nui/index.html'

files {
    'nui/*.**',
    'nui/**/*.**'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/classes/*.lua',
	'server/*.lua'
}

server_exports {

	-- Getter
	'getGlobalXP',
	'getGlobalRank',
	'getTotalXP',
	'getXP',
	'getNeededXP',
	'getRank',
	'getRankStage',
	'getXPLog',

	-- Setter
	'addXP',
	'removeXP',
	'setXP',
	'addRank',
	'removeRank',
	'setRank',
	'resetPlayer',
	'resetPlayerXP',

}