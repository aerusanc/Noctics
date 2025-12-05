-- THE FORGE BETA — FIXED & CLEAN VERSION
-- Noctics Hub by RYU
-- Fully sanitized: no nil-call, no nil-parent, no GUI crash

do
    ----------------------------
    -- SERVICES & VARIABLES
    ----------------------------
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

    local isMobile = UserInputService.TouchEnabled
    local windowWidth = isMobile and 400 or 520
    local windowHeight = isMobile and 500 or 450
    local padding = 12
    local currentY = 0

    -- akan di set setelah GUI selesai dibuat
    local ContentContainer = nil  


    ----------------------------
    -- LOGIC FUNCTIONS
    ----------------------------

    local function GetFeatureStatus()
        return FeatureStatus
    end

    local function autoMineWorker()
        while FeatureStatus.AutoMine do
            print("[Noctics] Auto Mine aktif...")
            task.wait(1.2)
        end
    end

    local function ToggleAutoMine(state)
        FeatureStatus.AutoMine = state

        if state then
            Threads.AutoMine = task.spawn(autoMineWorker)
        else
            if Threads.AutoMine then
                task.cancel(Threads.AutoMine)
            end
            Threads.AutoMine = nil
        end

        print("[Noctics] AutoMine =", state)
    end

    local function ToggleAutoForgePerfect(state)
        FeatureStatus.AutoForgePerfect = state
        print("[Noctics] AutoForgePerfect =", state)
    end

    local function ToggleSelectedOre(oreName, state)
        FeatureStatus.SelectedOres[oreName] = state
        print("[Noctics] Ore", oreName, "=", state)
    end

    local function CloseLogic()
        ToggleAutoMine(false)
        ToggleAutoForgePerfect(false)
        print("[Noctics] Semua fitur dimatikan.")
    end



    ----------------------------
    -- UI HELPERS
    ----------------------------

    local function createToggle(label, description)
        -- FRAME WRAPPER
        local Wrap = Instance.new("Frame")
        Wrap.BackgroundTransparency = 1
        Wrap.Size = UDim2.new(1, -20, 0, 55)
        Wrap.Position = UDim2.new(0, 10, 0, currentY)
        Wrap.Parent = ContentContainer

        -- BUTTON
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -20, 0, 45)
        Button.Position = UDim2.new(0, 10, 0, 5)
        Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 18
        Button.Text = description
        Button.Parent = Wrap

        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

        currentY = currentY + 60
        return Button
    end



    ----------------------------
    -- BUILD GUI
    ----------------------------

    local function buildGUI()
        if CoreGui:FindFirstChild("TheForgeBETA") then
            CoreGui.TheForgeBETA:Destroy()
        end

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "TheForgeBETA"
        ScreenGui.Parent = CoreGui

        -- MAIN FRAME
        local Main = Instance.new("Frame")
        Main.Size = UDim2.new(0, windowWidth, 0, windowHeight)
        Main.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
        Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Main.Parent = ScreenGui

        Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

        -- TITLEBAR
        local TitleBar = Instance.new("Frame")
        TitleBar.Size = UDim2.new(1, 0, 0, 50)
        TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TitleBar.Parent = Main
        Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -50, 1, 0)
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "NOCTICS — THE FORGE"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 20
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = TitleBar

        -- CLOSE BUTTON
        local CloseButton = Instance.new("TextButton")
        CloseButton.Size = UDim2.new(0, 40, 0, 40)
        CloseButton.Position = UDim2.new(1, -45, 0, 5)
        CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        CloseButton.Text = "X"
        CloseButton.Font = Enum.Font.GothamBold
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.TextSize = 18
        CloseButton.Parent = TitleBar
        Instance.new("UICorner", CloseButton)

        -- CONTENT
        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, 0, 1, -50)
        Scroll.Position = UDim2.new(0, 0, 0, 50)
        Scroll.BackgroundTransparency = 1
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
        Scroll.ScrollBarThickness = 6
        Scroll.Parent = Main

        ContentContainer = Instance.new("Frame")
        ContentContainer.BackgroundTransparency = 1
        ContentContainer.Size = UDim2.new(1, 0, 0, 600)
        ContentContainer.Parent = Scroll


        ----------------------------
        -- TOGGLES
        ----------------------------

        -- AutoMine
        local AutoMineBtn = createToggle("AutoMine", "⛏️ AUTO MINE")
        AutoMineBtn.MouseButton1Click:Connect(function()
            local newState = not FeatureStatus.AutoMine
            ToggleAutoMine(newState)
            AutoMineBtn.BackgroundColor3 = newState
                and Color3.fromRGB(0, 170, 0)
                or Color3.fromRGB(35, 35, 35)
        end)

        -- AutoForgePerfect
        local ForgeBtn = createToggle("Forge", "⚡ AUTO FORGE PERFECT")
        ForgeBtn.MouseButton1Click:Connect(function()
            local newState = not FeatureStatus.AutoForgePerfect
            ToggleAutoForgePerfect(newState)
            ForgeBtn.BackgroundColor3 = newState
                and Color3.fromRGB(0, 170, 0)
                or Color3.fromRGB(35, 35, 35)
        end)


        ----------------------------
        -- CLOSE BUTTON
        ----------------------------

        CloseButton.MouseButton1Click:Connect(function()
            CloseLogic()
            ScreenGui:Destroy()
        end)

        print("✓ Forge GUI Loaded.")
    end


    -- safe call
    pcall(buildGUI)

end
