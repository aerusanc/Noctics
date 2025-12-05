-- [[ NOCTICS - THE FORGE BETA (PRO VERSION) ]]
-- Premium UI * Smooth Tween * Blur * Shadow * Category Panel * Clean Logic
-- Made by RYU - Optimized & Executor-Safe

do
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Lighting = game:GetService("Lighting")

    local FeatureStatus = {
        AutoMine = false,
        AutoForgePerfect = false,
        SelectedOres = {},
    }

    local Threads = {}

    local function tween(obj, time, props)
        TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
    end

    local function ToggleAutoMine(state)
        FeatureStatus.AutoMine = state
        if state then
            Threads.AutoMine = task.spawn(function()
                while FeatureStatus.AutoMine do
                    print("[Noctics] Auto Mining…")
                    task.wait(1)
                end
            end)
        else
            if Threads.AutoMine then
                task.cancel(Threads.AutoMine)
            end
        end
    end

    local function ToggleAutoForgePerfect(state)
        FeatureStatus.AutoForgePerfect = state
        print("[Noctics] Auto Forge Perfect =", state)
    end

    local function enableDragging(gui)
        local dragging, dragStart, startPos
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
            end
        end)
        gui.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    local function createShadow(parent)
        local shadow = Instance.new("ImageLabel", parent)
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.Position = UDim2.new(0.5, 0, 0.5, 8)
        shadow.Size = UDim2.new(1, 40, 1, 40)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://1316045217"
        shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        shadow.ImageTransparency = 0.4
        return shadow
    end

    local function createToggle(text)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 50)
        frame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame)

        local label = Instance.new("TextLabel", frame)
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -70, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = text

        local button = Instance.new("Frame", frame)
        button.Size = UDim2.new(0, 45, 0, 22)
        button.Position = UDim2.new(1, -55, 0.5, -11)
        button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
        Instance.new("UICorner", button)

        local knob = Instance.new("Frame", button)
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = UDim2.new(0, 1, 0, 1)
        knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        Instance.new("UICorner", knob)

        return frame, button, knob
    end

    local function buildGUI()
        if CoreGui:FindFirstChild("NOCTICS_FORGE_PRO") then
            CoreGui.NOCTICS_FORGE_PRO:Destroy()
        end

        local blur = Instance.new("BlurEffect")
        blur.Size = 12
        blur.Parent = Lighting

        local gui = Instance.new("ScreenGui", CoreGui)
        gui.Name = "NOCTICS_FORGE_PRO"
        gui.ResetOnSpawn = false

        local main = Instance.new("Frame", gui)
        main.Size = UDim2.new(0, 560, 0, 335)
        main.Position = UDim2.new(0.5, -280, 0.5, -170)
        main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Instance.new("UICorner", main)

        createShadow(main)
        enableDragging(main)

        local header = Instance.new("Frame", main)
        header.Size = UDim2.new(1, 0, 0, 55)
        header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Instance.new("UICorner", header)

        local title = Instance.new("TextLabel", header)
        title.Size = UDim2.new(1, -60, 1, 0)
        title.Position = UDim2.new(0, 10, 0, 0)
        title.Text = "NOCTICS - THE FORGE PRO"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 20
        title.BackgroundTransparency = 1
        title.TextXAlignment = Enum.TextXAlignment.Left

        local close = Instance.new("TextButton", header)
        close.Size = UDim2.new(0, 42, 0, 42)
        close.Position = UDim2.new(1, -50, 0.5, -21)
        close.Text = "X"
        close.TextColor3 = Color3.fromRGB(255, 255, 255)
        close.Font = Enum.Font.GothamBold
        close.TextSize = 22
        close.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        Instance.new("UICorner", close)

        close.MouseButton1Click:Connect(function()
            blur:Destroy()
            gui:Destroy()
        end)

        local sidebar = Instance.new("Frame", main)
        sidebar.Size = UDim2.new(0, 150, 1, -55)
        sidebar.Position = UDim2.new(0, 0, 0, 55)
        sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Instance.new("UICorner", sidebar)

        local categories = {"MINING", "FORGE", "UTILITY"}
        local pages = {}
        for i, name in ipairs(categories) do
            local btn = Instance.new("TextButton", sidebar)
            btn.Size = UDim2.new(1, -20, 0, 40)
            btn.Position = UDim2.new(0, 10, 0, 10 + (i-1)*50)
            btn.Text = name
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 16
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            Instance.new("UICorner", btn)

            local page = Instance.new("ScrollingFrame", main)
            page.Size = UDim2.new(1, -160, 1, -65)
            page.Position = UDim2.new(0, 155, 0, 60)
            page.BackgroundTransparency = 1
            page.CanvasSize = UDim2.new(0, 0, 0, 400)
            page.Visible = false
            pages[name] = page

            btn.MouseButton1Click:Connect(function()
                for _, p in pairs(pages) do p.Visible = false end
                pages[name].Visible = true
            end)

            if i == 1 then
                page.Visible = true
            end
        end

        do  -- MINING page
            local page = pages["MINING"]
            local frame, toggleBtn, knob = createToggle("AUTO MINE")
            frame.Parent = page

            toggleBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local new = not FeatureStatus.AutoMine
                    ToggleAutoMine(new)
                    if new then
                        tween(knob, 0.2, {Position = UDim2.new(1, -21, 0, 1)})
                        tween(toggleBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(0,170,0)})
                    else
                        tween(knob, 0.2, {Position = UDim2.new(0, 1, 0, 1)})
                        tween(toggleBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(90,90,90)})
                    end
                end
            end)
        end

        do  -- FORGE page
            local page = pages["FORGE"]
            local frame, toggleBtn, knob = createToggle("AUTO FORGE PERFECT")
            frame.Parent = page

            toggleBtn.MouseButton1Click:Connect(function()
                local new = not FeatureStatus.AutoForgePerfect
                ToggleAutoForgePerfect(new)
                if new then
                    tween(knob, 0.2, {Position = UDim2.new(1, -21, 0, 1)})
                    tween(toggleBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(0,170,0)})
                else
                    tween(knob, 0.2, {Position = UDim2.new(0, 1, 0, 1)})
                    tween(toggleBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(90,90,90)})
                end
            end)
        end
    end

    pcall(buildGUI)
end
