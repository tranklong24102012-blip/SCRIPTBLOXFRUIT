-- Auto lấy trái từ kho (ưu tiên Mythical -> Common) rồi reset (Blox Fruits)
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local CommF = RS:WaitForChild("Remotes"):WaitForChild("CommF_")

local STOP_AFTER_FIRST = true   -- true: lấy được 1 trái là dừng | false: thử hết cả danh sách
local DELAY_BETWEEN = 0.3
local DELAY_BEFORE_RESET = 1.5

local FRUITS = {
    -- MYTHICAL (thứ tự như trong shop, từ trên xuống)
    "Kitsune-Kitsune", "Control-Control",
    "Dragon-Dragon", "Dragon-Dragon (West)", "Dragon-Dragon (East)",
    "Tiger-Tiger", "Yeti-Yeti", "Magnet-Magnet",
    "Gas-Gas", "Spirit-Spirit", "Dough-Dough", "Shadow-Shadow", "Venom-Venom",
    "Gravity-Gravity", "Mammoth-Mammoth", "T-Rex-T-Rex", "Leopard-Leopard",

    -- LEGENDARY
    "Quake-Quake", "Buddha-Buddha", "Love-Love", "Spider-Spider", "Sound-Sound",
    "Phoenix-Phoenix", "Portal-Portal", "Rumble-Rumble", "Pain-Pain", "Blizzard-Blizzard",

    -- RARE
    "Light-Light", "Rubber-Rubber", "Barrier-Barrier", "Ghost-Ghost", "Magma-Magma",

    -- UNCOMMON
    "Flame-Flame", "Falcon-Falcon", "Ice-Ice", "Sand-Sand", "Dark-Dark", "Diamond-Diamond",

    -- COMMON
    "Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Spring-Spring",
    "Bomb-Bomb", "Smoke-Smoke", "Spike-Spike",
}

local gotFruit = false

for _, name in ipairs(FRUITS) do
    local ok, result = pcall(function()
        return CommF:InvokeServer("LoadFruit", name)
    end)
    print(("[%s] ok=%s | result=%s"):format(name, tostring(ok), tostring(result)))

    if ok and result then
        gotFruit = true
        print(">> Lấy được: " .. name)
        if STOP_AFTER_FIRST then break end
    end
    task.wait(DELAY_BETWEEN)
end

task.wait(DELAY_BEFORE_RESET)

if gotFruit then
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
else
    warn("Không lấy được trái nào, chưa reset. Xem console (F9).")
end
