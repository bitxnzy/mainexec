repeat
	task.wait()
until game:IsLoaded()
task.wait(1)
warn("[TEMPEST HUB] Loading Ui")
task.wait()

--Starting Script
local MacLib =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/maclibTempestHubUI/main/maclib.lua"))()

local isMobile = game:GetService("UserInputService").TouchEnabled
local pcSize = UDim2.fromOffset(850, 650)
local mobileSize = UDim2.fromOffset(650, 400)
local currentSize = isMobile and mobileSize or pcSize

local Window = MacLib:Window({
	Title = "Tempest Hub",
	Subtitle = "Anime Squadron",
	Size = currentSize,
	DragStyle = 1,
	DisabledWindowControls = {},
	ShowUserInfo = false,
	Keybind = Enum.KeyCode.RightControl,
	AcrylicBlur = true,
})

function findGuiRecursive(parent, targetName)
	for _, child in ipairs(parent:GetChildren()) do
		if child.Name == targetName then
			return child
		end
		local found = findGuiRecursive(child, targetName)
		if found then
			return found
		end
	end
	return nil
end

local globalSettings = {
	UIBlurToggle = Window:GlobalSetting({
		Name = "UI Blur",
		Default = Window:GetAcrylicBlurState(),
		Callback = function(bool)
			Window:SetAcrylicBlurState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Enabled" or "Disabled") .. " UI Blur",
				Lifetime = 5,
			})
		end,
	}),
	NotificationToggler = Window:GlobalSetting({
		Name = "Notifications",
		Default = Window:GetNotificationsState(),
		Callback = function(bool)
			Window:SetNotificationsState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Enabled" or "Disabled") .. " Notifications",
				Lifetime = 5,
			})
		end,
	}),
	ShowUserInfo = Window:GlobalSetting({
		Name = "Show User Info",
		Default = Window:GetUserInfoState(),
		Callback = function(bool)
			Window:SetUserInfoState(false)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Showing" or "Redacted") .. " User Info",
				Lifetime = 5,
			})
		end,
	}),
}
warn("[TEMPEST HUB] Loading Function")
task.wait()
warn("[TEMPEST HUB] Loading Toggles")
task.wait()
warn("[TEMPEST HUB] Last Checking")
task.wait()

local tabGroups = {
	TabGroup1 = Window:TabGroup(),
}

-- UI Tabs
local tabs = {
	Main = tabGroups.TabGroup1:Tab({ Name = "Main", Image = "rbxassetid://10723407389" }),
	Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" }),
}

--UI Sections

local sections = {
	MainSection1 = tabs.Main:Section({ Side = "Left" }),
	MainSection25 = tabs.Settings:Section({ Side = "Left" }),
}

--Locals
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local originalSizes = {}
local pcSize2 = Vector2.new(850, 650)
local mobileSize2 = Vector2.new(650, 400)
local speed = 1000


--UI IMPORTANT THINGS
MacLib:SetFolder("Maclib")

sections.MainSection25:Toggle({
	Name = "Hide Player Info",
	Default = false,
	Callback = function(value)
		MacLib:HidePlayer(value)
	end,
}, "HideUiWhenExecuteToggle")

sections.MainSection25:Toggle({
	Name = "Hide UI when Execute",
	Default = false,
	Callback = function(value)
		MacLib:HideUI(value)
	end,
}, "HideUiWhenExecuteToggle")

sections.MainSection25:Toggle({
	Name = "Low cpu usage",
	Default = false,
	Callback = function(value)
		MacLib:lowCpuUsage(value)
	end,
}, "LowCpuUsage")

sections.MainSection25:Toggle({
	Name = "FPS Boost",
	Default = false,
	Callback = function(value)
		MacLib:FPSBoost(value)
	end,
}, "FPSBoostToggle")

sections.MainSection25:Slider({
	Name = "Change UI Size",
	Default = 0.8,
	Minimum = 0.5,
	Maximum = 1.5,
	Increment = 0.05,
	DisplayMethod = "Round",
	Precision = 1,
	Callback = function(scale)
		MacLib:changeUISize(scale)
	end,
}, "changeUISize")

Window.onUnloaded(function() end)
tabs.Main:Select()

local GameConfigName = "_ALS_"
local player = game.Players.LocalPlayer
local GuiService = game:GetService("GuiService")
MacLib:SetFolder("Tempest Hub")
MacLib:SetFolder("Tempest Hub/_AS_")
MacLib:LoadConfig(player.Name .. GameConfigName)

local function saveConfigBeforeGameLeave()
	MacLib:SaveConfig(player.Name .. GameConfigName)
end
GuiService.NativeClose:Connect(saveConfigBeforeGameLeave)
GuiService.MenuOpened:Connect(saveConfigBeforeGameLeave)
player.OnTeleport:Connect(function()
	saveConfigBeforeGameLeave()
end)
task.spawn(function()
	while true do
		saveConfigBeforeGameLeave()
		task.wait(60)
	end
end)

local LocalPlayer = game:GetService("Players").LocalPlayer
for _, v in pairs(getconnections(LocalPlayer.Idled)) do
	v:Disable()
end