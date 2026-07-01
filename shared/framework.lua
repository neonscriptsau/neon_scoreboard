Framework = {}

local function NormalizeFramework(name)
    local fw = string.upper(tostring(name or 'QBCORE'))

    if fw == 'QB' or fw == 'QB-CORE' or fw == 'QBCORE' then
        return 'QBCORE'
    end

    if fw == 'QBOX' or fw == 'QBX' then
        return 'QBOX'
    end

    if fw == 'ESX' then
        return 'ESX'
    end

    return fw
end

local framework = NormalizeFramework(Config.Framework)

local function IsPlayerOnDuty(job)
    if not job then
        return false
    end

    if job.onduty ~= nil then
        return job.onduty
    end

    if job.onDuty ~= nil then
        return job.onDuty
    end

    return true
end

if framework == 'QBCORE' or framework == 'QBOX' then
    local resource = framework == 'QBOX' and 'qbx_core' or 'qb-core'
    local Core = exports[resource]:GetCoreObject()

    function Framework.GetPlayerIds()
        return Core.Functions.GetPlayers()
    end

    function Framework.GetJob(source)
        local player = Core.Functions.GetPlayer(source)
        if not player then
            return nil
        end

        local job = player.PlayerData.job
        return {
            name = job.name,
            onduty = IsPlayerOnDuty(job),
        }
    end

    if IsDuplicityVersion() then
        function Framework.CreateCallback(name, fn)
            Core.Functions.CreateCallback(name, fn)
        end
    else
        function Framework.TriggerCallback(name, cb)
            Core.Functions.TriggerCallback(name, cb)
        end
    end
elseif framework == 'ESX' then
    local ESX = exports['es_extended']:getSharedObject()

    function Framework.GetPlayerIds()
        return ESX.GetPlayers()
    end

    function Framework.GetJob(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then
            return nil
        end

        local job = xPlayer.job
        return {
            name = job.name,
            onduty = IsPlayerOnDuty(job),
        }
    end

    if IsDuplicityVersion() then
        function Framework.CreateCallback(name, fn)
            ESX.RegisterServerCallback(name, fn)
        end
    else
        function Framework.TriggerCallback(name, cb)
            ESX.TriggerServerCallback(name, cb)
        end
    end
else
    error(('neon_scoreboard: unsupported framework "%s"'):format(Config.Framework))
end
