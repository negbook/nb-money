RegisterServerCallback("cmd:give",function(player,cb,target,amount)
    local player = tonumber(player) 
    local target = tonumber(target)
    if not GetPlayerEndpoint(target) then return cb(false,"player not exist") end 
    
    local playerCoords = TriggerClientCallbackSynced(player,"GetPosition")
    local targetCoords = TriggerClientCallbackSynced(target,"GetPosition")
    
    if #(playerCoords-targetCoords) > 5.0 then return cb(false,"Far Away From Player") end 
    
    if player == target then return cb(false,"SamePlayer") end 
    
    TransferPlayerMoneyToPlayer(player,target,"cash","cash",amount,cb,"Give To","Receive From")
end)

RegisterServerCallback("cmd:pay",function(player,cb,target,amount)
    local player = tonumber(player) 
    local target = tonumber(target)
    if not GetPlayerEndpoint(target) then return cb(false,"player not exist") end 
    
    local playerCoords = TriggerClientCallbackSynced(player,"GetPosition")
    local targetCoords = TriggerClientCallbackSynced(target,"GetPosition")
    
    if #(playerCoords-targetCoords) > 5.0 then return cb(false,"Far Away From Player") end 
    
    if player == target then return cb(false,"SamePlayer") end 
    TransferPlayerMoneyToPlayer(player,target,"bank","bank",amount,cb,"Paid To","Receive Payment From")
end)


