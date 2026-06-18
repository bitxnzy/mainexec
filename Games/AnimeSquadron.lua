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
    MainSection10 = tabs.Main:Section({ Side = "Right" }),
    MainSection100 = tabs.Settings:Section({ Side = "Left" }),
}

--Global Locals
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
getgenv().autoDailyRewardsEnabled = false
getgenv().autoBattlepassEnabled = false
getgenv().autoClaimQuestsEnabled = false
getgenv().autoUpgradePerksEnabled = false
local selectedPerkToUpgrade = "Max Yen"
local PerkOptions = {
    "Max Yen",
    "Yen Generation",
    "Health"
}

-- Worlds
local WorldOptions = {}

for _, world in ipairs(game:GetService("ReplicatedStorage").Worlds:GetChildren()) do
    table.insert(WorldOptions, world.Name)
end

table.sort(WorldOptions)

-- Modes
local ModeOptions = {
    "Story",
    "Squadron",
    "Challenge",
    "Raid"
}

-- Difficulties
local DifficultyOptions = {
    "Normal",
    "Hard"
}

-- Acts
local ActOptions = {
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "Infinite"
}

local selectedWorld = WorldOptions[1]
local selectedMode = "Story"
local selectedDifficulty = "Normal"
local selectedAct = "1"
local onlyFriends = false

--Functions

function autoGetDailyRewards()
    for i = 1, 7 do
        local args = {
            [1] = i
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Daily_Rewards"):WaitForChild("claim")
            :InvokeServer(unpack(args))
    end
end

function autoGetBattlepass()
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Battlepass"):WaitForChild("claim_all")
        :InvokeServer()
end

function autoClaimQuests()
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Quests"):WaitForChild("claim_all")
        :InvokeServer()
end

function autoUpgradePerksFunction()
    task.spawn(function()
        while getgenv().autoUpgradePerksEnabled do
            if selectedPerkToUpgrade == "Max Yen" then
                local args = {
                    [1] = "Yen_Max"
                }

                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Perks"):WaitForChild(
                    "upgrade"):InvokeServer(unpack(args))
            elseif selectedPerkToUpgrade == "Yen Generation" then
                local args = {
                    [1] = "Yen_Generation"
                }

                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Perks"):WaitForChild(
                    "upgrade"):InvokeServer(unpack(args))
            elseif selectedPerkToUpgrade == "Health" then
                local args = {
                    [1] = "Health"
                }

                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Perks"):WaitForChild(
                    "upgrade"):InvokeServer(unpack(args))
            else
                warn("[TEMPEST HUB] Invalid Perk Selected")
            end
            task.wait()
        end
    end)
end

function autoJoin()
    local args = {
        [1] = {
            ["boosted"] = true,
            ["act"] = selectedAct,
            ["difficulty"] = selectedDifficulty,
            ["mode"] = selectedMode,
            ["only_friends"] = onlyFriends,
            ["world"] = selectedWorld
        }
    }

    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Play"):WaitForChild("create_room")
        :InvokeServer(unpack(args))
    task.wait()
end

--UI

sections.MainSection1:Header({
    Name = "Player",
})

sections.MainSection1:Toggle({
    Name = "Auto Get Daily Rewards",
    Default = false,
    Callback = function(value)
        autoGetDailyRewards()
    end,
}, "autoGetDailyRewardsToggle")

sections.MainSection1:Toggle({
    Name = "Auto Battlepass",
    Default = false,
    Callback = function(value)
        getgenv().autoBattlepassEnabled = value

        task.spawn(function()
            while getgenv().autoBattlepassEnabled do
                autoGetBattlepass()
                task.wait(5)
            end
        end)
    end,
}, "AutoBattlepass")

sections.MainSection1:Toggle({
    Name = "Auto Claim Quests",
    Default = false,
    Callback = function(value)
        getgenv().autoClaimQuestsEnabled = value

        task.spawn(function()
            while getgenv().autoClaimQuestsEnabled do
                autoClaimQuests()
                task.wait(5)
            end
        end)
    end,
}, "AutoClaimQuests")

sections.MainSection1:Dropdown({
    Name = "Select Perk",
    Search = false,
    Multi = false,
    Required = true,
    Options = PerkOptions,
    Default = 1,
    Callback = function(value)
        selectedPerkToUpgrade = value
    end,
}, "SelectedPerk")

sections.MainSection1:Toggle({
    Name = "Auto Upgrade Perks",
    Default = false,
    Callback = function(value)
        getgenv().autoUpgradePerksEnabled = value

        if value then
            autoUpgradePerksFunction()
        end
    end,
}, "AutoUpgradePerks")

sections.MainSection10:Header({
	Name = "Auto Join"
})

sections.MainSection10:Dropdown({
	Name = "Select World",
	Search = true,
	Multi = false,
	Required = true,
	Options = WorldOptions,
	Default = 1,
	Callback = function(value)
		selectedWorld = value
	end,
}, "SelectedWorld")

sections.MainSection10:Dropdown({
	Name = "Select Mode",
	Search = false,
	Multi = false,
	Required = true,
	Options = ModeOptions,
	Default = 1,
	Callback = function(value)
		selectedMode = value
	end,
}, "SelectedMode")

sections.MainSection10:Dropdown({
	Name = "Select Difficulty",
	Search = false,
	Multi = false,
	Required = true,
	Options = DifficultyOptions,
	Default = 1,
	Callback = function(value)
		selectedDifficulty = value
	end,
}, "SelectedDifficulty")

sections.MainSection10:Dropdown({
	Name = "Select Act",
	Search = false,
	Multi = false,
	Required = true,
	Options = ActOptions,
	Default = 1,
	Callback = function(value)
		if value == "infinite" then
			selectedAct = "infinite"
		else
			selectedAct = tonumber(value)
		end
	end,
}, "SelectedAct")

sections.MainSection10:Toggle({
	Name = "Only Friends",
	Default = false,
	Callback = function(value)
		onlyFriends = value
	end,
}, "OnlyFriends")

sections.MainSection10:Toggle({
	Name = "Auto Join",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinEnabled = value

		task.spawn(function()
			while getgenv().autoJoinEnabled do
				autoJoin()
				task.wait()

    		end
		end)
	end,
}, "AutoJoin")




--UI IMPORTANT THINGS
MacLib:SetFolder("Maclib")

sections.MainSection100:Toggle({
    Name = "Hide Player Info",
    Default = false,
    Callback = function(value)
        MacLib:HidePlayer(value)
    end,
}, "HideUiWhenExecuteToggle")

sections.MainSection100:Toggle({
    Name = "Hide UI when Execute",
    Default = false,
    Callback = function(value)
        MacLib:HideUI(value)
    end,
}, "HideUiWhenExecuteToggle")

sections.MainSection100:Toggle({
    Name = "Low cpu usage",
    Default = false,
    Callback = function(value)
        MacLib:lowCpuUsage(value)
    end,
}, "LowCpuUsage")

sections.MainSection100:Toggle({
    Name = "FPS Boost",
    Default = false,
    Callback = function(value)
        MacLib:FPSBoost(value)
    end,
}, "FPSBoostToggle")

sections.MainSection100:Slider({
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
