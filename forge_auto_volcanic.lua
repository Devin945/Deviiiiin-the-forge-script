print("SCRIPT STARTED")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Wait for character & HRP
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
print("Character loaded:", char.Name)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "VisibleDebugGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 180)
frame.Position = UDim2.new(0.5, -175, 0.4, -90)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
frame.Draggable = true

-- Corner
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 10)
title.Text = "Debug GUI"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- Status box (acts as console)
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 120)
status.Position = UDim2.new(0, 10, 0, 50)
status.Text = "Status messages will appear here..."
status.TextWrapped = true
status.TextYAlignment = Enum.TextYAlignment.Top
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(200,200,200)
status.BackgroundColor3 = Color3.fromRGB(55,55,55)
status.BackgroundTransparency = 0
status.RichText = true

-- Function to append messages
local function log(msg)
    print(msg)  -- also print to real console
    status.Text = status.Text .. "\n" .. msg
end

log("GUI created successfully!")

-- Example main loop
local ACTIVE = true
local TARGET_NAME = "Rock"

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
        log("Targeting: "..closest.Name)
    else
        log("No target found...")
    end
end)
