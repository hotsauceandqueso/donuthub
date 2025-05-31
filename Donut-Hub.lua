local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomVerticalGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0.18, 0, 0.4, 0)
frame.Position = UDim2.new(0.7, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
topBar.BorderSizePixel = 0
topBar.Parent = frame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0, 5, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.BorderSizePixel = 0
closeButton.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 120, 0, 30)
titleLabel.Position = UDim2.new(1, -125, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Donut Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Right
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Parent = topBar

closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
end)














local silentAimEnabled = false

local silentAimButton = Instance.new("TextButton")
silentAimButton.Name = "SilentAimButton"
silentAimButton.Size = UDim2.new(0.8, 0, 0, 30)
silentAimButton.Position = UDim2.new(0.1, 0, 0.15, 0)
silentAimButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
silentAimButton.Text = "Silent Aim: OFF"
silentAimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
silentAimButton.Font = Enum.Font.SourceSansBold
silentAimButton.TextSize = 16
silentAimButton.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = silentAimButton

silentAimButton.MouseButton1Click:Connect(function()
    silentAimEnabled = not silentAimEnabled
    silentAimButton.Text = "Silent Aim: " .. (silentAimEnabled and "ON" or "OFF")
    silentAimButton.BackgroundColor3 = silentAimEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
end)













local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local function getClosestPlayer()
    local maxDistance = 500
    local closest = nil
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pos = v.Character.HumanoidRootPart.Position
            local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(pos)
            local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
            
            if distance < maxDistance then
                maxDistance = distance
                closest = v
            end
        end
    end
    return closest
end

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if silentAimEnabled and method == "FireServer" and tostring(self) == "RemoteEvent" then
        local closest = getClosestPlayer()
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            args[1] = closest.Character.Head.Position
        end
    end
    
    return oldNamecall(self, unpack(args))
end)

setreadonly(mt, 
