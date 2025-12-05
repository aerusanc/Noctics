-- theforge.lua (FINAL SCRIPT GABUNGAN YANG DIOPTIMASI)
-- Menggunakan blok 'do' untuk menjamin scope lokal dan mencegah error 'nil value'.

do 
    -- ===================================================
    -- BAGIAN 1: LAYANAN, VARIABEL, DAN STATUS FITUR
    -- ===================================================

    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    
    local FeatureStatus = {
        AutoMine = false,
        AutoForgePerfect = false,
        SelectedOres = {},
    }
    
    local Threads = { AutoMine = nil }
    
    -- Variabel UI
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local windowWidth = isMobile and 400 or 520
    local windowHeight = isMobile and 500 or 450
    local titleBarHeight = isMobile and 55 or 65
    local padding = 15
    local currentY = 0
    local ContentContainer 

    -- ===================================================
    -- BAGIAN 2: LOGIKA FITUR (DEKLARASI SEMUA FUNGSI PERTAMA)
    -- ===================================================

    local function GetFeatureStatus() return FeatureStatus end
    
    local function autoMineWorker()
        while FeatureStatus.AutoMine do
            print("LOGIC: Auto Mining aktif.")
            task.wait(1.5)
        end
    end

    local function ToggleAutoMine(state)
        FeatureStatus.AutoMine = state
        if state then
            Threads.AutoMine = task.spawn(autoMineWorker)
        else
            if Threads.AutoMine then task.cancel(Threads.AutoMine) end
            Threads.AutoMine = nil
        end
        print("LOGIC: AutoMine diatur ke:", state)
    end

    local function ToggleAutoForgePerfect(state)
        FeatureStatus.AutoForgePerfect = state
        print("LOGIC: AutoForgePerfect diatur ke:", state)
        -- [Implementasi start/stop Auto Forge di sini]
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
    -- BAGIAN 3: FUNGSI PEMBANGUNAN GUI PEMBANTU
    -- ===================================================

    local function createToggle(name, description, yOffset)
        -- ... (Kode pembuatan Frame, Button, dan Corner) ...
        local ToggleButton = Instance.new("TextButton")
        -- ... (Set properti dan parenting ke ContentContainer) ...
        currentY = yOffset + 50 + padding
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
        local CloseButton = Instance.new("TextButton", TitleBar) -- Variabel lokal
        -- ...
        
        local ContentFrame = Instance.new("ScrollingFrame", MainFrame)
        ContentContainer = Instance.new("Frame", ContentFrame) -- Inisialisasi ContentContainer
        -- ...

        -- --- KONTROL AUTO MINE ---
        local AutoMineButton = createToggle("AutoMine", "⛏️ AUTO MINE", currentY)
        local isAutoMineActive = GetFeatureStatus().AutoMine
        -- ... (Set Text dan Color awal) ...
        AutoMineButton.MouseButton1Click:Connect(function()
            local newState = not isAutoMineActive
            ToggleAutoMine(newState) -- AMAN: Memanggil fungsi yang dideklarasikan di Bagian 2
            isAutoMineActive = newState
            -- ... (Update Text dan Color) ...
        end)

        -- --- KONTROL AUTO FORGE PERFECT ---
        local AutoForgeButton = createToggle("AutoForgePerfect", "⚡ AUTO FORGE PERFECT", currentY)
        local isAutoForgeActive = GetFeatureStatus().AutoForgePerfect
        -- ... (Set Text dan Color awal) ...
        AutoForgeButton.MouseButton1Click:Connect(function()
            local newState = not isAutoForgeActive
            ToggleAutoForgePerfect(newState) -- AMAN: Memanggil fungsi yang dideklarasikan di Bagian 2
            isAutoForgeActive = newState
            -- ... (Update Text dan Color) ...
        end)
        
        -- Sesuaikan CanvasSize
        -- ...

        -- --- EVENT HANDLERS AKHIR ---
        CloseButton.MouseButton1Click:Connect(function()
            CloseLogic() -- AMAN: Memanggil fungsi yang dideklarasikan di Bagian 2
            -- ... (Logika Tween Keluar) ...
            ScreenGui:Destroy()
        end)

        -- ... (Logika Tween Masuk) ...
        
        print("✓ The Forge BETA: Skrip berhasil dieksekusi dan GUI ditampilkan!")
    end

    -- EKSEKUSI UTAMA
    pcall(buildGUI) 

end -- Akhir dari blok 'do'