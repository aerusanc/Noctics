-- examples/demo.lua

local url = "https://raw.githubusercontent.com/aerusanc/Noctics/main/src/main.lua"
local scriptSource = game:HttpGet(url)
local module = loadstring(scriptSource)()

-- Jalankan fungsi utama dari modul
module.run()
