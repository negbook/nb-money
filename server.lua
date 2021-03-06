local GetPlayerLicense = function(type, player)
    for k,v in pairs(GetPlayerIdentifiers(player))do
        if string.sub(v, 1, string.len(type..":")) == type..":" then 
            return v 
        end 
    end
end 

local RegisterDatabaseTable = function(t,datas,cb)
    local keys = {}
    local values = {} 
    local valuestxt = {}
    for i,v in pairs(datas) do 
        table.insert(keys,i)
        table.insert(values,v)
        table.insert(valuestxt,"?")
    end 
    exports.oxmysql:query("INSERT INTO "..t.." ("..table.concat(keys,",")..") VALUES ("..table.concat(valuestxt,",")..")", values,
    cb)
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
    
    local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/log/'..license:gsub(":","-") ..'.log','a+')
    
	if not f then return print(err) end
    
    local timestamp = os.time(os.date("*t"))
    local data = {amount=amount,reason=reason or "Undescription",date=os.date("%x %X",timestamp),timestamp=timestamp}
    local line = json.encode(data).."\n"
    
	f:write(line)
	f:close()
end

local GetMoneyLog = function(player,cb)
    local license = GetPlayerLicense("license", player)
    local result = {}
    for line in io.lines(GetResourcePath(GetCurrentResourceName()).."/log/"..license:gsub(":","-") ..'.log') do
        local temp = json.decode(line)
        
        table.insert(result,temp)
    end
    table.sort(result,function(A,B)
        return A.timestamp > B.timestamp
    end)
    cb(result)
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
            if safe and data - amount < 0 then 
                cb(false)
                return 
            end
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
            if safe and amount > 1000000 then 
                cb(false)
                return 
            end
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
    GetMoneyLog(player,cb)
end)


local GetPlayerMoney = function(player,cb)
    local player = tonumber(player)
    local license = GetPlayerLicense("license", player)
    local result = exports.oxmysql:query_async("SELECT "..table.concat(config.acceptedtable,",").." FROM money WHERE license = ? LIMIT 1", {license})
    local money_account = result and result[1]
    local money_account_numbered
    if money_account then 
        for i,v in pairs(money_account) do 
            result[1][i] = tonumber(v)
        end 
        money_account_numbered = result[1]
        cb(money_account_numbered)
    else 
        local datas = {
            license = license,
            cash= config.startingCash,
            bank = config.startingBank,
            cryto = config.startingCryto
        }
        RegisterDatabaseTable("money",datas,function()
            local result2 = exports.oxmysql:query_async("SELECT "..table.concat(config.acceptedtable,",").." FROM money WHERE license = ? LIMIT 1", {license})
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
    
end
RegisterServerCallback("GetPlayerMoney", GetPlayerMoney )


local BadLog = function(player,reason,...)
    local license = GetPlayerLicense("license", player)
    local opts = {...}
    if opts[1] then 
        reason = reason.." "..table.concat(opts," ")
    end 
    local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/log/bad.log','a+')
    
	if not f then return print(err) end
    local data = {license=license, reason=reason or "Undescription",date=os.date("%x %X",timestamp)}
    local line = json.encode(data).."\n"
    
	f:write(line)
	f:close()
end 
RegisterServerCallback("ChargerMoney",function(player,cb,amount,type,reason)
    local found = false 
    local acceptedtable = config.acceptedtable
    for i=1,#acceptedtable do 
        local v = acceptedtable[i]
        if v == type then 
            found = true 
            break 
        end 
    end 
    if found then 
        RemovePlayerMoney(player,type,amount,cb,reason,true)
    else 
        BadLog(player,"Warning: Player is trying execute sql table type:",type)
    end 
end)


if config.salary then 
    local salaryTimer = config.salaryIntervalMS
    CreateThread(function()
        while true do
            Wait(salaryTimer)
            for _, player in pairs(GetPlayers()) do
     
                UpdateMoneyData(player,"bank",config.salaryAmount,function(success)
                    if success then 
                        TriggerClientEvent("receiveSalary", player, config.salaryAmount)
                    end 
                end,"Salary")
            end
        end
    end)
end 


exports("RemovePlayerMoney",RemovePlayerMoney)
exports("AddPlayerMoney",AddPlayerMoney)
exports("TransferPlayerMoney",TransferPlayerMoney)
exports("TransferPlayerMoneyToPlayer",TransferPlayerMoneyToPlayer)
exports("GetMoneyLog",GetMoneyLog)
exports("GetPlayerMoney",GetPlayerMoney)