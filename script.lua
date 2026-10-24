-- Lấy trái ra -> DỪNG lấy -> reset -> hồi sinh xong -> lặp lại (Blox Fruits)
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local CommF = RS:WaitForChild("Remotes"):WaitForChild("CommF_")

local env = (getgenv and getgenv()) or _G
if env.FruitLoopRunning then return end
env.FruitLoopRunning = true
env.FruitLoopStop = false

local DELAY_BETWEEN = 0.3         -- nghỉ giữa mỗi lần thử tên trái
local DELAY_BEFORE_RESET = 1.5    -- đợi sau khi lấy trái, trước khi reset
local DELAY_AFTER_RESPAWN = 3     -- đợi sau khi hồi sinh, trước vòng mới
local DELAY_IF_FAIL = 2

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

local function takeFruit()
    for _, name in ipairs(FRUITS) do
        if env.FruitLoopStop then return false end
        local ok, result = pcall(function()
            return CommF:InvokeServer("LoadFruit", name)
        end)
        print(("[%s] ok=%s | result=%s"):format(name, tostring(ok), tostring(result)))
        if ok and result then
            print(">> Lấy ra: " .. name)
            return true
        end
        task.wait(DELAY_BETWEEN)
    end
    return false
end

local function resetChar()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        local respawned = false
        local conn = player.CharacterAdded:Connect(function() respawned = true end)
        hum.Health = 0
        local t = 0
        while not respawned and t < 10 do task.wait(0.1) t += 0.1 end
        conn:Disconnect()
    end
    task.wait(DELAY_AFTER_RESPAWN)
end

while not env.FruitLoopStop do
    if takeFruit() then
        task.wait(DELAY_BEFORE_RESET)
        resetChar()
    else
        warn("Không lấy được trái nào. Xem console (F9).")
        task.wait(DELAY_IF_FAIL)
    end
end

env.FruitLoopRunning = false
