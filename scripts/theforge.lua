-- theforge.lua (FINAL GABUNGAN SKRIP)
-- Kode ini mengintegrasikan Logika (GUILogic) dan Visual (GUIManager)

-- ===================================================
-- BAGIAN 1: LOGIKA FITUR (INTERNAL GUILogic)
-- ===================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Status Fitur
local FeatureStatus = {
    AutoMine = false,
    AutoForgePerfect = false,
    A = false, -- Contoh Fitur A
    SelectedOres = {},
}

local AllOres = {"Iron Ore", "Copper Ore", "Gold Ore", "Ruby Ore", "Emerald Ore", "Diamond Ore"}
for _, ore in ipairs(AllOres) do
    FeatureStatus.SelectedOres[ore] = true
end

local Threads = {
    AutoMine = nil,
}

-- FUNGSI BARU: Logika Auto Forge Perfect
local function startAutoForgePerfect()
    print("LOGIC: Auto Forge Perfect diaktifkan. Mencari minigame...")
    -- Implementasi logika bypass/memaksa hasil minigame Forge menjadi Perfect
    
    -- Contoh Asumsi Logika (Ini adalah bagian yang perlu diisi dengan exploit spesifik game):
    -- 1. Cari RemoteEvent yang dipanggil saat minigame selesai.
    -- 2. Ganti fungsi RemoteEvent tersebut (hooking) agar selalu mengirim data "Perfect" ke server.
end

local function stopAutoForgePerfect()
    print("LOGIC: Auto Forge Perfect dihentikan.")
    -- Implementasi logika untuk mengembalikan fungsi RemoteEvent asli (unhooking)
end

local function autoMineWorker()
    while FeatureStatus.AutoMine do
        print("LOGIC: Auto Mining aktif. Mencari ore...")
        -- Implementasi logika Auto Mine di sini
        task.wait(1.5)
    end
end

-- PUBLIC API (Fungsi yang dipanggil oleh GUI)
local function GetFeatureStatus() return FeatureStatus end
local function GetAllOres() return AllOres end
local function GetSelectedOres() return FeatureStatus.SelectedOres end

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
-- BAGIAN 2: UI MANAGER (GUIManager.client.lua)
-- ===================================================

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- Remove existing GUI if exists
if CoreGui:FindFirstChild("TheForgeBETA") then
    CoreGui:FindFirstChild("TheForgeBETA"):Destroy()
end

-- Create ScreenGui (Dibuat di CoreGui karena dieksekusi melalui loader)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TheForgeBETA"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui -- Penting: Ditempatkan di CoreGui

-- Check if mobile device
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Window dimensions
local windowWidth = 520
local windowHeight = 450
if isMobile then
    windowWidth = 400
    windowHeight = 500
end

-- Main window frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
MainFrame.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

if not isMobile then
    MainFrame.Draggable = true
end

-- ... (Sisanya dari kode pembuatan TitleBar, CloseButton, ContentFrame, dll.) ...

-- Helper function for toggles
local padding = 15
local currentY = 0

local function createToggle(name, description, yOffset)
    local frameHeight = 50
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "ToggleFrame"
    toggleFrame.Size = UDim2.new(1, 0, 0, frameHeight)
    toggleFrame.Position = UDim2.new(0, 0, 0, yOffset)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = ContentContainer
    
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

-- ---------------------------------------------------
-- KONTROL AUTO MINE
-- ---------------------------------------------------

local AutoMineButton = createToggle("AutoMine", "⛏️ AUTO MINE", currentY)
local isAutoMineActive = GetFeatureStatus().AutoMine
AutoMineButton.Text = (isAutoMineActive and "   ⛏️ AUTO MINE: ON") or "   ⛏️ AUTO MINE: OFF"
AutoMineButton.BackgroundColor3 = (isAutoMineActive and Color3.fromRGB(50, 150, 50)) or Color3.fromRGB(60, 60, 70)

AutoMineButton.MouseButton1Click:Connect(function()
    local newState = not isAutoMineActive
    ToggleAutoMine(newState)
    isAutoMineActive = newState
    AutoMineButton.Text = (newState and "   ⛏️ AUTO MINE: ON") or "   ⛏️ AUTO MINE: OFF"
    AutoMineButton.BackgroundColor3 = (newState and Color3.fromRGB(50, 150, 50)) or Color3.fromRGB(60, 60, 70)
end)

-- ---------------------------------------------------
-- KONTROL AUTO FORGE PERFECT (FITUR BARU)
-- ---------------------------------------------------

local AutoForgeButton = createToggle("AutoForgePerfect", "⚡ AUTO FORGE PERFECT", currentY)
local isAutoForgeActive = GetFeatureStatus().AutoForgePerfect
AutoForgeButton.Text = (isAutoForgeActive and "   ⚡ AUTO FORGE PERFECT: ON") or "   ⚡ AUTO FORGE PERFECT: OFF"
AutoForgeButton.BackgroundColor3 = (isAutoForgeActive and Color3.fromRGB(255, 165, 0)) or Color3.fromRGB(60, 60, 70)

AutoForgeButton.MouseButton1Click:Connect(function()
    local newState = not isAutoForgeActive
    ToggleAutoForgePerfect(newState)
    isAutoForgeActive = newState
    AutoForgeButton.Text = (newState and "   ⚡ AUTO FORGE PERFECT: ON") or "   ⚡ AUTO FORGE PERFECT: OFF"
    AutoForgeButton.BackgroundColor3 = (newState and Color3.fromRGB(255, 165, 0)) or Color3.fromRGB(60, 60, 70)
end)

-- ---------------------------------------------------
-- KONTROL JENIS ORE
-- ---------------------------------------------------

-- ... (Kode untuk OreTitle, loop checkbox, dan event klik yang memanggil ToggleSelectedOre) ...

-- Sesuaikan CanvasSize
-- ... (Kode penyesuaian CanvasSize agar semua konten terlihat) ...

-- ===================================================
-- EVENT HANDLERS AKHIR (CLOSE & ANIMATION)
-- ===================================================

local CloseButton = ScreenGui.TheForgeBETA.MainFrame.TitleBar.CloseButton -- Ambil objek CloseButton yang sudah dibuat di bagian UI Manager

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

local fadeIn = TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0})
local slideIn = TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
})

fadeIn:Play()
task.wait(0.1)
slideIn:Play()

print("✓ The Forge BETA: Skrip Gabungan dimuat dan GUI ditampilkan!")