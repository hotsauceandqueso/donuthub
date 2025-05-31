-- SETTINGS
local FOV_RADIUS = 100
local ESP_ENABLED = false

-- SERVICES
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local playerGui = player:WaitForChild("PlayerGui")

-- GUI SETUP
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "CustomVerticalGui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0.18, 0, 0.4, 0)
frame.Position = UDim2.new(0.7, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)

local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
local topCorner = Instance.new("UICorner", topBar)
topCorner.CornerRadius = UDim.new(0, 12)

local closeButton = Instance.new("TextButton", topBar)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0, 5, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18

local titleLabel = Instance.new("TextLabel", topBar)
titleLabel.Size = UDim2.new(0, 120, 0, 30)
titleLabel.Position = UDim2.new(1, -125, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Donut Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Right
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18

closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- TOGGLE BUTTONS
local aimbotEnabled = false
local aiming = false

local aimbotToggle = Instance.new("TextButton", frame)
aimbotToggle.Text = "Aimbot: OFF"
aimbotToggle.Size = UDim2.new(0.8, 0, 0, 40)
aimbotToggle.Position = UDim2.new(0.1, 0, 0.3, 0)
aimbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotToggle.Font = Enum.Font.SourceSansBold
aimbotToggle.TextSize = 18

aimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotToggle.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    aimbotToggle.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
end)

local espToggle = Instance.new("TextButton", frame)
espToggle.Text = "ESP: OFF"
espToggle.Size = UDim2.new(0.8, 0, 0, 40)
espToggle.Position = UDim2.new(0.1, 0, 0.5, 0)
espToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.Font = Enum.Font.SourceSansBold
espToggle.TextSize = 18

espToggle.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    espToggle.Text = ESP_ENABLED and "ESP: ON" or "ESP: OFF"
    espToggle.BackgroundColor3 = ESP_ENABLED and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
end)

-- AIMBOT
userInput.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = true
    end
end)

userInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = false
    end
end)

-- DRAW FOV
local circle = Drawing.new("Circle")
circle.Radius = FOV_RADIUS
circle.Thickness = 2
circle.Transparency = 0.5
circle.Color = Color3.fromRGB(0, 255, 140)
circle.Filled = false
circle.Visible = false

-- UTILS
local function getClosestPlayerInFOV()
    local closest, shortest = nil, FOV_RADIUS

    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Team ~= player.Team then
            local char = plr.Character
            if char and char:FindFirstChild("Head") then
                local headPos, onScreen = camera:WorldToViewportPoint(char.Head.Position)
                local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                if onScreen then
                    local dist = (Vector2.new(headPos.X, headPos.Y) - center).Magnitude
                    if dist < shortest then
                        closest = char
                        shortest = dist
                    end
                end
            end
        end
    end

    return closest
end

local espBoxes = {}

local function updateESP()
    for _, box in pairs(espBoxes) do box:Remove() end
    espBoxes = {}

    if not ESP_ENABLED then return end

    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Team ~= player.Team then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                if onScreen then
                    local box = Drawing.new("Square")
                    box.Size = Vector2.new(50, 50)
                    box.Position = Vector2.new(pos.X - 25, pos.Y - 50)
                    box.Thickness = 1
                    box.Color = Color3.fromRGB(255, 0, 0)
                    box.Transparency = 0.6
                    box.Visible = true
                    table.insert(espBoxes, box)
                end
            end
        end
    end
end

-- MAIN LOOP
runService.RenderStepped:Connect(function()
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    circle.Position = center
    circle.Visible = aimbotEnabled -- Only show circle if aimbot is enabled

    updateESP()

    if aimbotEnabled and aiming then
        local target = getClosestPlayerInFOV()
        if target and target:FindFirstChild("Head") then
            local dir = (target.Head.Position - camera.CFrame.Position).Unit
            camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + dir)
        end
    end
end)

