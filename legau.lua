local Players=game:GetService("Players")
local Tween=game:GetService("TweenService")
local Run=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local SoundService=game:GetService("SoundService")

local plr=Players.LocalPlayer or Players.PlayerAdded:Wait()
local gui=Instance.new("ScreenGui",plr:WaitForChild("PlayerGui"))
gui.Name="MirrorsGalaxy"
gui.IgnoreGuiInset=true
gui.ResetOnSpawn=false

local bg=Instance.new("Frame",gui)
bg.Size=UDim2.fromScale(1,1)
bg.BackgroundColor3=Color3.fromRGB(8,5,20)
bg.BorderSizePixel=0

local grad=Instance.new("UIGradient",bg)
grad.Color=ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(30,10,70)),
	ColorSequenceKeypoint.new(0.5,Color3.fromRGB(110,50,200)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(10,5,25))
}
grad.Rotation=90

local fade=Instance.new("CanvasGroup",bg)
fade.GroupTransparency=0

local blur=Instance.new("BlurEffect",Lighting)
blur.Size=14

local music=Instance.new("Sound",SoundService)
music.SoundId="rbxassetid://1845341094"
music.Volume=0.7
music.Looped=true
music:Play()

-- ESTRELAS
for i=1,45 do
	local s=Instance.new("Frame",bg)
	s.Size=UDim2.fromOffset(2,2)
	s.Position=UDim2.fromScale(math.random(),math.random())
	s.BackgroundColor3=Color3.fromRGB(255,255,255)
	s.BackgroundTransparency=math.random(2,6)/10
	s.BorderSizePixel=0
	Instance.new("UICorner",s).CornerRadius=UDim.new(1,0)

	task.spawn(function()
		while s.Parent do
			Tween:Create(s,TweenInfo.new(math.random(3,6),Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{
				BackgroundTransparency=math.random(2,8)/10
			}):Play()
			task.wait(math.random(2,4))
		end
	end)
end

-- TITULO
local title=Instance.new("TextLabel",bg)
title.Size=UDim2.fromScale(1,0.2)
title.Position=UDim2.fromScale(0,0.3)
title.BackgroundTransparency=1
title.Text="MIRRORS HUB"
title.Font=Enum.Font.GothamBlack
title.TextSize=78
title.TextColor3=Color3.fromRGB(245,235,255)

local stroke=Instance.new("UIStroke",title)
stroke.Thickness=4
stroke.Color=Color3.fromRGB(170,80,255)
stroke.Transparency=0

local shadow=Instance.new("TextLabel",bg)
shadow.Size=title.Size
shadow.Position=title.Position+UDim2.fromOffset(4,4)
shadow.BackgroundTransparency=1
shadow.Text="MIRRORS HUB"
shadow.Font=title.Font
shadow.TextSize=78
shadow.TextColor3=Color3.fromRGB(120,0,180)
shadow.TextTransparency=0.35

-- SUBTEXTO
local sub=Instance.new("TextLabel",bg)
sub.Size=UDim2.fromScale(1,0.05)
sub.Position=UDim2.fromScale(0,0.52)
sub.BackgroundTransparency=1
sub.Font=Enum.Font.GothamMedium
sub.TextSize=18
sub.TextColor3=Color3.fromRGB(220,210,255)
sub.Text="initializing galaxy core"

-- BARRA
local barBG=Instance.new("Frame",bg)
barBG.Size=UDim2.fromScale(0.34,0.014)
barBG.Position=UDim2.fromScale(0.33,0.6)
barBG.BackgroundColor3=Color3.fromRGB(10,10,30)
barBG.BackgroundTransparency=0.3
barBG.BorderSizePixel=0
Instance.new("UICorner",barBG).CornerRadius=UDim.new(1,0)

local bar=Instance.new("Frame",barBG)
bar.Size=UDim2.fromScale(0,1)
bar.BorderSizePixel=0
Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)

local barGrad=Instance.new("UIGradient",bar)
barGrad.Color=ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(160,80,255)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(255,200,255))
}

Run.RenderStepped:Connect(function(dt)
	barGrad.Offset+=Vector2.new(dt*0.6,0)
end)

local pct=Instance.new("TextLabel",bg)
pct.Size=UDim2.fromScale(1,0.04)
pct.Position=UDim2.fromScale(0,0.64)
pct.BackgroundTransparency=1
pct.Font=Enum.Font.GothamMedium
pct.TextSize=15
pct.TextColor3=Color3.fromRGB(245,240,255)
pct.Text="0%"

local texts={
	"initializing galaxy core",
	"loading mirrors modules",
	"calibrating visuals",
	"syncing interface",
	"finalizing"
}

local p=0
while p<100 do
	p+=math.random(1,3)
	if p>100 then p=100 end
	pct.Text=p.."%"
	sub.Text=texts[math.clamp(math.floor(p/20)+1,1,#texts)]
	Tween:Create(bar,TweenInfo.new(0.3,Enum.EasingStyle.Sine),{
		Size=UDim2.fromScale(p/100,1)
	}):Play()
	task.wait(0.25)
end

-- FINALIZAÇÃO DO LOADING
sub.Text = "ready"

Tween:Create(fade, TweenInfo.new(1.6, Enum.EasingStyle.Quad), {
	GroupTransparency = 1
}):Play()

Tween:Create(music, TweenInfo.new(1.6), {
	Volume = 0
}):Play()

Tween:Create(blur, TweenInfo.new(1.6), {
	Size = 0
}):Play()

task.wait(1.7)

music:Stop()
blur:Destroy()
gui:Destroy()

-- EXECUTA O SCRIPT APÓS O LOADING TERMINAR
pcall(function()
	loadstring(game:HttpGet(
		"https://raw.githubusercontent.com/blackzww/UniversalScript/refs/heads/main/universal.lua"
	))()
end)
