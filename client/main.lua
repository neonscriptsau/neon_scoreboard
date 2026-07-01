local isOpen = false
local playtime = 0

RegisterCommand("scoreboard", function()
    isOpen = not isOpen
    SetNuiFocus(isOpen, isOpen)
    SendNUIMessage({ action = isOpen and "show" or "hide" })
    

    if isOpen then
        TriggerServerEvent("neon_scoreboard:requestData")

        local hours = math.floor(playtime / 60)
        local minutes = playtime % 60
        local formatted = string.format("%dh %02dm", hours, minutes)
        SendNUIMessage({ action = "updatePlaytime", playtime = formatted })
    end
end)

RegisterKeyMapping("scoreboard", "Toggle Scoreboard", "keyboard", "HOME")

RegisterNUICallback("closeUI", function(_, cb)
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hide" })
    cb("ok")
end)

RegisterNUICallback("robberyClick", function(_, cb)
    Framework.TriggerCallback("neon_scoreboard:getRobberyStatus", function(data)
        SendNUIMessage({
            action = "updateRobberies",
            robberies = data
        })
    end)
    cb("ok")
end)

RegisterNUICallback("requestServices", function(_, cb)
    TriggerServerEvent("neon_scoreboard:requestData")
    cb("ok")
end)

CreateThread(function()
    while true do
        Wait(60000)
        playtime = playtime + 1

        if isOpen then
            local hours = math.floor(playtime / 60)
            local minutes = playtime % 60
            local formatted = string.format("%dh %02dm", hours, minutes)
            SendNUIMessage({
                action = "updatePlaytime",
                playtime = formatted
            })
        end
    end
end)

RegisterNetEvent("neon_scoreboard:updateUI", function(data)
    SendNUIMessage({
        action = "updateData",
        total = data.total,
        slots = data.slots,
        uptime = data.uptime,
        counts = data.counts,
        jobs = data.jobs
    })
end)

RegisterNUICallback('getServerName', function(_, cb)
    cb(Config.ServerName)
end)