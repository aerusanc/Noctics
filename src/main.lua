-- src/main.lua
-- ✨ Noctics GUI dengan Icon & Animasi Menu ✨

local TweenService = game:GetService("TweenService")

local Noctics = {}

function Noctics.run()
    -- Pastikan GUI lama tidak dobel
    if game.CoreGui:FindFirstChild("NocticsUI") then
        game.CoreGui.NocticsUI:Destroy()
    end

    -- Buat ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NocticsUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui

    -- 🌙 Tombol Icon
    local IconButton = Instance.new("ImageButton")
    IconButton.Name = "OpenMenuButton"
    IconButton.Size = UDim2.new(0, 50, 0, 50)
    IconButton.Position = UDim2.new(1, -70, 1, -70)
    IconButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    IconButton.Image = "rbxassetid://6035047377" -- contoh icon bulat (bisa diganti)
    IconButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    IconButton.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = IconButton

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(80, 80, 255)
    UIStroke.Parent = IconButton

    -- 📋 Frame Menu
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Size = UDim2.new(0, 250, 0, 200)
    MenuFrame.Position = UDim2.new(1, -300, 1, -280)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MenuFrame.Visible = false
    MenuFrame.Parent = ScreenGui

    local MenuCorner = Instance.new("UICorner")
    MenuCorner.CornerRadius = UDim.new(0, 12)
    MenuCorner.Parent = MenuFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(90, 90, 255)
    Stroke.Parent = MenuFrame

    -- Judul Menu
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "🌙 Noctics Menu"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Parent = MenuFrame

    -- Tombol contoh
    local Button1 = Instance.new("TextButton")
    Button1.Size = UDim2.new(1, -40, 0, 35)
    Button1.Position = UDim2.new(0, 20, 0, 60)
    Button1.Text = "Kirim Notifikasi"
    Button1.Font = Enum.Font.Gotham
    Button1.TextSize = 16
    Button1.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button1.BackgroundColor3 = Color3.fromRGB(60, 60, 255)
    Button1.Parent = MenuFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button1

    Button1.MouseButton1Click:Connect(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Noctics",
            Text = "Notifikasi dikirim!",
            Duration = 3
        })
    end)

    -- 🌠 Animasi buka/tutup menu
    local menuOpen = false
    local tweenIn = TweenService:Create(MenuFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -300, 1, -280),
        BackgroundTransparency = 0
    })
    local tweenOut = TweenService:Create(MenuFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, -300, 1, -250),
        BackgroundTransparency = 1
    })

    IconButton.MouseButton1Click:Connect(function()
        if menuOpen then
            tweenOut:Play()
            task.wait(0.3)
            MenuFrame.Visible = false
        else
            MenuFrame.Visible = true
            tweenIn:Play()
        end
        menuOpen = not menuOpen
    end)

    -- 🔔 Notifikasi awal
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Noctics Loaded",
        Text = "Klik ikon di pojok kanan bawah untuk membuka menu.",
        Duration = 6
    })
end

return Noctics
