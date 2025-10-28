-- 🖤 Noctics Hub - Elegant Black GUI
print("🧠 Loading Noctics Hub GUI...")

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- GUI Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NocticsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 620, 0, 360)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(60, 100, 255)
UIStroke.Thickness = 1

-- Title Bar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "Noctics Hub"
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Sidebar.BorderSizePixel = 0

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 8)

-- Content Area
local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -160, 1, -50)
Content.Position = UDim2.new(0, 160, 0, 50)
Content.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Content.BorderSizePixel = 0
Instance.new("UICorner", Content)

-- Function to clear content
local function ClearContent()
	for _, v in ipairs(Content:GetChildren()) do
		if v:IsA("Frame") or v:IsA("TextLabel") or v:IsA("TextButton") then
			v:Destroy()
		end
	end
end

-- Function to create submenu
local function CreateSubmenu(menuName, options)
	ClearContent()

	local Title = Instance.new("TextLabel", Content)
	Title.Text = menuName
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 22
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 15, 0, 10)
	Title.Size = UDim2.new(1, -20, 0, 30)
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local List = Instance.new("Frame", Content)
	List.Position = UDim2.new(0, 10, 0, 50)
	List.Size = UDim2.new(1, -20, 1, -60)
	List.BackgroundTransparency = 1

	local UIList = Instance.new("UIListLayout", List)
	UIList.Padding = UDim.new(0, 6)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.SortOrder = Enum.SortOrder.LayoutOrder

	for _, opt in ipairs(options) do
		local Btn = Instance.new("TextButton", List)
		Btn.Size = UDim2.new(1, 0, 0, 35)
		Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
		Btn.Font = Enum.Font.Gotham
		Btn.TextSize = 15
		Btn.Text = opt.name

		local BtnCorner = Instance.new("UICorner", Btn)
		BtnCorner.CornerRadius = UDim.new(0, 6)

		local BtnStroke = Instance.new("UIStroke", Btn)
		BtnStroke.Color = Color3.fromRGB(60, 100, 255)
		BtnStroke.Thickness = 0.6
		BtnStroke.Transparency = 0.5

		Btn.MouseEnter:Connect(function()
			TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
		end)
		Btn.MouseLeave:Connect(function()
			TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
		end)
		Btn.MouseButton1Click:Connect(opt.callback)
	end
end

-- Menu Items
local menus = {
	{
		name = "Auto Farm",
		sub = {
			{name = "Start Auto Farm", callback = function() print("Auto Farm Started") end},
			{name = "Stop Auto Farm", callback = function() print("Auto Farm Stopped") end},
		}
	},
	{
		name = "Player",
		sub = {
			{name = "Speed Boost", callback = function() Player.Character.Humanoid.WalkSpeed = 50 end},
			{name = "Jump Boost", callback = function() Player.Character.Humanoid.JumpPower = 100 end},
			{name = "Reset Boosts", callback = function()
				Player.Character.Humanoid.WalkSpeed = 16
				Player.Character.Humanoid.JumpPower = 50
			end}
		}
	},
	{
		name = "Visual",
		sub = {
			{name = "Night Mode", callback = function() game.Lighting.ClockTime = 0 end},
			{name = "Day Mode", callback = function() game.Lighting.ClockTime = 14 end},
		}
	},
	{
		name = "About",
		sub = {
			{name = "Credits", callback = function()
				ClearContent()
				local info = Instance.new("TextLabel", Content)
				info.Text = "🖤 Noctics Hub v1.0\nCreated by Aerusanc"
				info.Font = Enum.Font.GothamSemibold
				info.TextSize = 18
				info.TextColor3 = Color3.fromRGB(200, 200, 200)
				info.BackgroundTransparency = 1
				info.Position = UDim2.new(0, 20, 0, 40)
				info.Size = UDim2.new(1, -40, 1, -80)
				info.TextXAlignment = Enum.TextXAlignment.Left
				info.TextYAlignment = Enum.TextYAlignment.Top
			end},
		}
	}
}

-- Sidebar Buttons
local UIList = Instance.new("UIListLayout", Sidebar)
UIList.Padding = UDim.new(0, 5)
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.VerticalAlignment = Enum.VerticalAlignment.Top
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

for _, menu in ipairs(menus) do
	local Btn = Instance.new("TextButton", Sidebar)
	Btn.Size = UDim2.new(1, -20, 0, 35)
	Btn.Position = UDim2.new(0, 10, 0, 0)
	Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	Btn.Font = Enum.Font.Gotham
	Btn.Text = menu.name
	Btn.TextSize = 16

	local BtnCorner = Instance.new("UICorner", Btn)
	BtnCorner.CornerRadius = UDim.new(0, 6)

	Btn.MouseButton1Click:Connect(function()
		CreateSubmenu(menu.name, menu.sub)
	end)

	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
	end)
end

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton", TopBar)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -40, 0, 5)
MinimizeBtn.Text = "_"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 22
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
local MinBtnCorner = Instance.new("UICorner", MinimizeBtn)
MinBtnCorner.CornerRadius = UDim.new(0, 5)

MinimizeBtn.MouseEnter:Connect(function()
	TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
end)
MinimizeBtn.MouseLeave:Connect(function()
	TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
end)

-- Minimize/Restore Function
local isMinimized = false
local originalSize = MainFrame.Size
local originalPosition = MainFrame.Position

local function ToggleMinimize()
	if isMinimized then
		MainFrame:TweenSizeAndPosition(originalSize, originalPosition, "Out", "Quad", 0.25, true)
	else
		MainFrame:TweenSizeAndPosition(UDim2.new(0, 200, 0, 40), UDim2.new(0.5, -100, 0.5, -20), "Out", "Quad", 0.25, true)
	end
	isMinimized = not isMinimized
end

MinimizeBtn.MouseButton1Click:Connect(ToggleMinimize)

-- Keybind (G)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.G then
		ToggleMinimize()
	end
end)


print("✅ Noctics Hub GUI Loaded Successfully.")
