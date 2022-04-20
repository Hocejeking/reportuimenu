local display = false
local src = ""
local isAdmin = false

--[[RegisterCommand("report",function(source, args, rawCommand)
    SetDisplay(not display)
    src = source
end, false)]]

RegisterNUICallback("report",function(data)
    chat(data.text .." "..data.type,{0,255,0})
    if data.type == "report" then
        TriggerServerEvent('performWebhookAndCreateReport',data.type,data.text,src)
        
    elseif data.type == "q" then
        TriggerServerEvent('performWebhookAndCreateReport','otázka',data.text,src)
        
    elseif data.type =="bug" then
        TriggerServerEvent('performWebhookAndCreateReport',data.type,data.text,src)
        
    end 
    SetDisplay(false)
end)

RegisterNUICallback("error",function(data)
    chat(data.error,{255,0,0})
    SetDisplay(false)
end)

RegisterNUICallback("exit",function(data)
    chat(data.exitReason,{0,0,255})
    print(data.exitReason)
    SetDisplay(false)
end)

RegisterNUICallback("adminMenuOpened",function(data)
    chat(data.exitReason,{0,0,255})
    print(data.exitReason)
end)

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0,1,display)
        DisableControlAction(0,2,display)
        DisableControlAction(0,142,display)
        DisableControlAction(0,18,display)
        DisableControlAction(0,322,display)
        DisableControlAction(0,106,display)
        DisableControlAction(0,13,display)
    end 
end)


RegisterCommand("report",function(source, args, rawCommand)
    src = GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId()))
    print(src)
    SetDisplay(not display)
end, false)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool,bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
        isAdmin = isAdmin,
    })
    
end

function addReportToNUI(name,text,source,reportId)
    print(name..text..source..reportId)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "newReport",
        status = false,
        text = text,
        name = name,
        source = source,
        reportId = reportId,
    })
end

function chat(str,color)
    TriggerEvent("chat:addMessage",{
    color = color,
    multiline = true,
    args = {str}
})
end

RegisterNetEvent('adminCheck',function(bool)
    isAdmin = bool 
end)

RegisterNetEvent('createAndShowReport',function (name,text,source,reportId)
    addReportToNUI(name,text,source,reportId)
end)
