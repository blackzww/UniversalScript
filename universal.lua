local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Config inicial
WindUI:SetFont("rbxassetid://12187370747")
WindUI:SetTheme("Dark")

local Window = WindUI:CreateWindow({
    Title = "Blackzw Universal",
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
    Title = "Abrir Hub",
    Icon = "menu",
    CornerRadius = UDim.new(0, 12),
    StrokeThickness = 1,
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromHex("#DC143C")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#8B0000"))
    },
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- Desabilita botões do topo
Window:DisableTopbarButtons({ "Fullscreen" })

-- Tabs
local Tab1 = Window:Tab({ Title = "Aimbot", Icon = "crosshair" })
local Tab2 = Window:Tab({ Title = "AutoKill", Icon = "sword" })
local Tab3 = Window:Tab({ Title = "Fly", Icon = "bird" })
local Tab4 = Window:Tab({ Title = "Speed", Icon = "gauge" })
local Tab5 = Window:Tab({ Title = "ESP", Icon = "eye" })
local Tab6 = Window:Tab({ Title = "Settings", Icon = "settings" })

-- TAB 1: AIMBOT
Tab1:Button({
    Title = "Ativar Aimbot",
    Desc = "Ativa o aimbot manualmente",
    Callback = function()
        loadstring(game:HttpGet("-- COLOCAR URL DO AIMBOT AQUI"))()
    end
})

Tab1:Toggle({
    Title = "Aimbot Automático",
    Desc = "Ativa o aimbot automaticamente",
    Default = false,
    Callback = function(state) 
        print("Aimbot:", state)
    end
})

-- TAB 2: AUTOKILL
Tab2:Button({
    Title = "Ativar AutoKill",
    Desc = "Executa o AutoKill uma vez",
    Callback = function()
        loadstring(game:HttpGet("-- COLOCAR URL DO AUTOKILL AQUI"))()
    end
})

Tab2:Toggle({
    Title = "AutoKill Contínuo", 
    Desc = "Mantém o AutoKill sempre ativo",
    Default = false,
    Callback = function(state) 
        print("AutoKill:", state)
    end
})

-- TAB 3: FLY
Tab3:Button({
    Title = "Ativar Fly",
    Desc = "Ativa voo manualmente",
    Callback = function()
        loadstring(game:HttpGet("-- COLOCAR URL DO FLY AQUI"))()
    end
})

Tab3:Toggle({
    Title = "Fly Automático",
    Desc = "Mantém o voo ativo",
    Default = false,
    Callback = function(state) 
        print("Fly:", state)
    end
})

-- TAB 4: SPEED
Tab4:Button({
    Title = "Ativar Speed",
    Desc = "Aumenta a velocidade manualmente", 
    Callback = function()
        loadstring(game:HttpGet("-- COLOCAR URL DO SPEED AQUI"))()
    end
})

Tab4:Toggle({
    Title = "Speed Boost",
    Desc = "Mantém velocidade aumentada",
    Default = false,
    Callback = function(state) 
        print("Speed:", state)
    end
})

-- TAB 5: ESP
Tab5:Button({
    Title = "Ativar ESP",
    Desc = "Mostra jogadores através das paredes",
    Callback = function()
        loadstring(game:HttpGet("-- COLOCAR URL DO ESP AQUI"))()
    end
})

Tab5:Toggle({
    Title = "ESP Contínuo",
    Desc = "Mantém ESP ativo sempre",
    Default = false,
    Callback = function(state) 
        print("ESP:", state)
    end
})

-- TAB 6: SETTINGS  
Tab6:Button({
    Title = "Salvar Config",
    Desc = "Salva as configurações atuais",
    Callback = function()
        print("Config salva")
    end
})

Tab6:Toggle({
    Title = "Modo Escuro",
    Desc = "Ativa/desativa tema escuro",
    Default = true,
    Callback = function(state) 
        print("Dark Mode:", state)
    end
})

-- Notificação
WindUI:Notify({
    Title = "Hub Carregado",
    Content = "Blackzw Universal pronto para uso.",
    Duration = 3,
    Icon = "check",
})