-- versão corrigida do seu script
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))()

WindUI:SetFont("rbxassetid://12187365559")
WindUI:SetTheme("Dark")

local Window = WindUI:CreateWindow({
    Title = "Blackzw Universal",
    Icon = "app-window",
    Author = "by blackzw",
    Folder = "BlackzwHub",
}) -- <- fechou a tabela e o parêntese corretamente

Window:EditOpenButton({
    Title = "Open Blackzw UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(252,0,0)), -- FC0000
        ColorSequenceKeypoint.new(1, Color3.fromRGB(122,0,0)), -- 7A0000
    }),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

Window:DisableTopbarButtons({
    "Close",
    "Minimize",
})

if Window.Icon and Window.Icon.Enable then
    Window.Icon:Enable()
end

local Tab = Window:Tab({
    Title = "Aimbot",
    Icon = "crosshair",
    Locked = true,
})

WindUI:Notify({
    Title = "Thanks for using my script :3",
    Content = "I really appreciate that you used my script, thanks :3",
    Duration = 3,
    Icon = "thumbs-up",
})