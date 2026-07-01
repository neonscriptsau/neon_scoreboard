fx_version 'cerulean'
game 'gta5'

author 'Neon'
description 'Neon Scoreboard'

shared_scripts {
    'config.lua',
    'shared/*.lua',
}

client_scripts {
    'client/*.lua'
}
server_script {
    'server/*.lua'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/css/style.css',
    'web/js/script.js',
    'web/images/**/*'
}