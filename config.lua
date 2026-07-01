Config = {}

Config.Framework = 'QBOX' -- Supported Frameworks: QBOX, ESX, QBCore

Config.ServerName = "Neon Scripts" -- Title Of Scoreboard

Config.ServerSlots = 60 -- Server Slots

Config.JobOrder = { 'police', 'ambulance', 'mechanic' } -- Order Of Jobs

Config.Jobs = {
    police = { -- Job ID
        title = "Police", -- Title Of Job
        high_count = 6, -- High Online Count
        medium_count = 3, -- Medium Online Count
    },
    ambulance = {
        title = "Ambulance",
        high_count = 4,
        medium_count = 2,
    },
    mechanic = {
        title = "Los Santos Custom",
        high_count = 3,
        medium_count = 2,
    }
}

Config.RobberOrder = { 'store', 'house', 'atm', 'arma' } -- Order Of Robberies Displayed On Robbery Status

Config.Robberies = {
    store = {
        title = "Store Robberies",
        job_count = 'police',
        online_count = 1 -- Police On To Turn > Active
    },
    house = {
        title = "House Robberies",
        job_count = 'police',
        online_count = 2
    },
    atm = {
        title = "ATM Robberies",
        job_count = 'police',
        online_count = 3
    },
    arma = {
        title = "AmraGuard Robberies",
        job_count = 'police',
        online_count = 4
    },
}