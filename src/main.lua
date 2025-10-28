-- src/main.lua
-- 🌙 Noctics Safe Mode: GUI aman & auto-recover di game protektif

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local Noctics = {}

function Noctics.run()
    print("[Noctics] Safe Mode dijalankan...")

    -- Hapus GUI lama (jika ada)
    for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
        if gui.Name:find("NocticsUI_") then
            gui:Destroy()
        end
    end

    -- Buat nama GUI acak
    local randomID = tostring(math.random(1000, 9999))
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NocticsUI_" .. randomID
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- 🌀 Tombol ikon toggle menu
    local IconButton = Instance.new("ImageButton")
    IconButton.Size = UDim2.new(0, 50, 0, 50)
    IconButton.Position = UDim2.new(1, -70, 1, -70)
    IconButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    IconButton.Image = "rbxassetid://6035047377" -- icon default Roblox circle
    IconButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    IconButton.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = IconButton

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(100, 100, 255)
    Stroke.Parent = IconButton

    -- 📋 Menu Frame
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Size = UDim2.new(0, 260, 0, 210)
    MenuFrame.Position = UDim2.new(1, -290, 1, -280)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MenuFrame.Visible = false
    MenuFrame.Parent = ScreenGui

    local MenuCorner = Instance.new("UICorner")
    MenuCorner.CornerRadius = UDim.new(0, 10)
    MenuCorner.Parent = MenuFrame

    local MenuStroke = Instance.new("UIStroke")
    MenuStroke.Thickness = 2
    MenuStroke.Color = Color3.fromRGB(90, 90, 255)
    MenuStroke.Parent = MenuFrame

    -- Judul
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "🌙 Noctics Menu"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Parent = MenuFrame

    -- Tombol Aksi
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -40, 0, 35)
    Button.Position = UDim2.new(0, 20, 0, 70)
    Button.Text = "Kirim Notifikasi"
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 16
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 255)
    Button.Parent = MenuFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Noctics",
            Text = "Notifikasi berhasil dikirim!",
            Duration = 3
        })
    end)

    -- ✨ Animasi buka/tutup
    local menuOpen = false
    IconButton.MouseButton1Click:Connect(function()
        menuOpen = not menuOpen
        MenuFrame.Visible = menuOpen

        local goal = {Position = menuOpen and UDim2.new(1, -290, 1, -280) or UDim2.new(1, -290, 1, -250)}
        local tween = TweenService:Create(MenuFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
        tween:Play()
    end)

    -- 🔁 Auto-recover protection
    task.spawn(function()
        while task.wait(2) do
            if not ScreenGui or not ScreenGui.Parent then
                warn("[Noctics] GUI hilang, membuat ulang...")
                Noctics.run()
                break
            end
        end
    end)

    -- 🔔 Notifikasi awal
    StarterGui:SetCore("SendNotification", {
        Title = "Noctics Safe Mode",
        Text = "Klik ikon kanan bawah untuk membuka menu.",
        Duration = 6
    })

    print("[Noctics] GUI berhasil dibuat.")
end

return Noctics
