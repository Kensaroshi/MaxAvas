-- esp_gui.lua (ตัวอย่างล่าสุด)
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ESP_GUI"

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")

-- Floating Button
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 80, 0, 40)
floatBtn.Position = UDim2.new(0.5, -40, 0.5, -20)
floatBtn.AnchorPoint = Vector2.new(0.5,0.5)
floatBtn.BackgroundColor3 = Color3.fromRGB(200,200,255)
floatBtn.BackgroundTransparency = 0.3
floatBtn.BorderSizePixel = 0
floatBtn.Text = "Menu"
floatBtn.TextColor3 = Color3.new(1,1,1)
floatBtn.TextScaled = true
floatBtn.AutoButtonColor = false
floatBtn.Parent = gui
local UICornerBtn = Instance.new("UICorner", floatBtn)

-- Menu
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 180, 0, 120)
menu.Position = UDim2.new(0.5, -90, 0.5, 40)
menu.BackgroundColor3 = Color3.fromRGB(240,240,240)
menu.Visible = false
menu.Parent = gui
local menuCorner = Instance.new("UICorner", menu)

-- ESP Toggle
local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0, 140, 0, 40)
espToggle.Position = UDim2.new(0, 20, 0, 30)
espToggle.BackgroundColor3 = Color3.fromRGB(100,200,255)
espToggle.TextColor3 = Color3.new(1,1,1)
espToggle.Font = Enum.Font.GothamBold
espToggle.Text = "ESP OFF"
espToggle.Parent = menu
local espCorner = Instance.new("UICorner", espToggle)

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

-- Floating Button Click
floatBtn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- ESP Logic
local espEnabled = false
local espObjects = {}

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = espEnabled and "ESP ON" or "ESP OFF"

    if not espEnabled then
        -- ลบ ESP ทุกตัวเมื่อปิด
        for _, obj in pairs(espObjects) do
            if obj.Box then obj.Box:Destroy() end
            if obj.NameLabel then obj.NameLabel:Destroy() end
        end
        espObjects = {}
    end
end)

-- อัปเดต ESP ทุกเฟรม
RS.RenderStepped:Connect(function()
    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if not espObjects[plr] then
                    -- Box Outline
                    local box = Instance.new("BoxHandleAdornment")
                    box.Adornee = plr.Character.HumanoidRootPart
                    box.Size = Vector3.new(2,3,1)
                    box.Color3 = Color3.fromRGB(255,0,0)
                    box.AlwaysOnTop = true
                    box.Transparency = 0.5
                    box.ZIndex = 10
                    box.Parent = gui

                    -- Name Label
                    local nameLabel = Instance.new("BillboardGui")
                    nameLabel.Size = UDim2.new(0,100,0,30)
                    nameLabel.Adornee = plr.Character:FindFirstChild("Head")
                    nameLabel.AlwaysOnTop = true
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
        end
    end
end)

-- Remove ESP objects if player leaves
Players.PlayerRemoving:Connect(function(plr)
    if espObjects[plr] then
        if espObjects[plr].Box then espObjects[plr].Box:Destroy() end
        if espObjects[plr].NameLabel then espObjects[plr].NameLabel:Destroy() end
        espObjects[plr] = nil
    end
end)
