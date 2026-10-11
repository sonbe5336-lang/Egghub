
-- EGG HUB v2.0 | VI / EN
-- Safe egg and money tracker UI
-- No exploit, auto-farming, or unauthorized ESP.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

local old = guiParent:FindFirstChild("EggHubUI")
if old then old:Destroy() end

local lang = "VI"
local page = "home"
local minimized = false
local eggs = {}
local money = 0
local moneyStart = 0
local searchText = ""

local function tr(vi, en)
    return lang == "VI" and vi or en
end

local gui = Instance.new("ScreenGui")
gui.Name = "EggHubUI"
gui.ResetOnSpawn = false
gui.Parent = guiParent

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(520, 410)
main.Position = UDim2.new(0.5, -260, 0.5, -205)
main.BackgroundColor3 = Color3.fromRGB(19, 22, 34)
main.BorderSizePixel = 0
main.Parent = gui

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end
corner(main, 14)

local outline = Instance.new("UIStroke")
outline.Color = Color3.fromRGB(99, 111, 255)
outline.Transparency = 0.35
outline.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(30, 35, 54)
header.BorderSizePixel = 0
header.Parent = main
corner(header, 14)

local title = Instance.new("TextLabel")
title.Position = UDim2.fromOffset(16, 7)
title.Size = UDim2.new(1, -150, 0, 26)
title.BackgroundTransparency = 1
title.Text = "🥚 EGG HUB"
title.TextColor3 = Color3.fromRGB(239, 242, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 21
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Position = UDim2.fromOffset(18, 34)
subtitle.Size = UDim2.new(1, -150, 0, 17)
subtitle.BackgroundTransparency = 1
subtitle.Text = tr("Egg & tiền tracker", "Egg & money tracker")
subtitle.TextColor3 = Color3.fromRGB(164, 173, 199)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 11
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local function button(parent, text, size, pos, color)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = color or Color3.fromRGB(46, 54, 81)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(242, 244, 255)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 12
    b.AutoButtonColor = true
    b.Parent = parent
    corner(b, 8)
    return b
end

local langBtn = button(header, "VI / EN",
    UDim2.fromOffset(65, 30), UDim2.new(1, -105, 0, 15))
local minBtn = button(header, "—",
    UDim2.fromOffset(28, 30), UDim2.new(1, -34, 0, 15))

-- Dragging support: mouse and touch.
local dragging, dragInput, dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local body = Instance.new("Frame")
body.Position = UDim2.fromOffset(10, 70)
body.Size = UDim2.new(1, -20, 1, -80)
body.BackgroundTransparency = 1
body.Parent = main

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 125, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(26, 30, 45)
sidebar.BorderSizePixel = 0
sidebar.Parent = body
corner(sidebar, 10)

local content = Instance.new("ScrollingFrame")
content.Position = UDim2.fromOffset(135, 0)
content.Size = UDim2.new(1, -135, 1, 0)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new()
content.Parent = body

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = content

local contentPad = Instance.new("UIPadding")
contentPad.PaddingLeft = UDim.new(0, 4)
contentPad.PaddingRight = UDim.new(0, 4)
contentPad.PaddingBottom = UDim.new(0, 10)
contentPad.Parent = content

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        if child ~= contentLayout and child ~= contentPad then
            child:Destroy()
        end
    end
end

local function label(text, height, color, bold)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -4, 0, height or 30)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextWrapped = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextSize = 12
    l.TextColor3 = color or Color3.fromRGB(230, 234, 248)
    l.Parent = content
    return l
end

local function inputBox(placeholder, initial)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -4, 0, 36)
    box.BackgroundColor3 = Color3.fromRGB(32, 38, 57)
    box.BorderSizePixel = 0
    box.PlaceholderText = placeholder
    box.Text = initial or ""
    box.TextColor3 = Color3.fromRGB(240, 243, 255)
    box.PlaceholderColor3 = Color3.fromRGB(148, 157, 183)
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.ClearTextOnFocus = false
    box.Parent = content
    corner(box, 8)
    return box
end

local function render()
    clearContent()

    if page == "home" then
        label(tr("TỔNG QUAN", "DASHBOARD"), 30,
            Color3.fromRGB(143, 155, 255), true)
        label(tr("Số trứng trong danh sách: ", "Eggs in list: ")
            .. #eggs, 28)
        label(tr("Tiền hiện tại: ", "Current money: ")
            .. tostring(money), 28)
        label(tr("Thay đổi tiền: ", "Money change: ")
            .. tostring(money - moneyStart), 28)
        label(tr("Các số liệu là do bạn tự nhập.",
            "Values are entered manually."), 40,
            Color3.fromRGB(157, 202, 177))
        local best
        for _, egg in ipairs(eggs) do
            if not best or egg.value > best.value then
                best = egg
            end
        end
        label(tr("Trứng giá trị cao nhất: ",
            "Highest-value egg: ") ..
            (best and (best.name .. " (" .. best.value .. ")")
            or tr("Chưa có dữ liệu", "No data yet")), 45)
    elseif page == "eggs" then
        label(tr("QUẢN LÝ TRỨNG", "EGG TRACKER"), 30,
            Color3.fromRGB(143, 155, 255), true)
        label(tr("Tên trứng", "Egg name"), 22)
        local nameBox = inputBox(
            tr("Ví dụ: Golden Egg", "Example: Golden Egg"))
        label(tr("Giá trị trứng", "Egg value"), 22)
        local valueBox = inputBox("0")

        button(content, tr("THÊM TRỨNG", "ADD EGG"),
            UDim2.new(1, -4, 0, 36), UDim2.new(),
            Color3.fromRGB(77, 91, 192)).Activated:Connect(function()
                local name = nameBox.Text
                local value = tonumber(valueBox.Text)
                if name ~= "" and value and value >= 0 then
                    table.insert(eggs, {name = name, value = value})
                    render()
                end
            end)

        local search = inputBox(tr("Tìm trứng...", "Search eggs..."),
            searchText)
        search:GetPropertyChangedSignal("Text"):Connect(function()
            searchText = search.Text
            -- Filter is applied when the list is redrawn.
        end)

        button(content, tr("LÀM MỚI DANH SÁCH", "REFRESH LIST"),
            UDim2.new(1, -4, 0, 34), UDim2.new()).Activated:Connect(render)

        local filtered = {}
        for _, egg in ipairs(eggs) do
            if searchText == ""
                or string.find(string.lower(egg.name),
                    string.lower(searchText), 1, true) then
                table.insert(filtered, egg)
            end
        end

        table.sort(filtered, function(a, b)
            return a.value > b.value
        end)

        if #filtered == 0 then
            label(tr("Chưa có trứng phù hợp.", "No matching eggs."), 30)
        end

        for index, egg in ipairs(filtered) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -4, 0, 42)
            row.BackgroundColor3 = Color3.fromRGB(31, 37, 56)
            row.BorderSizePixel = 0
            row.Parent = content
            corner(row, 8)

            local text = Instance.new("TextLabel")
            text.Position = UDim2.fromOffset(9, 0)
            text.Size = UDim2.new(1, -75, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = egg.name .. "  |  " .. tostring(egg.value)
            text.TextColor3 = Color3.fromRGB(235, 239, 255)
            text.Font = Enum.Font.Gotham
            text.TextSize = 11
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.Parent = row

            local del = button(row, "X",
                UDim2.fromOffset(30, 26),
                UDim2.new(1, -38, 0, 8),
                Color3.fromRGB(142, 55, 70))
            del.Activated:Connect(function()
                for i, existing in ipairs(eggs) do
                    if existing == egg then
                        table.remove(eggs, i)
                        break
                    end
                end
                render()
            end)
        end
    elseif page == "money" then
        label(tr("THEO DÕI TIỀN", "MONEY TRACKER"), 30,
            Color3.fromRGB(143, 155, 255), true)
        label(tr("Tiền hiện tại: ", "Current money: ")
            .. tostring(money), 28)
        label(tr("Tăng/giảm so với ban đầu: ",
            "Change since starting: ") ..
            tostring(money - moneyStart), 36)
        label(tr("Nhập số tiền hiện tại", "Enter current money"), 25)
        local amount = inputBox("0", tostring(money))

        button(content, tr("CẬP NHẬT TIỀN", "UPDATE MONEY"),
            UDim2.new(1, -4, 0, 36), UDim2.new(),
            Color3.fromRGB(77, 91, 192)).Activated:Connect(function()
                local n = tonumber(amount.Text)
                if n and n >= 0 then
                    money = n
                    render()
                end
            end)

        button(content, tr("ĐẶT MỐC BAN ĐẦU", "SET BASELINE"),
            UDim2.new(1, -4, 0, 36), UDim2.new()).Activated:Connect(function()
                moneyStart = money
                render()
            end)
    elseif page == "settings" then
        label(tr("CÀI ĐẶT", "SETTINGS"), 30,
            Color3.fromRGB(143, 155, 255), true)
        button(content, tr("Đổi ngôn ngữ VI / EN",
            "Switch language VI / EN"),
            UDim2.new(1, -4, 0, 38), UDim2.new()).Activated:Connect(function()
                lang = lang == "VI" and "EN" or "VI"
                renderAll()
            end)
        button(content, tr("Xóa toàn bộ dữ liệu tracker",
            "Clear all tracker data"),
            UDim2.new(1, -4, 0, 38), UDim2.new(),
            Color3.fromRGB(142, 55, 70)).Activated:Connect(function()
                eggs = {}
                money = 0
                moneyStart = 0
                searchText = ""
                render()
            end)
        label(tr("Dữ liệu chỉ được lưu trong phiên hiện tại.",
            "Data is kept only for this session."), 42)
    end
end

local function renderAll()
    subtitle.Text = tr("Egg & tiền tracker", "Egg & money tracker")
    for _, child in ipairs(sidebar:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    local tabs = {
        {"home", tr("Trang chủ", "Home")},
        {"eggs", tr("Danh sách trứng", "Egg tracker")},
        {"money", tr("Theo dõi tiền", "Money tracker")},
        {"settings", tr("Cài đặt", "Settings")},
    }

    for i, tab in ipairs(tabs) do
        local b = button(sidebar, tab[2],
            UDim2.new(1, -12, 0, 37),
            UDim2.new(0, 6, 0, 8 + (i - 1) * 45))
        b.BackgroundColor3 = page == tab[1]
            and Color3.fromRGB(76, 91, 190)
            or Color3.fromRGB(43, 50, 73)
        b.Activated:Connect(function()
            page = tab[1]
            renderAll()
        end)
    end
    render()
end

langBtn.Activated:Connect(function()
    lang = lang == "VI" and "EN" or "VI"
    renderAll()
end)

minBtn.Activated:Connect(function()
    minimized = not minimized
    body.Visible = not minimized
    main.Size = minimized
        and UDim2.fromOffset(520, 60)
        or UDim2.fromOffset(520, 410)
    minBtn.Text = minimized and "+" or "—"
end)

renderAll()
