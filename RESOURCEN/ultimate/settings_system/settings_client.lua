local sx, sy = guiGetScreenSize()
local w, h = 300, 200
local x = (sx/2) - (w/2)
local y = (sy/2) - (h/2)

local function showKeyBinds()

end

local function activateKeyBinds(settingsfile)
	showCursor(true)
	local mainwin = guiCreateWindow(x, y, w, h, "KeyBinds", false)
	local btnactivate = guiCreateButton(0.05, 0.20, 0.90, 0.20, "Aktivieren", true, mainwin)
	local btndeactivate = guiCreateButton(0.05, 0.50, 0.90, 0.20, "Deaktivieren", true, mainwin)
	addEventHandler("onClientGUIClick", btnactivate, function()
		if settingsfile then
			local xmlsettingsstate = xmlNodeGetChildren(settingsfile)
			if xmlsettingsstate then
				for i, v in pairs(xmlsettingsstate) do
					local keybindActivate = xmlNodeGetValue(v)
					xmlNodeSetValue(v, 1)
					xmlSaveFile(settingsfile)
					local keybindfile = xmlCreateFile("clientsettings/clientkeybinds.xml", "keybinds")
					showKeyBinds()
					destroyElement(mainwin)
				end
			end
		end
	end, false)
	addEventHandler("onClientGUIClick", btndeactivate, function()
		if settingsfile then
			local xmlsettingsstate = xmlNodeGetChildren(settingsfile)
			if xmlsettingsstate then
				for i, v in pairs(xmlsettingsstate) do
					local keybindActivate = xmlNodeGetValue(v)
					xmlNodeSetValue(v, 2)
					xmlSaveFile(settingsfile)
					showCursor(false)
					destroyElement(mainwin)
				end
			end
		end
	end, false)
	guiSetAlpha(mainwin, 1)
	guiWindowSetSizable(mainwin, false)
	guiWindowSetMovable(mainwin, false)
end

function checkSettingsFile()
	local settingsfile
	local file = "clientsettings/settingssystem.xml"
	if allowSettingKeyBinds == 1 then
		if not fileExists(file) then
			settingsfile = xmlCreateFile ( file, "clientdata" )
			local activatesettings = xmlCreateChild(settingsfile, "activate")
			xmlNodeSetValue ( activatesettings, "0" )
			xmlSaveFile(settingsfile)
		else
			settingsfile = xmlLoadFile(file)
		end
		if settingsfile then
			local xmlsettingsstate = xmlNodeGetChildren(settingsfile)
			if xmlsettingsstate then
				for i, v in pairs(xmlsettingsstate) do
					local keybindActivate = xmlNodeGetValue(v)
					outputDebugString(keybindActivate)
					if tonumber(keybindActivate) == 0 then
						activateKeyBinds(settingsfile)
					elseif tonumber(keybindActivate) == 1 then
						showKeyBinds()
					end
				end
			end
		end
	elseif allowSettingKeyBinds == 0 then
		return
	end
end

addCommandHandler("keysettings", function()
	checkSettingsFile()
end)