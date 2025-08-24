-- Oxtopus Hub Autosteal v0.01 (Cleaned for obfuscation) -- Place this LocalScript in StarterGui or run via executor that supports getgenv

if getgenv().oxtopus_autosteal_exists then return end getgenv().oxtopus_autosteal_exists = true getgenv().autoRob = getgenv().autoRob or false

-- Services local Players = game:GetService("Players") local PathfindingService = game:GetService("PathfindingService") local TweenService = game:GetService("TweenService") local UserInputService = game:GetService("UserInputService")

local clientPlayer = Players.LocalPlayer

-- ====== Original logic (cleaned for safety) ====== local success, Mutations = pcall(function() return require(game.ReplicatedStorage.Datas.Mutations) end) if not success then Mutations = {} end

local function ApplyBrainrotDataMutation(data, mutationName) local mutationData = Mutations[mutationName] if not mutationData then return end local mutationModifier = mutationData.Modifier or 0 data.Price = data.Price + data.Price * mutationModifier data.Generation = data.Generation + data.Generation * mutationModifier end

local success2, Animals = pcall(function() return require(game.ReplicatedStorage.Datas.Animals) end) if not success2 then Animals = {} end

local function GetPlotBrainrotData(plot, index) local brainrotSpawn = plot.AnimalPodiums[tostring(index)] and plot.AnimalPodiums[tostring(index)].Base.Spawn if not brainrotSpawn then return end

local attachment = brainrotSpawn:FindFirstChild('Attachment')
if not attachment then return end

local billboard = attachment:FindFirstChild('AnimalOverhead')
if not billboard then return end

local displayName = billboard:FindFirstChild('DisplayName')
if not displayName or not displayName.Visible then return end

local mutationLabel = billboard:FindFirstChild('Mutation')

local data = Animals[displayName.Text] and table.clone(Animals[displayName.Text])
if not data then return end

if mutationLabel and mutationLabel.Visible then
    local mutation = mutationLabel.Text
    data.Mutation = mutation
    ApplyBrainrotDataMutation(data, mutation)
end

return data

end

local function IsPlotOpen(plot) if not plot:FindFirstChild('LaserHitbox') then return false end for _, v in ipairs(plot.LaserHitbox:GetChildren()) do if not v.CanCollide then return true end end return false end

local Plots = workspace:FindFirstChild('Plots') or workspace local clientPlot for _, v in ipairs(Plots:GetChildren()) do if v:FindFirstChild('PlotSign') and v.PlotSign:FindFirstChild('YourBase') and v.PlotSign.YourBase.Enabled then clientPlot = v break end end

local function IsBrainrotStealable(podium) local start = clientPlayer.Character and clientPlayer.Character:FindFirstChild('HumanoidRootPart') if not start then return end start = start.Position local PromptAttachment = podium.Base and podium.Base.Spawn and podium.Base.Spawn:FindFirstChild('PromptAttachment') if not PromptAttachment then return end local goal = PromptAttachment.WorldCFrame.Position local pathObj = PathfindingService:CreatePath({ AgentRadius = 3, AgentHeight = 6, AgentCanJump = false }) local ok = pcall(function() pathObj:ComputeAsync(start, goal) end) if not ok or pathObj.Status ~= Enum.PathStatus.Success then return end

local stealPrompt
for _, v in ipairs(PromptAttachment:GetChildren()) do
    if v:IsA('ProximityPrompt') and v.ActionText == 'Steal' then
        stealPrompt = v
        break
    end
end

return pathObj, stealPrompt

end

local function GetPlotsBestBrainrot() local bestData, bestPodium, bestGeneration, bestPath, bestStealPrompt = nil, nil, 0, nil, nil

for _, plot in ipairs(Plots:GetChildren()) do
    if plot == clientPlot then continue end
    if not IsPlotOpen(plot) then continue end
    if not plot:FindFirstChild('AnimalPodiums') then continue end

    for podiumIndex, podium in ipairs(plot.AnimalPodiums:GetChildren()) do
        local brainrotData = GetPlotBrainrotData(plot, podiumIndex)
        if not brainrotData then continue end

        local generation = brainrotData.Generation or 0
        if generation > bestGeneration then
            local path, stealPrompt = IsBrainrotStealable(podium)
            if not path then continue end

            bestData = brainrotData
            bestPodium = podium
            bestGeneration = generation
            bestPath = path
            bestStealPrompt = stealPrompt
        end
    end
end

return bestData, bestPodium, bestPath, bestStealPrompt

end

local part = Instance.new('Part') part.Size = Vector3.new(1,1,1) part.Anchored = true part.CanCollide = false part.Material = Enum.Material.Neon part.Shape = Enum.PartType.Ball part.Parent = workspace

local function WalkPath(path) local character = clientPlayer.Character if not character then return end local root = character:FindFirstChild('HumanoidRootPart') local humanoid = character:FindFirstChild('Humanoid') if not root or not humanoid then return end

for _, waypoint in ipairs(path:GetWaypoints()) do
    local goal = waypoint.Position
    part.Position = goal

    while getgenv().autoRob and (root.Position - goal).Magnitude > 5 do
        humanoid:MoveTo(goal)
        task.wait()
    end
    if not getgenv().autoRob then return end
end

end

local function StealBrainrot(podium, path, stealPrompt) WalkPath(path) if not getgenv().autoRob then return end if stealPrompt and stealPrompt:IsA('ProximityPrompt') then stealPrompt:InputHoldBegin() end end

local deliveryGoal = clientPlot and clientPlot:FindFirstChild('DeliveryHitbox') and clientPlot.DeliveryHitbox.Position or nil local function DeliverBrainrot() if not deliveryGoal then return end local start = clientPlayer.Character and clientPlayer.Character:FindFirstChild('HumanoidRootPart') if not start then return end start = start.Position local pathObj = PathfindingService:CreatePath({ AgentRadius = 3, AgentHeight = 6, AgentCanJump = false }) local ok = pcall(function() pathObj:ComputeAsync(start, deliveryGoal) end) if not ok or pathObj.Status ~= Enum.PathStatus.Success then return end WalkPath(pathObj) end

local function Loop() if not getgenv().autoRob then return end if clientPlayer:GetAttribute('Stealing') then DeliverBrainrot() return end

local data, podium, path, stealPrompt = GetPlotsBestBrainrot()
if not data or not path then return end
StealBrainrot(podium, path, stealPrompt)

end

task.spawn(function() while true do if getgenv().autoRob then pcall(Loop) end task.wait(0.5) end end)

-- ====== UI ====== local screenGui = Instance.new("ScreenGui") screenGui.Name = "OxtopusHub_Autosteal_GUI" screenGui.ResetOnSpawn = false screenGui.IgnoreGuiInset = true screenGui.Parent = clientPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame") mainFrame.Size = UDim2.new(0, 320, 0, 120) mainFrame.Position = UDim2.new(0.5, -160, 0.25, 0) mainFrame.AnchorPoint = Vector2.new(0.5, 0) mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) mainFrame.Parent = screenGui

local uicorner = Instance.new("UICorner") uicorner.CornerRadius = UDim.new(0, 12) uicorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke") uiStroke.Thickness = 1 uiStroke.Transparency = 0.75 uiStroke.Parent = mainFrame

local title = Instance.new("TextLabel") title.Size = UDim2.new(1, -16, 0, 30) title.Position = UDim2.new(0, 8, 0, 8) title.BackgroundTransparency = 1 title.Text = "Oxtopus Hub Autosteal v0.01" title.TextColor3 = Color3.fromRGB(255,255,255) title.Font = Enum.Font.GothamSemibold title.TextSize = 16 title.TextXAlignment = Enum.TextXAlignment.Left title.Parent = mainFrame

local statusLabel = Instance.new("TextLabel") statusLabel.Size = UDim2.new(1, -16, 0, 20) statusLabel.Position = UDim2.new(0, 8, 0, 36) statusLabel.BackgroundTransparency = 1 statusLabel.Text = "Status: " .. (getgenv().autoRob and "Enabled" or "Disabled") statusLabel.TextColor3 = Color3.fromRGB(200,200,200) statusLabel.Font = Enum.Font.Gotham statusLabel.TextSize = 13 statusLabel.TextXAlignment = Enum.TextXAlignment.Left statusLabel.Parent = mainFrame

local toggleBtn = Instance.new("TextButton") toggleBtn.Size = UDim2.new(0, 120, 0, 36) toggleBtn.Position = UDim2.new(1, -136, 1, -48) toggleBtn.AnchorPoint = Vector2.new(1, 1) toggleBtn.BackgroundColor3 = getgenv().autoRob and Color3.fromRGB(90,160,90) or Color3.fromRGB(160,80,80) toggleBtn.Text = getgenv().autoRob and "Disable" or "Enable" toggleBtn.Font = Enum.Font.GothamBold toggleBtn.TextSize = 14 toggleBtn.TextColor3 = Color3.fromRGB(255,255,255) toggleBtn.Parent = mainFrame

local toggleCorner = Instance.new("UICorner") toggleCorner.CornerRadius = UDim.new(0, 8) toggleCorner.Parent = toggleBtn

local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) local function updateUI() TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = getgenv().autoRob and Color3.fromRGB(90,160,90) or Color3.fromRGB(160,80,80)}):Play() toggleBtn.Text = getgenv().autoRob and "Disable" or "Enable" statusLabel.Text = "Status: " .. (getgenv().autoRob and "Enabled" or "Disabled") end

toggleBtn.MouseButton1Click:Connect(function() getgenv().autoRob = not getgenv().autoRob updateUI() end)

local closeBtn = Instance.new('TextButton') closeBtn.Size = UDim2.new(0, 24, 0, 24) closeBtn.Position = UDim2.new(1, -28, 0, 8) closeBtn.AnchorPoint = Vector2.new(1, 0) closeBtn.Text = "X" closeBtn.Font = Enum.Font.GothamBold closeBtn.TextSize = 14 closeBtn.TextColor3 = Color3.fromRGB(255,255,255) closeBtn.BackgroundTransparency = 0.4 closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,50) closeBtn.Parent = mainFrame local closeCorner = Instance.new('UICorner') closeCorner.CornerRadius = UDim.new(0,6) closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Dragging local dragging = false local dragInput, dragStart, startPos

local function updateDrag(input) local delta = input.Position - dragStart local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) mainFrame.Position = newPos end

mainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = mainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)

mainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)

UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then updateDrag(input) end end)

-- Keybind toggle (M) UserInputService.InputBegan:Connect(function(input, gpe) if gpe then return end if input.KeyCode == Enum.KeyCode.M then getgenv().autoRob = not getgenv().autoRob updateUI() end end)

print("[Oxtopus Hub] GUI loaded. Press toggle or M to enable/disable autosteal.")

