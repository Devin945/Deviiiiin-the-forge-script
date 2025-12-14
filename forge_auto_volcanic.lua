-- Generic Configurable Target Finder GUI
-- Not game-specific | For learning & allowed use

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- SETTINGS
local ACTIVE = false
local TARGET_NAME = ""
local SCAN_RADIUS = 25
local OFFSET_UNDER = 3

--------------------------------------------------
-- GUI CREATION
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "TargetFinderGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 170)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Target Finder (Generic)"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 0, 30)
input.Position = UDim2.new(0, 10, 0, 40)
input.PlaceholderText = "Type part name (example: rock)"
input.Text = ""
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.TextColor3 = Color3.new(1, 1, 1)
input.Font = Enum.Font.SourceSans
input.TextSize = 14
input.ClearTextOnFocus = false
input.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 80)
button.Text = "Activate"
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 16
button.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 0, 130)
status.Text = "Status: Inactive"
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.BackgroundTransparency = 1
status.Font = Enum.Font.SourceSans
status.TextSize = 14
status.Parent = frame

--------------------------------------------------
-- HELPER FUNCTIONS
--------------------------------------------------

local function getHRP()
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

-- Finds nearest BasePart whose name contains TARGET_NAME
local function findNearestTarget()
    if TARGET_NAME == "" then return nil end
    local hrp = getHRP()
    if not hrp then return nil end

    local closest, bestDist = nil, SCAN_RADIUS

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(TARGET_NAME:lower()) then
            local dist = (hrp.Position - obj.Position).Magnitude
            if dist < bestDist then
                bestDist = dist
                closest = obj
            end
        end
    end

    return closest
end

--------------------------------------------------
-- MAIN LOOP
--------------------------------------------------

RunService.Heartbeat:Connect(function()
    if not ACTIVE then return end

    local hrp = getHRP()
    local target = findNearestTarget()

    if hrp and target then
        hrp.CFrame =
            target.CFrame
            * CFrame.new(0, -(target.Size.Y / 2 + OFFSET_UNDER), 0)
    end
end)

--------------------------------------------------
-- GUI LOGIC
--------------------------------------------------

button.MouseButton1Click:Connect(function()
    ACTIVE = not ACTIVE
    TARGET_NAME = input.Text

    button.Text = ACTIVE and "Deactivate" or "Activate"
    status.Text = ACTIVE and ("Status: Active (Looking for \"" .. TARGET_NAME .. "\")")
                          or "Status: Inactive"
end)
