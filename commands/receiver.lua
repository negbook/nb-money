local GetClosestPlayerFromPlayer = function(player)
    local targets = GetPlayers()
    local playerCoords = TriggerClientCallbackSynced(player,"GetPosition")

    local closestDistance = -1
    local closestPlayer   = -1
    local player        = tonumber(player)

    for i=1, #targets, 1 do
      local target = tonumber(targets[i])
      if target ~= player then
        local targetCoords = TriggerClientCallbackSynced(target,"GetPosition")
        local distance     = #(targetCoords-playerCoords)
        if closestDistance == -1 or closestDistance > distance then
          closestPlayer   = targets[i]
          closestDistance = distance
        end
      end
    end

    return closestPlayer, closestDistance
end


RegisterServerCallback("cmd:givecash",function(player,cb,target,amount)
    local player = tonumber(player) 
    local target = tonumber(target)
    local amount = tonumber(amount)

    if target == nil then target = GetClosestPlayerFromPlayer(player) end 
 
    if not GetPlayerEndpoint(target) then return cb(false,"player not exist") end 
    
    local playerCoords = TriggerClientCallbackSynced(player,"GetPosition")
    local targetCoords = TriggerClientCallbackSynced(target,"GetPosition")
    
    if #(playerCoords-targetCoords) > 5.0 then return cb(false,"Far Away From Player") end 
    
    if player == target then return cb(false,"SamePlayer") end 
    
    TransferPlayerMoneyToPlayer(player,target,"cash","cash",amount,function(success)
        if success then 
            TriggerClientEvent("MoneyTransfedMessage",player,"label:MPATM_TRANCOM","! ","hashlabel:0xC168FCA8"," $",amount)
            TriggerClientEvent("MoneyTransfedMessage",target,"label:MPATM_TRANCOM","! ","hashlabel:0xC168FCA8"," $",amount,"\n>>","cash")
        end 
        cb(success)
    end,"Give To","Receive From")
end)

RegisterServerCallback("cmd:paybank",function(player,cb,target,amount)
    local player = tonumber(player) 
    local target = tonumber(target)
    local amount = tonumber(amount)

    if target == nil then target = GetClosestPlayerFromPlayer(player) end 
 
    if not GetPlayerEndpoint(target) then return cb(false,"player not exist") end 
    
    local playerCoords = TriggerClientCallbackSynced(player,"GetPosition")
    local targetCoords = TriggerClientCallbackSynced(target,"GetPosition")
    
    if #(playerCoords-targetCoords) > 5.0 then return cb(false,"Far Away From Player") end 
    
    if player == target then return cb(false,"SamePlayer") end 
    
    TransferPlayerMoneyToPlayer(player,target,"bank","bank",amount,function(success)
        if success then 
            TriggerClientEvent("MoneyTransfedMessage",player,"label:MPATM_TRANCOM","! ","hashlabel:0xC168FCA8"," $",amount)
            TriggerClientEvent("MoneyTransfedMessage",target,"label:MPATM_TRANCOM","! ","hashlabel:0xC168FCA8"," $",amount,"\n>>","bank")
        end 
        cb(success)
    end,"Paid To","Receive Payment From")
end)


RconCommand = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) local source = source if source>0 then else fn(table.unpack(args)) end end) return end })
RconCommand["rconpaybank"] = function(amount,target)
    local amount,target = tonumber(amount),tonumber(target)
    AddPlayerMoney(target,"bank",amount,function(s)
        if s then print("Paid player: "..target.." with $"..amount.." OK!") end 
    end,"Paid by RCON?")
end 