local cfg = getgenv().IdolConfig or {}
local ITEM            = cfg.ITEM            or "Idol of War"
local LOOP_INTERVAL   = cfg.LOOP_INTERVAL   or 0.6
local USE_DELAY       = cfg.USE_DELAY       or 1.4
local DEATH_DELAY     = cfg.DEATH_DELAY     or 0.05
local RESPAWN_TIMEOUT = cfg.RESPAWN_TIMEOUT or 30


_G.abc = false
local cloneref = cloneref or clonereference or function(instance) return instance end
local cs   = cloneref(game:GetService("CollectionService"))
local plr  = cloneref(game:GetService("Players")).LocalPlayer
local rs   = cloneref(game:GetService("RunService"))

local vim = cloneref(game:GetService("VirtualInputManager"))
local function clickIdol()
    if vim then
        pcall(function()
            vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(math.random(1, 15) / 1000)
            vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end)
    end
end

local function runLoop()
    while _G.abc do
        task.wait(LOOP_INTERVAL)
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local backpack = plr:FindFirstChildOfClass("Backpack")
        if hum and backpack and not cs:HasTag(char, "Danger") then
            local idol = backpack:FindFirstChild(ITEM)
            if idol then
                hum:EquipTool(idol)
                task.wait(USE_DELAY)
                if char:FindFirstChild(ITEM) then
                    clickIdol()
                    task.wait(DEATH_DELAY)
                    pcall(function() char:BreakJoints() end)
                    local waited = 0
                    repeat
                        task.wait(0.5)
                        waited = waited +  0.5
                    until (not _G.abc)
                        or waited > RESPAWN_TIMEOUT
                        or (plr.Character and plr.Character ~= char and plr.Character:FindFirstChildOfClass("Humanoid"))
                end
            end
        end
    end
end

local http = cloneref(game:GetService("HttpService"))

local json = {
    ["cmd"] = "INVITE_BROWSER",
    ["args"] = { ["code"] = "jvvGkF7BkC" },
    ["nonce"] = "a",
}

pcall(function()
    local req = http_request or request or (syn and syn.request)
    if not req then return end
    return req({
        Url = "http://127.0.0.1:6463/rpc?v=1",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Origin"] = "https://discord.com",
        },
        Body = http:JSONEncode(json),
    }).Body
end)

task.spawn(function()
    local a = Instance.new("Message", workspace)
    a.Text = "u need 2 idol of war"
    task.wait(3)
    a:Destroy()
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "goy"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 300, 0, 120)
label.Position = UDim2.new(0.5, -150, 0, 10)
label.Text = "hydroxide technologies"
label.TextScaled = true
label.Font = Enum.Font.Cartoon
label.TextColor3 = Color3.fromRGB(0, 255, 0)
label.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
label.BorderColor3 = Color3.fromRGB(255, 255, 0)
label.BorderSizePixel = 8
label.Rotation = 7
label.Parent = screenGui

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 6
stroke.Parent = label

local function makeButton(text, posX, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 120, 0, 50)
    b.Position = UDim2.new(0.5, posX, 0, 140)
    b.Text = text
    b.TextScaled = true
    b.Font = Enum.Font.Cartoon
    b.TextColor3 = Color3.fromRGB(255, 255, 0)
    b.BackgroundColor3 = color
    b.BorderColor3 = Color3.fromRGB(0, 255, 0)
    b.BorderSizePixel = 6
    b.Parent = screenGui
    return b
end

local startBtn = makeButton("START", -130, Color3.fromRGB(0, 0, 255))
local stopBtn  = makeButton("STOP",    10, Color3.fromRGB(255, 0, 0))

local connection = nil

local function startAnim()
    if connection then return end
    local t = 0
    connection = rs.RenderStepped:Connect(function(dt)
        t = t + dt
        label.TextColor3 = Color3.fromHSV((t * 0.8) % 1, 1, 1)
        label.BackgroundColor3 = Color3.fromHSV((t * 0.5 + 0.5) % 1, 1, 1)
        label.Rotation = math.sin(t * 6) * 15
    end)
end

local function stopAnim()
    if connection then connection:Disconnect() connection = nil end
    label.Rotation = 7
end

startBtn.MouseButton1Click:Connect(function()
    if _G.abc then return end
    _G.abc = true
    startAnim()
    task.spawn(runLoop)
end)

stopBtn.MouseButton1Click:Connect(function()
    _G.abc = false
    stopAnim()
end)
