print("SCRIPT STARTING")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Wait for character & HRP
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
print("Character loaded:", char.Name)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ForgeDebugGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 140)
frame.Position = UDim2.new(0.5, -140, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Debug GUI"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -20, 0, 60)
info.Position = UDim2.new(0, 10, 0, 40)
info.Text = "Status: Waiting..."
info.TextWrapped = true
info.TextColor3 = Color3.fromRGB(200,200,200)
info.BackgroundTransparency = 1
info.Font = Enum.Font.SourceSans
info.TextSize = 14

-- Main loop
local ACTIVE = true
local TARGET_NAME = "Rock"  -- Example name

RunService.Heartbeat:Connect(function()
    if not ACTIVE then return end

    local closest, bestDist = nil, 50
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(TARGET_NAME:lower()) then
            local dist = (hrp.Position - obj.Position).Magnitude
            if dist < bestDist then
                closest = obj
                bestDist = dist
            end
        end
    end

    if closest then
        hrp.CFrame = closest.CFrame * CFrame.new(0, -(closest.Size.Y/2 + 3), 0)
        info.Text = "Targeting: "..closest.Name
        print("Target found:", closest.Name)
    else
        info.Text = "Status: No target found"
    end
end)

print("SCRIPT LOADED SUCCESSFULLY")
