local GetPlayerLicense = function(type, player)
    for k,v in pairs(GetPlayerIdentifiers(player))do
        if string.sub(v, 1, string.len(type..":")) == type..":" then 
            return v 
        end 
    end
end 

local GetMoneyData = function(player,type,cb,isnumber)
    local license = GetPlayerLicense("license", player)
    exports.oxmysql:query("SELECT "..type.." FROM money WHERE license = ?", {license}, function(result)
        if result and result[1] then
            local r = isnumber and tonumber(result[1][type]) or result[1][type]
            if cb then cb(r) end 
        end
    end)
end

local MoneyLog = function(player,amount,reason)
    local amount = tonumber(amount)
    local license = GetPlayerLicense("license", player)
    GetMoneyData(player,"log",function(data)
        if not data then data = {} else data = json.decode(data) end 
        local timestamp = os.time(os.date("*t"))
        table.insert(data,{amount=amount,reason=reason or "Undescription",date=os.date("%x %X",timestamp),timestamp=timestamp})
        local json = json.encode(data)
        exports.oxmysql:query("UPDATE money SET log = ? WHERE license = ?", {json, license},function(result2)
            if cb then cb(result2.changedRows>0) end 
        end)
    end)
end

local UpdateMoneyData = function(player,type,amount,cb,reason)
    local license = GetPlayerLicense("license", player)
    exports.oxmysql:query("UPDATE money SET "..type.." = "..type.." + ? WHERE license = ?", {amount, license},function(result)
        if cb then 
            if result.changedRows>0 then 
                cb(true) 
                MoneyLog(player,amount,reason or "Undescription")
            else 
                cb(false)
            end 
        end 
    end)
end

RemovePlayerMoney = function(player,type,amount,cb,reason,safe)
    local amount = tonumber(amount)
    GetMoneyData(player,type,function(data)
        if data then
            if safe and data - amount < 0 then return end
            if amount < 0 then
                if cb then cb(false) end 
            else
                if amount == 0 then 
                    if cb then cb(true) end 
                else 
                    UpdateMoneyData(player,type,-amount,cb,reason)
                end 
            end
        end
    end,true)
end 

AddPlayerMoney = function(player,type,amount,cb,reason,safe)
    local amount = tonumber(amount)
    GetMoneyData(player,type,function(data)
        if data then
            if safe and amount > 1000000 then return end
            if amount < 0 then
                if cb then cb(false) end 
            else
                if amount == 0 then 
                    if cb then cb(true) end 
                else 
                    UpdateMoneyData(player,type,amount,cb,reason)
                end 
            end
        end 
    end,true)
    
end

TransferPlayerMoneyToPlayer = function(playerFrom,playerTo,typeFrom,typeTo,amount,cb,outreason,inreason)
    RemovePlayerMoney(playerFrom,typeFrom,amount,function(suscess)
        if suscess then 
            AddPlayerMoney(playerTo,typeTo,amount,function(suscess2)
                cb(suscess2)
            end, inreason or "")
        else 
            cb(false)
        end 
    end, outreason or "" ,true)
end

TransferPlayerMoney = function(player,typeFrom,typeTo,amount,cb,outreason,inreason)
    TransferPlayerMoneyToPlayer(player,player,typeFrom,typeTo,amount,cb,outreason,inreason)
end 

RegisterServerCallback("GetMoneyLog",function(player,cb)
    GetMoneyData(player,"log",function(data)
        if not data then data = {} else data = json.decode(data) end 
        if data then 
            table.sort(data,function(dataA,dataB)
                return dataA.timestamp > dataB.timestamp
            end) 
            cb(data)
        else 
            cb({})
        end
    end)
end)

RegisterServerCallback("GetPlayerMoney",function(player,cb,...)
    local license = GetPlayerLicense("license", player)
    local types = {...}
    local result = exports.oxmysql:query_async("SELECT "..table.concat(types,",").." FROM money WHERE license = ? LIMIT 1", {license})
    local money_account = result and result[1]
    local money_account_numbered
    if money_account then 
        for i,v in pairs(money_account) do 
            result[1][i] = tonumber(v)
        end 
        money_account_numbered = result[1]
        cb(money_account_numbered)
    else 
        exports.oxmysql:query("INSERT INTO money (license, log, cash, bank, cryto) VALUES (?, ?, ?, ?, ?)", {license, json.encode({}), config.startingCash, config.startingBank, config.startingCryto},function()
            local result2 = exports.oxmysql:query_async("SELECT "..table.concat(types,",").." FROM money WHERE license = ? LIMIT 1", {license})
            local money_account = assert(result2 and result2[1], "Error getting money account")
            local money_account_numbered
            if money_account then 
                for i,v in pairs(money_account) do 
                    result2[1][i] = tonumber(v)
                end 
                money_account_numbered = result2[1]
                cb(money_account_numbered)
            else 
                cb({}) -- error
            end
            
        end)
    end 
    
end )

RegisterServerCallback("ChargerMoney",function(player,cb,amount,type,reason,safe)
    RemovePlayerMoney(player,type,amount,cb,reason,safe)
end)

RegisterServerCallback("TransferMoney",function(player,cb,amount,typeFrom,typeTo,outreason,inreason)
    TransferPlayerMoney(player,typeFrom,typeTo,amount,cb,outreason,inreason)
end)

RegisterServerCallback("TransferMoneyToPlayer",function(player,targetplayer,cb,amount,typeFrom,typeTo,outreason,inreason)
    TransferPlayerMoneyToPlayer(player,targetplayer,typeFrom,typeTo,amount,cb,outreason,inreason)
end)

local salaryTimer = config.salaryInterval * 60000
CreateThread(function()
    while true do
        Wait(salaryTimer)
        for _, player in pairs(GetPlayers()) do
            UpdateMoneyData(player,"bank",config.salaryAmount,function()
                TriggerClientEvent("receiveSalary", player, config.salaryAmount)
            end,"Salary")
        end
    end
end)

AddEventHandler("RemovePlayerMoney",RemovePlayerMoney)
AddEventHandler("AddPlayerMoney",AddPlayerMoney)
exports("RemovePlayerMoney",RemovePlayerMoney)
exports("AddPlayerMoney",AddPlayerMoney)
exports("TransferPlayerMoney",TransferPlayerMoney)
exports("TransferPlayerMoneyToPlayer",TransferPlayerMoneyToPlayer)



