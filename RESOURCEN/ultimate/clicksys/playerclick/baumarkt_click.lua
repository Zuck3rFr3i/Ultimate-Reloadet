createMarker ( -2667.78, -5.39, 5.05, "cylinder", 3, 255, 0, 0, 150 )
baumarktSphere = createColSphere ( -2667.78, -5.39, 5.05, 3 )
createBlip ( -2667.78, -5.39, 5.05, 11, 2, 255, 0, 0, 255, 0, 200 )
local clickedbut = nil

local sx, sy = guiGetScreenSize()
local w, h = 500, 300
local x = (sx/2)-(w/2)
local y = (sy/2)-(h/2)

function showBaumarktMenue ( hit )

	if hit == lp then
		showCursor ( true )
		setElementClicked ( true )
		if baumarktframe then
			guiSetVisible ( baumarktframe, true )
		else
			baumarktframe = guiCreateWindow(x, y, w, h, "Baumarkt", false)
			guiCreateStaticImage(0.05, 0.10, 0.13, 0.14, "images/inventory/placeable/ball_a.png", true, baumarktframe)
			guiCreateStaticImage(0.30, 0.10, 0.13, 0.14, "images/inventory/placeable/ball_b.png", true, baumarktframe)
			guiCreateStaticImage(0.55, 0.10, 0.13, 0.14, "images/inventory/placeable/campfire.png", true, baumarktframe)
			guiCreateStaticImage(0.80, 0.10, 0.13, 0.14, "images/inventory/placeable/grill.png", true, baumarktframe)
			
			guiCreateStaticImage(0.05, 0.50, 0.13, 0.14, "images/inventory/placeable/hi_fi.png", true, baumarktframe)
			guiCreateStaticImage(0.30, 0.50, 0.13, 0.14, "images/inventory/placeable/liege.png", true, baumarktframe)
			guiCreateStaticImage(0.55, 0.50, 0.13, 0.14, "images/inventory/placeable/torch.png", true, baumarktframe)
			guiCreateStaticImage(0.80, 0.50, 0.13, 0.14, "images/inventory/placeable/towel.png", true, baumarktframe)
			local btnballa = guiCreateButton(0.04, 0.26, 0.15, 0.10, "Kaufen", true, baumarktframe)
			local btnballb = guiCreateButton(0.29, 0.26, 0.15, 0.10, "Kaufen", true, baumarktframe)
			local btncampfire = guiCreateButton(0.54, 0.26, 0.15, 0.10, "Kaufen", true, baumarktframe)
			local btngrill = guiCreateButton(0.79, 0.26, 0.15, 0.10, "Kaufen", true, baumarktframe)
			local btnhifi = guiCreateButton(0.04, 0.66, 0.15, 0.10, "Kaufen", true, baumarktframe)
			local btnliege = guiCreateButton(0.29, 0.66, 0.15, 0.10, "Kaufen", true, baumarktframe)
			local btntorch = guiCreateButton(0.54, 0.66, 0.15, 0.10, "Kaufen", true, baumarktframe)
			local btntowel = guiCreateButton(0.79, 0.66, 0.15, 0.10, "Kaufen", true, baumarktframe)
			local btncancel = guiCreateButton(0.05, 0.85, 0.90, 0.10, "Aktion Abbrechen", true, baumarktframe)
			
			addEventHandler("onClientGUIClick", baumarktframe, function()
				if source ~= baumarktframe then
					if source == btnballa then
						clickedbut = 1946
						purchaseItem ()
					elseif source == btnballb then
						clickedbut = 1598
						purchaseItem ()
					elseif source == btncampfire then
						clickedbut = 841
						purchaseItem ()
					elseif source == btngrill then
						clickedbut = 1481
						purchaseItem ()
					elseif source == btnhifi then
						clickedbut = 2103
						purchaseItem ()
					elseif source == btnliege then
						clickedbut = 1255
						purchaseItem ()
					elseif source == btntorch then
						clickedbut = 3461
						purchaseItem ()
					elseif source == btntowel then
						clickedbut = 1640
						purchaseItem ()
					end
				end
			end)
			addEventHandler("onClientGUIClick", btncancel, function()
				hideBaumarktMenue ()
			end, false)
		end
	end
end
addEventHandler ( "onClientColShapeHit", baumarktSphere, showBaumarktMenue )

function hideBaumarktMenue ()

	guiSetVisible ( baumarktframe, false )
	showCursor ( false )
	setElementClicked ( false )
end

function purchaseItem ()
	if clickedbut then
		triggerServerEvent ( "purchaseItem", lp, clickedbut )
	end
end