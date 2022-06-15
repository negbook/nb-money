Command = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) fn(table.unpack(args)) end) return end })
logInPauseMenu = 1
ShowNotificationTicker = function(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg or "")
    EndTextCommandThefeedPostTicker(0,logInPauseMenu)
end

local ShowNotification = ShowNotificationTicker
local GetLabelTextByHash = GetStreetNameFromHashKey


Command["givecash"] = function(amount,target)
    local amount = tonumber(amount)
    local target = tonumber(target)
    TriggerServerCallback("cmd:givecash",function(suscess,err)
        
        if not suscess then 
            AddTextEntry("hexEntry:0x002FFD3A",GetLabelTextByHash(0x002FFD3A))
            BeginTextCommandThefeedPost("hexEntry:0x002FFD3A")
            AddTextComponentSubstringPlayerName("")
            EndTextCommandThefeedPostTicker(0,logInPauseMenu)
        else 
            
        end 
    end,target,amount)
end 

Command["paybank"] = function(amount,target)
    local amount = tonumber(amount)
    local target = tonumber(target)
    TriggerServerCallback("cmd:paybank",function(suscess,err)
        if not suscess then 
            AddTextEntry("hexEntry:0x002FFD3A",GetLabelTextByHash(0x002FFD3A))
            BeginTextCommandThefeedPost("hexEntry:0x002FFD3A")
            EndTextCommandThefeedPostTicker(0,logInPauseMenu)
        else 
            
        end 
    end,target,amount)
end 



RegisterClientCallback("GetPosition",function(cb)
    cb(GetEntityCoords(PlayerPedId()))
end)
