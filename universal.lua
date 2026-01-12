--==================================================
-- MIRRORS HUB v3.1 | CORE & BASE
-- Autor: blackzw
--==================================================

--==============================
-- 🔒 PROTEÇÃO DUPLA EXECUÇÃO
--==============================
if getgenv().MIRRORS_HUB_LOADED then
    warn("[Mirrors Hub] Script já executado.")
    return
end
getgenv().MIRRORS_HUB_LOADED = true

--==============================
-- 🔧 SERVIÇOS
--==============================
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    Workspace = game:GetService("Workspace"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    StarterGui = game:GetService("StarterGui"),
    MarketplaceService = game:GetService("MarketplaceService")
}

local LocalPlayer = Services.Players.LocalPlayer
local Camera = Services.Workspace.CurrentCamera

--==============================
-- 🧠 CONFIG GLOBAL
--==============================
getgenv().MirrorsHub = {
    Version = "3.1",
    Author = "blackzw",
    LoadedAt = os.time()
}

local Config = {
    Player = {
        Speed = 16,
        Jump = 50,
        InfiniteJump = false
    },
    Aimbot = { Enabled = false },
    ESP = {
        Enabled = false,
        BoxScale = 1,
        Thickness = 2,
        Color = Color3.fromRGB(0,255,0),
        Tracer = false
    },
    Fling = {
        Touch = false,
        Manual = false,
        Auto = false
    }
}

--==============================
-- 🔔 NOTIFICAÇÃO INICIAL
--==============================
pcall(function()
    Services.StarterGui:SetCore("SendNotification", {
        Title = "Mirrors Hub v3.1",
        Text = "Carregando interface...",
        Duration = 5,
        Icon = "rbxassetid://77513496492572"
    })
end)

--==============================
-- 🌐 LOAD WINDUI
--==============================
local Interface = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--==============================
-- 🪟 JANELA PRINCIPAL
--==============================
local Window = Interface:CreateWindow({
    Title = "Mirrors Hub",
    Icon = "app-window",
    Author = "by blackzw",
    Folder = "MirrorsHub"
})

local Tabs = {
    Main = Window:Tab({ Title = "Principal", Icon = "home" }),
    Player = Window:Tab({ Title = "Player", Icon = "user" }),
    Scripts = Window:Tab({ Title = "Scripts", Icon = "layers" }),
    Credits = Window:Tab({ Title = "Créditos", Icon = "info" })
}

--==============================
-- 🎮 DETECTAR JOGO
--==============================
task.spawn(function()
    local success, info = pcall(function()
        return Services.MarketplaceService:GetProductInfo(game.PlaceId)
    end)

    if success and info and info.Name then
        print("[Mirrors Hub] Jogo detectado:", info.Name)
    else
        warn("[Mirrors Hub] Não foi possível detectar o jogo.")
    end
end)

--==============================
-- 🏘️ ALTERAR NICK (BROOKHAVEN)
--==============================
pcall(function()
    local RE = Services.ReplicatedStorage:FindFirstChild("RE")
    if RE and RE:FindFirstChild("1RPNam1eTex1t") then
        RE["1RPNam1eTex1t"]:FireServer(
            "RolePlayName",
            "🤓 | MirrorsHub by Blackzw"
        )
        print("[Mirrors Hub] Nick alterado (Brookhaven)")
    end
end)

--==============================
-- 📢 NOTIFICAÇÃO FINAL DA BASE
--==============================
Interface:Notify({
    Title = "Mirrors Hub",
    Content = "Base carregada com sucesso",
    Duration = 4,
    Icon = "check"
})

print("[Mirrors Hub] CORE & BASE carregados com sucesso.")
--==================================================
-- PARTE 2 | COMBATE
-- AIMBOT + AUTOKILL
--==================================================

--==============================
-- 🎯 VARIÁVEIS AIMBOT
--==============================
local AimbotConnection = nil

-- Atualizar character
local Character = LocalPlayer.Character
local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
end)

--==============================
-- 🔍 OBTER ALVO MAIS PRÓXIMO
--==============================
local function GetClosestPlayer()
    if not HRP then return nil end

    local closest, shortest = nil, math.huge

    for _, plr in ipairs(Services.Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")

            if root and hum and hum.Health > 0 then
                local dist = (root.Position - HRP.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = root
                end
            end
        end
    end

    return closest
end

--==============================
-- 🎯 TOGGLE AIMBOT
--==============================
local function ToggleAimbot(state)
    Config.Aimbot.Enabled = state

    if state then
        if AimbotConnection then return end

        AimbotConnection = Services.RunService.RenderStepped:Connect(function()
            if not Config.Aimbot.Enabled then return end
            local target = GetClosestPlayer()
            if target then
                Camera.CFrame = CFrame.lookAt(
                    Camera.CFrame.Position,
                    target.Position
                )
            end
        end)
    else
        if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
    end
end

--==============================
-- ☠️ AUTOKILL (INTEGRAÇÃO)
--==============================
local AutoKillLoaded = false

pcall(function()
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/blackzww/auto-kill/refs/heads/main/autokill.lua"
    ))()
    AutoKillLoaded = true
    print("[Mirrors Hub] AutoKill carregado")
end)

local function ToggleAutoKill(state)
    if not AutoKillLoaded or not getgenv().AutoKill then
        warn("[Mirrors Hub] AutoKill não disponível")
        return
    end

    if state then
        if getgenv().AutoKill.Start then
            getgenv().AutoKill.Start()
        end
    else
        if getgenv().AutoKill.Stop then
            getgenv().AutoKill.Stop()
        end
    end
end

--==============================
-- 🧠 UI | ABA PRINCIPAL
--==============================
Tabs.Main:Toggle({
    Title = "Aimbot",
    Desc = "Mira automaticamente no jogador mais próximo",
    Value = false,
    Callback = ToggleAimbot
})

Tabs.Main:Toggle({
    Title = "Auto Kill",
    Desc = "Sistema AutoKill integrado (Start / Stop)",
    Value = false,
    Callback = ToggleAutoKill
})

Tabs.Main:Paragraph({
    Title = "Combate",
    Desc = "Sistemas avançados de combate ativados\nUse com cuidado.",
    Color = "Red"
})

print("[Mirrors Hub] PARTE 2 carregada.")
--==================================================
-- PARTE 3 | ESP COMPLETO
--==================================================

local ESPObjects = {}

--==============================
-- 🧱 CRIAR ESP
--==============================
local function CreateESP(player)
    if player == LocalPlayer then return end

    local box = Drawing.new("Square")
    box.Filled = false
    box.Visible = false

    local name = Drawing.new("Text")
    name.Size = 14
    name.Center = true
    name.Outline = true
    name.Visible = false

    local info = Drawing.new("Text")
    info.Size = 13
    info.Center = true
    info.Outline = true
    info.Visible = false

    local tracer = Drawing.new("Line")
    tracer.Visible = false

    ESPObjects[player] = {
        Box = box,
        Name = name,
        Info = info,
        Tracer = tracer
    }
end

--==============================
-- ❌ REMOVER ESP
--==============================
local function RemoveESP(player)
    local esp = ESPObjects[player]
    if esp then
        for _, obj in pairs(esp) do
            pcall(function() obj:Remove() end)
        end
        ESPObjects[player] = nil
    end
end

--==============================
-- 👥 PLAYERS
--==============================
for _, plr in ipairs(Services.Players:GetPlayers()) do
    CreateESP(plr)
end

Services.Players.PlayerAdded:Connect(CreateESP)
Services.Players.PlayerRemoving:Connect(RemoveESP)

--==============================
-- 🎥 ATUALIZAR ESP
--==============================
Services.RunService.RenderStepped:Connect(function()
    for plr, esp in pairs(ESPObjects) do
        if not Config.ESP.Enabled then
            for _, obj in pairs(esp) do
                obj.Visible = false
            end
            continue
        end

        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if root and hum and hum.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local distance = (Camera.CFrame.Position - root.Position).Magnitude
                local size = Vector2.new(40, 60) * Config.ESP.BoxScale

                -- BOX
                esp.Box.Size = size
                esp.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
                esp.Box.Color = Config.ESP.Color
                esp.Box.Thickness = Config.ESP.Thickness
                esp.Box.Visible = true

                -- NAME
                esp.Name.Text = plr.Name
                esp.Name.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 16)
                esp.Name.Color = Config.ESP.Color
                esp.Name.Visible = true

                -- INFO
                esp.Info.Text = math.floor(hum.Health).." HP | "..math.floor(distance).."m"
                esp.Info.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 2)
                esp.Info.Color = Config.ESP.Color
                esp.Info.Visible = true

                -- TRACER
                if Config.ESP.Tracer and HRP then
                    local myPos, myScreen = Camera:WorldToViewportPoint(HRP.Position)
                    if myScreen then
                        esp.Tracer.From = Vector2.new(myPos.X, myPos.Y)
                        esp.Tracer.To = Vector2.new(pos.X, pos.Y + size.Y/2)
                        esp.Tracer.Color = Config.ESP.Color
                        esp.Tracer.Thickness = Config.ESP.Thickness
                        esp.Tracer.Visible = true
                    else
                        esp.Tracer.Visible = false
                    end
                else
                    esp.Tracer.Visible = false
                end
            else
                for _, obj in pairs(esp) do
                    obj.Visible = false
                end
            end
        else
            for _, obj in pairs(esp) do
                obj.Visible = false
            end
        end
    end
end)

--==============================
-- 🧠 UI | ABA PLAYER (ESP)
--==============================
Tabs.Player:Paragraph({
    Title = "ESP Visual",
    Desc = "ESP completo: Caixa, Nome, Vida, Distância e Linha",
    Color = "Green"
})

Tabs.Player:Toggle({
    Title = "Ativar ESP",
    Value = false,
    Callback = function(v)
        Config.ESP.Enabled = v
    end
})

Tabs.Player:Toggle({
    Title = "Linha (Tracer)",
    Value = false,
    Callback = function(v)
        Config.ESP.Tracer = v
    end
})

Tabs.Player:Slider({
    Title = "Tamanho da Caixa",
    Step = 0.1,
    Value = { Min = 0.6, Max = 3, Default = 1 },
    Callback = function(v)
        Config.ESP.BoxScale = v
    end
})

Tabs.Player:Slider({
    Title = "Espessura",
    Step = 1,
    Value = { Min = 1, Max = 6, Default = 2 },
    Callback = function(v)
        Config.ESP.Thickness = v
    end
})

Tabs.Player:Colorpicker({
    Title = "Cor do ESP",
    Default = Color3.fromRGB(0,255,0),
    Callback = function(c)
        Config.ESP.Color = c
    end
})

print("[Mirrors Hub] PARTE 3 (ESP) carregada.")
--==================================================
-- PARTE 4 | PLAYER
--==================================================

--==============================
-- 🧍‍♂️ ATUALIZAR HUMANOID
--==============================
local function ApplyHumanoidSettings(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end

    hum.WalkSpeed = Config.Player.Speed
    hum.JumpPower = Config.Player.Jump
end

if LocalPlayer.Character then
    ApplyHumanoidSettings(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(ApplyHumanoidSettings)

--==============================
-- 🕴️ INFINITE JUMP
--==============================
Services.UserInputService = game:GetService("UserInputService")

Services.UserInputService.JumpRequest:Connect(function()
    if Config.Player.InfiniteJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--==============================
-- 💥 FLING CORE
--==============================
local FlingThread
local AutoFlingThread

-- Prevenção duplicada
if not Services.ReplicatedStorage:FindFirstChild("mirrors_fling_flag") then
    local flag = Instance.new("BoolValue")
    flag.Name = "mirrors_fling_flag"
    flag.Parent = Services.ReplicatedStorage
end

--==============================
-- 🔄 FLING LOOP
--==============================
local function StartFling()
    if FlingThread then return end
    Config.Fling.Manual = true

    FlingThread = task.spawn(function()
        while Config.Fling.Manual do
            Services.RunService.Heartbeat:Wait()

            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.Velocity
                hrp.Velocity = vel * 9999 + Vector3.new(0, 9999, 0)
                task.wait()
                if hrp then
                    hrp.Velocity = vel
                end
            end
        end
        FlingThread = nil
    end)
end

local function StopFling()
    Config.Fling.Manual = false
end

--==============================
-- 🤝 TOUCH FLING
--==============================
local TouchConnections = {}

local function EnableTouchFling()
    Config.Fling.Touch = true

    for _, plr in ipairs(Services.Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and not TouchConnections[plr] then
                TouchConnections[plr] = hrp.Touched:Connect(function(hit)
                    if Config.Fling.Touch then
                        StartFling()
                        task.delay(0.15, StopFling)
                    end
                end)
            end
        end
    end
end

local function DisableTouchFling()
    Config.Fling.Touch = false
    for _, con in pairs(TouchConnections) do
        con:Disconnect()
    end
    TouchConnections = {}
end

--==============================
-- 🤖 AUTO FLING
--==============================
local function GetTargets()
    local t = {}
    for _, plr in ipairs(Services.Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(t, plr)
        end
    end
    return t
end

local function AttachToTarget(plr)
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not (myHRP and targetHRP) then return false end

    myHRP.CFrame = targetHRP.CFrame
    myHRP.Velocity = Vector3.zero
    myHRP.RotVelocity = Vector3.zero
    return true
end

local function StartAutoFling()
    if AutoFlingThread then return end
    Config.Fling.Auto = true
    StartFling()

    AutoFlingThread = task.spawn(function()
        while Config.Fling.Auto do
            for _, target in ipairs(GetTargets()) do
                if not Config.Fling.Auto then break end
                if AttachToTarget(target) then
                    task.wait(0.15)
                end
            end
            task.wait(0.2)
        end
        AutoFlingThread = nil
    end)
end

local function StopAutoFling()
    Config.Fling.Auto = false
    StopFling()
end

--==============================
-- 🧠 UI | ABA PLAYER
--==============================
Tabs.Player:Toggle({
    Title = "Pulo Infinito",
    Value = false,
    Callback = function(v)
        Config.Player.InfiniteJump = v
    end
})

Tabs.Player:Toggle({
    Title = "Touch Fling",
    Value = false,
    Callback = function(v)
        if v then
            EnableTouchFling()
        else
            DisableTouchFling()
        end
    end
})

Tabs.Player:Toggle({
    Title = "Fling Manual",
    Value = false,
    Callback = function(v)
        if v then
            StartFling()
        else
            StopFling()
        end
    end
})

Tabs.Player:Toggle({
    Title = "Auto Fling",
    Value = false,
    Callback = function(v)
        if v then
            StartAutoFling()
        else
            StopAutoFling()
        end
    end
})

print("[Mirrors Hub] PARTE 4 (PLAYER) carregada.")
--==================================================
-- PARTE 5 | MOVIMENTO & PLAYER
--==================================================

--==============================
-- 🔧 VARIÁVEIS
--==============================
local Move = {
    Superman = false,
    Fly = false,
    Noclip = false,
    AntiHit = false
}

local Humanoid, HRP
local FlyBV, FlyBG
local FlyConn, NoclipConn, AntiHitConn

local DEFAULT_WALK = 16
local DEFAULT_JUMP = 50

local SUPER_WALK = 80
local SUPER_JUMP = 120

local UIS = Services.UserInputService

-- Atualiza refs
local function UpdateChar(char)
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")

    -- reset padrões
    Humanoid.WalkSpeed = DEFAULT_WALK
    Humanoid.JumpPower = DEFAULT_JUMP
end

if LocalPlayer.Character then
    UpdateChar(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(UpdateChar)

--==============================
-- 🦸‍♂️ SUPERMAN
--==============================
local function ToggleSuperman(state)
    Move.Superman = state
    if not Humanoid then return end

    if state then
        Humanoid.WalkSpeed = SUPER_WALK
        Humanoid.JumpPower = SUPER_JUMP
    else
        Humanoid.WalkSpeed = DEFAULT_WALK
        Humanoid.JumpPower = DEFAULT_JUMP
    end
end

--==============================
-- ✈️ FLY (MOBILE FRIENDLY)
--==============================
local function StartFly()
    if not HRP or FlyBV then return end

    FlyBV = Instance.new("BodyVelocity")
    FlyBV.Velocity = Vector3.zero
    FlyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    FlyBV.Parent = HRP

    FlyBG = Instance.new("BodyGyro")
    FlyBG.CFrame = HRP.CFrame
    FlyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    FlyBG.P = 9e4
    FlyBG.Parent = HRP

    FlyConn = Services.RunService.RenderStepped:Connect(function()
        if not Move.Fly or not HRP then return end
        FlyBG.CFrame = Camera.CFrame

        if UIS:IsKeyDown(Enum.KeyCode.W) then
    dir = dir + Camera.CFrame.LookVector
end

if UIS:IsKeyDown(Enum.KeyCode.S) then
    dir = dir - Camera.CFrame.LookVector
end

if UIS:IsKeyDown(Enum.KeyCode.A) then
    dir = dir - Camera.CFrame.RightVector
end

if UIS:IsKeyDown(Enum.KeyCode.D) then
    dir = dir + Camera.CFrame.RightVector
end

if UIS:IsKeyDown(Enum.KeyCode.Space) then
    dir = dir + Vector3.new(0,1,0)
end

if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
    dir = dir - Vector3.new(0,1,0)
end
        FlyBV.Velocity = dir * 70
    end)
end

local function StopFly()
    if FlyConn then FlyConn:Disconnect() FlyConn = nil end
    if FlyBV then FlyBV:Destroy() FlyBV = nil end
    if FlyBG then FlyBG:Destroy() FlyBG = nil end
end

local function ToggleFly(state)
    Move.Fly = state
    if state then StartFly() else StopFly() end
end

--==============================
-- 👻 NOCLIP REAL
--==============================
local function ToggleNoclip(state)
    Move.Noclip = state

    if state then
        if NoclipConn then return end
        NoclipConn = Services.RunService.Stepped:Connect(function()
            if not Move.Noclip or not LocalPlayer.Character then return end
            for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    else
        if NoclipConn then
            NoclipConn:Disconnect()
            NoclipConn = nil
        end
    end
end

--==============================
-- 🛡️ ANTI-HIT (FANTASMA REAL)
--==============================
local function ToggleAntiHit(state)
    Move.AntiHit = state

    if state then
        if AntiHitConn then return end
        AntiHitConn = Services.RunService.Stepped:Connect(function()
            if not LocalPlayer.Character then return end
            for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                    v.Massless = true
                end
            end
        end)
    else
        if AntiHitConn then
            AntiHitConn:Disconnect()
            AntiHitConn = nil
        end
    end
end

--==============================
-- 🧠 UI | ABA PLAYER
--==============================
Tabs.Player:Toggle({
    Title = "Modo Superman",
    Desc = "Velocidade e pulo extremos",
    Value = false,
    Callback = ToggleSuperman
})

Tabs.Player:Toggle({
    Title = "Fly",
    Desc = "Voar livremente (mobile compatível)",
    Value = false,
    Callback = ToggleFly
})

Tabs.Player:Toggle({
    Title = "Noclip",
    Desc = "Atravessar paredes",
    Value = false,
    Callback = ToggleNoclip
})

Tabs.Player:Toggle({
    Title = "Anti-Hit",
    Desc = "Modo fantasma (ninguém encosta)",
    Value = false,
    Callback = ToggleAntiHit
})

Tabs.Player:Paragraph({
    Title = "Movimento",
    Desc = "Funções avançadas de player\nUse com cuidado.",
    Color = "Blue"
})

print("[Mirrors Hub] PARTE 5 carregada com sucesso.")
