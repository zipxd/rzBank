ESX = nil
local Retrait = "" -- WEBHOOK POUR LE RETRAIT DARGENT
local Important = "" -- WEBHOOK POUR LES DEPOT/RETRAIT IMPORTANT (+1M)
local Depot = "" -- WEBHOOK POUR LES DEPOTS

TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("depot") -- event depot d'argent 
AddEventHandler("depot", function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
     local total = money
     local xMoney = xPlayer.getAccount('cash').money
	 local xMoneyBank = xPlayer.getAccount('bank').money
	amount = tonumber(amount)

	if xMoney >= total then
		if total <= 0 then
			TriggerClientEvent('::{korioz#0110}::esx:showAdvancedNotification', source, 'Le Banquier', '', "J\'vai t\'~r~enculer~s~ mec ~r~!~s~, comment ca des sous négatifs ~r~?!!~s~", 'CHAR_ANDREAS', 10)
		else
			xPlayer.removeAccountMoney('cash', total)
			xPlayer.addAccountMoney('bank', total)
        	TriggerClientEvent('::{korioz#0110}::esx:showAdvancedNotification', source, 'Banque', 'Banque', "Vous avez deposé ~g~"..total.."$~s~ à la banque !", 'CHAR_BANK_FLEECA', 10)
			if total >= Config.MoneyImportante then
				Important('Dépot important', '__Dépot supérieur à 1M__\n' .. GetPlayerName(source) .. ' [' .. source .. '] a déposé '..total..' Dollars\nInfo Joueur : Cash : '..xMoney..' | Banque :'..xMoneyBank)
				TriggerClientEvent('::{korioz#0110}::esx:showAdvancedNotification', source, 'Le Banquier un peu vendu', '', "Dis donc.. T'as beaucoup d'~g~argent~s~ toi... on peut s\'~b~arranger~s~ si tu veux...", 'CHAR_ANDREAS', 10)
			else
				Depot('LogsBanque', '__Argent déposé__\n' .. GetPlayerName(source) .. ' [' .. source .. '] a déposé '..total..' Dollars\nInfo Joueur : Cash : '..xMoney..' | Banque : '..xMoneyBank)
			end
		end
    else
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, "Vous n'avez pas assez ~r~d\'argent~s~ !")
	end
end)

RegisterServerEvent("retrait") -- event retrait d'argent 
AddEventHandler("retrait", function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xMoneyBank = xPlayer.getAccount('bank').money
	local xMoney = xPlayer.getAccount('cash').money
	local total = money
	amount = tonumber(amount)

	if xMoneyBank >= total then
		if total <= 0 then
			TriggerClientEvent('::{korioz#0110}::esx:showAdvancedNotification', source, 'Le Banquier', '', "J\'vai t\'~r~enculer~s~ mec ~r~!~s~, comment ca des sous négatifs ~r~?!!~s~", 'CHAR_ANDREAS', 10)
		else
			xPlayer.removeAccountMoney('bank', total)
			xPlayer.addAccountMoney('cash', total)
			TriggerClientEvent('::{korioz#0110}::esx:showAdvancedNotification', source, 'Banque', 'Banque', "Vous avez retiré ~g~"..total.."$~s~ de la banque !", 'CHAR_BANK_FLEECA', 10)
			if total >= Config.MoneyImportante then
				Important('Retir important', '__Retrait supérieur à 1M__\n' .. GetPlayerName(source) .. ' [' .. source .. '] a retiré '..total..' Dollars\nInfo Joueur : Cash : '..xMoney..' | Banque :'..xMoneyBank)
				TriggerClientEvent('::{korioz#0110}::esx:showAdvancedNotification', source, 'Le Banquier un peu vendu', '', "Dis donc.. T'as beaucoup d'~g~argent~s~ toi... on peut s\'~b~arranger~s~ si tu veux...", 'CHAR_ANDREAS', 10)
			else
				RetireLogs('LogsBanque', '__Argent retiré__\n' .. GetPlayerName(source) .. ' [' .. source .. '] a retiré '..total..' Dollars\nInfo Joueur : Cash : '..xMoney..' | Banque :'..xMoneyBank)
			end
		end
	else
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, "Vous n'avez pas assez ~r~d\'argent~s~ !")
	end
end)

RegisterServerEvent("bank:solde") 
AddEventHandler("bank:solde", function(action, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getAccount('bank').money
    TriggerClientEvent("solde:argent", source, playerMoney)
end)

date_local1 = os.date('%H:%M:%S', os.time())
local date_local = date_local1
local embeds = {
	{
		["title"]=message,
		["type"]="rich",
		["color"] ="64063",
		["footer"]=  {
			["text"]= "Heure: " ..date_local.. "",
		},
	}
}

function Depot (name,message,color)
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(Depot, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 

function Important (name,message,color)
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(Important, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' }) 
end 

function RetireLogs (name,message,color)
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(Retrait, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 
