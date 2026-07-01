local serverStartTime = os.time()

local function GetFormattedUptime()
    local secs = os.time() - serverStartTime
    local hours = math.floor(secs / 3600)
    local minutes = math.floor((secs % 3600) / 60)
    return string.format("%dh %02dm", hours, minutes)
end

local function GetPlayerCount()
    return #GetPlayers()
end

local function BuildJobCounts()
    local counts, jobsConfig = {}, {}

    for _, jobKey in ipairs(Config.JobOrder) do
        local jobData = Config.Jobs[jobKey]

        counts[jobKey] = 0
        jobsConfig[#jobsConfig + 1] = {
            key = jobKey,
            title = jobData.title,
            high = jobData.high_count,
            medium = jobData.medium_count
        }
    end

    for _, id in ipairs(Framework.GetPlayerIds()) do
        local job = Framework.GetJob(id)
        if job and job.onduty and counts[job.name] ~= nil then
            counts[job.name] = counts[job.name] + 1
        end
    end

    return counts, jobsConfig
end

local function BuildScoreboardPayload()
    local counts, jobsConfig = BuildJobCounts()

    return {
        total = GetPlayerCount(),
        slots = Config.ServerSlots,
        uptime = GetFormattedUptime(),
        counts = counts,
        jobs = jobsConfig
    }
end

local function BroadcastScoreboardUpdate()
    local payload = BuildScoreboardPayload()

    for _, id in ipairs(GetPlayers()) do
        TriggerClientEvent('neon_scoreboard:updateUI', tonumber(id), payload)
    end
end

CreateThread(function()
    while true do
        BroadcastScoreboardUpdate()
        Wait(15000)
    end
end)

AddEventHandler('playerJoining', function()
    SetTimeout(5000, BroadcastScoreboardUpdate)
end)

AddEventHandler('playerDropped', function()
    SetTimeout(1000, BroadcastScoreboardUpdate)
end)

Framework.CreateCallback('neon_scoreboard:getCounts', function(_, cb)
    cb(BuildScoreboardPayload())
end)

Framework.CreateCallback('neon_scoreboard:getRobberyStatus', function(_, cb)
    local jobCounts = {}

    for _, robbery in pairs(Config.Robberies) do
        if not jobCounts[robbery.job_count] then
            jobCounts[robbery.job_count] = 0
        end
    end

    for _, id in ipairs(Framework.GetPlayerIds()) do
        local job = Framework.GetJob(id)
        if job and job.onduty and jobCounts[job.name] ~= nil then
            jobCounts[job.name] = jobCounts[job.name] + 1
        end
    end

    local robberyData = {}

    for _, key in ipairs(Config.RobberOrder) do
        local rob = Config.Robberies[key]
        local online = jobCounts[rob.job_count] or 0
        robberyData[#robberyData + 1] = {
            key = key,
            title = rob.title,
            job = rob.job_count,
            required = rob.online_count,
            current = online
        }
    end

    cb(robberyData)
end)

RegisterNetEvent('neon_scoreboard:requestData', function()
    local src = source
    TriggerClientEvent('neon_scoreboard:updateUI', src, BuildScoreboardPayload())
end)

RegisterNetEvent('neon_scoreboard:refreshForAll', function()
    BroadcastScoreboardUpdate()
end)
