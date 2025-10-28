--// Noctics Universal Loader
print("🌙 Noctics Hub Universal Loader")

local nocticsLogoId = "rbxassetid://6023426926" -- Logo Roblox universal
 -- ganti logo kamu

--// Notifikasi Kustom
local function showNotification(title, message)
    local CoreGui = game:GetService("CoreGui")
    if CoreGui:FindFirstChild("NocticsNotifGui") then
        CoreGui.NocticsNotifGui:Destroy()
    end

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "NocticsNotifGui"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 320, 0, 75)
    frame.Position = UDim2.new(0.5, -160, 0, -90)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local icon = Instance.new("ImageLabel", frame)
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 32, 0, 32)
    icon.Position = UDim2.new(0, 10, 0.5, -16)
    icon.Image = nocticsLogoId

    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -60, 0, 25)
    titleLabel.Position = UDim2.new(0, 50, 0, 8)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title

    local messageLabel = Instance.new("TextLabel", frame)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Size = UDim2.new(1, -60, 0, 20)
    messageLabel.Position = UDim2.new(0, 50, 0, 35)
    messageLabel.Font = Enum.Font.SourceSans
    messageLabel.TextColor3 = Color3.fromRGB(200,200,200)
    messageLabel.TextSize = 14
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.Text = message

    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    tweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, -160, 0, 10)}):Play()

    task.wait(2)
    tweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, -160, 0, -90)}):Play()
    game:GetService("Debris"):AddItem(gui, 0.6)
end

--// Daftar Game dan Script
local supportedGames = {
    [121864768012064] = "https://raw.githubusercontent.com/aerusanc/Noctics/main/src/fishit.lua",
    [102234703920418] = "https://raw.githubusercontent.com/aerusanc/Noctics/main/src/mountdaun.lua",
    [2693023319] = "https://raw.githubusercontent.com/aerusanc/Noctics/main/src/antartica.lua",
}

--// Load Main GUI (main.lua)
local mainGuiUrl = "https://raw.githubusercontent.com/aerusanc/Noctics/main/src/main.lua"
pcall(function()
    loadstring(game:HttpGet(mainGuiUrl))()
end)

--// Deteksi Game
local currentGame = game.PlaceId
local scriptUrl = supportedGames[currentGame]

if scriptUrl then
    local success, gameInfo = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(currentGame)
    end)
    local gameName = success and gameInfo.Name or "Game"

    print("✅ Detected: " .. gameName)
    showNotification("Noctics Hub", gameName .. " script loaded successfully!")

    pcall(function()
        loadstring(game:HttpGet(scriptUrl))()
    end)
else
    warn("⚠️ Game not supported (ID: " .. currentGame .. ")")
    showNotification("Noctics Hub", "This game is not supported.")
end
