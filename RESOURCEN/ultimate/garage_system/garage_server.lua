local function msql_gettbl(query, ...)
	local GetDataset = dbQuery(handler, query, ...)
	if GetDataset then
		local result, rows = dbPoll(GetDataset, -1)
		if result then
			return result, rows
		else
			return false
		end
	else
		return false
	end
end

local function msql_settbl(query, ...)
	local WriteDat = dbExec(handler, query, ...)
	if WriteDat then
		return true
	else
		return false
	end
end

local moving = 0

if handler then
	local garage_data, rows = msql_gettbl("SELECT * FROM garage_system")
	if garage_data and rows >= 1 then
		for i, v in pairs(garage_data) do --math.floor ( xo * 100 ) / 100
			local x_garage, y_garage, z_garage, rot_garage = tonumber(gettok(v.garagepos, 1, "|")), tonumber(gettok(v.garagepos, 2, "|")), tonumber(gettok(v.garagepos, 3, "|")), tonumber(gettok(v.garagepos, 4, "|"))
			local xclose_gate, yclose_gate, zclose_gate, zrot_gate = tonumber(gettok(v.doorpos, 1, "|")), tonumber(gettok(v.doorpos, 2, "|")), tonumber(gettok(v.doorpos, 3, "|")), tonumber(gettok(v.doorpos, 4, "|"))
			local owner = v.ownedby
			local buyprice = v.buyprice
			local sellprice = v.sellprice
			local id = v.id
			if x_garage and rot_garage then
				local object_garage = createObject(17950, x_garage, y_garage, z_garage, 0, 0, rot_garage)
				local object_garagedoor = createObject(17951, xclose_gate, yclose_gate, zclose_gate, 0, 0, zrot_gate)
				setElementData(object_garagedoor, "owner", owner)
				setElementData(object_garagedoor, "doorstate", 0)
				setElementData(object_garagedoor, "id", id)
				if owner == "none" then
					setElementData(object_garagedoor, "price", buyprice)
					local blip = createBlip(x_garage, y_garage, z_garage, 32)
					setElementData(blip, "id", id)
				else
					setElementData(object_garagedoor, "price", sellprice)
				end
			end
		end
		outputDebugString("Found: "..rows.." Garages")
	end
end

addEvent("garagesystem:setupblips", true)
addEventHandler("garagesystem:setupblips", root, function(player)
	local pname = getPlayerName(player)
	local getownerships, rows = msql_gettbl("SELECT ownedby, garagepos FROM garage_system WHERE ownedby=?", pname)
	if getownerships then
		if rows >= 1 then
			for i,v in pairs(getownerships) do
				local x, y, z, r = tonumber(gettok(v.garagepos, 1, "|")), tonumber(gettok(v.garagepos, 2, "|")), tonumber(gettok(v.garagepos, 3, "|")), tonumber(gettok(v.garagepos, 4, "|"))
				if x and z then
					local blip = createBlip(x, y, z, 31, _, _, _, _, 255, _, _, player )
					if blip then
						setElementData(blip, "id", v.id)
					end
				end
			end
		end
	end
end)

addEvent("garagesystem:buyGarage", true)
addEventHandler("garagesystem:buyGarage", root, function(price, id, garage)
	if source ~= client then return end
	local onbankMoney = vioGetElementData ( client, "bankmoney")
		if onbankMoney then
			if onbankMoney >= price then
				local newmoney = onbankMoney - price
				if newmoney then
					vioSetElementData ( client, "bankmoney", newmoney)
					local pname = getPlayerName(client)
					local updateOwner = msql_settbl("UPDATE garage_system SET ownedby=? WHERE id=?", pname, id)
					if updateOwner then
						triggerClientEvent("garagesystem:closebuygui", client)
						outputChatBox ( "Die garage gehört nun dir =)", source, 20, 100, 1 )
						setElementData(garage, "owner", pname)
						for i, v in pairs(getElementsByType("blip")) do
							if getElementData(v, "id") == id then
								destroyElement(v)
							end
						end
						local x, y, z = getElementPosition(garage)
						local blip = createBlip(x, y, z, 31, _, _, _, _, 255, _, _, client )
						local updateSellprice, rows = msql_gettbl("SELECT * FROM garage_system WHERE id=?", id)
						if updateSellprice then
							local newprice = updateSellprice[1]["sellprice"]
							if newprice then
								setElementData(garage, "price", newprice)
							end
						end
					end
				end
			else
				outputChatBox ( "Überweisung fehlgeschlagen du hast nicht genug Geld auf dem konto!", source, 220, 100, 1 )
			end
		end
end)

addEvent("garagesystem:managedoor", true)
addEventHandler("garagesystem:managedoor", root, function(garage)
	if source ~= client then return end
	if moving == 1 then
		outputChatBox ( "Warte bis das Tor die aktion ausgeführt hat!", source, 220, 100, 1 )
		return
	end
	local x, y, z = getElementPosition(garage)
	if getElementData(garage, "doorstate") == 0 then
		if x and z then
			local _, rot, _ = getElementRotation(garage)
			moving = 1
			setTimer(function()
				moving = 0
			end, 3000, 1)
			local movement = moveObject ( garage, 2000, x, y, z+1.6, 0, rot+90, 0)
			if movement then
				setElementData(garage, "doorstate", 1)
			end
		end
	elseif getElementData(garage, "doorstate") == 1 then
		if x and z then
			moving = 1
			setTimer(function()
				moving = 0
			end, 3000, 1)
			local movement = moveObject ( garage, 2000, x, y, z-1.6, 0, -90, 0)
			if movement then
				setElementData(garage, "doorstate", 0)
				oldx, oldy, oldz = nil, nil ,nil
			end
		end
	end
end)

addEvent("garagesystem:sellgarage", true)
addEventHandler("garagesystem:sellgarage", root, function(garage)
	if source ~= client then return end
	local sellprice = getElementData(garage, "price")
	local onbank = vioGetElementData ( client, "bankmoney")
	local newmoney = onbank + sellprice
	if newmoney then
		vioSetElementData ( client, "bankmoney", newmoney)
		local id = getElementData(garage, "id")
		local updateOwner = msql_settbl("UPDATE garage_system SET ownedby=? WHERE id=?", "none", id)
		if updateOwner then
			setElementData(garage, "owner", "none")
			outputChatBox ( "Wir haben dir den betrag von: "..sellprice.." $ auf dein Konto Überwiesen.", source, 20, 100, 1 )
			for i, v in pairs(getElementsByType("blip")) do
				if getElementData(v, "id") == id then
					destroyElement(v)
				end
			end
			local x, y, z = getElementPosition(garage)
			local blip = createBlip(x, y, z, 32, _, _, _, _, 255, _, _ )
			local updateSellprice, rows = msql_gettbl("SELECT * FROM garage_system WHERE id=?", id)
			if updateSellprice then
				local newprice = updateSellprice[1]["buyprice"]
				if newprice then
					setElementData(garage, "price", newprice)
				end
			end
		end
	end
end)
