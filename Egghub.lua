
local Players = game:GetService("Players")
local gui = Instance.new("ScreenGui")
gui.Name = "EggHub"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(280, 220)
main.Position = UDim2.new(0.5, -140, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "EGG HUB"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextSize = 20
title.Parent = main

local function addButton(name, y)
    local on = false
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = UDim2.fromOffset(10, y)
    b.Text = name
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    b.Parent = main
    b.MouseButton1Click:Connect(function()
        on = not on
        b.BackgroundColor3 = on
            and Color3.fromRGB(30, 130, 70)
            or Color3.fromRGB(45, 45, 60)
    end)
end

addButton("Event Tracker", 50)
addButton("Admin Abuse", 95)
addButton("Auto Best Egg (UI)", 140)
