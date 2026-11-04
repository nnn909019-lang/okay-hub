-- okay hub v0.4
-- intentionally terrible
Players=game:GetService("Players")
TweenService=game:GetService("TweenService")
UserInputService=game:GetService("UserInputService")
RunService=game:GetService("RunService")
Lighting=game:GetService("Lighting")
HttpService=game:GetService("HttpService")

player=Players.LocalPlayer
guiParent=player:WaitForChild("PlayerGui")

for _,n in ipairs({"OkayGlassHub","OkayGlassNotify","OkayGlassToggle"}) do
    local o=guiParent:FindFirstChild(n)
    if o then o:Destroy() end
end

Config={}

function GetScale()
    local cam=workspace.CurrentCamera
    if not cam then return 2 end
    local vp=cam.ViewportSize
    return math.min(vp.X/1920,vp.Y/1080)*2
end
currentScale=GetScale()

notifyGui=Instance.new("ScreenGui")
notifyGui.Name="OkayGlassNotify"
notifyGui.ResetOnSpawn=false
notifyGui.IgnoreGuiInset=true
notifyGui.Parent=guiParent
notifyCol=Instance.new("Frame",notifyGui)
notifyCol.Position=UDim2.new(0,10,0,10)
notifyCol.Size=UDim2.new(0,240,0,300)
notifyCol.BackgroundTransparency=1
Instance.new("UIListLayout",notifyCol).Padding=UDim.new(0,4)

nCounter=0
Notify={}
function Notify.Show(title,desc,dur)
    dur=dur or 2
    nCounter-=1
    local n=Instance.new("Frame",notifyCol)
    n.Size=UDim2.new(1,0,0,30)
    n.BackgroundColor3=Color3.fromRGB(255,255,255)
    n.BackgroundTransparency=0.2
    n.BorderSizePixel=1
    n.BorderColor3=Color3.fromRGB(0,0,0)
    n.LayoutOrder=nCounter
    local t=Instance.new("TextLabel",n)
    t.Size=UDim2.new(1,-8,0,14)
    t.Position=UDim2.new(0,4,0,2)
    t.BackgroundTransparency=1
    t.Text=tostring(title or "")
    t.TextColor3=Color3.fromRGB(0,0,0)
    t.Font=Enum.Font.SourceSansBold
    t.TextSize=10
    t.TextXAlignment=Enum.TextXAlignment.Left
    t.TextTruncate=Enum.TextTruncate.AtEnd
    if desc and desc~="" then
        local d=Instance.new("TextLabel",n)
        d.Size=UDim2.new(1,-8,0,10)
        d.Position=UDim2.new(0,4,0,17)
        d.BackgroundTransparency=1
        d.Text=tostring(desc)
        d.TextColor3=Color3.fromRGB(80,80,80)
        d.Font=Enum.Font.SourceSans
        d.TextSize=8
        d.TextXAlignment=Enum.TextXAlignment.Left
        d.TextTruncate=Enum.TextTruncate.AtEnd
    end
    task.delay(dur,function() if n.Parent then n:Destroy() end end)
end

WIN_W,WIN_H=620,420

gui=Instance.new("ScreenGui")
gui.Name="OkayGlassHub"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.Parent=guiParent
guiScale=Instance.new("UIScale",gui)
guiScale.Scale=currentScale

wrap=Instance.new("Frame",gui)
wrap.Position=UDim2.new(0,100,0,100)
wrap.Size=UDim2.new(0,WIN_W,0,WIN_H)
wrap.BackgroundTransparency=1
wrap.Visible=false

win=Instance.new("Frame",wrap)
win.Size=UDim2.new(1,0,1,0)
win.BackgroundColor3=Color3.fromRGB(245,245,245)
win.BackgroundTransparency=0.25
win.BorderSizePixel=2
win.BorderColor3=Color3.fromRGB(0,0,0)

header=Instance.new("Frame",win)
header.Size=UDim2.new(1,-16,0,36)
header.Position=UDim2.new(0,8,0,8)
header.BackgroundColor3=Color3.fromRGB(255,255,255)
header.BorderSizePixel=1
header.BorderColor3=Color3.fromRGB(0,0,0)

title=Instance.new("TextLabel",header)
title.Size=UDim2.new(0,300,1,0)
title.Position=UDim2.new(0,4,0,0)
title.BackgroundTransparency=1
title.Text="OKAY HUB"
title.TextColor3=Color3.fromRGB(0,0,0)
title.Font=Enum.Font.SourceSansBold
title.TextSize=22
title.TextXAlignment=Enum.TextXAlignment.Left
title.TextTruncate=Enum.TextTruncate.AtEnd

sub=Instance.new("TextLabel",header)
sub.Size=UDim2.new(0,100,0,10)
sub.Position=UDim2.new(1,-128,0,4)
sub.BackgroundTransparency=1
sub.Text="v0.4"
sub.TextColor3=Color3.fromRGB(120,120,120)
sub.Font=Enum.Font.SourceSans
sub.TextSize=8

close=Instance.new("TextButton",header)
close.Size=UDim2.new(0,24,0,24)
close.Position=UDim2.new(1,-28,0.5,-12)
close.BackgroundColor3=Color3.fromRGB(255,255,255)
close.BorderSizePixel=1
close.BorderColor3=Color3.fromRGB(0,0,0)
close.Text="x"
close.TextColor3=Color3.fromRGB(0,0,0)
close.Font=Enum.Font.SourceSansBold
close.TextSize=14
close.AutoButtonColor=false

SIDEBAR_W=140
sidebar=Instance.new("Frame",win)
sidebar.Size=UDim2.new(0,SIDEBAR_W,1,-60)
sidebar.Position=UDim2.new(0,8,0,52)
sidebar.BackgroundColor3=Color3.fromRGB(255,255,255)
sidebar.BorderSizePixel=1
sidebar.BorderColor3=Color3.fromRGB(0,0,0)

sideScroll=Instance.new("ScrollingFrame",sidebar)
sideScroll.Size=UDim2.new(1,-4,1,-4)
sideScroll.Position=UDim2.new(0,2,0,2)
sideScroll.BackgroundTransparency=1
sideScroll.BorderSizePixel=0
sideScroll.ScrollBarThickness=1
sideScroll.ScrollBarImageColor3=Color3.fromRGB(0,0,0)
sideScroll.CanvasSize=UDim2.new(0,0,0,0)
sideScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
Instance.new("UIListLayout",sideScroll).Padding=UDim.new(0,0)

CONTENT_X=8+SIDEBAR_W+6
CONTENT_W=WIN_W-CONTENT_X-8
content=Instance.new("Frame",win)
content.Size=UDim2.new(0,CONTENT_W,1,-60)
content.Position=UDim2.new(0,CONTENT_X,0,52)
content.BackgroundColor3=Color3.fromRGB(255,255,255)
content.BorderSizePixel=1
content.BorderColor3=Color3.fromRGB(0,0,0)

secTitle=Instance.new("TextLabel",content)
secTitle.Size=UDim2.new(1,-8,0,20)
secTitle.Position=UDim2.new(0,4,0,4)
secTitle.BackgroundTransparency=1
secTitle.Text="home"
secTitle.TextColor3=Color3.fromRGB(0,0,0)
secTitle.Font=Enum.Font.SourceSansBold
secTitle.TextSize=16
secTitle.TextXAlignment=Enum.TextXAlignment.Left

secSub=Instance.new("TextLabel",content)
secSub.Size=UDim2.new(1,-8,0,10)
secSub.Position=UDim2.new(0,4,0,22)
secSub.BackgroundTransparency=1
secSub.Text="welcome (broken)"
secSub.TextColor3=Color3.fromRGB(120,120,120)
secSub.Font=Enum.Font.SourceSans
secSub.TextSize=8
secSub.TextXAlignment=Enum.TextXAlignment.Left

cardScroll=Instance.new("ScrollingFrame",content)
cardScroll.Size=UDim2.new(1,-8,1,-40)
cardScroll.Position=UDim2.new(0,4,0,36)
cardScroll.BackgroundTransparency=1
cardScroll.BorderSizePixel=0
cardScroll.ScrollBarThickness=2
cardScroll.ScrollBarImageColor3=Color3.fromRGB(0,0,0)
cardScroll.CanvasSize=UDim2.new(0,0,0,0)
cardScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y

footer=Instance.new("TextLabel",win)
footer.Size=UDim2.new(0,300,0,12)
footer.Position=UDim2.new(0,8,1,-14)
footer.BackgroundTransparency=1
footer.Text="okay hub  ·  v0.4  ·  don't use"
footer.TextColor3=Color3.fromRGB(140,140,140)
footer.Font=Enum.Font.SourceSans
footer.TextSize=8
footer.TextXAlignment=Enum.TextXAlignment.Left

TABS={"home","fun","settings"}
tabRefs={}
activeTab="home"

function setActive(id)
    if id==activeTab then return end
    activeTab=id
    for tid,t in pairs(tabRefs) do
        if t.label then
            t.label.TextColor3 = (tid==id) and Color3.fromRGB(0,0,0) or Color3.fromRGB(140,140,140)
        end
    end
    if renderContent then pcall(renderContent) end
end

for _,id in ipairs(TABS) do
    local lbl=Instance.new("TextButton",sideScroll)
    lbl.Size=UDim2.new(1,0,0,26)
    lbl.BackgroundColor3=Color3.fromRGB(255,255,255)
    lbl.BackgroundTransparency=1
    lbl.BorderSizePixel=0
    lbl.Text=id
    lbl.TextColor3 = (id==activeTab) and Color3.fromRGB(0,0,0) or Color3.fromRGB(140,140,140)
    lbl.Font=Enum.Font.SourceSansBold
    lbl.TextSize=11
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.AutoButtonColor=false
    lbl.MouseButton1Click:Connect(function() setActive(id) end)
    tabRefs[id]={label=lbl}
end

FEATURES={
    home={title="home",sub="welcome",items={
        {name="Disco",desc="rainbow world (lags)",type="toggle",key="disco"},
        {name="SpinBot",desc="spin yourself",type="toggle",key="spinbot"},
        {name="RandomColors",desc="chaos colors (broken)",type="toggle",key="randcolors"},
        {name="Grayscale",desc="remove all color",type="toggle",key="grayscale"},
        {name="JerkOff",desc="weird animation",type="load",url="https://pastefy.app/wJgFD7Lp/raw"},
        {name="FEEmote",desc="universal emotes",type="load",url="https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024"},
        {name="RickBomb",desc="rick bomb",type="load",url="https://pastefy.app/n9ROxwGo/raw"},
        {name="RickPrime",desc="rick prime",type="load",url="https://pastefy.app/1tcmg4qs/raw"},
    }},
    fun={title="fun",sub="chaos",items={
        {name="SitForever",desc="sit and never stand",type="button",fn="SitForever"},
        {name="DanceForever",desc="dance loop (does nothing)",type="button",fn="DanceForever"},
        {name="CameraSpin",desc="spin camera (client)",type="toggle",key="camspin"},
        {name="FreezeSelf",desc="freeze your own body 3s",type="button",fn="FreezeSelf"},
        {name="RandomTP",desc="tp random (may die)",type="button",fn="RandomTP"},
        {name="AnnoyingSound",desc="play annoying sound",type="button",fn="AnnoyingSound"},
    }},
    settings={title="settings",sub="broken stuff",items={
        {name="Nothing",desc="does nothing",type="button",fn="Nothing"},
        {name="FakeToggle",desc="toggle that toggles nothing",type="toggle",key="fake"},
        {name="FakeError",desc="show fake error",type="button",fn="FakeError"},
    }},
}

FEATURE_HANDLERS={}
BUTTON_HANDLERS={}
TogglesState={}

FEATURE_HANDLERS.disco=function(on)
    if _G._discoConn then _G._discoConn:Disconnect() _G._discoConn=nil end
    if on then
        _G._discoC={}
        _G._discoParts={}
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                _G._discoC[v]=v.Color
                table.insert(_G._discoParts,v)
            end
        end
        _G._discoConn=RunService.Heartbeat:Connect(function()
            local c=Color3.fromHSV(tick()%1,0.8,1)
            for _,v in ipairs(_G._discoParts) do
                if v.Parent then v.Color=c end
            end
        end)
    else
        for o,c in pairs(_G._discoC or {}) do
            pcall(function() if o.Parent then o.Color=c end end)
        end
    end
end

FEATURE_HANDLERS.spinbot=function(on)
    if _G._spinConn then _G._spinConn:Disconnect() _G._spinConn=nil end
    if on then
        _G._spinConn=RunService.Heartbeat:Connect(function()
            local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(30),0) end
        end)
    end
end

FEATURE_HANDLERS.randcolors=function(on)
    if _G._randConn then _G._randConn:Disconnect() _G._randConn=nil end
    if on then
        _G._randOrig={}
        _G._randParts={}
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                _G._randOrig[v]=v.Color
                table.insert(_G._randParts,v)
            end
        end
        _G._randConn=RunService.Heartbeat:Connect(function()
            for _,v in ipairs(_G._randParts) do
                if v.Parent and math.random()<0.05 then
                    v.Color=Color3.new(math.random(),math.random(),math.random())
                end
            end
        end)
    else
        for o,c in pairs(_G._randOrig or {}) do
            pcall(function() if o.Parent then o.Color=c end end)
        end
    end
end

FEATURE_HANDLERS.grayscale=function(on)
    local old=Lighting:FindFirstChild("OkayGrayCC")
    if old then old:Destroy() end
    if on then
        local cc=Instance.new("ColorCorrectionEffect",Lighting)
        cc.Name="OkayGrayCC"
        cc.Saturation=-1
    end
end

FEATURE_HANDLERS.camspin=function(on)
    if _G._camConn then _G._camConn:Disconnect() _G._camConn=nil end
    if on then
        _G._camConn=RunService.RenderStepped:Connect(function(dt)
            local cam=workspace.CurrentCamera
            if cam then cam.CFrame=cam.CFrame*CFrame.Angles(0,dt*2,0) end
        end)
    end
end

FEATURE_HANDLERS.fake=function(on) end

BUTTON_HANDLERS.SitForever=function()
    local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.Sit=true end
    Notify.Show("sit","you are now sitting. forever.",2)
end

BUTTON_HANDLERS.DanceForever=function()
    Notify.Show("dance","this does nothing lol",2)
end

BUTTON_HANDLERS.FreezeSelf=function()
    local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Anchored=true
        task.delay(3,function() if hrp and hrp.Parent then hrp.Anchored=false end end)
    end
    Notify.Show("freeze","3 seconds",2)
end

BUTTON_HANDLERS.RandomTP=function()
    local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame=CFrame.new(
            math.random(-500,500),
            math.random(0,200),
            math.random(-500,500)
        )
    end
    Notify.Show("tp","good luck",2)
end

BUTTON_HANDLERS.AnnoyingSound=function()
    local s=Instance.new("Sound",workspace)
    s.SoundId="rbxassetid://12221967"
    s.Volume=3
    s:Play()
    task.delay(2,function() if s.Parent then s:Destroy() end end)
end

BUTTON_HANDLERS.Nothing=function() end
BUTTON_HANDLERS.FakeError=function()
    Notify.Show("ERROR","something went wrong (jk)",3)
end

function makeCard(item)
    local card=Instance.new("Frame",cardScroll)
    card.BackgroundColor3=Color3.fromRGB(255,255,255)
    card.BorderSizePixel=1
    card.BorderColor3=Color3.fromRGB(180,180,180)

    local nameLbl=Instance.new("TextLabel",card)
    nameLbl.Size=UDim2.new(1,-8,0,12)
    nameLbl.Position=UDim2.new(0,4,0,2)
    nameLbl.BackgroundTransparency=1
    nameLbl.Text=item.name
    nameLbl.TextColor3=Color3.fromRGB(0,0,0)
    nameLbl.Font=Enum.Font.SourceSansBold
    nameLbl.TextSize=10
    nameLbl.TextXAlignment=Enum.TextXAlignment.Left
    nameLbl.TextTruncate=Enum.TextTruncate.AtEnd

    local descLbl=Instance.new("TextLabel",card)
    descLbl.Size=UDim2.new(1,-8,0,10)
    descLbl.Position=UDim2.new(0,4,0,16)
    descLbl.BackgroundTransparency=1
    descLbl.Text=item.desc
    descLbl.TextColor3=Color3.fromRGB(120,120,120)
    descLbl.Font=Enum.Font.SourceSans
    descLbl.TextSize=8
    descLbl.TextXAlignment=Enum.TextXAlignment.Left
    descLbl.TextTruncate=Enum.TextTruncate.AtEnd

    local click=Instance.new("TextButton",card)
    click.Size=UDim2.new(1,0,1,0)
    click.BackgroundTransparency=1
    click.Text=""
    click.ZIndex=40

    click.MouseButton1Click:Connect(function()
        if item.type=="toggle" then
            TogglesState[item.key]=not TogglesState[item.key]
            Notify.Show(item.name,TogglesState[item.key] and "on" or "off",1.5)
            if FEATURE_HANDLERS[item.key] then pcall(FEATURE_HANDLERS[item.key],TogglesState[item.key]) end
        elseif item.type=="load" then
            Notify.Show(item.name,"loading (maybe)",1.5)
            task.spawn(function()
                local ok,code=pcall(function() return game:HttpGet(item.url) end)
                if ok and code then local f=loadstring(code) if f then pcall(f) end end
            end)
        elseif item.type=="button" then
            if BUTTON_HANDLERS[item.fn] then pcall(BUTTON_HANDLERS[item.fn]) end
        end
    end)

    return card
end

renderContent=function()
    for _,c in ipairs(cardScroll:GetChildren()) do
        if c:IsA("Frame") or c:IsA("UIGridLayout") then c:Destroy() end
    end
    local f=FEATURES[activeTab]
    if not f then return end
    secTitle.Text=f.title
    secSub.Text=f.sub

    local g=Instance.new("UIGridLayout",cardScroll)
    g.CellSize=UDim2.new(0.5,-3,0,30)
    g.CellPadding=UDim.new(0,4,0,4)
    g.SortOrder=Enum.SortOrder.LayoutOrder

    for _,item in ipairs(f.items) do
        makeCard(item)
    end
end

toggleGui=Instance.new("ScreenGui")
toggleGui.Name="OkayGlassToggle"
toggleGui.ResetOnSpawn=false
toggleGui.IgnoreGuiInset=true
toggleGui.Parent=guiParent
tScale=Instance.new("UIScale",toggleGui)
tScale.Scale=currentScale

toggle=Instance.new("TextButton",toggleGui)
toggle.AnchorPoint=Vector2.new(0,0.5)
toggle.Position=UDim2.new(0,25,0.5,0)
toggle.Size=UDim2.new(0,50,0,50)
toggle.BackgroundColor3=Color3.fromRGB(255,255,255)
toggle.BorderSizePixel=2
toggle.BorderColor3=Color3.fromRGB(0,0,0)
toggle.Text="O"
toggle.TextColor3=Color3.fromRGB(0,0,0)
toggle.Font=Enum.Font.SourceSansBold
toggle.TextSize=22
toggle.AutoButtonColor=false

isOpen=false

function show()
    if isOpen then return end
    wrap.Visible=true
    wrap.Position=UDim2.new(0,math.random(50,400),0,math.random(50,300))
    wrap.Size=UDim2.new(0,WIN_W*0.5,0,WIN_H*0.5)
    isOpen=true
    Notify.Show("loaded","good luck finding the hub",2)
end

function hide()
    wrap.Visible=false
end

toggle.MouseButton1Click:Connect(function()
    if not wrap.Visible then
        show()
    else
        Notify.Show("hub","already open (bugged)",1)
    end
end)

close.MouseButton1Click:Connect(function()
    wrap.Visible=false
end)

renderContent()
Notify.Show("okay hub","v0.4 loaded",3)
print("[okay hub v0.4] loaded")
