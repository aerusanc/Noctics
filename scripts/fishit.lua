-- 🐟 Fish It Menu
print("🧠 Loading Fish It Menu...")

-- Pastikan function AddMenu sudah ada di main.lua
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Buat menu Fish It
local fishItMenu = {
	{name = "Start Auto Farm", callback = function()
		print("Auto Farm Started")
		-- Tambahkan logika auto farm Fish It di sini
	end},
	{name = "Stop Auto Farm", callback = function()
		print("Auto Farm Stopped")
		-- Tambahkan logic stop auto farm
	end},
}

-- Tambahkan menu ke GUI utama
if AddMenu then
	AddMenu("Auto Farm", fishItMenu)
else
	warn("AddMenu function not found! Pastikan main.lua sudah dijalankan")
end
