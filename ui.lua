--[[
    Project: Trust Hub - Advanced UI Library & Interface
    Description: Преміальний анімований інтерфейс для Roblox Mod Menu
]]

local UI = {}

function UI:Init(Features)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")

    local localPlayer = Players.LocalPlayer
    local toggleKey = Enum.KeyCode.F4

    -- Захист від дублікатів GUI
    if CoreGui:FindFirstChild("TrustHubAdvancedGui") then
        CoreGui.TrustHubAdvancedGui:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TrustHubAdvancedGui"
    screenGui.ResetOnSpawn = false
    pcall(function() screenGui.Parent = CoreGui end)
    if not screenGui.Parent then screenGui.Parent = localPlayer:WaitForChild("PlayerGui") end

    -- Головне вікно
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 620, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
    mainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame

    -- Неонова обводка
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 170, 255)
    mainStroke.Thickness = 1.5
    mainStroke.Parent = mainFrame

    -- Верхня панель (Header)
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    local logoText = Instance.new("TextLabel")
    logoText.Size = UDim2.new(0, 200, 1, 0)
    logoText.Position = UDim2.new(0, 15, 0, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "⚡ TRUST HUB"
    logoText.TextColor3 = Color3.fromRGB(0, 170, 255)
    logoText.TextSize = 16
    logoText.Font = Enum.Font.GothamBold
    logoText.TextXAlignment = Enum.TextXAlignment.Left
    logoText.Parent = header

    local subText = Instance.new("TextLabel")
    subText.Size = UDim2.new(0, 200, 1, 0)
    subText.Position = UDim2.new(0, 130, 0, 0)
    subText.BackgroundTransparency = 1
    subText.Text = "| Premium v2.0"
    subText.TextColor3 = Color3.fromRGB(100, 100, 120)
    subText.TextSize = 12
    subText.Font = Enum.Font.Gotham
    subText.TextXAlignment = Enum.TextXAlignment.Left
    subText.Parent = header

    -- Бокова панель вкладок (Sidebar)
    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Size = UDim2.new(0, 160, 1, -45)
    sidebar.Position = UDim2.new(0, 0, 0, 45)
    sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 21)
    sidebar.BorderSizePixel = 0
    sidebar.ScrollBarThickness = 2
    sidebar.Parent = mainFrame

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.Parent = sidebar

    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 12)
    sidebarPadding.PaddingLeft = UDim.new(0, 10)
    sidebarPadding.PaddingRight = UDim.new(0, 10)
    sidebarPadding.Parent = sidebar

    -- Контейнер вмісту
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -170, 1, -55)
    container.Position = UDim2.new(0, 165, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = mainFrame

    -- Система створення вкладок
    local tabs = {}
    local function createTab(name, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
        btn.BorderSizePixel = 0
        btn.Text = "   " .. name
        btn.TextColor3 = Color3.fromRGB(140, 140, 165)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamSemibold
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = order
        btn.Parent = sidebar

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4
        page.Visible = false
        page.Parent = container

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 8)
        pageLayout.Parent = page

        tabs[name] = {Button = btn, Page = page}

        btn.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.Page.Visible = false
                TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 32), TextColor3 = Color3.fromRGB(140, 140, 165)}):Play()
            end
            page.Visible = true
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        return page
    end

    local movementPage = createTab("Movement", 1)
    local visualsPage = createTab("Visuals", 2)
    local combatPage = createTab("Combat", 3)
    local teleportPage = createTab("Teleport", 4)
    local settingsPage = createTab("Settings", 5)

    -- Активуємо першу вкладку за замовчуванням
    tabs["Movement"].Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    tabs["Movement"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    movementPage.Visible = true

    -- Функція для створення елементів керування (Toggle)
    local function addToggle(page, text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
        frame.BorderSizePixel = 0
        frame.Parent = page

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 14, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220, 220, 240)
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local toggled = false
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 38, 0, 20)
        btn.Position = UDim2.new(1, -48, 0.5, -10)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        btn.Text = ""
        btn.Parent = frame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(1, 0)
        btnCorner.Parent = btn

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 16, 0, 16)
        circle.Position = UDim2.new(0, 2, 0.5, -8)
        circle.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
        circle.Parent = btn

        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = circle

        btn.MouseButton1Click:Connect(function()
            toggled = not toggled
            local targetColor = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(35, 35, 48)
            local targetPos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
            
            pcall(function() callback(toggled) end)
        end)
    end

    -- === НАПОВНЕННЯ ФУНКЦІЯМИ ===

    -- 1. MOVEMENT
    addToggle(movementPage, "Speed Hack", function(state) if Features.Speed then Features.Speed.Toggle(state) end end)
    addToggle(movementPage, "Fly Mode", function(state) if Features.Fly then Features.Fly.Toggle(state) end end)
    addToggle(movementPage, "High Jump", function(state) if Features.HighJump then Features.HighJump.Toggle(state) end end)
    addToggle(movementPage, "Inf Jump", function(state) if Features.InfJump then Features.InfJump.Toggle(state) end end)
    addToggle(movementPage, "Noclip", function(state) if Features.Noclip then Features.Noclip.Toggle(state) end end)
    addToggle(movementPage, "Anti Fling", function(state) if Features.AntiFling then Features.AntiFling.Toggle(state) end end)
    addToggle(movementPage, "Player Fling", function(state) if Features.Fling then Features.Fling.Toggle(state) end end)

    -- 2. VISUALS
    addToggle(visualsPage, "Standard ESP", function(state) if Features.ESP then Features.ESP.Toggle(state) end end)
    addToggle(visualsPage, "Body ESP", function(state) if Features.BodyESP then Features.BodyESP.Toggle(state) end end)
    addToggle(visualsPage, "Custom FOV", function(state) if Features.FOV then Features.FOV.Toggle(state) end end)
    addToggle(visualsPage, "Wings Custom", function(state) if Features.Wings then Features.Wings.Toggle(state) end end)
    addToggle(visualsPage, "Custom Animations", function(state) if Features.Animation then Features.Animation.Toggle(state) end end)

    -- 3. COMBAT
    addToggle(combatPage, "Silent Aim", function(state) if Features.SilentAim then Features.SilentAim.Toggle(state) end end)
    addToggle(combatPage, "Auto Gun / Shoot", function(state) if Features.AutoGun then Features.AutoGun.Toggle(state) end end)
    addToggle(combatPage, "Murderer Helper", function(state) if Features.Murderer then Features.Murderer.Toggle(state) end end)
    addToggle(combatPage, "Auto Farm", function(state) if Features.AutoFarm then Features.AutoFarm.Toggle(state) end end)

    -- 4. TELEPORT
    local function refreshTeleportList()
        for _, child in pairs(teleportPage:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= localPlayer then
                local tpBtn = Instance.new("TextButton")
                tpBtn.Size = UDim2.new(1, -10, 0, 36)
                tpBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
                tpBtn.BorderSizePixel = 0
                tpBtn.Text = "   👤 " .. plr.Name .. " (Teleport)"
                tpBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
                tpBtn.TextSize = 12
                tpBtn.Font = Enum.Font.Gotham
                tpBtn.TextXAlignment = Enum.TextXAlignment.Left
                tpBtn.Parent = teleportPage

                local c = Instance.new("UICorner")
                c.CornerRadius = UDim.new(0, 6)
                c.Parent = tpBtn

                tpBtn.MouseButton1Click:Connect(function()
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        localPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    end
                end)
            end
        end
    end

    refreshTeleportList()
    Players.PlayerAdded:Connect(refreshTeleportList)
    Players.PlayerRemoving:Connect(refreshTeleportList)

    -- 5. SETTINGS
    local keybindInfo = Instance.new("TextLabel")
    keybindInfo.Size = UDim2.new(1, -10, 0, 45)
    keybindInfo.BackgroundTransparency = 1
    keybindInfo.Text = "Menu Toggle Key: [ F4 ]\nClick below to change hotkey:"
    keybindInfo.TextColor3 = Color3.fromRGB(160, 160, 185)
    keybindInfo.TextSize = 13
    keybindInfo.Font = Enum.Font.Gotham
    keybindInfo.TextXAlignment = Enum.TextXAlignment.Left
    keybindInfo.Parent = settingsPage

    local changeKeyBtn = Instance.new("TextButton")
    changeKeyBtn.Size = UDim2.new(1, -10, 0, 40)
    changeKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    changeKeyBtn.BorderSizePixel = 0
    changeKeyBtn.Text = "Change Hotkey"
    changeKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    changeKeyBtn.TextSize = 13
    changeKeyBtn.Font = Enum.Font.GothamBold
    changeKeyBtn.Parent = settingsPage

    local cBtnCorner = Instance.new("UICorner")
    cBtnCorner.CornerRadius = UDim.new(0, 6)
    cBtnCorner.Parent = changeKeyBtn

    local listeningForKey = false
    changeKeyBtn.MouseButton1Click:Connect(function()
        listeningForKey = true
        changeKeyBtn.Text = "Press any key..."
    end)

    -- Анімація та бінд клавіші
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listeningForKey and input.UserInputType == Enum.UserInputType.Keyboard then
            toggleKey = input.KeyCode
            listeningForKey = false
            changeKeyBtn.Text = "Change Hotkey"
            keybindInfo.Text = "Menu Toggle Key: [ " .. input.KeyCode.Name .. " ]\nClick below to change hotkey:"
        end

        if not gameProcessed and input.KeyCode == toggleKey then
            local visible = not mainFrame.Visible
            if visible then
                mainFrame.Visible = true
                mainFrame.Size = UDim2.new(0, 0, 0, 0)
                TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 620, 0, 420)}):Play()
            else
                local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
                tween:Play()
                tween.Completed:Connect(function() mainFrame.Visible = false end)
            end
        end
    end)

    print("[Trust Hub] Преміальний UI успішно ініціалізовано!")
end

return UI
