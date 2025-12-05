-- main.lua (UNIVERSAL SCRIPT LOADER)
-- File ini bertugas untuk mendeteksi Game dan memuat Script yang relevan.

print("🌙 Noctics Hub Universal Loader: Initializing...")

-- Ganti ini dengan ID logo Anda (Opsional)
local nocticsLogoId = "rbxassetid://YOUR_LOGO_ASSET_ID" 

-- ===================================================
-- FUNGSI NOTIFIKASI KUSTOM
-- ===================================================

local function showNotification(title, message)
    local CoreGui = game:GetService("CoreGui")
    -- Hancurkan GUI notifikasi sebelumnya untuk mencegah tumpukan
    if CoreGui:FindFirstChild("NocticsNotifGui") then
        CoreGui.NocticsNotifGui:Destroy()
    end

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "NocticsNotifGui"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Frame, Icon, Title, dan Message Labels...
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 320, 0, 75)
    frame.Position = UDim2.new(0.5, -160, 0, -90) -- Posisi awal: tersembunyi di atas
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local icon = Instance.new("ImageLabel", frame)
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 32, 0, 32)
    icon.Position = UDim2.new(0, 10, 0.5, -16)
    icon.Image = nocticsLogoId
    
    local titleLabel = Instance.new("TextLabel", frame)
    -- ... (Properti TextLabel Title) ...
    titleLabel.Text = title

    local messageLabel = Instance.new("TextLabel", frame)
    -- ... (Properti TextLabel Message) ...
    messageLabel.Text = message

    -- Animasi
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- Animasi Masuk
    tweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, -160, 0, 10)}):Play()

    -- Tunda tampilan, lalu Animasi Keluar
    task.wait(3) -- Menampilkan notifikasi selama 3 detik
    tweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, -160, 0, -90)}):Play()
    game:GetService("Debris"):AddItem(gui, 0.6)
end

-- ===================================================
-- DETEKSI GAME DAN DAFTAR SCRIPT
-- ===================================================

-- Ganti ID game di bawah dengan PlaceId game The Forge yang sebenarnya
local THE_FORGE_PLACE_ID = 76558904092080

-- Daftar Game yang didukung dan URL Script yang sesuai
local supportedGames = {
    -- ID game memancing lama
    [121864768012064] = "https://raw.githubusercontent.com/aerusanc/Noctics/main/scripts/fishit.lua",
    
    -- Game The Forge BETA (memuat script gabungan theforge.lua)
    [THE_FORGE_PLACE_ID] = "https://raw.githubusercontent.com/aerusanc/Noctics/main/scripts/theforge.lua", 
    
    -- Contoh game lain
    [102234703920418] = "https://raw.githubusercontent.com/aerusanc/Noctics/main/scripts/mountdaun.lua",
}

local currentGame = game.PlaceId
local scriptUrl = supportedGames[currentGame]

-- ===================================================
-- PROSES PEMUATAN (LOADING)
-- ===================================================

if scriptUrl then
    local gameName = "Current Game"
    
    -- Ambil nama game untuk notifikasi (Opsional: membutuhkan MarketplaceService, bisa gagal)
    local success, gameInfo = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(currentGame)
    end)
    if success and gameInfo then
        gameName = gameInfo.Name
    end

    print("✅ Detected: " .. gameName .. " (ID: " .. currentGame .. ")")
    showNotification("Noctics Hub", gameName .. " script loaded successfully!")

    -- Ambil dan Eksekusi Script dari URL
    local scriptCode = game:HttpGet(scriptUrl)
    if scriptCode and scriptCode ~= "" then
        pcall(function()
            loadstring(scriptCode)() -- Eksekusi kode
        end)
    else
        warn("❌ Failed to download script from: " .. scriptUrl)
        showNotification("Noctics Hub", "Failed to download script! Check the URL.")
    end

else
    warn("⚠️ Game not supported (ID: " .. currentGame .. ")")
    showNotification("Noctics Hub", "This game is not supported.")
end