print("SCRIPT STARTED")

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- CONFIGURATION
local MAX_LOG_LINES = 5
local SEARCH_RADIUS = 50 -- Check within 50 studs of the player
local TARGET_NAME = "Rock"
local ACTIVE = true

-- WAIT FOR PLAYER/CHARACTER
if not player then
    print("Error: LocalPlayer is nil. Is this running as a LocalScript?")
    return
end

local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
print("Character loaded:", char.Name)

-- === GUI SETUP ===

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

-- === LOGGING FUNCTION (FIXED) ===

-- Function to append messages and limit line count
local function log(msg)
    print(msg)  -- also print to real console
    
    local lines = string.split(status.Text, "\n")
    table.insert(lines, msg) -- Add new message
    
    -- Trim older lines if we exceed the limit
    while #lines > MAX_LOG_LINES do
        table.remove(lines, 1) -- Remove the oldest line (index 1)
    end
    
    status.Text = table.concat(lines, "\n")
end

log("GUI created successfully! Searching for: "..TARGET_NAME)
log("Search Radius: "..SEARCH_RADIUS.." studs.")


-- === MAIN LOOP (CLEANED) ===

RunService.Heartbeat:Connect(function()
    if not ACTIVE or not hrp or not hrp.Parent then return end

    local closest, bestDist = nil, SEARCH_RADIUS
    
    -- WARNING: GetDescendants on workspace is highly inefficient on large maps.
    -- Consider using CollectionService or GetPartsInRadius for performance.
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(TARGET_NAME:lower()) then
            local dist = (hrp.Position - obj.Position).Magnitude
            
            if dist < bestDist then
                closest = obj
                bestDist = dist
            end
        end
    end

    -- === TARGET ACTION/LOGGING (FIXED) ===
    
    if closest then
        -- We are now only LOGGING the target status, not breaking physics by constantly moving CFrame.
        log("Target found: "..closest.Name.." at "..math.floor(bestDist).." studs.")
        
        -- If you wanted to perform an action (e.g., teleport, attach a visual), 
        -- you would do it here, perhaps only after a specific user input.
        
    else
        log("No target found within "..SEARCH_RADIUS.." studs.")
    end
end)
