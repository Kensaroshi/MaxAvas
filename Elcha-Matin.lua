-- Full GUI: Elcha-Matin with ESP (TPWalk removed)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "Elcha_Matin_GUI"
gui.ResetOnSpawn = false

-- Floating Button
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0,80,0,40)
floatBtn.Position = UDim2.new(0,40,0,40)
floatBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
floatBtn.Text = "Menu"
floatBtn.TextColor3 = Color3.fromRGB(255,255,255)
floatBtn.Font = Enum.Font.Gotham
floatBtn.TextScaled = true
floatBtn.Parent = gui
Instance.new("UICorner", floatBtn)
local fbStroke = Instance.new("UIStroke", floatBtn)
fbStroke.Thickness = 0.5
fbStroke.Color = Color3.fromRGB(255,255,255)

-- Menu Frame
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0,300,0,350)
menu.Position = UDim2.new(0,40,0,90)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.BackgroundTransparency = 1
menu.Visible = false
menu.Parent = gui
Instance.new("UICorner", menu)
local menuStroke = Instance.new("UIStroke", menu)
menuStroke.Thickness = 0.5
menuStroke.Color = Color3.fromRGB(255,255,255)

-- Tabs
local tabFrame = Instance.new("Frame", menu)
tabFrame.Size = UDim2.new(1,0,0,40)
tabFrame.BackgroundTransparency = 1
local contentFrame = Instance.new("Frame", menu)
contentFrame.Size = UDim2.new(1,0,1,-40)
contentFrame.Position = UDim2.new(0,0,0,40)
contentFrame.BackgroundTransparency = 1

local function createTab(name,x)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,80,0,30)
    btn.Position = UDim2.new(0,x,0,5)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.Parent = tabFrame
    Instance.new("UICorner", btn)
    local s = Instance.new("UIStroke", btn)
    s.Thickness = 0.5
    s.Color = Color3.fromRGB(255,255,255)
    return btn
end

local homeBtn = createTab("Home",10)
local lpBtn = createTab("Local",110)
local setBtn = createTab("Settings",210)

-- Pages
local homePage = Instance.new("Frame", contentFrame)
homePage.Size = UDim2.new(1,0,1,0)
homePage.BackgroundTransparency = 1

local lpPage = Instance.new("Frame", contentFrame)
lpPage.Size = UDim2.new(1,0,1,0)
lpPage.BackgroundTransparency = 1
lpPage.Visible=false

local setPage = Instance.new("Frame", contentFrame)
setPage.Size = UDim2.new(1,0,1,0)
setPage.BackgroundTransparency = 1
setPage.Visible=false

local function showPage(page)
    homePage.Visible=false
    lpPage.Visible=false
    setPage.Visible=false
    page.Visible=true
end
homeBtn.MouseButton1Click:Connect(function() showPage(homePage) end)
lpBtn.MouseButton1Click:Connect(function() showPage(lpPage) end)
setBtn.MouseButton1Click:Connect(function() showPage(setPage) end)

-- Dragging
local function makeDraggable(obj)
    local drag=false; local startPos; local startInput
    obj.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true; startPos=obj.Position; startInput=input.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then drag=false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and input.UserInputType==Enum.UserInputType.MouseMovement then
            local delta=input.Position-startInput
            obj.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end
makeDraggable(floatBtn)
makeDraggable(menu)

-- Toggle Menu (Fade)
local menuOpen=false
local tweenInfo = TweenInfo.new(0.25,Enum.EasingStyle.Linear)
local function toggleMenu()
    menuOpen = not menuOpen
    if menuOpen then
        menu.Visible=true
        TweenService:Create(menu,tweenInfo,{BackgroundTransparency=0.3}):Play()
    else
        local tw = TweenService:Create(menu,tweenInfo,{BackgroundTransparency=1})
        tw:Play()
        tw.Completed:Connect(function()
            if not menuOpen then menu.Visible=false end
        end)
    end
end
floatBtn.MouseButton1Click:Connect(toggleMenu)
UIS.InputBegan:Connect(function(input,gp)
    if not gp and input.KeyCode==Enum.KeyCode.G then toggleMenu() end
end)

-- ESP
local espEnabled=false
local espList={}
local function addESP(plr)
    if plr.Character and not espList[plr] then
        local h=Instance.new("Highlight")
        h.Adornee=plr.Character
        h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        h.FillTransparency=1
        h.OutlineColor=Color3.fromRGB(255,255,255)
        h.OutlineTransparency=0
        h.Parent=gui
        espList[plr]=h
    end
end
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() if espEnabled then addESP(plr) end end)
end)
Players.PlayerRemoving:Connect(function(plr)
    if espList[plr] then espList[plr]:Destroy(); espList[plr]=nil end
end)

local espBtn = Instance.new("TextButton", homePage)
espBtn.Size = UDim2.new(0,140,0,40)
espBtn.Position = UDim2.new(0,20,0,20)
espBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
espBtn.Text = "ESP OFF"
espBtn.TextColor3 = Color3.fromRGB(255,255,255)
espBtn.Font = Enum.Font.Gotham
espBtn.TextScaled = true
Instance.new("UICorner", espBtn)
local espStroke = Instance.new("UIStroke", espBtn)
espStroke.Thickness=0.5
espStroke.Color = Color3.fromRGB(255,255,255)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ESP ON" or "ESP OFF"
    if espEnabled then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr~=player then addESP(plr) end
        end
    else
        for _,h in pairs(espList) do h:Destroy() end
        espList={}
    end
end)
