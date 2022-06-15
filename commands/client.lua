Command = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) fn(table.unpack(args)) end) return end })
logInPauseMenu = 1
ShowNotificationTicker = function(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg or "")
    EndTextCommandThefeedPostTicker(0,logInPauseMenu)
end

local ShowNotification = ShowNotificationTicker
local GetLabelTextByHash = GetStreetNameFromHashKey


Command["give"] = function(amount,target)
    local amount,target = tonumber(amount),tonumber(target)
    TriggerServerCallback("cmd:give",function(suscess,err)
        
        if not suscess then 
            AddTextEntry("hexEntry:0x002FFD3A",GetLabelTextByHash(0x002FFD3A))
            BeginTextCommandThefeedPost("hexEntry:0x002FFD3A")
            AddTextComponentSubstringPlayerName("")
            EndTextCommandThefeedPostTicker(0,logInPauseMenu)
        else 
            BeginTextCommandThefeedPost("CELL_EMAIL_BCON")
            AddTextComponentSubstringTextLabel("MPATM_TRANCOM")
            AddTextComponentSubstringPlayerName("! ")
            AddTextComponentSubstringTextLabelHashKey(0xC168FCA8)
            AddTextComponentSubstringPlayerName(" $")
            AddTextComponentFormattedInteger(amount, true)
            EndTextCommandThefeedPostTicker(0,logInPauseMenu)
        end 
    end,target,amount)
end 

Command["pay"] = function(amount,target)
    local amount,target = tonumber(amount),tonumber(target)
    TriggerServerCallback("cmd:pay",function(suscess,err)
        if not suscess then 
            AddTextEntry("hexEntry:0x002FFD3A",GetLabelTextByHash(0x002FFD3A))
            BeginTextCommandThefeedPost("hexEntry:0x002FFD3A")
            EndTextCommandThefeedPostTicker(0,logInPauseMenu)
        else 
            BeginTextCommandThefeedPost("CELL_EMAIL_BCON")
            AddTextComponentSubstringTextLabel("MPATM_TRANCOM")
            AddTextComponentSubstringPlayerName("! ")
            AddTextComponentSubstringTextLabelHashKey(0xC168FCA8)
            AddTextComponentSubstringPlayerName(" $")
            AddTextComponentFormattedInteger(amount, true)
            
            EndTextCommandThefeedPostTicker(0,logInPauseMenu)
        end 
    end,target,amount)
end 

RegisterClientCallback("GetPosition",function(cb)
    cb(GetEntityCoords(PlayerPedId()))
end)
