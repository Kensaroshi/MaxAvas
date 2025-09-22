loadstring([[
-- Services
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "Elcha_Matin_GUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Floating Button
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 80, 0, 40)
floatBtn.Position = UDim2.new(0, 40, 0, 40)
floatBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
floatBtn.BorderSizePixel = 0
floatBtn.Text = "Menu"
floatBtn.TextColor3 = Color3.fromRGB(255,255,255)
floatBtn.TextScaled = true
floatBtn.AutoButtonColor = false
floatBtn.Parent = gui
Instance.new("UICorner", floatBtn)

-- Main Menu Frame
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 300, 0, 350)
menu.Position = UDim2.new(0, 40, 0, 90)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.BackgroundTransparency = 1
menu.Visible = false
menu.Parent = gui
Instance.new("UICorner", menu)

-- Tab Buttons Frame
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1,0,0,40)
tabFrame.Position = UDim2.new(0,0,0,0)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = menu

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1,0,1,-40)
contentFrame.Position = UDim2.new(0,0,0,40)
contentFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
contentFrame.Parent = menu
Instance.new("UICorner", contentFrame)

-- Function to create Tab Buttons
local function createTabButton(name,posX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 30)
    btn.Position = UDim2.new(0, posX, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = name
    btn.Parent = tabFrame
    Instance.new("UICorner", btn)
    return btn
end

local homeBtn = createTabButton("Home",10)
local localPlayerBtn = createTabButton("LocalPlayer",110)
local settingsBtn = createTabButton("Settings",210)

-- Content Pages
local homePage = Instance.new("Frame")
homePage.Size = UDim2.new(1,0,1,0)
homePage.BackgroundTransparency = 1
homePage.Parent = contentFrame

local localPlayerPage = Instance.new("Frame")
localPlayerPage.Size = UDim2.new(1,0,1,0)
localPlayerPage.BackgroundTransparency = 1
localPlayerPage.Visible = false
localPlayerPage.Parent = contentFrame

local settingsPage = Instance.new("Frame")
settingsPage.Size = UDim2.new(1,0,1,0)
settingsPage.BackgroundTransparency = 1
settingsPage.Visible = false
settingsPage.Parent = contentFrame

-- Tab Switching Logic
local function showPage(page)
    homePage.Visible = false
    localPlayerPage.Visible = false
    settingsPage.Visible = false
    page.Visible = true
end

homeBtn.MouseButton1Click:Connect(function() showPage(homePage) end)
localPlayerBtn.MouseButton1Click:Connect(function() showPage(localPlayerPage) end)
settingsBtn.MouseButton1Click:Connect(function() showPage(settingsPage) end)

-- Drag Function
local function makeDraggable(frame)
    local dragging=false
    local dragInput, mousePos, framePos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            mousePos=input.Position
            framePos=frame.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then
                    dragging=false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement then
            dragInput=input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input==dragInput and dragging then
            local delta=input.Position-mousePos
            frame.Position=UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset+delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset+delta.Y
            )
        end
    end)
end

makeDraggable(floatBtn)
makeDraggable(menu)

-- Toggle Menu Fade
local function ToggleMenu()
    if menu.Visible==false then
        menu.Visible=true
        TweenService:Create(menu,TweenInfo.new(0.3),{BackgroundTransparency=0}):Play()
        TweenService:Create(contentFrame,TweenInfo.new(0.3),{BackgroundTransparency=0}):Play()
    else
        TweenService:Create(menu,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        TweenService:Create(contentFrame,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        task.delay(0.3,function() menu.Visible=false end)
    end
end

floatBtn.MouseButton1Click:Connect(ToggleMenu)
UIS.InputBegan:Connect(function(input,gp)
    if not gp and input.KeyCode==Enum.KeyCode.G then
        ToggleMenu()
    end
end)

-- ESP in Home Page
local espEnabled=false
local espObjects={}

local function createESP(plr)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local box=Instance.new("BoxHandleAdornment")
        box.Adornee=plr.Character.HumanoidRootPart
        box.Size=Vector3.new(2,3,1)
        box.Color3=Color3.fromRGB(255,255,255)
        box.AlwaysOnTop=true
        box.Transparency=0.8
        box.ZIndex=10
        box.LineThickness=0.1 -- ขอบบาง
        box.Parent=gui

        local nameLabel=Instance.new("BillboardGui")
        nameLabel.Size=UDim2.new(0,100,0,30)
        nameLabel.Adornee=plr.Character:FindFirstChild("Head")
        nameLabel.AlwaysOnTop=true
        nameLabel.MaxDistance=100
        nameLabel.Parent=gui

        local textLabel=Instance.new("TextLabel")
        textLabel.Size=UDim2.new(1,0,1,0)
        textLabel.BackgroundTransparency=1
        textLabel.Text=plr.Name
        textLabel.TextColor3=Color3.fromRGB(255,255,255)
        textLabel.Font=Enum.Font.GothamBold
        textLabel.TextScaled=true
        textLabel.Parent=nameLabel

        espObjects[plr]={Box=box,NameLabel=nameLabel}
    end
end

RS.RenderStepped:Connect(function()
    if espEnabled then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr~=player and not espObjects[plr] then
                createESP(plr)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if espObjects[plr] then
        if espObjects[plr].Box then espObjects[plr].Box:Destroy() end
        if espObjects[plr].NameLabel then espObjects[plr].NameLabel:Destroy() end
        espObjects[plr]=nil
    end
end)

-- ESP Toggle Button in Home
local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0, 140, 0, 40)
espToggle.Position = UDim2.new(0,20,0,20)
espToggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
espToggle.BorderSizePixel = 0
espToggle.TextColor3 = Color3.fromRGB(255,255,255)
espToggle.Font = Enum.Font.GothamBold
espToggle.Text = "ESP OFF"
espToggle.Parent = homePage
Instance.new("UICorner", espToggle)

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = espEnabled and "ESP ON" or "ESP OFF"
    if not espEnabled then
        for _, obj in pairs(espObjects) do
            if obj.Box then obj.Box:Destroy() end
            if obj.NameLabel then obj.NameLabel:Destroy() end
        end
        espObjects = {}
    end
end)

-- Reload GUI on respawn
player.CharacterAdded:Connect(function()
    gui:Destroy()
    task.delay(0.1,function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Kensaroshi/MaxAvas/refs/heads/main/Elcha-Matin.lua",true))()
    end)
end)
]])()
