ESX  = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local MenuOpen = false
local ClothesShopMenu = RageUI.CreateMenu("Ponsonbys", " ")
local MannequinOptions = RageUI.CreateSubMenu(ClothesShopMenu, "Choix", " ")
local MannequinClothesMenu = RageUI.CreateSubMenu(ClothesShopMenu, "Vêtements", " ")
local MannequinDispo = RageUI.CreateSubMenu(ClothesShopMenu, "Tenue(s)", " ")
ClothesShopMenu.Closed = function()
    destorycam() 
    open = false
end
MannequinClothesMenu.EnableMouse = true
MannequinClothesMenu.Closable = false
MannequinOptions.Closed = function()
    destorycam() 
end

local Torso = 1
local Tshirts = 1
local Arms = 1 
local Pants = 1 
local Shoes = 1

local TorsoList = {}
local TshirtList = {}
local ArmsList = {}
local PantsList = {}
local ShoesList = {}

Citizen.CreateThread(function()
    for i = 1, 75 do
        table.insert(TorsoList, i)
    end
    for i = 1, 75 do
        table.insert(TshirtList, i)
    end
    for i = 1, 75 do
        table.insert(ArmsList, i)
    end
    for i = 1, 75 do
        table.insert(PantsList, i)
    end
    for i = 1, 75 do
        table.insert(ShoesList, i)
    end
end)

Clothes = {
    ActionsClothes = 1,
    PlayerActionsClothes = 1,
    PlayerActions = {'Mettre', 'Renommer', 'Donner','Supprimer'},
    Actions = {'Attribuer', 'Supprimer'}
}

SliderPanel = {
    Config = {
        Min = 0,
        Torso = 0,
        Tshirt = 0,
        Pants = 0,
        Shoes = 0,
        Max = 64,
    },
    Torso = {
        Index = 1
    },
    Arms = {
        Index = 1
    },
    Tshirt = {
        Index = 1
    },
    Pants = {
        Index = 1
    },
    Shoes = {
        Index = 1
    }
}

clothes = {}

function OpenClothesShopMenu()
    if open then 
        open = false 
        RageUI.Visible(ClothesShopMenu,false)
        return
    else
        open = true 
        RageUI.Visible(ClothesShopMenu, true)
        Citizen.CreateThread(function ()
            while open do 
                RageUI.IsVisible(ClothesShopMenu, function()
                    RageUI.Button("Créer une tenue", false, {RightLabel = "→"}, true, {
                        onSelected = function()
                            cam_principal()
                        end
                    }, MannequinOptions)    
                    RageUI.Button("Tenue(s) disponibles", false, {RightLabel = "→"}, true, {
                        onSelected = function()
                            RefreshPonsonbys()
                        end
                    }, MannequinDispo)    
                    RageUI.Button("Facturer un joueur", false, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local amount = KeyboardInput('Montant', '', 6)
                            local player, distance = ESX.Game.GetClosestPlayer()
                            local amount = tonumber(amount)
                            if player ~= -1 and distance <= 3.0 then
                                if amount ~= nil then
                                    if amount <= 10000 then
                                        if amount == 0 then
                                        else
                                            if type(amount) == 'number' then
                                                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ponsobys', "Facturation - Ponsobys", amount)
                                                Wait(100)
                                                ESX.ShowNotification("~g~Vous avez envoyée une facture au montant de "..amount.."$")
                                            end
                                        end
                                    else
                                        ESX.ShowNotification("~r~Vous ne pouvez pas envoyée une facture plus élevé que 10.000$")
                                    end
                                end
                            else
                                ESX.ShowNotification("~r~Aucun joueur à proximité")
                            end
                        end
                    })
                end)  
                RageUI.IsVisible(MannequinOptions, function()
                    RageUI.Separator("← ~y~Type de mannequin ~s~→")
                    RageUI.Button("Mannequin Homme", false, {RightLabel = "→"}, true, {
                        onSelected = function()
                            ped_type = 1
                            GetMannequin()
                        end
                    },MannequinClothesMenu)
                    RageUI.Button("Mannequin Femme", false, {RightLabel = "→"}, true, {
                        onSelected = function()
                            ped_type = 2
                            GetMannequin()
                        end
                    },MannequinClothesMenu)
                end)
                RageUI.IsVisible(MannequinDispo, function()
                    local player, distance = ESX.Game.GetClosestPlayer()
                    for i = 1, #YourMannequin, 1 do 
                        RageUI.List(YourMannequin[i].label, Clothes.Actions, Clothes.ActionsClothes, false, {}, true, {
                            onListChange = function(Index)
                                Clothes.ActionsClothes = Index
                            end,
                            onSelected = function(Index)
                                if Index == 1 then
                                    if player ~= -1 and distance <= 3.0 then
                                        TriggerServerEvent('ClothesShop:addClothesForPlayer', GetPlayerServerId(player), YourMannequin[i].label, YourMannequin[i].value)
                                        Wait(150)
                                        RefreshPonsonbys()
                                    else
                                        ESX.ShowNotification("~r~Aucun joueur à proximité")
                                    end
                                elseif Index == 2 then 
                                    TriggerServerEvent('ClothesShop:DeleteClotheFromPonsonbys', YourMannequin[i].id, YourMannequin[i].label)
                                    Wait(600)
                                    RefreshPonsonbys()
                                end
                            end
                        })
                    end
                end)
                RageUI.IsVisible(MannequinClothesMenu, function()
                    RageUI.List('Liste des torses :', TorsoList, Torso , nil, {}, true, {
                        onListChange = function(Index)
                            Torso = Index
                            SetPedComponentVariation(ped , 11, Torso, 0) 
                        end
                    })
                    RageUI.List('Liste des t-shirts :', TshirtList, Tshirts , nil, {}, true, {
                        onListChange = function(Index)
                            Tshirts = Index
                            SetPedComponentVariation(ped , 8, Tshirts, 0) 
                        end
                    })
                    RageUI.List('Liste des bras :', ArmsList, Arms , nil, {}, true, {
                        onListChange = function(Index)
                            Arms = Index
                            SetPedComponentVariation(ped , 3, Arms, 0) 
                        end
                    })
                    RageUI.List('Liste des pantalons :', PantsList, Pants , nil, {}, true, {
                        onListChange = function(Index)
                            Pants = Index
                            SetPedComponentVariation(ped , 4, Pants, 0) 
                        end
                    })
                    RageUI.List('Liste des chaussures :', ShoesList, Shoes , nil, {}, true, {
                        onListChange = function(Index)
                            Shoes = Index
                            SetPedComponentVariation(ped , 6, Shoes, 0) 
                        end
                    })
                    RageUI.Button("Annuler la personalisation du mannequin", false, {}, true, {
                        onSelected = function()
                            DoScreenFadeOut(500)
                            Wait(600)
                            DeleteEntity(ped)
                            destorycam()
                            Torso = 1
                            SliderPanel.Config.Torso = 0
                            Tshirts = 1
                            SliderPanel.Config.Tshirt = 0
                            Arms = 1
                            Pants = 1
                            SliderPanel.Config.Pants = 0
                            Shoes = 1
                            SliderPanel.Config.Shoes = 0
                            RageUI.Visible(ClothesShopMenu, true)  
                            Wait(1000)
                            DoScreenFadeIn(1000)   
                        end
                    })
                    RageUI.Button("Valider la tenue du mannequin", false, { Color = { BackgroundColor = { 0, 140, 0, 160 } } }, true, {
                        onSelected = function()
                            clothes["torso_1"] = Torso
                            clothes["torso_2"] = SliderPanel.Config.Torso
                            clothes["tshirt_1"] = Tshirts
                            clothes["tshirt_2"] = SliderPanel.Config.Tshirt
                            clothes["arms"] = Arms
                            clothes["pants_1"] = Pants
                            clothes["pants_2"] = SliderPanel.Config.Pants
                            clothes["shoes_1"] = Shoes
                            clothes["shoes_2"] = SliderPanel.Config.Shoes
                            local name = KeyboardInput("Indiquer le nom de la tenue du mannequin :", "", 40)
                            DoScreenFadeOut(500)
                            Wait(600)
                            if ped_type == 1 then 
                                TriggerServerEvent('ClothesShop:addClothes', name, clothes, "Masculin")
                            else
                                TriggerServerEvent('ClothesShop:addClothes', name, clothes, "Féminin")
                            end
                            Wait(600)
                            DeleteEntity(ped)
                            Torso = 1
                            SliderPanel.Config.Torso = 0
                            Tshirts = 1
                            SliderPanel.Config.Tshirt = 0
                            Arms = 1
                            Pants = 1
                            SliderPanel.Config.Pants = 0
                            Shoes = 1
                            SliderPanel.Config.Shoes = 0
                            clothes = {}  
                            destorycam()
                            RageUI.Visible(ClothesShopMenu, true)   
                            Wait(1000)
                            DoScreenFadeIn(1000)  
                        end
                    })
                    RageUI.Separator("← ~p~Tenue by Ponsonbys ~s~→")
                    RageUI.SliderPanel(SliderPanel.Config.Torso, SliderPanel.Config.Min, "Variations", GetNumberOfPedTextureVariations(PlayerPedId(), 11, SliderPanel.Torso.Index)-1, {
                        onSliderChange = function(Index)
                            SliderPanel.Config.Torso = Index
                            SetPedComponentVariation(ped , 11, Torso, SliderPanel.Config.Torso) 
                        end
                    }, 1)
                    RageUI.SliderPanel(SliderPanel.Config.Tshirt, SliderPanel.Config.Min, "Variations", GetNumberOfPedTextureVariations(PlayerPedId(), 8, SliderPanel.Tshirt.Index)-1, {
                        onSliderChange = function(Index)
                            SliderPanel.Config.Tshirt = Index
                            SetPedComponentVariation(ped , 8, Tshirts, SliderPanel.Config.Tshirt) 
                        end
                    }, 2)
                    RageUI.SliderPanel(SliderPanel.Config.Pants, SliderPanel.Config.Min, "Variations", GetNumberOfPedTextureVariations(PlayerPedId(), 4, SliderPanel.Pants.Index)-1, {
                        onSliderChange = function(Index)
                            SliderPanel.Config.Pants = Index
                            SetPedComponentVariation(ped , 4, Pants, SliderPanel.Config.Pants) 
                        end
                    }, 4)
                    RageUI.SliderPanel(SliderPanel.Config.Shoes, SliderPanel.Config.Min, "Variations", GetNumberOfPedTextureVariations(PlayerPedId(), 6, SliderPanel.Shoes.Index)-1, {
                        onSliderChange = function(Index)
                            SliderPanel.Config.Shoes = Index
                            SetPedComponentVariation(ped , 6, Shoes, SliderPanel.Config.Shoes) 
                        end
                    }, 5)
                end)
                Wait(0)
            end
        end)
    end
end

YourPlayerClothes = {}

function RefreshPlayerClothes()
    ESX.TriggerServerCallback('ClothesShop:ShowPlayerClothes', function(ShowPlayerClothes)
        YourPlayerClothes = ShowPlayerClothes
    end)
end

local ClothesPlayerMenu = RageUI.CreateMenu("Vos tenues", "Vêtements")

function OpenClothesPlayerMenu()
    if open then 
        open = false 
        RageUI.Visible(ClothesPlayerMenu,false)
        return
    else
        open = true 
        RageUI.Visible(ClothesPlayerMenu, true)
        Citizen.CreateThread(function ()
            while open do 
                RageUI.IsVisible(ClothesPlayerMenu, function()
                    for i = 1, #YourPlayerClothes, 1 do
                        RageUI.List(YourPlayerClothes[i].label, Clothes.PlayerActions, Clothes.PlayerActionsClothes, false, {}, true, {
                            onListChange = function(Index)
                                Clothes.PlayerActionsClothes = Index
                            end,
                            onSelected = function(Index)
                                if Index == 1 then
                                    plyPed = PlayerPedId()
                                    startAnimAction('clothingtie', 'try_tie_neutral_a')
                                    Citizen.Wait(1700)
                                    ClearPedTasks(PlayerPedId())                           
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        TriggerEvent('skinchanger:loadClothes', skin, json.decode(YourPlayerClothes[i].value))
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                            TriggerServerEvent('esx_skin:save', skin)                                    
                                        end)
                                    end)
                                elseif Index == 2 then 
                                    local rename = KeyboardInput("Choisir un nom pour votre tenue : ", "", 30)
                                    TriggerServerEvent('ClothesShop:RenameClothes', rename, YourPlayerClothes[i].id)
                                    Wait(150)
                                    RefreshPlayerClothes()
                                elseif Index == 3 then 
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                    if closestPlayer == -1 or closestDistance > 3.0 then
                                        ESX.ShowNotification('~r~Aucune joueur à proximité.')
                                    else
                                        TriggerServerEvent('ClothesShop:GiveClothes', YourPlayerClothes[i].id, GetPlayerServerId(closestPlayer), YourPlayerClothes[i].label)
                                        Wait(100)
                                        ShowVetements()
                                    end
                                elseif Index == 4 then 
                                    TriggerServerEvent('ClothesShop:DeleteClothes', YourPlayerClothes[i].id)
                                    Wait(100)
                                    ShowVetements()
                                end
                            end
                        })
                    end
                end)
                Wait(0)
            end
        end)
    end
end

Keys.Register('F2','F2', 'Menu Vêtements', function()
    RefreshPlayerClothes()
    Wait(600)
    OpenClothesPlayerMenu()
end)

local ClothesComptoir = {
    {pos = vector3(-164.79, -301.95, 39.73)}
}

CreateThread(function()
    while true do
        local pCoords = GetEntityCoords(PlayerPedId())
        local spam = false
        for _,v in pairs(ClothesComptoir) do
            if #(pCoords - v.pos) < 1.2 then
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ponsonbys' then 
                    spam = true
                    Visual.Subtitle("Appuyer sur [~b~E~s~] pour accéder au ~b~comptoir")
                    DrawMarker(22, v.pos, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 0, 0, 255, 255, 1, 0, 0, 2)               
                    if IsControlJustReleased(0, 38) then
                        RefreshPonsonbys()
                        OpenClothesShopMenu()
                    end   
                end                             
            elseif #(pCoords - v.pos) < 1.3 then
                spam = false 
                RageUI.CloseAll()
                open = false
            end
        end
        if spam then
            Wait(1)
        else
            Wait(500)
        end
    end
end)