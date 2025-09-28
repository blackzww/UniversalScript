local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Fonte customizada e tema escuro
WindUI:SetFont("rbxassetid://12187365559")
WindUI:SetTheme("Dark")

-- Criação da janela principal
local Window = WindUI:CreateWindow({
    Title = "Blackzw Universal",
    Icon = "app-window",
    Author = "by blackzw",
    Folder = "BlackzwHub",
    CornerRadius = UDim.new(0, 20), -- bordas arredondadas
    TopbarColor = Color3.fromRGB(35, 35, 35), -- cor do topo
    TitleColor = Color3.fromRGB(252, 0, 0), -- cor do título (destacado)
})

-- Botão de abrir com gradiente e animação
Window:EditOpenButton({
    Title = "Open Blackzw UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromHex("FC0000")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("B90000")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("7A0000"))
    },
    OnlyMobile = true, -- disponível para PC e mobile
    Enabled = true,
    Draggable = true,
    Animation = "Bounce", -- animação para destacar o botão
})

-- Botões do topo customizados
Window:DisableTopbarButtons({
    "Fullscreen", -- desabilita fullscreen
})

-- Ativa o ícone da janela (se aplicável)
if Window.Icon and Window.Icon.Enable then
    Window.Icon:Enable()
end

-- Tab de Aimbot estilizada
local Tab = Window:Tab({
    Title = "Aimbot",
    Icon = "crosshair",
    Locked = false, -- desbloqueado para o usuário
    TabColor = Color3.fromRGB(252, 0, 0), -- cor do tab
})

-- Notificação animada
WindUI:Notify({
    Title = "Thanks for using my script :3",
    Content = "I really appreciate that you used my script, thanks :3",
    Duration = 4,
    Icon = "thumbs-up",
    Animation = "Fade", -- animação suave
    BackgroundColor = Color3.fromRGB(35, 35, 35), -- cor do fundo
    TitleColor = Color3.fromRGB(252, 0, 0), -- cor do título
})

-- Dica: você pode adicionar mais tabs, botões, sliders, e customizar cores e ícones para cada parte!