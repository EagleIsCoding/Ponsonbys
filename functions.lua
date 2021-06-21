function startAnimAction(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
		RemoveAnimDict(lib)
	end)
end

function GetMannequin()
    Citizen.CreateThread(function()
        if ped_type == 1 then 
            local hash = GetHashKey("mp_m_freemode_01")
            while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
            end
            ped = CreatePed("PED_TYPE_CIVMALE", "mp_m_freemode_01", -166.81, -299.82, 38.73, 68.35, true) 
            SetBlockingOfNonTemporaryEvents(ped, true) 
            SetPedComponentVariation(ped, 2, 1, 4, 0) 
            SetPedComponentVariation(ped, 3, 15, 0, 2) 
            SetPedComponentVariation(ped, 11, 15, 0, 2) 
            SetPedComponentVariation(ped, 8, 15, 0, 2) 
            SetPedComponentVariation(ped, 4, 61, 0, 2)
            SetPedComponentVariation(ped, 6, 34, 0, 2) 
            FreezeEntityPosition(ped, true) 
            SetEntityInvincible(ped, true) 
        else
            local hash = GetHashKey("mp_f_freemode_01")
            while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
            end
            ped = CreatePed("PED_TYPE_CIVMALE", "mp_f_freemode_01", -166.81, -299.82, 38.73, 68.35, true) 
            SetBlockingOfNonTemporaryEvents(ped, true) 
            SetPedComponentVariation(ped, 2, 15, 3, 0) 
            SetPedComponentVariation(ped, 3, 15, 0, 2) 
            SetPedComponentVariation(ped, 11, 15, 0, 2) 
            SetPedComponentVariation(ped, 8, 15, 0, 2) 
            SetPedComponentVariation(ped, 4, 15, 0, 2)
            SetPedComponentVariation(ped, 6, 0, 0, 2) 
            FreezeEntityPosition(ped, true) 
            SetEntityInvincible(ped, true) 
        end  
    end)
end

function destorycam() 	
    cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end  
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

YourMannequin = {}

function RefreshPonsonbys()
    ESX.TriggerServerCallback('ClothesShop:ShowMannequins', function(ShowMannequins)
        YourMannequin = ShowMannequins
    end)
end

function cam_principal()
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, -169.11, -298.84, 39.73)  
    SetCamRot(cam, 0.0, 0.0, 246.66)
    SetCamFov(cam, 50.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
end
