Config = {}

Config.Debug = false

---𝗙𝗥𝗔𝗠𝗘𝗪𝗢𝗥𝗞 (Choose the desired frame work you are using) works with --[[ qb, esx, nd, qbx ]]
Config.Framework = 'qb' -- change me ! 

Config.DropOffs = {
    [1] = vector3(152.52, 237.36, 106.97),
    [2] = vector3(646.28, 267.24, 103.26),
    [3] = vector3(971.65, 8.67, 81.04),
    [4] = vector3(1137.58, -470.69, 66.67),
    [5] = vector3(1165.29, -1347.32, 35.97),
    [6] = vector3(858.68, -3202.46, 5.99),
    --[7] = vector3(858.68, -3202.46, 5.99),   remove the (--) to get line of code keep (--) if you dont want more spots! 
    --[8] = vector3(858.68, -3202.46, 5.99),
    --[9] = vector3(858.68, -3202.46, 5.99),
    --[10] = vector3(858.68, -3202.46, 5.99),
    -- Add more drop-off positions if you want them here [6] = vector3(858.68, -3202.46, 5.99),
}
---𝗧𝗥𝗨𝗖𝗞 𝗦𝗣𝗔𝗪𝗡𝗦 -- Spawn Areas for the Trucks !  add more if needed or wanted
Config.Spawns = {
    [1] = vector4(-3155.67, 1132.26, 20.69, 335.2),
    [2] = vector4(62.66, 123.57, 79.02, 161.44),
    [3] = vector4(-425.89, 6167.91, 31.32, 315.59),
    [4] = vector4(-521.54, -2904.96, 5.83, 113.16) --if adding more put , behind this exp: [4] = vector4(-521.54, -2904.96, 5.83, 113.16),<-- 
    --[5] = vector4(-521.54, -2904.96, 5.83, 113.16)
    -- Spawn Areas for the Trucks ! 
}
--- 𝐣𝐨𝐛 𝐥𝐨𝐜𝐚𝐭𝐢𝐨𝐧𝐬  Change to your liking ! Can use custom vehicles from your server if you have them!!
Config.JobLoc = {
    [1] = {v = vector3(-3147.12, 1121.18, 20.86), h = 59.9, veh = "boxville4"},   
    [2] = {v = vector3(78.81, 111.89, 81.16), h = 64.33, veh = "boxville4"},
    [3] = {v = vector3(-421.2, 6136.79, 31.87), h = 181.67, veh = "boxville4"},
    [4] = {v = vector3(-424.23, -2789.84, 6.52), h = 134.05, veh = "boxville4"}
    -- can add more if needed or wanted!
}
--- 𝐏𝐀𝐘𝐎𝐔𝐓𝐒 (Can set to your liking exp: 650,<--Lowest--Highest--> 850)
Config.Payouts = {
    [1] = function()
        return math.random(650, 850)
    end,
    [2] = function()
        return math.random(480, 220)
    end,
    [3] = function()
        return math.random(1000, 1200)
    end,
    [4] = function()
        return math.random(1000, 1200)
    end,
    [5] = function()
        return math.random(1000, 1200)
    end
    -- Add more payouts as needed
}
