local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Config inicial
WindUI:SetFont("rbxassetid://12187370747")
WindUI:SetTheme("Dark")

local Window = WindUI:CreateWindow({
    Title = "Blackzw | Universal",
    Icon = "zap",
    Author = "by blackzw",
    Folder = "BlackzwHub",
    Size = UDim2.fromOffset(600, 500),
    CornerRadius = UDim.new(0, 15),
    TopbarColor = Color3.fromRGB(15, 15, 15),
    TitleColor = Color3.fromRGB(220, 20, 60),
})

-- Botão de abrir
Window:EditOpenButton({
    Title = "Open Universal UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 12),
    StrokeThickness = 1,
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromHex("#DC143C")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#8B0000"))
    },
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

-- Desabilita botões do topo
Window:DisableTopbarButtons({ "Fullscreen" })

-- Tabs
local Tab1 = Window:Tab({ Title = "Aimbot", Icon = "crosshair" })
local Tab2 = Window:Tab({ Title = "AutoKill", Icon = "sword" })
local Tab3 = Window:Tab({ Title = "AutoNaoSei", Icon = "bird" })
local Tab4 = Window:Tab({ Title = "AindaNaoSe", Icon = "gauge" })
local Tab5 = Window:Tab({ Title = "Misc", Icon = "layers" })
local Tab6 = Window:Tab({ Title = "Settings", Icon = "settings" })

-- CARREGA O AIMBOT UMA VEZ
local aimbot = (function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local aimbotEnabled = false
    local conn = nil

    local DIST_LIMIT = 100

    local function getClosest()
        local minDist = DIST_LIMIT
        local closestChar = nil
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local dist = (myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closestChar = p.Character
                end
            end
        end
        return closestChar
    end

    local function lockCamera()
        local myChar = LocalPlayer.Character
        local myHead = myChar and myChar:FindFirstChild("Head")
        local closest = getClosest()
        if closest and myHead then
            local targetPos = closest.HumanoidRootPart.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        end
    end

    local function toggleAimbot(state)
        aimbotEnabled = state
        
        if aimbotEnabled then
            if not conn then
                conn = RunService.RenderStepped:Connect(lockCamera)
                print("Aimbot: ON")
            end
        else
            if conn then 
                conn:Disconnect() 
                conn = nil
                print("Aimbot: OFF")
            end
        end
    end

    return {
        toggle = toggleAimbot,
        isEnabled = function() return aimbotEnabled end
    }
end)()

-- CARREGA O AUTO KILL CORRIGIDO
local autoKill = (function()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local player = Players.LocalPlayer

    -- Variáveis de controle
    local autoKillEnabled = false
    local targetPlayer = nil
    local connection = nil
    local autoClickEnabled = true
    local aggressiveMode = true
    local lastSlotChange = 0
    local slotCooldown = 1.5
    local currentSlot = 1
    local lastTeleport = 0
    local teleportCooldown = 0.1

    -- Aguardar o player carregar
    local function waitForCharacter()
        repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    end

    -- Reconectar quando o personagem morrer
    player.CharacterAdded:Connect(function(character)
        waitForCharacter()
        if autoKillEnabled then
            print("Auto Kill: Reconectado após morte")
        end
    end)

    waitForCharacter()

    local mouse = player:GetMouse()

    -- Encontrar player mais próximo
    local function findNearestPlayer()
        local nearest, shortest = nil, math.huge
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return nil, math.huge end

        for _, other in ipairs(Players:GetPlayers()) do
            if other ~= player and other.Character then
                local oRoot = other.Character:FindFirstChild("HumanoidRootPart")
                local hum = other.Character:FindFirstChildOfClass("Humanoid")
                if oRoot and hum and hum.Health > 0 then
                    local dist = (root.Position - oRoot.Position).Magnitude
                    if dist < shortest and dist < 200 then
                        shortest = dist
                        nearest = other
                    end
                end
            end
        end
        return nearest, shortest
    end

    -- Clique rápido
    local function ultraRapidClick()
        if not autoClickEnabled then return end
        for i = 1, 5 do
            VirtualInputManager:SendMouseButtonEvent(mouse.X, mouse.Y, 0, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(mouse.X, mouse.Y, 0, false, game, 0)
            task.wait(0.01)
        end
    end

    -- Teleporte rápido
    local function ultraFastTeleportToTarget()
        if not targetPlayer or not targetPlayer.Character then return end
        local tRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local pRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not tRoot or not pRoot then return end
        
        local currentTime = tick()
        if currentTime - lastTeleport < teleportCooldown then return end
        lastTeleport = currentTime
        
        local dir = (tRoot.Position - pRoot.Position).Unit
        local distance = (tRoot.Position - pRoot.Position).Magnitude
        
        local targetDistance = 3
        if distance > targetDistance + 1 or distance < targetDistance - 1 then
            local pos = tRoot.Position - dir * targetDistance
            pRoot.CFrame = CFrame.new(pos, tRoot.Position)
        end
        
        return distance
    end

    -- Sequência de ataques
    local function ultraFastAttackSequence()
        local attackKeys = {
            Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, 
            Enum.KeyCode.V, Enum.KeyCode.E, Enum.KeyCode.B,
            Enum.KeyCode.Q, Enum.KeyCode.R, Enum.KeyCode.T
        }
        
        -- Ataque com tecla J
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.J, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.J, false, game)
        
        -- Executar todos os ataques
        for _, key in ipairs(attackKeys) do
            if not autoKillEnabled then break end
            
            VirtualInputManager:SendKeyEvent(true, key, false, game)
            task.wait(0.03)
            VirtualInputManager:SendKeyEvent(false, key, false, game)
            
            ultraRapidClick()
            task.wait(0.02)
        end
    end

    -- Teclas numéricas (1-4)
    local numberKeys = {
        [1] = Enum.KeyCode.One,
        [2] = Enum.KeyCode.Two,
        [3] = Enum.KeyCode.Three,
        [4] = Enum.KeyCode.Four,
    }

    -- Mudança de slot
    local function changeSlotFast()
        local currentTime = tick()
        if currentTime - lastSlotChange < slotCooldown then
            return currentSlot
        end
        
        lastSlotChange = currentTime
        currentSlot = (currentSlot % 4) + 1
        
        local key = numberKeys[currentSlot]
        if key then
            VirtualInputManager:SendKeyEvent(true, key, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, key, false, game)
        end
        
        return currentSlot
    end

    -- Loop principal
    local function ultraFastKillLoop()
        if not autoKillEnabled then return end

        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        -- Verificar alvo atual
        if targetPlayer and targetPlayer.Character then
            local hum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then
                targetPlayer = nil
            end
        end

        -- Procurar novo alvo
        if not targetPlayer then
            local nearest, dist = findNearestPlayer()
            if nearest and dist < 180 then
                targetPlayer = nearest
            else
                return
            end
        end

        -- SEQUÊNCIA DE ATAQUE
        if targetPlayer and targetPlayer.Character then
            ultraFastTeleportToTarget()
            changeSlotFast()
            ultraFastAttackSequence()
            ultraRapidClick()
            
            if aggressiveMode then
                task.wait(0.05)
                ultraFastTeleportToTarget()
            end
        end
    end

    -- Função para ativar/desativar
    local function toggleAutoKill(state)
        autoKillEnabled = state
        
        if autoKillEnabled then
            print("Auto Kill: ATIVADO - ULTRA RÁPIDO")
            
            -- Usar RenderStepped para máxima velocidade
            connection = RunService.RenderStepped:Connect(ultraFastKillLoop)
        else
            print("Auto Kill: Desativado")
            
            if connection then 
                connection:Disconnect() 
                connection = nil 
            end
            targetPlayer = nil
            currentSlot = 1
        end
    end

    -- Configurações opcionais
    local function setAutoClick(state)
        autoClickEnabled = state
        print("Auto Click:", state and "ON" or "OFF")
    end

    local function setAggressiveMode(state)
        aggressiveMode = state
        teleportCooldown = state and 0.05 or 0.1
        print("Modo Agressivo:", state and "ON" or "OFF")
    end

    -- Atalhos (opcionais)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        
        -- Shift + T para teleporte instantâneo
        if input.KeyCode == Enum.KeyCode.T and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            ultraFastTeleportToTarget()
        end
        
        -- Shift + R para resetar alvo
        if input.KeyCode == Enum.KeyCode.R and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            targetPlayer = nil
            print("Alvo resetado")
        end
    end)

    return {
        toggle = toggleAutoKill,
        setAutoClick = setAutoClick,
        setAggressiveMode = setAggressiveMode,
        isEnabled = function() return autoKillEnabled end
    }
end)()

-- TAB 1: AIMBOT
Tab1:Toggle({
    Title = "Aimbot Automático",
    Desc = "Ativa o aimbot automaticamente",
    Default = false,
    Callback = function(state) 
        aimbot.toggle(state)
        print("Aimbot:", state)
        WindUI:Notify({
            Title = "Aimbot",
            Content = state and "Ligado" or "Desligado",
            Duration = 2,
            Icon = "crosshair",
        })
    end
})

-- TAB 2: AUTOKILL
Tab2:Toggle({
    Title = "AutoKill Contínuo", 
    Desc = "Mantém o AutoKill sempre ativo",
    Default = false,
    Callback = function(state) 
        autoKill.toggle(state)
        print("AutoKill:", state)
        WindUI:Notify({
            Title = "Auto Kill",
            Content = state and "ATIVADO - ULTRA RÁPIDO" or "Desativado",
            Duration = 2,
            Icon = "sword",
        })
    end
})

Tab2:Toggle({
    Title = "Auto Click",
    Desc = "Clique automático durante o AutoKill",
    Default = true,
    Callback = function(state)
        autoKill.setAutoClick(state)
    end
})

Tab2:Toggle({
    Title = "Modo Agressivo",
    Desc = "Teleporte mais rápido e próximo",
    Default = true,
    Callback = function(state)
        autoKill.setAggressiveMode(state)
    end
})

-- TAB 3: FLY
Tab3:Button({
    Title = "Ativar Fly",
    Desc = "Habilita voo no jogo",
    Callback = function()
        WindUI:Notify({
            Title = "Fly",
            Content = "Função Fly ativada",
            Duration = 2,
            Icon = "bird",
        })
    end
})

-- TAB 4: SPEED
Tab4:Slider({
    Title = "Velocidade",
    Desc = "Controla a velocidade do personagem",
    Default = 16,
    Min = 16,
    Max = 100,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end

        WindUI:Notify({
            Title = "Speed",
            Content = "Velocidade: " .. value,
            Duration = 2,
            Icon = "gauge",
        })
    end
})

-- TAB 5: VELOCIDADE COM INPUT
Tab5:Input({
    Title = "Definir Velocidade",
    Desc = "Recomendado usar menos de 300.",
    Value = "16",
    InputIcon = "text_cursor",
    Type = "Input",
    Placeholder = "Ex: 50, 100, 200...",
    Callback = function(input) 
        local speed = tonumber(input)
        
        if speed and speed >= 16 and speed <= 1000 then
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
                
                WindUI:Notify({
                    Title = "Speed",
                    Content = "Velocidade: " .. speed,
                    Duration = 2,
                    Icon = "text_cursor",
                })
            end
        else
            WindUI:Notify({
                Title = "Erro",
                Content = "Digite um número entre 16 e 1000",
                Duration = 2,
                Icon = "error",
            })
        end
    end
})

-- TAB 6: SETTINGS
Tab6:Button({
    Title = "Destruir Interface",
    Desc = "Remove completamente a interface",
    Callback = function()
        Window:Destroy()
        WindUI:Notify({
            Title = "Interface",
            Content = "Interface destruída",
            Duration = 2,
            Icon = "trash",
        })
    end
})

-- Notificação
WindUI:Notify({
    Title = "Hub Carregado",
    Content = "Blackzw Universal pronto para uso, espero que não seja banido ;-;.",
    Duration = 3,
    Icon = "check",
})