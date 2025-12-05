<<<<<<< HEAD
-- theforge.lua (FINAL GABUNGAN: Logika + UI)
-- Skrip ini dirancang untuk dieksekusi oleh loadstring, oleh karena itu semua fungsi dideklarasikan secara lokal dan terstruktur di awal.

-- ===================================================
-- BAGIAN 1: DEKLARASI LAYANAN DAN VARIABEL GLOBAL
-- ===================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Status Fitur (diakses langsung oleh fungsi Logika & UI)
local FeatureStatus = {
    AutoMine = false,
    AutoForgePerfect = false,
    A = false, 
    SelectedOres = {},
}

local AllOres = {"Iron Ore", "Copper Ore", "Gold Ore", "Ruby Ore", "Emerald Ore", "Diamond Ore"}
for _, ore in ipairs(AllOres) do
    FeatureStatus.SelectedOres[ore] = true
end

local Threads = {
    AutoMine = nil,
}

-- Definisi Dimensi UI
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local windowWidth = isMobile and 400 or 520
local windowHeight = isMobile and 500 or 450
local titleBarHeight = isMobile and 55 or 65
local closeButtonSize = isMobile and 38 or 42
local titleFontSize = isMobile and 20 or 26

-- ===================================================
-- BAGIAN 2: LOGIKA FITUR (INTERNAL)
-- ===================================================

local function GetFeatureStatus() return FeatureStatus end
local function GetAllOres() return AllOres end
local function GetSelectedOres() return FeatureStatus.SelectedOres end

local function startAutoForgePerfect()
    print("LOGIC: Auto Forge Perfect diaktifkan. (Implementasi Bypass diperlukan)")
    -- [Implementasi logika bypass/force Perfect di sini]
end

local function stopAutoForgePerfect()
    print("LOGIC: Auto Forge Perfect dihentikan.")
end

local function autoMineWorker()
    while FeatureStatus.AutoMine do
        print("LOGIC: Auto Mining aktif.")
        -- [Implementasi logika Auto Mine di sini]
        task.wait(1.5)
    end
end

local function ToggleAutoMine(state)
    FeatureStatus.AutoMine = state
    if state and Threads.AutoMine == nil then
        Threads.AutoMine = task.spawn(autoMineWorker)
    elseif not state and Threads.AutoMine then
        task.cancel(Threads.AutoMine)
        Threads.AutoMine = nil
    end
    print("LOGIC: AutoMine diatur ke:", state)
end

local function ToggleAutoForgePerfect(state)
    FeatureStatus.AutoForgePerfect = state
    if state then
        startAutoForgePerfect()
    else
        stopAutoForgePerfect()
    end
    print("LOGIC: AutoForgePerfect diatur ke:", state)
end

local function ToggleFeature(key, state)
    FeatureStatus[key] = state
    print("LOGIC:", key, "diatur ke:", state)
end

local function ToggleSelectedOre(oreName, state)
    FeatureStatus.SelectedOres[oreName] = state
    print("LOGIC: Ore", oreName, "diatur ke:", state)
end

local function CloseLogic()
    -- Hentikan semua fitur saat GUI ditutup
    ToggleAutoMine(false)
    ToggleAutoForgePerfect(false)
    print("LOGIC: Logika fitur dibersihkan.")
end

-- ===================================================
-- BAGIAN 3: FUNGSI PEMBANGUNAN GUI PEMBANTU
-- ===================================================

local ContentContainer -- Deklarasikan di luar agar bisa diakses oleh fungsi di bawah

local padding = 15
local currentY = 0

local function createToggle(name, description, yOffset)
    local frameHeight = 50
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "ToggleFrame"
    toggleFrame.Size = UDim2.new(1, 0, 0, frameHeight)
    toggleFrame.Position = UDim2.new(0, 0, 0, yOffset)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = ContentContainer -- Menggunakan ContentContainer yang dideklarasikan nanti
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = name .. "Button"
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 18
    ToggleButton.TextXAlignment = Enum.TextXAlignment.Left
    ToggleButton.Text = "   " .. description .. ": OFF"
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = toggleFrame
    
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)
    
    currentY = yOffset + frameHeight + padding
    return ToggleButton
end

-- ===================================================
-- BAGIAN 4: EKSEKUSI PEMBANGUNAN GUI UTAMA
-- ===================================================

local function buildGUI()
    if CoreGui:FindFirstChild("TheForgeBETA") then
        CoreGui:FindFirstChild("TheForgeBETA"):Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TheForgeBETA"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = CoreGui 

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    MainFrame.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    if not isMobile then MainFrame.Draggable = true end
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

    -- Title Bar & Close Button Creation...
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, titleBarHeight)
    TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    TitleBar.Parent = MainFrame
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 16)

    local TitleText = Instance.new("TextLabel")
    -- ... (Properti TitleText) ...
    TitleText.Text = "The Forge BETA - Features"
    TitleText.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, closeButtonSize, 0, closeButtonSize)
    CloseButton.Position = UDim2.new(1, -54, 0.5, -closeButtonSize/2)
    CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    CloseButton.Text = "X"
    CloseButton.Parent = TitleBar
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 10)


    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -titleBarHeight)
    ContentFrame.Position = UDim2.new(0, 0, 0, titleBarHeight)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.Parent = MainFrame

    ContentContainer = Instance.new("Frame") -- Definisi ContentContainer di sini
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -40, 0, 480) 
    ContentContainer.Position = UDim2.new(0, 20, 0, 15)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = ContentFrame

    -- --- KONTROL AUTO MINE ---
    local AutoMineButton = createToggle("AutoMine", "⛏️ AUTO MINE", currentY)
    local isAutoMineActive = GetFeatureStatus().AutoMine
    AutoMineButton.Text = (isAutoMineActive and "   ⛏️ AUTO MINE: ON") or "   ⛏️ AUTO MINE: OFF"
    AutoMineButton.BackgroundColor3 = (isAutoMineActive and Color3.fromRGB(50, 150, 50)) or Color3.fromRGB(60, 60, 70)
    AutoMineButton.MouseButton1Click:Connect(function()
        local newState = not isAutoMineActive
        ToggleAutoMine(newState) -- Panggil fungsi logika yang sudah dideklarasikan
        isAutoMineActive = newState
        AutoMineButton.Text = (newState and "   ⛏️ AUTO MINE: ON") or "   ⛏️ AUTO MINE: OFF"
        AutoMineButton.BackgroundColor3 = (newState and Color3.fromRGB(50, 150, 50)) or Color3.fromRGB(60, 60, 70)
    end)

    -- --- KONTROL AUTO FORGE PERFECT ---
    local AutoForgeButton = createToggle("AutoForgePerfect", "⚡ AUTO FORGE PERFECT", currentY)
    local isAutoForgeActive = GetFeatureStatus().AutoForgePerfect
    AutoForgeButton.Text = (isAutoForgeActive and "   ⚡ AUTO FORGE PERFECT: ON") or "   ⚡ AUTO FORGE PERFECT: OFF"
    AutoForgeButton.BackgroundColor3 = (isAutoForgeActive and Color3.fromRGB(255, 165, 0)) or Color3.fromRGB(60, 60, 70)
    AutoForgeButton.MouseButton1Click:Connect(function()
        local newState = not isAutoForgeActive
        ToggleAutoForgePerfect(newState) -- Panggil fungsi logika yang sudah dideklarasikan
        isAutoForgeActive = newState
        AutoForgeButton.Text = (newState and "   ⚡ AUTO FORGE PERFECT: ON") or "   ⚡ AUTO FORGE PERFECT: OFF"
        AutoForgeButton.BackgroundColor3 = (newState and Color3.fromRGB(255, 165, 0)) or Color3.fromRGB(60, 60, 70)
    end)

    -- --- KONTROL JENIS ORE (CHECKBOXES) ---
    -- [Implementasi Checkboxes Ore yang memanggil ToggleSelectedOre]

    -- Sesuaikan CanvasSize
    ContentContainer.Size = UDim2.new(1, -40, 0, currentY + 15)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentContainer.Size.Offset.Y + 30)


    -- --- EVENT HANDLERS AKHIR (CLOSE & ANIMATION) ---
    CloseButton.MouseButton1Click:Connect(function()
        CloseLogic() -- Panggil fungsi pembersihan logika
        
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -windowWidth/2, 1.5, 0)
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        
        ScreenGui:Destroy()
    end)

    -- Entrance animation
    MainFrame.Position = UDim2.new(0.5, -windowWidth/2, 1.5, 0)
    MainFrame.BackgroundTransparency = 1
    -- ... (Logika Tweening Entrance) ...
    local fadeIn = TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0})
    local slideIn = TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
    })
    fadeIn:Play()
    task.wait(0.1)
    slideIn:Play()
    
    print("✓ The Forge BETA: Skrip berhasil dieksekusi dan GUI ditampilkan!")
end

-- Panggil fungsi utama untuk memulai pembangunan GUI dan fitur
pcall(buildGUI)
=======
-- theforge.lua (Uji Coba)
pcall(function() 
    -- Ini harusnya aman dieksekusi
    local players = game:GetService("Players") 
    print("Skrip diunduh dan layanan dapat diakses.")
end)
>>>>>>> 3eac1d6bba4d3da66fb92de6f08313a2d5efe10a
