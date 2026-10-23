local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local CommF = RS:WaitForChild("Remotes"):WaitForChild("CommF_")

local env = (getgenv and getgenv()) or _G
if env.FruitLoopRunning then return end   -- chặn chạy 2 lần cùng lúc
env.FruitLoopRunning = true
env.FruitLoopStop = false                  -- đặt true để dừng vòng lặp

local DELAY_BETWEEN = 0.3        -- nghỉ giữa các lần thử tên trái
local DELAY_BEFORE_RESET = 1.5   -- đợi sau khi lấy trái
local DELAY_AFTER_RESPAWN = 5    -- đợi sau khi hồi sinh trước vòng mới
local DELAY_IF_FAIL = 5          -- đợi nếu vòng đó không lấy được trái

---------------------------------------------------------------
-- MÀN HÌNH TRẮNG + CHỮ
---------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "WaitScreen"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.new(1, 1, 1)
bg.BorderSizePixel = 0
bg.Active = true
bg.Parent = gui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0, 80)
label.AnchorPoint = Vector2.new(0.5, 0.5)
label.Position = UDim2.new(0.5, 0, 0.5, 0)
label.BackgroundTransparency = 1
label.Text = "WAIT A MINUTE"
label.TextColor3 = Color3.new(0, 0, 0)
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.Parent = bg

local okParent = pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not okParent then gui.Parent = player:WaitForChild("PlayerGui") end

---------------------------------------------------------------
-- DANH SÁCH TRÁI (Mythical -> Common)
---------------------------------------------------------------
local FRUITS = {
    "Kitsune-Kitsune", "Control-Control",
    "Dragon-Dragon", "Dragon-Dragon (West)", "Dragon-Dragon (East)",
    "Tiger-Tiger", "Yeti-Yeti", "Magnet-Magnet",
    "Gas-Gas", "Spirit-Spirit", "Dough-Dough", "Shadow-Shadow", "Venom-Venom",
    "Gravity-Gravity", "Mammoth-Mammoth", "T-Rex-T-Rex", "Leopard-Leopard",
    "Quake-Quake", "Buddha-Buddha", "Love-Love", "Spider-Spider", "Sound-Sound",
    "Phoenix-Phoenix", "Portal-Portal", "Rumble-Rumble", "Pain-Pain", "Blizzard-Blizzard",
    "Light-Light", "Rubber-Rubber", "Barrier-Barrier", "Ghost-Ghost", "Magma-Magma",
    "Flame-Flame", "Falcon-Falcon", "Ice-Ice", "Sand-Sand", "Dark-Dark", "Diamond-Diamond",
    "Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Spring-Spring",
    "Bomb-Bomb", "Smoke-Smoke", "Spike-Spike",
}

---------------------------------------------------------------
-- VÒNG LẶP VĨNH VIỄN
---------------------------------------------------------------
while not env.FruitLoopStop do
    local gotFruit = false

    for _, name in ipairs(FRUITS) do
        if env.FruitLoopStop then break end
        local ok, result = pcall(function()
            return CommF:InvokeServer("LoadFruit", name)
        end)
        if ok and result then
            gotFruit = true
            print(">> Lấy được: " .. name)
            break
        end
        task.wait(DELAY_BETWEEN)
    end

    if gotFruit then
        task.wait(DELAY_BEFORE_RESET)
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
            player.CharacterAdded:Wait()       -- đợi hồi sinh
        end
        task.wait(DELAY_AFTER_RESPAWN)
    else
        task.wait(DELAY_IF_FAIL)               -- không có trái thì nghỉ rồi thử lại
    end
end

gui:Destroy()
env.FruitLoopRunning = false
