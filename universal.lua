--[[
    Mirrors Hub | Interface Premium
    Autor: blackzw
    Versão: 2.0
]]

--==================================================
-- CONFIGURAÇÕES INICIAIS
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--==================================================
-- FUNCAO PARA APARECER A NOTIFY
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- Espera o PlayerGui carregar
player:WaitForChild("PlayerGui")

-- Espera um pouco mais para garantir que tudo está carregado
wait(1)

pcall(function()
	StarterGui:SetCore("SendNotification", {
		Title = "Mirrors Hub",
		Text = "Execute o script novamente para inicia-lo.",
		Icon = "rbxassetid://77513496492572", -- Ícone que funciona
		Duration = 8
	})
end)

--==================================================
-- CARREGAR INTERFACE
--==================================================

local Interface = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--==================================================
-- EXECUTAR AUTOKILL
--==================================================

pcall(function()
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/blackzww/auto-kill/refs/heads/main/autokill.lua"
    ))()
end)

--==================================================
-- NOTIFICAÇÃO INICIAL
--==================================================

Interface:Notify({
    Title = "Mirrors Hub",
    Content = "Interface carregada com sucesso",
    Duration = 3,
    Icon = "check"
})

--==================================================
-- CRIAÇÃO DA JANELA PRINCIPAL
--==================================================

local Janela = Interface:CreateWindow({
    Title = "Mirrors Hub",
    Icon = "app-window",
    Author = "by blackzw",
    Folder = "MirrorsHub",
})

--==================================================
-- DECLARAÇÃO DE ABAS
--==================================================

local Principal = Janela:Tab({
    Title = "Principal",
    Icon = "home",
})

local Player = Janela:Tab({
    Title = "Player",
    Icon = "user",
})

local Scripts = Janela:Tab({
    Title = "Scripts",
    Icon = "layers",
})

local Creditos = Janela:Tab({
    Title = "Créditos",
    Icon = "info",
})

--==================================================
-- VARIÁVEIS GLOBAIS
--==================================================

local Config = {
    Velocidade = 16,
    Pulo = 50,
    AimbotAtivo = false,
    ESPAtivo = false,
    FlingAtivo = false,
    AutoFlingAtivo = false
}

--==================================================
-- Alterar Nick automaticamente (APENAS Brookhaven)
--==================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

if ReplicatedStorage:FindFirstChild("RE")
and ReplicatedStorage.RE:FindFirstChild("1RPNam1eTex1t") then

	local args = {
		"RolePlayName",
		"🤓 | MirrorsHub by Blackzw"
	}

	ReplicatedStorage.RE["1RPNam1eTex1t"]:FireServer(unpack(args))
end
--==================================================
-- Detectar nome do jogo atual
-- Mostra o nome no console ao iniciar o script
--==================================================

local MarketplaceService = game:GetService("MarketplaceService")

local placeId = game.PlaceId
local success, info = pcall(function()
	return MarketplaceService:GetProductInfo(placeId)
end)

if success and info and info.Name then
	print("[Mirrors Hub] Jogo detectado:", info.Name)
else
	warn("[Mirrors Hub] Não foi possível identificar o nome do jogo")
end

--==================================================
-- SISTEMA DE AIMBOT
--==================================================

local ConexaoAimbot = nil
local PersonagemLocal = LocalPlayer.Character
local RAIZLocal = PersonagemLocal and PersonagemLocal:FindFirstChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(personagem)
    PersonagemLocal = personagem
    RAIZLocal = personagem:WaitForChild("HumanoidRootPart")
end)

local function ObterJogadorMaisProximo()
    local meuPersonagem = LocalPlayer.Character
    local minhaRAIZ = meuPersonagem and meuPersonagem:FindFirstChild("HumanoidRootPart")
    if not minhaRAIZ then return nil end

    local maisProximo, distancia = nil, math.huge

    for _, jogador in ipairs(Players:GetPlayers()) do
        if jogador ~= LocalPlayer and jogador.Character then
            local raiz = jogador.Character:FindFirstChild("HumanoidRootPart")
            local humanoide = jogador.Character:FindFirstChildOfClass("Humanoid")
            
            if raiz and humanoide and humanoide.Health > 0 then
                local d = (raiz.Position - minhaRAIZ.Position).Magnitude
                if d < distancia then
                    distancia = d
                    maisProximo = raiz
                end
            end
        end
    end

    return maisProximo
end

local function IniciarAimbot()
    if ConexaoAimbot then return end

    Config.AimbotAtivo = true
    ConexaoAimbot = RunService.RenderStepped:Connect(function()
        if not Config.AimbotAtivo then return end

        local alvo = ObterJogadorMaisProximo()
        if alvo then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, alvo.Position)
        end
    end)
end

local function PararAimbot()
    Config.AimbotAtivo = false
    if ConexaoAimbot then
        ConexaoAimbot:Disconnect()
        ConexaoAimbot = nil
    end
end

--==================================================
-- SISTEMA DE ESP
--==================================================

local ConfigESP = {
    Ativo = false,
    TamanhoCaixa = 1,
    Espessura = 2,
    Cor = Color3.fromRGB(0, 255, 0),
    MostrarLinha = false
}

local ObjetosESP = {}

local function RemoverESP(jogador)
    if ObjetosESP[jogador] then
        for _, objeto in pairs(ObjetosESP[jogador]) do
            objeto:Remove()
        end
        ObjetosESP[jogador] = nil
    end
end

local function CriarESP(jogador)
    if jogador == LocalPlayer then return end

    local caixa = Drawing.new("Square")
    caixa.Filled = false
    caixa.Visible = false

    local nome = Drawing.new("Text")
    nome.Size = 14
    nome.Center = true
    nome.Outline = true
    nome.Visible = false

    local informacao = Drawing.new("Text")
    informacao.Size = 13
    informacao.Center = true
    informacao.Outline = true
    informacao.Visible = false

    local linha = Drawing.new("Line")
    linha.Visible = false

    ObjetosESP[jogador] = {
        Caixa = caixa,
        Nome = nome,
        Info = informacao,
        Linha = linha
    }
end

-- Inicializar ESP para jogadores existentes
for _, jogador in ipairs(Players:GetPlayers()) do
    CriarESP(jogador)
end

Players.PlayerAdded:Connect(CriarESP)
Players.PlayerRemoving:Connect(RemoverESP)

RunService.RenderStepped:Connect(function()
    for jogador, esp in pairs(ObjetosESP) do
        if not ConfigESP.Ativo then
            for _, objeto in pairs(esp) do
                objeto.Visible = false
            end
            continue
        end

        local personagem = jogador.Character
        local raiz = personagem and personagem:FindFirstChild("HumanoidRootPart")
        local humanoide = personagem and personagem:FindFirstChildOfClass("Humanoid")

        if raiz and humanoide and humanoide.Health > 0 then
            local posicao, naTela = Camera:WorldToViewportPoint(raiz.Position)

            if naTela then
                local distancia = (Camera.CFrame.Position - raiz.Position).Magnitude
                local tamanho = Vector2.new(40, 60) * ConfigESP.TamanhoCaixa

                -- Caixa
                esp.Caixa.Size = tamanho
                esp.Caixa.Position = Vector2.new(posicao.X - tamanho.X/2, posicao.Y - tamanho.Y/2)
                esp.Caixa.Color = ConfigESP.Cor
                esp.Caixa.Thickness = ConfigESP.Espessura
                esp.Caixa.Visible = true

                -- Nome
                esp.Nome.Text = jogador.Name
                esp.Nome.Position = Vector2.new(posicao.X, posicao.Y - tamanho.Y/2 - 16)
                esp.Nome.Color = ConfigESP.Cor
                esp.Nome.Visible = true

                -- Informações
                esp.Info.Text = math.floor(humanoide.Health).." HP | "..math.floor(distancia).."m"
                esp.Info.Position = Vector2.new(posicao.X, posicao.Y + tamanho.Y/2 + 2)
                esp.Info.Color = ConfigESP.Cor
                esp.Info.Visible = true

                -- Linha de conexão
                if ConfigESP.MostrarLinha and RAIZLocal then
                    local minhaPosicao, minhaTela = Camera:WorldToViewportPoint(RAIZLocal.Position)

                    if minhaTela then
                        esp.Linha.From = Vector2.new(minhaPosicao.X, minhaPosicao.Y)
                        esp.Linha.To = Vector2.new(posicao.X, posicao.Y + tamanho.Y/2)
                        esp.Linha.Color = ConfigESP.Cor
                        esp.Linha.Thickness = ConfigESP.Espessura
                        esp.Linha.Visible = true
                    else
                        esp.Linha.Visible = false
                    end
                else
                    esp.Linha.Visible = false
                end
            else
                for _, objeto in pairs(esp) do
                    objeto.Visible = false
                end
            end
        else
            for _, objeto in pairs(esp) do
                objeto.Visible = false
            end
        end
    end
end)

--==================================================
-- SISTEMA DE FLING
--==================================================

local FlingAtivo = false
local ThreadFling = nil
local AutoFlingAtivo = false
local ThreadAutoFling = nil

-- Prevenção de duplicação
if not ReplicatedStorage:FindFirstChild("identificador_fling") then
    local identificador = Instance.new("Decal")
    identificador.Name = "identificador_fling"
    identificador.Parent = ReplicatedStorage
end

local function IniciarFling()
    if ThreadFling then return end

    FlingAtivo = true
    ThreadFling = task.spawn(function()
        local movimento = 0.1

        while FlingAtivo do
            RunService.Heartbeat:Wait()

            local personagem = LocalPlayer.Character
            local raiz = personagem and personagem:FindFirstChild("HumanoidRootPart")

            if raiz then
                local velocidade = raiz.Velocity
                raiz.Velocity = velocidade * 10000 + Vector3.new(0, 10000, 0)

                RunService.RenderStepped:Wait()
                if raiz then
                    raiz.Velocity = velocidade
                end

                RunService.Stepped:Wait()
                if raiz then
                    raiz.Velocity = velocidade + Vector3.new(0, movimento, 0)
                    movimento = -movimento
                end
            end
        end

        ThreadFling = nil
    end)
end

local function PararFling()
    FlingAtivo = false
end

-- Sistema de Auto Fling
local function ObterAlvos()
    local alvos = {}
    for _, jogador in ipairs(Players:GetPlayers()) do
        if jogador ~= LocalPlayer and jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(alvos, jogador)
        end
    end
    return alvos
end

local function AcolarAlvo(alvo)
    local minhaRAIZ = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local raizAlvo = alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart")
    
    if not (minhaRAIZ and raizAlvo) then return false end

    minhaRAIZ.CFrame = raizAlvo.CFrame
    minhaRAIZ.Velocity = Vector3.zero
    minhaRAIZ.RotVelocity = Vector3.zero
    
    return true
end

local function EsperarFling(alvo)
    local raizAlvo = alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart")
    if not raizAlvo then return true end

    local posicaoInicial = raizAlvo.Position
    local distanciaFling = 30

    while AutoFlingAtivo do
        task.wait(0.05)

        if not raizAlvo or not raizAlvo.Parent then
            return true
        end

        local distancia = (raizAlvo.Position - posicaoInicial).Magnitude

        if distancia >= distanciaFling or raizAlvo.Velocity.Magnitude > 10000 then
            return true
        end

        AcolarAlvo(alvo)
    end

    return true
end

local function IniciarAutoFling()
    if ThreadAutoFling then return end

    AutoFlingAtivo = true
    FlingAtivo = true
    IniciarFling()

    ThreadAutoFling = task.spawn(function()
        while AutoFlingAtivo do
            for _, alvo in ipairs(ObterAlvos()) do
                if not AutoFlingAtivo then break end

                if AcolarAlvo(alvo) then
                    EsperarFling(alvo)
                end

                task.wait(0.1)
            end

            task.wait(0.2)
        end

        ThreadAutoFling = nil
    end)
end

local function PararAutoFling()
    AutoFlingAtivo = false
    FlingAtivo = false
end

--==================================================
-- ABA PRINCIPAL
--==================================================

Principal:Paragraph({
    Title = "Mirrors Hub",
    Desc = "Hub premium com funcionalidades avançadas.\nSistema integrado de AutoKill com controle seguro.",
    Color = "Blue",
})

Principal:Toggle({
    Title = "Aimbot",
    Desc = "Mira automaticamente no jogador mais próximo",
    Value = false,
    Callback = function(estado)
        if estado then
            IniciarAimbot()
        else
            PararAimbot()
        end
    end
})

Principal:Toggle({
    Title = "Auto Kill",
    Desc = "Ativa ou desativa o sistema AutoKill",
    Value = false,
    Callback = function(estado)
        if getgenv().AutoKill then
            if estado then
                getgenv().AutoKill.Start()
            else
                getgenv().AutoKill.Stop()
            end
        else
            warn("Sistema AutoKill não carregado")
        end
    end
})

Principal:Button({
    Title = "Executar Ação",
    Desc = "Botão de teste para funcionalidades",
    Callback = function()
        print("Ação executada com sucesso")
    end
})

--==================================================
-- ABA PLAYER
--==================================================

Player:Slider({
    Title = "Velocidade",
    Desc = "Controla a velocidade de movimento do jogador",
    Step = 1,
    Value = {
        Min = 16,
        Max = 120,
        Default = 16,
    },
    Callback = function(valor)
        Config.Velocidade = valor
        local personagem = LocalPlayer.Character
        if personagem and personagem:FindFirstChildOfClass("Humanoid") then
            personagem:FindFirstChildOfClass("Humanoid").WalkSpeed = valor
        end
    end
})

Player:Slider({
    Title = "Força do Pulo",
    Desc = "Ajusta a altura máxima do pulo",
    Step = 5,
    Value = {
        Min = 50,
        Max = 200,
        Default = 50,
    },
    Callback = function(valor)
        Config.Pulo = valor
        local personagem = LocalPlayer.Character
        if personagem and personagem:FindFirstChildOfClass("Humanoid") then
            personagem:FindFirstChildOfClass("Humanoid").JumpPower = valor
        end
    end
})

Player:Toggle({
    Title = "Pulo Infinito",
    Desc = "Permite pulos consecutivos no ar",
    Value = false,
    Callback = function(estado)
        print("Pulo Infinito:", estado)
    end
})

Player:Toggle({
    Title = "Touch Fling",
    Desc = "Empurra jogadores ao encostar neles",
    Value = false,
    Callback = function(estado)
        if estado then
            IniciarFling()
        else
            PararFling()
        end
    end
})

Player:Toggle({
    Title = "Fling Automático",
    Desc = "Aplica fling em todos os jogadores do servidor",
    Value = false,
    Callback = function(estado)
        if estado then
            IniciarAutoFling()
        else
            PararAutoFling()
        end
    end
})

-- Configurações do ESP
Player:Paragraph({
    Title = "ESP Visual",
    Desc = "Sistema avançado de ESP\nInclui caixa, nome, vida, distância e linha guia",
    Color = "Green"
})

Player:Toggle({
    Title = "Ativar ESP",
    Desc = "Habilita o sistema de ESP",
    Value = false,
    Callback = function(estado)
        ConfigESP.Ativo = estado
    end
})

Player:Toggle({
    Title = "Linha Guia",
    Desc = "Exibe linha conectando ao jogador",
    Value = false,
    Callback = function(estado)
        ConfigESP.MostrarLinha = estado
    end
})

Player:Slider({
    Title = "Tamanho da Caixa",
    Desc = "Escala visual do ESP",
    Step = 0.1,
    Value = {
        Min = 0.6,
        Max = 3,
        Default = 1,
    },
    Callback = function(valor)
        ConfigESP.TamanhoCaixa = valor
    end
})

Player:Slider({
    Title = "Espessura",
    Desc = "Define a espessura das linhas",
    Step = 1,
    Value = {
        Min = 1,
        Max = 6,
        Default = 2,
    },
    Callback = function(valor)
        ConfigESP.Espessura = valor
    end
})

Player:Colorpicker({
    Title = "Cor do ESP",
    Desc = "Define a cor dos elementos visuais",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(cor)
        ConfigESP.Cor = cor
    end
})

--==================================================
-- ABA SCRIPTS
--==================================================

Scripts:Paragraph({
    Title = "Aviso Importante",
    Desc = "Alguns scripts exigem chave de acesso.\nCertifique-se de obter a chave antes de utilizar.",
    Color = "Green",
})

Scripts:Button({
    Title = "OMG Hub",
    Desc = "Executa o OMG Hub universal",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-OMG-Hub-43353"))()
    end
})

Scripts:Button({
    Title = "Zee Hub",
    Desc = "Carrega o Zee Hub",
    Callback = function()
        loadstring(game:HttpGet('https://zuwz.me/Ls-Zee-Hub-KL'))()
    end
})

Scripts:Button({
    Title = "Arch Hub",
    Desc = "Inicializa o Arch Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ChopLoris/ArcHub/main/main.lua"))()
    end
})

Scripts:Button({
    Title = "Infinite Yield",
    Desc = "Ativa o Infinite Yield FE",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Infinite-Yield-FE-Script-74834"))()
    end
})

Scripts:Button({
    Title = "Fly V4",
    Desc = "Habilita sistema de voo V4",
    Callback = function()
        getgenv().rotationSpeed = 1
        getgenv().noclipfly = true
        getgenv().useV3Method = false
        loadstring(game:HttpGet("https://raw.githubusercontent.com/linhmcfake/Script/refs/heads/main/FLYGUIV4"))()
    end
})

Scripts:Button({
    Title = "Noclip",
    Desc = "Ativa modo noclip",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/AkU0ZYKX"))()
    end
})

Scripts:Button({
    Title = "ESP Externo",
    Desc = "Carrega sistema ESP alternativo",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))()
    end
})

--==================================================
-- ABA CRÉDITOS
--==================================================

Creditos:Paragraph({
    Title = "Créditos",
    Desc = "Desenvolvido por blackzw\nInterface: WindUI\nSistema integrado de AutoKill",
    Color = "Green",
})