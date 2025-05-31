-- LocalScript

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DonutHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 160)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Smooth corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "Donut Hub"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Button
local ArsenalButton = Instance.new("TextButton")
ArsenalButton.Size = UDim2.new(0.8, 0, 0, 35)
ArsenalButton.Position = UDim2.new(0.1, 0, 0, 60)
ArsenalButton.Text = "Load Arsenal Script"
ArsenalButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
ArsenalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ArsenalButton.Font = Enum.Font.Gotham
ArsenalButton.TextSize = 16
ArsenalButton.BorderSizePixel = 0
ArsenalButton.AutoButtonColor = true
ArsenalButton.Parent = MainFrame

-- Smooth button corners
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ArsenalButton

-- Hover effect
ArsenalButton.MouseEnter:Connect(function()
	ArsenalButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
end)
ArsenalButton.MouseLeave:Connect(function()
	ArsenalButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
end)

-- Load script from GitHub repo
ArsenalButton.MouseButton1Click:Connect(function()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/hotsauceandqueso/donuthub/refs/heads/main/arsenal.lua"))()
	end)
end)

-- Optional: Tween intro animation
MainFrame.Position = UDim2.new(0.35, 0, -1, 0)
MainFrame:TweenPosition(UDim2.new(0.35, 0, 0.3, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.4, true)
