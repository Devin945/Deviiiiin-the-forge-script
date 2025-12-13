-- Auto Volcanic Ore Under-Miner (Solora Compatible)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local SCAN_RADIUS = 18
local UNDER_OFFSET = 3
local ACTIVE = true

local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
    local char = getChar()
    return char:FindFirstChild("HumanoidRootPart")
end

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
