--[[
    Project: Trust Hub Loader
    Description: Головний завантажувач модульного чит-меню з GitHub
]]

local GITHUB_USER = "YOUR_GITHUB_USERNAME"
local REPO_NAME = "YOUR_REPO_NAME"
local BRANCH = "main"

local baseUrl = string.format("https://raw.githubusercontent.com/%s/%s/%s/", GITHUB_USER, REPO_NAME, BRANCH)

local function loadModule(path)
    local success, result = pcall(function()
        local content = game:HttpGet(baseUrl .. path)
        local chunk, err = loadstring(content)
        if not chunk then
            error("Syntax error: " .. tostring(err))
        end
        return chunk()
    end)
    
    if not success then
        warn("[Trust Hub] Не вдалося завантажити модуль: " .. path .. "\nПомилка: " .. tostring(result))
        return nil
    end
    return result
end

print("[Trust Hub] Ініціалізація завантаження...");

-- 1. Завантаження інтерфейсу (ui.lua)
local UI = loadModule("ui.lua")
if not UI then
    warn("[Trust Hub] Фатальна помилка: не вдалося завантажити ui.lua!")
    return
end

-- 2. Завантаження всіх модулів із папки features/
local Features = {
    BodyESP   = loadModule("features/BodyESP.lua"),
    HighJump  = loadModule("features/HighJump.lua"),
    Wings     = loadModule("features/Wings.lua"),
    Animation = loadModule("features/animation.lua"),
    AntiFling = loadModule("features/antifling.lua"),
    AutoFarm  = loadModule("features/autofarm.lua"),
    AutoGun   = loadModule("features/autogun.lua"),
    ESP       = loadModule("features/esp.lua"),
    Fling     = loadModule("features/fling.lua"),
    Fly       = loadModule("features/fly.lua"),
    FOV       = loadModule("features/fov.lua"),
    InfJump   = loadModule("features/infjump.lua"),
    Murderer  = loadModule("features/murderer.lua"),
    Noclip    = loadModule("features/noclip.lua"),
    SilentAim = loadModule("features/silentaim.lua"),
    Speed     = loadModule("features/speed.lua"),
}

-- 3. Запуск інтерфейсу та передача функцій
if UI.Init then
    pcall(function()
        UI:Init(Features)
        print("[Trust Hub] Успішно запущено!")
    end)
else
    warn("[Trust Hub] У файлі ui.lua відсутня функція Init!")
end
