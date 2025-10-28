--// Noctics Hub - Fish It Script
print("🎣 Noctics Hub - Fish It Loaded")

-- Fungsi notifikasi cepat (versi lokal)
local function notif(msg)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Noctics Hub - Fish It";
        Text = msg;
        Duration = 3;
    })
end

notif("Welcome to Noctics Hub - Fish It!")

-- Cegah duplikasi GUI
if game.CoreGui:FindFirstChild("NocticsFishIt") then
    game.CoreGui.NocticsFishIt:Destroy()
end

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NocticsFishIt"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", mainFrame)
title.Text = "🎣 Noctics Hub - Fish It"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Tombol Close
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Template function untuk buat tombol
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Text = name
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

--// Tombol-tombol contoh
createButton("Auto Cast 🎯", 60, function()
    notif("Auto Cast activated (demo mode)")
    print("[Noctics] Auto Cast triggered!")
    -- Kamu bisa tambahkan logic cast otomatis di sini nanti
end)

createButton("Auto Reel 🪝", 100, function()
    notif("Auto Reel activated (demo mode)")
    print("[Noctics] Auto Reel triggered!")
    -- Logic reel otomatis bisa dimasukkan di sini
end)

createButton("Auto Sell 💰", 140, function()
    notif("Auto Sell activated (demo mode)")
    print("[Noctics] Auto Sell triggered!")
    -- Logic jual otomatis ikan bisa kamu tambahkan di sini
end)

-- Animasi kecil (Fade in)
mainFrame.BackgroundTransparency = 1
title.TextTransparency = 1

local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

tweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
tweenService:Create(title, tweenInfo, {TextTransparency = 0}):Play()

notif("GUI Loaded Successfully!")