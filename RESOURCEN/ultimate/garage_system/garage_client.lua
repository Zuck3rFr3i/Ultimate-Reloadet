addEvent("garagesystem:interact_owned", true)
addEventHandler("garagesystem:interact_owned", localPlayer, function(garage)
	if getElementData(localPlayer, "interacting") ~= 1 then
		local sx, sy = guiGetScreenSize()
		local int_width, int_height = 300, 200
		local x = (sx/2) - (int_width/2)
		local y = (sy/2) - (int_height/2)
		guielem_garagemanageframe = guiCreateWindow(x, y, int_width, int_height, "Deine garage", false)
		guiCreateLabel(0.05, 0.12, 0.90, 0.10, "Verkaufswert: "..getElementData(garage, "price").." $", true, guielem_garagemanageframe)
		if getElementData(garage, "doorstate") == 0 then
			btnTextdoor = "Öffnen"
		else
			btnTextdoor = "Schließen"
		end
		local btnopen = guiCreateButton(0.05, 0.25, 0.90, 0.20, btnTextdoor, true, guielem_garagemanageframe)
		local btnsell = guiCreateButton(0.05, 0.50, 0.90, 0.20, "Verkaufen", true, guielem_garagemanageframe)
		local btncanel = guiCreateButton(0.05, 0.75, 0.90, 0.20, "Abbrechen", true, guielem_garagemanageframe)
		addEventHandler("onClientGUIClick", btncanel, function()
			destroyElement(guielem_garagemanageframe)
			showCursor(false)
			setElementData(localPlayer, "interacting", 0)
		end, false)
		addEventHandler("onClientGUIClick", btnopen, function()
			triggerServerEvent("garagesystem:managedoor", localPlayer, garage)
			destroyElement(guielem_garagemanageframe)
			showCursor(false)
			setElementData(localPlayer, "interacting", 0)
		end, false)
		addEventHandler("onClientGUIClick", btnsell, function()
			destroyElement(guielem_garagemanageframe)
			guielem_garagemanageframecheck = guiCreateWindow(x, y, int_width, int_height, "Deine garage Verkaufen", false)
			guiCreateLabel(0.05, 0.12, 0.90, 0.10, "Willst du deine garage Wirklich verkaufen?", true, guielem_garagemanageframecheck)
			local btnsell = guiCreateButton(0.05, 0.50, 0.90, 0.20, "Ja", true, guielem_garagemanageframecheck)
			local btncanel = guiCreateButton(0.05, 0.75, 0.90, 0.20, "Nein!", true, guielem_garagemanageframecheck)
			addEventHandler("onClientGUIClick", btnsell, function()
				if getElementData(garage, "doorstate") == 0 then
					triggerServerEvent("garagesystem:sellgarage", localPlayer, garage)
					destroyElement(guielem_garagemanageframecheck)
					showCursor(false)
					setElementData(localPlayer, "interacting", 0)
				else
					destroyElement(guielem_garagemanageframecheck)
					showCursor(false)
					setElementData(localPlayer, "interacting", 0)
					outputChatBox("Bitte schließe die Garag erst! Manieren müssen sein!", 255, 0, 0)
				end
			end, false)
			addEventHandler("onClientGUIClick", btncanel, function()
				destroyElement(guielem_garagemanageframecheck)
				showCursor(false)
				setElementData(localPlayer, "interacting", 0)
			end, false)
		end)
	end
end)

addEvent("garagesystem:interact_notowned", true)
addEventHandler("garagesystem:interact_notowned", localPlayer, function(garage)
	if getElementData(localPlayer, "interacting") ~= 1 then
		local sx, sy = guiGetScreenSize()
		local int_width, int_height = 300, 200
		local x = (sx/2) - (int_width/2)
		local y = (sy/2) - (int_height/2)
		guielem_garagemanageframe = guiCreateWindow(x, y, int_width, int_height, "Garage Kaufen", false)
		local l1 = guiCreateLabel(0.05, 0.10, 0.90, 0.30, "Diese garage wird dich: "..getElementData(garage, "price").." $ Kosten \n sobald du diese gekauft hast ist sie für immer\n dein Eigentum! Du kannst sie später natürlich\n  wieder Verkaufen!", true, guielem_garagemanageframe)
		guiLabelSetVerticalAlign(l1, "center")
		local btn_kaufen = guiCreateButton(0.05, 0.45, 0.90, 0.25, "Kaufen", true, guielem_garagemanageframe)
		local btn_cancel = guiCreateButton(0.05, 0.75, 0.90, 0.25, "Abbrechen", true, guielem_garagemanageframe)
		addEventHandler("onClientGUIClick", btn_kaufen, function()
			local price = getElementData(garage, "price")
			local id = getElementData(garage, "id")
			if price then
				local garage = garage
				triggerServerEvent("garagesystem:buyGarage", localPlayer, price, id, garage)
			end
		end, false)
		addEventHandler("onClientGUIClick", btn_cancel, function()
			destroyElement(guielem_garagemanageframe)
			showCursor(false)
			setElementData(localPlayer, "interacting", 0)
		end, false)
	end
end)

addEvent("garagesystem:closebuygui", true)
addEventHandler("garagesystem:closebuygui", localPlayer, function()
	destroyElement(guielem_garagemanageframe)
	setElementData(localPlayer, "interacting", 0)
	showCursor(false)
end)