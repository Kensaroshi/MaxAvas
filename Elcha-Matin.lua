-- Elcha-Matin.lua (Loadstring Ready)

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
floatBtn.Position = UDim2.new(0, 30, 0, 30) -- ซ้ายบน ลดมาซ้ายอีกนิด
floatBtn.AnchorPoint = Vector2.new(0,0)
floatBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
floatBtn.BackgroundTransparency = 0.1
floatBtn.BorderSizePixel = 0
floatBtn.Text = "Menu"
floatBtn.TextColor3 = Color3.fromRGB(255,255,255)
floatBtn.TextScaled = true
floatBtn.AutoButtonColor = false
floatBtn.Parent = gui
Instance.new("UICorner", floatBtn)

-- Menu
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 180, 0, 120)
menu.Position = UDim2.new(0, 30, 0, 80)
menu.BackgroundColor3 = Color3.fromRGB(40,40,40)
menu.BackgroundTransparency = 1 -- เริ่มโปร่งสำหรับ fade
menu.Visible = false
menu.Parent = gui
Instance.new("UICorner", menu)

-- ESP Toggle Button
local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0, 140, 0, 40)
espToggle.Position = UDim2.new(0, 20, 0, 30)
espToggle.BackgroundColor3 = Color3.fromRGB(0,122,255)
espToggle.TextColor3 = Color3.fromRGB(255,255,255)
espToggle.Font = Enum.Font.GothamBold
espToggle.Text = "ESP OFF"
espToggle.Parent = menu
Instance.new("UICorner", espToggle)

-- Drag Function
local function makeDraggable(frame)
    local dragging = false
    local dragInput, mousePos, framePos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(floatBtn)
makeDraggable(menu)

-- Toggle Menu (Fade In/Out)
local function ToggleMenu()
    if menu.Visible == false then
        menu.Visible = true
        TweenService:Create(menu, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    else
        TweenService:Create(menu, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.delay(0.3, function() menu.Visible = false end)
    end
end

-- Connect Button & Hotkey G
floatBtn.MouseButton1Click:Connect(ToggleMenu)
UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.G then
        ToggleMenu()
    end
end)

-- ESP Logic
local espEnabled = false
local espObjects = {}

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

local function createESP(plr)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        -- Outline Box (ขอบเฉพาะ)
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = plr.Character.HumanoidRootPart
        box.Size = Vector3.new(2,3,1)
        box.Color3 = Color3.fromRGB(255,0,0)
        box.AlwaysOnTop = true
        box.Transparency = 0.5
        box.ZIndex = 10
        box.Parent = gui
        box.LineThickness = 0.1 -- บางแต่ชัด

        -- Name Label
        local nameLabel = Instance.new("BillboardGui")
        nameLabel.Size = UDim2.new(0,100,0,30)
        nameLabel.Adornee = plr.Character:FindFirstChild("Head")
        nameLabel.AlwaysOnTop = true
        nameLabel.MaxDistance = 100
        nameLabel.Parent = gui

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1,0,1,0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = plr.Name
        textLabel.TextColor3 = Color3.fromRGB(255,255,255)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextScaled = true
        textLabel.Parent = nameLabel

        espObjects[plr] = {Box=box, NameLabel=nameLabel}
    end
end

RS.RenderStepped:Connect(function()
    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and not espObjects[plr] then
                createESP(plr)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if espObjects[plr] then
        if espObjects[plr].Box then espObjects[plr].Box:Destroy() end
        if espObjects[plr].NameLabel then espObjects[plr].NameLabel:Destroy() end
        espObjects[plr] = nil
    end
end)

-- Reload GUI on respawn
player.CharacterAdded:Connect(function()
    gui:Destroy()
    task.delay(0.1,function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Kensaroshi/MaxAvas/refs/heads/main/Elcha-Matin.lua", true))()
    end)
end)
