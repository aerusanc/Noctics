
do
    -------------------------------------------------------
    -- SERVICES
    -------------------------------------------------------
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    -------------------------------------------------------
    -- ERROR PATCH (BLOCK UIController NumberSequence BUG)
    -------------------------------------------------------
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = function(self, ...)
        local method = getnamecallmethod()

        if tostring(self) == "Notifications" then
            local args = {...}
            if typeof(args[1]) == "NumberSequence" then
                local last = -1
                for _,kp in ipairs(args[1].Keypoints) do
                    if kp.Time < last then
                        return nil
                    end
                    last = kp.Time
                end
            end
        end

        return old(self, ...)
    end

    setreadonly(mt, true)

    -------------------------------------------------------
    -- CONFIG
    -------------------------------------------------------
    local SETTINGS = {
        AUTOSTOP_INVENTORY_FULL = true,
        SAFE_DISTANCE = 100,
        MODE = "UNDER", -- UNDER / OVER
        MIN_Y = -20,
        MAX_Y = 120,
    }

    local MiningEnabled = false
    local killSwitch = false
    local oreList = {}

    -------------------------------------------------------
    -- ORE PATHS
    -------------------------------------------------------
    local oreFolders = {
        workspace:FindFirstChild("Ores"),
        workspace:FindFirstChild("SpawnedOres"),
        workspace:FindFirstChild("Resources") and workspace.Resources:FindFirstChild("Ore"),
        workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ores"),
        workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Ores"),
        workspace:FindFirstChild("Interactable") and workspace.Interactable:FindFirstChild("Ore"),
    }

    -------------------------------------------------------
    -- SCAN ORES
    -------------------------------------------------------
    local function scanOres()
        local found = {}
        for _,folder in ipairs(oreFolders) do
            if folder and folder:IsA("Folder") then
                for _,obj in ipairs(folder:GetChildren()) do
                    if obj:IsA("Model") or obj:IsA("Part") then
                        table.insert(found, obj)
                    end
                end
            end
        end
        return found
    end

    -------------------------------------------------------
    -- PRIORITY SYSTEM
    -------------------------------------------------------
    local function getPriority(ore)
        local name = ore.Name:lower()

        if string.find(name, "shiny") then return 1 end
        if string.find(name, "hard") then return 2 end
        if string.find(name, "crystal") then return 3 end

        return 4
    end

    -------------------------------------------------------
    -- PATHFIND + MOVE
    -------------------------------------------------------
    local function moveToOre(ore)
        if not ore or not ore:IsDescendantOf(workspace) then return end

        local pos = ore:GetPivot().p

        if SETTINGS.MODE == "UNDER" then
            hrp.CFrame = CFrame.new(pos.X, SETTINGS.MIN_Y, pos.Z)
        elseif SETTINGS.MODE == "OVER" then
            hrp.CFrame = CFrame.new(pos.X, SETTINGS.MAX_Y, pos.Z)
        end

        task.wait(0.1)

        hrp.CFrame = ore:GetPivot() + Vector3.new(0, 3, 0)
    end

    -------------------------------------------------------
    -- INVENTORY CHECK (NEED CONFIG)
    -------------------------------------------------------
    local function inventoryFull()
        return false -- kamu bisa isi sendiri jika tahu folder inventory
    end

    -------------------------------------------------------
    -- AI MINING ENGINE
    -------------------------------------------------------
    local function miningThread()
        while MiningEnabled and not killSwitch do

            if SETTINGS.AUTOSTOP_INVENTORY_FULL and inventoryFull() then
                MiningEnabled = false
                print("[NOCTICS] Inventory Penuh. AutoMine dihentikan.")
                break
            end

            local ores = scanOres()
            if #ores == 0 then
                print("[NOCTICS] Tidak ada ore.")
                task.wait(1)
                continue
            end

            table.sort(ores, function(a,b)
                return getPriority(a) < getPriority(b)
            end)

            local target = ores[1]

            print("[NOCTICS] Target:", target.Name)
            moveToOre(target)

            task.wait(0.3)
        end
    end

    -------------------------------------------------------
    -- GUI PRO (MINIMIZE)
    -------------------------------------------------------
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "NOCTICS_FORGE_ULTRA"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 300, 0, 260)
    Main.Position = UDim2.new(0.1, 0, 0.3, 0)
    Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Instance.new("UICorner", Main)

    local MinBtn = Instance.new("TextButton", Main)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -40, 0, 10)
    MinBtn.Text = "-"
    MinBtn.TextSize = 24
    MinBtn.BackgroundColor3 = Color3.fromRGB(90,90,90)
    Instance.new("UICorner", MinBtn)

    local MiniIcon = Instance.new("TextButton", ScreenGui)
    MiniIcon.Size = UDim2.new(0, 60, 0, 30)
    MiniIcon.Position = UDim2.new(0.1, 0, 0.3, 0)
    MiniIcon.Text = "Forge"
    MiniIcon.Visible = false

    MinBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        MiniIcon.Visible = true
    end)

    MiniIcon.MouseButton1Click:Connect(function()
        MiniIcon.Visible = false
        Main.Visible = true
    end)

    -------------------------------------------------------
    -- BUTTON AUTOMINE
    -------------------------------------------------------
    local autoBtn = Instance.new("TextButton", Main)
    autoBtn.Size = UDim2.new(0, 240, 0, 40)
    autoBtn.Position = UDim2.new(0, 30, 0, 60)
    autoBtn.Text = "AUTO MINE OFF"
    autoBtn.BackgroundColor3 = Color3.fromRGB(80,0,0)
    Instance.new("UICorner", autoBtn)

    autoBtn.MouseButton1Click:Connect(function()
        MiningEnabled = not MiningEnabled

        if MiningEnabled then
            autoBtn.Text = "AUTO MINE ON"
            autoBtn.BackgroundColor3 = Color3.fromRGB(0,120,0)
            killSwitch = false
            task.spawn(miningThread)
        else
            autoBtn.Text = "AUTO MINE OFF"
            autoBtn.BackgroundColor3 = Color3.fromRGB(80,0,0)
            killSwitch = true
        end
    end)

    -------------------------------------------------------
    -- REFRESH + MODE
    -------------------------------------------------------
    local modeBtn = Instance.new("TextButton", Main)
    modeBtn.Size = UDim2.new(0, 240, 0, 40)
    modeBtn.Position = UDim2.new(0, 30, 0, 120)
    modeBtn.Text = "MODE: UNDERGROUND"
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

    -------------------------------------------------------
    -- REFRESH BUTTON
    -------------------------------------------------------
    local refBtn = Instance.new("TextButton", Main)
    refBtn.Size = UDim2.new(0, 240, 0, 40)
    refBtn.Position = UDim2.new(0, 30, 0, 180)
    refBtn.Text = "REFRESH ORES"
    refBtn.BackgroundColor3 = Color3.fromRGB(40,40,90)
    Instance.new("UICorner", refBtn)

    refBtn.MouseButton1Click:Connect(function()
        oreList = scanOres()
        print("[NOCTICS] Ores ditemukan:", #oreList)
    end)
end
