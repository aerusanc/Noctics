-- Noctics Hub - Minimal Clean UI (Merged with Elegant Black GUI features)
-- Sidebar: Main, Backpack, Teleport, Utilities
-- Main page: Dropdown "Fishing" & "Event" (Auto Fishing, Cancel Fishing, Auto Teleport)
-- Utilities: Auto Farm, Player (WS/JP), Visual (Night/Day), About
-- Keybind: G (toggle show/hide), Minimize -> Dock icon, Close -> Destroy GUI

--======================================================
-- Services & Utils
--======================================================
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local TS      = game:GetService("TweenService")
local RS      = game:GetService("RunService")
local WS      = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function tween(o,t,props)
	TS:Create(o, TweenInfo.new(t or 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function style(obj, props)
	for k,v in pairs(props) do obj[k] = v end
end

local C = {
	bg   = Color3.fromRGB(18,18,18),
	pane = Color3.fromRGB(26,26,26),
	pane2= Color3.fromRGB(32,32,32),
	text = Color3.fromRGB(235,235,235),
	dim  = Color3.fromRGB(185,185,185),
	line = Color3.fromRGB(58,58,58),
	hi   = Color3.fromRGB(96,160,255)
}
local HOTKEY = Enum.KeyCode.G

--======================================================
-- Bootstrap: ScreenGui ke PlayerGui (bukan StarterGui)
--======================================================
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("MainGui")
if old then old:Destroy() end

local root = Instance.new("ScreenGui")
root.Name = "MainGui"
root.ResetOnSpawn = false
root.IgnoreGuiInset = true
root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
root.Parent = playerGui

--(opsional) badge kecil indikator loaded
do
	local badge = Instance.new("TextLabel")
	badge.Size = UDim2.fromOffset(110,18)
	badge.Position = UDim2.new(1,-120,0,8)
	badge.BackgroundColor3 = Color3.fromRGB(30,30,30)
	badge.BackgroundTransparency = 0.3
	badge.Text = "Noctics Hub Loaded"
	badge.TextSize = 12
	badge.Font = Enum.Font.Gotham
	badge.TextColor3 = C.text
	badge.Parent = root
	task.delay(1.2, function() if badge and badge.Parent then badge:Destroy() end end)
end

--======================================================
-- Dock Icon (muncul kalau minimize/hidden)
--======================================================
local dock = Instance.new("TextButton")
dock.Name = "DockIcon"
dock.Parent = root
style(dock, {
	Size = UDim2.fromOffset(34,34),
	Position = UDim2.new(0,14,1,-48),
	Text = "🖤",
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	TextColor3 = C.text,
	BackgroundColor3 = C.pane2,
	AutoButtonColor = true,
	Visible = false
})
Instance.new("UICorner", dock).CornerRadius = UDim.new(0,8)

--======================================================
-- Main Window
--======================================================
local main = Instance.new("Frame", root)
style(main, {
	Size = UDim2.fromOffset(420,280),
	Position = UDim2.fromScale(.5,.5),
	AnchorPoint = Vector2.new(.5,.5),
	BackgroundColor3 = C.bg,
	Active = true,
	Draggable = true
})
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
local topLine = Instance.new("Frame", main) style(topLine,{Size=UDim2.new(1,0,0,1),BackgroundColor3=C.line})

-- Titlebar
local bar = Instance.new("Frame", main)
style(bar, {Size=UDim2.new(1,-16,0,32), Position=UDim2.new(0,8,0,8), BackgroundColor3=C.pane})
Instance.new("UICorner", bar).CornerRadius = UDim.new(0,8)
local title = Instance.new("TextLabel", bar)
style(title, {BackgroundTransparency=1, Size=UDim2.new(1,-84,1,0), Position=UDim2.new(0,10,0,0),
	Text="🖤 Noctics Hub", TextSize=15, Font=Enum.Font.GothamSemibold, TextColor3=C.text, TextXAlignment=Enum.TextXAlignment.Left})

-- Minimize & Close Buttons
local btnClose = Instance.new("TextButton", bar)
style(btnClose, {Size=UDim2.fromOffset(24,24), Position=UDim2.new(1,-30,.5,-12), Text="✕", TextSize=16, BackgroundColor3=C.pane2, TextColor3=Color3.fromRGB(255,100,100), Font=Enum.Font.GothamBold})
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0,6)
local btnMin = Instance.new("TextButton", bar)
style(btnMin, {Size=UDim2.fromOffset(24,24), Position=UDim2.new(1,-60,.5,-12), Text="–", TextSize=16, BackgroundColor3=C.pane2, TextColor3=C.text})
Instance.new("UICorner", btnMin).CornerRadius = UDim.new(0,6)

-- Body
local body = Instance.new("Frame", main)
style(body, {Size=UDim2.new(1,-16,1,-56), Position=UDim2.new(0,8,0,40), BackgroundTransparency=1})

--======================================================
-- Sidebar (4 item)
--======================================================
local side = Instance.new("Frame", body)
style(side, {Size=UDim2.new(0,136,1,0), BackgroundColor3=C.pane})
Instance.new("UICorner", side).CornerRadius = UDim.new(0,8)
local sidePad = Instance.new("UIPadding", side)
sidePad.PaddingLeft = UDim.new(0,6); sidePad.PaddingTop = UDim.new(0,6)
sidePad.PaddingRight = UDim.new(0,6); sidePad.PaddingBottom = UDim.new(0,6)

local sideWrap = Instance.new("Frame", side)
style(sideWrap, {Size=UDim2.fromScale(1,1), BackgroundTransparency = 1})
local sbList = Instance.new("UIListLayout", sideWrap) sbList.Padding = UDim.new(0,6)

local function makeSideButton(text)
	local b = Instance.new("TextButton", sideWrap)
	style(b, {Size=UDim2.new(1,0,0,28), Text="  "..text, TextXAlignment=Enum.TextXAlignment.Left,
		BackgroundColor3=C.pane2, TextColor3=C.text, TextSize=14, Font=Enum.Font.GothamSemibold})
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	b.AutoButtonColor = false
	b.MouseEnter:Connect(function()
		if b.BackgroundColor3 ~= C.pane then tween(b,.08,{BackgroundColor3=C.pane}) end
	end)
	b.MouseLeave:Connect(function()
		if b ~= _G.__activeBtn then tween(b,.10,{BackgroundColor3=C.pane2}) end
	end)
	return b
end

--======================================================
-- Content Panel
--======================================================
local content = Instance.new("Frame", body)
style(content, {Size=UDim2.new(1,-(136+8),1,0), Position=UDim2.new(0,136+8,0,0), BackgroundColor3=C.pane})
Instance.new("UICorner", content).CornerRadius = UDim.new(0,8)
local cPad = Instance.new("UIPadding", content)
cPad.PaddingLeft=UDim.new(0,10); cPad.PaddingTop=UDim.new(0,8)
cPad.PaddingRight=UDim.new(0,10)
cPad.PaddingBottom=UDim.new(0,8)

local cTitle = Instance.new("TextLabel", content)
style(cTitle, {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="Welcome",
	TextSize=15, Font=Enum.Font.GothamSemibold, TextColor3=C.text, TextXAlignment=Enum.TextXAlignment.Left})
local divider = Instance.new("Frame", content) style(divider,{Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0,24), BackgroundColor3=C.line})

local cArea = Instance.new("Frame", content)
style(cArea, {Size=UDim2.new(1,0,1,-28), Position=UDim2.new(0,0,0,28), BackgroundTransparency=1})

--======================================================
-- Active state (sidebar)
--======================================================
_G.__activeBtn = nil
local function setActive(btn)
	if _G.__activeBtn and _G.__activeBtn ~= btn then
		tween(_G.__activeBtn, .10, {BackgroundColor3 = C.pane2})
		for _,c in ipairs(_G.__activeBtn:GetChildren()) do
			if c.Name=="ActLine" then c:Destroy() end
		end
	end
	_G.__activeBtn = btn
	tween(btn, .10, {BackgroundColor3 = C.pane})
	local line = Instance.new("Frame", btn) line.Name="ActLine"
	style(line, {Size=UDim2.new(0,2,1,0), Position=UDim2.new(0,0,0,0), BackgroundColor3=C.hi})
end

--======================================================
-- FishIt: Generic Fishing Helper (client-side)
--======================================================
local FishIt = {}
do
	local ROD_KEYWORDS = {"Rod","Pancing","Fishing"}
	local RECAST_INTERVAL = {min=6, max=10}
	local SPOT_NAMES = {"FishingSpot","Lake","Water"}

	local flags = {
		autoFishing = false,
		cancelFishing = false,
		autoTeleport = false,
		selectedEvent = nil,
	}
	local threads = { fishing = nil }

	local function getCharacter()
		return player.Character or player.CharacterAdded:Wait()
	end
	local function findRod()
		local inv = {player.Backpack, getCharacter()}
		for _,container in ipairs(inv) do
			if container then
				for _,obj in ipairs(container:GetChildren()) do
					if obj:IsA("Tool") then
						local n = obj.Name:lower()
						for _,k in ipairs(ROD_KEYWORDS) do
							if string.find(n, k:lower()) then
								return obj
							end
						end
					end
				end
			end
		end
		return nil
	end
	local function equipRod()
		local rod = findRod()
		if rod and rod.Parent ~= getCharacter() then
			rod.Parent = getCharacter()
			task.wait(0.1)
		end
		return rod
	end
	local function unequipAll()
		pcall(function() getCharacter():FindFirstChildOfClass("Humanoid"):UnequipTools() end)
	end
	local function findMarkerByName(name)
		if not name then return nil end
		name = name:lower()
		for _,desc in ipairs(WS:GetDescendants()) do
			if desc:IsA("BasePart") and desc.Name:lower() == name then return desc end
		end
		for _,desc in ipairs(WS:GetDescendants()) do
			if desc:IsA("BasePart") and string.find(desc.Name:lower(), name, 1, true) then return desc end
		end
		return nil
	end
	local function teleportToEvent(name)
		local rootPart = getCharacter():FindFirstChild("HumanoidRootPart")
		if not rootPart then return end
		local target = findMarkerByName(name)
		if target then rootPart.CFrame = target.CFrame + Vector3.new(0,3,0) end
	end
	local function tryCast(rod)
		if not rod then return false end
		if rod:IsDescendantOf(getCharacter()) and rod:FindFirstChildWhichIsA("RemoteEvent") == nil then
			pcall(function() rod:Activate() end)
			return true
		end
		--[=[ EDIT HERE: sesuaikan remote cast/cancel bila ada di game kamu ]=]
		return false
	end
	local function tryCancel(_rod)
		unequipAll()
		--[=[ EDIT HERE: panggil remote cancel bila ada ]=]
	end
	local function randf(a,b) return a + math.random()*(b-a) end
	local function fishingWorker()
		while flags.autoFishing do
			if flags.cancelFishing then
				tryCancel(findRod()); flags.cancelFishing = false
			end
			local rod = equipRod()
			if rod then tryCast(rod) end
			local waitTime = randf(RECAST_INTERVAL.min, RECAST_INTERVAL.max)
			for _=1, math.ceil(waitTime*10) do
				if not flags.autoFishing then break end
				if flags.cancelFishing then tryCancel(rod); flags.cancelFishing=false end
				task.wait(0.1)
			end
		end
	end

	function FishIt.Start()
		if flags.autoFishing then return end
		flags.autoFishing = true
		if threads.fishing == nil or coroutine.status(threads.fishing) == "dead" then
			threads.fishing = coroutine.create(fishingWorker)
			coroutine.resume(threads.fishing)
		end
	end
	function FishIt.Stop() flags.autoFishing=false; flags.cancelFishing=false; unequipAll() end
	function FishIt.CancelNow() flags.cancelFishing = true end
	function FishIt.SetAutoTeleport(on, name) flags.autoTeleport=on; flags.selectedEvent=name; if on and name then teleportToEvent(name) end end
	function FishIt.SetSelectedEvent(name) flags.selectedEvent = name end
	function FishIt.GetFlags() return flags end
end

--======================================================
-- Content helpers (toggle, dropdown, button row)
--======================================================
local function clearContent()
	for _,c in ipairs(cArea:GetChildren()) do c:Destroy() end
end

local function header(txt) cTitle.Text = txt end

local function makeToggle(parent, label, default, onChange)
	local row = Instance.new("Frame", parent)
	style(row,{Size=UDim2.new(1,0,0,24), BackgroundTransparency=1})

	local txt = Instance.new("TextLabel", row)
	style(txt,{Size=UDim2.new(1,-64,1,0), BackgroundTransparency=1, Text=label, TextSize=14,
		Font=Enum.Font.Gotham, TextColor3=C.text, TextXAlignment=Enum.TextXAlignment.Left})

	local btn = Instance.new("TextButton", row)
	style(btn,{Size=UDim2.fromOffset(48,22), Position=UDim2.new(1,-52,0.5,-11), Text="", BackgroundColor3=C.pane2})
	Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame", btn)
	style(knob,{Size=UDim2.fromOffset(18,18), Position=UDim2.new(0,2,0.5,-9), BackgroundColor3=C.dim})
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

	local state = default and true or false
	local function render()
		tween(btn,.1,{BackgroundColor3 = state and C.hi or C.pane2})
		tween(knob,.1,{Position = state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9),
			BackgroundColor3 = state and C.text or C.dim})
	end
	render()

	btn.MouseButton1Click:Connect(function()
		state = not state
		render()
		if onChange then onChange(state) end
	end)

	return { get=function() return state end, set=function(v) state=v; render() end }
end

local function makeContentDropdown(titleText)
	local wrap = Instance.new("Frame", cArea)
	style(wrap, {Size=UDim2.new(1,0,0,28), BackgroundColor3=C.pane2})
	Instance.new("UICorner", wrap).CornerRadius = UDim.new(0,6)

	local head = Instance.new("TextButton", wrap)
	style(head, {Size=UDim2.new(1,0,0,28), Text="  "..titleText.."  ⌄", TextXAlignment=Enum.TextXAlignment.Left,
		TextColor3=C.text, TextSize=14, BackgroundTransparency=1, Font=Enum.Font.GothamSemibold})

	local container = Instance.new("Frame", wrap)
	style(container, {Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,0,28), BackgroundColor3=C.pane, ClipsDescendants=true})
	local pad = Instance.new("UIPadding", container)
	pad.PaddingLeft=UDim.new(0,8); pad.PaddingTop=UDim.new(0,6); pad.PaddingRight=UDim.new(0,8); pad.PaddingBottom=UDim.new(0,8)
	local li = Instance.new("UIListLayout", container) li.Padding = UDim.new(0,6)

	local open = false
	local function toggle()
		open = not open
		head.Text = "  "..titleText..(open and "  ⌃" or "  ⌄")
		tween(container, .14, {Size = UDim2.new(1,0,0, open and (li.AbsoluteContentSize.Y + 12) or 0)})
	end
	head.MouseButton1Click:Connect(toggle)

	li:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		if open then container.Size = UDim2.new(1,0,0, li.AbsoluteContentSize.Y + 12) end
	end)

	local function addToggle(label, default, onChange)
		return makeToggle(container, label, default, onChange)
	end

	local function addSelector(label, listItems, defaultText, onPick)
		local row = Instance.new("Frame", container)
		style(row, {Size=UDim2.new(1,0,0,24), BackgroundTransparency=1})

		local lbl = Instance.new("TextLabel", row)
		style(lbl, {Size=UDim2.new(.4,0,1,0), BackgroundTransparency=1, Text=label, TextSize=14,
			TextXAlignment=Enum.TextXAlignment.Left, TextColor3=C.text, Font=Enum.Font.Gotham})

		local btn = Instance.new("TextButton", row)
		style(btn, {Size=UDim2.new(.6,0,1,0), Position=UDim2.new(.4,0,0,0),
			Text=" "..(defaultText or "Choose…"), TextXAlignment=Enum.TextXAlignment.Left,
			BackgroundColor3=C.pane2, TextColor3=C.text, TextSize=14, Font=Enum.Font.Gotham})
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

		local popup = Instance.new("Frame", container)
		style(popup, {Size=UDim2.new(.6,0,0,0), Position=UDim2.new(.4,0,0,24+4), BackgroundColor3=C.pane, ClipsDescendants=true})
		Instance.new("UICorner", popup).CornerRadius = UDim.new(0,6)
		local pLi = Instance.new("UIListLayout", popup) pLi.Padding = UDim.new(0,2)

		local openSel = false
		btn.MouseButton1Click:Connect(function()
			openSel = not openSel
			tween(popup, .12, {Size = UDim2.new(.6,0,0, openSel and (#listItems*22 + 4) or 0)})
		end)

		for _,name in ipairs(listItems) do
			local b = Instance.new("TextButton", popup)
			style(b, {Size=UDim2.new(1,0,0,22), Text="  "..name, TextXAlignment=Enum.TextXAlignment.Left,
				BackgroundColor3=C.pane2, TextColor3=C.text, TextSize=14, Font=Enum.Font.Gotham})
			b.MouseButton1Click:Connect(function()
				btn.Text = " "..name
				openSel = false
				tween(popup, .12, {Size = UDim2.new(.6,0,0,0)})
				if onPick then onPick(name) end
			end)
		end

		return { get=function() return btn.Text:sub(2) end, set=function(v) btn.Text=" "..tostring(v) end }
	end

	-- small button row (untuk “Start/Stop” dsb)
	local function addButtonRow(buttons) -- { {text=..., callback=function() end}, ... }
		local row = Instance.new("Frame", container)
		style(row, {Size=UDim2.new(1,0,0,28), BackgroundTransparency=1})
		local lay = Instance.new("UIListLayout", row)
		lay.Padding = UDim.new(0,6); lay.FillDirection = Enum.FillDirection.Horizontal
		for _,b in ipairs(buttons) do
			local btn = Instance.new("TextButton", row)
			style(btn, {Size=UDim2.new(0, math.floor((content.AbsoluteSize.X-60)/#buttons), 1, 0),
				Text=b.text, BackgroundColor3=C.pane2, TextColor3=C.text, TextSize=14, Font=Enum.Font.Gotham})
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
			btn.MouseButton1Click:Connect(function() if b.callback then b.callback() end end)
			btn.MouseEnter:Connect(function() tween(btn,.12,{BackgroundColor3=C.pane}) end)
			btn.MouseLeave:Connect(function() tween(btn,.12,{BackgroundColor3=C.pane2}) end)
		end
	end

	return {
		open = function() if not open then toggle() end end,
		addToggle = addToggle,
		addSelector = addSelector,
		addButtonRow = addButtonRow,
		getContainer = function() return container end,
	}
end

--======================================================
-- Pages
--======================================================
local function pageMain()
	header("Main"); clearContent()

	-- Fishing
	local fishing = makeContentDropdown("Fishing")
	fishing.addToggle("Auto Fishing", false, function(on)
		print("Auto Fishing:", on)
		if on then FishIt.Start() else FishIt.Stop() end
	end)
	fishing.addToggle("Cancel Fishing", false, function(on)
		print("Cancel Fishing:", on)
		if on then FishIt.CancelNow() end
	end)
	fishing.open()

	-- Spacer
	local sp = Instance.new("Frame", cArea) style(sp,{Size=UDim2.new(1,0,0,8), BackgroundTransparency=1})

	-- Event
	local selectedEvent = "Choose…"
	local eventGrp = makeContentDropdown("Event")
	local sel = eventGrp.addSelector("Select Event", {"Boss A","Boss B","Festival"}, selectedEvent, function(name)
		selectedEvent = name
		FishIt.SetSelectedEvent(name)
		print("Select Event:", name)
	end)
	eventGrp.addToggle("Auto Teleport", false, function(on)
		local evName = sel.get()
		if evName == "Choose…" then evName = nil end
		print("Auto Teleport:", on, "->", evName)
		FishIt.SetAutoTeleport(on, evName)
	end)
	eventGrp.open()
end

local function pageBackpack()
	header("Backpack"); clearContent()
	local items = makeContentDropdown("Items")
	items.addToggle("Auto Use Potion", false, function(on) print("Auto Use Potion:", on) end)
	items.addToggle("Auto Equip Rod", false, function(on)
		print("Auto Equip Rod:", on)
		if on then
			pcall(function()
				local ch = player.Character or player.CharacterAdded:Wait()
				for _,t in ipairs(player.Backpack:GetChildren()) do
					if t:IsA("Tool") and t.Name:lower():find("rod") then t.Parent = ch break end
				end
			end)
		end
	end)
	items.open()
end

local function pageTeleport()
	header("Teleport"); clearContent()
	local locs = makeContentDropdown("Locations")
	locs.addToggle("Auto Tele to Spawn", false, function(on)
		print("Auto Tele Spawn:", on)
		if on then
			local rootPart = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
			local spawn = WS:FindFirstChild("SpawnLocation")
			if rootPart and spawn then rootPart.CFrame = spawn.CFrame + Vector3.new(0,3,0) end
		end
	end)
	locs.addToggle("Auto Tele to Lake", false, function(on)
		print("Auto Tele Lake:", on)
		if on then
			local target
			for _,d in ipairs(WS:GetDescendants()) do
				if d:IsA("BasePart") and d.Name:lower():find("lake") then target = d break end
			end
			if target then
				local rootPart = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
				rootPart.CFrame = target.CFrame + Vector3.new(0,3,0)
			end
		end
	end)
	locs.open()
end

-- NEW: Utilities page (merge dari Elegant Black GUI)
local function pageUtilities()
	header("Utilities"); clearContent()

	-- Auto Farm
	local autoFarm = makeContentDropdown("Auto Farm")
	autoFarm.addButtonRow({
		{text="Start Auto Farm", callback=function() print("Auto Farm Started") end},
		{text="Stop Auto Farm",  callback=function() print("Auto Farm Stopped") end},
	})
	autoFarm.open()

	-- Player
	local playerGrp = makeContentDropdown("Player")
	playerGrp.addButtonRow({
		{text="Speed Boost", callback=function()
			local hum = (player.Character or player.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = 50 end
		end},
		{text="Jump Boost", callback=function()
			local hum = (player.Character or player.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
			if hum then hum.JumpPower = 100 end
		end},
		{text="Reset Boosts", callback=function()
			local hum = (player.Character or player.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = 16; hum.JumpPower = 50 end
		end},
	})
	playerGrp.open()

	-- Visual
	local visual = makeContentDropdown("Visual")
	visual.addButtonRow({
		{text="Night Mode", callback=function() pcall(function() game.Lighting.ClockTime = 0 end) end},
		{text="Day Mode",   callback=function() pcall(function() game.Lighting.ClockTime = 14 end) end},
	})
	visual.open()

	-- About
	local about = makeContentDropdown("About")
	do
		local container = about.getContainer()
		local info = Instance.new("TextLabel", container)
		style(info, {
			BackgroundTransparency = 1,
			Text = "🖤 Noctics Hub v1.0\nCreated by Aerusanc",
			Font = Enum.Font.GothamSemibold,
			TextSize = 16,
			TextColor3 = C.text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(1,-8,0,44),
		})
	end
	about.open()
end

--======================================================
-- Sidebar buttons & wiring
--======================================================
local btnMain      = makeSideButton("Main")
local btnBackpack  = makeSideButton("Backpack")
local btnTeleport  = makeSideButton("Teleport")
local btnUtilities = makeSideButton("Utilities")

btnMain.MouseButton1Click:Connect(function() setActive(btnMain); pageMain() end)
btnBackpack.MouseButton1Click:Connect(function() setActive(btnBackpack); pageBackpack() end)
btnTeleport.MouseButton1Click:Connect(function() setActive(btnTeleport); pageTeleport() end)
btnUtilities.MouseButton1Click:Connect(function() setActive(btnUtilities); pageUtilities() end)

-- default page
setActive(btnMain); pageMain()

--======================================================
-- Open/Close logic
--======================================================
local isOpen = true
local function setOpen(v)
	if isOpen == v then return end
	isOpen = v
	if isOpen then
		dock.Visible = false
		main.Visible = true
		tween(main, .14, {BackgroundTransparency = 0})
	else
		tween(main, .14, {BackgroundTransparency = 1})
		task.delay(.16, function()
			if not isOpen then
				main.Visible = false
				dock.Visible = true
			end
		end)
	end
end

-- keybind + buttons
UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == HOTKEY then setOpen(not isOpen) end
end)
btnMin.MouseButton1Click:Connect(function() setOpen(false) end)
dock.MouseButton1Click:Connect(function() setOpen(true) end)
btnClose.MouseButton1Click:Connect(function() root:Destroy() end)

-- pastikan terlihat saat start
main.Visible = true
