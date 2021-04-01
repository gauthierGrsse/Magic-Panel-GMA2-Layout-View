-- By Gauthier G.
-- This plugin allow to create group and layout view for Magic Panel in Extended Mode (116 channel).
-- v1.0
-- April 2021
-- offset entre les JDC dans le layout view
local layoutOffsetX = 8 -- Distance entre 2 instance main en X
local layoutOffsetY = 10 -- Distance entre 2 instance main en Y

local maxNbrXInLayout = 10

local sleepTime = 0.05

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

local function mainInstanceSelect(fixture)
    cmd("Fixture " .. fixture .. ".1")
end

local function ledInstanceSelect(fixture)
    cmd("Fixture " .. fixture .. ".2 Thru " .. fixture .. ".26")
end

local function storeGroup(ID, label)
    cmd("Store Group " .. ID)
    cmd("Label Group "..ID.." \"" .. label .. "\"")
end

local function defFixtInLayout(fixture)
    for x = 1, 26, 1 do
        xmlFileContent = xmlFileContent .. '<Subfixture fix_id="' .. fixture .. '" sub_index="' .. x .. '" />'
    end
end

local function setupFixtureInLayout(fixture, offset_x, offset_y)
    for x = 1, 26, 1 do
        if x == 1 then
            pos_x = 0 + offset_x
            pos_y = 0 + offset_y
            xmlFileContent = xmlFileContent .. '<LayoutSubFix center_x="' .. pos_x .. '" center_y="' .. pos_y ..
                                 '" size_h="1" size_w="1" background_color="00000000" icon="None" show_id="1" show_type="1" function_type="Filled" select_group="1"><image /><Subfixture fix_id="' ..
                                 fixture .. '" sub_index="' .. x .. '" /></LayoutSubFix>'
        elseif x >= 2 and x <= 6 then
            pos_x = x - 2 + offset_x
            pos_y = 2 + offset_y
            xmlFileContent = xmlFileContent .. '<LayoutSubFix center_x="' .. pos_x .. '" center_y="' .. pos_y ..
                                 '" size_h="1" size_w="1" background_color="00000000" icon="None" show_id="1" show_type="1" function_type="Filled" select_group="1"><image /><Subfixture fix_id="' ..
                                 fixture .. '" sub_index="' .. x .. '" /></LayoutSubFix>'
        elseif x >= 7 and x <= 11 then
            pos_x = x - 7 + offset_x
            pos_y = 3 + offset_y
            xmlFileContent = xmlFileContent .. '<LayoutSubFix center_x="' .. pos_x .. '" center_y="' .. pos_y ..
                                 '" size_h="1" size_w="1" background_color="00000000" icon="None" show_id="1" show_type="1" function_type="Filled" select_group="1"><image /><Subfixture fix_id="' ..
                                 fixture .. '" sub_index="' .. x .. '" /></LayoutSubFix>'
        elseif x >= 12 and x <= 16 then
            pos_x = x - 12 + offset_x
            pos_y = 4 + offset_y
            xmlFileContent = xmlFileContent .. '<LayoutSubFix center_x="' .. pos_x .. '" center_y="' .. pos_y ..
                                 '" size_h="1" size_w="1" background_color="00000000" icon="None" show_id="1" show_type="1" function_type="Filled" select_group="1"><image /><Subfixture fix_id="' ..
                                 fixture .. '" sub_index="' .. x .. '" /></LayoutSubFix>'
        elseif x >= 17 and x <= 21 then
            pos_x = x - 17 + offset_x
            pos_y = 5 + offset_y
            xmlFileContent = xmlFileContent .. '<LayoutSubFix center_x="' .. pos_x .. '" center_y="' .. pos_y ..
                                 '" size_h="1" size_w="1" background_color="00000000" icon="None" show_id="1" show_type="1" function_type="Filled" select_group="1"><image /><Subfixture fix_id="' ..
                                 fixture .. '" sub_index="' .. x .. '" /></LayoutSubFix>'
        elseif x >= 22 and x <= 26 then
            pos_x = x - 22 + offset_x
            pos_y = 6 + offset_y
            xmlFileContent = xmlFileContent .. '<LayoutSubFix center_x="' .. pos_x .. '" center_y="' .. pos_y ..
                                 '" size_h="1" size_w="1" background_color="00000000" icon="None" show_id="1" show_type="1" function_type="Filled" select_group="1"><image /><Subfixture fix_id="' ..
                                 fixture .. '" sub_index="' .. x .. '" /></LayoutSubFix>'
        end
    end
end

local function start()
    gma.feedback("--- Magic Panel instances group and layout creator ---")

    local startID = tonumber(textinput("Start Fixture ID", ""))
    local endID = tonumber(textinput("End Fixture ID", ""))
    local startGroupID = tonumber(textinput("Start Group ID (2 available group)", ""))
    local layoutViewID = tonumber(textinput("Layout View ID", ""))

    if (startID > endID) then -- test pour remettre dans l'ordre les 2 nombres
        local bridge = endID
        endID = startID
        startID = bridge
    end

    if (gma.gui.confirm("Confirm", "Confirm Magic Panel instances group and layout create for Fixture " .. startID ..
        " to " .. endID .. " ?")) then
        feedback("Create group and layout confirm for Magic Panel Fixture " .. startID .. " to " .. endID)

        progress_bar = gma.gui.progress.start("Magic Panel Instance Plugin")
        gma.gui.progress.setrange(progress_bar, 0, 5)

        -- Main Instance
        for x = startID, endID, 1 do
            mainInstanceSelect(x)
            gma.sleep(sleepTime)
        end
        storeGroup(startGroupID, "MagicPanel Main")
        gma.cmd("ClearAll")
        gma.gui.progress.set(progress_bar, 1)

        -- LED instances
        for x = startID, endID, 1 do
            ledInstanceSelect(x)
            gma.sleep(sleepTime)
        end
        storeGroup(startGroupID + 1, "MagicPanel LED")
        gma.cmd("ClearAll")
        gma.gui.progress.set(progress_bar, 2)

        -- Declare fixtures in layout xml
        for x = startID, endID, 1 do
            defFixtInLayout(x)
            gma.sleep(sleepTime)
            feedback("Def fixture " .. x .. " in layout xml")
        end
        gma.gui.progress.set(progress_bar, 3)

        -- Add mid content in xml
        xmlFileContent = xmlFileContent ..
                             "</Subfixtures><LayoutData index='0' marker_visible='true' background_color='000000' visible_grid_h='1' visible_grid_w='1' snap_grid_h='0.5' snap_grid_w='0.5' default_gauge='Filled &amp; Symbol' subfixture_view_mode='DMX Layer'><SubFixtures>"

        -- Setup fixtures in layout xml
        local countFixture = 0
        local countFixtureY = 0
        for x = startID, endID, 1 do
            setupFixtureInLayout(x, countFixture * layoutOffsetX, countFixtureY * layoutOffsetY)
            feedback("Setup fixture " .. x .. " in layout xml")
            countFixture = countFixture + 1
            if (countFixture >= maxNbrXInLayout) then
                countFixture = 0
                countFixtureY = countFixtureY + 1
            end
            gma.sleep(sleepTime)
        end
        gma.gui.progress.set(progress_bar, 4)

        -- Finish xml
        xmlFileContent = xmlFileContent .. "</SubFixtures></LayoutData></Group></MA>"

        -- Store xml variable in xml file (Thanks to Florian ANAYA)
        local fileName = "layouttemp.xml"
        local filePath = gma.show.getvar('PATH') .. '/importexport/' .. fileName
        local file = io.open(filePath, "w")
        file:write(xmlFileContent)
        file:close()
        feedback("XML File created")

        -- Import xml in layout
        gma.cmd('Import "' .. fileName .. '" Layout ' .. layoutViewID)
        feedback("Layout imported")
        gma.gui.progress.set(progress_bar, 5)

        gma.sleep(sleepTime)
        gma.gui.progress.stop(progress_bar)
        gma.feedback("--- Magic Panel instances group creator finished ---")
    else
        error("Operation canceled")
        gma.feedback("--- Magic Panel instances group creator finished ---")
    end
end

return start