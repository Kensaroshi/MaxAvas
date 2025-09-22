-- esp_gui_improved.lua
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ESP_GUI"
gui.Parent = player:WaitForChild("PlayerGui")

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")

-- Floating Button (ซ้ายบน)
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 80, 0, 40)
floatBtn.Position = UDim2.new(0, 20, 0, 20)
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
menu.Position = UDim2.new(0, 20, 0, 70)
menu.BackgroundColor3 = Color3.fromRGB(40,40,40)
menu.Visible = false
menu.Parent = gui
Instance.new("UICorner", menu)

-- ESP Toggle
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

-- Floating Button Click (Animation)
local tweenService = game:GetService("TweenService")
floatBtn.MouseButton1Click:Connect(function()
    menu.Visible = true
    local goal = {Position = UDim2.new(menu.Position.X.Scale, menu.Position.X.Offset, menu.Position.Y.Scale, menu.Position.Y.Offset)}
    local tween = tweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Quad), goal)
    tween:Play()
    menu.Visible = not menu.Visible
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

-- Function สร้าง ESP Outline
local function createESP(plr)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        -- Outline (SurfaceGui + UIStroke)
        local boxGui = Instance.new("SurfaceGui")
        boxGui.Adornee = plr.Character.HumanoidRootPart
        boxGui.AlwaysOnTop = true
        boxGui.Face = Enum.NormalId.Top
        boxGui.Parent = gui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,0,1,0)
        frame.BackgroundTransparency = 1
        frame.Parent = boxGui

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(255,0,0)
        stroke.Parent = frame

        -- Name Label
        local nameBillboard = Instance.new("BillboardGui")
        nameBillboard.Adornee = plr.Character:FindFirstChild("Head")
        nameBillboard.Size = UDim2.new(0,100,0,30)
        nameBillboard.AlwaysOnTop = true
        nameBillboard.MaxDistance = 100
        nameBillboard.Parent = gui

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1,0,1,0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = plr.Name
        textLabel.TextColor3 = Color3.fromRGB(255,255,255)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextScaled = true
        textLabel.Parent = nameBillboard

        espObjects[plr] = {Box=boxGui, NameLabel=nameBillboard}
    end
end

RS.RenderStepped:Connect(function()
    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                if not espObjects[plr] then
                    createESP(plr)
                end
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

-- รันซ้ำเวลาตาย
player.CharacterAdded:Connect(function()
    gui:Destroy()
    wait(0.1)
    loadstring(game:HttpGet("YOUR_RAW_URL_HERE",true))()
end)
