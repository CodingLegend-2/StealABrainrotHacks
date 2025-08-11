-- Octopus Hub - Smooth Executor-Friendly GUI with Key System & Notifications

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local correctKey = "FREE_OCTOPUS_3839JAO9"

-- ======= Key Input GUI =======

local keyGui = Instance.new("ScreenGui", CoreGui)
keyGui.Name = "OctopusKeyGui"

local frame = Instance.new("Frame", keyGui)
frame.Size = UDim2.new(0, 350, 0, 150)
frame.Position = UDim2.new(0.5, -175, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Text = "🔐 Enter Octopus Hub Key"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(200, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Position = UDim2.new(0, 0, 0, 10)

local textbox = Instance.new("TextBox", frame)
textbox.PlaceholderText = "Enter Key Here"
textbox.Size = UDim2.new(0.8, 0, 0, 40)
textbox.Position = UDim2.new(0.1, 0, 0, 60)
textbox.ClearTextOnFocus = false
textbox.Text = ""
textbox.Font = Enum.Font.Gotham
textbox.TextScaled = true
textbox.TextColor3 = Color3.fromRGB(255,255,255)
textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
textbox.TextStrokeTransparency = 0.8
local tbCorner = Instance.new("UICorner", textbox)
tbCorner.CornerRadius = UDim.new(0, 8)

local submitBtn = Instance.new("TextButton", frame)
submitBtn.Size = UDim2.new(0.35, 0, 0, 40)
submitBtn.Position = UDim2.new(0.325, 0, 0, 110)
submitBtn.Text = "Submit"
submitBtn.Font = Enum.Font.GothamSemibold
submitBtn.TextScaled = true
submitBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.BorderSizePixel = 0
local btnCorner = Instance.new("UICorner", submitBtn)
btnCorner.CornerRadius = UDim.new(0, 8)

-- Function to create notification on key GUI
local function notifyKeyGui(text, color)
    local notif = Instance.new("TextLabel", frame)
    notif.Size = UDim2.new(1, -20, 0, 30)
    notif.Position = UDim2.new(0, 10, 1, -40)
    notif.BackgroundTransparency = 0.6
    notif.BackgroundColor3 = color or Color3.fromRGB(180, 0, 0)
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.Text = text
    notif.Font = Enum.Font.GothamBold
    notif.TextScaled = true
    notif.TextWrapped = true

    task.delay(3, function()
        if notif then notif:Destroy() end
    end)
end

-- Variable to track key acceptance
local keyAccepted = false

submitBtn.MouseButton1Click:Connect(function()
    local input = textbox.Text
    if input == correctKey then
        keyAccepted = true
        keyGui:Destroy()
    else
        notifyKeyGui("❌ Incorrect Key! Try again.", Color3.fromRGB(255, 50, 50))
        textbox.Text = ""
    end
end)

-- Wait until key is accepted before continuing
repeat task.wait() until keyAccepted

-- ======= Main Octopus Hub GUI =======

local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local noclip = false
local basePosition = nil
local floatHeight = 10

-- Create Main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OctopusHub"
screenGui.Parent = CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🐙 Octopus Hub"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -70)
contentFrame.Position = UDim2.new(0, 10, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Notification System
local function createNotification(text, color)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 250, 0, 60)
    notif.Position = UDim2.new(1, 20, 0, 100)
    notif.BackgroundColor3 = color or Color3.fromRGB(50, 50, 70)
    notif.BorderSizePixel = 0
    notif.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notif
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextScaled = true
    notifText.Font = Enum.Font.Gotham
    notifText.Parent = notif
    
    local slideIn = TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -270, 0, 100)})
    slideIn:Play()
    
    task.delay(3, function()
        local slideOut = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 20, 0, 100)})
        slideOut:Play()
        slideOut.Completed:Connect(function()
            notif:Destroy()
        end)
    end)
end

-- Button Creation Function
local function createButton(name, text, position, color, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Position = position
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = contentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(math.clamp(color.R + 0.1,0,1), math.clamp(color.G + 0.1,0,1), math.clamp(color.B + 0.1,0,1))}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Noclip Brainrot Button
local noclipBtn = createButton("NoclipBtn", "🚀 Noclip Brainrot", UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 100, 100), function()
    pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Anti-teleport-script-35206"))()
    end)
    
    noclip = true
    humanoid.WalkSpeed = 29
    
    createNotification("🚀 Noclip Activated! Speed: 29", Color3.fromRGB(255, 100, 100))
    
    task.delay(10, function()
        createNotification("⚠️ Auto-rejoining in 3 seconds...", Color3.fromRGB(255, 165, 0))
        task.wait(3)
        local ts = game:GetService("TeleportService")
        ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end)
end)

-- Set Base Button
local setBaseBtn = createButton("SetBaseBtn", "📍 Set Base Position", UDim2.new(0, 0, 0, 60), Color3.fromRGB(0, 170, 255), function()
    basePosition = humanoidRootPart.Position
    createNotification("📍 Base position saved!", Color3.fromRGB(0, 170, 255))
end)

-- Tween to Base Button
local tweenBaseBtn = createButton("TweenBaseBtn", "🌟 Tween to Base", UDim2.new(0, 0, 0, 120), Color3.fromRGB(0, 200, 0), function()
    if not basePosition then
        createNotification("❌ No base position set!", Color3.fromRGB(255, 85, 85))
        return
    end
    
    createNotification("🌟 Traveling to base...", Color3.fromRGB(0, 200, 0))
    
    local function travelAboveBase(targetPos)
        local upPos = humanoidRootPart.Position + Vector3.new(0, floatHeight, 0)
        local targetAbove = Vector3.new(targetPos.X, upPos.Y, targetPos.Z)

        local tween1 = TweenService:Create(humanoidRootPart, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {CFrame = CFrame.new(upPos)})
        tween1:Play()
        tween1.Completed:Wait()

        local horizontalDist = (targetAbove - upPos).Magnitude
        local travelTime = horizontalDist / 16
        local tween2 = TweenService:Create(humanoidRootPart, TweenInfo.new(travelTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetAbove)})
        tween2:Play()
        tween2.Completed:Wait()

        local dropTime = math.abs((targetAbove.Y - targetPos.Y)) / 30
        local tween3 = TweenService:Create(humanoidRootPart, TweenInfo.new(dropTime, Enum.EasingStyle.Quad), {CFrame = CFrame.new(targetPos)})
        tween3:Play()
        tween3.Completed:Wait()
        
        createNotification("✅ Arrived at base!", Color3.fromRGB(0, 255, 127))
    end
    
    travelAboveBase(basePosition)
end)

-- Toggle Noclip Button
local toggleNoclipBtn = createButton("ToggleNoclipBtn", "👻 Toggle Noclip", UDim2.new(0, 0, 0, 180), Color3.fromRGB(138, 43, 226), function()
    noclip = not noclip
    local status = noclip and "ON" or "OFF"
    local color = noclip and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 85, 85)
    createNotification("👻 Noclip: " .. status, color)
end)

-- Speed Control Button
local speedBtn = createButton("SpeedBtn", "⚡ Speed Boost (16→50)", UDim2.new(0, 0, 0, 240), Color3.fromRGB(255, 165, 0), function()
    local newSpeed = humanoid.WalkSpeed == 16 and 50 or 16
    humanoid.WalkSpeed = newSpeed
    createNotification("⚡ Speed set to: " .. newSpeed, Color3.fromRGB(255, 165, 0))
end)

-- Close button functionality
closeBtn.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 0, 0, 0)})
    closeTween:Play()
    closeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Noclip Loop
RunService.Stepped:Connect(function()
    if noclip and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
    noclip = false
end)

-- Entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local entranceTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 300, 0, 400)})
entranceTween:Play()

-- Welcome notification
createNotification("🐙 Octopus Hub Loaded!", Color3.fromRGB(138, 43, 226))
