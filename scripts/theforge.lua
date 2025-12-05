-- theforge.lua (FINAL SCRIPT YANG DIOPTIMASI UNTUK EKSEKUSI LOADSTRING)

do -- Blok 'do' untuk menjamin scope lokal dan urutan eksekusi

    -- ===================================================
    -- BAGIAN 1: DEKLARASI LAYANAN DAN VARIABEL GLOBAL
    -- ===================================================

    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer

    local FeatureStatus = {
        AutoMine = false,
        AutoForgePerfect = false,
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
    local padding = 15
    local currentY = 0
    local ContentContainer -- Dideklarasikan di sini agar scope-nya luas untuk semua fungsi UI

    -- ===================================================
    -- BAGIAN 2: LOGIKA FITUR (DEKLARASI SEMUA FUNGSI)
    -- ===================================================

    local function GetFeatureStatus() return FeatureStatus end
    local function ToggleAutoMine(state)
        FeatureStatus.AutoMine = state
        -- [Logika AutoMine Worker]
        print("LOGIC: AutoMine diatur ke:", state)
    end

    local function ToggleAutoForgePerfect(state)
        FeatureStatus.AutoForgePerfect = state
        -- [Logika Forge Worker]
        print("LOGIC: AutoForgePerfect diatur ke:", state)
    end
    
    local function ToggleSelectedOre(oreName, state)
        FeatureStatus.SelectedOres[oreName] = state
        print("LOGIC: Ore", oreName, "diatur ke:", state)
    end
    
    local function CloseLogic()
        ToggleAutoMine(false)
        ToggleAutoForgePerfect(false)
        print("LOGIC: Logika fitur dibersihkan.")
    end

    -- ===================================================
    -- BAGIAN 3: FUNGSI PEMBANGUNAN GUI PEMBANTU (MENGGUNAKAN FUNGSI LOGIKA DI ATAS)
    -- ===================================================

    local function createToggle(name, description, yOffset)
        local frameHeight = 50
        -- ... (Kode pembuatan toggle frame dan button) ...
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Parent = ContentContainer -- Aman karena ContentContainer sudah dideklarasikan di scope luar
        
        local ToggleButton = Instance.new("TextButton")
        -- ... (Set properti) ...
        ToggleButton.Parent = toggleFrame
        
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

        local ScreenGui = Instance.new("ScreenGui", CoreGui)
        ScreenGui.Name = "TheForgeBETA"
        
        local MainFrame = Instance.new("Frame", ScreenGui)
        -- ... (Set properti MainFrame) ...
        
        local TitleBar = Instance.new("Frame", MainFrame)
        -- ... (Set properti TitleBar) ...
        
        local CloseButton = Instance.new("TextButton", TitleBar) -- CloseButton dideklarasikan sebagai variabel lokal
        -- ... (Set properti CloseButton) ...

        local ContentFrame = Instance.new("ScrollingFrame", MainFrame)

        ContentContainer = Instance.new("Frame", ContentFrame) -- Inisialisasi ContentContainer
        -- ... (Set properti ContentContainer) ...
        
        -- --- KONTROL AUTO MINE ---
        local AutoMineButton = createToggle("AutoMine", "⛏️ AUTO MINE", currentY)
        local isAutoMineActive = GetFeatureStatus().AutoMine
        -- ... (Set Text dan Color awal) ...
        AutoMineButton.MouseButton1Click:Connect(function()
            local newState = not isAutoMineActive
            ToggleAutoMine(newState) -- Aman karena ToggleAutoMine sudah dideklarasikan
            isAutoMineActive = newState
            -- ... (Update Text dan Color) ...
        end)

        -- --- KONTROL AUTO FORGE PERFECT ---
        local AutoForgeButton = createToggle("AutoForgePerfect", "⚡ AUTO FORGE PERFECT", currentY)
        local isAutoForgeActive = GetFeatureStatus().AutoForgePerfect
        -- ... (Set Text dan Color awal) ...
        AutoForgeButton.MouseButton1Click:Connect(function()
            local newState = not isAutoForgeActive
            ToggleAutoForgePerfect(newState) -- Aman karena ToggleAutoForgePerfect sudah dideklarasikan
            isAutoForgeActive = newState
            -- ... (Update Text dan Color) ...
        end)

        -- ... (KONTROL JENIS ORE) ...
        
        -- --- EVENT HANDLERS AKHIR ---
        CloseButton.MouseButton1Click:Connect(function()
            CloseLogic() -- Aman karena CloseLogic sudah dideklarasikan
            -- ... (Logika Tween Keluar) ...
            ScreenGui:Destroy()
        end)

        -- ... (Logika Tween Masuk) ...
        
        print("✓ The Forge BETA: Skrip berhasil dieksekusi dan GUI ditampilkan!")
    end

    -- EKSEKUSI UTAMA (Ini dipanggil hanya setelah semua fungsi di atas dideklarasikan)
    pcall(buildGUI) 

end -- Akhir dari blok 'do'