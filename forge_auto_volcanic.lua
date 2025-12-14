-- Generic Configurable Target Finder (Fixed & Reliable)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

--------------------------------------------------
-- SAFE CHARACTER HANDLING
--------------------------------------------------

local function getCharacter()
    if player.Character then return player.Character end
    return player.CharacterAdded:Wait()
end

local function getHRP()
    local char = getCharacter()
    return char:WaitForChild("HumanoidRootPart", 5)
end

--------------------------------------------------
-- STATE
--------------------------------------------------

local ACTIVE = false
local TARGET_NAME = ""
local SCAN_RADIUS = 30
local OFFSET_UNDER = 3

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "TargetFinderGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 170)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Target Finder (Generic)"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(1, -20, 0, 30)
input.Position = UDim2.new(0, 10, 0, 40)
input.PlaceholderText = "example: rock"
input.Text = ""
input.ClearTextOnFocus = false
input.BackgroundColor3 = Color3.fromRGB(55,55,55)
input.TextColor3 = Color3.new(1,1,1)
input.TextSize = 14

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 80)
button.Text = "Activate"
button.BackgroundColor3 = Color3.fromRGB(70,70,70)
button.TextColor3 = Color3.new(1,1,1)
button.TextSize = 16
button.Font = Enum.Font.SourceSansBold

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 0, 130)
status.Text = "Status: Inactive"
status.TextColor3 = Color3.fromRGB(200,200,200)
status.BackgroundTransparency = 1
status.TextSize = 14

--------------------------------------------------
-- TARGET SEARCH
--------------------------------------------------

local function findNearestTarget()
    if TARGET_NAME == "" then
        status.Text = "Status: No target name"
        return nil
    end

    local hrp = getHRP()
    if not hrp then return nil end

    local closest, bestDist = nil, SCAN_RADIUS

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if string.find(obj.Name:lower(), TARGET_NAME:lower()) then
                local dist = (hrp.Position - obj.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    closest = obj
                end
            end
        end
    end

    if not closest then
        status.Text = 'Status: No "' .. TARGET_NAME .. '" found'
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
        status.Text = 'Status: Targeting "' .. target.Name .. '"'
        hrp.CFrame =
            target.CFrame
            * CFrame.new(0, -(target.Size.Y / 2 + OFFSET_UNDER), 0)
    end
end)

--------------------------------------------------
-- BUTTON
--------------------------------------------------

button.MouseButton1Click:Connect(function()
    ACTIVE = not ACTIVE
    TARGET_NAME = input.Text

    button.Text = ACTIVE and "Deactivate" or "Activate"
    status.Text = ACTIVE and "Status: Searching..." or "Status: Inactive"
end)
