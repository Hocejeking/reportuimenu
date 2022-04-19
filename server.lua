
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

AddEventHandler('esx:playerLoaded',function( playerId, xPlayer)
    if(config.authorizedGroups[xPlayer.group])then
        TriggerClientEvent('adminCheck',playerId,true)
    end
end)

RegisterNetEvent('performWebhook',function(name,data,source)
    sendToDiscord(name,data,source)
end)

function saveReport(name,message,source)
    --TODO

end


function sendToDiscord(name,message,source)
    local playerName = GetPlayerName(source)
    local steamid  = ""
    local license  =""
    local discord  = ""
    local xbl      = ""
    local liveid   = ""
    local ip       = ""
  for k,v in pairs(GetPlayerIdentifiers(source))do
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        steamid = v
      elseif string.sub(v, 1, string.len("license:")) == "license:" then
        license = v
      elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
        xbl  = v
      elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
        ip = v
      elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
        discord = v
      elseif string.sub(v, 1, string.len("live:")) == "live:" then
        liveid = v
      end
    end
         local embed =
        { 
            {
            ["title"] = 'Hráč : '..source,
            ["description"] = message,
            ["fields"] = {

                {
                ["name"] = 'Identifiers',
                ["value"] = --steamid .. ' \n' ..
                            license .. ' \n' .. 
                            discord .. ' \n' .. 
                            xbl .. ' \n' .. 
                            liveid.. ' \n' ..
                            ip,
                ["inline"] = "false",
                },
                {
                ["name"] = 'Pozice',
                ["value"] = 'X : ' ..
                            'Y : ' .. 
                            'Z : ' ,
                ["inline"] = 'false',
                },
                {
                    ["name"] = 'Jméno hráče',
                    ["value"] = playerName,
                    ["inline"] = 'false',
                }, 
            },
                ["footer"] = {
                ["text"] = 'typ: '.. name,
                },
            }
        }
    PerformHttpRequest(config.testurl,
     function(err,text,headers)end,
     'POST',
     json.encode({username = 'ReportSystem',embeds = embed}),
     {['Content-Type'] = 'application/json'})
end 

RegisterCommand("checkAdmin",function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if(config.authorizedGroups[xPlayer.group])then
        TriggerClientEvent('adminCheck',source,true)
    end
end, false)
