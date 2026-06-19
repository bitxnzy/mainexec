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
warn("[TEMPEST HUB] Loading Toggles")
warn("[TEMPEST HUB] Last Checking")

local tabGroups = {
    TabGroup1 = Window:TabGroup(),
}

-- UI Tabs
local tabs = {
    Main = tabGroups.TabGroup1:Tab({ Name = "Main", Image = "rbxassetid://10723407389" }),
    AutoJoin = tabGroups.TabGroup1:Tab({ Name = "Auto Join", Image = "rbxassetid://10723407389" }),
    AutoPlay = tabGroups.TabGroup1:Tab({ Name = "Auto Play", Image = "rbxassetid://10723407389" }),
    Webhook = tabGroups.TabGroup1:Tab({ Name = "Webhook", Image = "rbxassetid://10723407389" }),
    Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" }),
}

--UI Sections

local sections = {
    MainSection1 = tabs.Main:Section({ Side = "Left" }),
    MainSection2 = tabs.Main:Section({ Side = "Right" }),
    MainSection10 = tabs.AutoJoin:Section({ Side = "Left" }),
    MainSection500 = tabs.AutoPlay:Section({ Side = "Left" }),
    MainSection50 = tabs.Webhook:Section({ Side = "Left" }),
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
getgenv().urlwebhook = getgenv().urlwebhook or ""
getgenv().discordUserID = getgenv().discordUserID or ""
getgenv().webhook = getgenv().webhook or false
getgenv().pingUser = getgenv().pingUser or false
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

function autoEquipBest()
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Characters"):WaitForChild("equip_best")
        :InvokeServer()
    task.wait()
end

function autoJoin()
    print("Sending Create room remote")
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
    print("Sent")
    task.wait(1)
    print("Sending remote start")
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Play"):WaitForChild("start"):InvokeServer()
    print("Teleporting")
end

function autoGameSpeed(speed)
    local args = {
        [1] = tonumber(speed)
    }

    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("change_speed")
        :InvokeServer(unpack(args))
end

function autoReplay()
    local menuScreen = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Menus")
    if menuScreen then
        local endScreen = menuScreen:FindFirstChild("EndScreen")
        if endScreen and endScreen.Visible == true then
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("replay")
                :FireServer()
        end
    end
end

function autoNext()
    local menuScreen = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Menus")
    if menuScreen then
        local endScreen = menuScreen:FindFirstChild("EndScreen")
        if endScreen and endScreen.Visible == true then
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("next")
                :FireServer()
        end
    end
end

function autoLeave()
    local menuScreen = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Menus")
    if menuScreen then
        local endScreen = menuScreen:FindFirstChild("EndScreen")
        if endScreen and endScreen.Visible == true then
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("leave")
                :FireServer()
        end
    end
end

function autoUpgrade()
    local EquippedUnits = {}

    local Profile = game:GetService("ReplicatedStorage")
        .Remotes
        .Players
        .get
        :InvokeServer()

    for _, Unit in pairs(Profile.characters or {}) do
        if Unit.equipped then
            table.insert(EquippedUnits, Unit.name)
        end
    end

    print("[UNITS LOADED]", #EquippedUnits)

    local UpgradeRemote = game:GetService("ReplicatedStorage")
        :WaitForChild("Remotes")
        :WaitForChild("Characters")
        :WaitForChild("upgrade")

    for _, UnitName in ipairs(EquippedUnits) do
        print("[UPGRADE]", UnitName)

        UpgradeRemote:InvokeServer(UnitName)
    end
end

--webhook shits
local function BuildWebhookData()
    local Player = Players.LocalPlayer

    local RewardsText = "No rewards"
    local RewardsFrame = Player.PlayerGui.Menus.EndScreen.Rewards.ScrollingFrame
    local Rewards = {}
    for _, Reward in ipairs(RewardsFrame:GetChildren()) do
        if Reward.Name ~= "UIListLayout" then
            local ItemName = "Unknown"
            local Quantity = "1"
            local ItemNameLabel = Reward:FindFirstChild("ItemName")
            if ItemNameLabel and ItemNameLabel:IsA("TextLabel") then ItemName = ItemNameLabel.Text end
            local QuantityLabel = Reward:FindFirstChild("Quantity")
            if QuantityLabel and QuantityLabel:IsA("TextLabel") then Quantity = QuantityLabel.Text end
            local IsShiny = false
            local ShinyValue = Reward:FindFirstChild("Shiny", true)
            if ShinyValue and ShinyValue:IsA("BoolValue") then IsShiny = ShinyValue.Value end
            table.insert(Rewards, string.format("%s (%s) -> %s", ItemName, Quantity, IsShiny and "Shiny" or "No Shiny"))
        end
    end

    if #Rewards > 0 then
        RewardsText = table.concat(Rewards, "\n")
    end

    local Played = workspace.Game.Stats.Played.Value
    local Won = workspace.Game.Stats.Won.Value

    local Stats = Player.PlayerGui.Menus.EndScreen.Stats

    local Worlds = workspace.World:GetChildren()
    local MapName = Worlds[1] and Worlds[1].Name or "Unknown"

    local Mode = tostring(Stats.Mode.Text)
    local Difficulty = tostring(Stats.Difficulty.Text)
    local Chapter = tostring(Stats.Chapter.Text:gsub("<.->", ""))

    local Profile = game:GetService("ReplicatedStorage")
        .Remotes
        .Players
        .get
        :InvokeServer()

    print("[WEBHOOK] Building webhook data...")
    print("[WEBHOOK] User:", Player.Name)
    print("[WEBHOOK] DisplayName:", Player.DisplayName)

    local Units = {}

    for _, Unit in pairs(Profile.characters or {}) do
        if Unit.equipped then
            table.insert(
                Units,
                string.format(
                    "[ %s ] = %s [ %s%% ]",
                    tostring(Unit.level),
                    tostring(Unit.name),
                    tostring(Unit.potential)
                )
            )
        end
    end

    local UnitsText =
        #Units > 0
        and table.concat(Units, "\n")
        or "No equipped units"

    local Content = ""

    if getgenv().pingUser and tostring(getgenv().discordUserID) ~= "" then
        Content = "<@" .. tostring(getgenv().discordUserID) .. ">"
    end

    return {
        content = Content,
        embeds = {
            {
                title = "Anime Squadron",

                description =
                    "**User:** ||" ..
                    tostring(Player.DisplayName) ..
                    " (" ..
                    tostring(Player.Name) ..
                    ")||\n" ..
                    "**Level:** " ..
                    tostring(Profile.stats.level),

                color = 65280,

                fields = {
                    {
                        name = "Player Stats",
                        value =
                            "⭐ Level: " .. tostring(Profile.stats.level) ..
                            "\n📘 XP: " .. tostring(Profile.stats.XP) ..
                            "\n💎 Gems: " .. tostring(Profile.stats.Gems) ..
                            "\n🪙 Gold: " .. tostring(Profile.stats.Gold) ..
                            "\n🎲 Reroll Cubes: " .. tostring(Profile.stats["Reroll Cubes"]) ..
                            "\n✨ Trait Shards: " .. tostring(Profile.stats["Trait Shards"]) ..
                            "\n🔷 Perfect Cubes: " .. tostring(Profile.stats["Perfect Cubes"]),

                        inline = false
                    },

                    {
                        name = "Rewards",
                        value = RewardsText,
                        inline = false
                    },

                    {
                        name = "Units",
                        value = UnitsText,
                        inline = false
                    },

                    {
                        name = "Match Result",
                        value =
                            "🗺️ Map: " .. tostring(MapName) ..
                            "\n🎯 Mode: " .. tostring(Mode) ..
                            "\n⚔️ Difficulty: " .. tostring(Difficulty) ..
                            "\n📖 Chapter: " .. tostring(Chapter) ..
                            "\n🎮 Played: " .. tostring(Played) ..
                            "\n🏆 Won: " .. tostring(Won),

                        inline = false
                    }
                },

                footer = {
                    text = "Tempest Hub • " .. os.date("%d/%m/%Y %H:%M")
                }
            }
        }
    }
end

local function SendWebhookMessage()
    if not getgenv().webhook then return end
    if tostring(getgenv().urlwebhook) == "" then
        warn("Webhook URL missing")
        return
    end
    request({
        Url = getgenv().urlwebhook,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body =
            HttpService:JSONEncode(BuildWebhookData())
    })
end

--UI

sections.MainSection1:Header({
    Name = "Player",
})

sections.MainSection1:Toggle({
    Name = "Auto Equip Best",
    Default = false,
    Callback = function(value)
        autoEquipBest()
    end,
}, "autoEquipBestToggle")

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

sections.MainSection1:Dropdown({
    Name = "Select Gamespeed",
    Search = false,
    Multi = false,
    Required = true,
    Options = { "2", "3" },
    Default = 1,
    Callback = function(value)
        autoGameSpeed(value)
    end,
}, "autoGameSpeed")

sections.MainSection2:Toggle({
    Name = "Auto Replay",
    Default = false,
    Callback = function(value)
        getgenv().autoreplayEnabled = value

        task.spawn(function()
            while getgenv().autoreplayEnabled do
                autoReplay()
                task.wait()
            end
        end)
    end,
}, "autoReplay")

sections.MainSection2:Toggle({
    Name = "Auto Next",
    Default = false,
    Callback = function(value)
        getgenv().autoNextEnabled = value

        task.spawn(function()
            while getgenv().autoNextEnabled do
                autoNext()
                task.wait()
            end
        end)
    end,
}, "autoNext")

sections.MainSection2:Toggle({
    Name = "Auto Leave",
    Default = false,
    Callback = function(value)
        getgenv().autoLeaveEnabled = value

        task.spawn(function()
            while getgenv().autoLeaveEnabled do
                autoLeave()
                task.wait()
            end
        end)
    end,
}, "autoLeave")

sections.MainSection2:Toggle({
    Name = "Auto Upgrade",
    Default = false,
    Callback = function(value)
        getgenv().autoUpgradeEnabled = value

        task.spawn(function()
            while getgenv().autoUpgradeEnabled do
                autoUpgrade()
                task.wait()
            end
        end)
    end,
}, "autoUpgrade")

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

sections.MainSection50:Input(
    {
        Name = "Webhook URL",
        Placeholder = "Press enter after paste",
        AcceptedCharacters = "All",
        Callback = function(value)
            getgenv().urlwebhook =
                value
        end,
        onChanged = function(value) getgenv().urlwebhook = value end,
    }, "WebhookURL")
sections.MainSection50:Input(
    {
        Name = "Discord User ID",
        Placeholder = "123456789012345678",
        AcceptedCharacters = "Number",
        Callback = function(value)
            getgenv().discordUserID =
                value
        end,
        onChanged = function(value) getgenv().discordUserID = value end,
    }, "DiscordUserID")
sections.MainSection50:Toggle({
    Name = "Send Webhook when finish game",
    Default = false,

    Callback = function(value)
        getgenv().webhook = value

        if value then
            task.spawn(function()
                local Sent = false

                while getgenv().webhook do
                    task.wait(0.5)

                    local Player = game:GetService("Players").LocalPlayer
                    local Menus = Player.PlayerGui:FindFirstChild("Menus")

                    if not Menus then
                        continue
                    end

                    local EndScreen = Menus:FindFirstChild("EndScreen")

                    if not EndScreen then
                        continue
                    end

                    if EndScreen.Visible and not Sent then
                        Sent = true

                        -- espera a UI terminar de atualizar
                        task.wait(2)

                        print("[WEBHOOK] EndScreen detectada, enviando webhook...")

                        local Success, Error = pcall(function()
                            SendWebhookMessage()
                        end)

                        if not Success then
                            warn("[WEBHOOK ERROR]", Error)
                        end
                    elseif not EndScreen.Visible then
                        Sent = false
                    end
                end
            end)
        end
    end,
}, "WebhookFinishGame")
sections.MainSection50:Toggle(
    { Name = "Ping user", Default = false, Callback = function(value) getgenv().pingUser = value end, }, "PingUser")
sections.MainSection50:Button({
    Name = "Test Webhook",
    Callback = function()
        if getgenv().urlwebhook == "" then
            warn("Webhook URL missing")
            return
        end

        local HttpService = game:GetService("HttpService")

        local content = ""

        if getgenv().pingUser and getgenv().discordUserID ~= "" then
            content = "<@" .. tostring(getgenv().discordUserID) .. ">"
        end

        request({
            Url = getgenv().urlwebhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                content = content,

                embeds = {
                    {
                        title = "Webhook Test",

                        description =
                            "User: ||" .. tostring(game.Players.LocalPlayer.Name) .. "||\n" ..
                            "UserId: ||" .. tostring(game.Players.LocalPlayer.UserId) .. "||",

                        color = 65280
                    }
                }
            })
        })
    end,
})

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
