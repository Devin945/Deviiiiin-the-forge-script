-- Auto Volcanic Ore GUI (Solora Compatible)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local SCAN_RADIUS = 18
local UNDER_OFFSET = 3
local ACTIVE = false -- starts off

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VolcanicOreGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 100)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Volcanic Ore Bot"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = mainFrame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -20, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 40)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
toggleBtn.Text = "Activate"
toggleBtn.Parent = mainFrame

-- Character helpers
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
    local char = getChar()
    return char:FindFirstChild("HumanoidRootPart")
end

-- Ore detection
local function isVolcanicOre(part)
    return part
        and part:IsA("BasePart")
        and part.Name:lower():find("volcanic")
end

local function findNearestOre()
    local hrp = getHRP()
    if not hrp then return nil end

    local closest, dist = nil, SCAN_RADIUS

    for _, v in ipairs(workspace:GetDescendants()) do
        if isVolcanicOre(v) then
            local d = (hrp.Position - v.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end

    return closest
end

-- Auto teleport loop
RunService.Heartbeat:Connect(function()
    if not ACTIVE then return end

    local hrp = getHRP()
    if not hrp then return end

    local ore = findNearestOre()
    if not ore then return end

    hrp.CFrame =
        ore.CFrame
        * CFrame.new(0, -(ore.Size.Y / 2 + UNDER_OFFSET), 0)
end)

-- Toggle button logic
toggleBtn.MouseButton1Click:Connect(function()
    ACTIVE = not ACTIVE
    toggleBtn.Text = ACTIVE and "Deactivate" or "Activate"
end)
