--[[
    Project: Trust Hub - ESP Module
    File: features/esp.lua
    Description: Повноцінне підсвічування гравців (Highlight + Name ESP)
]]

local ESPModule = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local espEnabled = false
local connections = {}

-- Допоміжна функція створення ESP для конкретного персонажа
local function createESP(player)
    if player == localPlayer then return end

    local function applyHighlight(character)
        if not character then return end
        
        -- Очікуємо завантаження корінної частини
        character:WaitForChild("HumanoidRootPart", 5)
        character:WaitForChild("Head", 5)

        -- Перевіряємо чи вже існує ESP
        if character:FindFirstChild("TrustHubESP") then
            character.TrustHubESP:Destroy()
        end

        -- 1. Створення Highlight (підсвітка крізь стіни)
        local highlight = Instance.new("Highlight")
        highlight.Name = "TrustHubESP"
        highlight.FillColor = Color3.fromRGB(255, 40, 40) -- Яскраво-червоний колір
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Білий контур
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character

        -- 2. Створення BillboardGui для імені над головою
        if character:FindFirstChild("Head") and not character.Head:FindFirstChild("TrustHubNameESP") then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "TrustHubNameESP"
            billboard.Adornee = character.Head
            billboard.Size = UDim2.new(0, 100, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextSize = 13
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.Parent = billboard

            billboard.Parent = character.Head
        end
    end

    if player.Character then
        applyHighlight(player.Character)
    end

    -- Підписка на новий спавн гравця
    local conn = player.CharacterAdded:Connect(function(char)
        if espEnabled then
            task.wait(0.2)
            applyHighlight(char)
        end
    end)
    table.insert(connections, conn)
end

-- Основна функція увімкнення / вимкнення ESP
function ESPModule.Toggle(state)
    espEnabled = state

    if espEnabled then
        -- Вмикаємо ESP для всіх поточних гравців
        for _, player in pairs(Players:GetPlayers()) do
            createESP(player)
        end

        -- Підписуємося на нових гравців, які заходять на сервер
        local playerAddedConn = Players.PlayerAdded:Connect(function(player)
            if espEnabled then
                createESP(player)
            end
        end)
        table.insert(connections, playerAddedConn)
    else
        -- Відключаємо всі події
        for _, conn in pairs(connections) do
            if conn then conn:Disconnect() end
        end
        connections = {}

        -- Видаляємо ESP елементи з усіх персонажів
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                if player.Character:FindFirstChild("TrustHubESP") then
                    player.Character.TrustHubESP:Destroy()
                end
                if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("TrustHubNameESP") then
                    player.Character.Head.TrustHubNameESP:Destroy()
                end
            end
        end
    end
end

return ESPModule
