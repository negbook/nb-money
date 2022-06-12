local initialed = false 
local hideAt = nil

UpdatePlayerMpMoneyUI = function (cash,bank)
    StatSetInt(`MP0_WALLET_BALANCE`, cash, true)
    StatSetInt(`BANK_BALANCE`, bank, true)
    if not config.displayMPMoney then goto theend end 
    DisplayCash(true) 
    UseFakeMpCash(true);
    SetMultiplayerWalletCash();
    SetMultiplayerBankCash();
    UseFakeMpCash(false);
    hideAt = GetGameTimer() + config.fadeoutTimerMS
    
    ::theend::
    if not initialed then initialed = true end 
end

CreateThread(function()
	while true do
		Wait(0)
		if not initialed and NetworkIsSessionStarted() then
			TriggerServerCallback("GetPlayerMoney",function(money_account)
                UpdatePlayerMpMoneyUI(money_account.cash,money_account.bank)
            end,"cash","bank")
			return
		end
	end
end)

CreateThread(function()
    while true do 
        Wait(500)
        if hideAt and GetGameTimer() > hideAt then 
            RemoveMultiplayerWalletCash();
            RemoveMultiplayerBankCash();
            DisplayCash(false) 
            hideAt = nil
        end 
    end 
end) 

ChargerMoney = function(type,amount,cb,reason,safe)
    while not initialed do Wait(0) end  
    TriggerServerCallback("ChargerMoney",function(success)
        if success then 
            TriggerServerCallback("GetPlayerMoney",function(money_account)
                UpdatePlayerMpMoneyUI(money_account.cash,money_account.bank)
                --print(json.encode(money_account))
            end,"cash","bank")
        end 
        if cb then cb(success) end 
    end,amount,type,reason,safe)
end

exports("ChargerMoney",ChargerMoney)
AddEventHandler("ChargerMoney",ChargerMoney)

receiveSalary = function(amount)
    BeginTextCommandThefeedPost("GOODBOYTICK")
    AddTextComponentInteger(amount, true)
    EndTextCommandThefeedPostTicker(false, true)
    BeginTextCommandThefeedPost("GOODBOYRMDR")
    EndTextCommandThefeedPostTicker(false, true)
end
RegisterNetEvent("receiveSalary",receiveSalary) 