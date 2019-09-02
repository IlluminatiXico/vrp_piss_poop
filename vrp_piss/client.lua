
vRP = Proxy.getInterface("vrp")

RegisterCommand('piss', function(source, args, rawCommand)
    pissyou() 
end,false) 

RegisterCommand('poop', function(source, args, rawCommand)
    poop()
end,false) 

-- CONFIG --
DelayPiss = 1 -- How long it takes for the percentage to add one % for piss
DelayShit = 1 -- How long it takes for the percentage to add one % for shit
EnableDebugHUD = true -- Enable the Debug HUD on the right of the screen allowing the user to see their piss and shit percentage


-- DO NOT TOUCH BELOW HERE --
IsDead = false
piss = 0
shit = 0

Citizen.CreateThread(function()
	RequestAnimDict("missbigscore1switch_trevor_piss")
	while not HasAnimDictLoaded("missbigscore1switch_trevor_piss") do
		Citizen.Wait(100)
	end
	RequestAnimDict("switch@trevor@on_toilet")
	while not HasAnimDictLoaded("switch@trevor@on_toilet") do
		Citizen.Wait(100)
	end
end)  

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(DelayPiss * 1000) -- Delay in incrementation in milliseconds
		piss = piss + 1
	end
end)

-- Handle Shit Incrementation
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(DelayShit * 2000) -- Delay in incrementation in milliseconds
		shit = shit + 1
	end
end) 

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if piss == 100 then
			vRP.notify({"You need the toilet (Piss)"})
		end
		if shit == 100 then
			vRP.notify({"You need the toilet (Poop)"})
		end
		if piss > 119 then
		    vRP.notify({"You have pissed yourself!"})
			pissyou()
		end
		if shit > 119 then
            vRP.notify({"You have shit yourself!"})
			shit()
		end
	end
end)




Citizen.CreateThread(function()
    while true do
    	Citizen.Wait(0)
    	if EnableDebugHUD then
	        textPiss(piss)
	        textShit(shit)
	    end
    end
end)










function poop()
    local ped = PlayerPedId()
    if not IsEntityPlayingAnim(ped, "switch@trevor@on_toilet", "trev_on_toilet_exit", 3) then
        TaskPlayAnim(ped, "switch@trevor@on_toilet", "trev_on_toilet_exit", 8.0, -8, -1, 49, 0, 0, 0, 0)
        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
		vRP.notify({"~g~You have taken a shit!"})
        Wait(8000)
        ClearPedTasksImmediately(ped)
    end
	poop = 0
	return
end 


function pissyou()
    local ped = PlayerPedId()
    if not IsEntityPlayingAnim(ped, "missbigscore1switch_trevor_piss", "piss_loop", 3) then
        TaskPlayAnim(ped, "missbigscore1switch_trevor_piss", "piss_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
		vRP.notify({"~g~You have taken a piss!"})
        Wait(8000)
        ClearPedTasksImmediately(ped)
    end
	piss = 0
	return
end 



function textPiss(content) 
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.5,0.5)
    SetTextEntry("STRING")
    AddTextComponentString("Bladder (Piss): " ..content.."%")
    DrawText(0.84,0.62)
end


function textShit(content) 
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.5,0.5)
    SetTextEntry("STRING")
    AddTextComponentString("Bladder (Poop): " ..content.."%")
    DrawText(0.84,0.65)
end