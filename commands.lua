Command = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) fn(table.unpack(args)) end) return end })

Command["give"] = function(target,amount)
    TriggerServerCallback("TransferMoneyToPlayer",
end 

Command["pay"] = function(target,amount)
    
end 

--[[
ClientCommand["give"] = function(source,target,amount)
    local source = tonumber(source)
    local target = tonumber(target)
    if source == target then 
        TriggerClientEvent(GetCurrentResourceName()..":FailedClientMessage",source,"CELEB_FAILED",true)
        return 
    end 
    TransferPlayerMoneyToPlayer(source,target,"cash","cash",amount,function(suscess)
        if suscess then 
            TriggerClientEvent(GetCurrentResourceName()..":UpdateClient",source,"MPATM_PLCHLDR_CST",true,"ID:"..target)
            TriggerClientEvent(GetCurrentResourceName()..":UpdateClient",target,"MPATM_PLCHLDR_CRF",true,"ID:"..source)
        else 
            TriggerClientEvent(GetCurrentResourceName()..":FailedClientMessage",source,"BB_NOMONEY",true)
        end 
    end,"Give To"..GetPlayerName(target),"Receive From"..GetPlayerName(source))
end

ClientCommand["pay"] = function(source,target,amount)
    local source = tonumber(source)
    local target = tonumber(target)
    if source == target then 
        TriggerClientEvent(GetCurrentResourceName()..":FailedClientMessage",source,"CELEB_FAILED",true)
        return 
    end 
    TransferPlayerMoneyToPlayer(source,target,"bank","bank",amount,function(suscess)
        if suscess then 
            TriggerClientEvent(GetCurrentResourceName()..":UpdateClient",source,"MPATM_PLCHLDR_CST",true,"ID:"..target)
            TriggerClientEvent(GetCurrentResourceName()..":UpdateClient",target,"MPATM_PLCHLDR_CRF",true,"ID:"..source)
        else 
            TriggerClientEvent(GetCurrentResourceName()..":FailedClientMessage",source,"BB_NOBANK",true)
        end 
    end,"Paid To"..GetPlayerName(target),"Receive Payment From"..GetPlayerName(source))
end
---]]

