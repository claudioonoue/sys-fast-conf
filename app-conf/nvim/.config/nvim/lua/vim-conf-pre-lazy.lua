local remap = require("config.keymap-remap")
local editorSettings = require("config.editor-settings")
local autocommands = require("config.autocommands")

remap.setup()
editorSettings.setup()
autocommands.setup()
