ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ClothesShop:addClothesForPlayer')
AddEventHandler('ClothesShop:addClothesForPlayer', function(playerId, label, value)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	MySQL.Async.execute('INSERT INTO player_clothes (identifier, label, value) VALUES (@identifier, @label, @value)', {
        ['@identifier'] = xTarget.identifier,
        ['@label'] = label,
        ['@value'] = value
    })
	MySQL.Async.execute(
		'DELETE FROM clothes_ponsonbys WHERE label = @label',
		{
		['@label'] = label
		}
	)
	TriggerClientEvent('esx:showNotification', source, "Vous avez attribué la tenue : ~b~"..label.."\n~s~à ~y~"..GetPlayerName(playerId))  	
	TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez recu la tenue : ~b~"..label)  
end)

RegisterServerEvent('ClothesShop:addClothes')
AddEventHandler('ClothesShop:addClothes', function(label, value,type)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local price = 75
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ponsonbys', function(account)
		societyAccount = account
		if account.money >= price then
			societyAccount.removeMoney(price)
			MySQL.Async.execute('INSERT INTO clothes_ponsonbys (label, value, type) VALUES (@label, @value, @type)', {
				['@label'] = label,
				['@value'] = json.encode(value),
				['@type'] = type
			}, function(rowsChanged)
			end)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Tenue acheté")
		else
			societyAccount.addMoney(price)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~La société n'a pas assez d'argent.")
		end
	end)
end)

RegisterServerEvent('ClothesShop:DeleteClotheFromPonsonbys')
AddEventHandler('ClothesShop:DeleteClotheFromPonsonbys', function (id, label)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
  	if id ~= nil then
  		MySQL.Async.execute(
			'DELETE FROM clothes_ponsonbys WHERE id = @id',
			{
			['@id'] = id
			}
		)
		TriggerClientEvent('esx:showNotification', source, 'Label : ~y~'..label.."\n~s~Status : ~r~Supprimé")
  	else
  		TriggerClientEvent('esx:showNotification', source, "~r~Vêtement introuvable.")
  	end
end)

RegisterServerEvent('ClothesShop:RenameClothes')
AddEventHandler('ClothesShop:RenameClothes', function (rename, id)
  	if id ~= nil then
  		MySQL.Async.execute(
		'UPDATE player_clothes SET label = @rename WHERE id = @id',
		{
        ['@rename'] = rename,
        ['@id'] = id
		}
	)
		TriggerClientEvent('esx:showNotification', source, "- ~b~Tenue renommé \n~s~ Label : ~y~"..rename)
  	else
  		TriggerClientEvent('esx:showNotification', source, "~r~Vêtement introuvable.")
  	end
end)

RegisterServerEvent('ClothesShop:GiveClothes')
AddEventHandler('ClothesShop:GiveClothes', function (id_clothes, player, label)
	local _source = source
	local id_player = player
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(id_player)
  	if id_clothes ~= nil then
  		MySQL.Async.execute(
			'UPDATE player_clothes SET identifier = @identifier WHERE id = @id',
			{
				['@identifier'] = xTarget.identifier,
				['@id'] = id_clothes
			}
		)
		TriggerClientEvent('esx:showNotification', source, "Vous avez donné la tenue avec le nom suivant ~o~" .. label)
  		TriggerClientEvent('esx:showNotification', id_player, "Vous avez recu la tenue avec le nom suivant ~o~" .. label)
  	else
  		TriggerClientEvent('esx:showNotification', source, "La tenue est introuvable..")
  	end
end)

RegisterServerEvent('ClothesShop:DeleteClothes')
AddEventHandler('ClothesShop:DeleteClothes', function (id)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
  	if id ~= nil then
  		MySQL.Async.execute(
			'DELETE FROM player_clothes WHERE id = @id',
			{
			['@id'] = id
			}
		)
		TriggerClientEvent('esx:showNotification', source, "~r~Tenue supprimé")
  	else
  		TriggerClientEvent('esx:showNotification', source, "~r~Vêtement introuvable.")
  	end
end)

ESX.RegisterServerCallback('ClothesShop:ShowMannequins', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ShowMannequins = {}
	MySQL.Async.fetchAll('SELECT * FROM clothes_ponsonbys', {}, function(result)
		for i = 1, #result, 1 do
			table.insert(ShowMannequins, {
				id = result[i].id,
				label = result[i].label,
				value = result[i].value,
				type = result[i].type
			})
		end
		cb(ShowMannequins)
	end)
end)

ESX.RegisterServerCallback('ClothesShop:ShowPlayerClothes', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ShowPlayerClothes = {}
	MySQL.Async.fetchAll('SELECT * FROM player_clothes WHERE (identifier = @identifier)', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(ShowPlayerClothes, {
				id = result[i].id,
				label = result[i].label,
				value = result[i].value
			})
		end
		cb(ShowPlayerClothes)
	end)
end)
