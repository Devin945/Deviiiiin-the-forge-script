-- Generic Part Selector GUI (Learning Tool)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

--------------------------------------------------
-- STATE
--------------------------------------------------

local ACTIVE = false
local SELECTED_NAME = nil
local FOLLOW = false

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "PartSelectorGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 170)
frame.Position = UDim2.new(0.5, -140, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Title bar
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 32)
title.Position = UDim2.new(0, 12, 0, 6)
title.Text = "Part Selector"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Left

-- Close button
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -32, 0, 8)
close.Text = "✕"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.fromRGB(255,255,255)
close.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

-- Info label
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -24, 0, 40)
info.Position = UDim2.new(0, 12, 0, 40)
info.Text = "Click a part to select it"
info.TextWrapped = true
info.TextColor3 = Color3.fromRGB(200,200,200)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.TextSize = 13

-- Toggle button
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -24, 0, 36)
toggle.Position = UDim2.new(0, 12, 0, 90)
toggle.Text = "Activate"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

-- Status
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -24, 0, 24)
status.Position = UDim2.new(0, 12, 0, 132)
status.Text = "Status: Idle"
status.TextColor3 = Color3.fromRGB(170,170,170)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 12

--------------------------------------------------
-- LOGIC
--------------------------------------------------

-- Close GUI
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Click to select part
mouse.Button1Down:Connect(function()
    if not ACTIVE then return end

    local target = mouse.Target
    if target and target:IsA("BasePart") then
        SELECTED_NAME = target.Name
        status.Text = 'Selected: "' .. SELECTED_NAME .. '"'
    end
end)

-- Toggle
toggle.MouseButton1Click:Connect(function()
    ACTIVE = not ACTIVE
    toggle.Text = ACTIVE and "Deactivate" or "Activate"
    status.Text = ACTIVE and "Click a part to select" or "Status: Idle"
end)
