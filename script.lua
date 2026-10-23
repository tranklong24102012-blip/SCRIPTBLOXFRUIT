local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Màn trắng + chữ "wait a minute"
local Screen = Instance.new("ScreenGui")
Screen.Name = "WaitScreen"
Screen.IgnoreGuiInset = true
Screen.Parent = CoreGui

local Frame = Instance.new("Frame", Screen)
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BorderSizePixel = 0

local Text = Instance.new("TextLabel", Frame)
Text.Size = UDim2.new(1, 0, 1, 0)
Text.BackgroundTransparency = 1
Text.Text = "wait a minute"
Text.TextColor3 = Color3.new(0, 0, 0)
Text.TextScaled = true
Text.Font = Enum.Font.GothamBold

-- Bảng điểm trái
local Rank = {
    ["Dragon"] = 100,
    ["Kitsune"] = 97,
    ["Control"] = 94,
    ["Magnet"] = 91,
    ["Tiger"] = 88,
    ["Yeti"] = 86,
    ["Gas"] = 83,
    ["Dough"] = 80,
    ["Venom"] = 77,
    ["Spirit"] = 74,
    ["T-Rex"] = 71,
    ["Mammoth"] = 68,
    ["Gravity"] = 65,
    ["Shadow"] = 62,
    ["Buddha"] = 58,
    ["Portal"] = 55,
    ["Lightning"] = 52,
    ["Blizzard"] = 49,
    ["Phoenix"] = 46,
    ["Sound"] = 43
}

local function getBestFruit()
    local best, highest = nil, -1
    local function check(container)
        if not container then return end
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:find("Fruit") or tool.Name:find("-Fruit")) then
                local name = tool.Name:gsub("-Fruit",""):gsub(" Fruit",""):gsub("Fruit",""):gsub(" ","")
                local score = Rank[name] or 1
                if score > highest then
                    highest = score
                    best = tool
                end
            end
        end
    end
    check(LocalPlayer.Backpack)
    if LocalPlayer.Character then check(LocalPlayer.Character) end
    return best
end

-- Chạy liên tục
while true do
    -- Đợi nhân vật load xong
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.CharacterAdded:Wait()
        task.wait(1)
    end

    local fruit = getBestFruit()
    if fruit then
        fruit.Parent = LocalPlayer.Character
        task.wait(0.4)
    end

    -- Reset
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
    end

    task.wait(2.5) -- đợi respawn rồi lặp lại
end
