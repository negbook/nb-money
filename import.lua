if GetCurrentResourceName() == "nb-money" then 

else 
    if IsDuplicityVersion() then 
        GetPlayerMoney = function(...)
            return exports["nb-money"]:GetPlayerMoney(...)
        end 
        GetMoneyLog = function(...)
            return exports["nb-money"]:GetMoneyLog(...)
        end 
        TransferPlayerMoneyToPlayer = function(...)
            return exports["nb-money"]:TransferPlayerMoneyToPlayer(...)
        end 
        TransferPlayerMoney = function(...)
            return exports["nb-money"]:TransferPlayerMoney(...)
        end 
        AddPlayerMoney = function(...)
            return exports["nb-money"]:AddPlayerMoney(...)
        end 
        RemovePlayerMoney = function(...)
            return exports["nb-money"]:RemovePlayerMoney(...)
        end 
    else 
        
        MoneyTransfedMessage = function(...)
            return exports["nb-money"]:MoneyTransfedMessage(...)
        end 
        UpdatePlayerMpMoneyUI = function(...)
            return exports["nb-money"]:UpdatePlayerMpMoneyUI(...)
        end 
        ChargerMoney = function(...)
            return exports["nb-money"]:ChargerMoney(...)
        end 
    end 
end 