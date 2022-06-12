local GetClosestPlayerFromPlayer = function(player)
    local targets = GetPlayers()
    local playerCoords = TriggerClientCallbackSynced(player,"GetPosition")

      local closestDistance = -1
      local closestPlayer   = -1
      local coords          = coords
      local playerPed       = GetPlayerPed(-1)
      local playerId        = tonumber(player)

      for i=1, #targets, 1 do
        local target = tonumber(targets[i])
        if target ~= playerId then
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


RegisterServerCallback("cmd:give",function(player,cb,target,amount)
    local player = tonumber(player) 
    local target = tonumber(target)
    if target == nil then target = GetClosestPlayerFromPlayer(player) end 
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
    if target == nil then target = GetClosestPlayerFromPlayer(player) end 
 
    if not GetPlayerEndpoint(target) then return cb(false,"player not exist") end 
    
    local playerCoords = TriggerClientCallbackSynced(player,"GetPosition")
    local targetCoords = TriggerClientCallbackSynced(target,"GetPosition")
    
    if #(playerCoords-targetCoords) > 5.0 then return cb(false,"Far Away From Player") end 
    
    if player == target then return cb(false,"SamePlayer") end 
    TransferPlayerMoneyToPlayer(player,target,"bank","bank",amount,cb,"Paid To","Receive Payment From")
end)


