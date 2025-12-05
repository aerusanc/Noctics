-- [[ NOCTICS - THE FORGE ULTRA CLEAN ]]
-- Auto Mining + Priority + Minimize GUI
-- No exploit-only functions, executor-safe for anything.

do
    ----------------------------------------------------------
    -- SERVICES
    ----------------------------------------------------------
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local function getHRP()
        local ch = player.Character or player.CharacterAdded:Wait()
        return ch:WaitForChild("HumanoidRootPart")
    end

    ----------------------------------------------------------
    -- SETTINGS
    ----------------------------------------------------------
    local SETTINGS = {
        MODE = "UNDER",      -- "UNDER" atau "OVER"
        Y_UNDER = -20,       -- Y saat noclip bawah
        Y_OVER = 120,        -- Y saat noclip atas
        AUTO_STOP_WHEN_FULL = false, -- inventory check belum dihubungkan
    }

    local MiningEnabled = false
    local MiningThread = nil

    ----------------------------------------------------------
    -- ORE FOLDERS
    ----------------------------------------------------------
    local oreFolders = {
        workspace:FindFirstChild("Ores"),
        workspace:FindFirstChild("SpawnedOres"),
        workspace:FindFirstChild("Resources") and workspace.Resources:FindFirstChild("Ore"),
        workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ores"),
        workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Ores"),
        workspace:FindFirstChild("Interactable") and workspace.Interactable:FindFirstChild("Ore"),
    }

    ----------------------------------------------------------
    -- HELPERS
    ----------------------------------------------------------
    local function tween(obj, time, props)
        TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
    end

    local function scanOres()
        local list = {}
        for _, folder in ipairs(oreFolders) do
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    if obj:IsA("Model") or obj:IsA("Part") then
                        table.insert(list, obj)
                    end
                end
            end
        end
        return list
    end

    local function getPriority(ore)
        local name = ore.Name:lower()
        if string.find(name, "shiny") then return 1 end
        if string.find(name, "hard") then return 2 end
        if string.find(name, "crystal") then return 3 end
        return 4
    end

    local function inventoryFull()
        -- Diisi manual kalau kamu sudah tahu struktur inventory.
        return false
    end

    local function moveToOre(ore)
        if not ore or not ore:IsDescendantOf(workspace) then return end
        local hrp = getHRP()
        local pos = ore:GetPivot().p

        if SETTINGS.MODE == "UNDER" then
            hrp.CFrame = CFrame.new(pos.X, SETTINGS.Y_UNDER, pos.Z)
        elseif SETTINGS.MODE == "OVER" then
            hrp.CFrame = CFrame.new(pos.X, SETTINGS.Y_OVER, pos.Z)
        end

        task.wait(0.15)
        hrp.CFrame = ore:GetPivot() + Vector3.new(0, 3, 0)
    end

    ----------------------------------------------------------
    -- MINING LOOP
    ----------------------------------------------------------
    local function startMining()
        if MiningThread then return end
        MiningEnabled = true
        MiningThread = task.spawn(function()
            while MiningEnabled do
                if SETTINGS.AUTO_STOP_WHEN_FULL and inventoryFull() then
                    print("[Noctics] Inventory penuh, AutoMine stop.")
                    MiningEnabled = false
                    break
                end

                local ores = scanOres()
                if #ores == 0 then
                    print("[Noctics] Tidak ada ore, menunggu...")
                    task.wait(1)
                else
                    table.sort(ores, function(a, b)
                        return getPriority(a) < getPriority(b)
                    end)

                    local target = ores[1]
                    print("[Noctics] Auto Mining...", target.Name)
                    moveToOre(target)
                    task.wait(0.4)
                end
            end
            MiningThread = nil
        end)
    end

    local function stopMining()
        MiningEnabled = false
    end

    ----------------------------------------------------------
    -- GUI
    ----------------------------------------------------------
    if CoreGui:FindFirstChild("NOCTICS_FORGE_CLEAN") then
        CoreGui.NOCTICS_FORGE_CLEAN:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "NOCTICS_FORGE_CLEAN"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 300, 0, 220)
    main.Position = UDim2.new(0.1, 0, 0.3, 0)
    main.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Instance.new("UICorner", main)

    -- drag
    do
        local dragging = false
        local dragStart, startPos

        main.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
            end
        end)

        main.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Text = "NOCTICS - FORGE"

    local close = Instance.new("TextButton", main)
    close.Size = UDim2.new(0, 24, 0, 24)
    close.Position = UDim2.new(1, -30, 0, 8)
    close.Text = "X"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 16
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.BackgroundColor3 = Color3.fromRGB(200,50,50)
    Instance.new("UICorner", close)

    close.MouseButton1Click:Connect(function()
        stopMining()
        gui:Destroy()
    end)

    local miniButton = Instance.new("TextButton", gui)
    miniButton.Size = UDim2.new(0, 80, 0, 28)
    miniButton.Position = UDim2.new(0.1, 0, 0.3, 0)
    miniButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
    miniButton.Text = "Forge"
    miniButton.Font = Enum.Font.GothamBold
    miniButton.TextSize = 14
    miniButton.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", miniButton)
    miniButton.Visible = false

    local minBtn = Instance.new("TextButton", main)
    minBtn.Size = UDim2.new(0, 24, 0, 24)
    minBtn.Position = UDim2.new(1, -60, 0, 8)
    minBtn.Text = "-"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 18
    minBtn.TextColor3 = Color3.fromRGB(255,255,255)
    minBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    Instance.new("UICorner", minBtn)

    minBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        miniButton.Visible = true
    end)

    miniButton.MouseButton1Click:Connect(function()
        main.Visible = true
        miniButton.Visible = false
    end)

    local autoBtn = Instance.new("TextButton", main)
    autoBtn.Size = UDim2.new(0, 260, 0, 40)
    autoBtn.Position = UDim2.new(0, 20, 0, 50)
    autoBtn.Text = "AUTO MINE: OFF"
    autoBtn.Font = Enum.Font.GothamBold
    autoBtn.TextSize = 16
    autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
    autoBtn.BackgroundColor3 = Color3.fromRGB(120,30,30)
    Instance.new("UICorner", autoBtn)

    autoBtn.MouseButton1Click:Connect(function()
        if MiningEnabled then
            stopMining()
            autoBtn.Text = "AUTO MINE: OFF"
            autoBtn.BackgroundColor3 = Color3.fromRGB(120,30,30)
        else
            startMining()
            autoBtn.Text = "AUTO MINE: ON"
            autoBtn.BackgroundColor3 = Color3.fromRGB(30,120,40)
        end
    end)

    local modeBtn = Instance.new("TextButton", main)
    modeBtn.Size = UDim2.new(0, 260, 0, 32)
    modeBtn.Position = UDim2.new(0, 20, 0, 100)
    modeBtn.Text = "MODE: UNDERGROUND"
    modeBtn.Font = Enum.Font.Gotham
    modeBtn.TextSize = 14
    modeBtn.TextColor3 = Color3.fromRGB(230,230,230)
    modeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", modeBtn)

    modeBtn.MouseButton1Click:Connect(function()
        if SETTINGS.MODE == "UNDER" then
            SETTINGS.MODE = "OVER"
            modeBtn.Text = "MODE: OVERGROUND"
        else
            SETTINGS.MODE = "UNDER"
            modeBtn.Text = "MODE: UNDERGROUND"
        end
    end)

    local refreshBtn = Instance.new("TextButton", main)
    refreshBtn.Size = UDim2.new(0, 260, 0, 32)
    refreshBtn.Position = UDim2.new(0, 20, 0, 140)
    refreshBtn.Text = "REFRESH ORES (LOG ONLY)"
    refreshBtn.Font = Enum.Font.Gotham
    refreshBtn.TextSize = 14
    refreshBtn.TextColor3 = Color3.fromRGB(230,230,230)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(40,40,80)
    Instance.new("UICorner", refreshBtn)

    refreshBtn.MouseButton1Click:Connect(function()
        local ores = scanOres()
        print("[Noctics] Jumlah ore terdeteksi:", #ores)
        for i, o in ipairs(ores) do
            print(i, o:GetFullName())
        end
    end)
end
