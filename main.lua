-- By Gauthier G.
-- This plugin allow to create group and layout view for Magic Panel in Extended Mode (116 channel).
-- v1.0
-- April 2021
-- offset entre les JDC dans le layout view
local layoutOffsetX = 8 -- Distance entre 2 instance main en X
local layoutOffsetY = 7 -- Distance entre 2 instance main en Y

local sleepTime = 0.1

-- Ne pas toucher au code en dessous

-- Shortcut :
local cmd = gma.cmd
local setvar = gma.show.setvar
local getvar = gma.show.getvar
local sleep = gma.sleep
local confirm = gma.gui.confirm
local msgbox = gma.gui.msgbox
local textinput = gma.textinput
local progress = gma.gui.progress
local getobj = gma.show.getobj
local property = gma.show.property

local function feedback(text)
    gma.feedback("Plugin Magic Panel : " .. text)
end

local function echo(text)
    gma.echo("Plugin Magic Panel : " .. text)
end

local function error(text)
    gma.gui.msgbox("Plugin Magic Panel ERROR", text)
end

local xmlFileContent =
    '<?xml version="1.0" encoding="utf-8"?><MA xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.malighting.de/grandma2/xml/MA" xsi:schemaLocation="http://schemas.malighting.de/grandma2/xml/MA http://schemas.malighting.de/grandma2/xml/3.9.0/MA.xsd" major_vers="1" minor_vers="0" stream_vers="0"><Info datetime="2020-11-14T01:13:58" showfile="gauthier guerisse" /><Group index="1" name="Magic Panel"><Subfixtures>'

