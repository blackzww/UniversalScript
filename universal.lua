local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:SetFont("rbxassetid://12187365559")
WindUI:SetTheme("Dark")

local Window = WindUI:CreateWindow({
    Title = "Blackzw Universal",
    Icon = "app-window",
    Author = "by blackzw",
    Folder = "BlackzwHub",

Window:EditOpenButton({
    Title = "Open Blackzw UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FC0000"), 
        Color3.fromHex("7A0000")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

Window:DisableTopbarButtons({
    "Close", 
    "Minimize"
})

Window.Icon:Enable()

local Tab = Window:Tab({
    Title = "Aimbot",
    Icon = "crosshair", -- optional
    Locked = true,
})

WindUI:Notify({
    Title = "Thanks for using my script :3",
    Content = "I really appreciate that you used my script, thanks :3",
    Duration = 3, -- 3 seconds
    Icon = "thumbs-up",
})