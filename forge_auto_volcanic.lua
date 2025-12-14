print("SCRIPT STARTED")

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "TestGui"
gui.Parent = player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 300, 0, 60)
label.Position = UDim2.new(0.5, -150, 0.5, -30)
label.Text = "LOADED SUCCESSFULLY"
label.TextScaled = true
label.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
label.TextColor3 = Color3.new(1,1,1)
label.Parent = gui

print("GUI CREATED")
