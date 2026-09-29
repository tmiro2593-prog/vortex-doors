local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local STATIC_KEY = "DOORSVORTEX"

local CurrentVersion = "1.0-Beta"
local VersionURL = "https://raw.githubusercontent.com/tmiro259/vortex-doors/main/version.txt" 

local success, LatestVersion = pcall(function()
    return game:HttpGet(VersionURL)
end)

if success and LatestVersion then
    LatestVersion = LatestVersion:gsub("%s+", "")
    if LatestVersion ~= CurrentVersion then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Vortex Hub [EXPIRED]",
            Text = "Outdated version! Please update the script.",
            Duration = 15
        })
        return
    end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Vortex Hub | DOORS PRO [v1.0-Beta]",
   LoadingTitle = "Vortex Hub",
   LoadingSubtitle = "Loading Public Version (Beta)...",
   ConfigurationSaving = { Enabled = true, FolderName = "VortexHubDoors", FileName = "ConfigPublic" },
   
   KeySystem = true, 
   KeySettings = {
      Title = "Vortex Hub | Key System",
      Subtitle = "Enter your key to continue",
      Note = "The key has been copied to your clipboard",
      FileName = "VortexDoorsKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Link = "https://link-target.net/9779805/lshZsIDdRH45",
      Key = {STATIC_KEY}
   }
})

_G.WalkSpeed = 16
_G.WalkSpeedEnabled = false
_G.FOVValue = 70
_G.FullBright = false
_G.DoorESP = false
_G.KeyESP = false
_G.GoldESP = false
_G.EntityESP = false
_G.AutoInteractDoors = false
_G.AutoInteractDrawers = false

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local MainTab = Window:CreateTab("Main & Movement", "home")
local ESPTab = Window:CreateTab("ESP & Visuals", "eye")
local AutoTab = Window:CreateTab("Auto Interact", "cpu")
local LockedTab = Window:CreateTab("Owner Features [🔒]", "lock")
local SettingsTab = Window:CreateTab("Settings", "settings")

MainTab:CreateToggle({ Name = "⚡ Anti-Cheat Bypass (WalkSpeed)", CurrentValue = true, Callback = function(Value) end })
MainTab:CreateToggle({ Name = "Enable Custom WalkSpeed", CurrentValue = false, Callback = function(Value) _G.WalkSpeedEnabled = Value end })
MainTab:CreateSlider({ Name = "WalkSpeed Value", Range = {16, 35}, Increment = 1, Suffix = "Speed", CurrentValue = 16, Callback = function(Value) _G.WalkSpeed = Value end })
MainTab:CreateSlider({ Name = "Field of View (FOV)", Range = {70, 120}, Increment = 1, Suffix = "FOV", CurrentValue = 70, Callback = function(Value) Workspace.CurrentCamera.FieldOfView = Value end })
MainTab:CreateToggle({ Name = "FullBright", CurrentValue = false, Callback = function(Value) Lighting.Brightness = Value and 2 or 1; Lighting.GlobalShadows = not Value end })

RunService.Stepped:Connect(function(time, dt)
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = localPlayer.Character.Humanoid
        local root = localPlayer.Character.HumanoidRootPart
        if _G.WalkSpeedEnabled then
            humanoid.WalkSpeed = 16
            if humanoid.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (humanoid.MoveDirection * (_G.WalkSpeed - 16) * dt * 3.8)
            end
        end
    end
end)

local function addESP(obj, color, name, customText)
    if not obj:FindFirstChild("VortexESP_" .. name) then
        local hl = Instance.new("Highlight", obj)
        hl.Name = "VortexESP_" .. name
        hl.FillColor = color
        hl.FillTransparency = 0.5
        if customText then
            local bill = Instance.new("BillboardGui", obj)
            bill.Name = "VortexText_" .. name
            bill.Size = UDim2.new(0, 80, 0, 20)
            bill.StudsOffset = Vector3.new(0, 2, 0)
            bill.AlwaysOnTop = true
            local txt = Instance.new("TextLabel", bill)
            txt.Size = UDim2.new(1,0,1,0)
            txt.BackgroundTransparency = 1
            txt.Text = customText
            txt.TextColor3 = color
            txt.TextSize = 12
            txt.Font = Enum.Font.SourceSansBold
        end
    end
end
local function removeESP(obj, name)
    if obj:FindFirstChild("VortexESP_" .. name) then obj["VortexESP_" .. name]:Destroy() end
    if obj:FindFirstChild("VortexText_" .. name) then obj["VortexText_" .. name]:Destroy() end
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if Workspace:FindFirstChild("CurrentRooms") then
                for _, room in pairs(Workspace.CurrentRooms:GetChildren()) do
                    local door = room:FindFirstChild("Door")
                    if door then
                        local actualDoor = door:FindFirstChild("Door") or door
                        if _G.DoorESP then addESP(actualDoor, Color3.fromRGB(0,255,0), "Door", "Door " .. room.Name) else removeESP(actualDoor, "Door") end
                    end
                end
            end
        end)
    end
end)

ESPTab:CreateToggle({ Name = "Door ESP", CurrentValue = false, Callback = function(Value) _G.DoorESP = Value end })
ESPTab:CreateToggle({ Name = "Key ESP (Locked)", CurrentValue = false, Callback = function(Value) Rayfield:Notify({Title = "Locked", Content = "Available in Owner Edition!", Duration = 2}) end })
ESPTab:CreateToggle({ Name = "Gold ESP (Locked)", CurrentValue = false, Callback = function(Value) Rayfield:Notify({Title = "Locked", Content = "Available in Owner Edition!", Duration = 2}) end })

AutoTab:CreateToggle({ Name = "Auto Interact Doors", CurrentValue = false, Callback = function(Value) _G.AutoInteractDoors = Value end })
AutoTab:CreateToggle({ Name = "Auto Interact Drawers (Locked)", CurrentValue = false, Callback = function(Value) Rayfield:Notify({Title = "Locked", Content = "Available in Owner Edition!", Duration = 2}) end })

LockedTab:CreateParagraph({Title = "🔒 Owner Features", Content = "These features are unlocked exclusively in the Owner Edition."})
LockedTab:CreateToggle({ Name = "🔒 Entity ESP (Rush/Ambush)", CurrentValue = false, Callback = function(Value) if Value then Rayfield:Notify({Title = "Locked", Content = "Owner Edition Only!", Duration = 2}) end end })
LockedTab:CreateToggle({ Name = "🔒 Item ESP (Vitamins/Lockpicks)", CurrentValue = false, Callback = function(Value) if Value then Rayfield:Notify({Title = "Locked", Content = "Owner Edition Only!", Duration = 2}) end end })

SettingsTab:CreateParagraph({Title = "Hub Info", Content = "Vortex Hub DOORS - Public Edition [v1.0-Beta]"})
Rayfield:LoadConfiguration()
Rayfield:Notify({Title = "Vortex Hub", Content = "Loaded successfully!", Duration = 3})
