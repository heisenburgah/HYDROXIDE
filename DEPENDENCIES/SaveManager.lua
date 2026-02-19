if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Wait for LocalPlayer to exist
local Players = cloneref(game:GetService("Players"))
repeat task.wait() until Players.LocalPlayer
repeat task.wait() until Players.LocalPlayer.Backpack

-- Wait for LeaderboardGui to load in StarterGui
local StarterGui = cloneref(game:GetService("StarterGui"))
repeat task.wait() until StarterGui:FindFirstChild("LeaderboardGui")

pcall(function()
    if getconnections then
        for _,v in pairs(getconnections(game:GetService('ScriptContext').Error)) do
            v:Disable();
        end
    end
end)

loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();

loadstring([[
    function LPH_ENCSTR(f) return f end;
]])();

loadstring([[
    LPH_OBFUSCATED = false;
]])();

pcall(loadstring([[if not HXD_HWID then HXD_HWID="STUB_HWID" HXD_DISCORD_ID="123456789" HXD_EXPIRES_AT=os.time()+2592000 HXD_STATUS="active" HXD_EXECUTION_COUNT=1 HXD_SECONDS_LEFT=2592000 HXD_UserNote="beta" end]]));
pcall(loadstring([[if not HXD_SANITIZE then function HXD_SANITIZE(value,pattern)if not value or not pattern then return""end;value=tostring(value)local charset=pattern:match("%[(.-)%]")if not charset then return""end;local _,max=pattern:match("{%s*(%d+)%s*,%s*(%d+)%s*}")local max_len=tonumber(max)or#value;local extra_chars="→←↑↓★☆"charset=charset:gsub("%]","%%]")value=value:gsub("[^"..charset..extra_chars.."]","")return value:sub(1,max_len)end end]]));
pcall(loadstring([[if not HXD_SEND_WEBHOOK then function HXD_SEND_WEBHOOK(url,data)if not request then warn("[STUB] Webhook:",url)return true end;local HttpService=game:GetService("HttpService")local headers={["Content-Type"]="application/json"}return request({Url=url,Method="POST",Headers=headers,Body=HttpService:JSONEncode(data)})end end]]));

local anticheat_mode = "Normal"
pcall(function()
    if isfile and readfile and isfile("HYDROXIDE/anticheat_mode.txt") then
        local saved_mode = readfile("HYDROXIDE/anticheat_mode.txt")
        if saved_mode == "Kick" or saved_mode == "Normal" then
            anticheat_mode = saved_mode
        end
    end
end)

local Required = {
	"hookfunction",
	"getconnections",
	"hookmetamethod",
	"bit32",
	"getgenv",
	"setmetatable",
    "clonefunction",
    "cloneref",
    "getconnections",
    "fireclickdetector",
    "checkcaller"
}

local Kick = clonefunction and clonefunction(game:GetService("Players").LocalPlayer.Kick) or game:GetService("Players").LocalPlayer.Kick
for i = 1, #Required do
	local v = Required[i]
	if not getgenv()[v] then
        Kick(game:GetService("Players").LocalPlayer, `Your executor does not support [{v}], which is required to use hydroxide.sol @ Rogue Lineage.`)
	end
end

local function process_string(str, salt)
    salt = salt or 27
    if not bit32 or not bit32.bxor then
        warn("bit32.bxor not available")
        return str
    end
    local chars = {}
    for i = 1, #str do
        local char = string.byte(str, i)
        local processedChar = bit32.bxor(char, salt + (i % 7))
        chars[i] = string.char(processedChar)
    end
    return table.concat(chars)
end

local function encode(str, salt) return process_string(str, salt) end
local function decode(str, salt) return process_string(str, salt) end

local function generate_key()
    local p = game.PlaceId
    local j = game.JobId
    local u = game:GetService("Players").LocalPlayer.UserId
    return encode(p.."_"..j:sub(1,5).."_"..tostring(u):sub(-4))
end

local key = generate_key()
if game.PlaceId == 3541987450 or game.PlaceId == 5208655184 or game.PlaceId == 109732117428502 or game.PlaceId == 14341521240 then
    if getgenv()[key] and type(getgenv()[key]) == "table" then return end
    getgenv()[key] = setmetatable({}, { __tostring = function() return "nil" end })

    local success, err = xpcall(function()
    local old_destroy = nil
    do -- Anti Cheat Hooks
        old_destroy = hookfunction(workspace.Destroy, function(Self) -- Character Handler Destructor
            if not checkcaller() then
                if tostring(Self) == "CharacterHandler" then
                    return
                end
            end

            return old_destroy(Self)
        end)

        if anticheat_mode == "Kick" then
            task.spawn(function()
                local cw
                local lockThreads = {}

                cw = hookfunction(coroutine.wrap, newcclosure(function(f,...)
                    if not checkcaller() then
                        if type(f) == "function" and islclosure(f) then
                            local consts, upvals = getconstants(f), getupvalues(f)
                            local g3 = getfenv(3)

                            if typeof(upvals[2]) == "Instance" and upvals[2]:IsA("AnimationTrack") and upvals[1] == upvals[2].Play then
                                --warn("DETECTION__1")
                                lockThreads[g3] = true
                            end

                            if consts[1] == "scr" and consts[2] == "Parent" then
                                --warn("DETECTION__2")
                                lockThreads[g3] = true
                            end

                            if consts[1] == "coroutine" and consts[2] == "create" and table.find(consts,"dead") then
                                --warn("DETECTION__3")
                                lockThreads[g3] = true
                            end

                            if g3 and lockThreads[g3] then
                                local plrs_local = game:GetService("Players")
                                while true do
                                    plrs_local.LocalPlayer:Kick("Ban Attempt")
                                    task.wait()
                                end
                            end
                        end

                        if lockThreads[getfenv(3)] then
                            return function() end
                        end
                    end

                    return cw(f,...)
                end))
            end)
        else
            LPH_NO_VIRTUALIZE(function()
                -- hello loadstring hook!!! Ye this is from scarlethook. u couldve just skidded from #releases but ok
                local type = type
                local getupvalues = getupvalues
                local islclosure = islclosure
                local EmptyFunc = function() end
                local RunService = game:GetService("RunService")
                local debug_info = debug.info

                local old
                old = hookfunction(coroutine.wrap, function(func)
                    if not checkcaller() then
                        if type(func) == "function" and islclosure(func) then
                            -- don't need this since stack level eq pcall check yields, but just in case
                            local upvals = getupvalues(func)
                            if #upvals == 1 then
                                if upvals[1] == RunService then
                                    --warn("HXSOL__COROUTINE")
                                    return old(EmptyFunc)
                                end
                            end
                        end

                        local stackfunc = debug_info(5, "n") -- 1 hook, 2 anon func, 3 sub func, 4 anon func, 5 pcall
                        if stackfunc and stackfunc == "pcall" then
                            --warn("HXSOL__PCALL")
                            return -- old(function() end)
                        end
                    end
                    return old(func)
                end)
            end)()
        end
    end

    local start = os.clock()
    do
        makefolder("HYDROXIDE")
        if game.PlaceId == 14341521240 then
            makefolder("HYDROXIDE\\rlp_configs")
        else
            makefolder("HYDROXIDE\\configs")
        end
    end

    local cloneref = (cloneref or clonereference or function(instance: any)
        return instance
    end)

    -- Services
    local cas  = cloneref(game:GetService("ContextActionService"))
    local vim  = cloneref(game:GetService("VirtualInputManager"))
    local mem  = cloneref(game:GetService("MemStorageService"))
    local rps  = cloneref(game:GetService("ReplicatedStorage"))
    local cs   = cloneref(game:GetService("CollectionService"))
    local uis  = cloneref(game:GetService("UserInputService"))
    local tps  = cloneref(game:GetService("TeleportService"))
    local txt  = cloneref(game:GetService("TextChatService"))
    local ts   = cloneref(game:GetService("TweenService"))
    local vs   = cloneref(game:GetService("VirtualUser"))
    local sui  = cloneref(game:GetService("StarterGui"))
    local rs   = cloneref(game:GetService("RunService"))
    local gui  = cloneref(game:GetService("GuiService"))
    local lit  = cloneref(game:GetService("Lighting"))
    local plrs = cloneref(game:GetService("Players"))
    local ws   = cloneref(game:GetService("Workspace"))
    local deb  = cloneref(game:GetService("Debris"))
    local cg   = cloneref(game:GetService("CoreGui"))

    -- Local
    local plr = plrs.LocalPlayer
    local mouse = cloneref(plr:GetMouse())

    -- Save persisted config name immediately (before anything can overwrite it)
    local persisted_config_name = nil
    if mem and mem:HasItem("loaded_config") then
        persisted_config_name = mem:GetItem("loaded_config")
        print("[CONFIG PERSISTENCE] Found persisted config:", persisted_config_name)
    else
        print("[CONFIG PERSISTENCE] No persisted config found")
    end
    
    local ui = gethui and gethui() or cg
    local flagged_chats = {'clipped','exploiter','banned','blacklisted','clip','hacker'}
    local hidden_folder = Instance.new("Folder", ui)
    local area_markers = ws:WaitForChild("AreaMarkers")
    local area_data = require(rps:WaitForChild("Info"):WaitForChild("AreaData"))

    local get_mouse_remote
    if game.PlaceId == 14341521240 then
        get_mouse_remote = nil
    else
        get_mouse_remote = rps:WaitForChild("Requests"):WaitForChild("GetMouse")
    end

    local join_server
    if game.PlaceId == 14341521240 then
        join_server = nil
    else
        join_server = rps:WaitForChild("Requests"):WaitForChild("JoinPublicServer")
    end

    local live_folder = ws:WaitForChild("Live")
    local headers = {["content-type"] = "application/json"}

    local teleport_failed = false
    local teleport_fail_reason = ""
    tps.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
        teleport_failed = true
        teleport_fail_reason = errorMessage or "Unknown error"
        warn(string.format("[TELEPORT FAILED] %s - Retrying serverhop...", teleport_fail_reason))
    end)

    local is_gaia = game.PlaceId == 5208655184;
    local is_khei = game.PlaceId == 3541987450 or game.PlaceId == 14341521240;

    local updatePlayerLabel, getPlayerColor
    local last_area_restore = nil
    local ingredient_folder = nil
    local active_observe = nil
    local auto_pot_active = false
    local auto_craft_active = false
    local was_noclip_enabled = false

    local mana_overlay = {}
    local transparent_parts = {}
    local original_names = {}
    local original_days = {}
    local original_materials = {}
    local dialogue_remote = nil
    local mana_remote = nil
    local old_remote = nil
    local old_hastag = nil
    local old_newindex = nil
    local old_find_first_child = nil
    local watched_guis = {}
    local hooked_connections = {}
    local playerLabels = {}

    local proximity_gui
    local proximity_label
    local proximity_connection

    local streamer_connections = {}
    local ragoozer_frame = nil
    local disabled_connections = {}

    local done = false
    local busy = false

    -- Global Tables
    local game_client = {}
    local library = {}
    local utility = {}
    local shared = {
        is_unloading = false,
        drawing_containers = {
            menu = {},
            notification = {},
            esp = {},
            status = {},
        },
        connections = {},
        hidden_connections = {},
        blatant_features = {"flight", "better_flight", "no_fall", "no_killbrick", "auto_bag", "NoStun", "PerfloraTeleport", "parry_ignore_visibility", "forcefield", "anti_globus", "loop_orderly", "start_path", "test_path"},
        blatant_toggles = {},
        -- pointers table removed - now using Library.Options and Library.Toggles
        theme = {
            inline = Color3.fromRGB(3, 3, 3),
            dark = Color3.fromRGB(24, 24, 24),
            text = Color3.fromRGB(155, 155, 155),
            section = Color3.fromRGB(60, 60, 60),
            accent = Color3.fromRGB(255,0,0),
        },
        accents = {},
        moveKeys = {
            ["Movement"] = {
                ["Up"] = "Up",
                ["Down"] = "Down"
            },
            ["Action"] = {
                ["Left"] = "Left",
                ["Right"] = "Right"
            }
        },
        allowedKeyCodes = {"Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M","One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Zero","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","KeypadOne","KeypadTwo","KeypadThree","KeypadFour","KeypadFive","KeypadSix","KeypadSeven","KeypadEight","KeypadNine","KeypadZero","KeypadPeriod","KeypadDivide","KeypadMultiply","KeypadMinus","KeypadPlus","KeypadEnter","Insert","Tab","Home","End","LeftAlt","LeftControl","LeftShift","RightAlt","RightControl","RightShift","CapsLock","Return","Up","Down","Left","Right"},
        allowedInputTypes = {"MouseButton1","MouseButton2","MouseButton3"},
        shortenedInputs = {
            -- Control Keys
            ["LeftControl"] = 'left control',
            ["RightControl"] = 'right control',
            ["LeftShift"] = 'left shift',
            ["RightShift"] = 'right shift',

            -- Numberbar
            ["Backquote"] = "grave",
            ["Tilde"] = "~",
            ["At"] = "@",
            ["Hash"] = "#",
            ["Dollar"] = "$",
            ["Percent"] = "%",
            ["Caret"] = "^",
            ["Ampersand"] = "&",
            ["Asterisk"] = "*",
            ["LeftParenthesis"] = "(",
            ["RightParenthesis"] = ")",

            ["Underscore"] = '_',
            ["Minus"] = '-',
            ["Plus"] = '+',
            ["Period"] = '.',
            ["Slash"] = '/',
            ["BackSlash"] = '\\',
            ["Question"] = '?',

            -- Super
            ["PageUp"] = "pgup",
            ["PageDown"] = "pgdwn",

            -- Keyboard
            ["Comma"] = ",",
            ["Period"] = ".",
            ["Semicolon"] = ",",
            ["Colon"] = ":",
            ["GreaterThan"] = ">",
            ["LessThan"] = "<",
            ["LeftBracket"] = "[",
            ["RightBracket"] = "]",
            ["LeftCurly"] = "{",
            ["RightCurly"] = "}",
            ["Pipe"] = "|",

            -- Numberpad
            ["NumLock"] = "num lock",
            ["KeypadNine"] = "num 9",
            ["KeypadEight"] = "num 8",
            ["KeypadSeven"] = "num 7",
            ["KeypadSix"] = "num 6",
            ["KeypadFive"] = "num 5",
            ["KeypadFour"] = "num 4",
            ["KeypadThree"] = "num 3",
            ["KeypadTwo"] = "num 2",
            ["KeypadOne"] = "num 1",
            ["KeypadZero"] = "num 0",

            ["KeypadMultiply"] = "num multiply",
            ["KeypadDivide"] = "num divide",
            ["KeypadPeriod"] = "num decimal",
            ["KeypadPlus"] = "num plus",
            ["KeypadMinus"] = "num sub",
            ["KeypadEnter"] = "num enter",
            ["KeypadEquals"] = "num equals",

            -- Mouse
            ["MouseButton1"] = 'mouse1',
            ["MouseButton2"] = 'mouse2',
            ["MouseButton3"] = 'mouse3',
        },
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 200, 0), Color3.fromRGB(210, 255, 0), Color3.fromRGB(110, 255, 0), Color3.fromRGB(10, 255, 0), Color3.fromRGB(0, 255, 90), Color3.fromRGB(0, 255, 190), Color3.fromRGB(0, 220, 255), Color3.fromRGB(0, 120, 255), Color3.fromRGB(0, 20, 255), Color3.fromRGB(80, 0, 255), Color3.fromRGB(180, 0, 255), Color3.fromRGB(255, 0, 230), Color3.fromRGB(255, 0, 130), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0)},
        windowActive = true,
        notifications = {},
    }
    local cheat_client = {
        config = {
            anticheat_mode = "Normal", -- Anti-cheat bypass mode
            perflora_teleport = false, -- Combat Chunk
            auto_misogi = false,
            anti_backfire_viribus = false,
            hold_block = false,
            hold_block_delay = 0,
            no_stun = false,
            anti_confusion = false,

            parry_viribus = false,
            parry_owlslash = false,
            parry_shadowrush = false,
            parry_verdien = false,

            parry_ping_adjust = true,
            parry_custom_delay = false,
            custom_delay = 0,
            parry_fov_angle = 180,
            parry_disable_when_unfocused = true,
            parry_ignore_visibility = false,
            parry_semi_blatant_block = false,

            silent_aim = false,
            fov = 80,
            aimbot_hitboxes = 1,
            hide_fov_circle = false,
    
            player_esp = true, -- Visual Chunk
            player_box = true,
            player_health = true,
            player_name = true,
            player_tags = true,
            player_intent = true,
            player_mana = true,
            player_mana_text = false,
            player_hover_details = true,
            player_observe = false,
            player_racial = true,
            player_range = 2000,

            player_chams = false,
            player_friendly_chams = false,
            player_low_health = false,
            player_aimbot_chams = false,
            player_racial_chams = false,
            player_chams_fill = false,
            player_chams_pulse = false,
            player_chams_occluded = false,
            --player_chams_color = Color3.fromRGB(0,255,255),

            player_healthview = false,
            legit_intent = false,
    
            trinket_esp = true,
            trinket_show_area = true,
            trinket_range = 1000,
            trinket_ignore_range_types = {
                ["Artifact"] = true,
                ["Mythic"] = true
            },

            shrieker_chams = false,
            fallion_esp = false,
            npc_esp = false,
    
            ore_esp = false,
            mythril_esp = false,
            copper_esp = false,
            iron_esp = false,
            tin_esp = false,
            ore_range = 12000,
            
            ingredient_esp = false,
            ingredient_range = 500,
    
            no_fog = false,
            no_blindness = false,
            no_blur = false,
            no_sanity = false,
            better_leaderboard = true,
            fullbright = false,
            brightness_level = 80,
            change_time = false,
            clock_time = 12,

            mana_overlay = false,
    
            no_insane = false, -- Exploits Chunk
            instant_mine = false,
            bard_stack = false,
            observe = true,

            invis_cam = false,
            max_zoom = false,
            anti_globus = false,
    
            flight = false, -- Movement Chunk
            noclip = false,
            auto_fall = false,
            flight_speed = 100,
            better_flight = false,
            better_flight_keybind = nil,
    
            
            auto_dialogue = false, -- Automation Chunk
            auto_bard = false,
            hide_bard = false,
            anti_afk = false,
            auto_trinket = false,
            auto_ingredient = false,
            auto_weapon = false,
            auto_resurrection = false,
            auto_chair = false,
            auto_charge = false,
            auto_charge_threshold = 100,
            auto_bag = false,
            bag_range = 100,
            
            
            -- World Chunk
            temperature_lock = false,
            textures = false,
            no_fall = false,
            no_killbrick = false,
            no_mob_trigger = false,
            freecam = false,
    
            -- Misc Chunk
            double_jump = false,
            the_soul = false,
            better_mana = false,
            ignore_danger = false,
            execute_on_serverhop = false,
            proximity_notifier = false,
            proximity_ignore_allies = false,
            loop_join = false,
            roblox_chat = false,
            unhide_players = false,
            gate_anti_backfire = false,
            streamer_mode = false,

            -- Keybinds Chunk
            flight_keybind = nil,
            noclip_keybind = nil,
            freecam_keybind = nil,
            player_esp_keybind = nil,
            ore_esp_keybind = nil,
            ingredient_esp_keybind = nil,
            attach_to_back_keybind = nil,
            fullbright_keybind = nil,
            no_fog_keybind = nil,
            auto_bag_keybind = nil,
            auto_trinket_pickup_keybind = nil,
            auto_ingredient_pickup_keybind = nil,
            auto_weapon_keybind = nil,
            auto_craft_delay = 0.25,
            ps_heal_button_keybind = nil,
            instant_menu_keybind = nil,
            menu_keybind = "RightShift",
            unload_keybind = "End",

            -- UI Chunk
            auto_housemate_ally = false,
            auto_friend_ally = false,
            notifications = true,
            notification_volume = 5,
            ignore_friendly = false,
            blatant_mode = false,
            status_effects = false,
            keybinds_ui = false,
            keybind_frame_position = nil,
            status_frame_position = nil,

            -- Webhook
            webhook = "",

            -- Spoofing Chunk
            custom_name_spoof = "",
            custom_day_spoof = 1,
            spoof_days_enabled = false,

            -- Character Customization
            char_custom_enabled = false,
            char_custom_face = "",
            char_custom_shirt = "",
            char_custom_pants = "",
            char_custom_accessories = "",
            char_custom_skin_color = Color3.fromRGB(255, 253, 247),
            char_custom_rlface_color = Color3.fromRGB(255, 253, 247),
            char_custom_clothing_dye = Color3.fromRGB(255, 253, 247),
            outfit_shirt_color = nil,
            outfit_pants_color = nil,
        },
        stuns = { -- Some of these don't need to be here, but only here cause of zyu
            ManaStop = true,
            Sprinting = true,
            Action = true,
            NoJump = true,
            HeavyAttack = true,
            LightAttack = true,
            NoJump = true,
            ForwardDash = true,
            RecentDash = true,
            ClimbCoolDown = true,
            NoDam = true,
            NoDash = true,
            Casting = true,
            BeingExecuted = true,
            IsClimbing = true,
            Blocking = true,
            NoControl = true,
            MustSprint = true,
            AttackExcept = true,
            Poisoned = true,
            BarrierCD = true,
            TimeStop = true,
            TimeStopped = true,
            JumpCool = true,
            Danger = true,
        },
        mental_injuries = {
            Hallucinations = true,
            PsychoInjury = true,
            AttackExcept = true,
            Whispering = true,
            Quivering = true,
            NoControl = true,
            Careless = true,
            Maniacal = true,
            Fearful = true
        },
        physical_injuries = { -- Removed Knocked, Unconscious because if you spoof it; it will brick ur client
            BrokenLeg = false,
            BrokenRib = false,
            BrokenArm = false,
        },
        valid_projectiles = {
            'FlowerProjectile',
        },
        last_names = {
            "Binary", "Rosine", "Tsuyi", "Ceos",
            "Famous", "Mudock", "Billbert", "Revenge", "Legate",
            "Emperor", "King", "Duke", "Warden", "33", "Blunt",
            "Baba", "Bazaar", "Rango", "Otf", "Topuria", "Bodyslam",
            "Hawktuah", "Azelf", "Nightraven", "Gallica", "Hydroxide",
            "Joyuri", "Female", "Democracy", "Kikihub", "Heroinhound"
        },
        class_identifiers = {
            ["Oni"] = {"Misogi"},
            ["Dragon Sage"] = {"DragonDash"},
            ["Illusionist"] = {"Dominus","Intermissum","Globus","Claritum","Custos","Observe"},
            ["Druid"] = {"Verdien","Fon Vitae","Perflora","Floresco","Life Sense", "Poison Soul"},
            ["Necromancer"] = {"Inferi","Reditus","Ligans","Furantur","Secare","Command Monsters","Howler"} ,
            ["Whisperer"] = {"Acrobat", "RapierTraining"},
            ["Bard"] = {"Joyous Dance","Sweet Soothing","Song of Lethargy"},
            ["Faceless"] = {"UpgradedBane"},
            ["Shinobi"] = {"Grapple","Resurrection"},
            ["Dragon Slayer"] = {"Dragon Awakening"},
            ["Spearfisher"] = {"Harpoon","Skewer","Hunter's Focus"},
            ["Deep Knight"] = {"Chain Pull", "PrinceBlessing"},
            ["Sigil Knight"] = {"Hyper Body","White Flame Charge"},
            ["Wraith Knight"] = {"Dark Charged Blow"},
            ["Blacksmith"] = {"Remote Smithing","Grindstone"},
            ["Ronin"] = {"Calm Mind","Swallow Reversal","Triple Slash","Blade Flash","Flowing Counter"},
            ["Abyss Walker"] = {"Abyssal Scream","Wrathful Leap"},
        },
        spell_cost = {
            ["Armis"] = {{40, 60}, {70, 80}},
            ["Trickstus"] = {{30, 70}, {30, 50}},
            ["Scrupus"] = {{30, 100}, {30, 100}},
            ["Celeritas"] = {{70, 90}, {70, 80}},
            ["Ignis"] = {{80, 95}, {53, 57}},
            ["Gelidus"] = {{80, 95}, {85, 100}},
            ["Viribus"] = {{23, 35}, {60, 70}},
            ["Sagitta Sol"] = {{50, 65}, {40, 60}},
            ["Tenebris"] = {{90, 100}, {40, 60}},
            ["Nocere"] = {{70, 85}, {70, 85}},
            ["Hystericus"] = {{75, 90}, {15, 35}},
            ["Shrieker"] = {{30, 50}, {30, 50}},
            ["Verdien"] = {{75, 100}, {75, 85}},
            ["Contrarium"] = {{80, 95}, {70, 90}},
            ["Floresco"] = {{90, 100}, {80, 95}},
            ["Perflora"] = {{70, 90}, {30, 50}},
            ["Manus Dei"] = {{90, 95}, {50, 60}},
            ["Fons Vitae"] = {{75, 100}, {75, 100}},
            ["Trahere"] = {{75, 85}, {75, 85}},
            ["Furantur"] = {{60, 80}, {60, 80}},
            ["Inferi"] = {{10, 30}, {10, 30}},
            ["Howler"] = {{60, 80}, {60, 80}},
            ["Secare"] = {{90, 95}, {90, 95}},
            ["Ligans"] = {{63, 80}, {63, 80}},
            ["Reditus"] = {{50, 100}, {50, 100}},
            ["Fimbulvetr"] = {{86, 90}, {70, 80}},
            ["Gate"] = {{75, 83}, {75, 83}},
            ["Snarvindur"] = {{60, 75}, {20, 30}},
            ["Hoppa"] = {{40, 60}, {50, 60}},
            ["Percutiens"] = {{60, 70}, {70, 80}},
            ["Dominus"] = {{50, 100}, {50, 100}},
            ["Custos"] = {{45, 65}, {45, 65}},
            ["Claritum"] = {{90, 100}, {90, 100}},
            ["Globus"] = {{70, 100}, {70, 100}},
            ["Intermissum"] = {{70, 100}, {70, 100}},
            ["Sraunus"] = {{1, 50}, {1, 50}},
            ["Nosferatus"] = {{95, 100}, {95, 100}},
            ["Gourdus"] = {{80, 90}, {80, 90}},
            ["Telorum"] = {{80, 90}, {75, 85}},
            ["Velo"] = {{0, 100}, {50, 60}}
        },
        trinket_colors = {
            none = {ZIndex = 1,Color = Color3.fromRGB(40, 40, 40)}, -- Gray
            common = {ZIndex = 2,Color = Color3.fromRGB(189, 97, 29)}, -- Brown
            rare = {ZIndex = 3,Color = Color3.fromRGB(60, 150, 150)}, -- Blue
            event = {ZIndex = 4,Color = Color3.fromRGB(0, 255, 0)}, -- Green
            artifact = {ZIndex = 5,Color = Color3.fromRGB(160, 100, 160)}, -- Purple
            mythic = {ZIndex = 6,Color = Color3.fromRGB(255, 0, 80)}, -- Red
        },
        custom_flight_functions = {
            ["IsKeyDown"] = uis.IsKeyDown,
            ["GetFocusedTextBox"] = uis.GetFocusedTextBox,
        },
        ingredient_identifiers = {
            ["3293218896"] = "Desert Mist",
            ["2773353559"] = "Blood Thorn",
            ["2960178471"] = "Snowscroom",
            ["2577691737"] = "Lava Flower",
            ["2618765559"] = "Glow Scroom",
            ["2575167210"] = "Moss Plant",
            ["2620905234"] = "Scroom",
            ["2766925289"] = "Trote",
            ["2766925320"] = "Polar Plant",
            ["2766802713"] = "Periashroom",
            ["2766802766"] = "Strange Tentacle",
            ["2766925228"] = "Tellbloom",
            ["2766802731"] = "Dire Flower",   
            ["2573998175"] = "Freeleaf",
            ["2766925214"] = "Crown Flower",
            ["3215371492"] = "Potato",
            ["2766925304"] = "Vile Seed",
            ["3049345298"] = "Zombie Scroom",
            ["2766802752"] = "Orcher Leaf",
            ["2766925267"] = "Creely",
            ["2889328388"] = "Ice Jar",
            ["3049928758"] = "Canewood",
            ["3049556532"] = "Acorn Light",
            ["2766925245"] = "Uncanny Tentacle",
            ["9858299042"] = "Evoflower",
        },
        must_touch = {
            [BrickColor.new("Reddish brown").Number] = true, -- idk
            [BrickColor.new("Copper").Number] = true,
            [BrickColor.new("Magenta").Number] = true,
        },
        safe_bricks = {
            Fire = true,
            OrderField = true,
            PoisonField = true,
            SolanBall = true,
            SolansGate = true,
            BaalField = true,
            Elevator = true,
            MageField = true,
            TeleportIn = true,
            TeleportOut = true,
        },
        blacklisted_ingredients = {
            [Vector3.new(1967.81348, 177.639648, 1084.42285)] = true,
            [Vector3.new(1987.31, 177.64, 1080.92)] = true,
            [Vector3.new(2511.75, 198.985, -442.45)] = true,
            [Vector3.new(2510.07, 199.709, -518.071)] = true,
            [Vector3.new(2512.57, 199.709, -518.321)] = true,
            [Vector3.new(2511.57, 199.709, -517.071)] = true,
            [Vector3.new(2438.07, 199.709, -466.071)] = true,
            [Vector3.new(2439.07, 199.709, -467.321)] = true,
            [Vector3.new(2439.57, 199.709, -465.071)] = true,
        },
        artifacts = {"Rift Gem", "Lannis's Amulet", "Amulet of the White King", "Scroll of Fimbulvetr", "Scroll of Percutiens", "Scroll of Hoppa", "Scroll of Snarvindur", "Scroll of Manus Dei", "Spider Cloak", "Night Stone", "Philosophers Stone", "Howler Friend", "Phoenix Down", "Azael Horn", "Mysterious Artifact", "Fairfrozen", "Phoenix Flower"},
        spec_skills = {"Eyes of Justice", "Justinian's Helm", "Speech", "Undying Justinian", "Handgun", "StaticField", "Chain Lightning", "Flying Mushroom God", "Flying Flower God", "Overgrowth", "Scroomflora", "Mind Read", "Domination Rune", "Bestowal", "Domination", "Despair", "Better Manus Dei", "Better Mori", "Maledicta Terra", "Terrible Scream", "FrostAura", "Ray of Frost", "Aculeor", "Infettare", "Sylvester's Cloak", "Jester's Trick", "Quick Stop", "Abyssbypass", "VeryCoolBard", "Snowball", "Time Halt", "Time Erase", "Jester's Ruse", "Jester's Scheme", "Wallet Swipe", "Epitaph", "Pondus", "Darkness"},
        mod_list = {
            117075515, -- // epotomy
            117092117, -- // zv_l
            218915876, -- // fun135090
            147287757, -- // sethpremecy
            1992980412, -- // DrDokieHead
            2352320475, -- // DrDSage
            1923314177, -- // DrTableHead
            1315267418, -- // Morqam
            1929945985, -- // DrDokieFace
            29656, -- // mam
            3408465701, -- // cantostyle
            272525488, -- // BurningDumpsterFire
            360905811, -- // aaRoks1234
            309149657, -- // Ra_ymond
            2758900605, -- // radicalpipelayer
            2052324682, -- // pentchann
            1220344444, -- // BlueRedGreenBRG
            1099784, -- // Doctor5
            1090716399, -- // Rindyrsil
            1754748220, -- // BlenzSr
            78504910, -- // shadoworth101
            364994040, -- // Grimiore
            96218539, -- // AvailableEnergetic
            434535742, -- // Masmixel
            19044993, -- // FrazoraX
            411595307, -- // ReEvolu
            1490237662, -- // detestdoot
            1255256325, -- // Grand_Archives
            1306981979, -- // kylenuts
            20469570, -- // vezplaw
            71662791, -- // thiari
            77196836, -- // XeroNavy
            28177302, -- // Midnight_zz
            8835343, -- // blutreefrog
            88193330, -- // sabyism
            83785067, -- // killer67564564643
            2542030529, -- // Brathruzas
            274304909, -- // redemtions
            2441088083, -- // cornagedotxyz
            177436599, -- // tommychongthe2nd
            64992045, -- // bluetetraninja
            1866587913, -- // WipeMePleaseOk
            1586650903, -- // stummycapalot
            1085890137, -- // babymouthy
            143241422, -- // Noblesman
            1014826936, -- // p0vd
            1657035, -- // lucman27
            2259720861, -- // HateBored
            338544906, -- // drypth
            399618581, -- // Almedris
            73062, -- // Adonis
            167825083, -- // melonbeard
            110153256, -- // Gizen_K
            266800563, -- // Lazureos
            1216700054, -- // KittyTheYeeter
            3314396480, -- // HugeEcuadorianMan
            3292692379, -- // cookiesoda221
            1427798376, -- // Agamatsu
            1626803537, -- // Shadiphx
            1311587059, -- // RagoozersLeftSock
            988461535, -- // mime_keep
            3006409955, -- // Bismuullah
            2485656647, -- // z_rolled
            1255256325, -- // panchikorox
            2228891194, -- // Rivai_Ackermann
            2243463821, -- // Rivaihuh
            2252396915, -- // magicverdien
            1989789343, -- // tayissecy
            8791234913, -- // batu alt (Iriletion)
            2260532477,
        },
        aimbot = {
            aimkey_translation = {
                ["mouse1"] = Enum.UserInputType.MouseButton1,
                ["mouse2"] = Enum.UserInputType.MouseButton2,
            },
            silent_vector = nil,
            current_target = nil,
        },
        friends = {},
        connections = {},
        window_active = true,
    }

    -- Friends save/load functions
    local friends_file = "HYDROXIDE/friends.json"
    function cheat_client:save_friends()
        local success, err = pcall(function()
            local json = game:GetService("HttpService"):JSONEncode(self.friends)
            writefile(friends_file, json)
        end)
        if not success then
            warn("[Friends] Failed to save:", err)
        end
    end

    function cheat_client:load_friends()
        local success, result = pcall(function()
            if isfile(friends_file) then
                local json = readfile(friends_file)
                return game:GetService("HttpService"):JSONDecode(json)
            end
            return {}
        end)

        if success and result then
            self.friends = result
        else
            self.friends = {}
        end
    end

    -- Load friends on startup
    cheat_client:load_friends()

    local cpu = {
        services = {
            uis = game:GetService('UserInputService'),
            vs = game:GetService("VirtualUser"),
            rs = game:GetService("RunService"),
            ugs = UserSettings():GetService('UserGameSettings'),
            plrs = game:GetService("Players"),
                
            ms = UserSettings():GetService('UserGameSettings').MasterVolume,
            ql = settings().Rendering.QualityLevel,
        },
        status = {
            active = false,
            hd_mode = false,
            focused = false,
        }
    }

    local ROBLOX_API_HEADERS = {
        ["Content-Type"] = "application/json",
        ["Accept"] = "application/json",
        ["Cookie"] = ".ROBLOSECURITY=_|WARNING:-DO-NOT-SHARE-THIS.--Sharing-this-will-allow-someone-to-log-in-as-you-and-to-steal-your-ROBUX-and-items.|_CAEaAhAB.05EF5534C60BAE5A145958C9FB15A4FA18BE6CC674120F40071EAD68B1ACC506842C0C0A25A537D719B878862CF5E69F9D3D2FBA62E8697D6C2792B9117487BB5B733A64F857BA8D0AF11631A1135B8FB272C5AF3A110CB8AF55586A41262C006AEF2D30CD4AD457B5E076F31B05C073003F464A7CF6BCA3C8A2D09ED9072BF6E31A259265C4B978F1725726614A004B6B1B014EBB7BE54E211848272773CBDF48196D7DB96E5D537C1B65F118239666C6AF9461D76C25B0B40854339B3A053A8950506F6E2A474D352A34CEE02FB0BB898DF00462660A51D9CB2E1A430E93ECE2A29B383D6F8864C76850477D084BAC48731A386105799E42B1C1A87C6B9D0D69F9C823AEDB8E21AABA9EF07BFA5B1E3CC3EAC60D1A17B54B4E8FA7AB4D241B96F2F82233BBF0CF4A751E7145DFB01CF6038AD93E61D74A6EE6D1E94048D74BF44CC8D961E0158659F8139085645643B92623891C83155AA67F4930110D247EEDAFDB69332EF0E52686FF3273FE1632B7035C75425727EF2AA9ACC19472BBD6C90C281F56C9B6FA36CF8146DD3E5D21DB698FB5CCCA2AD5366BED6329842CA8666A5C96986D5CC2393DEAF4115012B2A9FC54F1E81CC3A541A44E39EC7253DCFE8EA4795C99B31261E949C552DE1444357F5CBF67C2705DFCB4B06788D63F20F02B8B6D0528CC1EC1500161BB5F09E64D50B1CE648995E526A49B7EADA865C3B0026869CFB9255A9F12E128DFFEF897A7D003D34ACB14B12029BBE046DD643532B9780B9D81004653B74388959CA9C91ED6D7D9EA2A098BC99EBCC0029D868C0ECFAC3C8C38B21355CA23C8412A169407BA3D71368C500C9E53B2471B1E2BE617BD79B8B291E4F2D016A1E6880817EC37BFFC298D5F40A9A20F8C7C0091BD8123E15DF782FE33FAA67CA52C16B6B0A71DB4DEE75A48BD89F77FF24803A9D310C207A932FD16200A486D2CEF7DC2F89467CEF12210F58E98D7C2057F53DBCDFE868A077891FC64EC4AD130B540DDD78C46C815BDBD564FB339AFAC7423E994F5C3C70DEB34D0EFFFD5E5F09C55232222849269DAD5FA94D98124AE21BECA3CD4927BF88F3C7EFB3D9D8F5B1E784C7B002CAB627AE82C9413B02F210A11A9778BF257ABE6246331C8A9D34846D86814F82F69DE845C1AEC2D077CFB45F4F3FBB48CD224F24C629DB35806CA4B49E92DE5856433837EE68F2D10F9882D8879858702B63CA0464CA1E12EEA954AFA683E8A8823DED9"
    }
    
    -- Encrypt Module
    do
        local BitBuffer
    
        do -- Bit Buffer Module
            BitBuffer = {}
    
            local NumberToBase64; local Base64ToNumber; do
                NumberToBase64 = {}
                Base64ToNumber = {}
                local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                for i = 1, #chars do
                    local ch = chars:sub(i, i)
                    NumberToBase64[i-1] = ch
                    Base64ToNumber[ch] = i-1
                end
            end
    
            local PowerOfTwo; do
                PowerOfTwo = {}
                for i = 0, 64 do
                    PowerOfTwo[i] = 2^i
                end
            end
    
            local BrickColorToNumber; local NumberToBrickColor; do
                BrickColorToNumber = {}
                NumberToBrickColor = {}
                for i = 0, 63 do
                    local color = BrickColor.palette(i)
                    BrickColorToNumber[color.Number] = i
                    NumberToBrickColor[i] = color
                end
            end
    
            local floor,insert = math.floor, table.insert
            local abs, sqrt, random = math.abs, math.sqrt, math.random
            local max, min, ceil = math.max, math.min, math.ceil
            
            function fast_remove(tbl, value)
                for i = #tbl, 1, -1 do
                    if tbl[i] == value then
                        tbl[i] = tbl[#tbl]
                        tbl[#tbl] = nil
                        return true
                    end
                end
                return false
            end
            function ToBase(n, b)
                n = floor(n)
                if not b or b == 10 then return tostring(n) end
                local digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                local t = {}
                local sign = ""
                if n < 0 then
                    sign = "-"
                    n = -n
                end
                repeat
                    local d = (n % b) + 1
                    n = floor(n / b)
                    insert(t, 1, digits:sub(d, d))
                until n == 0
                return sign..table.concat(t, "")
            end
    
            function BitBuffer.Create()
                local this = {}
    
                -- Tracking
                local mBitPtr = 0
                local mBitBuffer = {}
    
                function this:ResetPtr()
                    mBitPtr = 0
                end
                function this:Reset()
                    mBitBuffer = {}
                    mBitPtr = 0
                end
    
                -- Set debugging on
                local mDebug = false
                function this:SetDebug(state)
                    mDebug = state
                end
    
                -- Read / Write to a string
                function this:FromString(str)
                    this:Reset()
                    for i = 1, #str do
                        local ch = str:sub(i, i):byte()
                        for i = 1, 8 do
                            mBitPtr = mBitPtr + 1
                            mBitBuffer[mBitPtr] = ch % 2
                            ch = math.floor(ch / 2)
                        end
                    end
                    mBitPtr = 0
                end
                function this:ToString()
                    local chars = {}
                    local charIndex = 1
                    local accum = 0
                    local pow = 0
                    for i = 1, ceil((#mBitBuffer) / 8)*8 do
                        accum = accum + PowerOfTwo[pow]*(mBitBuffer[i] or 0)
                        pow = pow + 1
                        if pow >= 8 then
                            chars[charIndex] = string.char(accum)
                            charIndex = charIndex + 1
                            accum = 0
                            pow = 0
                        end
                    end
                    return table.concat(chars)
                end
    
                -- Read / Write to base64
                function this:FromBase64(str)
                    this:Reset()
                    for i = 1, #str do
                        local ch = Base64ToNumber[str:sub(i, i)]
                        assert(ch, "Bad character: 0x"..ToBase(str:sub(i, i):byte(), 16))
                        for i = 1, 6 do
                            mBitPtr = mBitPtr + 1
                            mBitBuffer[mBitPtr] = ch % 2
                            ch = math.floor(ch / 2)
                        end
                        assert(ch == 0, "Character value 0x"..ToBase(Base64ToNumber[str:sub(i, i)], 16).." too large")
                    end
                    this:ResetPtr()
                end
                function this:ToBase64()
                    local strtab = {}
                    local accum = 0
                    local pow = 0
                    for i = 1, math.ceil((#mBitBuffer) / 6)*6 do
                        accum = accum + PowerOfTwo[pow]*(mBitBuffer[i] or 0)
                        pow = pow + 1
                        if pow >= 6 then
                            strtab[#strtab + 1] = NumberToBase64[accum]
                            accum = 0
                            pow = 0
                        end
                    end
                    return table.concat(strtab)
                end	
    
                -- Dump
                function this:Dump()
                    local str = ""
                    local str2 = ""
                    local accum = 0
                    local pow = 0
                    for i = 1, math.ceil((#mBitBuffer) / 8)*8 do
                        str2 = str2..(mBitBuffer[i] or 0)
                        accum = accum + PowerOfTwo[pow]*(mBitBuffer[i] or 0)
                        --print(pow..": +"..PowerOfTwo[pow].."*["..(mBitBuffer[i] or 0).."] -> "..accum)
                        pow = pow + 1
                        if pow >= 8 then
                            str2 = str2.." "
                            str = str.."0x"..ToBase(accum, 16).." "
                            accum = 0
                            pow = 0
                        end
                    end
                end
    
                -- Read / Write a bit
                local function writeBit(v)
                    mBitPtr = mBitPtr + 1
                    mBitBuffer[mBitPtr] = v
                end
                local function readBit(v)
                    mBitPtr = mBitPtr + 1
                    return mBitBuffer[mBitPtr]
                end
    
                -- Read / Write an unsigned number
                function this:WriteUnsigned(w, value, printoff)
                    assert(w, "Bad arguments to BitBuffer::WriteUnsigned (Missing BitWidth)")
                    assert(value, "Bad arguments to BitBuffer::WriteUnsigned (Missing Value)")
                    assert(value >= 0, "Negative value to BitBuffer::WriteUnsigned")
                    assert(math.floor(value) == value, "Non-integer value to BitBuffer::WriteUnsigned")
                    if mDebug and not printoff then
                        warn("WriteUnsigned["..w.."]:", value)
                    end
                    -- Store LSB first
                    for i = 1, w do
                        writeBit(value % 2)
                        value = math.floor(value / 2)
                    end
                    assert(value == 0, "Value "..tostring(value).." has width greater than "..w.."bits")
                end 
                function this:ReadUnsigned(w, printoff)
                    local value = 0
                    for i = 1, w do
                        value = value + readBit() * PowerOfTwo[i-1]
                    end
                    return value
                end
    
                -- Read / Write a signed number
                function this:WriteSigned(w, value)
                    assert(w and value, "Bad arguments to BitBuffer::WriteSigned (Did you forget a bitWidth?)")
                    assert(math.floor(value) == value, "Non-integer value to BitBuffer::WriteSigned")
                    -- Write sign
                    if value < 0 then
                        writeBit(1)
                        value = -value
                    else
                        writeBit(0)
                    end
                    -- Write value
                    this:WriteUnsigned(w-1, value, true)
                end
                function this:ReadSigned(w)
                    -- Read sign
                    local sign = (-1)^readBit()
                    -- Read value
                    local value = this:ReadUnsigned(w-1, true)
                    if mDebug then
                        warn("ReadSigned["..w.."]:", sign*value)
                    end
                    return sign*value
                end
    
                -- Read / Write a string. May contain embedded nulls (string.char(0))
                function this:WriteString(s)
                    -- First check if it's a 7 or 8 bit width of string
                    local bitWidth = 7
                    for i = 1, #s do
                        if s:sub(i, i):byte() > 127 then
                            bitWidth = 8
                            break
                        end
                    end
    
                    -- Write the bit width flag
                    if bitWidth == 7 then
                        this:WriteBool(false)
                    else
                        this:WriteBool(true) -- wide chars
                    end
    
                    -- Now write out the string, terminated with "0x10, 0b0"
                    -- 0x10 is encoded as "0x10, 0b1"
                    for i = 1, #s do
                        local ch = s:sub(i, i):byte()
                        if ch == 0x10 then
                            this:WriteUnsigned(bitWidth, 0x10)
                            this:WriteBool(true)
                        else
                            this:WriteUnsigned(bitWidth, ch)
                        end
                    end
    
                    -- Write terminator
                    this:WriteUnsigned(bitWidth, 0x10)
                    this:WriteBool(false)
                end
                function this:ReadString()
                    -- Get bit width
                    local bitWidth;
                    if this:ReadBool() then
                        bitWidth = 8
                    else
                        bitWidth = 7
                    end
    
                    -- Loop
                    local str = ""
                    while true do
                        local ch = this:ReadUnsigned(bitWidth)
                        if ch == 0x10 then
                            local flag = this:ReadBool()
                            if flag then
                                str = str..string.char(0x10)
                            else
                                break
                            end
                        else
                            str = str..string.char(ch)
                        end
                    end
                    return str
                end
    
                -- Read / Write a bool
                function this:WriteBool(v)
                    if v then
                        this:WriteUnsigned(1, 1, true)
                    else
                        this:WriteUnsigned(1, 0, true)
                    end
                end
                function this:ReadBool()
                    local v = (this:ReadUnsigned(1, true) == 1)
                    return v
                end
    
                -- Read / Write a floating point number with |wfrac| fraction part
                -- bits, |wexp| exponent part bits, and one sign bit.
                function this:WriteFloat(wfrac, wexp, f)
                    assert(wfrac and wexp and f)
    
                    -- Sign
                    local sign = 1
                    if f < 0 then
                        f = -f
                        sign = -1
                    end
    
                    -- Decompose
                    local mantissa, exponent = math.frexp(f)
                    if exponent == 0 and mantissa == 0 then
                        this:WriteUnsigned(wfrac + wexp + 1, 0)
                        return
                    else
                        mantissa = ((mantissa - 0.5)/0.5 * PowerOfTwo[wfrac])
                    end
    
                    -- Write sign
                    if sign == -1 then
                        this:WriteBool(true)
                    else
                        this:WriteBool(false)
                    end
    
                    -- Write mantissa
                    mantissa = math.floor(mantissa + 0.5) -- Not really correct, should round up/down based on the parity of |wexp|
                    this:WriteUnsigned(wfrac, mantissa)
    
                    -- Write exponent
                    local maxExp = PowerOfTwo[wexp-1]-1
                    if exponent > maxExp then
                        exponent = maxExp
                    end
                    if exponent < -maxExp then
                        exponent = -maxExp
                    end
                    this:WriteSigned(wexp, exponent)	
                end
                function this:ReadFloat(wfrac, wexp)
                    assert(wfrac and wexp)
    
                    -- Read sign
                    local sign = 1
                    if this:ReadBool() then
                        sign = -1
                    end
    
                    -- Read mantissa
                    local mantissa = this:ReadUnsigned(wfrac)
    
                    -- Read exponent
                    local exponent = this:ReadSigned(wexp)
                    if exponent == 0 and mantissa == 0 then
                        return 0
                    end
    
                    -- Convert mantissa
                    mantissa = mantissa / PowerOfTwo[wfrac] * 0.5 + 0.5
    
                    -- Output
                    return sign * math.ldexp(mantissa, exponent)
                end
    
                -- Read / Write single precision floating point
                function this:WriteFloat32(f)
                    this:WriteFloat(23, 8, f)
                end
                function this:ReadFloat32()
                    return this:ReadFloat(23, 8)
                end
    
                -- Read / Write double precision floating point
                function this:WriteFloat64(f)
                    this:WriteFloat(52, 11, f)
                end
                function this:ReadFloat64()
                    return this:ReadFloat(52, 11)
                end
    
                -- Read / Write a BrickColor
                function this:WriteBrickColor(b)
                    local pnum = BrickColorToNumber[b.Number]
                    if not pnum then
                        warn("Attempt to serialize non-pallete BrickColor `"..tostring(b).."` (#"..b.Number.."), using Light Stone Grey instead.")
                        pnum = BrickColorToNumber[BrickColor.new(1032).Number]
                    end
                    this:WriteUnsigned(6, pnum)
                end
                function this:ReadBrickColor()
                    return NumberToBrickColor[this:ReadUnsigned(6)]
                end
    
                -- Read / Write a rotation as a 64bit value.
                local function round(n)
                    return math.floor(n + 0.5)
                end
                function this:WriteRotation(cf)
                    local lookVector = cf.lookVector
                    local azumith = math.atan2(-lookVector.X, -lookVector.Z)
                    local ybase = (lookVector.X^2 + lookVector.Z^2)^0.5
                    local elevation = math.atan2(lookVector.Y, ybase)
                    local withoutRoll = CFrame.new(cf.p) * CFrame.Angles(0, azumith, 0) * CFrame.Angles(elevation, 0, 0)
                    local x, y, z = (withoutRoll:inverse()*cf):toEulerAnglesXYZ()
                    local roll = z
                    -- Atan2 -> in the range [-pi, pi] 
                    azumith   = round((azumith   /  math.pi   ) * (2^21-1))
                    roll      = round((roll      /  math.pi   ) * (2^20-1))
                    elevation = round((elevation / (math.pi/2)) * (2^20-1))
                    --
                    this:WriteSigned(22, azumith)
                    this:WriteSigned(21, roll)
                    this:WriteSigned(21, elevation)
                end
                function this:ReadRotation()
                    local azumith   = this:ReadSigned(22)
                    local roll      = this:ReadSigned(21)
                    local elevation = this:ReadSigned(21)
                    --
                    azumith =    math.pi    * (azumith / (2^21-1))
                    roll =       math.pi    * (roll    / (2^20-1))
                    elevation = (math.pi/2) * (elevation / (2^20-1))
                    --
                    local rot = CFrame.Angles(0, azumith, 0)
                    rot = rot * CFrame.Angles(elevation, 0, 0)
                    rot = rot * CFrame.Angles(0, 0, roll)
                    --
                    return rot
                end
    
                return this
            end
    
        end
    
        local TypeIntegerLength = 3
        local IntegerLength = 10
    
        local function TypeToId(Type)
            if Type == "Integer" then
                return 1
            elseif Type == "NegInteger" then
                return 2
            elseif Type == "Number" then
                return 3
            elseif Type == "String" then
                return 4
            elseif Type == "Boolean" then
                return 5
            elseif Type == "Table" then
                return 6
            end
            return 0
        end
    
        local function IdToType(Type)
            if Type == 1 then
                return "Integer"
            elseif Type == 2 then
                return "NegInteger"
            elseif Type == 3 then
                return "Number"
            elseif Type == 4 then
                return "String"
            elseif Type == 5 then
                return "Boolean"
            elseif Type == 6 then
                return "Table"
            end
        end
    
        local function IsInt(Number)
            local Decimal = string.find(tostring(Number),"%.")
            if Decimal then
                return false
            else
                return true
            end
        end
    
        local function log(Base,Number)
            return math.log(Number)/math.log(Base)
        end
    
        local function GetMaxBitsInt(Table)
            local Max = 0
            for Key,Value in pairs(Table) do
                if type(Value) == "number" then
                    Value = math.abs(Value)
                    if IsInt(Value) and Value > 0 then
                        local Bits = math.ceil(log(2,Value + 1))
                        if Bits > Max then Max = Bits end
                    end
                end
                
                if type(Key) == "number" then
                    Key = math.abs(Key)
                    if IsInt(Key) and Key > 0 then
                        local Bits = math.ceil(log(2,Key + 1))
                        if Bits > Max then Max = Bits end
                    end
                end
            end
            return Max*2
        end
    
        local function GetTableLength(Table)
            local Total = 0
            for _,_ in pairs(Table) do
                Total = Total + 1
            end
            return Total
        end
    
        local function GetType(Key)
            local Type = type(Key) 
            if Type == "number" then
                if IsInt(Key) then
                    if Key < 0 then
                        return "NegInteger"
                    end
                    return "Integer"
                else
                    return "Number"
                end
            else
                return Type
            end
        end
    
        local function GetAllType(Table)
            local Type
            for Key,_ in pairs(Table) do
                if not Type then 
                    Type = GetType(Key)
                end
                if type(Key) ~= Type then
                    local NewType = GetType(Key)
                    if NewType ~= Type then
                        return nil
                    end
                end
            end	
            if Type == "Number" then
                return "Number"
            elseif Type == "Integer" then
                return "Integer"
            elseif Type == "NegInteger" then
                return "NegInteger"
            else
                return "String"
            end
        end
    
        local crypt = {}
        function crypt:encode(Table,UseBase64,_depth)
            _depth = _depth or 0
            if _depth > 50 then
                error("Table nesting exceeds 50 levels - possible circular reference")
            end

            local AllType = GetAllType(Table)
            local Buffer = BitBuffer.Create()
            if UseBase64 == true then
                Buffer:WriteBool(true)
            else
                Buffer:WriteBool(false)
            end
            Buffer:WriteUnsigned(IntegerLength,GetTableLength(Table))

            local function WriteFloat(Number)
                if UseBase64 == true then
                    Buffer:WriteFloat64(Number)
                else
                    Buffer:WriteFloat32(Number)
                end
            end
            Buffer:WriteUnsigned(TypeIntegerLength,TypeToId(AllType))
            local MaxBits = GetMaxBitsInt(Table)
            Buffer:WriteUnsigned(IntegerLength,MaxBits)

            local function WriteKey(Key,AllowAllSame)
                if not (AllowAllSame == true and AllType) then
                    Buffer:WriteUnsigned(TypeIntegerLength,Key)
                elseif AllowAllSame == false then
                    Buffer:WriteUnsigned(TypeIntegerLength,Key)
                end
            end

            for Key,Value in pairs(Table) do
                if type(Key) == "string" then
                    WriteKey(TypeToId("String"),true)
                    Buffer:WriteString(Key)
                elseif type(Key) == "number" and IsInt(Key) then
                    if Key >= 0 then
                        WriteKey(TypeToId("Integer"),true)
                        Buffer:WriteUnsigned(MaxBits,Key)
                    else
                        WriteKey(TypeToId("NegInteger"),true)
                        Buffer:WriteSigned(MaxBits*2,Key)
                    end
                elseif type(Key) == "number" then
                    WriteKey(TypeToId("Number"),true)
                    WriteFloat(Key)
                end

                if type(Value) == "boolean" then
                    WriteKey(TypeToId("Boolean"))
                    Buffer:WriteBool(Value)
                elseif type(Value) == "number" then
                    if IsInt(Value) then
                        if Value < 0 then
                            WriteKey(TypeToId("NegInteger"))
                            Buffer:WriteSigned(MaxBits*2,Value)
                        else
                            WriteKey(TypeToId("Integer"))
                            Buffer:WriteUnsigned(MaxBits,Value)
                        end
                    else
                        WriteKey(TypeToId("Number"))
                        WriteFloat(Value)
                    end
                elseif type(Value) == "table" then
                    WriteKey(TypeToId("Table"))
                    Buffer:WriteString(crypt:encode(Value,UseBase64,_depth + 1))
                elseif type(Value) == "string" then
                    WriteKey(TypeToId("String"))
                    Buffer:WriteString(tostring(Value))
                end
            end
            return Buffer:ToBase64()
        end
    
        function crypt:decode(BinaryString,_depth)
            _depth = _depth or 0
            if _depth > 50 then
                error("Table nesting exceeds 50 levels during decode")
            end

            local Buffer = BitBuffer.Create()
            Buffer:FromBase64(BinaryString)
            local Table = {}
            local UseBase64 = Buffer:ReadBool()
            local function ReadFloat()
                if UseBase64 == true then
                    return Buffer:ReadFloat64()
                else
                    return Buffer:ReadFloat32()
                end
            end
            local Length = Buffer:ReadUnsigned(IntegerLength)
            local AllType = Buffer:ReadUnsigned(TypeIntegerLength)
            local MaxBits = Buffer:ReadUnsigned(IntegerLength)
            if AllType == 0 then AllType = nil end

            for i = 1, Length do
                local KeyType,Key = AllType or Buffer:ReadUnsigned(TypeIntegerLength)

                local KeyRealType = IdToType(KeyType)
                if KeyRealType == "Integer" then
                    Key = Buffer:ReadUnsigned(MaxBits)
                elseif KeyRealType == "NegInteger" then
                    Key = Buffer:ReadSigned(MaxBits*2)
                elseif KeyRealType == "Number" then
                    Key = ReadFloat()
                elseif KeyRealType == "String" then
                    Key = Buffer:ReadString()
                end

                local ValueType,Value = Buffer:ReadUnsigned(TypeIntegerLength)
                local ValueRealType = IdToType(ValueType)
                if ValueRealType == "String" then
                    Value = Buffer:ReadString()
                elseif ValueRealType == "Boolean" then
                    Value = Buffer:ReadBool()
                elseif ValueRealType == "Number" then
                    Value = ReadFloat()
                elseif ValueRealType == "Integer" then
                    Value = Buffer:ReadUnsigned(MaxBits)
                elseif ValueRealType == "NegInteger" then
                    Value = Buffer:ReadSigned((MaxBits * 2))
                elseif ValueRealType == "Table" then
                    Value = crypt:decode(Buffer:ReadString(),_depth + 1)
                elseif ValueRealType == "Color3" then
                    Value = Color3.new(ReadFloat(),ReadFloat(),ReadFloat())
                elseif ValueRealType == "CFrame" then
                    Value = CFrame.new(ReadFloat(),ReadFloat(),ReadFloat()) * Buffer:ReadRotation()
                elseif ValueRealType == "BrickColor" then
                    Value = Buffer:ReadBrickColor()
                elseif ValueRealType == "UDim2" then
                    Value = UDim2.new(ReadFloat(),ReadFloat(),ReadFloat(),ReadFloat())
                elseif ValueRealType == "UDim" then
                    Value = UDim.new(ReadFloat(),ReadFloat())
                elseif ValueRealType == "Region3" then
                    Value = Region3.new(Vector3.new(ReadFloat(),ReadFloat(),ReadFloat()),Vector3.new(ReadFloat(),ReadFloat(),ReadFloat()))
                elseif ValueRealType == "Region3int16" then
                    Value = Region3int16.new(Vector3int16.new(ReadFloat(),ReadFloat(),ReadFloat()),Vector3int16.new(ReadFloat(),ReadFloat(),ReadFloat()))
                elseif ValueRealType == "Vector3" then
                    Value = Vector3.new(ReadFloat(Value.X),ReadFloat(Value.Y),ReadFloat(Value.Z))
                elseif ValueRealType == "Vector2" then
                    Value = Vector2.new(ReadFloat(Value.X),ReadFloat(Value.Y))
                elseif ValueRealType == "EnumItem" then
                    Value = Enum[Buffer:ReadString()][Buffer:ReadString()]
                elseif ValueRealType == "Enums" then
                    Value = Enum[Buffer:ReadString()]
                elseif ValueRealType == "Enum" then
                    Value = Enum
                elseif ValueRealType == "Ray" then
                    Value = Ray.new(Vector3.new(ReadFloat(),ReadFloat(),ReadFloat()),Vector3.new(ReadFloat(),ReadFloat(),ReadFloat()))
                elseif ValueRealType == "Axes" then
                    local X,Y,Z = Buffer:ReadBool(),Buffer:ReadBool(),Buffer:ReadBool()
                    Value = Axes.new(X == true and Enum.Axis.X,Y == true and Enum.Axis.Y,Z == true and Enum.Axis.Z)
                elseif ValueRealType == "Faces" then
                    local Front,Back,Left,Right,Top,Bottom = Buffer:ReadBool(),Buffer:ReadBool(),Buffer:ReadBool(),Buffer:ReadBool(),Buffer:ReadBool(),Buffer:ReadBool()
                    Value = Faces.new(Front == true and Enum.NormalId.Front,Back == true and Enum.NormalId.Back,Left == true and Enum.NormalId.Left,Right == true and Enum.NormalId.Right,Top == true and Enum.NormalId.Top,Bottom == true and Enum.NormalId.Bottom)
                elseif ValueRealType == "ColorSequence" then
                    local Points = crypt:decode(Buffer:ReadString(),_depth + 1)
                    Value = ColorSequence.new(Points[1].Value,Points[2].Value)
                elseif ValueRealType == "ColorSequenceKeypoint" then
                    Value = ColorSequenceKeypoint.new(ReadFloat(),Color3.new(ReadFloat(),ReadFloat(),ReadFloat()))
                elseif ValueRealType == "NumberRange" then
                    Value = NumberRange.new(ReadFloat(),ReadFloat())
                elseif ValueRealType == "NumberSequence" then
                    Value = NumberSequence.new(crypt:decode(Buffer:ReadString(),_depth + 1))
                elseif ValueRealType == "NumberSequenceKeypoint" then
                    Value = NumberSequenceKeypoint.new(ReadFloat(),ReadFloat(),ReadFloat())
                end
                Table[Key] = Value
            end
            return Table
        end
    
        shared.crypt = crypt
    end
    
    -- Utility Functions
    do
        function utility:Create(instanceType, instanceProperties, container)
            local instance = Drawing.new(instanceType)
            local parent
            --
            if instanceProperties["Parent"] or instanceProperties["parent"] then
                parent = instanceProperties["Parent"] or instanceProperties["parent"]
                --
                instanceProperties["parent"] = nil
                instanceProperties["Parent"] = nil
            end
            --
            for property, value in pairs(instanceProperties) do
                if property and value then
                    if property == "Size" or property == "Size" then
                        if instanceType == "Text" then
                            instance.Size = value
                        else
                            local xSize = (value.X.Scale * ((parent and parent.Size) or ws.CurrentCamera.ViewportSize).X) + value.X.Offset
                            local ySize = (value.Y.Scale * ((parent and parent.Size) or ws.CurrentCamera.ViewportSize).Y) + value.Y.Offset
                            --
                            instance.Size = Vector2.new(xSize, ySize)
                        end
                    elseif property == "Position" or property == "position" then
                        if instanceType == "Text" then
                            local xPosition = ((((parent and parent.Position) or Vector2.new(0, 0)).X) + (value.X.Scale * ((typeof(parent.Size) == "number" and parent.TextBounds) or parent.Size).X)) + value.X.Offset
                            local yPosition = ((((parent and parent.Position) or Vector2.new(0, 0)).Y) + (value.Y.Scale * ((typeof(parent.Size) == "number" and parent.TextBounds) or parent.Size).Y)) + value.Y.Offset
                            --
                            instance.Position = Vector2.new(xPosition, yPosition)
                        else
                            local xPosition = ((((parent and parent.Position) or Vector2.new(0, 0)).X) + value.X.Scale * ((parent and parent.Size) or ws.CurrentCamera.ViewportSize).X) + value.X.Offset
                            local yPosition = ((((parent and parent.Position) or Vector2.new(0, 0)).Y) + value.Y.Scale * ((parent and parent.Size) or ws.CurrentCamera.ViewportSize).Y) + value.Y.Offset
                            --
                            instance.Position = Vector2.new(xPosition, yPosition)
                        end
                    elseif property == "Color" or property == "color" then
                        if typeof(value) == "string" then
                            instance["Color"] = shared.theme[value]
                            --
                            if value == "accent" then
                                shared.accents[#shared.accents + 1] = instance
                            end
                        else
                            instance[property] = value
                        end
                    else
                        instance[property] = value
                    end
                end
            end
            --
            shared.drawing_containers[container][#shared.drawing_containers[container] + 1] = instance
            --
            return instance
        end
    
        function utility:Update(instance, instanceProperty, instanceValue, instanceParent)
            if instanceProperty == "Size" or instanceProperty == "Size" then
                local xSize = (instanceValue.X.Scale * ((instanceParent and instanceParent.Size) or ws.CurrentCamera.ViewportSize).X) + instanceValue.X.Offset
                local ySize = (instanceValue.Y.Scale * ((instanceParent and instanceParent.Size) or ws.CurrentCamera.ViewportSize).Y) + instanceValue.Y.Offset
                --
                instance.Size = Vector2.new(xSize, ySize)
            elseif instanceProperty == "Position" or instanceProperty == "position" then
                    local xPosition = ((((instanceParent and instanceParent.Position) or Vector2.new(0, 0)).X) + (instanceValue.X.Scale * ((typeof(instanceParent.Size) == "number" and instanceParent.TextBounds) or instanceParent.Size).X)) + instanceValue.X.Offset
                    local yPosition = ((((instanceParent and instanceParent.Position) or Vector2.new(0, 0)).Y) + (instanceValue.Y.Scale * ((typeof(instanceParent.Size) == "number" and instanceParent.TextBounds) or instanceParent.Size).Y)) + instanceValue.Y.Offset
                    --
                    instance.Position = Vector2.new(xPosition, yPosition)
            elseif instanceProperty == "Color" or instanceProperty == "color" then
                if typeof(instanceValue) == "string" then
                    instance.Color = shared.theme[instanceValue]
                    --
                    if instanceValue == "accent" then
                        shared.accents[#shared.accents + 1] = instance
                    else
                        if table.find(shared.accents, instance) then
                            fast_remove(shared.accents, instance)
                        end
                    end
                else
                    instance.Color = instanceValue
                end
            end
        end
    
        function utility:Connection(connectionType, connectionCallback)
            local connection = connectionType:Connect(connectionCallback)
            if shared.connections then
                shared.connections[#shared.connections + 1] = connection
            end
            --
            return connection
        end
    
        function utility:RemoveConnection(connection)
            if not shared then return end
            if not shared.connections then return end
            for index, con in pairs(shared.connections) do
                if con == connection then
                    con:Disconnect()
                    shared.connections[index] = nil
                end
            end
            --
            for index, con in pairs(shared.hidden_connections) do
                if con == connection then
                    con:Disconnect()
                    shared.hidden_connections[index] = nil
                end
            end
        end
    
        function utility:Lerp(instance, instanceTo, instanceTime)
            local currentTime = 0
            local currentIndex = {}
            local connection
            --
            for i,v in pairs(instanceTo) do
                currentIndex[i] = instance[i]
            end
            --
            local function lerp()
                for i,v in pairs(instanceTo) do
                    instance[i] = ((v - currentIndex[i]) * currentTime / instanceTime) + currentIndex[i]
                end
            end
            --
            connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function(delta)
                if currentTime < instanceTime then
                    currentTime = currentTime + delta
                    lerp()
                else
                    connection:Disconnect()
                end
            end))
        end
    
        function utility:Unload(removeitem)
            if shared then
                shared.is_unloading = true
            end

            task.wait(0.5)

            local success, err = pcall(function()
                if shared and shared.connections then
                    for i,v in pairs(shared.connections) do
                        if v and v.Disconnect then
                            pcall(function() v:Disconnect() end)
                        end
                    end
                end
                --
                if shared and shared.drawing_containers then
                    for i,v in pairs(shared.drawing_containers) do
                        for _,k in pairs(v) do
                            k:Remove()
                        end
                    end
                    --
                    table.clear(shared.drawing_containers)
                end
                --
                if shared then
                    shared.drawing_containers = nil
                    shared.connections = nil
                end
                --
                cas:UnbindAction("BlockAutoParryInputs")
                cas:UnbindAction("FreecamKeyboard")
                --
                if cheat_client and cheat_client.chat_logger_instance then
                    cheat_client.chat_logger_instance:Unload()
                    cheat_client.chat_logger_instance = nil
                end
                --
                if cheat_client and cheat_client.apply_streamer then
                    pcall(function()
                        cheat_client:apply_streamer(false)
                    end)
                end
                --
                if plr and plr.Character then
                    pcall(function()
                        if cheat_client and cheat_client.char_custom_restore then
                            cheat_client.char_custom_restore(plr.Character)
                        end
                    end)
                end
                --
                if shared and shared.library and shared.library.Unload then
                    pcall(function() shared.library:Unload() end)
                end
                --
                if shared and shared.SPRLS then
                    shared.SPRLS = nil
                end
                --
                if shared and shared.SPROC then
                    LPH_NO_VIRTUALIZE(function()
                        for v, data in pairs(shared.SPROC) do
                            if typeof(v) == "function" and data.Index and data.Function then
                                pcall(function()
                                    debug.setupvalue(v, data.Index, data.Function)
                                end)
                            end
                        end
                    end)()
                    shared.SPROC = nil
                end
                --
                if shared then
                    table.clear(shared)
                end
                utility = nil
                library = nil
                shared = nil
                --
                do
                    if plr.Character and plr.Backpack and plr.Backpack:FindFirstChild("HealerVision") then return end
                    for _,v in pairs(workspace.Live:GetChildren()) do
                        if v ~= plr.Character then
                            local z = v:FindFirstChildWhichIsA("Humanoid")
                            if z then
                                z.HealthDisplayType = Enum.HumanoidHealthDisplayType.DisplayWhenDamaged
                                if v:FindFirstChild("MonsterInfo") then
                                    z.NameDisplayDistance = 0
                                end
                                z.HealthDisplayDistance = 0
                                z.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                            end
                        end
                    end
                end
                --
                if original_names[plr] then
                    cheat_client:spoof_name(original_names[plr])
                    original_names[plr] = nil
                end
                --
                if original_days.hundred then
                    local stat_gui = plr.PlayerGui:FindFirstChild("StatGui")
                    if stat_gui then
                        local lives = stat_gui.Container.Health:FindFirstChild("Lives")
                        if lives then
                            local rollers = {}
                            for _, child in ipairs(lives:GetChildren()) do
                                if child.Name == "Roller" and child:FindFirstChild("Char") then
                                    table.insert(rollers, child)
                                end
                            end

                            if #rollers >= 4 then
                                local has_thousand = #rollers >= 6

                                local thousand, hundred, ten, one
                                if has_thousand then
                                    thousand = rollers[2]
                                    hundred = rollers[3]
                                    ten = rollers[4]
                                    one = rollers[5]
                                else
                                    hundred = rollers[2]
                                    ten = rollers[3]
                                    one = rollers[4]
                                end

                                if thousand and original_days.thousand and original_days.thousand.text then
                                    thousand.Char.Text = original_days.thousand.text
                                end
                                if hundred and original_days.hundred.text then
                                    hundred.Char.Text = original_days.hundred.text
                                end
                                if ten and original_days.ten.text then
                                    ten.Char.Text = original_days.ten.text
                                end
                                if one and original_days.one.text then
                                    one.Char.Text = original_days.one.text
                                end

                                -- Disconnect connections
                                if original_days.thousand and original_days.thousand.connection then original_days.thousand.connection:Disconnect() end
                                if original_days.hundred.connection then original_days.hundred.connection:Disconnect() end
                                if original_days.ten.connection then original_days.ten.connection:Disconnect() end
                                if original_days.one.connection then original_days.one.connection:Disconnect() end
                            end
                        end
                    end
                    original_days = {}
                end
                --
                if plr.PlayerGui and plr.PlayerGui:FindFirstChild("LeaderboardGui") then
                    local scrollingFrame = plr.PlayerGui["LeaderboardGui"].MainFrame.ScrollingFrame
                    for _, frame in pairs(scrollingFrame:GetChildren()) do
                        if frame and frame.Text == "Ragoozer" then
                            frame.Text = plr.Name
                            frame.TextTransparency = 0
                            
                            for _, connection in pairs(getconnections(frame.MouseEnter)) do
                                if not connection.Enabled then
                                    connection:Enable()
                                end
                            end
                            
                            for _, connection in pairs(getconnections(frame.MouseLeave)) do
                                if not connection.Enabled then
                                    connection:Enable()
                                end
                            end
                        else
                            for _, connection in pairs(getconnections(frame.MouseEnter)) do
                                connection:Enable()
                            end
                
                            for _, connection in pairs(getconnections(frame.MouseLeave)) do
                                connection:Enable()
                            end
                        end
                    end
                end
                --
                task.defer(function()
                    pcall(function()
                        local playerGui = plr:FindFirstChild("PlayerGui")
                        if not playerGui then return end

                        local leaderboardGui = playerGui:FindFirstChild("LeaderboardGui")
                        if not leaderboardGui then return end

                        local mainFrame = leaderboardGui:FindFirstChild("MainFrame")
                        if not mainFrame then return end

                        local scrollingFrame = mainFrame:FindFirstChild("ScrollingFrame")
                        if not scrollingFrame then return end

                        for _, v in pairs(scrollingFrame:GetDescendants()) do
                            if v:IsA("TextButton") and v.Name == "SPB" then
                                v:Destroy()
                            end
                        end
                    end)
                end)
                --
                if plr.PlayerGui and playerLabels then
                    local leaderboardGui = plr.PlayerGui:FindFirstChild("LeaderboardGui")
                    if leaderboardGui and leaderboardGui:FindFirstChild("MainFrame") then
                        local scrollingFrame = leaderboardGui.MainFrame.ScrollingFrame
                        for _, v in pairs(scrollingFrame:GetChildren()) do
                            if v:IsA("TextLabel") then
                                local player = playerLabels[v]
                                if player then
                                    local hasMaxEdict = player:GetAttribute("MaxEdict") == true
                                    local hasLeaderstat = is_khei and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("MaxEdict") and player.leaderstats.MaxEdict.Value == true

                                    v.TextColor3 = (hasMaxEdict or hasLeaderstat) and Color3.fromRGB(255, 214, 81) or Color3.new(1, 1, 1)
                                end
                            end
                        end
                        table.clear(playerLabels)
                        playerLabels = nil
                    end
                end
                --
                if game.PlaceId == 5208655184 then
                    container = ws:FindFirstChild("Map")
                elseif game.PlaceId == 3541987450 then
                    container = ws
                end
                --
                if game.PlaceId == 5208655184 or game.PlaceId == 14341521240 then
                    txt.ChatWindowConfiguration.Enabled = false
                end
                --
                if container and cheat_client then
                    for _, v in next, container:GetDescendants() do
                        if v:IsA("BasePart") and v:FindFirstChild("TouchInterest") then
                            local is_safe_name = cheat_client.safe_bricks and cheat_client.safe_bricks[v.Name]
                            local is_safe_color = cheat_client.must_touch and cheat_client.must_touch[v.BrickColor.Number]
                            if not is_safe_name and not is_safe_color then
                                v.CanTouch = true
                            end
                        end
                    end
                end
                --
                do
                    local monsters = workspace:FindFirstChild("MonstersSpawns") or workspace:FindFirstChild("MonsterSpawns")
                    if monsters and monsters:FindFirstChild("Triggers") then
                        for _, obj in ipairs(monsters.Triggers:GetDescendants()) do
                            if obj and obj.ClassName == "Part" then
                                pcall(function()
                                    obj.CanTouch = true
                                end)
                            end
                        end
                    end
                end
                --
                for _, v in pairs(plrs:GetPlayers()) do
                    local char = v.Character
                    local backpack = v:FindFirstChild("Backpack")

                    local jack_char = char and char:FindFirstChild("Jack")
                    local jack_bag = backpack and backpack:FindFirstChild("Jack")

                    if (jack_char and jack_char:IsA("Tool")) or (jack_bag and jack_bag:IsA("Tool")) then
                        v:SetAttribute("Hidden", true)

                        -- Khei:
                        if game.PlaceId == 3541987450 then
                            local leaderstats = v:FindFirstChild("leaderstats")
                            if leaderstats then
                                local hidden = leaderstats:FindFirstChild("Hidden")
                                if hidden and hidden:IsA("BoolValue") then
                                    hidden.Value = true
                                end
                            end
                        end
                    end
                end
                --
                if game.PlaceId ~= 14341521240 then
                    plr.CameraMaxZoomDistance = 50
                    plr.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
                end
                --
                if old_remote then
                    hookfunction(Instance.new("RemoteEvent").FireServer, old_remote)
                end
                --
                if old_hastag then
                    hookfunction(cs.HasTag, old_hastag)
                end
                --
                if old_destroy then
                    hookfunction(ws.Destroy, old_destroy)
                end
                --
                if plr.Character then
                    ws.CurrentCamera.CameraSubject = plr.Character
                    ws.CurrentCamera.CameraType = Enum.CameraType.Custom
                    active_observe = nil
                else
                    if plr.PlayerGui and plr.PlayerGui:FindFirstChild("LeaderboardGui") then
                        plr.PlayerGui:FindFirstChild("LeaderboardGui").Enabled = false
                    end
                    ws.CurrentCamera.CameraSubject = nil
                    ws.CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    active_observe = nil
                end
                --
                auto_craft_active = nil
                auto_pot_active = nil
                dialogue_remote = nil
                mana_remote = nil
                done = nil
                busy = nil
                --
                if plr.PlayerGui:FindFirstChild("BardGui") then
                    plr.PlayerGui:FindFirstChild("BardGui").Enabled = true
                end
                --
                pcall(function()
                    local blindness = lit:FindFirstChild("Blindness")
                    if blindness then blindness.Enabled = true end

                    local blur = lit:FindFirstChild("Blur")
                    if blur then blur.Enabled = true end

                    local areacolor = lit:FindFirstChild("areacolor")
                    if areacolor then areacolor.Enabled = true end
                end)
                --
                pcall(function()
                    if cheat_client.restore_ambience then
                        cheat_client:restore_ambience();
                    end
                    
                    if cheat_client.restore_state then
                        cheat_client:restore_state();
                    end
                    
                    if cheat_client.legit_intent_cleanup then
                        cheat_client.legit_intent_cleanup();
                    end
                    
                    if cheat_client.proximity_cleanup then
                        cheat_client.proximity_cleanup();
                    end
                    
                    watched_guis = nil
                end)
                --
                for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
                    task.defer(function()
                        if v:FindFirstChild("Toggle") and v:FindFirstChild('SaveInstance') then
                            v.Enabled = false
                        end
                        if v.Name == "Dex" then
                            v:Destroy();
                        end
                    end)
                end
                --
                pcall(function()
                    if hidden_folder and hidden_folder.Parent then
                        hidden_folder:Destroy()
                    end

                    for _,v in pairs(workspace.Thrown:GetChildren()) do
                        if v.Name == "2holla" then
                            v:Destroy()
                        end
                    end
                end)
                --
                if cpu and cpu.status.active then
                    setfpscap(999)
                    cpu.services.ugs.MasterVolume = cpu.services.ms
                    settings().Rendering.QualityLevel = cpu.services.ql
                    cpu.services.rs:Set3dRenderingEnabled(true)

                    table.clear(cpu)
                    cpu = nil
                end
            end)

            if not success then
                warn("[HXSOL] Unload error:", err)
            end

            pcall(function()
                getgenv()[key] = nil
                gcinfo()
            end)

            pcall(function()
                mem:RemoveItem("dayfarming")
                mem:RemoveItem("dayfarming_range")
                mem:RemoveItem("day_goal_kick")
                mem:RemoveItem("no_kick")
                mem:RemoveItem("daygoal")

                if not removeitem then
                    mem:RemoveItem("botstarted")
                end
            end)

            pcall(function()
                if original_materials then
                    for v, data in pairs(original_materials) do
                        if v and v.Parent then
                            v.Material = data.Material
                            v.Reflectance = data.Reflectance
                        end
                    end
                    table.clear(original_materials)
                    original_materials = nil
                end
            end)

            pcall(function()
                if cheat_client then
                    table.clear(cheat_client)
                    cheat_client = nil
                end
            end)
        end
    
        function utility:ChangeAccent(accentColor)
            shared.theme.accent = accentColor
            --
            for index, drawing in pairs(shared.accents) do
                drawing.Color = shared.theme.accent
            end
        end
    
        function utility:Object(type, properties, container)
            local object = Instance.new(type)
            
            for i, v in next, properties do
                object[i] = v
            end
            
            if container then
                if not shared.drawing_containers[container] then
                    shared.drawing_containers[container] = {}
                end
                
                shared.drawing_containers[container][#shared.drawing_containers[container] + 1] = object
            end
            
            return object
        end
    
        function utility:GetCamera()
            return ws.CurrentCamera
        end
        
        function utility:LeftClick()
            local args = {
                math.random(1, 10),                    -- first param: random int
                tonumber("0." .. math.random(1e15, 9e15)) -- second param: decimal number
            }

            local remote = plr.Character 
                and plr.Character:FindFirstChild("CharacterHandler") 
                and plr.Character.CharacterHandler.Remotes.LeftClick

            if remote then
                pcall(function()
                    remote:FireServer(args)
                end)
            end
        end

        function utility:RightClick()
            local args = {
            	[1] = math.random(1, 10),
            	[2] = math.random()
            }
            local remote = plr.Character and plr.Character:FindFirstChild("CharacterHandler") and plr.Character.CharacterHandler.Remotes.RightClick
            if remote then
                remote:FireServer(args)
            end
        end

        function utility:getPlayerDays()
            if not plr.Character then return end
            for i, v in next, getconnections(rps.Requests.DaysSurvivedChanged.OnClientEvent) do
                return getupvalue(v.Function, 2)
            end
        end

        do -- Mana stuff
            local pingValue = game:GetService('Stats'):WaitForChild('PerformanceStats'):WaitForChild('Ping')
            local smoothed_ping = 0

            task.spawn(function()
                while shared and not shared.is_unloading do
                    local raw_ping = pingValue and pingValue:GetValue() or 0
                    smoothed_ping = (smoothed_ping * 0.8) + (raw_ping * 0.2)
                    task.wait(0.1)
                end
            end)

            local function adjusted_wait(base_time, multiplier)
                multiplier = multiplier or 1.0
                task.wait(base_time + (smoothed_ping / 1000) * multiplier)
            end

            local function can_use_mana()
                local character = plr.Character
                if not character then return end

                if character:FindFirstChild('Grabbed') then return end
                if character:FindFirstChild('Climbing') then return end
                if character:FindFirstChild('ClimbCoolDown') then return end

                if character:FindFirstChild('ManaStop') then return end
                if character:FindFirstChild('SpellBlocking') then return end
                if character:FindFirstChild('ActiveCast') then return end
                if character:FindFirstChild('Stun') then return end

                if cs:HasTag(character, 'Knocked') then return end
                if cs:HasTag(character, 'Unconscious') then return end

                return true
            end

            function utility:charge_mana()
                if not mana_remote or not self then return end

                if is_gaia then
                    mana_remote:FireServer({ math.random(1, 10), math.random() })
                else
                    mana_remote:FireServer(true)
                end
            end

            function utility:decharge_mana()
                if not mana_remote or not self then return end

                if is_gaia then
                    mana_remote:FireServer()
                else
                    mana_remote:FireServer(false)
                end
            end

            function utility:charge_mana_until(amount)
                local character = plr.Character
                if not character or character:FindFirstChildWhichIsA('ForceField') or not can_use_mana() then
                    return warn('mana unavailable', can_use_mana())
                end

                local mana = character:FindFirstChild('Mana')
                if not mana then return end

                if character:FindFirstChild('Charge') then
                    utility:decharge_mana()
                    -- Skip delay for snap training
                    if not Toggles.SnapTrain or not Toggles.SnapTrain.Value then
                        adjusted_wait(0.2, 1.0)
                    end
                end

                -- fail-fast loop: dies instantly if utility == nil
                while utility and shared and not shared.is_unloading and mana.Value < math.clamp(amount, 0, 98) do
                    utility:charge_mana()
                    -- Faster iteration for snap training
                    if Toggles.SnapTrain and Toggles.SnapTrain.Value then
                        adjusted_wait(0.03, 0.5)
                    else
                        adjusted_wait(0.1, 1.2)
                    end
                end

                if utility and character:FindFirstChild('Charge') then
                    utility:decharge_mana()
                    -- Skip delay for snap training to eliminate hovering
                    if not Toggles.SnapTrain or not Toggles.SnapTrain.Value then
                        adjusted_wait(0.3, 1.0)
                    end
                end
            end
        end

        function utility:random_wait(usePing)
            --[[ 
                print(utility:random_wait())        -- random humanized delay
                print(utility:random_wait(true))    -- ping-based delay 
            --]]

            local function getPing()
                local success, ping = pcall(function()
                    return game:GetService('Stats'):WaitForChild('PerformanceStats'):WaitForChild('Ping'):GetValue()
                end)
                return success and ping or 0
            end

            if usePing and utility then
                local ping = getPing()
                local delay = 0.025 + (ping / 1000)
                if delay > 0.35 then delay = 0.35 end
                return delay
            else
                local base = math.random(25, 350) / 1000
                local jitter = math.random() * 0.05

                if math.random() < 0.2 then
                    base = base + math.random() * 0.1
                end

                local delay = base + jitter
                if delay < 0.025 then delay = 0.025 end
                if delay > 0.35 then delay = 0.35 end
                return delay
            end
        end

    
        function utility:ForceRejoin()
            if join_server then
                join_server:FireServer(game.JobId)
            else
                library:Notify("Server hop not supported in this game", 3)
            end
            --tps:Teleport(3016661674)
        end

        function utility:UnblockAll()
            local RAMAccount = loadstring(game:HttpGet'https://raw.githubusercontent.com/ic3w0lf22/Roblox-Account-Manager/master/RAMAccount.lua')()
            local MyAccount = RAMAccount.new(plr.Name)

            if MyAccount then
                local success, response = pcall(function()
                    return request({ -- syn.request
                        Url = "http://localhost:7963//UnblockEveryone?Account="..plr.Name,
                        Method = "GET"
                    })
                end)

                if not success then
                    warn("[!] Failed to unblock all: Connection to localhost cancelled or unavailable")
                end
            end
        end

        do -- server finder
            local ROBLOX_GAMES_API = "https://games.roblox.com/v1/games/%s/servers/0"
            local httpService = game:GetService("HttpService")
            local SERVER_HISTORY_KEY = "RecentServers_" .. game.PlaceId
            local MAX_HISTORY_SIZE = 15

            local function get_server_history()
                local success, stored = pcall(function()
                    return mem:GetItem(SERVER_HISTORY_KEY)
                end)

                if success and stored then
                    local decode_success, history = pcall(function()
                        return httpService:JSONDecode(stored)
                    end)
                    if decode_success and type(history) == "table" then
                        return history
                    end
                end

                return {}
            end

            function utility:add_server_to_history(jobId)
                local history = get_server_history()

                table.insert(history, 1, jobId)

                while #history > MAX_HISTORY_SIZE do
                    table.remove(history)
                end

                pcall(function()
                    mem:SetItem(SERVER_HISTORY_KEY, httpService:JSONEncode(history))
                end)
            end

            function utility:clear_server_history()
                pcall(function()
                    mem:SetItem(SERVER_HISTORY_KEY, httpService:JSONEncode({}))
                end)
            end

            local function is_server_recent(jobId, history)
                for _, recentJobId in ipairs(history) do
                    if recentJobId == jobId then
                        return true
                    end
                end
                return false
            end

            function utility:get_largest_server()
                local placeId = game.PlaceId
                local currentJobId = game.JobId
                local url = string.format(ROBLOX_GAMES_API .. "?sortOrder=2&excludeFullGames=true&limit=25", placeId)
                local history = get_server_history()

                local success, result = pcall(function()
                    local response = request({
                        Url = url,
                        Method = "GET",
                        Headers = {
                            ["Accept"] = "application/json"
                        }
                    })

                    if not (response and response.Success and response.StatusCode == 200) then
                        return nil
                    end

                    local data = httpService:JSONDecode(response.Body)
                    if data and data.data then
                        for _, server in ipairs(data.data) do
                            if server.id and server.id ~= currentJobId and not is_server_recent(server.id, history) then
                                return server.id
                            end
                        end
                    end

                    return nil
                end)

                if success and result then
                    return result
                end

                return nil
            end

            function utility:get_smallest_server()
                local placeId = game.PlaceId
                local currentJobId = game.JobId
                local url = string.format(ROBLOX_GAMES_API .. "?sortOrder=1&excludeFullGames=false&limit=10", placeId)
                local history = get_server_history()

                local success, result = pcall(function()
                    local response = request({
                        Url = url,
                        Method = "GET",
                        Headers = {
                            ["Accept"] = "application/json"
                        }
                    })

                    if not (response and response.Success and response.StatusCode == 200) then
                        return nil
                    end

                    local data = httpService:JSONDecode(response.Body)
                    if data and data.data then
                        for _, server in ipairs(data.data) do
                            if server.id and server.id ~= currentJobId and not is_server_recent(server.id, history) then
                                return server.id
                            end
                        end
                    end

                    return nil
                end)

                if success and result then
                    return result
                end

                return nil
            end

            function utility:get_oldest_server()
                local currentJobId = game.JobId
                local history = get_server_history()
                local serverInfo = rps:FindFirstChild("ServerInfo")
                local httpService = game:GetService("HttpService")

                if not serverInfo then
                    warn("[!] ServerInfo not found")
                    return nil
                end

                local oldestServer = nil
                local maxLifespan = -1

                for _, serverFolder in ipairs(serverInfo:GetChildren()) do
                    local jobId = serverFolder.Name
                    local lifespanValue = serverFolder:FindFirstChild("Lifespan")
                    local playersValue = serverFolder:FindFirstChild("Players")

                    if lifespanValue and lifespanValue:IsA("IntValue") and jobId ~= currentJobId and not is_server_recent(jobId, history) then
                        -- Check if server is full (max 23 players)
                        local playerCount = 0
                        if playersValue and playersValue:IsA("StringValue") then
                            local success, playerData = pcall(function()
                                return httpService:JSONDecode(playersValue.Value)
                            end)
                            if success and playerData and type(playerData) == "table" then
                                playerCount = #playerData
                            end
                        end

                        -- Skip full servers
                        if playerCount < 23 then
                            local lifespan = lifespanValue.Value
                            if lifespan > maxLifespan then
                                maxLifespan = lifespan
                                oldestServer = jobId
                            end
                        end
                    end
                end

                return oldestServer
            end

            function utility:get_newest_server()
                local currentJobId = game.JobId
                local history = get_server_history()
                local serverInfo = rps:FindFirstChild("ServerInfo")
                local httpService = game:GetService("HttpService")

                if not serverInfo then
                    warn("[!] ServerInfo not found")
                    return nil
                end

                local newestServer = nil
                local minLifespan = math.huge

                for _, serverFolder in ipairs(serverInfo:GetChildren()) do
                    local jobId = serverFolder.Name
                    local lifespanValue = serverFolder:FindFirstChild("Lifespan")
                    local playersValue = serverFolder:FindFirstChild("Players")

                    if lifespanValue and lifespanValue:IsA("IntValue") and jobId ~= currentJobId and not is_server_recent(jobId, history) then
                        -- Check if server is full (max 23 players)
                        local playerCount = 0
                        if playersValue and playersValue:IsA("StringValue") then
                            local success, playerData = pcall(function()
                                return httpService:JSONDecode(playersValue.Value)
                            end)
                            if success and playerData and type(playerData) == "table" then
                                playerCount = #playerData
                            end
                        end

                        -- Skip full servers
                        if playerCount < 23 then
                            local lifespan = lifespanValue.Value
                            if lifespan < minLifespan then
                                minLifespan = lifespan
                                newestServer = jobId
                            end
                        end
                    end
                end

                return newestServer
            end
        end

        function utility:Serverhop()
            local httpService = game:GetService("HttpService")
            local bot_started = mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true"
            if bot_started then
                local current_count = 0
                if mem:HasItem("serverhop_count") then
                    current_count = tonumber(mem:GetItem("serverhop_count")) or 0
                end
                mem:SetItem("serverhop_count", tostring(current_count + 1))
            end

            local RAMAccount = loadstring(game:HttpGet'https://raw.githubusercontent.com/ic3w0lf22/Roblox-Account-Manager/master/RAMAccount.lua')()
            local MyAccount = RAMAccount.new(plr.Name)

            local function attemptTeleport(jobId, maxRetries)
                maxRetries = maxRetries or 3
                local retries = 0

                while retries < maxRetries do
                    teleport_failed = false
                    teleport_fail_reason = ""

                    join_server:FireServer(jobId)

                    -- Wait longer for slow networks/teleport to complete
                    local timeout = tick() + 20
                    while tick() < timeout and not teleport_failed do
                        task.wait(0.1)
                    end

                    if not teleport_failed then
                        -- Don't unload - let Roblox complete the teleport naturally
                        -- The teleport will happen and script will end when player leaves
                        print("[TELEPORT] Teleport appears successful, waiting for transition...")
                        task.wait(5)  -- Give extra time for teleport to complete
                        return true
                    else
                        -- Teleport failed (server full, kicked, etc.)
                        retries = retries + 1
                        if retries < maxRetries then
                            warn(string.format("[RETRY %d/%d] Teleport failed: %s - Trying another server...", retries, maxRetries, teleport_fail_reason))
                            return false  -- Signal to get a new server
                        else
                            warn(string.format("[MAX RETRIES] Failed to teleport after %d attempts", maxRetries))
                            return false
                        end
                    end
                end

                return false
            end

            local function unblockAll()
            	if MyAccount then
            		local success, response = pcall(function()
            			return request({ -- syn.request
            				Url = "http://localhost:7963//UnblockEveryone?Account="..plr.Name,
            				Method = "GET"
            			})
            		end)

            		if not success then
            			warn("[!] Failed to unblock all: Connection to localhost cancelled or unavailable")
            		end
            	end
            end

            local function blockPlayer(Player)
            	if MyAccount then
            		local success, response = pcall(function()
            			return request({
            				Url = "http://localhost:7963/BlockUser?Account="..plr.Name.."&UserId="..tostring(plrs:GetUserIdFromNameAsync(Player.Name)),
            				Method = "GET"
            			})
            		end)

            		if not success then
            			warn("[!] Failed to block player: Connection to localhost cancelled or unavailable")
            			return
            		end

                    if response and tostring(response.Body) == [[{"success":true}]] then
                    elseif response and tostring(response.Body) == [[{"success":false}]] then
                        unblockAll()
                    end
            	end
            end

            local function joinServerWithMinPlayers(min_players)
                local placeId = game.PlaceId
                local ROBLOX_GAMES_API = "https://games.roblox.com/v1/games/%s/servers/0"
                local url = string.format(ROBLOX_GAMES_API .. "?sortOrder=2&excludeFullGames=false&limit=100", placeId)

                local success, response = pcall(function()
                    return request({
                        Url = url,
                        Method = "GET",
                        Headers = {
                            ["Accept"] = "application/json"
                        }
                    })
                end)

                if not success or not response or not response.Success or response.StatusCode ~= 200 then
                    return nil
                end

                local decode_success, data = pcall(function()
                    return httpService:JSONDecode(response.Body)
                end)

                if not decode_success or not data or not data.data then
                    return nil
                end

                -- Get server history
                local SERVER_HISTORY_KEY = "RecentServers_" .. game.PlaceId
                local history = {}
                pcall(function()
                    local stored = mem:GetItem(SERVER_HISTORY_KEY)
                    if stored then
                        local decoded = httpService:JSONDecode(stored)
                        if type(decoded) == "table" then
                            history = decoded
                        end
                    end
                end)

                local valid_servers = {}
                for _, server in ipairs(data.data) do
                    local jobId = server.id
                    local playerCount = server.playing or 0
                    local maxPlayers = server.maxPlayers or 0

                    local is_recent = false
                    for _, recentJobId in ipairs(history) do
                        if recentJobId == jobId then
                            is_recent = true
                            break
                        end
                    end

                    if jobId ~= game.JobId and not is_recent and playerCount >= min_players and playerCount < maxPlayers then
                        table.insert(valid_servers, jobId)
                    end
                end

                if #valid_servers > 0 then
                    -- Try up to 3 different servers from the valid list
                    local max_server_attempts = math.min(3, #valid_servers)
                    for attempt = 1, max_server_attempts do
                        local randomJobId = valid_servers[math.random(1, #valid_servers)]
                        print(string.format("[API JOIN] Attempting server %d/%d: %s", attempt, max_server_attempts, randomJobId))

                        if attemptTeleport(randomJobId, 1) then
                            return true
                        end

                        -- Remove failed server from list
                        for i, jobId in ipairs(valid_servers) do
                            if jobId == randomJobId then
                                table.remove(valid_servers, i)
                                break
                            end
                        end
                    end

                    warn("[API JOIN] All server attempts failed")
                    return nil
                else
                    return nil
                end
            end

            local function joinRandomServer(blockTarget)
                local min_player_count = 0
                if mem:HasItem("botstarted") then
                    if mem:HasItem("trinket_bot_settings") then
                        local success, settings = pcall(function()
                            return httpService:JSONDecode(mem:GetItem("trinket_bot_settings"))
                        end)
                        if success and settings then
                            min_player_count = settings.min_player_count or 0
                        end
                    end
                end

                if min_player_count > 0 then
                    local api_success = joinServerWithMinPlayers(min_player_count)
                    if api_success then
                        return
                    end
                end

                local serverInfo = rps:FindFirstChild("ServerInfo")
                if serverInfo then
                    local servers = serverInfo:GetChildren()
                    if #servers > 0 then
                        local SERVER_HISTORY_KEY = "RecentServers_" .. game.PlaceId
                        local history = {}
                        pcall(function()
                            local stored = mem:GetItem(SERVER_HISTORY_KEY)
                            if stored then
                                local decoded = httpService:JSONDecode(stored)
                                if type(decoded) == "table" then
                                    history = decoded
                                end
                            end
                        end)

                        local available_servers = {}
                        for _, server in ipairs(servers) do
                            local jobId = server.Name
                            local is_recent = false

                            for _, recentJobId in ipairs(history) do
                                if recentJobId == jobId then
                                    is_recent = true
                                    break
                                end
                            end

                            if jobId ~= game.JobId and not is_recent then
                                if min_player_count > 0 then
                                    local playersValue = server:FindFirstChild("Players")
                                    if playersValue and playersValue:IsA("StringValue") then
                                        local success, playerData = pcall(function()
                                            return httpService:JSONDecode(playersValue.Value)
                                        end)
                                        if success and playerData and type(playerData) == "table" then
                                            local playerCount = #playerData
                                            if playerCount >= min_player_count and playerCount < 23 then
                                                table.insert(available_servers, server)
                                            end
                                        end
                                    end
                                else
                                    table.insert(available_servers, server)
                                end
                            end
                        end

                        if #available_servers > 0 then
                            if min_player_count > 0 then
                                print(string.format("Found %d servers with %d+ players. Joining one...", #available_servers, min_player_count))
                            end

                            -- Try multiple servers if first one fails
                            local max_attempts = math.min(3, #available_servers)
                            for attempt = 1, max_attempts do
                                local randomServer = available_servers[math.random(1, #available_servers)]
                                local jobId = randomServer.Name

                                if attemptTeleport(jobId, 1) then
                                    return
                                end

                                -- Remove failed server from list
                                for i, server in ipairs(available_servers) do
                                    if server.Name == jobId then
                                        table.remove(available_servers, i)
                                        break
                                    end
                                end
                            end

                            warn("[SERVERHOP] All available servers failed, falling through to fallback...")
                        else
                            if min_player_count > 0 then
                                print(string.format("WARNING: No servers found with %d+ players out of %d total servers. Clearing history...", min_player_count, #servers))
                            end
                            local fallback_servers = {}
                            for _, server in ipairs(servers) do
                                local jobId = server.Name
                                local is_recent = false
                                for _, recentJobId in ipairs(history) do
                                    if recentJobId == jobId then
                                        is_recent = true
                                        break
                                    end
                                end
                                if jobId ~= game.JobId and not is_recent then
                                    -- Apply min_player_count filter to fallback servers too
                                    if min_player_count > 0 then
                                        local playersValue = server:FindFirstChild("Players")
                                        if playersValue and playersValue:IsA("StringValue") then
                                            local success, playerData = pcall(function()
                                                return httpService:JSONDecode(playersValue.Value)
                                            end)
                                            if success and playerData and type(playerData) == "table" then
                                                local playerCount = #playerData
                                                if playerCount >= min_player_count and playerCount < 23 then
                                                    table.insert(fallback_servers, server)
                                                end
                                            end
                                        end
                                    else
                                        table.insert(fallback_servers, server)
                                    end
                                end
                            end

                            if #fallback_servers > 0 then
                                -- Try multiple fallback servers
                                local max_attempts = math.min(3, #fallback_servers)
                                for attempt = 1, max_attempts do
                                    local randomServer = fallback_servers[math.random(1, #fallback_servers)]
                                    local jobId = randomServer.Name

                                    if attemptTeleport(jobId, 1) then
                                        return
                                    end

                                    -- Remove failed server
                                    for i, server in ipairs(fallback_servers) do
                                        if server.Name == jobId then
                                            table.remove(fallback_servers, i)
                                            break
                                        end
                                    end
                                end

                                warn("[SERVERHOP] All fallback servers failed, trying any server...")
                            end

                            -- Final fallback: try any server
                            local max_final_attempts = math.min(3, #servers)
                            for attempt = 1, max_final_attempts do
                                local randomServer = servers[math.random(1, #servers)]
                                local jobId = randomServer.Name

                                if attemptTeleport(jobId, 1) then
                                    return
                                end
                            end

                            warn("[SERVERHOP] All server attempts exhausted")
                        end
                    else
                        warn("[!] No servers found in ServerInfo, using fallback")
                        if blockTarget then
                            blockPlayer(blockTarget)
                        end
                        tps:Teleport(3016661674)
                        task.wait(0.1)
                        utility:Unload(true)
                    end
                else
                    warn("[!] ServerInfo not found, using fallback teleport")
                    if blockTarget then
                        blockPlayer(blockTarget)
                    end
                    tps:Teleport(3016661674)
                    task.wait(0.1)
                    utility:Unload(true)
                end
            end

            -- Check if join oldest server is enabled
            local join_oldest = false
            if mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true" then
                if mem:HasItem("trinket_bot_settings") then
                    local success, settings = pcall(function()
                        return httpService:JSONDecode(mem:GetItem("trinket_bot_settings"))
                    end)
                    if success and settings then
                        join_oldest = settings.join_oldest_server or false
                    end
                end
            end

            if join_oldest then
                local oldest_server_id = utility:get_oldest_server()
                if oldest_server_id then
                    -- Add to history BEFORE attempting teleport to prevent loop
                    utility:add_server_to_history(oldest_server_id)
                    print(string.format("[JOIN OLDEST] Joining oldest server: %s", oldest_server_id))
                    if attemptTeleport(oldest_server_id, 1) then
                        return
                    else
                        warn("[JOIN OLDEST] Failed to join oldest server, using random")
                    end
                else
                    warn("[JOIN OLDEST] Failed to find oldest server, using random")
                end
            end

            if plrs:GetChildren()[2] then
                local blockTarget = game:GetService("Players"):GetChildren()[2]
                task.wait(0.05)
                joinRandomServer(blockTarget)
            else
                task.wait(0.05)
                joinRandomServer()
            end
        end

        function utility:IsHoveringFrame(frame)
            local mouse_location = uis:GetMouseLocation()
    
            local x1 = frame.AbsolutePosition.X
            local y1 = frame.AbsolutePosition.Y
            local x2 = x1 + frame.AbsoluteSize.X
            local y2 = y1 + frame.AbsoluteSize.Y
    
            return (mouse_location.X >= x1 and mouse_location.Y - 36 >= y1 and mouse_location.X <= x2 and mouse_location.Y - 36 <= y2)
        end
    
        function utility:Instance(class_name, properties)
            local object = Instance.new(class_name)
    
            for i,v in next, properties do
                object[i] = v
            end
    
            return object
        end
    end
    
    local repo = "https://raw.githubusercontent.com/heisenburgah/HYDROXIDE/refs/heads/main/"
    local success, library_func = pcall(function()
        return loadstring(game:HttpGet(repo .. "DEPENDENCIES/Library.lua"))()
    end)

    if success then
        library = library_func(shared, utility)
        shared.library = library

        getgenv().Toggles = library.Toggles or {}
        getgenv().Options = library.Options or {}
        getgenv().Labels = library.Labels or {}

        local SaveManager = loadstring(game:HttpGet(repo .. "DEPENDENCIES/SaveManager.lua"))()
        local ThemeManager = loadstring(game:HttpGet(repo .. "DEPENDENCIES/ThemeManager.lua"))()

        SaveManager:SetLibrary(library)
        ThemeManager:SetLibrary(library)
        SaveManager:IgnoreThemeSettings()

        shared.SaveManager = SaveManager
        shared.ThemeManager = ThemeManager
    else
        warn("Failed to load UI library: " .. tostring(library_func))
    end

    
    do
        local player_races = {}
        local race_colors = {}

        do
            if(rps:FindFirstChild('Info') and rps.Info:FindFirstChild('Races')) then
                for i, v in next, rps.Info.Races:GetChildren() do
                    race_colors[#race_colors + 1] = {tostring(v.EyeColor.Value), tostring(v.SkinColor.Value), v.Name}
                end
            end
        end

        function cheat_client:get_race(player)
            if(player_races[player] and tick() - player_races[player].lastUpdateAt <= 5) then
                return player_races[player].name;
            end

            local head = player.Character and player.Character:FindFirstChild('Head')
            local face = head and head:FindFirstChild('RLFace')
            local scroomHead = player.Character and player.Character:FindFirstChild('ScroomHead')

            local raceFound = 'Unknown'

            if(not face) then return raceFound end

            if(scroomHead) then
                if(scroomHead.Material.Name == 'DiamondPlate') then
                    raceFound = 'Metascroom'
                else
                    raceFound = 'Scroom'
                end
            end

            if(raceFound == 'Unknown') then
                for i2, v2 in next, race_colors do
                    local eyeColor, skinColor, raceName = v2[1], v2[2], v2[3];

                    if(tostring(head.Color) == skinColor and tostring(face.Color3) == eyeColor) then
                        raceFound = raceName
                    end
                end
            end


            player_races[player] = {
                lastUpdateAt = tick(),
                name = raceFound
            }

            return raceFound
        end

        do -- Name retrieval
            local function is_empty(s)
                return s == nil or s == ""
            end

            function cheat_client:get_name(player)
                if game.PlaceId == 5208655184 or game.PlaceId == 109732117428502 then
                    if not player:GetAttribute("FirstName") or player:GetAttribute("FirstName") == "" then
                        return "nil"
                    end

                    local firstName = player:GetAttribute('FirstName')
                    local lastName = player:GetAttribute("LastName")
                    local uberTitle = player:GetAttribute("UberTitle")

                    local fullName = firstName
                    if lastName and lastName ~= "" then
                        fullName = firstName .. " " .. lastName
                    end

                    if not is_empty(uberTitle) then
                        return fullName .. ", " .. uberTitle
                    else
                        return fullName
                    end
                elseif game.PlaceId == 3541987450 or game.PlaceId == 14341521240 then
                    local leaderstats = player:FindFirstChild("leaderstats")
                    if not leaderstats or not leaderstats:FindFirstChild("FirstName") then
                        return "nil"
                    end

                    local firstName = leaderstats.FirstName.Value
                    local lastName = leaderstats.LastName.Value
                    local uberTitle = leaderstats:FindFirstChild("UberTitle") and leaderstats.UberTitle.Value or ""

                    local fullName = firstName
                    if lastName and lastName ~= "" then
                        fullName = firstName .. " " .. lastName
                    end

                    if not is_empty(uberTitle) then
                        return fullName .. ", " .. uberTitle
                    else
                        return fullName
                    end
                else
                    return "nil"
                end
            end
        end
    
        cheat_client.is_friendly = LPH_NO_VIRTUALIZE(function(self, player)
            local ignore_friendly = Toggles and Toggles.ignore_friendly
            if ignore_friendly and ignore_friendly.Value then
                return false
            end

            local auto_housemate_ally = Toggles and Toggles.auto_housemate_ally and Toggles.auto_housemate_ally.Value or false
            local auto_friend_ally = Toggles and Toggles.auto_friend_ally and Toggles.auto_friend_ally.Value or false

            if game.PlaceId == 5208655184 then
                local lastName1 = player:GetAttribute("LastName")
                local lastName2 = plr:GetAttribute("LastName")

                local is_housemate = lastName1 and lastName1 ~= "" and lastName1 == lastName2
                local is_friend = plr:IsFriendsWith(player.UserId)
                local is_manual_friend = cheat_client and cheat_client.friends and table.find(cheat_client.friends, player.UserId) ~= nil

                return (auto_housemate_ally and is_housemate) or
                       (auto_friend_ally and is_friend) or
                       is_manual_friend

            elseif game.PlaceId == 3541987450 or game.PlaceId == 14341521240 then
                local stats1 = player:FindFirstChild("leaderstats")
                local stats2 = plr:FindFirstChild("leaderstats")

                if not stats1 or not stats2 then return false end

                local lastName1 = stats1:FindFirstChild("LastName")
                local lastName2 = stats2:FindFirstChild("LastName")

                local is_housemate = lastName1 and lastName2 and lastName1.Value == lastName2.Value
                local is_friend = plr:IsFriendsWith(player.UserId)
                local is_manual_friend = table.find(cheat_client.friends, player.UserId) ~= nil

                return (auto_housemate_ally and is_housemate) or
                       (auto_friend_ally and is_friend) or
                       is_manual_friend
            end

            local is_friend = plr:IsFriendsWith(player.UserId)
            local is_manual_friend = table.find(cheat_client.friends, player.UserId) ~= nil

            return (auto_friend_ally and is_friend) or is_manual_friend
        end)
        

        -- utility:sound("rbxassetid://1693890393",2)
        function utility:sound(Id, Removal)
            if cheat_client and shared and Toggles and Toggles.notifications and Toggles.notifications.Value then
                local volume = cheat_client.config.notification_volume or 5
                local Sound = utility:Instance("Sound", {
                    SoundId = Id,
                    Volume = volume,
                    Parent = cg
                })

                Sound:Play()
                deb:AddItem(Sound, Removal)
            end
        end
        
        do -- mod detection
            local valid_names = {}
            local lich_names = {}

            local function load_name_lists()
                local success, nameGenerator = pcall(function()
                    return rps.Info.NameGenerator
                end)

                if success and nameGenerator then
                    local name_modules = {"Azael", "Cameo", "Kasparan", "Feminine", "LesserNavaran", "Lich", "Masculine", "Navaran", "Scroom", "Vind"}

                    for _, module_name in ipairs(name_modules) do
                        local name_module = nameGenerator:FindFirstChild(module_name)
                        if name_module then
                            local ok, names = pcall(function()
                                return require(name_module)
                            end)

                            if ok and names then
                                if module_name == "Lich" then
                                    for _, name in ipairs(names) do
                                        lich_names[name] = true
                                        valid_names[name] = true
                                    end
                                else
                                    for _, name in ipairs(names) do
                                        valid_names[name] = true
                                    end
                                end
                            end
                        end
                    end
                end
            end

            task.spawn(load_name_lists)
            function cheat_client:detect_mod(player)
                if not player then return end

                local success, isInGroup, success2, isInGroup2

                if game.PlaceId == 14341521240 then
                    local success_mod, isInGroupMod = pcall(function()
                        return player:IsInGroup(15055389)
                    end)

                    if success_mod and isInGroupMod then
                        local player_rank = player:GetRoleInGroup(15055389)
                        if player_rank ~= "Guest" and (library ~= nil and library.Notify) then
                            utility:sound("rbxassetid://1693890393",4)
                            library:Notify({
                                Title = "🛑 MODERATOR DETECTED",
                                Description = player.Name.." is a Moderator",
                                Time = 25
                            })
                        end
                    end
                    return
                else
                    success, isInGroup = pcall(function()
                        return player:IsInGroup(4556484)
                    end)

                    success2, isInGroup2 = pcall(function()
                        return player:IsInGroup(281365)
                    end)
                end

                local has_spec_name = false
                local is_lich_mod = false
                local firstName = player:GetAttribute("FirstName")

                if firstName == nil or firstName == 'nil' then
                    task.spawn(function()
                        repeat
                            task.wait(0.1)
                            firstName = player:GetAttribute("FirstName")
                        until (firstName ~= nil and firstName ~= 'nil') or not player.Parent

                        if not player.Parent then return end

                        if firstName == "Faceless One" or firstName == "Fungless One" then
                            return
                        end

                        if firstName and firstName ~= "" then
                            if lich_names[firstName] then
                                is_lich_mod = true
                            elseif not valid_names[firstName] then
                                has_spec_name = true
                            end
                        end

                        if is_lich_mod then
                            if (library ~= nil and library.Notify) then
                                utility:sound("rbxassetid://1693890393",4)
                                library:Notify({
                                    Title = "🛑 MODERATOR DETECTED",
                                    Description = cheat_client:get_name(player).." ["..player.Name.."] has Lich name ["..firstName.."]",
                                    Time = 25
                                })
                            end
                        elseif has_spec_name then
                            if (library ~= nil and library.Notify) then
                                utility:sound("rbxassetid://2865227039",4)
                                library:Notify({
                                    Title = "⚠️ WARNING",
                                    Description = cheat_client:get_name(player).." ["..player.Name.."] has a special name '"..firstName.."'",
                                    Time = 25
                                })
                            end
                        end
                    end)
                    firstName = nil
                end

                if firstName == "Faceless One" or firstName == "Fungless One" then
                    return
                end

                if firstName and firstName ~= "" then
                    if lich_names[firstName] then
                        is_lich_mod = true
                    elseif not valid_names[firstName] then
                        has_spec_name = true
                    end
                end

                if success and isInGroup then
                    local player_rank = player:GetRoleInGroup(4556484)
                    if player_rank ~= "Guest" and (library ~= nil and library.Notify) then
                        utility:sound("rbxassetid://1693890393",4)
                        library:Notify({
                            Title = "🛑 MODERATOR DETECTED",
                            Description = cheat_client:get_name(player).." ["..player.Name.."] is in Rogue Lineage group, [ "..player_rank.." ]",
                            Time = 25
                        })
                    end
                elseif is_lich_mod then
                    if (library ~= nil and library.Notify) then
                        utility:sound("rbxassetid://1693890393",4)
                        library:Notify({
                            Title = "🛑 MODERATOR DETECTED",
                            Description = cheat_client:get_name(player).." ["..player.Name.."] has Lich name ["..firstName.."]",
                            Time = 25
                        })
                    end
                elseif success2 and isInGroup2 then
                    local player_rank = player:GetRoleInGroup(281365)
                    if player_rank ~= "Guest" and (library ~= nil and library.Notify) then
                        utility:sound("rbxassetid://2865227039",4)
                        library:Notify({
                            Title = "🛑 POSSIBLE MODERATOR",
                            Description = cheat_client:get_name(player).." ["..player.Name.."] is in SPEC group (281365), [ "..player_rank.." ]",
                            Time = 25
                        })
                    end
                elseif has_spec_name then
                    if (library ~= nil and library.Notify) then
                        utility:sound("rbxassetid://2865227039",4)
                        library:Notify({
                            Title = "⚠️ WARNING",
                            Description = cheat_client:get_name(player).." ["..player.Name.."] has a special name '"..firstName.."'",
                            Time = 25
                        })
                    end
                elseif cheat_client and cheat_client.mod_list and table.find(cheat_client.mod_list, player.UserId) then
                    if (library ~= nil and library.Notify) then
                        utility:sound("rbxassetid://1693890393",4)
                        library:Notify({
                            Title = "🛑 MODERATOR DETECTED",
                            Description = cheat_client:get_name(player).." ["..player.Name.."] is a Moderator",
                            Time = 25
                        })
                    end
                else
                    if not success then
                        warn("IsInGroup failed for player: "..player.Name.." | Error: "..tostring(isInGroup))
                    end
                    if not success2 then
                        warn("IsInGroup (281365) failed for player: "..player.Name.." | Error: "..tostring(isInGroup2))
                    end
                end
            end

            function cheat_client:detect_specs(player)
                if not player or player == plr then return end

                local backpack = player:FindFirstChild("Backpack")
                if not backpack then return end

                local has_verdien = backpack:FindFirstChild("Verdien")
                local has_life_sense = backpack:FindFirstChild("Life Sense")
                local has_floresco = backpack:FindFirstChild("Floresco")

                if has_verdien and not has_life_sense and not has_floresco then
                    if (library ~= nil and library.Notify) then
                        utility:sound("rbxassetid://2865227039",4)
                        library:Notify({
                            Title = "⚠️ FAGGOT DETECTED WARNING",
                            Description = cheat_client:get_name(player).." ["..player.Name.."] has Verdien but is not a druid",
                            Time = 25
                        })
                    end
                    return
                end

                local has_flower_god = backpack:FindFirstChild("Flying Flower God")
                local has_mushroom_god = backpack:FindFirstChild("Flying Mushroom God")

                if has_flower_god or has_mushroom_god then
                    if (library ~= nil and library.Notify) then
                        utility:sound("rbxassetid://2865227039",4)
                        library:Notify({
                            Title = "⚠️ FAGGOT DETECTED WARNING",
                            Description = cheat_client:get_name(player).." ["..player.Name.."] can teleport to you with "..(has_flower_god and "Flying Flower God" or "Flying Mushroom God"),
                            Time = 25
                        })
                    end
                end

                local found_spec_skills = {}
                for _, skill_name in ipairs(cheat_client.spec_skills) do
                    if skill_name ~= "Flying Flower God" and skill_name ~= "Flying Mushroom God" then
                        if backpack:FindFirstChild(skill_name) then
                            table.insert(found_spec_skills, skill_name)
                        end
                    end
                end

                if #found_spec_skills > 0 then
                    local skills_list = table.concat(found_spec_skills, ", ")
                    if (library ~= nil and library.Notify) then
                        utility:sound("rbxassetid://2865227039",4)
                        library:Notify({
                            Title = "⚠️ FAGGOT DETECTED WARNING",
                            Description = cheat_client:get_name(player).." ["..player.Name.."] has spec skills: "..skills_list,
                            Time = 25
                        })
                    end
                end
            end
        end

        do -- reset
            function utility:reset()
                local Character = plr.Character
                
                if (Character == nil) then
                    return
                end
            
                local Head = Character:FindFirstChild("Head")
            
                if (Head == nil) then
                    return
                end
            
                Head:Destroy()
            end
        end

        do -- game presence
            local ROBLOX_PRESENCE_API = "https://presence.roblox.com/v1/presence/users"
            local httpService = game:GetService("HttpService")
            local presenceCache = {}
            local CACHE_DURATION = 30 -- seconds
            
            function utility:get_presence(userId)
                local currentTime = tick()
                local cachedData = presenceCache[userId]
                
                if cachedData and (currentTime - cachedData.timestamp) < CACHE_DURATION then
                    return cachedData.joinable, cachedData.gameId
                end
                
                local success, joinable, gameId = pcall(function()
                    local response = request({
                        Url = ROBLOX_PRESENCE_API,
                        Method = "POST",
                        Headers = ROBLOX_API_HEADERS,
                        Body = '{"userIds":[' .. userId .. ']}'
                    })
            
                    if not (response and response.Success and response.StatusCode == 200) then
                        return false, nil
                    end
                    
                    local data = httpService:JSONDecode(response.Body)
                    local userPresence = data.userPresences and data.userPresences[1]
                    
                    if not userPresence then
                        return false, nil
                    end
                    
                    local presenceType = userPresence.userPresenceType or 0
                    local isJoinable = (presenceType == 2 and userPresence.placeId ~= nil)
                    
                    return isJoinable, userPresence.gameId
                end)
                
                if not success then
                    joinable, gameId = false, nil
                end
                
                presenceCache[userId] = {
                    joinable = joinable,
                    gameId = gameId,
                    timestamp = currentTime
                }
                
                return joinable, gameId
            end
        end

        function get_server_info()
            local server_name = ""
            local server_region = ""
            
            if plr.PlayerGui and plr.PlayerGui:FindFirstChild("ServerStatsGui") and plr.PlayerGui.ServerStatsGui:FindFirstChild("Frame") then
                local server_stats = plr.PlayerGui.ServerStatsGui.Frame.Stats
                if server_stats then
                    if server_stats:FindFirstChild("ServerName") then
                        local full_text = server_stats.ServerName.Text
                        server_name = full_text:match("Server Name: (.+)") or ""
                    end
                    
                    if server_stats:FindFirstChild("ServerRegion") then
                        local full_text = server_stats.ServerRegion.Text
                        server_region = full_text:match("Server Region: (.+)") or ""
                    end
                end
            end
            
            return server_name, server_region
        end

        do -- webhook
            local HttpService = game:GetService("HttpService")
            local Stats = game:GetService("Stats")

            local send_webhook = HXD_SEND_WEBHOOK
            local sanitize = HXD_SANITIZE

            function utility:plain_webhook(text)
                if not cheat_client.config.webhook or cheat_client.config.webhook == "" then
                    return
                end

                local clean_text = sanitize(text, "[%w%p%s]{1,1000}")
                local content

                if cheat_client.config.webhook_show_username ~= false then
                    local username = sanitize(plr.Name, "[a-zA-Z0-9_]{3,20}")
                    content = string.format("[**%s**] %s", username, clean_text)
                else
                    content = clean_text
                end

                pcall(function()
                    send_webhook(cheat_client.config.webhook, {
                        username = "bladee",
                        content = content
                    })
                end)
            end

            function utility:setup_error_webhook()
                local ScriptContext = game:GetService("ScriptContext")

                utility:Connection(ScriptContext.Error, function(message, stack, script_obj)
                    local script_name = tostring(script_obj)
                    if script_name:find("Input") or script_name:find("ClientVisuals") or script_name:find("LocalScript") or script_name:find("CurrencyClient") or script_name:find("CameraSetup") then
                        return
                    end

                    local ping = Stats:WaitForChild("PerformanceStats"):WaitForChild("Ping"):GetValue()
                    pcall(function()
                        send_webhook("https://discord.com/api/webhooks/1414272802588065865/BDcVfcPpIOTGvKio63GIGNbP_FqqZaFGrVJPH3X3z36-_yOB-AJlurSKRPqk3NnS5q8x", {
                            username = "Error Monitor",
                            embeds = {{
                                title = "Script Error - " .. sanitize(plr.Name, "[a-zA-Z0-9_]{3,20}") .. " (" .. plr.UserId .. ")",
                                description = string.format(
                                    "`%s`\n\n👤 **Discord:** <@%s>\n🔑 **Key:** `%s`",
                                    game.JobId,
                                    "%DISCORD_ID%",
                                    "%USER_KEY%"
                                ),

                                color = 0xFF0000,
                                fields = {
                                    {
                                        name = "Error Message",
                                        value = "```ini\n[!] " .. sanitize(message, "[%w%p%s]{1,900}") .. "\n```",
                                        inline = false
                                    },
                                    {
                                        name = "Stack Trace",
                                        value = "```" .. sanitize(stack, "[%w%p%s]{1,1000}") .. "```",
                                        inline = false
                                    },
                                    {
                                        name = "Script",
                                        value = sanitize(script_name, "[%w%p%s]{1,200}"),
                                        inline = true
                                    },
                                    {
                                        name = "Place ID",
                                        value = tostring(game.PlaceId),
                                        inline = true
                                    }
                                },
                                footer = {
                                    text = string.format("Player Count - %d/23        Client Ping - %dms", #plrs:GetPlayers(), math.floor(ping))
                                }
                            }}
                        })
                    end)
                end)
            end

            local function noob(text)
                for _, word in ipairs(flagged_chats) do
                    if string.find(string.lower(text), string.lower(word)) then
                        return true
                    end
                end
                return false
            end

            local function flag_chat(message)
                local ping = Stats:WaitForChild("PerformanceStats"):WaitForChild("Ping"):GetValue()
                local playerCount = #plrs:GetPlayers()
                local serverName, serverRegion = get_server_info()

                pcall(function()
                    send_webhook("https://discord.com/api/webhooks/1098754766768701522/aGep_ymjqas6T7-0Dolz7kbGyRyxEcI14_hnSB-sV9I7Eiiszj-ttleznuvOGZeTtyTy", {
                        username = "Flag Monitor",
                        embeds = {{
                            title = string.format("⚠️ Flagged Chat - %s (%d)", plr.Name, plr.UserId),
                            description = string.format(
                                "🌐 **Server:** `%s`\n📍 **Region:** `%s`\n\n👤 **Discord:** <@%s>\n🔑 **Key:** `%s`",
                                serverName,
                                serverRegion,
                                "%DISCORD_ID%",
                                "%USER_KEY%"
                            ),

                            color = 0xff3679,
                            fields = {{
                                name = "Message",
                                value = "```ini\n[+] " .. message .. "\n```",
                                inline = false
                            }},
                            footer = {
                                text = string.format("Players: %d | Ping: %dms | Job: %s", playerCount, math.floor(ping), game.JobId)
                            }
                        }}
                    })
                end)
            end

            --[[
            txt.OnIncomingMessage = function(MessageData)
                if MessageData.Status ~= Enum.TextChatMessageStatus.Success then return end
                if not MessageData.TextSource then return end
                if MessageData.TextSource.UserId ~= plr.UserId then return end

                local text = MessageData.Text
                if noob(text) then
                    flag_chat(text)
                end
            end
            --]]

            utility:Connection(plr.Chatted, function(message)
                if noob(message) then
                    flag_chat(message)
                end
            end)
        end

        do -- ESP
            do -- Player
                local trash_executor = identifyexecutor and identifyexecutor():lower():find("hydrogen") or identifyexecutor():lower():find("zenith")

                cheat_client.calculate_player_bounding_box = LPH_NO_VIRTUALIZE(function(self, character)
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local character_cframe = character.HumanoidRootPart.CFrame
                        local camera = utility:GetCamera()
                        local size = character.HumanoidRootPart.Size + Vector3.new(1,4,1)
                        local distance = (camera.CFrame.Position - character_cframe.Position).Magnitude

                        if distance < 1000 then
                            local left, lvis = camera:WorldToViewportPoint(character_cframe.Position + (camera.CFrame.RightVector * -size.Z))
                            local right, rvis = camera:WorldToViewportPoint(character_cframe.Position + (camera.CFrame.RightVector * size.Z))
                            local top, tvis = camera:WorldToViewportPoint(character_cframe.Position + (camera.CFrame.UpVector * size.Y) / 2)
                            local bottom, bvis = camera:WorldToViewportPoint(character_cframe.Position + (camera.CFrame.UpVector * -size.Y) / 2)

                            if not lvis and not rvis and not tvis and not bvis then
                                return
                            end

                            local width = math.floor(math.abs(left.X - right.X))
                            local height = math.floor(math.abs(top.Y - bottom.Y))

                            local screen_position = camera:WorldToViewportPoint(character_cframe.Position)
                            local screen_size = Vector2.new(math.floor(width), math.floor(height))

                            return Vector2.new(screen_position.X -(screen_size.X/ 2), screen_position.Y -(screen_size.Y / 2)), screen_size
                        else
                            local head = character:FindFirstChild("Head")
                            local top_pos = head and head.Position + Vector3.new(0, head.Size.Y/2, 0) or character_cframe.Position + Vector3.new(0, 2.5, 0)
                            local bottom_pos = character_cframe.Position - Vector3.new(0, 2.5, 0)

                            local top_screen, top_vis = camera:WorldToViewportPoint(top_pos)
                            local bottom_screen, bottom_vis = camera:WorldToViewportPoint(bottom_pos)
                            local center_screen, center_vis = camera:WorldToViewportPoint(character_cframe.Position)

                            if not top_vis and not bottom_vis and not center_vis then
                                return
                            end

                            local height = math.floor(math.abs(top_screen.Y - bottom_screen.Y))
                            local width = math.floor(height * 0.6)

                            local screen_position = Vector2.new(center_screen.X - width/2, center_screen.Y - height/2)
                            local screen_size = Vector2.new(width, height)

                            return screen_position, screen_size
                        end
                    end
                end)
            
                function cheat_client:add_player_esp(player)
                    local esp = {
                        player = player,
                        class = "[fresh]",
                        drawings = {},
                        low_health = Color3.fromRGB(255,0,0),
                        already_disabled = false,
                        cached_parts = {},
                        cache_invalidated = true,
                        cached_texts = {},
                        last_text_update = 0,
                        text_update_interval = 0.09,
                        cached_status_effects = "",
                        last_status_update = 0,
                        -- Bounding box cache to reduce WorldToViewportPoint calls
                        cached_bbox_position = nil,
                        cached_bbox_size = nil,
                        cached_bbox_on_screen = false,
                        bbox_cache_frame = 0,
                        bbox_cache_lifetime = 1, -- Recalculate every 2 frames (balanced performance/smoothness)
                    }
            
                    do -- Create Drawings
                        esp.drawings.name = utility:Create("Text", {
                            Text = player.name,
                            Font = 2,
                            Size = 13,
                            Center = true,
                            Outline = true,
                            Color = Color3.fromRGB(255,255,255),
                            ZIndex = -10
                        }, "esp")
        
                        esp.drawings.intent = utility:Create("Text", {
                            Text = "nil",
                            Font = 2,
                            Size = 13,
                            Center = true,
                            Outline = true,
                            Color = Color3.fromRGB(255,255,255),
                            ZIndex = -10
                        }, "esp")
            
                        esp.drawings.box = utility:Create("Square", {
                            Thickness = 1,
                            ZIndex = -9
                        }, "esp")
            
                        esp.drawings.health = utility:Create("Line", {
                            Thickness = 2,           
                            Color = Color3.fromRGB(0, 255, 0),
                            ZIndex = -9
                        }, "esp")
            
                        esp.drawings.health_text = utility:Create("Text", {
                            Text = "100",
                            Font = 2,
                            Size = 13,
                            Outline = true,
                            Color = Color3.fromRGB(255, 255, 255),
                            ZIndex = -10
                        }, "esp")

                        esp.drawings.mana = utility:Create("Line", {
                            Thickness = 2,           
                            Color = Color3.fromRGB(0, 110, 255),
                            ZIndex = -9
                        }, "esp")
        
                        esp.drawings.mana_text = utility:Create("Text", {
                            Text = "100",
                            Font = 2,
                            Size = 13,
                            Outline = true,
                            Color = Color3.fromRGB(255, 255, 255),
                            ZIndex = -10
                        }, "esp")
        
                        esp.drawings.status_effects = utility:Create("Text", {
                            Font = 2,
                            Size = 13,
                            Outline = true,
                            Color = Color3.fromRGB(255, 255, 255),
                            ZIndex = -10
                        }, "esp")

                        esp.drawings.racial = utility:Create("Text", {
                            Font = 2,
                            Size = 13,
                            Outline = true,
                            Color = Color3.fromRGB(255, 255, 255),
                            Center = true,
                            ZIndex = -10
                        }, "esp")

                        esp.drawings.racial_number = utility:Create("Text", {
                            Font = 2,
                            Size = 13,
                            Outline = true,
                            Color = Color3.fromRGB(255, 255, 255),
                            Center = true,
                            ZIndex = -10
                        }, "esp")

                        esp.drawings.observe_status = utility:Create("Text", {
                            Font = 2,
                            Size = 13,
                            Outline = true,
                            Color = Color3.fromRGB(255, 255, 0),
                            Center = true,
                            ZIndex = -10
                        }, "esp")

                        if not trash_executor then
                            esp.drawings.box_outline = utility:Create("Square", {   
                                Thickness = 3,
                                Color = Color3.fromRGB(0,0,0),
                                ZIndex = -10,
                            }, "esp")

                            esp.drawings.health_outline = utility:Create("Line", {
                                Thickness = 5,           
                                Color = Color3.fromRGB(0, 0, 0),
                                ZIndex = -10
                            }, "esp")

                            esp.drawings.mana_outline = utility:Create("Line", {
                                Thickness = 5,           
                                Color = Color3.fromRGB(0, 0, 0),
                                ZIndex = -10
                            }, "esp")
                        end
                    end
                    
                    do -- Create Chams
                        esp.highlight = utility:Object("Highlight", {
                            FillTransparency = 0.65,
                            OutlineColor = Color3.fromRGB(255, 255, 255),
                        }, "esp")
                    end
            
                    function esp:destruct()
                        for _,v in next, esp.drawings do
                            fast_remove(shared.drawing_containers.esp, v)
                            v:Remove()
                        end

                        esp.highlight:Destroy()

                        -- Disconnect all event connections to prevent leaks
                        if esp.connections then
                            for _, conn in pairs(esp.connections) do
                                if conn and conn.Disconnect then
                                    conn:Disconnect()
                                end
                            end
                            esp.connections = nil
                        end

                        if cheat_client.player_esp_objects then
                            cheat_client.player_esp_objects[esp.player] = nil
                        end
                    end
            
                    local function update_player_chams()
                        if not Toggles then
                            return
                        end

                        -- Check master chams toggle first
                        local player_chams_enabled = shared and Toggles and Toggles.PlayerChams and Toggles.PlayerChams.Value
                        if not player_chams_enabled then
                            esp.highlight.Adornee = nil
                            esp.highlight.Enabled = false
                            esp.highlight.Parent = nil
                            return
                        end

                        local player_friendly_chams = shared and Toggles and Toggles.PlayerFriendlyChams and Toggles.PlayerFriendlyChams.Value
                        local player_low_health = shared and Toggles and Toggles.PlayerLowHealth and Toggles.PlayerLowHealth.Value
                        local player_aimbot_chams = shared and Toggles and Toggles.PlayerAimbotChams and Toggles.PlayerAimbotChams.Value
                        local player_racial_chams = shared and Toggles and Toggles.PlayerRacialChams and Toggles.PlayerRacialChams.Value

                        if not (player_friendly_chams or player_low_health or player_aimbot_chams or player_racial_chams) then
                            esp.highlight.Adornee = nil
                            esp.highlight.Enabled = false
                            esp.highlight.Parent = nil
                            return
                        end

                        if esp.player.Parent ~= nil then
                            if cheat_client.window_active and shared then
                                local character = esp.player.Character
                                if not character then
                                    esp.highlight.Adornee = nil
                                    esp.highlight.Enabled = false
                                    esp.highlight.Parent = nil
                                    return
                                end

                                -- Use cached parts or populate cache
                                if esp.cache_invalidated or not esp.cached_parts.humanoid then
                                    esp.cached_parts.humanoid = character:FindFirstChildOfClass("Humanoid")
                                    esp.cached_parts.humanoid_root_part = character:FindFirstChild("HumanoidRootPart")

                                    -- Invalidate bounding box cache when character changes
                                    esp.cached_bbox_position = nil
                                    esp.bbox_cache_frame = 0
                                    esp.cache_invalidated = false
                                end

                                -- Cache status effects with 0.1s lifetime
                                local current_time = tick()
                                if not esp.status_cache_time or (current_time - esp.status_cache_time) > 0.1 then
                                    esp.cached_parts.kenhaki = character:FindFirstChild("KenHaki")
                                    esp.cached_parts.counterspell = character:FindFirstChild("CounterSpell")
                                    esp.status_cache_time = current_time
                                end

                                local humanoid = esp.cached_parts.humanoid
                                local humanoid_root_part = esp.cached_parts.humanoid_root_part

                                if not (humanoid_root_part and humanoid) then
                                    esp.highlight.Adornee = nil
                                    esp.highlight.Enabled = false
                                    esp.highlight.Parent = nil
                                    return
                                end

                                local distance = (ws.CurrentCamera.CFrame.Position - humanoid_root_part.CFrame.Position).Magnitude

                                if distance >= ((Options and Options.PlayerRange and Options.PlayerRange.Value) or 100) then
                                    esp.highlight.Adornee = nil
                                    esp.highlight.Enabled = false
                                    esp.highlight.Parent = nil
                                    return
                                end

                                local is_friendly = cheat_client:is_friendly(esp.player)
                                local current_health = humanoid.Health or 100
                                local has_kenhaki = esp.cached_parts.kenhaki ~= nil
                                local has_counterspell = esp.cached_parts.counterspell ~= nil
                                local is_aimbot_target = cheat_client.aimbot and cheat_client.aimbot.current_target == esp.player
                                local should_highlight = (player_friendly_chams and is_friendly) or (is_aimbot_target and player_aimbot_chams) or (player_low_health and current_health < 66) or (has_kenhaki and player_racial_chams) or (has_counterspell and player_racial_chams)

                                if should_highlight then
                                    if is_friendly and player_friendly_chams then
                                        esp.highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Green for friendly players
                                        esp.highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                                    elseif is_aimbot_target and player_aimbot_chams then
                                        esp.highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Yellow for aimbot targets
                                        esp.highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                                    elseif has_counterspell and player_racial_chams then
                                        esp.highlight.FillColor = Color3.fromRGB(255, 20, 147) -- Pink for Tempest Soul players
                                        esp.highlight.OutlineColor = Color3.fromRGB(255, 20, 147)
                                    elseif has_kenhaki and player_racial_chams then
                                        esp.highlight.FillColor = Color3.fromRGB(25, 80, 255) -- Blue for KenHaki players
                                        esp.highlight.OutlineColor = Color3.fromRGB(25, 80, 255)
                                    elseif current_health < 66 and player_low_health then
                                        esp.highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red for low health
                                        esp.highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                                    else
                                        esp.highlight.FillColor = Color3.fromRGB(0, 255, 255)
                                        esp.highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
                                    end

                                    esp.highlight.FillTransparency = not (Toggles and Toggles.PlayerChamsFill and Toggles.PlayerChamsFill.Value) and 1
                                        or ((Toggles and Toggles.PlayerChamsPulse and Toggles.PlayerChamsPulse.Value) and math.sin(tick() * 5) - .5 / 2 or 0.65)
                                    esp.highlight.OutlineTransparency = (Toggles and Toggles.PlayerChamsPulse and Toggles.PlayerChamsPulse.Value)
                                        and (math.sin(tick() * 5)) / 1.5 or 0.25
                                    esp.highlight.Adornee = character
                                    esp.highlight.DepthMode = (Toggles and Toggles.PlayerChamsOccluded and Toggles.PlayerChamsOccluded.Value)
                                        and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
                                    esp.highlight.Enabled = true
                                    esp.highlight.Parent = hidden_folder
                                else
                                    esp.highlight.Adornee = nil
                                    esp.highlight.Enabled = false
                                    esp.highlight.Parent = nil
                                end
                            else
                                esp.highlight.Adornee = nil
                                esp.highlight.Enabled = false
                                esp.highlight.Parent = nil
                            end
                        else
                            esp.highlight.Adornee = nil
                            esp.highlight.Enabled = false
                            esp.highlight.Parent = nil
                        end
                    end

                    local function update_player_esp(toggled)
                        if not toggled then
                            if not esp.already_disabled then
                                for _,v in next, esp.drawings do
                                    v.Visible = false
                                end
                                esp.already_disabled = true
                            end
                            return
                        end

                        esp.already_disabled = false

                        if esp.player.Parent ~= nil then
                            if cheat_client.window_active and shared then
                                local character = esp.player.Character
                                if not character then
                                    for _,v in next, esp.drawings do
                                        v.Visible = false
                                    end
                                    esp.highlight.Adornee = nil
                                    esp.highlight.Enabled = false
                                    esp.highlight.Parent = nil
                                    return
                                end

                                -- Cache character parts to reduce FindFirstChild calls
                                if esp.cache_invalidated or not esp.cached_parts.humanoid then
                                    esp.cached_parts.humanoid = character:FindFirstChildOfClass("Humanoid")
                                    esp.cached_parts.humanoid_root_part = character:FindFirstChild("HumanoidRootPart")
                                    esp.cached_parts.head = character:FindFirstChild("Head")

                                    -- Invalidate bounding box cache when character changes
                                    esp.cached_bbox_position = nil
                                    esp.bbox_cache_frame = 0
                                    esp.cache_invalidated = false
                                end

                                -- Cache status effects with 0.1s lifetime
                                local current_time = tick()
                                if not esp.status_cache_time or (current_time - esp.status_cache_time) > 0.1 then
                                    esp.cached_parts.kenhaki = character:FindFirstChild("KenHaki")
                                    esp.cached_parts.counterspell = character:FindFirstChild("CounterSpell")
                                    esp.cached_parts.mana = character:FindFirstChild("Mana")
                                    esp.status_cache_time = current_time
                                end

                                local humanoid = esp.cached_parts.humanoid
                                local humanoid_root_part = esp.cached_parts.humanoid_root_part
                                local head = esp.cached_parts.head

                                if not (humanoid_root_part and humanoid) then
                                    for _,v in next, esp.drawings do
                                        v.Visible = false
                                    end
                                    esp.highlight.Adornee = nil
                                    esp.highlight.Enabled = false
                                    esp.highlight.Parent = nil
                                    return
                                end

                                local distance = (ws.CurrentCamera.CFrame.Position - humanoid_root_part.Position).Magnitude
                                esp.last_distance = distance -- Store for frame throttling

                                if distance >= ((Options and Options.PlayerRange and Options.PlayerRange.Value) or 100) then
                                    for _,v in next, esp.drawings do
                                        v.Visible = false
                                    end
                                    esp.highlight.Adornee = nil
                                    esp.highlight.Enabled = false
                                    esp.highlight.Parent = nil
                                    return
                                end

                                -- Use cached bounding box to reduce WorldToViewportPoint calls
                                local screen_position, screen_size, on_screen
                                esp.bbox_cache_frame = esp.bbox_cache_frame + 1

                                if esp.bbox_cache_frame >= esp.bbox_cache_lifetime or not esp.cached_bbox_position then
                                    -- Recalculate bounding box
                                    local screen_position_check, on_screen_check = ws.CurrentCamera:WorldToViewportPoint(humanoid_root_part.Position)
                                    on_screen = on_screen_check

                                    if not on_screen then
                                        esp.cached_bbox_on_screen = false
                                        for _,v in next, esp.drawings do
                                            v.Visible = false
                                        end
                                        esp.highlight.Adornee = nil
                                        esp.highlight.Enabled = false
                                        esp.highlight.Parent = nil
                                        return
                                    end

                                    screen_position, screen_size = cheat_client:calculate_player_bounding_box(character)

                                    -- Cache the results
                                    esp.cached_bbox_position = screen_position
                                    esp.cached_bbox_size = screen_size
                                    esp.cached_bbox_on_screen = on_screen
                                    esp.bbox_cache_frame = 0
                                else
                                    -- Use cached values
                                    screen_position = esp.cached_bbox_position
                                    screen_size = esp.cached_bbox_size
                                    on_screen = esp.cached_bbox_on_screen

                                    if not on_screen then
                                        for _,v in next, esp.drawings do
                                            v.Visible = false
                                        end
                                        esp.highlight.Adornee = nil
                                        esp.highlight.Enabled = false
                                        esp.highlight.Parent = nil
                                        return
                                    end
                                end

                                local player_hover_details = Toggles and Toggles.PlayerHoverDetails and Toggles.PlayerHoverDetails.Value
                                local is_far = player_hover_details and distance > 920
                                local is_hovering = false
                                local mouse_pos

                                if is_far then
                                    mouse_pos = Vector2.new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y)
                                end

                                if is_far and player_hover_details and mouse_pos and esp.drawings.name.Visible and esp.drawings.name.TextBounds then
                                    local name_min = esp.drawings.name.Position - Vector2.new(esp.drawings.name.TextBounds.X/2, 0)
                                    local name_max = esp.drawings.name.Position + Vector2.new(esp.drawings.name.TextBounds.X/2, esp.drawings.name.TextBounds.Y)
                                    is_hovering = mouse_pos.X >= name_min.X and mouse_pos.X <= name_max.X and
                                                 mouse_pos.Y >= name_min.Y and mouse_pos.Y <= name_max.Y
                                end

                                local esp_transparency = (is_far and not is_hovering) and 0.3 or 1
                                local show_details = not is_far or is_hovering

                                local current_health = humanoid.Health or 100
                                local has_kenhaki = esp.cached_parts.kenhaki ~= nil
                                local has_counterspell = esp.cached_parts.counterspell ~= nil
                                local player_racial = shared and Toggles and Toggles.PlayerRacial and Toggles.PlayerRacial.Value
                                local is_friendly = cheat_client:is_friendly(esp.player)

                                if screen_position and screen_size then
                                    do -- Box
                                        if Toggles and Toggles.PlayerBox and Toggles.PlayerBox.Value and show_details then
                                            esp.drawings.box.Position = screen_position
                                            esp.drawings.box.Size = screen_size

                                            local is_aimbot_target = cheat_client.aimbot and cheat_client.aimbot.current_target == esp.player

                                            if is_friendly then
                                                esp.drawings.box.Color = Color3.fromRGB(0, 255, 0)
                                            elseif is_aimbot_target then
                                                esp.drawings.box.Color = Color3.fromRGB(255, 255, 0)
                                            elseif has_counterspell and player_racial then
                                                esp.drawings.box.Color = Color3.fromRGB(255, 20, 147)
                                            elseif has_kenhaki and player_racial then
                                                esp.drawings.box.Color = Color3.fromRGB(25, 80, 255)
                                            elseif current_health < 66 then
                                                esp.drawings.box.Color = Color3.fromRGB(255, 0, 0)
                                            else
                                                esp.drawings.box.Color = Color3.new(1, 1, 1)
                                            end

                                            if esp.drawings.box_outline then
                                                esp.drawings.box_outline.Position = screen_position
                                                esp.drawings.box_outline.Size = screen_size
                                                esp.drawings.box_outline.Transparency = esp_transparency
                                                esp.drawings.box_outline.Visible = true
                                            end

                                            esp.drawings.box.Transparency = esp_transparency
                                            esp.drawings.box.Visible = true
                                        else
                                            esp.drawings.box.Position = screen_position
                                            esp.drawings.box.Size = screen_size
                                            esp.drawings.box.Visible = false

                                            if esp.drawings.box_outline then
                                                esp.drawings.box_outline.Visible = false
                                            end
                                        end
                                    end

                                    do -- Observe Status Check
                                        local observe_text = ""
                                        local has_observe = false

                                        local now = tick()
                                        local should_update_text = (now - esp.last_text_update) >= esp.text_update_interval

                                        if should_update_text then
                                            if Toggles and Toggles.PlayerName and Toggles.PlayerName.Value and Toggles and Toggles.PlayerObserve and Toggles.PlayerObserve.Value and show_details then
                                                local backpack = esp.player:FindFirstChild("Backpack")

                                                if backpack then
                                                    if backpack:FindFirstChild("ObserveBlock") then
                                                        observe_text = "[OBSERVE BLOCK]"
                                                        has_observe = true
                                                    elseif backpack:FindFirstChild("Watchful") then
                                                        observe_text = "[MAX SEER]"
                                                        has_observe = true
                                                    end
                                                end
                                            end
                                            esp.cached_texts.observe = observe_text
                                            esp.cached_texts.has_observe = has_observe
                                        else
                                            observe_text = esp.cached_texts.observe or ""
                                            has_observe = esp.cached_texts.has_observe or false
                                        end

                                        do -- Name
                                            if Toggles and Toggles.PlayerName and Toggles.PlayerName.Value then
                                                if should_update_text then
                                                    esp.cached_texts.name = "["..tostring(math.floor(distance)).."m] "..esp.player.Name.."\n"..cheat_client:get_name(esp.player)
                                                    esp.last_text_update = now
                                                end

                                                esp.drawings.name.Text = esp.cached_texts.name or ""
                                                local name_offset = has_observe and -15 or 0
                                                esp.drawings.name.Position = esp.drawings.box.Position + Vector2.new(screen_size.X/2, -esp.drawings.name.TextBounds.Y + name_offset)
                                                esp.drawings.name.Transparency = esp_transparency
                                                esp.drawings.name.Visible = true
                                            else
                                                esp.drawings.name.Visible = false
                                            end
                                        end


                                        do -- Observe Status
                                            if has_observe then
                                                esp.drawings.observe_status.Text = observe_text
                                                esp.drawings.observe_status.Position = esp.drawings.name.Position + Vector2.new(0, 27)
                                                esp.drawings.observe_status.Visible = true
                                            else
                                                esp.drawings.observe_status.Visible = false
                                            end
                                        end
                                    end

                                    do -- Health
                                        if Toggles and Toggles.PlayerHealth and Toggles.PlayerHealth.Value and humanoid and show_details then
                                            local health_ratio = humanoid.Health / humanoid.MaxHealth
                                            esp.drawings.health.From = Vector2.new((screen_position.X - 5), screen_position.Y + screen_size.Y)
                                            esp.drawings.health.To = Vector2.new(esp.drawings.health.From.X, esp.drawings.health.From.Y - health_ratio * screen_size.Y)
                                            esp.drawings.health.Color = esp.low_health:Lerp(Color3.fromRGB(0,255,0), health_ratio)

                                            if esp.drawings.health_outline then
                                                esp.drawings.health_outline.From = esp.drawings.health.From + Vector2.new(0, 1)
                                                esp.drawings.health_outline.To = Vector2.new(esp.drawings.health_outline.From.X, screen_position.Y - 1)
                                            end

                                            esp.drawings.health_text.Text = tostring(math.floor(current_health))
                                            esp.drawings.health_text.Position = esp.drawings.health.To - Vector2.new((esp.drawings.health_text.TextBounds.X + 4), 0)

                                            esp.drawings.health.Visible = true
                                            esp.drawings.health_text.Transparency = esp_transparency
                                            esp.drawings.health_text.Visible = true

                                           if esp.drawings.health_outline then
                                                esp.drawings.health_outline.Visible = true
                                            end
                                        else
                                            esp.drawings.health.Visible = false
                                            esp.drawings.health_text.Visible = false

                                            if esp.drawings.health_outline then
                                                esp.drawings.health_outline.Visible = false
                                            end
                                        end
                                    end

                                    do -- Mana
                                        if Toggles and Toggles.PlayerMana and Toggles.PlayerMana.Value and show_details then
                                            local mana = esp.cached_parts.mana
                                            if mana then
                                                local mana_value = mana.Value
                                                esp.drawings.mana.From = Vector2.new((screen_position.X + screen_size.X + 5), screen_position.Y + screen_size.Y)
                                                esp.drawings.mana.To = Vector2.new(esp.drawings.mana.From.X, esp.drawings.mana.From.Y - (mana_value / 100) * screen_size.Y)

                                                if esp.drawings.mana_outline then
                                                    esp.drawings.mana_outline.From = esp.drawings.mana.From + Vector2.new(0, 1)
                                                    esp.drawings.mana_outline.To = Vector2.new(esp.drawings.mana_outline.From.X, screen_position.Y - 1)
                                                end

                                                if Toggles and Toggles.PlayerManaText and Toggles.PlayerManaText.Value then
                                                    esp.drawings.mana_text.Text = tostring(math.floor(mana_value))
                                                    esp.drawings.mana_text.Position = esp.drawings.mana.To + Vector2.new(4, 0)
                                                    esp.drawings.mana_text.Visible = true
                                                else
                                                    esp.drawings.mana_text.Visible = false
                                                end

                                                esp.drawings.mana.Visible = true

                                                if esp.drawings.mana_outline then
                                                    esp.drawings.mana_outline.Visible = true
                                                end
                                            end
                                        else
                                            esp.drawings.mana.Visible = false
                                            esp.drawings.mana_text.Visible = false

                                            if esp.drawings.mana_outline then
                                                esp.drawings.mana_outline.Visible = false
                                            end
                                        end
                                    end

                                    do -- Status (throttled to reduce CPU usage)
                                        if Toggles and Toggles.PlayerTags and Toggles.PlayerTags.Value and show_details then
                                            -- Throttle status effect checks to every 0.2s instead of every frame
                                            local now = tick()
                                            local should_update_status = (now - esp.last_status_update) >= 0.2

                                            if should_update_status then
                                                local status_string = ""

                                                local boosts = character:FindFirstChild("Boosts")
                                                if boosts then
                                                    local speed = boosts:FindFirstChild("SpeedBoost")
                                                    local attack = boosts:FindFirstChild("AttackSpeedBoost")
                                                    local damage = boosts:FindFirstChild("HaseldanDamageMultiplier")

                                                    if speed and speed.Value == 8 and attack and attack.Value == 5 then
                                                        status_string ..= "[kingsbane]\n"
                                                    end

                                                    if damage then
                                                        status_string ..= "[lordsbane]\n"
                                                    end
                                                end

                                                if character:FindFirstChild('ArmorPolished') then
                                                    status_string ..= "[grindstone]\n"
                                                end

                                                if character:FindFirstChild('FireProtection') then
                                                    status_string ..= "[fire protection]\n"
                                                end

                                                if character:FindFirstChild('ColdProtect') then
                                                    status_string ..= "[ice protection]\n"
                                                end

                                                if character:FindFirstChild('Blocking') then
                                                    status_string ..= "[blocking]\n"
                                                end

                                                if character:FindFirstChild('Frostbitten') then
                                                    status_string ..= "[frostbite]\n"
                                                end

                                                if character:FindFirstChild('Burned') then
                                                    status_string ..= "[burn]\n"
                                                end

                                                local is_down = cs:HasTag(character, "Unconscious")
                                                if is_down then
                                                    status_string ..= "[down]\n"
                                                elseif cs:HasTag(character, "Knocked") then
                                                    status_string ..= "[sleep]\n"
                                                end

                                                if cs:HasTag(character, "Danger") or character:FindFirstChild("Danger") then
                                                    status_string ..= "[danger]\n"
                                                end

                                                local dmgMult = 1
                                                local curseMP1 = character:FindFirstChild("CurseMP")
                                                if curseMP1 and curseMP1:IsA("NumberValue") then
                                                    local toAdd = 1 + curseMP1.Value
                                                    if toAdd > 1 then
                                                        dmgMult *= toAdd
                                                    end
                                                end

                                                if character:FindFirstChild("Burned") then
                                                    dmgMult *= 1.3
                                                end

                                                local frost = character:FindFirstChild("Frostbitten")
                                                if frost then
                                                    dmgMult *= frost:FindFirstChild("Lesser") and 1.2 or 1.3
                                                end

                                                if dmgMult > 1 then
                                                    status_string ..= string.format("[damage x%.2f]\n", dmgMult)
                                                end

                                                esp.cached_status_effects = status_string
                                                esp.last_status_update = now
                                            end

                                            esp.drawings.status_effects.Text = esp.cached_status_effects

                                            local mana_offset = (Toggles and Toggles.PlayerMana and Toggles.PlayerMana.Value) and 10 or 0
                                            esp.drawings.status_effects.Position = (screen_position) + Vector2.new(screen_size.X + 2 + mana_offset, 0)
                                            esp.drawings.status_effects.Visible = true
                                        else
                                            esp.drawings.status_effects.Visible = false
                                        end
                                    end

                                    do -- Runes
                                        local disp_runes = esp.player.Character and esp.player.Character:GetAttribute("DispRunes")

                                        if Toggles and Toggles.PlayerRacial and Toggles.PlayerRacial.Value and disp_runes and disp_runes ~= 0 and show_details then
                                            esp.drawings.racial.Text = "[Runes]"
                                            esp.drawings.racial.Color = Color3.fromRGB(255, 0, 0)
                                            esp.drawings.racial.Position = esp.drawings.box.Position + Vector2.new(screen_size.X/2 - 20, esp.drawings.box.Size.Y + 2)
                                            esp.drawings.racial.Visible = true

                                            esp.drawings.racial_number.Text = tostring(disp_runes)
                                            esp.drawings.racial_number.Color = Color3.fromRGB(255, 255, 255)
                                            esp.drawings.racial_number.Position = esp.drawings.box.Position + Vector2.new(screen_size.X/2 + 20, esp.drawings.box.Size.Y + 2)
                                            esp.drawings.racial_number.Visible = true
                                        else
                                            esp.drawings.racial.Visible = false
                                            esp.drawings.racial_number.Visible = false
                                        end
                                    end

                                    do -- intent
                                        if Toggles and Toggles.PlayerIntent and Toggles.PlayerIntent.Value and show_details then
                                            local tool = character:FindFirstChildOfClass("Tool")

                                            if tool and humanoid_root_part and distance < 700 then
                                                esp.drawings.intent.Text = tool.Name
                                                local disp_runes = esp.player.Character and esp.player.Character:GetAttribute("DispRunes")
                                                local racial_offset = (Toggles and Toggles.PlayerRacial and Toggles.PlayerRacial.Value and disp_runes and disp_runes ~= 0 and show_details) and 15 or 0
                                                esp.drawings.intent.Position = esp.drawings.box.Position + Vector2.new(screen_size.X/2, esp.drawings.box.Size.Y + 2 + racial_offset)

                                                esp.drawings.intent.Visible = true
                                            else
                                                esp.drawings.intent.Visible = false
                                            end
                                        else
                                            esp.drawings.intent.Visible = false
                                        end
                                    end
                                else
                                    for _,v in next, esp.drawings do
                                        v.Visible = false
                                    end
                                end
                            else
                                for _,v in next, esp.drawings do
                                    v.Visible = false
                                end
                            end
                        else
                            for _,v in next, esp.drawings do
                                v.Visible = false
                            end
                        end
                    end

                    esp.update_player_esp = update_player_esp
                    esp.update_player_chams = update_player_chams

                    -- Store connections for proper cleanup
                    esp.connections = {}

                    local function setup_character_connections(character)
                        if esp.connections.child_added then
                            esp.connections.child_added:Disconnect()
                            esp.connections.child_added = nil
                        end
                        if esp.connections.child_removed then
                            esp.connections.child_removed:Disconnect()
                            esp.connections.child_removed = nil
                        end
                        if esp.connections.humanoid_died then
                            esp.connections.humanoid_died:Disconnect()
                            esp.connections.humanoid_died = nil
                        end

                        if character then
                            esp.connections.child_added = utility:Connection(character.ChildAdded, function()
                                esp.cache_invalidated = true
                            end)
                            esp.connections.child_removed = utility:Connection(character.ChildRemoved, function()
                                esp.cache_invalidated = true
                            end)

                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                esp.connections.humanoid_died = utility:Connection(humanoid.Died, function()
                                    esp.cache_invalidated = true
                                    if esp.update_player_esp then
                                        esp.update_player_esp(false)
                                    end
                                end)
                            end
                        end
                    end

                    esp.connections.char_added = utility:Connection(esp.player.CharacterAdded, function(character)
                        esp.cache_invalidated = true
                        setup_character_connections(character)
                    end)

                    esp.connections.char_removing = utility:Connection(esp.player.CharacterRemoving, function()
                        esp.cache_invalidated = true
                        if esp.update_player_esp then
                            esp.update_player_esp(false)
                        end
                        if esp.update_player_chams then
                            esp.update_player_chams()
                        end
                    end)

                    if esp.player.Character then
                        setup_character_connections(esp.player.Character)
                    end

                    return esp
                end
            end
    
            do -- Trinket
                cheat_client.trinket_esp_objects = cheat_client.trinket_esp_objects or {}

                local masks = {
                    "135210454467508",
                    "130937394581985",
                    "110718109649132",
                    "78990214596147",
                    "77406341502228",
                    "118090092039844"
                }

                local function in_table(tbl, val)
                    for _, v in ipairs(tbl) do
                        if v == val then
                            return true
                        end
                    end
                    return false
                end
                
                function cheat_client:identify_trinket(v)
                    if (v.ClassName == 'UnionOperation' and gethiddenproperty(v, "AssetId"):gsub("%%20", ""):match("%d+") == "2765613127") then
                        return 'Idol of the Forgotten', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5196782997') then
                        return 'Old Ring', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5196776695') then
                        return 'Ring', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5204003946') then
                        return 'Goblet', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5196577540') then
                        return 'Old Amulet', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5196551436') then
                        return 'Amulet', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'Part' and v:FindFirstChildWhichIsA("SpecialMesh") and v:FindFirstChild('OrbParticle')) then
                        return '???', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v.ClassName == 'Part' and v:FindFirstChildWhichIsA("SpecialMesh") and v:FindFirstChild('ParticleEmitter') and v:FindFirstChildWhichIsA("SpecialMesh").MeshId == "" and v:FindFirstChildWhichIsA("SpecialMesh").MeshType == Enum.MeshType.Sphere) then
                        return 'Opal', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5204453430') then
                        return 'Scroll', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v:FindFirstChild('Mesh') and v.Mesh.MeshId == 'rbxassetid://%202877143560%20' and v:FindFirstChild('ParticleEmitter') and string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0') and v.ClassName == 'Part' and tostring(v.Color) == '0.643137, 0.733333, 0.745098') then
                        return 'Diamond', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v:FindFirstChild('Mesh') and v.Mesh.MeshId == 'rbxassetid://%202877143560%20' and v:FindFirstChild('ParticleEmitter') and string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0') and v.ClassName == 'Part' and v.Color.G > v.Color.R and v.Color.G > v.Color.B) then
                        return 'Emerald', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v:FindFirstChild('Mesh') and v.Mesh.MeshId == 'rbxassetid://%202877143560%20' and v:FindFirstChild('ParticleEmitter') and string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0') and v.ClassName == 'Part' and v.Color.R > v.Color.G and v.Color.R > v.Color.B) then
                        return 'Ruby', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v:FindFirstChild('Mesh') and v.Mesh.MeshId == 'rbxassetid://%202877143560%20' and v:FindFirstChild('ParticleEmitter') and string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0') and v.ClassName == 'Part' and v.Color.B > v.Color.G and v.Color.B > v.Color.R) then
                        return 'Sapphire', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v.ClassName == 'Part' and v:FindFirstChild('ParticleEmitter') and not string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0')) then
                        return 'Rift Gem', cheat_client.trinket_colors.mythic.Color, cheat_client.trinket_colors.mythic.ZIndex
                    elseif (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://5197099782" and v:FindFirstChild("MeshPart") and v.MeshPart.MeshId == "rbxassetid://5197111525") then
                        return 'Amulet of the White King', cheat_client.trinket_colors.artifact.Color, cheat_client.trinket_colors.artifact.ZIndex
                    elseif (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://5196963069" and v:FindFirstChild("MeshPart") and v.MeshPart.MeshId == "rbxassetid://5196975152") then
                        return 'Lannis Amulet', cheat_client.trinket_colors.artifact.Color, cheat_client.trinket_colors.artifact.ZIndex
                    elseif (v:FindFirstChild('Attachment') and v.Attachment:FindFirstChildOfClass('ParticleEmitter') and v.Attachment:FindFirstChildOfClass('ParticleEmitter').Rate == 3) then
                        return 'Mysterious Artifact', cheat_client.trinket_colors.mythic.Color, cheat_client.trinket_colors.mythic.ZIndex

                    elseif (v:IsA('MeshPart') and v.MeshId == "rbxassetid://4103271893") then
                        return 'Candy', cheat_client.trinket_colors.event.Color, cheat_client.trinket_colors.event.ZIndex
                    elseif v.ClassName == "UnionOperation" then
                        local assetId = gethiddenproperty(v, "AssetId"):gsub("%%20", ""):match("%d+")
                        if in_table(masks, assetId) then
                            return "Scary Mask", cheat_client.trinket_colors.event.Color, cheat_client.trinket_colors.event.ZIndex
                        end

                    elseif (v.ClassName == 'UnionOperation' and gethiddenproperty(v, "AssetId"):gsub("%%20", ""):match("%d+") == "4117970107") then
                        return 'Pumpkin Centerpiece', cheat_client.trinket_colors.event.Color, cheat_client.trinket_colors.event.ZIndex

                        
                    elseif (v:FindFirstChild('Attachment') and v.Attachment:FindFirstChildOfClass('ParticleEmitter') and v.Attachment:FindFirstChildOfClass('ParticleEmitter').Rate == 5 and tostring(v.Attachment:FindFirstChildOfClass('ParticleEmitter').Color):split(" ")[3] ~= "0.8") then
                        local name = (game.PlaceId == 3541987450) and 'Phoenix Flower' or 'Azael Horn'
                        return name, cheat_client.trinket_colors.mythic.Color, cheat_client.trinket_colors.mythic.ZIndex
                    
                    elseif (v:FindFirstChild('Attachment') and v.Attachment:FindFirstChildOfClass('ParticleEmitter') and v.Attachment:FindFirstChildOfClass('ParticleEmitter').Rate == 5 and tostring(v.Attachment:FindFirstChildOfClass('ParticleEmitter').Color):split(" ")[3]=="0.8") then
                        return 'Phoenix Down', cheat_client.trinket_colors.artifact.Color, cheat_client.trinket_colors.artifact.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.BrickColor.Name == 'Black') then
                        return 'Night Stone', cheat_client.trinket_colors.artifact.Color, cheat_client.trinket_colors.artifact.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://%202520762076%20') then
                        return 'Howler Friend', cheat_client.trinket_colors.artifact.Color, cheat_client.trinket_colors.artifact.ZIndex
                    elseif (v.ClassName == 'Part' and v:FindFirstChild('OrbParticle') and string.match(tostring(v.OrbParticle.Color), '0 0.105882 0.596078 0.596078 0 1 0.105882 0.596078 0.596078 0 ')) then
                        return 'Ice Essence', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    end

                    if game.PlaceId == 3541987450 then
                        if (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://4027112893" and v:FindFirstChild("Part")) then
                            return 'Bound Book', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                        elseif (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://%202877143560%20" and v.Color.B < v.Color.G and v.Color.B > v.Color.R) then
                            return 'Emerald', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZInde
                        elseif (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://%202877143560%20" and v.Color.R > v.Color.G and v.Color.R > v.Color.B) then
                            return 'Ruby', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                        elseif (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://%202877143560%20" and v.Color.B > v.Color.R and v.Color.B > v.Color.G) then
                            return 'Sapphire', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                        elseif (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://%202877143560%20" and tostring(v.Color) == '0.643137, 0.733333, 0.745098') then
                            return 'Diamond', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                        end
                    end

                    return "Opal", cheat_client.trinket_colors.none.Color, cheat_client.trinket_colors.none.ZIndex
                end
        
                function cheat_client:add_trinket_esp(trinket, name, color, zindex)
                    local esp = {
                        object = trinket,
                        name = name,
                        color = color,
                        zindex = zindex or -10,
                        drawings = {},
                        area = "Unknown",
                        already_disabled = false,
                        cached_text = "",
                        last_text_update = 0,
                        text_update_interval = 0.2,
                    }
                    
                    local function detectTrinketArea()
                        if not ws:FindFirstChild("AreaMarkers") then return "None" end
                        
                        local LocationName = "None"
                        local LocationNumSq = math.huge
                        local Area = ws.AreaMarkers
                        local trinketPos = trinket.Position
                        
                        for i,v in pairs(Area:GetChildren()) do
                            local diff = trinketPos - v.Position
                            local distSq = diff.X * diff.X + diff.Y * diff.Y + diff.Z * diff.Z
                            if distSq < LocationNumSq then
                                LocationName = v.Name
                                LocationNumSq = distSq
                            end
                        end
                        
                        return LocationName
                    end
                    
                    esp.area = detectTrinketArea()
    
                    do -- Create Drawings
                        esp.drawings.main_text = utility:Create("Text", {
                            Center = true,
                            Outline = true,
                            Color = esp.color,
                            Transparency = 1,
                            Text = esp.name,
                            Size = 13,
                            Font = 2,
                            ZIndex = esp.zindex,
                            Visible = false
                        }, "esp")
                    end
    
                    function esp:destruct()
                        for _,v in next, esp.drawings do
                            fast_remove(shared.drawing_containers.esp, v)
                            v:Remove()
                        end

                        if cheat_client.trinket_esp_objects then
                            cheat_client.trinket_esp_objects[esp.object] = nil
                        end
                    end
    
                    local function update_trinket_esp(toggled)
                        if not toggled then
                            if not esp.already_disabled then
                                esp.drawings.main_text.Visible = false
                                esp.already_disabled = true
                            end
                            return
                        end

                        if Options and Options.TrinketTypes and Options.TrinketTypes.Value then
                            local filters = Options.TrinketTypes.Value
                            local should_show = false

                            if esp.color == cheat_client.trinket_colors.common.Color and filters["Common"] then
                                should_show = true
                            elseif esp.color == cheat_client.trinket_colors.rare.Color and filters["Rare"] then
                                should_show = true
                            elseif esp.color == cheat_client.trinket_colors.mythic.Color and filters["Mythic"] then
                                should_show = true
                            elseif esp.color == cheat_client.trinket_colors.artifact.Color and filters["Artifact"] then
                                should_show = true
                            elseif esp.color == cheat_client.trinket_colors.event.Color and filters["Event"] then
                                should_show = true
                            end

                            if not should_show then
                                esp.drawings.main_text.Visible = false
                                return
                            end
                        end

                        esp.already_disabled = false
                        if esp.object.Parent ~= nil then
                            if cheat_client.window_active then
                                local camera = ws.CurrentCamera
                                local objectPos = esp.object.CFrame.Position
                                local distance = (camera.CFrame.Position - objectPos).Magnitude

                                local ignore_range = false
                                if Options and Options.TrinketIgnoreRangeTypes and Options.TrinketIgnoreRangeTypes.Value then
                                    local ignore_types = Options.TrinketIgnoreRangeTypes.Value

                                    if (esp.color == cheat_client.trinket_colors.common.Color and ignore_types["Common"]) or
                                       (esp.color == cheat_client.trinket_colors.rare.Color and ignore_types["Rare"]) or
                                       (esp.color == cheat_client.trinket_colors.mythic.Color and ignore_types["Mythic"]) or
                                       (esp.color == cheat_client.trinket_colors.artifact.Color and ignore_types["Artifact"]) or
                                       (esp.color == cheat_client.trinket_colors.event.Color and ignore_types["Event"]) then

                                        if Options and Options.TrinketTypes and Options.TrinketTypes.Value then
                                            local filters = Options.TrinketTypes.Value
                                            if (esp.color == cheat_client.trinket_colors.common.Color and filters["Common"]) or
                                               (esp.color == cheat_client.trinket_colors.rare.Color and filters["Rare"]) or
                                               (esp.color == cheat_client.trinket_colors.mythic.Color and filters["Mythic"]) or
                                               (esp.color == cheat_client.trinket_colors.artifact.Color and filters["Artifact"]) or
                                               (esp.color == cheat_client.trinket_colors.event.Color and filters["Event"]) then
                                                ignore_range = true
                                            end
                                        end
                                    end
                                end

                                if not ignore_range and distance >= ((Options and Options.TrinketRange and Options.TrinketRange.Value) or 75) then
                                    esp.drawings.main_text.Visible = false
                                    return
                                end

                                local screen_position, on_screen = camera:WorldToViewportPoint(objectPos)

                                if not on_screen then
                                    esp.drawings.main_text.Visible = false
                                    return
                                end

                                local now = tick()
                                local should_update_text = (now - esp.last_text_update) >= esp.text_update_interval

                                if should_update_text then
                                    local area_text = (esp.area ~= "None" and Toggles and Toggles.TrinketShowArea and Toggles.TrinketShowArea.Value) and " ("..esp.area..")" or ""
                                    esp.cached_text = esp.name.."\n["..tostring(math.floor(distance)).."]"..area_text
                                    esp.last_text_update = now
                                end

                                esp.drawings.main_text.Text = esp.cached_text
                                esp.drawings.main_text.Position = Vector2.new(screen_position.X, screen_position.Y)
                                esp.drawings.main_text.Visible = true
                            else
                                esp.drawings.main_text.Visible = false
                            end
                        else
                            esp:destruct()
                        end
                    end

                    esp.update_trinket_esp = update_trinket_esp
                    cheat_client.trinket_esp_objects[trinket] = esp
                    return esp
                end
            end
            
            do -- Fallions
                if game.PlaceId == 5208655184 or game.PlaceId == 109732117428502 then
                    cheat_client.fallion_esp_objects = cheat_client.fallion_esp_objects or {}
                    
                    function cheat_client:add_fallion_esp(npc, name)
                        local esp = {
                            object = npc,
                            name = "[" .. name .. "]",
                            color = Color3.fromRGB(255, 115, 229),
                            drawings = {},
                            already_disabled = false,
                        }
            
                        do -- Create Drawings
                            esp.drawings.main_text = utility:Create("Text", {
                                Center = true,
                                Outline = true,
                                Color = esp.color,
                                Transparency = 1,
                                Text = esp.name,
                                Size = 13,
                                Font = 2,
                                ZIndex = -10,
                                Visible = false
                            }, "esp")
                        end
            
                        function esp:destruct()
                            for _, v in next, esp.drawings do
                                fast_remove(shared.drawing_containers.esp, v)
                                v:Remove()
                            end

                            if cheat_client.fallion_esp_objects then
                                cheat_client.fallion_esp_objects[esp.object] = nil
                            end
                        end
            
                        local function update_fallion_esp(toggled)
                            if not toggled then
                                if not esp.already_disabled then
                                    esp.drawings.main_text.Visible = false
                                    esp.already_disabled = true
                                end
                                return
                            end
                            
                            esp.already_disabled = false
                            if esp.object.Parent ~= nil then
                                if cheat_client.window_active then
                                    local distance = (ws.CurrentCamera.CFrame.Position - esp.object.HumanoidRootPart.CFrame.Position).Magnitude
                                    local screen_position, on_screen = ws.CurrentCamera:WorldToViewportPoint(esp.object.HumanoidRootPart.CFrame.Position)
                                    
                                    if not on_screen then
                                        esp.drawings.main_text.Visible = false
                                        return
                                    end
            
                                    esp.drawings.main_text.Text = esp.name .. "\n[" .. tostring(math.floor(distance)) .. "]"
                                    esp.drawings.main_text.Position = Vector2.new(screen_position.X, screen_position.Y)
                                    esp.drawings.main_text.Visible = true
                                else
                                    esp.drawings.main_text.Visible = false
                                end
                            else
                                esp:destruct()
                            end
                        end

                        esp.update_fallion_esp = update_fallion_esp
                        cheat_client.fallion_esp_objects[npc] = esp
                        return esp
                    end
                end
            end            
            
            do -- NPC ESP
                cheat_client.npc_esp_objects = cheat_client.npc_esp_objects or {}
                
                function cheat_client:add_npc_esp(npc,name)
                     local esp = {
                        object = npc,
                        name = "["..name.."]",
                        color = npc.Torso.Color,
                        drawings = {},
                        already_disabled = false,
                     }
            
                     do -- Create Drawings
                        esp.drawings.main_text = utility:Create("Text", {
                           Center = true,
                           Outline = true,
                           Color = esp.color,
                           Transparency = 1,
                           Text = esp.name,
                           Size = 13,
                           Font = 2,
                           ZIndex = -10,
                           Visible = false
                        }, "esp")
                     end
            
                     function esp:destruct()
                        for _,v in next, esp.drawings do
                           fast_remove(shared.drawing_containers.esp, v)
                           v:Remove()
                        end

                        if cheat_client.npc_esp_objects then
                            cheat_client.npc_esp_objects[esp.object] = nil
                        end
                     end
            
                    local function update_npc_esp(toggled)
                        if not toggled then
                            if not esp.already_disabled then
                                esp.drawings.main_text.Visible = false
                                esp.already_disabled = true
                            end
                            return
                        end
                        
                        esp.already_disabled = false
                        if esp.object.Parent ~= nil then
                            if cheat_client.window_active then
                                local distance = (ws.CurrentCamera.CFrame.Position - esp.object.HumanoidRootPart.CFrame.Position).Magnitude
                                local screen_position, on_screen = ws.CurrentCamera:WorldToViewportPoint(esp.object.HumanoidRootPart.CFrame.Position)
                                
                                if not on_screen then
                                    esp.drawings.main_text.Visible = false
                                    return
                                end
                                
                                esp.drawings.main_text.Text = esp.name.."\n["..tostring(math.floor(distance)).."]"
                                esp.drawings.main_text.Position = Vector2.new(screen_position.X, screen_position.Y)
                                esp.drawings.main_text.Visible = true
                            else
                                esp.drawings.main_text.Visible = false
                            end
                        else
                            esp:destruct()
                        end
                    end

                    esp.update_npc_esp = update_npc_esp

                    cheat_client.npc_esp_objects[npc] = esp
                    return esp
                end
            end
    
            do -- Ingredient
                if game.PlaceId ~= 3541987450 then
                    cheat_client.ingredient_esp_objects = cheat_client.ingredient_esp_objects or {}

                    function cheat_client:identify_ingredient(object)
                        local asset_id = gethiddenproperty(object, "AssetId"):gsub("%%20", ""):match("%d+")
                        local matched_ingredient = cheat_client.ingredient_identifiers[asset_id]
            
                        if matched_ingredient then
                            return matched_ingredient
                        end
                    end
        
                    function cheat_client:add_ingredient_esp(ingredient, name)
                        local esp = {
                            object = ingredient,
                            name = name or ingredient.Name or "Unknown",
                            color = ingredient.Color,
                            drawings = {},
                            already_disabled = false,
                            cached_text = "",
                            last_text_update = 0,
                            text_update_interval = 0.5,
                        }
        
                        do -- Create Drawings
                            esp.drawings.main_text = utility:Create("Text", {
                                Center = true,
                                Outline = true,
                                Color = esp.color,
                                Transparency = 1,
                                Text = esp.name,
                                Size = 13,
                                Font = 2,
                                ZIndex = -10,
                                Visible = false
                            }, "esp")
                        end
        
                        function esp:destruct()
                            for _,v in next, esp.drawings do
                                fast_remove(shared.drawing_containers.esp, v)
                                v:Remove()
                            end

                            if cheat_client.ingredient_esp_objects then
                                cheat_client.ingredient_esp_objects[esp.object] = nil
                            end
                        end
        
                        local function update_ingredient_esp(toggled)
                            if not toggled then
                                if not esp.already_disabled then
                                    esp.drawings.main_text.Visible = false
                                    esp.already_disabled = true
                                end
                                return
                            end
                            
                            esp.already_disabled = false
                            
                            if esp.object.Parent ~= nil then
                                if cheat_client.window_active then
                                    if esp.object.Transparency ~= 1 then
                                        local distance = (ws.CurrentCamera.CFrame.Position - esp.object.CFrame.Position).Magnitude

                                        if distance >= ((Options and Options.IngredientRange and Options.IngredientRange.Value) or 60) then
                                            esp.drawings.main_text.Visible = false
                                            return
                                        end

                                        if (distance < ((Options and Options.IngredientRange and Options.IngredientRange.Value) or 60)) then
                                            local screen_position, on_screen = ws.CurrentCamera:WorldToViewportPoint(esp.object.CFrame.Position)

                                            if not on_screen then
                                                esp.drawings.main_text.Visible = false
                                                return
                                            end

                                            local now = tick()
                                            local should_update_text = (now - esp.last_text_update) >= esp.text_update_interval

                                            if should_update_text then
                                                esp.cached_text = (esp.name or "Unknown") .. "\n[" .. tostring(math.floor(distance)) .. "]"
                                                esp.last_text_update = now
                                            end

                                            esp.drawings.main_text.Text = esp.cached_text
                                            esp.drawings.main_text.Position = Vector2.new(screen_position.X, screen_position.Y)
                                            esp.drawings.main_text.Visible = true
                                        else
                                            esp.drawings.main_text.Visible = false
                                        end
                                    else
                                        esp.drawings.main_text.Visible = false
                                    end
                                else
                                    esp.drawings.main_text.Visible = false
                                end
                            else
                                esp:destruct()
                            end
                        end

                        esp.update_ingredient_esp = update_ingredient_esp
                        cheat_client.ingredient_esp_objects[ingredient] = esp
                        return esp
                    end
                end
            end

            do -- Ore
                cheat_client.ore_esp_objects = cheat_client.ore_esp_objects or {}

                function cheat_client:add_ore_esp(ore)
                    local esp = {
                        object = ore,
                        name = ore.Name,
                        color = ore.Color,
                        drawings = {},
                        already_disabled = false,
                        cached_text = "",
                        last_text_update = 0,
                        text_update_interval = 0.2,
                    }
    
                    do -- Create Drawings
                        esp.drawings.main_text = utility:Create("Text", {
                            Center = true,
                            Outline = true,
                            Color = esp.color,
                            Transparency = 1,
                            Text = esp.name,
                            Size = 13,
                            Font = 2,
                            ZIndex = -10,
                            Visible = false
                        }, "esp")
                    end
    
                    function esp:destruct()
                        for _,v in next, esp.drawings do
                            fast_remove(shared.drawing_containers.esp, v)
                            v:Remove()
                        end

                        if cheat_client.ore_esp_objects then
                            cheat_client.ore_esp_objects[esp.object] = nil
                        end
                    end
    
                    local function update_ore_esp(toggled)
                        local oreToggleName = esp.name:lower() .. "_esp"
                        local oreToggleExists = Toggles and Toggles[oreToggleName] and Toggles[oreToggleName].Value
                        if not toggled or not oreToggleExists then
                            if not esp.already_disabled then
                                esp.drawings.main_text.Visible = false
                                esp.already_disabled = true
                            end
                            return
                        end
                        
                        esp.already_disabled = false
                        
                        if esp.object.Parent ~= nil and esp.object.Transparency ~= 1 then
                            if cheat_client.window_active then
                                local distance = (ws.CurrentCamera.CFrame.Position - esp.object.CFrame.Position).Magnitude
                                
                                if distance >= ((Options and Options.ore_range and Options.ore_range.Value) or 50) then
                                    esp.drawings.main_text.Visible = false
                                    return
                                end
                                
                                if distance < ((Options and Options.ore_range and Options.ore_range.Value) or 50) then
                                    local screen_position, on_screen = ws.CurrentCamera:WorldToViewportPoint(esp.object.CFrame.Position)


                                    if not on_screen then
                                        esp.drawings.main_text.Visible = false
                                        return
                                    end

                                    -- Text update throttling - only recalculate strings every 0.5s
                                    local now = tick()
                                    local should_update_text = (now - esp.last_text_update) >= esp.text_update_interval

                                    if should_update_text then
                                        esp.cached_text = esp.name.."\n["..tostring(math.floor(distance)).."]"
                                        esp.last_text_update = now
                                    end

                                    esp.drawings.main_text.Text = esp.cached_text
                                    esp.drawings.main_text.Position = Vector2.new(screen_position.X, screen_position.Y)
                                    esp.drawings.main_text.Visible = true
                                else
                                    esp.drawings.main_text.Visible = false
                                end
                            else
                                esp.drawings.main_text.Visible = false
                            end                            
                        else
                            esp.drawings.main_text.Visible = false
                        end
                    end

                    esp.update_ore_esp = update_ore_esp
                    cheat_client.ore_esp_objects[ore] = esp
                    return esp
                end
            end
            
            do -- Shrieker Chams
                function cheat_client:get_shrieker_color(shrieker)
                    if shrieker and shrieker:FindFirstChild("MonsterInfo") then
                        if shrieker.MonsterInfo:FindFirstChild("Master") then
                            if not plr.Character then
                                return Color3.fromRGB(255, 0, 80) -- enemy if no character
                            elseif shrieker.MonsterInfo.Master.Value == plr.Character then
                                return Color3.fromRGB(0, 255, 255) -- owned
                            else
                                return Color3.fromRGB(255, 0, 80) -- enemy
                            end
                        end
                    end
                    return Color3.fromRGB(255, 255, 255) -- neutral
                end

                function cheat_client:add_shrieker_chams(shrieker)
                    local chams = {
                        object = shrieker,
                        highlight = nil,
                        already_disabled = false,
                    }

                    chams.highlight = utility:Object("Highlight", {
                        Parent = hidden_folder,
                        Adornee = shrieker,
                        Enabled = true,
                        FillColor = cheat_client:get_shrieker_color(shrieker),
                        FillTransparency = 0.65,
                        OutlineColor = Color3.fromRGB(255, 255, 255),
                        OutlineTransparency = 0.5,
                    }, "esp")

                    function chams:destruct()
                        chams.update_connection:Disconnect()
                        chams.highlight:Destroy()
                    end

                    local function update_shrieker_chams(toggled)
                        if not toggled then
                            if not chams.already_disabled then
                                chams.highlight.Enabled = false
                                chams.already_disabled = true
                            end
                            return
                        end

                        chams.already_disabled = false

                        if not chams.object.Parent then
                            chams:destruct()
                            return
                        end

                        if not cheat_client.window_active then
                            chams.highlight.Enabled = false
                            return
                        end

                        local shriek_hrp = chams.object:FindFirstChild("HumanoidRootPart")
                        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

                        if not shriek_hrp then
                            chams.highlight.Enabled = false
                            return
                        end

                        if not hrp then
                            chams.highlight.FillColor = Color3.fromRGB(255, 0, 80)
                            chams.highlight.Enabled = true
                            return
                        end

                        local dist = (hrp.Position - shriek_hrp.Position).Magnitude
                        if dist > 800 then
                            chams.highlight.Enabled = false
                            return
                        end

                        chams.highlight.FillColor = cheat_client:get_shrieker_color(chams.object)
                        chams.highlight.Enabled = true
                    end

                    local last_update = 0
                    local UPDATE_INTERVAL = 1/2 -- 30 FPS

                    chams.update_connection = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                        local now = tick()
                        if now - last_update >= UPDATE_INTERVAL then
                            local isShriekerChamsEnabled = Toggles and Toggles.ShriekerChams and Toggles.ShriekerChams.Value or false
                            update_shrieker_chams(isShriekerChamsEnabled)
                            last_update = now
                        end
                    end))

                    return chams
                end
            end

            do -- Event-Driven ESP Rendering System
                -- Store rendering connections (only active when toggles are enabled)
                local esp_render_connections = {
                    player_esp = nil,
                    player_chams = nil,
                    trinket_esp = nil,
                    fallion_esp = nil,
                    npc_esp = nil,
                    ingredient_esp = nil,
                    ore_esp = nil
                }

                -- Player ESP Connection Manager (Optimized)
                local function start_player_esp_rendering()
                    if esp_render_connections.player_esp then return end

                    local frame_count = 0
                    esp_render_connections.player_esp = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        --frame_count = frame_count + 1

                        -- Limit to 30fps for all ESP updates (smooth but not excessive)
                        --if frame_count % 2 ~= 0 then return end

                        for player, esp in pairs(cheat_client.player_esp_objects or {}) do
                            if esp.update_player_esp then
                                esp.update_player_esp(true)
                            end
                        end
                    end))
                end

                local function stop_player_esp_rendering()
                    if esp_render_connections.player_esp then
                        esp_render_connections.player_esp:Disconnect()
                        esp_render_connections.player_esp = nil

                        -- Hide all ESP elements
                        for player, esp in pairs(cheat_client.player_esp_objects or {}) do
                            if esp.update_player_esp then
                                esp.update_player_esp(false)
                            end
                        end
                    end
                end

                -- Player Chams Connection Manager
                local function is_any_chams_enabled()
                    -- Check master toggle first
                    if not (Toggles and Toggles.PlayerChams and Toggles.PlayerChams.Value) then
                        return false
                    end

                    return (Toggles and Toggles.PlayerAimbotChams and Toggles.PlayerAimbotChams.Value) or
                           (Toggles and Toggles.PlayerFriendlyChams and Toggles.PlayerFriendlyChams.Value) or
                           (Toggles and Toggles.PlayerLowHealth and Toggles.PlayerLowHealth.Value) or
                           (Toggles and Toggles.PlayerRacialChams and Toggles.PlayerRacialChams.Value)
                end

                local function start_player_chams_rendering()
                    if esp_render_connections.player_chams then return end

                    local frame_count = 0
                    esp_render_connections.player_chams = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                        frame_count = frame_count + 1

                        -- Limit to ~25fps - chams are Roblox Highlight objects
                        if frame_count % 2 ~= 0 then return end

                        for player, esp in pairs(cheat_client.player_esp_objects or {}) do
                            if esp.update_player_chams then
                                esp.update_player_chams()
                            end
                        end
                    end))
                end

                local function stop_player_chams_rendering()
                    if esp_render_connections.player_chams then
                        esp_render_connections.player_chams:Disconnect()
                        esp_render_connections.player_chams = nil
                    end
                end

                local function update_chams_rendering()
                    if is_any_chams_enabled() then
                        -- Ensure table exists
                        cheat_client.player_esp_objects = cheat_client.player_esp_objects or {}

                        -- Create ESP objects if they don't exist (chams need the objects)
                        for _, player in pairs(plrs:GetPlayers()) do
                            if player ~= plr and not cheat_client.player_esp_objects[player] then
                                cheat_client.player_esp_objects[player] = cheat_client:add_player_esp(player)
                            end
                        end
                        start_player_chams_rendering()
                    else
                        stop_player_chams_rendering()
                        if not (Toggles and Toggles.PlayerEsp and Toggles.PlayerEsp.Value) then
                            for player, esp in pairs(cheat_client.player_esp_objects or {}) do
                                if esp and esp.destruct then
                                    esp:destruct()
                                end
                                if cheat_client.player_esp_objects then
                                    cheat_client.player_esp_objects[player] = nil
                                end
                            end
                        end
                    end
                end

                -- Trinket ESP Connection Manager
                local function start_trinket_esp_rendering()
                    if esp_render_connections.trinket_esp then return end

                    local frame_count = 0
                    esp_render_connections.trinket_esp = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        frame_count = frame_count + 1
                        if frame_count % 2 ~= 0 then return end

                        for trinket, esp in pairs(cheat_client.trinket_esp_objects or {}) do
                            if esp.update_trinket_esp then
                                esp.update_trinket_esp(true)
                            end
                        end
                    end))
                end

                local function stop_trinket_esp_rendering()
                    if esp_render_connections.trinket_esp then
                        esp_render_connections.trinket_esp:Disconnect()
                        esp_render_connections.trinket_esp = nil

                        for trinket, esp in pairs(cheat_client.trinket_esp_objects or {}) do
                            if esp.update_trinket_esp then
                                esp.update_trinket_esp(false)
                            end
                        end
                    end
                end

                -- Fallion ESP Connection Manager
                local function start_fallion_esp_rendering()
                    if esp_render_connections.fallion_esp then return end

                    local frame_count = 0
                    esp_render_connections.fallion_esp = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        frame_count = frame_count + 1

                        -- Limit to 30fps
                        if frame_count % 2 ~= 0 then return end

                        for npc, esp in pairs(cheat_client.fallion_esp_objects or {}) do
                            if esp.update_fallion_esp then
                                esp.update_fallion_esp(true)
                            end
                        end
                    end))
                end

                local function stop_fallion_esp_rendering()
                    if esp_render_connections.fallion_esp then
                        esp_render_connections.fallion_esp:Disconnect()
                        esp_render_connections.fallion_esp = nil

                        for npc, esp in pairs(cheat_client.fallion_esp_objects or {}) do
                            if esp.update_fallion_esp then
                                esp.update_fallion_esp(false)
                            end
                        end
                    end
                end

                -- NPC ESP Connection Manager
                local function start_npc_esp_rendering()
                    if esp_render_connections.npc_esp then return end

                    local frame_count = 0
                    esp_render_connections.npc_esp = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        frame_count = frame_count + 1

                        -- Limit to 30fps
                        if frame_count % 2 ~= 0 then return end

                        for npc, esp in pairs(cheat_client.npc_esp_objects or {}) do
                            if esp.update_npc_esp then
                                esp.update_npc_esp(true)
                            end
                        end
                    end))
                end

                local function stop_npc_esp_rendering()
                    if esp_render_connections.npc_esp then
                        esp_render_connections.npc_esp:Disconnect()
                        esp_render_connections.npc_esp = nil

                        for npc, esp in pairs(cheat_client.npc_esp_objects or {}) do
                            if esp.update_npc_esp then
                                esp.update_npc_esp(false)
                            end
                        end
                    end
                end

                -- Ingredient ESP Connection Manager
                local function start_ingredient_esp_rendering()
                    if esp_render_connections.ingredient_esp then return end

                    local frame_count = 0
                    esp_render_connections.ingredient_esp = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        frame_count = frame_count + 1
                        if frame_count % 2 ~= 0 then return end

                        for ingredient, esp in pairs(cheat_client.ingredient_esp_objects or {}) do
                            if esp.update_ingredient_esp then
                                esp.update_ingredient_esp(true)
                            end
                        end
                    end))
                end

                local function stop_ingredient_esp_rendering()
                    if esp_render_connections.ingredient_esp then
                        esp_render_connections.ingredient_esp:Disconnect()
                        esp_render_connections.ingredient_esp = nil

                        for ingredient, esp in pairs(cheat_client.ingredient_esp_objects or {}) do
                            if esp.update_ingredient_esp then
                                esp.update_ingredient_esp(false)
                            end
                        end
                    end
                end

                -- Ore ESP Connection Manager
                local function start_ore_esp_rendering()
                    if esp_render_connections.ore_esp then return end

                    local frame_count = 0
                    esp_render_connections.ore_esp = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        frame_count = frame_count + 1
                        if frame_count % 2 ~= 0 then return end  -- 30fps throttle

                        for ore, esp in pairs(cheat_client.ore_esp_objects or {}) do
                            if esp.update_ore_esp then
                                esp.update_ore_esp(true)
                            end
                        end
                    end))
                end

                local function stop_ore_esp_rendering()
                    if esp_render_connections.ore_esp then
                        esp_render_connections.ore_esp:Disconnect()
                        esp_render_connections.ore_esp = nil

                        for ore, esp in pairs(cheat_client.ore_esp_objects or {}) do
                            if esp.update_ore_esp then
                                esp.update_ore_esp(false)
                            end
                            if esp.destruct then
                                esp:destruct()
                            end
                        end
                        cheat_client.ore_esp_objects = {}
                    end
                end

                -- Store functions in cheat_client for access from OnChanged handlers
                cheat_client.esp_rendering = {
                    start_player_esp = start_player_esp_rendering,
                    stop_player_esp = stop_player_esp_rendering,
                    update_chams = update_chams_rendering,
                    start_trinket_esp = start_trinket_esp_rendering,
                    stop_trinket_esp = stop_trinket_esp_rendering,
                    start_fallion_esp = start_fallion_esp_rendering,
                    stop_fallion_esp = stop_fallion_esp_rendering,
                    start_npc_esp = start_npc_esp_rendering,
                    stop_npc_esp = stop_npc_esp_rendering,
                    start_ingredient_esp = start_ingredient_esp_rendering,
                    stop_ingredient_esp = stop_ingredient_esp_rendering,
                    start_ore_esp = start_ore_esp_rendering,
                    stop_ore_esp = stop_ore_esp_rendering
                }
            end

            do -- Feature Connection Management (Freecam, Flight, Day Farm, etc.)
                local feature_connections = {
                    freecam = nil,
                    flight = nil,
                    day_farm = nil,
                    auto_trinket = nil,
                    auto_ingredient = nil,
                    status_updates = nil,
                    silent_aim = nil,
                    proximity_notifier = nil
                }

                -- Store for access from toggle OnChanged handlers
                cheat_client.feature_connections = feature_connections
            end
        end

        do -- Environment
            local function set_ambience(area)
                local biome = area_data.biomes[area]
                if biome then
                    local area_color
                    if biome == "desert" or biome == "oasis" then
                        area_color = lit.desertcolor
                    elseif biome == "tundraoutside" then
                        area_color = lit.tundracolor
                    elseif biome == "tundrainside" or biome == "tundracastle" then
                        area_color = lit.tundrainsidecolor
                    elseif biome == "lava" then
                        area_color = lit.lavacolor
                    else
                        area_color = lit.defaultcolor
                    end
                    if area_color ~= nil then
                        lit.areacolor.Brightness = area_color.Brightness
                        lit.areacolor.Contrast = area_color.Contrast
                        lit.areacolor.Saturation = area_color.Saturation
                        lit.areacolor.TintColor = area_color.TintColor
                    end
                    local sun_rays = false
                    if biome ~= "tundrainside" then
                        sun_rays = false
                        if biome ~= "tundraoutside" then
                            sun_rays = biome ~= "tundracastle"
                        end
                    end

                    if biome == "forest_seasonal" then
                        biome = workspace:FindFirstChild("GaiaFallDecor") and "forestfall" or workspace:FindFirstChild("GaiaWinterDecor") and "forestwinter" or "forest";
                    end;

                    lit.SunRays.Enabled = sun_rays
                    local ambience = nil
                    local brightness = nil
                    local outdoor_ambience = nil
                    local fog = nil
                    local fog_color = nil
                    if biome == "forest" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 1.15
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(163, 181, 177)
                        }
                        fog = {
                            FogStart = 0, 
                            FogEnd = 750
                        }
                        fog_color = {
                            Value = Color3.fromRGB(91, 159, 157)
                        }
                    elseif biome == "darkforest" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 0.6
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(163, 181, 177)
                        }
                        fog = {
                            FogStart = 0, 
                            FogEnd = 120
                        }
                        fog_color = {
                            Value = Color3.fromRGB(25, 85, 60)
                        }
                    elseif biome == "cave" or biome == "theabyss" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 0
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(11, 13, 12)
                        }
                        fog = {
                            FogStart = 0, 
                            FogEnd = 80
                        }
                        fog_color = {
                            Value = Color3.fromRGB(25, 44, 43)
                        }
                    elseif biome == "darkcave" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 0
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(11, 13, 12)
                        }
                        fog = {
                            FogStart = 0, 
                            FogEnd = 50
                        }
                        fog_color = {
                            Value = Color3.fromRGB(17, 17, 17)
                        }
                    elseif biome == "desert" or biome == "oasis" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 1.25
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(127, 126, 101)
                        }
                        fog = {
                            FogStart = 150, 
                            FogEnd = 2000
                        }
                        fog_color = {
                            Value = Color3.fromRGB(147, 130, 109)
                        }
                    elseif biome == "tundraoutside" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 1.5
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(136, 136, 136)
                        }
                        fog = {
                            FogStart = 40, 
                            FogEnd = 200
                        }
                        fog_color = {
                            Value = Color3.fromRGB(240, 255, 240)
                        }
                    elseif biome == "tundrainside" or biome == "tundracastle" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 1.5
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(136, 136, 136)
                        }
                        fog = {
                            FogStart = 100, 
                            FogEnd = 200
                        }
                        fog_color = {
                            Value = Color3.fromRGB(255, 255, 255)
                        }
                    elseif biome == "lava" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 0.5
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(239, 15, 15)
                        }
                        fog = {
                            FogStart = 100, 
                            FogEnd = 1000
                        }
                        fog_color = {
                            Value = Color3.fromRGB(240, 255, 240)
                        }
                    elseif biome == "spooky" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 0.5
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(50, 50, 50)
                        }
                        fog = {
                            FogStart = 0, 
                            FogEnd = 400
                        }
                        fog_color = {
                            Value = Color3.fromRGB(200, 125, 50)
                        }
                    elseif biome == "spookytown" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        };
                        brightness = {
                            Value = 0.5
                        };
                        outdoor_ambience = {
                            Value = Color3.fromRGB(50, 50, 50)
                        };
                        fog = {
                            FogStart = 0, 
                            FogEnd = 180
                        };
                        fog_color = {
                            Value = Color3.fromRGB(171, 105, 43)
                        };
                    elseif biome == "lightwinter" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        };
                        brightness = {
                            Value = 1
                        };
                        outdoor_ambience = {
                            Value = Color3.fromRGB(200, 190, 190)
                        };
                        fog = {
                            FogStart = 200, 
                            FogEnd = 400
                        };
                        fog_color = {
                            Value = Color3.fromRGB(250, 245, 240)
                        };
                    elseif biome == "forestfall" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        };
                        brightness = {
                            Value = 1.15
                        };
                        outdoor_ambience = {
                            Value = Color3.fromRGB(211, 163, 163)
                        };
                        fog = {
                            FogStart = 0, 
                            FogEnd = 750
                        };
                        fog_color = {
                            Value = Color3.fromRGB(208, 175, 123)
                        };
                    elseif biome == "forestwinter" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        };
                        brightness = {
                            Value = 1.15
                        };
                        outdoor_ambience = {
                            Value = Color3.fromRGB(193, 214, 234)
                        };
                        fog = {
                            FogStart = 0, 
                            FogEnd = 750
                        };
                        fog_color = {
                            Value = Color3.fromRGB(159, 212, 227)
                        };
                    end;
        
                    if ambience then
                        lit.Ambient = ambience.Ambient
                    end
        
                    if brightness then
                        lit.Brightness = brightness.Value
                    end
        
                    if outdoor_ambience then
                        lit.OutdoorAmbient = outdoor_ambience.Value
                    end
        
                    if fog then
                        if fog.FogEnd then
                            fog.FogEnd = fog.FogEnd * 1.5
                        end
                        lit.FogStart = fog.FogStart
                        lit.FogEnd = fog.FogEnd
                    end
        
                    if fog_color then
                        lit.FogColor = fog_color.Value
                    end
                end
            end

            local is_restoring_ambience = false
            function cheat_client:restore_ambience()
                if is_restoring_ambience then return end
                is_restoring_ambience = true

                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local ray_result = ws:FindPartOnRayWithWhitelist(Ray.new(plr.Character:FindFirstChild("HumanoidRootPart").Position, Vector3.new(0, 1000, 0)), { area_markers })
                    if ray_result then
                        last_area_restore = ray_result.Name
                        set_ambience(ray_result.Name)
                    else
                        if last_area_restore then
                            set_ambience(last_area_restore)
                        end
                    end
            
                    if lit:FindFirstChild("TimeBrightness") and lit:FindFirstChild("AreaOutdoor") and lit:FindFirstChild("AreaFog")  then
                        local time_brightness = lit.TimeBrightness.Value
                        local area_outdoor = lit.AreaOutdoor.Value
                        local area_fog = lit.AreaFog.Value
                        local color_shift = 0.4 + time_brightness * 0.6
                        lit.Brightness = time_brightness * lit.AreaBrightness.Value
                        lit.OutdoorAmbient = Color3.new(area_outdoor.r * color_shift, area_outdoor.g * color_shift, area_outdoor.b * color_shift)
                        lit.FogColor = Color3.new(area_fog.r * color_shift, area_fog.g * color_shift, area_fog.b * color_shift)
                    end
                end

                task.defer(function()
                    is_restoring_ambience = false
                end)
            end
        end

        do -- Mana Overlay
            function cheat_client:clear_visuals()
                if spellvis then spellvis.Visible = false end
                if snapvis then snapvis.Visible = false end
            end

            function cheat_client:handle_toggle(state)
                if state then
                    if plr and plr.Character then
                        local tool = plr.Character:FindFirstChildOfClass("Tool")
                        if tool and cheat_client then
                            cheat_client:update_visuals(tool)
                        end
                    end
                else
                    cheat_client:clear_visuals()
                end
            end
        end

        do -- spoof
            function cheat_client:spoof_name(name)
                task.wait(0.186)
                local statGui
            
                if plr.Character and plr.PlayerGui:FindFirstChild("StatGui") then
                    statGui = plr.PlayerGui:FindFirstChild("StatGui")
                    local charShadow = statGui:WaitForChild("Container", 2)
                        and statGui.Container:WaitForChild("CharacterName", 2)
                        and statGui.Container.CharacterName:WaitForChild("Shadow", 2)
            
                    if charShadow then
                        charShadow.Text = string.upper(name)
                        charShadow.Parent.Text = string.upper(name)
                    end
                end
            
                local splitString = {}
                local uber_title = nil

                local name_parts = name:split(",")
                if #name_parts > 1 then
                    local name_part = name_parts[1]:match("^%s*(.-)%s*$")
                    local title_part = name_parts[2]:match("^%s*(.-)%s*$")

                    splitString = name_part:split(" ")
                    uber_title = title_part
                else
                    splitString = name:split(" ")
                end

                -- Handle single-word names by treating them as FirstName only
                local firstName = splitString[1] or ""
                local lastName = splitString[2] or ""

                if game.PlaceId == 5208655184 or game.PlaceId == 109732117428502 then
                    plr:SetAttribute("FirstName", firstName)
                    plr:SetAttribute("LastName", lastName)

                    if uber_title then
                        plr:SetAttribute("UberTitle", uber_title)
                    else
                        plr:SetAttribute("UberTitle", "")
                    end
                elseif plr:FindFirstChild("leaderstats") then
                    local leaderstats = plr.leaderstats
                    if leaderstats:FindFirstChild("FirstName") and leaderstats:FindFirstChild("LastName") then
                        leaderstats.FirstName.Value = firstName
                        leaderstats.LastName.Value = lastName

                        if uber_title and leaderstats:FindFirstChild("UberTitle") then
                            leaderstats.UberTitle.Value = uber_title
                        elseif leaderstats:FindFirstChild("UberTitle") then
                            leaderstats.UberTitle.Value = ""
                        end
                    end
                end
            end

            function cheat_client:apply_streamer(state)
                if state then
                    task.spawn(function()
                        if not original_names[plr] then
                            original_names[plr] = cheat_client:get_name(plr)
                        end

                        local leaderboardGui = plr.PlayerGui:WaitForChild("LeaderboardGui", 30)
                        if not leaderboardGui then return end

                        local mainFrame = leaderboardGui:WaitForChild("MainFrame", 10)
                        if not mainFrame then return end

                        local scrollingFrame = mainFrame:WaitForChild("ScrollingFrame", 10)
                        if not scrollingFrame then return end

                        for _, frame in pairs(scrollingFrame:GetChildren()) do
                            for _, connection in pairs(getconnections(frame.MouseEnter)) do
                                connection:Fire()
                            end
                            task.wait()

                            if string.gsub(frame.Text, "%W", "") == plr.Name and utility then
                                if ragoozer_frame ~= frame then
                                    for _, conn in pairs(disabled_connections) do
                                        if conn then
                                            conn:Enable()
                                        end
                                    end
                                    disabled_connections = {}

                                    for _, connection in pairs(getconnections(frame.MouseEnter)) do
                                        disabled_connections[#disabled_connections + 1] = connection
                                        connection:Disable()
                                    end
                                end

                                ragoozer_frame = frame
                                local ragoozer_conn = utility:Connection(frame.MouseEnter, function()
                                    frame.Text = "Ragoozer"
                                    frame.TextTransparency = 0.3
                                end)
                                streamer_connections[#streamer_connections + 1] = ragoozer_conn

                                for _, connection in pairs(getconnections(frame.MouseLeave)) do
                                    connection:Fire()
                                end
                                break
                            end
                        end

                        if cheat_client.config.custom_name_spoof and cheat_client.config.custom_name_spoof ~= "" then
                            cheat_client:spoof_name(cheat_client.config.custom_name_spoof)
                        elseif cheat_client.last_names and #cheat_client.last_names > 0 then
                            local random_lastname = cheat_client.last_names[math.random(1, #cheat_client.last_names)]
                            cheat_client:spoof_name("Fear " .. random_lastname)
                        end

                        utility:Connection(gui.MenuOpened, function()
                            if busy then return end
                            busy = true

                            rs.RenderStepped:Wait()
                            task.wait(0.05)

                            local robloxGui = cg:FindFirstChild("RobloxGui") or cg:WaitForChild("RobloxGui", 0.5)
                            if not robloxGui then
                                busy = false
                                return
                            end

                            local settingsShield = robloxGui:FindFirstChild("SettingsClippingShield")
                            local maxRetries = 8
                            local retries = 0
                            while (not settingsShield or not settingsShield:FindFirstChild("SettingsShield")) and retries < maxRetries do
                                retries = retries + 1
                                task.wait(0.06)
                                settingsShield = robloxGui:FindFirstChild("SettingsClippingShield")
                            end

                            if not settingsShield or not settingsShield:FindFirstChild("SettingsShield") then
                                warn("SettingsShield not found after retries")
                                busy = false
                                return
                            end

                            local success, players = pcall(function()
                                return settingsShield.SettingsShield
                                    .MenuContainer
                                    .Page
                                    .PageViewClipper
                                    .PageView
                                    .PageViewInnerFrame
                                    .Players
                            end)

                            if not success or not players then
                                warn("Players container missing")
                                busy = false
                                return
                            end

                            local playerLabel = players:FindFirstChild("PlayerLabel" .. plr.Name) or players:WaitForChild("PlayerLabel" .. plr.Name, 0.5)
                            if not playerLabel then
                                warn("PlayerLabel for "..plr.Name.." not found")
                                busy = false
                                return
                            end

                            do
                                playerLabel.NameLabel.Text = "@Ragoozer"
                                playerLabel.DisplayNameLabel.Text = "Ragoozer"
                                playerLabel.Icon.Image = "rbxthumb://type=Avatar&id=87261352&w=100&h=100"

                                local name_conn = utility:Connection(playerLabel.NameLabel:GetPropertyChangedSignal("Text"), function()
                                    if playerLabel.NameLabel.Text ~= "@Ragoozer" then
                                        playerLabel.NameLabel.Text = "@Ragoozer"
                                    end
                                end)
                                streamer_connections[#streamer_connections + 1] = name_conn

                                local display_conn = utility:Connection(playerLabel.DisplayNameLabel:GetPropertyChangedSignal("Text"), function()
                                    if playerLabel.DisplayNameLabel.Text ~= "Ragoozer" then
                                        playerLabel.DisplayNameLabel.Text = "Ragoozer"
                                    end
                                end)
                                streamer_connections[#streamer_connections + 1] = display_conn

                                local icon_conn = utility:Connection(playerLabel.Icon:GetPropertyChangedSignal("Image"), function()
                                    if playerLabel.Icon.Image ~= "rbxthumb://type=Avatar&id=87261352&w=100&h=100" then
                                        playerLabel.Icon.Image = "rbxthumb://type=Avatar&id=87261352&w=100&h=100"
                                    end
                                end)
                                streamer_connections[#streamer_connections + 1] = icon_conn
                            end

                            done = true
                            busy = false
                        end)
                    end)
                else
                    for _, conn in pairs(streamer_connections) do
                        if conn and conn.Connected then
                            conn:Disconnect()
                        end
                    end
                    streamer_connections = {}

                    for _, conn in pairs(disabled_connections) do
                        if conn then
                            conn:Enable()
                        end
                    end
                    disabled_connections = {}

                    if ragoozer_frame then
                        for _, connection in pairs(getconnections(ragoozer_frame.MouseEnter)) do
                            connection:Fire()
                        end
                        ragoozer_frame = nil
                    end

                    if original_names[plr] then
                        cheat_client:spoof_name(original_names[plr])
                        original_names[plr] = nil
                    end
                end
            end
        end

        function cheat_client:spoof_days(days)
            -- Recursion guard
            if cheat_client._spoofing_days then return end
            cheat_client._spoofing_days = true

            local stat_gui = plr.PlayerGui:FindFirstChild("StatGui")
            if not stat_gui then
                cheat_client._spoofing_days = false
                return
            end

            local lives = stat_gui.Container.Health:FindFirstChild("Lives")
            if not lives then
                cheat_client._spoofing_days = false
                return
            end

            -- Get all Roller objects (filter out non-Roller children)
            local rollers = {}
            for _, child in ipairs(lives:GetChildren()) do
                if child.Name == "Roller" and child:FindFirstChild("Char") then
                    table.insert(rollers, child)
                end
            end

            -- Need at least 4 rollers (1 for lives, 3 for days)
            if #rollers < 4 then
                cheat_client._spoofing_days = false
                return
            end

            -- The FIRST roller is for lives count, the rest are for days
            -- Order: [1]=lives, [2]=hundred, [3]=ten, [4]=one (for <1000 days)
            -- For 1000+ days: [1]=lives, [2]=thousand, [3]=hundred, [4]=ten, [5]=one
            local has_thousand = #rollers >= 6

            local thousand, hundred, ten, one
            if has_thousand then
                -- Skip rollers[1] which is lives
                thousand = rollers[2]
                hundred = rollers[3]
                ten = rollers[4]
                one = rollers[5]
            else
                -- Skip rollers[1] which is lives
                hundred = rollers[2]
                ten = rollers[3]
                one = rollers[4]
            end

            if not hundred or not ten or not one then
                cheat_client._spoofing_days = false
                return
            end

            if not original_days.hundred then
                original_days = {
                    thousand = has_thousand and {text = thousand.Char.Text, connection = nil} or nil,
                    hundred = {text = hundred.Char.Text, connection = nil},
                    ten = {text = ten.Char.Text, connection = nil},
                    one = {text = one.Char.Text, connection = nil}
                }
            end

            -- Disconnect old connections FIRST
            if original_days.thousand and original_days.thousand.connection then original_days.thousand.connection:Disconnect() end
            if original_days.hundred.connection then original_days.hundred.connection:Disconnect() end
            if original_days.ten.connection then original_days.ten.connection:Disconnect() end
            if original_days.one.connection then original_days.one.connection:Disconnect() end

            -- Set text values
            local days_str = tostring(days)
            if #days_str == 4 and has_thousand then
                thousand.Char.Text = string.sub(days_str, 1, 1)
                hundred.Char.Text = string.sub(days_str, 2, 2)
                ten.Char.Text = string.sub(days_str, 3, 3)
                one.Char.Text = string.sub(days_str, 4, 4)
            elseif #days_str == 3 then
                if has_thousand then thousand.Char.Text = "0" end
                hundred.Char.Text = string.sub(days_str, 1, 1)
                ten.Char.Text = string.sub(days_str, 2, 2)
                one.Char.Text = string.sub(days_str, 3, 3)
            elseif #days_str == 2 then
                if has_thousand then thousand.Char.Text = "0" end
                hundred.Char.Text = "0"
                ten.Char.Text = string.sub(days_str, 1, 1)
                one.Char.Text = string.sub(days_str, 2, 2)
            else
                if has_thousand then thousand.Char.Text = "0" end
                hundred.Char.Text = "0"
                ten.Char.Text = "0"
                one.Char.Text = string.sub(days_str, 1, 1)
            end

            -- Recreate connections with recursion guard check
            if cheat_client.config.spoof_days_enabled then
                if has_thousand and thousand then
                    original_days.thousand.connection = utility:Connection(thousand.Char:GetPropertyChangedSignal("Text"), function()
                        if cheat_client._spoofing_days then return end
                        if cheat_client.config.spoof_days_enabled then
                            cheat_client:spoof_days(cheat_client.config.custom_day_spoof)
                        end
                    end)
                end

                original_days.hundred.connection = utility:Connection(hundred.Char:GetPropertyChangedSignal("Text"), function()
                    if cheat_client._spoofing_days then return end
                    if cheat_client.config.spoof_days_enabled then
                        cheat_client:spoof_days(cheat_client.config.custom_day_spoof)
                    end
                end)

                original_days.ten.connection = utility:Connection(ten.Char:GetPropertyChangedSignal("Text"), function()
                    if cheat_client._spoofing_days then return end
                    if cheat_client.config.spoof_days_enabled then
                        cheat_client:spoof_days(cheat_client.config.custom_day_spoof)
                    end
                end)

                original_days.one.connection = utility:Connection(one.Char:GetPropertyChangedSignal("Text"), function()
                    if cheat_client._spoofing_days then return end
                    if cheat_client.config.spoof_days_enabled then
                        cheat_client:spoof_days(cheat_client.config.custom_day_spoof)
                    end
                end)
            end

            cheat_client._spoofing_days = false
        end

        do -- // Auto Potions + Auto Smithing
            local autoCraftUtils = {};

            local potions = {
                ['Health Potion'] = {
                    ['Lava Flower'] = 1;
                    ['Scroom'] = 2;
                },
    
                ['Bone Growth'] = {
                    ['Trote'] = 1,
                    ['Strange Tentacle'] = 1,
                    ['Uncanny Tentacle'] = 1
                },
    
                ['Switch Witch'] = {
                    ['Dire Flower'] = 1,
                    ['Glow Shroom'] = 2
                },
    
                ['Silver Sun'] = {
                    ['Desert Mist'] = 1,
                    ['Free Leaf'] = 1,
                    ['Polar Plant'] = 1
                },
    
                ['Lordsbane'] = {
                    ['Crown Flower'] = 3
                },
    
                ['Liquid Wisdom'] = {
                    ['Desert Mist'] = 1,
                    ['Periashroom'] = 1,
                    ['Crown Flower'] = 1,
                    ['Freeleaf'] = 1
                },
    
                ['Ice Protection'] = {
                    ['Snow Scroom'] = 2,
                    ['Trote'] = 1,
                },
    
                ['Kingsbane'] = {
                    ['Crown Flower'] = 1,
                    ['Vile Seed'] = 2,
                },
    
                ['Feather Feet'] = {
                    ['Creely'] = 1,
                    ['Dire Flower'] = 1,
                    ['Polar Plant'] = 1
                },
    
                ['Fire Protection'] = {
                    ['Trote'] = 1,
                    ['Scroom'] = 2
                },
    
                ['Tespian Elixir'] = {
                    ['Lava Flower'] = 1,
                    ['Scroom'] = 1,
                    ['Moss Plant'] = 2
                },
    
                ['Slateskin'] = {
                    ['Petrii Flower'] = 1,
                    ['Stone Scroom'] = 1,
                    ['Coconut'] = 1
                },
    
                ['Mind Mend'] = {
                    ['Grass Stem'] = 1,
                    ['Crystal Lotus'] = 1,
                    ['Winter Blossom'] = 1
                },
    
                ['Clot Control'] = {
                    ['Coconut'] = 1,
                    ['Grass Stem'] = 1,
                    ['Petri Flower'] = 1
                },
    
                ['Maidensbane'] = {
                    ['Stone Scroom'] = 1,
                    ['Fen Bloom'] = 1,
                    ['Foul Root'] = 1,
                },
    
                ['Sooth Sight'] = {
                    ['Grass Stem'] = 2,
                    ['Crystal Lotus'] = 1
                },
    
                ['Crystal Extract'] = {
                    ['Crystal Root'] = 1,
                    ['Crystal Lotus'] = 1,
                    ['Winter Blossom'] = 1
                },
    
                ['Soothing Frost'] = {
                    ['Winter Blossom'] = 1,
                    ['Snowshroom'] = 2
                },
            };
            
            local swords = {
                ['Bronze Sword'] = {
                    ['Copper Bar'] = 1,
                    ['Tin Bar'] = 2
                },
    
                ['Bronze Dagger'] = {
                    ['Copper Bar'] = 1,
                    ['Tin Bar'] = 1
                },
    
                ['Bronze Spear'] = {
                    ['Tin Bar'] = 1,
                    ['Copper Bar'] = 2
                },
    
                ['Steel Sword'] = {
                    ['Iron Bar'] = 2,
                    ['Copper Bar'] = 1
                },
    
                ['Steel Dagger'] = {
                    ['Iron Bar'] = 1,
                    ['Copper Bar'] = 1
                },
    
                ['Steel Spear'] = {
                    ['Iron Bar'] = 1,
                    ['Copper Bar'] = 2
                },
    
                ['Mythril Sword'] = {
                    ['Copper Bar'] = 1,
                    ['Iron Bar'] = 2,
                    ['Mythril Bar'] = 1
                },
    
                ['Mythril Dagger'] = {
                    ['Copper Bar'] = 1,
                    ['Iron Bar'] = 1,
                    ['Mythril Bar'] = 1
                },
    
                ['Mythril Spear'] = {
                    ['Copper Bar'] = 2,
                    ['Iron Bar'] = 1,
                    ['Mythril Bar'] = 1
                }
            }
    
            local stations = workspace:FindFirstChild("Stations");
    
            local function GrabStation(type)
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if typeof(type) ~= "string" then
                        return warn(string.format("Expected type string got <%s>",typeof(type)))
                    elseif(not stations) then
                        return warn('[Auto Potion] No Stations');
                    end
        
                    for i,v in next, stations:GetChildren() do
                        if (v.Timer.Position-plr.Character.HumanoidRootPart.Position).Magnitude <= 15 and string.find(v.Name, type) then
                            return v
                        end
                    end
                end
            end
    
            local function hasMaterials(items, item)
                local recipe = items[item];
                local count = setmetatable({}, {__index = function() return 0 end});

                assert(recipe);

                if not plr.Backpack then return false end
                for i, v in next, plr.Backpack:GetChildren() do
                    if(recipe[v.Name]) then
                        local quantity = v:FindFirstChild('Quantity');
                        quantity = quantity and quantity.Value or 1;
    
                        count[v.Name] = count[v.Name] + quantity;
                    end;
                end;
    
                for i, v in next, recipe do
                    if(count[i] < v) then
                        return false;
                    end;
                end;
    
                return recipe;
            end;
            
    
            autoCraftUtils.hasMaterials = function(craftType, item)
                return hasMaterials(craftType == 'Alchemy' and potions or swords, item);
            end;
            
    
            local function addItemsToStation(items, station, part, partToClick, partToClean)
                if(station.Contents.Value ~= '[]') then
                    repeat
                        fireclickdetector(station[partToClean].ClickEmpty);
                        task.wait(utility:random_wait(true));
                    until station.Contents.Value == '[]';
            
                    task.wait(utility:random_wait(true))
                end;

                for name, count in next, items do
                    for i = 1, count do
                        if not plr.Backpack then
                            warn("[auto stuff] Backpack not found")
                            return
                        end
                        local k = plr.Backpack:FindFirstChild(name);
            
                        if not k then 
                            warn(string.format("[auto stuff] missing ingredient: %s", name)) 
                            return 
                        end 
            
                        if k.Parent == nil then 
                            warn(string.format("[auto stuff] cannot move %s, its parent is NULL", name))
                            return
                        end
            
                        task.wait(utility:random_wait(true))
                        k.Parent = plr.Character;
            
                        if k.Parent ~= plr.Character then
                            warn("[auto stuff] Failed to move " .. name .. " to character")
                            return
                        end
            
                        local remote = k:FindFirstChildWhichIsA('RemoteEvent');
            
                        if(remote) then
                            local content = station.Contents.Value;
            
                            repeat
                                remote:FireServer(station[part].CFrame, station[part]);
                                task.wait(utility:random_wait(true))
                            until station.Contents.Value ~= content;

                            if k.Parent and plr.Backpack then
                                k.Parent = plr.Backpack;
                            end
                            task.wait(0.1);
                        else
                            k:Activate();
            
                            repeat
                                task.wait(utility:random_wait(true))
                            until not k.Parent;
                        end;
                    end;
                end;
            
                repeat
                    fireclickdetector(station[partToClick].ClickConcoct);
                    task.wait(utility:random_wait(true))
                until station.Contents.Value == '[]';
            end;
            
    
            function utility:craft(stationType, itemToCraft)
                if not plr.Character then return false end
                if not (auto_pot_active or auto_craft_active) then return false end

                local station = GrabStation(stationType);
                local items = hasMaterials(stationType == 'Alchemy' and potions or swords, itemToCraft);

                if (library ~= nil and library.Notify) then
                    if(not station) then
                        library:Notify("You must be near a cauldron/furnace!", Color3.fromRGB(255,0,0))
                        return false
                    end
                    if(not items) then
                        library:Notify("Some ingredients are missing!", Color3.fromRGB(255,0,0))
                        return false
                    end
                end
    
                if(stationType == 'Smithing') then
                    rps.Requests.GetMouse.OnClientInvoke = function()
                        return {
                            Hit = station.Material.CFrame,
                            Target = station.Material,
                            UnitRay = mouse.UnitRay,
                            X = mouse.X,
                            Y = mouse.Y
                        }
                    end;
                end;
    
                if (stationType == 'Alchemy') then
                    repeat
                        if not auto_pot_active then return false end
                        addItemsToStation(items, station, 'Water', 'Ladle', 'Bucket');
                        items = hasMaterials(stationType == 'Alchemy' and potions or swords, itemToCraft);

                        -- Apply delay between each potion
                        if cheat_client and cheat_client.config and cheat_client.config.auto_craft_delay then
                            task.wait(cheat_client.config.auto_craft_delay)
                        else
                            task.wait(utility:random_wait(true))
                        end
                    until not items or not auto_pot_active;
                elseif (stationType == 'Smithing') then
                    repeat
                        if not auto_craft_active then return false end
                        addItemsToStation(items, station, 'Material', 'Hammer', 'Trash');
                        items = hasMaterials(stationType == 'Alchemy' and potions or swords, itemToCraft);

                        -- Apply delay between each sword
                        if cheat_client and cheat_client.config and cheat_client.config.auto_craft_delay then
                            task.wait(cheat_client.config.auto_craft_delay)
                        else
                            task.wait(utility:random_wait(true))
                        end
                    until not items or not auto_craft_active;
                end;

                rps.Requests.GetMouse.OnClientInvoke = function()
                    return {
                        Hit = mouse.Hit,
                        Target = mouse.Target,
                        UnitRay = mouse.UnitRay,
                        X = mouse.X,
                        Y = mouse.Y
                    }
                end

                return true
            end
        end

        do -- Dayfarm
            local function is_moderator(player)
                if cheat_client and cheat_client.mod_list and table.find(cheat_client.mod_list, player.UserId) then
                    return true
                end

                local success, isInGroup = pcall(function()
                    return player:IsInGroup(4556484)
                end)

                if success and isInGroup then
                    local role = player:GetRoleInGroup(4556484)
                    if role ~= "Guest" then
                        return true
                    end
                end

                local success2, isInGroup2 = pcall(function()
                    return player:IsInGroup(281365)
                end)

                if success2 and isInGroup2 then
                    local role = player:GetRoleInGroup(281365)
                    if role ~= "Guest" then
                        return true
                    end
                end

                return false
            end

            local function no_kick()
                if Toggles and Toggles.no_kick and Toggles.no_kick.Value then
                    return true
                end
                return false
            end

            function cheat_client:day_farm(state)
                for _, connection in next, getconnections(plr.Idled) do
                    if state then 
                        connection:Disable()
                    else 
                        connection:Enable()
                    end
                end
                
                if not shared.deathConnection then
                    shared.deathConnection = nil
                end
                
                if not shared.characterAddedConnection then
                    shared.characterAddedConnection = nil
                end
                
                if state then
                    mem:SetItem('dayfarming', 'true')
                        
                    local ptr = Options.day_farm_range
                    local noKickPtr = Toggles and Toggles.no_kick
                    local daygoalKickPtr = Toggles and Toggles.day_goal_kick
                    local dayGoalPtr = Options.DayGoal

                    if ptr then
                        mem:SetItem('dayfarming_range', tostring(ptr.Value))
                    else
                        mem:SetItem('dayfarming_range', "500")
                    end

                    if daygoalKickPtr then
                        mem:SetItem('day_goal_kick', daygoalKickPtr.Value and "true" or "false")
                    else
                        mem:SetItem('day_goal_kick', "false")
                    end

                    if noKickPtr then
                        mem:SetItem('no_kick', noKickPtr.Value and "true" or "false")
                    else
                        mem:SetItem('no_kick', "false")
                    end

                    if dayGoalPtr then
                        mem:SetItem('daygoal', tostring(dayGoalPtr.Value))
                    else
                        mem:SetItem('daygoal', "999")
                    end


                    local playerCount = #plrs:GetPlayers()
                    utility:plain_webhook(string.format("Started farming days with %d players", playerCount))

                    cpu.status.active = true
                    
                    if shared.focusConnection then
                        shared.focusConnection:Disconnect()
                    end
                    
                    shared.focusConnection = utility:Connection(uis.WindowFocused, function()
                        cpu.status.focused = true
                        if cpu.status.hd_mode then
                            setfpscap(50)
                        else
                            setfpscap(20)
                        end
                        cpu.services.ugs.MasterVolume = cpu.services.ms
                        settings().Rendering.QualityLevel = cpu.services.ql
                        cpu.services.rs:Set3dRenderingEnabled(true)
                    end)
                    
                    if shared.unfocusConnection then
                        shared.unfocusConnection:Disconnect()
                    end
                    
                    shared.unfocusConnection = utility:Connection(uis.WindowFocusReleased, function()
                        cpu.status.focused = false
                        setfpscap(15)
                        settings().Rendering.QualityLevel = 1
                        cpu.services.rs:Set3dRenderingEnabled(false)
                    end)
                    
                    local function kickPlayer(message)
                        if cs:HasTag(plr.Character, "Danger") then
                            repeat task.wait(0.1) until not cs:HasTag(plr.Character, "Danger")
                        end

                        utility:plain_webhook(message)
                        rps.Requests.ReturnToMenu:InvokeServer()
                        plr:Kick(message)
                        utility:Unload()
                    end

                    local teleport_debounce = false
                    local function DayfarmServerhop(reason)
                        if teleport_debounce then return end

                        if plr.Character and cs:HasTag(plr.Character, "Danger") then
                            repeat task.wait(0.1) until not cs:HasTag(plr.Character, "Danger")
                        end

                        utility:plain_webhook(reason or "Dayfarm serverhopping")

                        -- Return to menu BEFORE serverhopping
                        if rps.Requests and rps.Requests:FindFirstChild("ReturnToMenu") and plr.Character then
                            pcall(function()
                                rps.Requests.ReturnToMenu:InvokeServer()
                            end)
                            task.wait(0.5)
                        end

                        -- Setup OnTeleport handler
                        plr.OnTeleport:Connect(function(State)
                            if teleport_debounce then return end
                            teleport_debounce = true

                            local queue_func = queueteleport or queue_on_teleport
                            if queue_func then
                                local success, err = pcall(function()
                                    local loader_script
                                    if readfile and isfile and isfile("bazaar_loader.txt") then
                                        loader_script = [[local s,e=pcall(loadstring(readfile("bazaar_loader.txt")))if not s then print("[QUEUE ERROR]",e)end]]
                                    else
                                        loader_script = [[local s,e=pcall(loadstring(game:HttpGet("https://bazaar.hydroxide.solutions/v2/loader.lua")))if not s then print("[QUEUE ERROR]",e)end]]
                                    end
                                    queue_func(loader_script)
                                end)

                                if not success then
                                    utility:plain_webhook(string.format("FAILED to queue script: %s", tostring(err)))
                                end
                            else
                                utility:plain_webhook("WARNING: queueteleport not available - script will NOT auto-load!")
                            end
                        end)

                        task.wait(0.5)
                        utility:Serverhop()
                    end

                    shared.dangerousItemConnection = utility:Connection(ws.Live.DescendantAdded, function(descendant)
                        if not (Toggles and Toggles.day_farm and Toggles.day_farm.Value) then return end
                        if no_kick() then return end

                        if descendant:IsA("Tool") and (descendant.Name == "Perflora" or descendant.Name == "Pebble") then
                            local character = descendant.Parent
                            if character and character:IsA("Model") then
                                local player = plrs:GetPlayerFromCharacter(character)
                                if player and player ~= plr then
                                    DayfarmServerhop(string.format("%s (%s) has dangerous item: %s", player.Name, player.UserId, descendant.Name))
                                end
                            end
                        end
                    end)
                    
                    local time_elapsed = 0
                    local server_hop_initiated = false

                    cheat_client.feature_connections.day_farm = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(delta_time)
                        if not server_hop_initiated then
                            time_elapsed += delta_time
                            if time_elapsed >= 1 then
                                time_elapsed = 0

                                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                                    return
                                end

                                if no_kick() then
                                    return
                                end

                                local range = (Options and Options.day_farm_range and Options.day_farm_range.Value) or 50
                                local myPosition = plr.Character.HumanoidRootPart.Position

                                for _, player in next, plrs:GetPlayers() do
                                    if player == plr then continue end

                                    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                                        continue
                                    end

                                    local theirPosition = player.Character.HumanoidRootPart.Position
                                    local distance = (myPosition - theirPosition).Magnitude

                                    print(string.format("[Day Farm] Checking %s: %.2f studs (range: %.2f)", player.Name, distance, range))

                                    if distance < range and distance > 0.1 then
                                        if cs:HasTag(plr.Character, "Danger") then
                                            repeat
                                                task.wait(0.1)
                                            until not cs:HasTag(plr.Character, "Danger")
                                        end

                                        server_hop_initiated = true
                                        print(string.format("[Day Farm] TRIGGER: %s came too close (%.2f studs < %.2f range)", player.Name, distance, range))
                                        DayfarmServerhop(string.format("%s (%s) came too close (%.2f studs)", player.Name, player.UserId, distance))
                                        break
                                    end
                                end
                            end
                        end
                    end))

                    for _, player in ipairs(plrs:GetPlayers()) do
                        if player == plr then continue end

                        if is_moderator(player) and not no_kick() then
                            DayfarmServerhop(string.format("Moderator already in server: %s (%s)", player.Name, player.UserId))
                            return
                        end

                        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local range = (Options and Options.day_farm_range and Options.day_farm_range.Value) or 50
                            local distance = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance < range and distance > 0.1 and not no_kick() then
                                DayfarmServerhop(string.format("%s (%s) was already too close when day farm started (%.2f studs)", player.Name, player.UserId, distance))
                                return
                            end
                        end

                        utility:Connection(player.CharacterAdded, function(character)
                            if not (Toggles and Toggles.day_farm and Toggles.day_farm.Value) then return end
                            if no_kick() then return end

                            task.wait(1)

                            if character:FindFirstChild("HumanoidRootPart") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                local range = (Options and Options.day_farm_range and Options.day_farm_range.Value) or 50
                                local distance = (plr.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                                if distance < range and distance > 0.1 then
                                    DayfarmServerhop(string.format("%s (%s) spawned too close (%.2f studs)", player.Name, player.UserId, distance))
                                end
                            end
                        end)
                    end

                    shared.playerAddedConnection = utility:Connection(plrs.PlayerAdded, function(player)
                        if not (Toggles and Toggles.day_farm and Toggles.day_farm.Value) then return end
                        if no_kick() then return end

                        if is_moderator(player) then
                            DayfarmServerhop(string.format("Moderator joined: %s (%s)", player.Name, player.UserId))
                        end
                        
                        local characterAddedConnection
                        characterAddedConnection = utility:Connection(player.CharacterAdded, function(character)
                            task.wait(1)
                            
                            if character:FindFirstChild("HumanoidRootPart") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = (plr.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                                if distance < ((Options and Options.day_farm_range and Options.day_farm_range.Value) or 50) then
                                    DayfarmServerhop(string.format("%s (%s) joined and spawned too close (%.2f studs)", player.Name, player.UserId, distance))
                                    characterAddedConnection:Disconnect()
                                end
                            end
                        end)
                        
                        if player.Character then
                            if player.Character:FindFirstChild("HumanoidRootPart") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                if distance < ((Options and Options.day_farm_range and Options.day_farm_range.Value) or 50) then
                                    DayfarmServerhop(string.format("%s (%s) was already too close (%.2f studs)", player.Name, player.UserId, distance))
                                end
                            end
                        end
                    end)

                    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                        if shared.deathConnection then
                            shared.deathConnection:Disconnect()
                        end

                        shared.deathConnection = utility:Connection(plr.Character.Humanoid.Died, function()
                            if cs:HasTag(plr.Character, "Danger") then
                                repeat
                                    task.wait(0.1)
                                until not cs:HasTag(plr.Character, "Danger")
                            end

                            utility:plain_webhook("player died during day farm??")
                            rps.Requests.ReturnToMenu:InvokeServer()
                            plr:Kick("player died during day farm")
                            utility:Unload()
                        end)
                    end
                    
                    if shared.characterAddedConnection then
                        shared.characterAddedConnection:Disconnect()
                    end
                    
                    shared.characterAddedConnection = utility:Connection(plr.CharacterAdded, function(character)
                        if shared.deathConnection then
                            shared.deathConnection:Disconnect()
                        end
                        
                        task.wait(1)
                        
                        if character:FindFirstChild("Humanoid") then
                            shared.deathConnection = utility:Connection(character.Humanoid.Died, function()
                                if cs:HasTag(character, "Danger") then
                                    repeat
                                        task.wait(0.1)
                                    until not cs:HasTag(character, "Danger")
                                end

                                utility:plain_webhook("player died during day farm??")
                                rps.Requests.ReturnToMenu:InvokeServer()
                                plr:Kick("player died during day farm")
                                utility:Unload()
                            end)
                        end
                    end)
                else
                    cpu.status.active = false
                    setfpscap(999)
                    settings().Rendering.QualityLevel = cpu.services.ql
                    cpu.services.rs:Set3dRenderingEnabled(true)

                    if shared.cpuOptimizationConnection then
                        shared.cpuOptimizationConnection:Disconnect()
                        shared.cpuOptimizationConnection = nil
                    end
                    
                    if shared.focusConnection then
                        shared.focusConnection:Disconnect()
                        shared.focusConnection = nil
                    end
                    
                    if shared.unfocusConnection then
                        shared.unfocusConnection:Disconnect()
                        shared.unfocusConnection = nil
                    end
                    
                    if shared.deathConnection then
                        shared.deathConnection:Disconnect()
                        shared.deathConnection = nil
                    end
                    
                    if shared.characterAddedConnection then
                        shared.characterAddedConnection:Disconnect()
                        shared.characterAddedConnection = nil
                    end

                    if shared.dangerousItemConnection then
                        shared.dangerousItemConnection:Disconnect()
                        shared.dangerousItemConnection = nil
                    end
                    
                    if cheat_client.feature_connections.day_farm then
                        cheat_client.feature_connections.day_farm:Disconnect()
                        cheat_client.feature_connections.day_farm = nil
                    end
                    
                    if shared.playerAddedConnection then
                        shared.playerAddedConnection:Disconnect()
                        shared.playerAddedConnection = nil
                    end

                    mem:RemoveItem("dayfarming")
                    mem:RemoveItem("dayfarming_range")
                    mem:RemoveItem("day_goal_kick")
                    mem:RemoveItem("no_kick")
                    mem:RemoveItem("daygoal")
                end
            end


            -- Auto-restart check on script load
            task.spawn(function()
                if mem:HasItem("dayfarming") and mem:GetItem("dayfarming") == "true" then
                    task.wait(2)

                    -- Moderator check BEFORE spawning character
                    local moderator_detected = false
                    for _, player in next, plrs:GetPlayers() do
                        if player ~= plr and is_moderator(player) then
                            moderator_detected = true
                            utility:plain_webhook(string.format("Moderator %s detected on dayfarm auto-restart - serverhopping", player.Name))
                            DayfarmServerhop(string.format("Moderator detected: %s", player.Name))
                            return
                        end
                    end

                    if moderator_detected then return end

                    -- Auto-spawn character
                    local success = pcall(function()
                        plr.PlayerGui:WaitForChild("StartMenu", 30)
                    end)

                    if success and plr.PlayerGui:FindFirstChild("StartMenu") then
                        task.wait(1)

                        pcall(function()
                            if plr.PlayerGui.StartMenu:FindFirstChild("Choices") and
                               plr.PlayerGui.StartMenu.Choices:FindFirstChild("Play") then
                                firesignal(plr.PlayerGui.StartMenu.Choices.Play.MouseButton1Click)
                            end
                        end)

                        repeat task.wait(0.25) until plr.Character
                        repeat task.wait(0.25) until plr.Character:FindFirstChild("HumanoidRootPart")
                        task.wait(1)

                        -- Load settings from mem
                        if mem:HasItem('dayfarming_range') then
                            local range = tonumber(mem:GetItem('dayfarming_range'))
                            if range and library.Options and library.Options.day_farm_range then
                                library.Options.day_farm_range:SetValue(range)
                            end
                        end

                        if mem:HasItem('day_goal_kick') then
                            local kick = mem:GetItem('day_goal_kick') == "true"
                            if library.Toggles and library.Toggles.day_goal_kick then
                                library.Toggles.day_goal_kick:SetValue(kick)
                            end
                        end

                        if mem:HasItem('no_kick') then
                            local no_kick_val = mem:GetItem('no_kick') == "true"
                            if library.Toggles and library.Toggles.no_kick then
                                library.Toggles.no_kick:SetValue(no_kick_val)
                            end
                        end

                        if mem:HasItem('daygoal') then
                            local goal = tonumber(mem:GetItem('daygoal'))
                            if goal and library.Options and library.Options.DayGoal then
                                library.Options.DayGoal:SetValue(tostring(goal))
                            end
                        end

                        library:Notify("Auto-restarting day farm...")
                        task.wait(1)

                        -- Auto-enable dayfarm toggle
                        if library.Toggles and library.Toggles.day_farm then
                            library.Toggles.day_farm:SetValue(true)
                        else
                            cheat_client:day_farm(true)
                        end
                    end
                end
            end)
        end
    end
    
    -- UI
    do
        -- Proper Library Initialization
        local Options = library.Options
        local Toggles = library.Toggles

        local window = library:CreateWindow({
            Title = "HYDROXIDE",
            NotifySide = "Left",
            Footer = "",
            Center = true,
            AutoShow = true,
            Resizable = true,
            DisableSearch = false
        })

        -- Tab Structure
        local Tabs = {
            Combat = window:AddTab("Combat", "sword"),
            Visuals = window:AddTab("Visuals", "eye"),
            World = window:AddTab("World", "globe"),
            Exploits = window:AddTab("Exploits", "zap"),
            Movement = window:AddTab("Movement", "wind"),
            Automation = window:AddTab("Automation", "cog"),
            Misc = window:AddTab("Misc", "settings"),
            Botting = window:AddTab("Botting", "bot"),
            Interface = window:AddTab("Interface", "monitor"),
            Config = window:AddTab("Config", "save")
        }

        do -- Combat
            -- Group 1: Combat Utilities
            local group_combat_utils = Tabs.Combat:AddLeftGroupbox("Combat Utilities")

            group_combat_utils:AddToggle("NoStun", {
                Text = "No Stun",
                Default = cheat_client.config.no_stun
            })

            group_combat_utils:AddToggle("AntiHystericus", {
                Text = "No Confusion",
                Default = cheat_client.config.anti_confusion
            })

            group_combat_utils:AddToggle("PerfloraTeleport", {
                Text = "Perflora Teleport",
                Default = cheat_client.config.perflora_teleport
            })

            group_combat_utils:AddDivider()

            group_combat_utils:AddLabel("Attach to Back"):AddKeyPicker("AttachToBackKeybind", {
                Default = cheat_client.config.attach_to_back_keybind,
                Text = "Attach to Back",
            })

            Options.AttachToBackKeybind:OnChanged(function()
                cheat_client.config.attach_to_back_keybind = Options.AttachToBackKeybind.Value
            end)

            group_combat_utils:AddDivider()

            group_combat_utils:AddToggle("AutoMisogi", {
                Text = "Auto Misogi",
                Default = cheat_client.config.auto_misogi
            })

            group_combat_utils:AddToggle("AntiBackfireViribus", {
                Text = "Anti Backfire Viribus",
                Default = cheat_client.config.anti_backfire_viribus
            })

            group_combat_utils:AddDivider()

            if HXD_UserNote and string.find(HXD_UserNote:lower(), "beta") then
                group_combat_utils:AddToggle("HoldBlock", {
                    Text = "Hold Block (F)",
                    Default = cheat_client.config.hold_block
                })

                group_combat_utils:AddSlider("HoldBlockDelay", {
                    Text = "Block Delay (ms)",
                    Default = cheat_client.config.hold_block_delay,
                    Min = 0,
                    Max = 1000,
                    Rounding = 0,
                    Compact = true
                })
            end

            -- Group 2: Auto Parry
            local group_auto_parry = Tabs.Combat:AddRightGroupbox("Auto Parry")

            group_auto_parry:AddToggle("ParryViribus", {
                Text = "Auto Parry Viribus",
                Default = cheat_client.config.parry_viribus
            })

            group_auto_parry:AddToggle("ParryOwl", {
                Text = "Auto Parry Owlslash",
                Default = cheat_client.config.parry_owlslash
            })

            group_auto_parry:AddToggle("ParryShadowrush", {
                Text = "Auto Parry Shadowrush",
                Default = cheat_client.config.parry_shadowrush
            })

            group_auto_parry:AddToggle("ParryVerdien", {
                Text = "Auto Parry Verdien",
                Default = cheat_client.config.parry_verdien
            })

            -- Group 3: Parry Settings
            local group_parry_settings = Tabs.Combat:AddLeftGroupbox("Parry Settings")

            group_parry_settings:AddToggle("ParryPingAdjust", {
                Text = "Ping Adjustment",
                Default = cheat_client.config.parry_ping_adjust
            })

            group_parry_settings:AddToggle("ParryCustomDelay", {
                Text = "Use Custom Delay",
                Default = cheat_client.config.parry_custom_delay
            })

            group_parry_settings:AddSlider("ParryCustomDelayMs", {
                Text = "Custom Delay",
                Default = cheat_client.config.custom_delay,
                Min = -500,
                Max = 500,
                Rounding = 1
            })

            group_parry_settings:AddSlider("ParryFovAngle", {
                Text = "Parry FOV Angle",
                Default = cheat_client.config.parry_fov_angle,
                Min = 0,
                Max = 360,
                Rounding = 1
            })

            group_parry_settings:AddToggle("ParryDisableWhenUnfocused", {
                Text = "Disable When Window Unfocused",
                Default = cheat_client.config.parry_disable_when_unfocused
            })

            group_parry_settings:AddToggle("ParryIgnoreVisibility", {
                Text = "Ignore Visibility (Blatant)",
                Default = cheat_client.config.parry_ignore_visibility
            })

            group_parry_settings:AddToggle("ParrySemiBlatantBlock", {
                Text = "Semi-Blatant Block",
                Default = cheat_client.config.parry_semi_blatant_block
            })

            -- Group 4: Silent Aim
            local group_silent_aim = Tabs.Combat:AddRightGroupbox("Silent Aim")

            group_silent_aim:AddToggle("SilentAim", {
                Text = "Silent Aim",
                Default = cheat_client.config.silent_aim
            })

            group_silent_aim:AddSlider("SilentAimFov", {
                Text = "FOV",
                Default = cheat_client.config.fov,
                Min = 0,
                Max = 200,
                Rounding = 1
            })

            group_silent_aim:AddToggle("HideFovCircle", {
                Text = "Hide FOV Circle",
                Default = cheat_client.config.hide_fov_circle
            })

            Toggles.NoStun:OnChanged(function()
                local value = Toggles.NoStun.Value
                cheat_client.config.no_stun = value
            end)

            Toggles.AntiHystericus:OnChanged(function()
                local value = Toggles.AntiHystericus.Value
                cheat_client.config.anti_confusion = value
            end)

            Toggles.PerfloraTeleport:OnChanged(function()
                local value = Toggles.PerfloraTeleport.Value
                cheat_client.config.perflora_teleport = value

                if value then
                    if cheat_client.start_perflora_teleport then
                        cheat_client.start_perflora_teleport()
                    end
                else
                    if cheat_client.stop_perflora_teleport then
                        cheat_client.stop_perflora_teleport()
                    end
                end
            end)

            Toggles.AutoMisogi:OnChanged(function()
                local value = Toggles.AutoMisogi.Value
                cheat_client.config.auto_misogi = value
            end)

            Toggles.AntiBackfireViribus:OnChanged(function()
                local value = Toggles.AntiBackfireViribus.Value
                cheat_client.config.anti_backfire_viribus = value
            end)

            if HXD_UserNote and string.find(HXD_UserNote:lower(), "beta") then
                Toggles.HoldBlock:OnChanged(function()
                    local value = Toggles.HoldBlock.Value
                    cheat_client.config.hold_block = value

                    if value then
                        if cheat_client.start_hold_block then
                            cheat_client.start_hold_block()
                        end
                    else
                        if cheat_client.stop_hold_block then
                            cheat_client.stop_hold_block()
                        end
                    end
                end)

                Options.HoldBlockDelay:OnChanged(function()
                    cheat_client.config.hold_block_delay = Options.HoldBlockDelay.Value
                end)
            end

            Toggles.ParryViribus:OnChanged(function()
                local value = Toggles.ParryViribus.Value
                cheat_client.config.parry_viribus = value
            end)

            Toggles.ParryOwl:OnChanged(function()
                local value = Toggles.ParryOwl.Value
                cheat_client.config.parry_owlslash = value
            end)

            Toggles.ParryShadowrush:OnChanged(function()
                local value = Toggles.ParryShadowrush.Value
                cheat_client.config.parry_shadowrush = value
            end)

            Toggles.ParryVerdien:OnChanged(function()
                local value = Toggles.ParryVerdien.Value
                cheat_client.config.parry_verdien = value
            end)

            Toggles.ParryPingAdjust:OnChanged(function()
                local value = Toggles.ParryPingAdjust.Value
                cheat_client.config.parry_ping_adjust = value
            end)

            Toggles.ParryCustomDelay:OnChanged(function()
                local value = Toggles.ParryCustomDelay.Value
                cheat_client.config.parry_custom_delay = value
            end)

            Options.ParryCustomDelayMs:OnChanged(function()
                local value = Options.ParryCustomDelayMs.Value
                cheat_client.config.custom_delay = value
            end)

            Options.ParryFovAngle:OnChanged(function()
                local value = Options.ParryFovAngle.Value
                cheat_client.config.parry_fov_angle = value
            end)

            Toggles.ParryDisableWhenUnfocused:OnChanged(function()
                local value = Toggles.ParryDisableWhenUnfocused.Value
                cheat_client.config.parry_disable_when_unfocused = value
            end)

            Toggles.ParryIgnoreVisibility:OnChanged(function()
                local value = Toggles.ParryIgnoreVisibility.Value
                cheat_client.config.parry_ignore_visibility = value
            end)

            Toggles.ParrySemiBlatantBlock:OnChanged(function()
                local value = Toggles.ParrySemiBlatantBlock.Value
                cheat_client.config.parry_semi_blatant_block = value
            end)

            Toggles.SilentAim:OnChanged(function()
                local value = Toggles.SilentAim.Value
                cheat_client.config.silent_aim = value

                if value then
                    if cheat_client.start_silent_aim_rendering then
                        cheat_client.start_silent_aim_rendering()
                    end
                else
                    if cheat_client.stop_silent_aim_rendering then
                        cheat_client.stop_silent_aim_rendering()
                    end
                end
            end)

            Options.SilentAimFov:OnChanged(function()
                local value = Options.SilentAimFov.Value
                cheat_client.config.fov = value
            end)

            Toggles.HideFovCircle:OnChanged(function()
                local value = Toggles.HideFovCircle.Value
                cheat_client.config.hide_fov_circle = value
            end)

        end
    
        do -- Visuals
            local group_player = Tabs.Visuals:AddLeftGroupbox("Player ESP")
            local group_chams = Tabs.Visuals:AddRightGroupbox("Chams")
    
            do -- Player
                group_player:AddToggle("PlayerEsp", {
                    Text = "Player ESP",
                    Default = cheat_client.config.player_esp
                }):AddKeyPicker("PlayerEspKeybind", {
                    Default = cheat_client.config.player_esp_keybind,
                    Text = "Player ESP Toggle",
                    Mode = "Toggle",
                    SyncToggleState = true,
                })

                Toggles.PlayerEsp:OnChanged(function()
                    cheat_client.config.player_esp = Toggles.PlayerEsp.Value

                    if Toggles.PlayerEsp.Value then
                        cheat_client.player_esp_objects = cheat_client.player_esp_objects or {}

                        for _, player in pairs(plrs:GetPlayers()) do
                            if player ~= plr and not cheat_client.player_esp_objects[player] then
                                cheat_client.player_esp_objects[player] = cheat_client:add_player_esp(player)
                            end
                        end
                        cheat_client.esp_rendering.start_player_esp()
                    else
                        cheat_client.esp_rendering.stop_player_esp()

                        local chams_enabled = Toggles and Toggles.PlayerChams and Toggles.PlayerChams.Value
                        local esp_still_needed = chams_enabled and ((Toggles and Toggles.PlayerAimbotChams and Toggles.PlayerAimbotChams.Value) or
                                                  (Toggles and Toggles.PlayerFriendlyChams and Toggles.PlayerFriendlyChams.Value) or
                                                  (Toggles and Toggles.PlayerLowHealth and Toggles.PlayerLowHealth.Value) or
                                                  (Toggles and Toggles.PlayerRacialChams and Toggles.PlayerRacialChams.Value))

                        if not esp_still_needed then
                            for player, esp in pairs(cheat_client.player_esp_objects or {}) do
                                if esp and esp.destruct then
                                    esp:destruct()
                                end
                                if cheat_client.player_esp_objects then
                                    cheat_client.player_esp_objects[player] = nil
                                end
                            end
                        end
                    end
                end)

                Options.PlayerEspKeybind:OnChanged(function()
                    cheat_client.config.player_esp_keybind = Options.PlayerEspKeybind.Value
                end)

                group_player:AddToggle("PlayerName", {
                    Text = "Name",
                    Default = cheat_client.config.player_name
                })

                group_player:AddToggle("PlayerBox", {
                    Text = "Box",
                    Default = cheat_client.config.player_box
                })

                group_player:AddToggle("PlayerHealth", {
                    Text = "Health",
                    Default = cheat_client.config.player_health
                })

                group_player:AddToggle("PlayerTags", {
                    Text = "Tags",
                    Default = cheat_client.config.player_tags
                })

                group_player:AddToggle("PlayerIntent", {
                    Text = "Intent",
                    Default = cheat_client.config.player_intent
                })

                group_player:AddToggle("PlayerMana", {
                    Text = "Mana",
                    Default = cheat_client.config.player_mana
                })

                group_player:AddToggle("PlayerManaText", {
                    Text = "Mana Text",
                    Default = cheat_client.config.player_mana_text
                })

                group_player:AddToggle("PlayerRacial", {
                    Text = "Racial",
                    Default = cheat_client.config.player_racial
                })

                group_player:AddToggle("PlayerObserve", {
                    Text = "Observe Block",
                    Default = cheat_client.config.player_observe
                })

                group_player:AddToggle("PlayerHoverDetails", {
                    Text = "Fade Away",
                    Default = cheat_client.config.player_hover_details
                })

                group_player:AddSlider("PlayerRange", {
                    Text = "Range",
                    Default = cheat_client.config.player_range,
                    Min = 0,
                    Max = 9000,
                    Rounding = 1
                })

                group_player:AddDivider()

                -- Chams
                local function color_index(color)
                    for i, v in ipairs(shared.colors) do
                        if v == color then
                            return i
                        end
                    end
                    return 1 -- fallback index
                end

                group_chams:AddToggle("PlayerChams", {
                    Text = "Player Chams",
                    Default = cheat_client.config.player_chams
                })

                group_chams:AddDivider()

                group_chams:AddToggle("PlayerFriendlyChams", {
                    Text = "Friendly Chams",
                    Default = cheat_client.config.player_friendly_chams
                })

                group_chams:AddToggle("PlayerLowHealth", {
                    Text = "Low Health Chams",
                    Default = cheat_client.config.player_low_health
                })

                group_chams:AddToggle("PlayerAimbotChams", {
                    Text = "Player Aimbot Chams",
                    Default = cheat_client.config.player_aimbot_chams
                })

                group_chams:AddToggle("PlayerRacialChams", {
                    Text = "Racial Chams",
                    Default = cheat_client.config.player_racial_chams
                })

                group_chams:AddToggle("PlayerChamsFill", {
                    Text = "Chams Filled",
                    Default = cheat_client.config.player_chams_fill
                })

                group_chams:AddToggle("PlayerChamsPulse", {
                    Text = "Chams Pulse",
                    Default = cheat_client.config.player_chams_pulse
                })

                group_chams:AddToggle("PlayerChamsOccluded", {
                    Text = "Chams Occluded",
                    Default = cheat_client.config.player_chams_occluded
                })

                -- Hook all chams toggles to the rendering system
                Toggles.PlayerChams:OnChanged(function()
                    cheat_client.config.player_chams = Toggles.PlayerChams.Value
                    cheat_client.esp_rendering.update_chams()
                end)

                Toggles.PlayerFriendlyChams:OnChanged(function()
                    cheat_client.esp_rendering.update_chams()
                end)

                Toggles.PlayerLowHealth:OnChanged(function()
                    cheat_client.esp_rendering.update_chams()
                end)

                Toggles.PlayerAimbotChams:OnChanged(function()
                    cheat_client.esp_rendering.update_chams()
                end)

                Toggles.PlayerRacialChams:OnChanged(function()
                    cheat_client.esp_rendering.update_chams()
                end)

                -- Color picker can be added later if needed
                -- group_chams:AddColorPicker("player_chams_color", {
                --     Default = cheat_client.config.player_chams_color,
                --     Title = "Chams Color"
                -- })

                group_player:AddDivider()

                do -- player healthview
                    local hv_connection;
                    group_player:AddToggle("PlayerHealthview", {
                        Text = "Player Healthview",
                        Default = cheat_client.config.player_healthview
                    })

                    Toggles.PlayerHealthview:OnChanged(function()
                        local state = Toggles.PlayerHealthview.Value
                        cheat_client.config.player_healthview = state

                        if state then
                            for _, v in pairs(ws.Live:GetChildren()) do
                                if v ~= plr.Character then
                                    local z = v:FindFirstChildWhichIsA("Humanoid")
                                    if z then
                                        z.HealthDisplayType = Enum.HumanoidHealthDisplayType.DisplayWhenDamaged
                                        if v:FindFirstChild("MonsterInfo") then
                                            z.NameDisplayDistance = 0
                                        end
                                        z.HealthDisplayDistance = 80
                                        z.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                                    end
                                end
                            end

                            hv_connection = utility:Connection(ws.Live.ChildAdded, function(ch)
                                if ch ~= plr.Character then
                                    local z = ch:WaitForChild("Humanoid", 3)
                                    if z then
                                        z.HealthDisplayType = Enum.HumanoidHealthDisplayType.DisplayWhenDamaged
                                        if ch:FindFirstChild("MonsterInfo") then
                                            z.NameDisplayDistance = 0
                                        end
                                        z.HealthDisplayDistance = 80
                                        z.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                                    end
                                end
                            end)

                        else
                            if plr.Character and plr.Backpack and plr.Backpack:FindFirstChild("HealerVision") then return end
                            for _, v in pairs(ws.Live:GetChildren()) do
                                if v ~= plr.Character then
                                    local z = v:FindFirstChildWhichIsA("Humanoid")
                                    if z then
                                        z.HealthDisplayType = Enum.HumanoidHealthDisplayType.DisplayWhenDamaged
                                        if v:FindFirstChild("MonsterInfo") then
                                            z.NameDisplayDistance = 0
                                        end
                                        z.HealthDisplayDistance = 0
                                        z.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                                    end
                                end
                            end

                            if hv_connection then
                                hv_connection:Disconnect()
                                hv_connection = nil
                            end
                        end
                    end) -- <-- make sure this closing ')' exists

                    group_player:AddToggle("LegitIntent", {
                        Text = "Legit Intent",
                        Default = cheat_client.config.legit_intent
                    })

                    Toggles.LegitIntent:OnChanged(function(enabled)
                        if enabled and cheat_client.legit_intent_setup then
                            cheat_client.legit_intent_setup()
                        elseif not enabled and cheat_client.legit_intent_cleanup then
                            cheat_client.legit_intent_cleanup()
                        end
                    end)
                end
            end

            local group_overlays = Tabs.Visuals:AddRightGroupbox("Overlays")

            group_overlays:AddToggle("mana_overlay", {
                Text = "Mana Overlay",
                Default = cheat_client.config.mana_overlay,
                Callback = function(state)
                    cheat_client.config.mana_overlay = state
                    cheat_client:handle_toggle(state)
                end
            })

            group_overlays:AddToggle("better_leaderboard", {
                Text = "Better Leaderboard",
                Default = cheat_client.config.better_leaderboard,
                Callback = function(state)
                    cheat_client.config.better_leaderboard = state

                    if playerLabels then
                        for label, player in pairs(playerLabels) do
                            if label and label:IsA("TextLabel") and player then
                                if state then
                                    local color = getPlayerColor(player)
                                    label.TextColor3 = color
                                else
                                    local hasMaxEdict = player:GetAttribute("MaxEdict") == true
                                    local hasLeaderstat = is_khei
                                        and player:FindFirstChild("leaderstats")
                                        and player.leaderstats:FindFirstChild("MaxEdict")
                                        and player.leaderstats.MaxEdict.Value == true

                                    label.TextColor3 = (hasMaxEdict or hasLeaderstat)
                                        and Color3.fromRGB(255, 214, 81)
                                        or Color3.new(1, 1, 1)
                                end
                            end
                        end
                    end
                end
            })

            local group_misc_esp = Tabs.Visuals:AddLeftGroupbox("World ESP")
            local group_ingredient_esp = Tabs.Visuals:AddRightGroupbox("Ingredient ESP")
            local group_ore_esp = Tabs.Visuals:AddLeftGroupbox("Ore ESP")

            do -- Trinket
                group_misc_esp:AddToggle("TrinketEsp", {
                    Text = "Trinket ESP",
                    Default = cheat_client.config.trinket_esp
                })

                Toggles.TrinketEsp:OnChanged(function()
                    if Toggles.TrinketEsp.Value then
                        cheat_client.trinket_esp_objects = cheat_client.trinket_esp_objects or {}
                        for _, object in pairs(ws:GetChildren()) do
                            if object.Name == "Part" and object:FindFirstChild("ID") and not cheat_client.trinket_esp_objects[object] then
                                local trinket_name, trinket_color, trinket_zindex = cheat_client:identify_trinket(object)
                                cheat_client:add_trinket_esp(object, trinket_name, trinket_color, trinket_zindex)
                            end
                        end

                        cheat_client.esp_rendering.start_trinket_esp()
                    else
                        cheat_client.esp_rendering.stop_trinket_esp()

                        for trinket, esp in pairs(cheat_client.trinket_esp_objects or {}) do
                            if esp and esp.destruct then
                                esp:destruct()
                            end
                        end
                        cheat_client.trinket_esp_objects = {}
                    end
                end)

                group_misc_esp:AddToggle("TrinketShowArea", {
                    Text = "Show Area",
                    Default = cheat_client.config.trinket_show_area
                })

                group_misc_esp:AddDropdown("TrinketTypes", {
                    Text = "Show Types",
                    Values = {"Common", "Rare", "Mythic", "Artifact", "Event"},
                    Default = 1,
                    Multi = true,
                    Callback = function(value)
                        cheat_client.config.trinket_types = value
                    end
                })

                if not cheat_client.config.trinket_types then
                    cheat_client.config.trinket_types = {
                        ["Common"] = true,
                        ["Rare"] = true,
                        ["Mythic"] = true,
                        ["Artifact"] = true,
                        ["Event"] = true
                    }
                end

                group_misc_esp:AddDropdown("TrinketIgnoreRangeTypes", {
                    Text = "Unlimited Range For",
                    Values = {"Common", "Rare", "Mythic", "Artifact", "Event"},
                    Default = 1,
                    Multi = true,
                    Callback = function(value)
                        cheat_client.config.trinket_ignore_range_types = value

                        -- Auto-select unlimited range types in Show Types dropdown
                        if Options.TrinketTypes then
                            local show_types = Options.TrinketTypes.Value or {}
                            for trinket_type, enabled in pairs(value) do
                                if enabled then
                                    show_types[trinket_type] = true
                                end
                            end
                            Options.TrinketTypes:SetValue(show_types)
                        end
                    end
                })

                group_misc_esp:AddSlider("TrinketRange", {
                    Text = "Range",
                    Default = cheat_client.config.trinket_range,
                    Min = 0,
                    Max = 2000,
                    Rounding = 1
                })
            end

            group_misc_esp:AddDivider()

            do -- NPC Esp
                group_chams:AddToggle("ShriekerChams", {
                    Text = "Shrieker Chams",
                    Default = cheat_client.config.shrieker_chams
                })

                group_misc_esp:AddToggle("FallionEsp", {
                    Text = "Fallion ESP",
                    Default = cheat_client.config.fallion_esp
                })

                Toggles.FallionEsp:OnChanged(function()
                    local toggled = Toggles.FallionEsp.Value
                        cheat_client.config.fallion_esp = toggled

                        if not toggled then
                            cheat_client.esp_rendering.stop_fallion_esp()
                            for fallion, esp in pairs(cheat_client.fallion_esp_objects or {}) do
                                esp:destruct()
                            end
                            cheat_client.fallion_esp_objects = {}
                        else
                            if game.PlaceId == 5208655184 or game.PlaceId == 109732117428502 then
                                for _, fallion in next, ws.NPCs:GetChildren() do
                                    if fallion.Name == "Fallion" then
                                        cheat_client:add_fallion_esp(fallion, fallion.Name)
                                    end
                                end
                            end
                            cheat_client.esp_rendering.start_fallion_esp()
                        end
                    end)

                group_misc_esp:AddToggle("NpcEsp", {
                    Text = "NPC ESP",
                    Default = cheat_client.config.npc_esp
                })

                Toggles.NpcEsp:OnChanged(function()
                    local toggled = Toggles.NpcEsp.Value
                        cheat_client.config.npc_esp = toggled

                        if not toggled then
                            cheat_client.esp_rendering.stop_npc_esp()
                            for npc, esp in pairs(cheat_client.npc_esp_objects or {}) do
                                esp:destruct()
                            end
                            cheat_client.npc_esp_objects = {}
                        else
                            for _,object in next, ws.NPCs:GetChildren() do
                                if object:FindFirstChildOfClass('Pants') and object:FindFirstChild('Humanoid') and object:FindFirstChild('Torso') then
                                    cheat_client:add_npc_esp(object,object.Name)
                                end
                            end
                            cheat_client.esp_rendering.start_npc_esp()
                        end
                    end
                )
            end

            do -- Ingredient
                group_ingredient_esp:AddToggle("IngredientEsp", {
                    Text = "Ingredient ESP",
                    Default = cheat_client.config.ingredient_esp
                }):AddKeyPicker("IngredientEspKeybind", {
                    Default = cheat_client.config.ingredient_esp_keybind,
                    Text = "Ingredient ESP Toggle",
                    Mode = "Toggle",
                    SyncToggleState = true,
                })

                Toggles.IngredientEsp:OnChanged(function()
                    if Toggles.IngredientEsp.Value then
                        cheat_client.ingredient_esp_objects = cheat_client.ingredient_esp_objects or {}
                        if ingredient_folder then
                            for _, object in pairs(ingredient_folder:GetChildren()) do
                                if not cheat_client.ingredient_esp_objects[object] then
                                    local ingredient_name = cheat_client:identify_ingredient(object)
                                    cheat_client:add_ingredient_esp(object, ingredient_name)
                                end
                            end
                        end

                        cheat_client.esp_rendering.start_ingredient_esp()
                    else
                        cheat_client.esp_rendering.stop_ingredient_esp()

                        for ingredient, esp in pairs(cheat_client.ingredient_esp_objects or {}) do
                            if esp and esp.destruct then
                                esp:destruct()
                            end
                        end
                        cheat_client.ingredient_esp_objects = {}
                    end
                end)

                Options.IngredientEspKeybind:OnChanged(function()
                    cheat_client.config.ingredient_esp_keybind = Options.IngredientEspKeybind.Value
                end)

                group_ingredient_esp:AddSlider("IngredientRange", {
                    Text = "Range",
                    Default = cheat_client.config.ingredient_range,
                    Min = 0,
                    Max = 2000,
                    Rounding = 1
                })
            end

            do -- Ore
                if game.PlaceId ~= 14341521240 then
                    group_ore_esp:AddToggle("ore_esp", {
                    Text = "Ore ESP",
                    Default = cheat_client.config.ore_esp,
                    Callback = function(value)
                        cheat_client.config.ore_esp = value

                        if value then
                            cheat_client.ore_esp_objects = cheat_client.ore_esp_objects or {}
                            for _, object in pairs(ws.Ores:GetChildren()) do
                                if not cheat_client.ore_esp_objects[object] then
                                    cheat_client:add_ore_esp(object)
                                end
                            end

                            cheat_client.esp_rendering.start_ore_esp()
                        else
                            cheat_client.esp_rendering.stop_ore_esp()

                            -- Clean up all ore ESP objects
                            for ore, esp in pairs(cheat_client.ore_esp_objects or {}) do
                                if esp and esp.destruct then
                                    esp:destruct()
                                end
                            end
                            cheat_client.ore_esp_objects = {}
                        end
                    end
                }):AddKeyPicker("OreEspKeybind", {
                    Default = cheat_client.config.ore_esp_keybind,
                    Text = "Ore ESP Toggle",
                    Mode = "Toggle",
                    SyncToggleState = true,
                })

                Options.OreEspKeybind:OnChanged(function()
                    cheat_client.config.ore_esp_keybind = Options.OreEspKeybind.Value
                end)

                group_ore_esp:AddToggle("mythril_esp", {
                    Text = "Mythril",
                    Default = cheat_client.config.mythril_esp,
                    Callback = function(value)
                        cheat_client.config.mythril_esp = value
                    end
                })

                group_ore_esp:AddToggle("copper_esp", {
                    Text = "Copper",
                    Default = cheat_client.config.copper_esp,
                    Callback = function(value)
                        cheat_client.config.copper_esp = value
                    end
                })

                group_ore_esp:AddToggle("iron_esp", {
                    Text = "Iron",
                    Default = cheat_client.config.iron_esp,
                    Callback = function(value)
                        cheat_client.config.iron_esp = value
                    end
                })

                group_ore_esp:AddToggle("tin_esp", {
                    Text = "Tin",
                    Default = cheat_client.config.tin_esp,
                    Callback = function(value)
                        cheat_client.config.tin_esp = value
                    end
                })

                group_ore_esp:AddSlider("ore_range", {
                    Text = "Range",
                    Default = cheat_client.config.ore_range,
                    Min = 0,
                    Max = 12000,
                    Rounding = 1,
                    Callback = function(value)
                        cheat_client.config.ore_range = value
                    end
                })
                end
            end

        end

        do -- Exploits
            local group_character = Tabs.Exploits:AddLeftGroupbox("Character")
            local group_camera = Tabs.Exploits:AddRightGroupbox("Camera")
    
            do -- character
                group_character:AddToggle("instant_mine", {
                    Text = "Instant Mine",
                    Default = cheat_client.config.instant_mine,
                    Tooltip = "Need min 5 pickaxes",
                    Callback = function(value)
                        cheat_client.config.instant_mine = value
                    end
                })

                -- Commented out: local bard_stack_toggle = section_settings:Toggle({name = "bard stack", default = cheat_client.config.bard_stack, pointer = "bard_stack"})

                group_character:AddToggle("no_insanity", {
                    Text = "No Insane",
                    Default = cheat_client.config.no_insane,
                    Callback = function(state)
                        cheat_client.config.no_insane = state

                        if state then
                            if plr.Character then
                                for _,v in pairs(plr.Character:GetChildren()) do
                                    if cheat_client.mental_injuries[v.Name] then
                                        v:Destroy()
                                    end
                                end
                            end
                        end
                    end
                })

                group_character:AddDivider()

                group_character:AddButton("Reset", function()
                    if plr.Character then
                        utility:reset();
                    end
                end)

                local forcefield_con
                group_character:AddToggle("forcefield", {
                    Text = "Enter Forcefield",
                    Default = false,
                    Callback = function(state)

                        if state then
                            if plr.Character then
                                local function ff()
                                    join_server:FireServer("hey")
                                end
                                ff()
                                forcefield_con = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(child)
                                    ff()
                                end))
                            end
                        else
                            if forcefield_con then
                                forcefield_con:Disconnect();
                                forcefield_con = nil
                            end
                        end
                    end
                })

                group_character:AddButton("Give Mercenary Carry", function()
                    if plr and plr.Backpack then
                        Instance.new("Folder", plr.Backpack).Name = "MercenaryCarry"
                    end
                end)
            end

            group_character:AddDivider()

            do -- observe
                group_character:AddToggle("observe", {
                    Text = "Observe",
                    Default = cheat_client.config.observe,
                    Callback = function(state)
                        cheat_client.config.observe = state

                        if not state then
                            if plr.Character then
                                ws.CurrentCamera.CameraSubject = plr.Character
                                active_observe = nil
                            end
                        end
                    end
                })
            end

            group_camera:AddToggle("invis_cam", {
                Text = "Invis Cam",
                Default = cheat_client.config.invis_cam,
                Callback = function(state)
                    cheat_client.config.invis_cam = state

                    if state then
                        plr.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
                    else
                        plr.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
                    end
                end
            })

            if game.PlaceId ~= 14341521240 then
                group_camera:AddToggle("max_zoom", {
                    Text = "Max Zoom",
                    Default = cheat_client.config.max_zoom,
                    Callback = function(state)
                        cheat_client.config.max_zoom = state

                        if state then
                            plr.CameraMaxZoomDistance = 9e9
                        else
                            plr.CameraMaxZoomDistance = 50
                        end
                    end
                })
            end

            group_character:AddToggle("anti_globus", {
                Text = "Anti Globus",
                Default = cheat_client.config.anti_globus,
                Callback = function(value)
                    cheat_client.config.anti_globus = value
                end
            })
        end
    
        do -- Movement
            local group_flight = Tabs.Movement:AddLeftGroupbox("Flight")

            group_flight:AddToggle("flight", {
                Text = "Flight",
                Default = false,
                Callback = function(value)
                    if value then
                        if cheat_client.start_flight_rendering then
                            cheat_client.start_flight_rendering()
                        end
                    else
                        if cheat_client.stop_flight_rendering then
                            cheat_client.stop_flight_rendering()
                        end
                    end
                end
            }):AddKeyPicker("FlightKeybind", {
                Default = cheat_client.config.flight_keybind,
                Text = "Flight Toggle",
                Mode = "Toggle",
                SyncToggleState = true,
            })

            Options.FlightKeybind:OnChanged(function()
                cheat_client.config.flight_keybind = Options.FlightKeybind.Value
            end)

            group_flight:AddToggle("noclip", {
                Text = "Noclip",
                Default = cheat_client.config.noclip,
                Callback = function(value)
                    cheat_client.config.noclip = value
                end
            }):AddKeyPicker("NoclipKeybind", {
                Default = cheat_client.config.noclip_keybind,
                Text = "Noclip Toggle",
                Mode = "Toggle",
                SyncToggleState = true,
            })

            Options.NoclipKeybind:OnChanged(function()
                cheat_client.config.noclip_keybind = Options.NoclipKeybind.Value
            end)

            group_flight:AddToggle("auto_fall", {
                Text = "Auto Fall",
                Default = cheat_client.config.auto_fall,
                Callback = function(value)
                    cheat_client.config.auto_fall = value
                end
            })

            group_flight:AddSlider("flight_speed", {
                Text = "Speed",
                Default = cheat_client.config.flight_speed,
                Min = 0,
                Max = 145,
                Rounding = 1,
                Callback = function(value)
                    cheat_client.config.flight_speed = value
                end
            })

            group_flight:AddDivider()

            if game.PlaceId ~= 14341521240 then
                group_flight:AddToggle("better_flight", {
                Text = "Better Flight",
                Default = cheat_client.config.better_flight,
                Callback = function(state)
                    cheat_client.config.better_flight = state

                    if plr.Character then
                        local huma = plr.Character:FindFirstChildOfClass("Humanoid")
                        if huma then
                            if state then
                                huma:SetStateEnabled(5, false)
                                huma:ChangeState(3)
                                if cheat_client.start_better_flight then
                                    cheat_client.start_better_flight()
                                end
                            else
                                if cheat_client.stop_better_flight then
                                    cheat_client.stop_better_flight()
                                end

                                local character = plr.Character
                                local huma = character:FindFirstChildOfClass("Humanoid")

                                for _, part in ipairs(plr.Character:GetDescendants()) do
                                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                        if part.Name == "Head" or part.Name == "Torso" then
                                            part.CanCollide = true
                                        else
                                            part.CanCollide = false
                                        end
                                    end
                                end

                                if huma then
                                    huma:SetStateEnabled(5, true)
                                    huma:ChangeState(5)
                                end

                                local rootPart = character:FindFirstChild("HumanoidRootPart")
                                if rootPart then
                                    rootPart.Anchored = false
                                end
                            end
                        end
                    end
                end})

                group_flight:AddLabel("Better Flight Keybind"):AddKeyPicker("BetterFlightKeybind", {
                    Default = cheat_client.config.better_flight_keybind,
                    Text = "Better Flight Toggle",
                    Mode = "Toggle",
                    Callback = function(Value)
                        local blatant_mode_enabled = Toggles.blatant_mode and Toggles.blatant_mode.Value
                        if blatant_mode_enabled and Toggles.better_flight then
                            Toggles.better_flight:SetValue(not Toggles.better_flight.Value)
                        end
                    end
                })

                Options.BetterFlightKeybind:OnChanged(function()
                    cheat_client.config.better_flight_keybind = Options.BetterFlightKeybind.Value
                end)
            end

            -- CERESIAN FLY
        end
    
        do -- Automation
            local group_general = Tabs.Automation:AddLeftGroupbox("General")
            local group_farm = Tabs.Automation:AddRightGroupbox("Farming")

            group_general:AddToggle("auto_dialogue", {
                Text = "Auto Dialogue",
                Default = cheat_client.config.auto_dialogue,
                Callback = function(value)
                    cheat_client.config.auto_dialogue = value
                end
            })

            group_general:AddToggle("auto_bard", {
                Text = "Auto Bard",
                Default = cheat_client.config.auto_bard,
                Callback = function(value)
                    cheat_client.config.auto_bard = value
                end
            })

            group_general:AddToggle("hide_bard", {
                Text = "Hide Bard",
                Default = cheat_client.config.hide_bard,
                Callback = function(value)
                    cheat_client.config.hide_bard = value
                end
            })

            group_general:AddDivider()

            group_general:AddToggle("anti_afk", {
                Text = "Anti AFK",
                Default = cheat_client.config.anti_afk,
            })

            Toggles.anti_afk:OnChanged(function(state)
                cheat_client.config.anti_afk = state
                for _, connection in next, getconnections(plr.Idled) do
                    if state then
                        connection:Disable()
                    else
                        connection:Enable()
                    end
                end
            end)

            group_farm:AddToggle("day_farm", {
                Text = "Day Farm",
                Default = false,
                Callback = function(state)
                    cheat_client:day_farm(state)
                end
            })

            group_farm:AddToggle("day_goal_kick", {
                Text = "Kick on Day",
                Default = false,
                Callback = function(value)
                end
            })

            group_farm:AddToggle("no_kick", {
                Text = "No Kick 23 Mode",
                Default = false,
                Callback = function(value)
                end
            })

            group_farm:AddSlider("day_farm_range", {
                Text = "Range",
                Default = 500,
                Min = 100,
                Max = 2500,
                Rounding = 1,
                Callback = function(value)
                end
            })

            group_farm:AddInput("day_goal", {
                Text = "Target Day",
                Default = utility:getPlayerDays(),
                Numeric = true,
                Finished = false,
                Placeholder = "Enter target day",
                Callback = function(value)
                    -- Validate input is a number
                    local num = tonumber(value)
                    if num and num >= 0 then
                        -- Valid number
                    else
                        library:Notify("Target Day must be a valid number!", 3)
                    end
                end
            })

            group_farm:AddDivider()

            group_farm:AddToggle("loop_orderly", {
                Text = "Loop Gain Orderly",
                Default = false,
                Callback = function(value)
                end
            })

            group_farm:AddToggle("train_climb", {
                Text = "Train Climb",
                Default = false,
                Callback = function(value)
                end
            })

            group_farm:AddDivider()

            group_farm:AddToggle("SnapTrain", {
                Text = "Snap Train",
                Default = false,
                Callback = function(value)
                end
            })

            group_farm:AddToggle("AutoCharge", {
                Text = "Auto Mana Charge",
                Default = cheat_client.config.auto_charge,
                Callback = function(value)
                    cheat_client.config.auto_charge = value
                end
            })

            group_farm:AddSlider("AutoChargeThreshold", {
                Text = "Charge At Percent",
                Default = cheat_client.config.auto_charge_threshold,
                Min = 1,
                Max = 100,
                Rounding = 1,
                Callback = function(value)
                    cheat_client.config.auto_charge_threshold = value
                end
            })

            local group_automation = Tabs.Automation:AddRightGroupbox("Automation")
            local group_auto_pickup = Tabs.Automation:AddLeftGroupbox("Auto Pickup")

            -- Automation Features
            do -- Auto Potion Toggle
                group_automation:AddDropdown("potions", {
                    Text = "Potions",
                    Values = {"Health Potion", "Tespian Elixir", "Feather Feet", "Fire Protection", "Kingsbane", "Lordsbane", "Silver Sun", "Switch Witch"},
                    Default = "Health Potion",
                    Callback = function(value)
                    end
                })

                group_automation:AddDropdown("weapons", {
                    Text = "Weapons",
                    Values = {"Mythril Dagger", "Mythril Sword", "Mythril Spear", "Steel Dagger", "Steel Sword", "Steel Spear", "Bronze Dagger", "Bronze Sword", "Bronze Spear"},
                    Default = "Mythril Dagger",
                    Callback = function(value)
                    end
                })

                group_automation:AddToggle("auto_potion", {
                    Text = "Auto Potion",
                    Default = false,
                    Callback = function(state)
                        auto_pot_active = state
                        if auto_pot_active then
                            task.spawn(function()
                                while utility and auto_pot_active and shared and not shared.is_unloading do
                                    local success = false
                                    if Options and Options.potions and Options.potions.Value then
                                        success = utility:craft('Alchemy', Options.potions.Value)
                                    end

                                    -- If craft failed, stop the toggle (craft function already notified)
                                    if not success then
                                        auto_pot_active = false
                                        if Toggles and Toggles.auto_potion then
                                            Toggles.auto_potion:SetValue(false)
                                        end
                                        break
                                    end
                                end
                            end)
                        else
                            auto_pot_active = false
                        end
                    end
                })
            end

            do -- Auto Craft Toggle
                group_automation:AddToggle("auto_craft", {
                    Text = "Auto Craft",
                    Default = false,
                    Callback = function(state)
                        auto_craft_active = state
                        if auto_craft_active then
                            task.spawn(function()
                                while utility and auto_craft_active and shared and not shared.is_unloading do
                                    local success = false
                                    if Options and Options.weapons and Options.weapons.Value then
                                        success = utility:craft('Smithing', Options.weapons.Value)
                                    end

                                    -- If craft failed, stop the toggle (craft function already notified)
                                    if not success then
                                        auto_craft_active = false
                                        if Toggles and Toggles.auto_craft then
                                            Toggles.auto_craft:SetValue(false)
                                        end
                                        break
                                    end
                                end
                            end)
                        else
                            auto_craft_active = false
                        end
                    end
                })
            end

            do -- Auto Craft Delay Slider
                group_automation:AddSlider("auto_craft_delay", {
                    Text = "Auto Craft Delay",
                    Default = cheat_client.config.auto_craft_delay,
                    Min = 0.1,
                    Max = 5,
                    Rounding = 2,
                    Compact = false,
                    Suffix = "s",
                    Callback = function(value)
                        cheat_client.config.auto_craft_delay = value
                    end
                })
            end

            group_auto_pickup:AddToggle("auto_trinket", {
                Text = "Auto Trinket",
                Default = cheat_client.config.auto_trinket,
                Callback = function(value)
                    cheat_client.config.auto_trinket = value
                    if value then
                        if cheat_client.start_auto_trinket_rendering then
                            cheat_client.start_auto_trinket_rendering()
                        end
                    else
                        if cheat_client.stop_auto_trinket_rendering then
                            cheat_client.stop_auto_trinket_rendering()
                        end
                    end
                end
            }):AddKeyPicker("AutoTrinketPickupKeybind", {
                Default = cheat_client.config.auto_trinket_keybind,
                Text = "Auto Trinket Toggle",
                Mode = "Toggle",
                SyncToggleState = true,
            })

            Options.AutoTrinketPickupKeybind:OnChanged(function()
                cheat_client.config.auto_trinket_keybind = Options.AutoTrinketPickupKeybind.Value
            end)

            group_auto_pickup:AddToggle("auto_ingredient", {
                Text = "Auto Ingredient",
                Default = cheat_client.config.auto_ingredient,
                Callback = function(value)
                    cheat_client.config.auto_ingredient = value
                    if value then
                        if cheat_client.start_auto_ingredient_rendering then
                            cheat_client.start_auto_ingredient_rendering()
                        end
                    else
                        if cheat_client.stop_auto_ingredient_rendering then
                            cheat_client.stop_auto_ingredient_rendering()
                        end
                    end
                end
            }):AddKeyPicker("AutoIngredientPickupKeybind", {
                Default = cheat_client.config.auto_ingredient_keybind,
                Text = "Auto Ingredient Toggle",
                Mode = "Toggle",
                SyncToggleState = true,
            })

            Options.AutoIngredientPickupKeybind:OnChanged(function()
                cheat_client.config.auto_ingredient_keybind = Options.AutoIngredientPickupKeybind.Value
            end)

            group_auto_pickup:AddToggle("auto_weapon", {
                Text = "Auto Weapon",
                Default = cheat_client.config.auto_weapon,
                Callback = function(value)
                    cheat_client.config.auto_weapon = value
                end
            }):AddKeyPicker("AutoWeaponKeybind", {
                Default = cheat_client.config.auto_weapon_keybind,
                Text = "Auto Weapon Toggle",
                Mode = "Toggle",
                SyncToggleState = true,
            })

            Options.AutoWeaponKeybind:OnChanged(function()
                cheat_client.config.auto_weapon_keybind = Options.AutoWeaponKeybind.Value
            end)

            group_auto_pickup:AddToggle("auto_resurrection", {
                Text = "Auto Resurrection",
                Default = cheat_client.config.auto_resurrection,
                Callback = function(value)
                    cheat_client.config.auto_resurrection = value
                end
            })

            group_auto_pickup:AddToggle("auto_chair", {
                Text = "Auto Chair",
                Default = cheat_client.config.auto_chair,
                Callback = function(value)
                    cheat_client.config.auto_chair = value
                end
            })

            group_auto_pickup:AddDivider()

            group_auto_pickup:AddToggle("auto_bag", {
                Text = "Auto Bag",
                Default = cheat_client.config.auto_bag,
                Callback = function(value)
                    cheat_client.config.auto_bag = value

                    if value then
                        if cheat_client.start_auto_bag then
                            cheat_client.start_auto_bag()
                        end
                    else
                        if cheat_client.stop_auto_bag then
                            cheat_client.stop_auto_bag()
                        end
                    end
                end
            }):AddKeyPicker("AutoBagKeybind", {
                Default = cheat_client.config.auto_bag_keybind,
                Text = "Auto Bag Toggle",
                Mode = "Toggle",
                SyncToggleState = true,
            })

            Options.AutoBagKeybind:OnChanged(function()
                cheat_client.config.auto_bag_keybind = Options.AutoBagKeybind.Value
            end)

            group_auto_pickup:AddSlider("bag_range", {
                Text = "Range",
                Default = cheat_client.config.bag_range,
                Min = 1,
                Max = 100,
                Rounding = 1,
                Callback = function(value)
                    cheat_client.config.bag_range = value
                end
            })

        end
        
        do -- World
            local group_world = Tabs.World:AddLeftGroupbox("World Settings")
                
            group_world:AddToggle("freecam", {
                Text = "Freecam",
                Default = false,
                Callback = function(state)
                    local camera = utility:GetCamera()
                    if plr.character then
                        local humanoid, torso = plr.Character:FindFirstChildOfClass("Humanoid"), plr.Character:FindFirstChild("Torso")

                        if humanoid and torso then
                            if state then
                                camera.CameraType = Enum.CameraType.Scriptable
                                StartCapture()
                                -- Start the rendering loop
                                if cheat_client.start_freecam_rendering then
                                    cheat_client.start_freecam_rendering()
                                end
                            else
                                camera.CameraType = Enum.CameraType.Custom
                                StopCapture()
                                camera.CameraSubject = humanoid
                                -- Stop the rendering loop
                                if cheat_client.stop_freecam_rendering then
                                    cheat_client.stop_freecam_rendering()
                                end
                            end
                        end
                    end
                end
            }):AddKeyPicker("FreecamKeybind", {
                Default = cheat_client.config.freecam_keybind,
                Text = "Freecam Toggle",
                Mode = "Toggle",
                SyncToggleState = true,
            })

            Options.FreecamKeybind:OnChanged(function()
                cheat_client.config.freecam_keybind = Options.FreecamKeybind.Value
            end)

            group_world:AddSlider("freecam_speed", {
                Text = "Freecam Speed",
                Default = cheat_client.config.freecam_speed,
                Min = 0,
                Max = 12,
                Rounding = 1,
                Callback = function(value)
                    cheat_client.config.freecam_speed = value
                end
            })

            group_world:AddDivider()
            
            do -- No Kill Bricks
                local function killbrick(state, container)
                    for _, v in next, container:GetChildren() do
                        if v:IsA("BasePart") and v:FindFirstChild("TouchInterest") and not (cheat_client.safe_bricks[v.Name] or cheat_client.must_touch[v.BrickColor.Number]) then
                            v.CanTouch = not state
                        end
                    end
                end

                local container
                if game.PlaceId == 5208655184 then
                    container = ws:FindFirstChild("Map")
                elseif game.PlaceId == 3541987450 then
                    container = ws
                end

                if container then
                    group_world:AddToggle("no_killbrick", {
                        Text = "No Kill Bricks",
                        Default = cheat_client.config.no_killbrick,
                        Callback = function(state)
                            killbrick(state, container)
                        end
                    })
                end
            end

            group_world:AddToggle("no_fall", {
                Text = "No Fall Damage",
                Default = cheat_client.config.no_fall,
                Callback = function(value)
                    cheat_client.config.no_fall = value
                end
            })

            do -- No Mob Trigger
                local function mob_trigger(state)
                    local monsters = workspace:FindFirstChild("MonstersSpawns") or workspace:FindFirstChild("MonsterSpawns")
                    if monsters and monsters:FindFirstChild("Triggers") then
                        for _, obj in ipairs(monsters.Triggers:GetDescendants()) do
                            if obj and obj.ClassName == "Part" then
                                pcall(function()
                                    obj.CanTouch = not state
                                end)
                            end
                        end
                    end
                end

                group_world:AddToggle("no_mob_trigger", {
                    Text = "No Mob Trigger",
                    Default = cheat_client.config.no_mob_trigger,
                    Callback = function(state)
                        cheat_client.config.no_mob_trigger = state
                        mob_trigger(state)
                    end
                })
            end

            group_world:AddToggle("temperature_lock", {
                Text = "Temperature Lock",
                Default = cheat_client.config.temperature_lock,
                Tooltip = "!!! Disables trinkets from spawning",
                Callback = function(value)
                    cheat_client.config.temperature_lock = value
                end
            })

            do -- Textures
                local texture_connections = {}
                local blacklisted_containers = {workspace.Thrown}

                local function blacklisted(part)
                    for _, container in pairs(blacklisted_containers) do
                        if part:IsDescendantOf(container) then
                            if container == workspace.Thrown then
                                local model = part.Parent
                                while model and model ~= workspace do
                                    if model:IsA("Model") and model.Name == "EarthPillar" then
                                        return false
                                    end
                                    model = model.Parent
                                end
                            end
                            return true
                        end
                    end
                    return false
                end

                local function apply(part)
                    if not part or not part:IsA("BasePart") then
                        return
                    end
                    if part:IsDescendantOf(game) == false then
                        return
                    end
                    if part.Material == Enum.Material.ForceField then
                        return
                    end
                    if blacklisted(part) then
                        return
                    end

                    if not original_materials[part] then
                        original_materials[part] = {
                            Material = part.Material,
                            Reflectance = part.Reflectance
                        }
                    end

                    part.Material = Enum.Material.SmoothPlastic
                    part.Reflectance = 0
                end

                local function restore(part)
                    if original_materials[part] then
                        part.Material = original_materials[part].Material
                        part.Reflectance = original_materials[part].Reflectance
                    end
                end

                group_world:AddToggle("textures", {
                    Text = "Textures",
                    Default = cheat_client.config.textures,
                    Callback = function(state)
                        if state then
                            task.spawn(function()
                                local descendants = workspace:GetDescendants()
                                local batchSize = 500
                                for i = 1, #descendants, batchSize do
                                    for j = i, math.min(i + batchSize - 1, #descendants) do
                                        apply(descendants[j])
                                    end
                                    task.wait()
                                end
                            end)

                            texture_connections[#texture_connections + 1] = utility:Connection(workspace.DescendantAdded, function(descendant)
                                if Toggles and Toggles.textures and Toggles.textures.Value then
                                    apply(descendant)
                                end
                            end)
                        else
                            for _, connection in pairs(texture_connections) do
                                connection:Disconnect()
                            end
                            texture_connections = {}

                            for part, _ in pairs(original_materials) do
                                if part and part.Parent then
                                    restore(part)
                                end
                            end
                            table.clear(original_materials)
                        end
                        cheat_client.config.textures = state
                    end
                })
            end

            group_world:AddDivider()

            do -- Proximity Notifier
                group_world:AddToggle("proximity_notifier", {
                    Text = "Proximity Notifier",
                    Default = cheat_client.config.proximity_notifier
                })

                Toggles.proximity_notifier:OnChanged(function(enabled)
                    cheat_client.config.proximity_notifier = enabled

                    if enabled and cheat_client.proximity_setup then
                        cheat_client.proximity_setup()
                    elseif not enabled and cheat_client.proximity_cleanup then
                        cheat_client.proximity_cleanup()
                    end
                end)

                group_world:AddToggle("proximity_ignore_allies", {
                    Text = "Ignore Allies",
                    Default = cheat_client.config.proximity_ignore_allies,
                    Tooltip = "Don't notify when allies are nearby"
                })

                Toggles.proximity_ignore_allies:OnChanged(function(value)
                    cheat_client.config.proximity_ignore_allies = value
                end)

                group_world:AddSlider("proximity_distance", {
                    Text = "Distance Threshold",
                    Default = cheat_client.config.proximity_distance or 100,
                    Min = 0,
                    Max = 1000,
                    Rounding = 0,
                    Suffix = " studs",
                    Callback = function(value)
                        cheat_client.config.proximity_distance = value
                    end
                })
            end

            local group_environment = Tabs.World:AddRightGroupbox("Environment")

            do -- Environment
                group_environment:AddToggle("fullbright", {
                    Text = "Fullbright",
                    Default = cheat_client.config.fullbright,
                    Callback = function(state)
                        cheat_client.config.fullbright = state

                        if state then
                            lit.areacolor.Enabled = false
                            local brightness_multiplier = cheat_client.config.brightness_level / 100
                            local color = Color3.new(brightness_multiplier, brightness_multiplier, brightness_multiplier)
                            lit.Ambient = color
                            lit.OutdoorAmbient = color
                            lit.Brightness = 1 + (brightness_multiplier * 2) -- Range: 1-3
                        else
                            lit.areacolor.Enabled = true
                            lit.Brightness = 1
                            cheat_client:restore_ambience()

                            if cheat_client.config.no_fog then
                                lit.FogColor = Color3.fromRGB(254, 254, 254)
                                lit.FogEnd = 100000
                                lit.FogStart = 50
                            end
                        end
                    end
                }):AddKeyPicker("FullbrightKeybind", {
                    Default = cheat_client.config.fullbright_keybind,
                    Text = "Fullbright Toggle",
                    Mode = "Toggle",
                    SyncToggleState = true,
                })

                Options.FullbrightKeybind:OnChanged(function()
                    cheat_client.config.fullbright_keybind = Options.FullbrightKeybind.Value
                end)

                group_environment:AddSlider("brightness_level", {
                    Text = "Brightness Level",
                    Default = cheat_client.config.brightness_level,
                    Min = 0,
                    Max = 100,
                    Rounding = 0,
                    Compact = false,
                    Callback = function(value)
                        cheat_client.config.brightness_level = value

                        if cheat_client.config.fullbright then
                            local brightness_multiplier = value / 100
                            local color = Color3.new(brightness_multiplier, brightness_multiplier, brightness_multiplier)

                            lit.Ambient = color
                            lit.OutdoorAmbient = color
                            lit.Brightness = 1 + (brightness_multiplier * 2) -- Range: 1-3
                        end
                    end
                })

                group_environment:AddToggle("no_fog", {
                    Text = "No Fog",
                    Default = cheat_client.config.no_fog,
                    Callback = function(state)
                        cheat_client.config.no_fog = state

                        if state then
                            lit.FogColor = Color3.fromRGB(254, 254, 254)
                            lit.FogEnd = 100000
                            lit.FogStart = 50
                        else
                            cheat_client:restore_ambience()
                        end
                    end
                }):AddKeyPicker("NoFogKeybind", {
                    Default = cheat_client.config.no_fog_keybind,
                    Text = "No Fog Toggle",
                    Mode = "Toggle",
                    SyncToggleState = true,
                })

                Options.NoFogKeybind:OnChanged(function()
                    cheat_client.config.no_fog_keybind = Options.NoFogKeybind.Value
                end)

                group_environment:AddToggle("change_time", {
                    Text = "Change Time",
                    Default = cheat_client.config.change_time,
                    Callback = function(state)
                        cheat_client.config.change_time = state

                        if state then
                            lit.ClockTime = Options and Options.clock_time and Options.clock_time.Value
                        end
                    end
                })

                group_environment:AddSlider("clock_time", {
                    Text = "Time",
                    Default = cheat_client.config.clock_time,
                    Min = 1,
                    Max = 24,
                    Rounding = 1,
                    Callback = function(value)
                        cheat_client.config.clock_time = value
                        -- Update time immediately if change_time is enabled
                        if Toggles.change_time and Toggles.change_time.Value then
                            lit.ClockTime = value
                        end
                    end
                })

                group_environment:AddToggle("no_blindness", {
                    Text = "No Blindness",
                    Default = cheat_client.config.no_blindness,
                    Callback = function(state)
                        cheat_client.config.no_blindness = state

                        if state then
                            lit:WaitForChild("Blindness").Enabled = false
                        else
                            lit:WaitForChild("Blindness").Enabled = true
                        end
                    end
                })

                group_environment:AddToggle("no_blur", {
                    Text = "No Blur",
                    Default = cheat_client.config.no_blur,
                    Callback = function(state)
                        cheat_client.config.no_blur = state

                        if state then
                            lit:WaitForChild("Blur").Enabled = false
                        else
                            lit:WaitForChild("Blur").Enabled = true
                        end
                    end
                })

                group_environment:AddToggle("no_sanity", {
                    Text = "No Sanity",
                    Default = cheat_client.config.no_sanity,
                    Callback = function(state)
                        cheat_client.config.no_sanity = state

                        if state then
                            lit:WaitForChild("Sanity").Enabled = false
                        else
                            lit:WaitForChild("Sanity").Enabled = true
                        end
                    end
                })
            end
        end


        do -- Misc
            local group_misc = Tabs.Misc:AddLeftGroupbox("Misc Settings")

            local function wait_danger()
                while shared and not shared.is_unloading and cs:HasTag(plr.Character, "Danger") and not (Toggles and Toggles.ignore_danger and Toggles.ignore_danger.Value) do
                    rs.Heartbeat:Wait()
                end
            end

            if not LPH_OBFUSCATED then
                group_misc:AddToggle("spoof_the_soul", {
                    Text = "Spoof The Soul",
                    Default = cheat_client.config.the_soul,
                    Callback = function(value)
                        cheat_client.config.the_soul = value
                    end
                })

                group_misc:AddToggle("spoof_acrobat", {
                    Text = "Spoof Double Jump",
                    Default = cheat_client.config.double_jump,
                    Callback = function(value)
                        cheat_client.config.double_jump = value
                    end
                })
            end

            group_misc:AddToggle("better_mana", {
                Text = "Better Mana Charge",
                Default = cheat_client.config.better_mana,
                Callback = function(value)
                    cheat_client.config.better_mana = value
                end
            })

            group_misc:AddDivider()
            
            group_misc:AddButton({
                Text = "Copy Leaderboard",
                Func = function()
                    local result = ""
                    local with_links = {}
                    local without_links = {}

                    local server_name, server_region = get_server_info()
                    if server_name ~= "" and server_region ~= "" then
                        result = server_name .. " " .. game.JobId .. " [" .. server_region .. "]\n\n"
                    end

                    for _, player in ipairs(plrs:GetPlayers()) do
                        if player ~= plr then
                            local displayName = cheat_client:get_name(player)
                            local profileLink = "<https://www.roblox.com/users/" .. tostring(player.UserId) .. "/profile>"

                            local joinable = utility:get_presence(player.UserId)
                            if joinable then
                                with_links[#with_links + 1] = displayName .. " [" .. player.Name .. "] " .. profileLink
                            else
                                without_links[#without_links + 1] = displayName .. " [" .. player.Name .. "]"
                            end
                        end
                    end

                    if #with_links > 0 then
                        result = result .. table.concat(with_links, "\n")

                        if #without_links > 0 then
                            result = result .. "\n"
                        end
                    end

                    if #without_links > 0 then
                        result = result .. table.concat(without_links, "\n")
                    end

                    setclipboard(result)
                end
            })


            group_misc:AddButton({
                Text = "Unblock All",
                DoubleClick = true,
                Func = function()
                    utility:UnblockAll()
                end
            })

            group_misc:AddButton({
                Text = "Shutdown Client",
                DoubleClick = true,
                Func = function()
                    wait_danger();
                    if rps.Requests and rps.Requests:FindFirstChild("ReturnToMenu") and plr.Character then
                        rps.Requests.ReturnToMenu:InvokeServer()
                    end
                    game:Shutdown();
                end
            })
            
            group_misc:AddButton({
                Text = "Reconnect",
                DoubleClick = true,
                Func = function()
                    wait_danger();
                    if rps.Requests and rps.Requests:FindFirstChild("ReturnToMenu") and plr.Character then
                        rps.Requests.ReturnToMenu:InvokeServer()
                    end
                    utility:ForceRejoin();
                end
            })
            
            group_misc:AddButton({
                Text = "Serverhop",
                DoubleClick = true,
                Func = function()
                    wait_danger();
                    if rps.Requests and rps.Requests:FindFirstChild("ReturnToMenu") and plr.Character then
                        rps.Requests.ReturnToMenu:InvokeServer()
                    end
                    utility:Serverhop();
                end
            })

            group_misc:AddDivider()
    
            group_misc:AddToggle("roblox_chat", {
                Text = "Roblox Chat",
                Default = cheat_client.config.roblox_chat,
                Callback = function(state)
                    if state then
                        txt.ChatWindowConfiguration.Enabled = true
                    else
                        txt.ChatWindowConfiguration.Enabled = false
                    end
                    cheat_client.config.roblox_chat = state
                end
            })

            do -- Unhide Players
                local unhide_connections = {}
                local unhide_playeradded_connection

                group_misc:AddToggle("unhide_players", {
                    Text = "Unhide Players",
                    Default = cheat_client.config.unhide_players,
                    Callback = function(state)
                        if state then
                            local function unhide_player(v)
                                if v:GetAttribute("Hidden") then
                                    v:SetAttribute("Hidden", false)
                                end

                                -- Khei: Also handle leaderstats.Hidden
                                if game.PlaceId == 3541987450 then
                                    local leaderstats = v:FindFirstChild("leaderstats")
                                    if leaderstats then
                                        local hidden = leaderstats:FindFirstChild("Hidden")
                                        if hidden and hidden:IsA("BoolValue") and hidden.Value then
                                            hidden.Value = false
                                        end
                                    end
                                end

                                if unhide_connections[v] then
                                    unhide_connections[v]:Disconnect()
                                    unhide_connections[v] = nil
                                end

                                unhide_connections[v] = utility:Connection(v.AttributeChanged, function(attribute)
                                    if attribute == "Hidden" and v:GetAttribute("Hidden") == true then
                                        v:SetAttribute("Hidden", false)
                                    end
                                end)

                                -- Khei:
                                if game.PlaceId == 3541987450 then
                                    local leaderstats = v:FindFirstChild("leaderstats")
                                    if leaderstats then
                                        local hidden = leaderstats:FindFirstChild("Hidden")
                                        if hidden and hidden:IsA("BoolValue") then
                                            unhide_connections[v.Name.."_leaderstats"] = utility:Connection(hidden.Changed, function()
                                                if hidden.Value == true then
                                                    hidden.Value = false
                                                end
                                            end)
                                        end
                                    end
                                end
                            end

                            for _, v in pairs(plrs:GetPlayers()) do
                                unhide_player(v)
                            end

                            unhide_playeradded_connection = utility:Connection(plrs.PlayerAdded, function(v)
                                unhide_player(v)
                            end)

                        else
                            for _, v in pairs(plrs:GetPlayers()) do
                                local char = v.Character
                                local backpack = v:FindFirstChild("Backpack")

                                local jack_char = char and char:FindFirstChild("Jack")
                                local jack_bag = backpack and backpack:FindFirstChild("Jack")

                                if (jack_char and jack_char:IsA("Tool")) or (jack_bag and jack_bag:IsA("Tool")) then
                                    v:SetAttribute("Hidden", true)

                                    -- Khei:
                                    if game.PlaceId == 3541987450 then
                                        local leaderstats = v:FindFirstChild("leaderstats")
                                        if leaderstats then
                                            local hidden = leaderstats:FindFirstChild("Hidden")
                                            if hidden and hidden:IsA("BoolValue") then
                                                hidden.Value = true
                                            end
                                        end
                                    end
                                end

                                if unhide_connections[v] then
                                    unhide_connections[v]:Disconnect()
                                    unhide_connections[v] = nil
                                end

                                -- Khei:
                                if unhide_connections[v.Name.."_leaderstats"] then
                                    unhide_connections[v.Name.."_leaderstats"]:Disconnect()
                                    unhide_connections[v.Name.."_leaderstats"] = nil
                                end
                            end

                            if unhide_playeradded_connection then
                                unhide_playeradded_connection:Disconnect()
                                unhide_playeradded_connection = nil
                            end
                        end

                        cheat_client.config.unhide_players = state
                    end
                })
            end

            
            group_misc:AddToggle("gate_anti_backfire", {
                Text = "Gate Anti Backfire",
                Default = cheat_client.config.gate_anti_backfire,
                Callback = function(value)
                    cheat_client.config.gate_anti_backfire = value
                end
            })
        end

        do -- timers
            local group_timers = Tabs.Misc:AddRightGroupbox("Server Info")

            group_timers:AddLabel("PlrsServer", {
                Text = "Players: " .. #plrs:GetPlayers(),
                DoesWrap = false
            })

            group_timers:AddLabel("InventoryValue", {
                Text = "Inventory Value: 0",
                DoesWrap = false
            })

            group_timers:AddDivider()

            if game.PlaceId == 5208655184 then
                -- Castle Rock timer label
                group_timers:AddLabel("CrLastLooted", {
                    Text = "Castle Rock: " .. math.floor((os.time() - workspace:WaitForChild("MonsterSpawns"):WaitForChild("Triggers"):WaitForChild("CastleRockSnake"):WaitForChild("LastSpawned").Value) / 60) .. "m",
                    DoesWrap = false
                })

                group_timers:AddLabel("TempleLastLooted", {
                    Text = "Temple of Fire: " .. math.floor((os.time() - workspace:WaitForChild("MonsterSpawns"):WaitForChild("Triggers"):WaitForChild("MazeSnakes"):WaitForChild("LastSpawned").Value) / 60) .. "m",
                    DoesWrap = false
                })

                group_timers:AddLabel("DeepLastLooted", {
                    Text = "Deep Sunken: " .. math.floor((os.time() - workspace:WaitForChild("MonsterSpawns"):WaitForChild("Triggers"):WaitForChild("evileye2"):WaitForChild("LastSpawned").Value) / 60) .. "m",
                    DoesWrap = false
                })

                group_timers:AddLabel("CryptLastLooted", {
                    Text = "Crypt of Kings: " .. math.floor((os.time() - workspace:WaitForChild("MonsterSpawns"):WaitForChild("Triggers"):WaitForChild("CryptTrigger"):WaitForChild("LastSpawned").Value) / 60) .. "m",
                    DoesWrap = false
                })
            elseif game.PlaceId == 3541987450 then
                group_timers:AddLabel("blank2", {
                    Text = " ",
                    DoesWrap = false
                })
                
                group_timers:AddLabel("PlayerBlessings", {
                    Text = "Blessings: None",
                    DoesWrap = false
                })

                group_timers:AddLabel("blank1", {
                    Text = " ",
                    DoesWrap = false
                })
            end
        end

        do -- Server Join
            local group_server_join = Tabs.Misc:AddRightGroupbox("Server Join")
            local debounce = false

            local function return_to_menu()
                if plr.Character then
                    if cs:HasTag(plr.Character, "Danger") and not (Toggles and Toggles.ignore_danger and Toggles.ignore_danger.Value) then
                        library:Notify("You are in danger! Please wait for safety before joining.")
                        repeat rs.Heartbeat:Wait() until not plr.Character or not cs:HasTag(plr.Character, "Danger") or (Toggles and Toggles.ignore_danger and Toggles.ignore_danger.Value)
                    end
                    library:Notify("Returning to menu before joining...")
                    rps.Requests.ReturnToMenu:InvokeServer()
                    task.wait(0.5)
                end
            end

            local function join_game_by_id(jobId)
                if not jobId or jobId == "" then
                    library:Notify("Please enter a valid Job ID")
                    return
                end

                return_to_menu()
                library:Notify("Joining server: " .. jobId)

                -- Use retry logic like attemptTeleport
                teleport_failed = false
                teleport_fail_reason = ""
                join_server:FireServer(jobId)

                -- Wait for teleport to succeed or fail
                local timeout = tick() + 20
                while tick() < timeout and not teleport_failed do
                    task.wait(0.1)
                end

                if not teleport_failed then
                    print("[TELEPORT] Join appears successful, waiting for transition...")
                    task.wait(5)
                else
                    warn(string.format("[TELEPORT FAILED] Could not join server: %s", teleport_fail_reason))
                    library:Notify("Server join failed: " .. teleport_fail_reason)
                end
            end

            local function join_game_by_username(username)
                if debounce then
                    library:Notify("Please wait before trying again.")
                    return
                end
                debounce = true

                task.delay(2, function()
                    debounce = false
                end)

                if not username or username == "" then
                    library:Notify("Please enter a valid username")
                    debounce = false
                    return
                end

                library:Notify("Searching servers for '" .. username .. "' ...")
                local httpService = game:GetService("HttpService")
                local serverInfo = rps:FindFirstChild("ServerInfo")
                if serverInfo then
                    for _, serverFolder in ipairs(serverInfo:GetChildren()) do
                        local jobId = serverFolder.Name
                        local playersValue = serverFolder:FindFirstChild("Players")

                        if playersValue and playersValue:IsA("StringValue") then
                            local success, playerData = pcall(function()
                                return httpService:JSONDecode(playersValue.Value)
                            end)

                            if success and playerData and type(playerData) == "table" then
                                for _, playerInfo in ipairs(playerData) do
                                    if playerInfo.Name and playerInfo.Name:lower() == username:lower() then
                                        library:Notify("Found '" .. username .. "' in server! Joining...")
                                        library:Notify("Server ID: " .. jobId)
                                        join_game_by_id(jobId)
                                        return
                                    end
                                end
                            end
                        end
                    end
                end

                library:Notify("Not found in server list, checking API...")
                local success, userId = pcall(function()
                    return plrs:GetUserIdFromNameAsync(username)
                end)

                if not success or not userId then
                    library:Notify("Couldn't find user '" .. username .. "'")
                    debounce = false
                    return
                end

                library:Notify("Checking if user is in a joinable game...")

                local joinable, jobId = utility:get_presence(userId)
                if not joinable then
                    library:Notify("User is not in a joinable game.")
                    return
                end

                library:Notify("Server ID: " .. jobId)
                join_game_by_id(jobId)
            end

            group_server_join:AddInput("JobIdInput", {
                Default = "",
                Numeric = false,
                Finished = false,
                Text = "Enter Job ID(s)",
                Tooltip = "Enter Job ID(s) separated by commas (e.g., 'jobid1,jobid2,jobid3')",
                Placeholder = "Enter Job ID(s) (comma separated)"
            })

            group_server_join:AddButton({
                Text = "Join by JobID",
                Func = function()
                    local jobId = Options.JobIdInput.Value
                    join_game_by_id(jobId)
                end,
                DoubleClick = false,
                Tooltip = "Join server using the Job ID"
            })

            group_server_join:AddInput("PlayerNameInput", {
                Default = "",
                Numeric = false,
                Finished = false,
                Text = "Enter Player Name",
                Tooltip = "Enter the player name to join their server",
                Placeholder = "Enter Player Name"
            })

            group_server_join:AddButton({
                Text = "Join by Player Name",
                Func = function()
                    local username = Options.PlayerNameInput.Value
                    join_game_by_username(username)
                end,
                DoubleClick = false,
                Tooltip = "Join the server where this player is currently playing"
            })

            group_server_join:AddDivider()

            do -- Loop Join
                local loop_join_connection = nil
                local loop_join_last_attempt = 0
                local current_job_index = 1

                group_server_join:AddToggle("loop_join", {
                    Text = "Loop Join",
                    Default = cheat_client.config.loop_join,
                    Tooltip = "Continuously attempt to join the Job ID(s) in the textbox above (10 attempts per second, cycles through multiple IDs)",
                    Callback = function(value)
                        cheat_client.config.loop_join = value

                        if loop_join_connection then
                            loop_join_connection:Disconnect()
                            loop_join_connection = nil
                        end

                        if value then
                            current_job_index = 1

                            cpu.status.active = true
                            if shared.loopJoinFocusConnection then
                                shared.loopJoinFocusConnection:Disconnect()
                            end

                            shared.loopJoinFocusConnection = utility:Connection(uis.WindowFocused, function()
                                cpu.status.focused = true
                                if cpu.status.hd_mode then
                                    setfpscap(50)
                                else
                                    setfpscap(20)
                                end
                                cpu.services.ugs.MasterVolume = cpu.services.ms
                                settings().Rendering.QualityLevel = cpu.services.ql
                                cpu.services.rs:Set3dRenderingEnabled(true)
                            end)

                            if shared.loopJoinUnfocusConnection then
                                shared.loopJoinUnfocusConnection:Disconnect()
                            end

                            shared.loopJoinUnfocusConnection = utility:Connection(uis.WindowFocusReleased, function()
                                cpu.status.focused = false
                                setfpscap(15)
                                settings().Rendering.QualityLevel = 1
                                cpu.services.rs:Set3dRenderingEnabled(false)
                            end)

                            loop_join_connection = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                                local current_time = tick()
                                if current_time - loop_join_last_attempt < 0.1 then return end
                                loop_join_last_attempt = current_time

                                if Options and Options.JobIdInput then
                                    local input_value = Options.JobIdInput.Value
                                    if input_value and input_value ~= "" then
                                        local job_ids = {}
                                        for job_id in string.gmatch(input_value, "[^,]+") do
                                            local trimmed = job_id:match("^%s*(.-)%s*$")
                                            if trimmed ~= "" then
                                                job_ids[#job_ids + 1] = trimmed
                                            end
                                        end

                                        if #job_ids > 0 then
                                            local jobId = job_ids[current_job_index]

                                            pcall(function()
                                                if plr.Character then
                                                    if cs:HasTag(plr.Character, "Danger") and not (Toggles and Toggles.ignore_danger and Toggles.ignore_danger.Value) then
                                                        repeat rs.Heartbeat:Wait() until not plr.Character or not cs:HasTag(plr.Character, "Danger") or (Toggles and Toggles.ignore_danger and Toggles.ignore_danger.Value)
                                                    end
                                                    rps.Requests.ReturnToMenu:InvokeServer()
                                                    task.wait(0.5)
                                                end

                                                join_server:FireServer(jobId)
                                            end)

                                            if #job_ids > 1 then
                                                current_job_index = (current_job_index % #job_ids) + 1
                                            end
                                        end
                                    end
                                end
                            end))
                        else
                            cpu.status.active = false
                            setfpscap(999)
                            settings().Rendering.QualityLevel = cpu.services.ql
                            cpu.services.rs:Set3dRenderingEnabled(true)

                            if shared.loopJoinFocusConnection then
                                shared.loopJoinFocusConnection:Disconnect()
                                shared.loopJoinFocusConnection = nil
                            end

                            if shared.loopJoinUnfocusConnection then
                                shared.loopJoinUnfocusConnection:Disconnect()
                                shared.loopJoinUnfocusConnection = nil
                            end
                        end
                    end
                })

                if Toggles.loop_join then
                    Toggles.loop_join:SetValue(cheat_client.config.loop_join)
                end
            end

            group_server_join:AddToggle("ignore_danger", {
                Text = "Ignore Danger",
                Default = cheat_client.config.ignore_danger,
                Callback = function(value)
                    cheat_client.config.ignore_danger = value
                end
            })

            group_server_join:AddToggle("execute_on_serverhop", {
                Text = "Execute on Serverhop",
                Default = cheat_client.config.execute_on_serverhop,
                Tooltip = "Automatically re-execute the script after teleporting to another server",
                Callback = function(value)
                    cheat_client.config.execute_on_serverhop = value
                end
            })

            group_server_join:AddDivider()

            group_server_join:AddButton({
                Text = "Join Largest Server",
                Func = function()
                    library:Notify("Finding largest server...")
                    local jobId = utility:get_largest_server()
                    if jobId then
                        utility:add_server_to_history(jobId)
                        join_game_by_id(jobId)
                    else
                        library:Notify("Failed to find largest server")
                    end
                end,
                DoubleClick = false,
                Tooltip = "Join the server with the most players"
            })

            group_server_join:AddButton({
                Text = "Join Smallest Server",
                Func = function()
                    library:Notify("Finding smallest server...")
                    local jobId = utility:get_smallest_server()
                    if jobId then
                        utility:add_server_to_history(jobId)
                        join_game_by_id(jobId)
                    else
                        library:Notify("Failed to find smallest server")
                    end
                end,
                DoubleClick = false,
                Tooltip = "Join the server with the least players"
            })

            group_server_join:AddButton({
                Text = "Join Oldest Server",
                Func = function()
                    library:Notify("Finding oldest server...")
                    local jobId = utility:get_oldest_server()
                    if jobId then
                        utility:add_server_to_history(jobId)
                        join_game_by_id(jobId)
                    else
                        library:Notify("Failed to find oldest server")
                    end
                end,
                DoubleClick = false,
                Tooltip = "Join the server with the highest lifespan"
            })

            group_server_join:AddButton({
                Text = "Join Newest Server",
                Func = function()
                    library:Notify("Finding newest server...")
                    local jobId = utility:get_newest_server()
                    if jobId then
                        utility:add_server_to_history(jobId)
                        join_game_by_id(jobId)
                    else
                        library:Notify("Failed to find newest server")
                    end
                end,
                DoubleClick = false,
                Tooltip = "Join the server with the lowest lifespan"
            })

            group_server_join:AddDivider()

            group_server_join:AddButton({
                Text = "Clear Server History",
                Func = function()
                    utility:clear_server_history()
                    library:Notify("Server history cleared")
                end,
                DoubleClick = false,
                Tooltip = "Clear recent server cache (max 15 servers)"
            })

        end

        do -- Spoofing
            local group_spoofing = Tabs.Misc:AddLeftGroupbox("Spoofing")

            local char_custom_connection = nil
            local current_accessories = {}
            local char_monitor_connections = {}
            local char_custom_enabled = {
                face = false,
                shirt = false,
                pants = false,
                accessories = false,
                skin_color = false,
                rlface_color = false,
                clothing_dye = false
            }
            local original_char_state = {
                face = nil,
                shirt = nil,
                pants = nil,
                skin_color = nil,
                rlface_color = nil,
                cached = false
            }

            local function clear_character_item(character, class_name)
                if not character or not character.Parent then return end
                local item = character:FindFirstChildOfClass(class_name)
                if item then
                    item:Destroy()
                end
            end

            local function get_player_gender()
                local success, result = pcall(function()
                    return rps.Requests.Get:InvokeServer(utf8.char(65532) .. "\240\159\152\131", "Gender")["Gender"]
                end)
                return success and result or "Male"
            end

            local function get_face_presets()
                local faces = {}
                local success, err = pcall(function()
                    local assets_faces = rps.Assets.Faces
                    for _, child in ipairs(assets_faces:GetChildren()) do
                        if child:IsA("Decal") then
                            faces[child.Name] = child.Texture
                        end
                    end
                    local rigan_folder = assets_faces:FindFirstChild("Rigan")
                    if rigan_folder then
                        for _, child in ipairs(rigan_folder:GetChildren()) do
                            if child:IsA("Decal") then
                                faces["Rigan" .. child.Name] = child.Texture
                            end
                        end
                    end
                end)
                return faces
            end

            local function get_outfit_presets()
                local outfits = {}
                local success = pcall(function()
                    local assets_outfits = rps.Assets.Outfits
                    for _, outfit_folder in ipairs(assets_outfits:GetChildren()) do
                        if outfit_folder:IsA("Folder") then
                            outfits[outfit_folder.Name] = outfit_folder
                        end
                    end
                end)
                return outfits
            end

            local function apply_outfit(character, outfit_folder)
                if not character or not character.Parent then return end
                if not outfit_folder then return end

                local gender = get_player_gender()
                local gender_folder = outfit_folder:FindFirstChild(gender)

                if not gender_folder then
                    gender_folder = outfit_folder:FindFirstChild("Male") or outfit_folder:FindFirstChild("Female")
                end

                if not gender_folder then return end

                local success,err = pcall(function()
                    local shirt = gender_folder:FindFirstChild("Shirt")
                    if shirt and shirt:IsA("Shirt") then
                        -- Store the outfit's shirt template and color to config
                        cheat_client.config.char_custom_shirt = shirt.ShirtTemplate
                        cheat_client.config.outfit_shirt_color = shirt.Color3

                        -- update input field to trigger save
                        if Options and Options.char_custom_shirt then
                            Options.char_custom_shirt:SetValue(shirt.ShirtTemplate)
                        end

                        clear_character_item(character, "Shirt")
                        local new_shirt = shirt:Clone()
                        new_shirt.Parent = character

                        char_custom_enabled.shirt = true
                    end

                    local pants = gender_folder:FindFirstChild("Pants")
                    if pants and pants:IsA("Pants") then
                        -- Store the outfit's pants template and color to config
                        cheat_client.config.char_custom_pants = pants.PantsTemplate
                        cheat_client.config.outfit_pants_color = pants.Color3

                        -- update input field to trigger save
                        if Options and Options.char_custom_pants then
                            Options.char_custom_pants:SetValue(pants.PantsTemplate)
                        end

                        clear_character_item(character, "Pants")
                        new_pants = pants:Clone()
                        new_pants.Parent = character

                        char_custom_enabled.pants = true
                    end

                    -- Disable clothing dye when outfit is loaded (don't apply custom dye)
                    char_custom_enabled.clothing_dye = false
                end)

                if not success then print("Error applying outfit: " .. tostring(err)) end
            end

            local function cache_original_state(character)
                if original_char_state.cached then return end
                if not character or not character.Parent then return end

                pcall(function()
                    local head = character:FindFirstChild("Head")
                    if head then
                        local face = head:FindFirstChildOfClass("Decal")
                        if face then
                            original_char_state.face = face.Texture
                        end

                        local rlface = head:FindFirstChild("RLFace")
                        if rlface and rlface:IsA("Decal") then
                            original_char_state.rlface_color = rlface.Color3
                        end
                    end

                    local shirt = character:FindFirstChildOfClass("Shirt")
                    if shirt then
                        original_char_state.shirt = shirt.ShirtTemplate
                        original_char_state.shirt_color = shirt.Color3
                    end

                    local pants = character:FindFirstChildOfClass("Pants")
                    if pants then
                        original_char_state.pants = pants.PantsTemplate
                        original_char_state.pants_color = pants.Color3
                    end

                    local head = character:FindFirstChild("Head")
                    if head then
                        original_char_state.skin_color = head.Color
                    end

                    original_char_state.cached = true
                end)
            end

            local function update_cached_state(character)
                if not character or not character.Parent then return end

                pcall(function()
                    local head = character:FindFirstChild("Head")
                    if head then
                        local face = head:FindFirstChildOfClass("Decal")
                        if face then
                            original_char_state.face = face.Texture
                        end

                        local rlface = head:FindFirstChild("RLFace")
                        if rlface and rlface:IsA("Decal") then
                            original_char_state.rlface_color = rlface.Color3
                        end
                    end

                    local shirt = character:FindFirstChildOfClass("Shirt")
                    if shirt then
                        original_char_state.shirt = shirt.ShirtTemplate
                        original_char_state.shirt_color = shirt.Color3
                    end

                    local pants = character:FindFirstChildOfClass("Pants")
                    if pants then
                        original_char_state.pants = pants.PantsTemplate
                        original_char_state.pants_color = pants.Color3
                    end

                    local head = character:FindFirstChild("Head")
                    if head then
                        original_char_state.skin_color = head.Color
                    end
                end)
            end

            local function restore_original_state(character)
                if not character or not character.Parent then return end
                if not original_char_state.cached then return end

                pcall(function()
                    if original_char_state.face then
                        local head = character:FindFirstChild("Head")
                        if head then
                            local rlface = head:FindFirstChild("RLFace")
                            if rlface and rlface:IsA("Decal") then
                                rlface.Texture = original_char_state.face
                                if original_char_state.rlface_color then
                                    rlface.Color3 = original_char_state.rlface_color
                                end
                            end
                        end
                    end

                    if original_char_state.shirt then
                        clear_character_item(character, "Shirt")
                        local shirt = Instance.new("Shirt")
                        shirt.ShirtTemplate = original_char_state.shirt
                        if original_char_state.shirt_color then
                            shirt.Color3 = original_char_state.shirt_color
                        end
                        shirt.Parent = character
                    end

                    if original_char_state.pants then
                        clear_character_item(character, "Pants")
                        local pants = Instance.new("Pants")
                        pants.PantsTemplate = original_char_state.pants
                        if original_char_state.pants_color then
                            pants.Color3 = original_char_state.pants_color
                        end
                        pants.Parent = character
                    end

                    if original_char_state.skin_color then
                        local body_colors = character:FindFirstChildOfClass("BodyColors")
                        if not body_colors then
                            body_colors = Instance.new("BodyColors")
                            body_colors.Parent = character
                        end
                        body_colors.HeadColor3 = original_char_state.skin_color
                        body_colors.TorsoColor3 = original_char_state.skin_color
                        body_colors.LeftArmColor3 = original_char_state.skin_color
                        body_colors.RightArmColor3 = original_char_state.skin_color
                        body_colors.LeftLegColor3 = original_char_state.skin_color
                        body_colors.RightLegColor3 = original_char_state.skin_color
                    end

                    -- RLFace restoration is now handled in the face section above to prevent duplication

                    for _, acc in ipairs(current_accessories) do
                        if acc and acc.Parent then
                            acc:Destroy()
                        end
                    end
                    current_accessories = {}
                end)
            end

            local function apply_face(character, face_id)
                if not character or not character.Parent then return end
                local head = character:FindFirstChild("Head")
                if not head then return end

                if face_id == "" then return end

                local success, err = pcall(function()
                    -- extract id from various formats
                    local extracted_id = face_id:match("asset/%?id=(%d+)") or
                                       face_id:match("rbxassetid://(%d+)") or
                                       face_id:match("^(%d+)$") or
                                       face_id

                    local texture = "rbxassetid://" .. extracted_id

                    local rlface = head:FindFirstChild("RLFace")
                    if rlface and rlface:IsA("Decal") then
                        rlface.Texture = texture
                    end
                end)

                if not success then
                    print("Failed to apply face: " .. tostring(err))
                end
            end

            local function apply_rlface_color(character, color)
                if not character or not character.Parent then return end
                local head = character:FindFirstChild("Head")
                if not head then return end

                local success, err = pcall(function()
                    local rlface = head:FindFirstChild("RLFace")
                    if rlface and rlface:IsA("Decal") then
                        rlface.Color3 = color
                    end
                end)

                if not success then
                    print("Failed to apply RLFace color: " .. tostring(err))
                end
            end

            local httpService = game:GetService("HttpService")
            local template_cache = {}

            local function get_template_id(asset_id)
                if template_cache[asset_id] then
                    return template_cache[asset_id].templateId
                end

                local success, result = pcall(function()
                    local response = request({
                        Url = "https://assetdelivery.roblox.com/v1/asset/?id=" .. asset_id,
                        Method = "GET",
                        Headers = ROBLOX_API_HEADERS
                    })

                    if not (response and response.Success and response.StatusCode == 200) then
                        return nil
                    end

                    local template_id = response.Body:match("id=(%d+)")

                    if template_id then
                        template_cache[asset_id] = {
                            assetId = tonumber(asset_id),
                            templateId = tonumber(template_id),
                            templateUrl = "rbxassetid://" .. template_id
                        }
                        return template_id
                    end

                    return nil
                end)

                if success and result then
                    return result
                end

                return nil
            end

            local function apply_shirt(character, shirt_id)
                if not character or not character.Parent then return end
                if shirt_id == "" then return end

                local success, err = pcall(function()
                    local extracted_id = shirt_id:match("rbxassetid://(%d+)") or shirt_id:match("^(%d+)$") or shirt_id

                    if #extracted_id > 20 then
                        warn("Shirt ID too long (max 20 digits): " .. extracted_id)
                        return
                    end
                    
                    local template_id = get_template_id(extracted_id)
                    local target_template = template_id and ("rbxassetid://" .. template_id) or ("rbxassetid://" .. extracted_id)

                    local old_shirt = character:FindFirstChildOfClass("Shirt")
                    if old_shirt then
                        old_shirt:Destroy()
                    end

                    local shirt = Instance.new("Shirt")
                    shirt.Parent = character
                    shirt.ShirtTemplate = target_template

                    task.wait(0.5)
                    if shirt.ShirtTemplate == target_template then
                        utility:Connection(shirt:GetPropertyChangedSignal("ShirtTemplate"), function()
                            if shirt.ShirtTemplate ~= target_template then
                                shirt.ShirtTemplate = target_template
                            end
                        end)
                    else
                        warn("Shirt ID failed to load (might be invalid): " .. extracted_id)
                        library:Notify("Shirt ID " .. extracted_id .. " failed to load", 3)
                    end
                end)

                if not success then
                    print("Failed to apply shirt: " .. tostring(err))
                end
            end

            local function apply_pants(character, pants_id)
                if not character or not character.Parent then return end
                if pants_id == "" then return end

                local success, err = pcall(function()
                    local extracted_id = pants_id:match("rbxassetid://(%d+)") or pants_id:match("^(%d+)$") or pants_id

                    if #extracted_id > 20 then
                        warn("Pants ID too long (max 20 digits): " .. extracted_id)
                        return
                    end

                    local template_id = get_template_id(extracted_id)
                    local target_template = template_id and ("rbxassetid://" .. template_id) or ("rbxassetid://" .. extracted_id)

                    local old_pants = character:FindFirstChildOfClass("Pants")
                    if old_pants then
                        old_pants:Destroy()
                    end

                    local pants = Instance.new("Pants")
                    pants.Parent = character
                    pants.PantsTemplate = target_template

                    task.wait(0.5)
                    if pants.PantsTemplate == target_template then
                        utility:Connection(pants:GetPropertyChangedSignal("PantsTemplate"), function()
                            if pants.PantsTemplate ~= target_template then
                                pants.PantsTemplate = target_template
                            end
                        end)
                    else
                        warn("Pants ID failed to load (might be invalid): " .. extracted_id)
                        library:Notify("Pants ID " .. extracted_id .. " failed to load", 3)
                    end
                end)

                if not success then
                    print("Failed to apply pants: " .. tostring(err))
                end
            end

            local function apply_skin_color(character, color)
                if not character or not character.Parent then return end

                local success, err = pcall(function()
                    local body_colors = character:FindFirstChildOfClass("BodyColors")
                    if not body_colors then
                        body_colors = Instance.new("BodyColors")
                        body_colors.Parent = character
                    end
                    body_colors.HeadColor3 = color
                    body_colors.TorsoColor3 = color
                    body_colors.LeftArmColor3 = color
                    body_colors.RightArmColor3 = color
                    body_colors.LeftLegColor3 = color
                    body_colors.RightLegColor3 = color
                end)

                if not success then
                    print("Failed to apply skin color: " .. tostring(err))
                end
            end

            local function apply_clothing_dye(character, color)
                if not character or not character.Parent then return end

                local success, err = pcall(function()
                    local shirt = character:FindFirstChildOfClass("Shirt")
                    if shirt then
                        shirt.Color3 = color
                    end

                    local pants = character:FindFirstChildOfClass("Pants")
                    if pants then
                        pants.Color3 = color
                    end
                end)

                if not success then
                    print("Failed to apply clothing dye: " .. tostring(err))
                end
            end

            local function apply_accessories(character, accessories_string)
                if not character or not character.Parent then return end
                if accessories_string == "" then return end

                for _, acc in ipairs(current_accessories) do
                    if acc and acc.Parent then
                        acc:Destroy()
                    end
                end
                current_accessories = {}

                local head = character:FindFirstChild("Head")
                if not head then return end

                for id in accessories_string:gmatch("[^,]+") do
                    id = id:match("^%s*(.-)%s*$")
                    local extracted_id = id:match("rbxassetid://(%d+)") or id:match("^(%d+)$") or id

                    local success, err = pcall(function()
                        local acc = game:GetObjects("rbxassetid://" .. extracted_id)[1]
                        if not acc then return end

                        acc.Name = "Asset:" .. extracted_id
                        acc.Parent = character

                        local handle = acc:WaitForChild("Handle", 5)
                        if not handle then return end

                        for _, obj in ipairs(handle:GetChildren()) do
                            if obj:IsA("Weld") or obj:IsA("WeldConstraint") or obj:IsA("Motor6D") then
                                obj:Destroy()
                            end
                        end

                        local accAtt = handle:FindFirstChildWhichIsA("Attachment")
                        if not accAtt then
                            warn("Accessory " .. extracted_id .. " has no attachment inside Handle")
                            return
                        end

                        local headAtt = head:FindFirstChild(accAtt.Name)
                        if not headAtt then
                            warn("Head has no matching attachment for " .. accAtt.Name)
                            return
                        end

                        local weld = Instance.new("Weld")
                        weld.Name = "AccessoryWeld"
                        weld.Part0 = handle
                        weld.Part1 = head
                        weld.C0 = accAtt.CFrame
                        weld.C1 = headAtt.CFrame
                        weld.Parent = handle

                        table.insert(current_accessories, acc)
                    end)

                    if not success then
                        warn("Failed to load accessory " .. extracted_id .. ": " .. tostring(err))
                    end
                end
            end

            local function is_color3_valid(color)
                if not color then return false end
                local default_white = Color3.fromRGB(255, 255, 255)
                return not (math.abs(color.R - default_white.R) < 0.001 and
                           math.abs(color.G - default_white.G) < 0.001 and
                           math.abs(color.B - default_white.B) < 0.001)
            end

            local function apply_all_customizations(character)
                repeat task.wait() until character:FindFirstChild("Humanoid")
                repeat task.wait() until character:FindFirstChild("Head")
                repeat task.wait() until character:FindFirstChild("Head"):FindFirstChild("RLFace")

                task.wait(0.5)
                if not character or not character.Parent then return end

                cache_original_state(character)

                for _, conn in ipairs(char_monitor_connections) do
                    if conn and conn.Disconnect then
                        pcall(function() conn:Disconnect() end)
                    end
                end
                char_monitor_connections = {}

                local config = cheat_client.config

                if char_custom_enabled.face and config.char_custom_face ~= "" then
                    apply_face(character, config.char_custom_face)
                end

                if char_custom_enabled.shirt and config.char_custom_shirt ~= "" then
                    apply_shirt(character, config.char_custom_shirt)
                    if config.outfit_shirt_color then
                        task.wait(0.1)
                        local shirt = character:FindFirstChildOfClass("Shirt")
                        if shirt then
                            shirt.Color3 = config.outfit_shirt_color
                        end
                    end
                end

                if char_custom_enabled.pants and config.char_custom_pants ~= "" then
                    apply_pants(character, config.char_custom_pants)
                    if config.outfit_pants_color then
                        task.wait(0.1)
                        local pants = character:FindFirstChildOfClass("Pants")
                        if pants then
                            pants.Color3 = config.outfit_pants_color
                        end
                    end
                end

                if char_custom_enabled.accessories and config.char_custom_accessories ~= "" then
                    apply_accessories(character, config.char_custom_accessories)
                end

                if char_custom_enabled.skin_color then
                    apply_skin_color(character, config.char_custom_skin_color)
                end

                if char_custom_enabled.rlface_color then
                    apply_rlface_color(character, config.char_custom_rlface_color)
                end

                if char_custom_enabled.clothing_dye then
                    apply_clothing_dye(character, config.char_custom_clothing_dye)
                end


                local reapply_debounce = false
                local function setup_monitoring()
                    local shirt_conn = utility:Connection(character.ChildAdded, function(child)
                        if reapply_debounce then return end
                        if child:IsA("Shirt") and config.char_custom_shirt ~= "" then
                            task.wait(0.1)
                            if child.ShirtTemplate ~= "rbxassetid://" .. config.char_custom_shirt then
                                reapply_debounce = true
                                apply_shirt(character, config.char_custom_shirt)
                                task.wait(0.5)
                                reapply_debounce = false
                            end
                        elseif child:IsA("Pants") and config.char_custom_pants ~= "" then
                            task.wait(0.1)
                            if child.PantsTemplate ~= "rbxassetid://" .. config.char_custom_pants then
                                reapply_debounce = true
                                apply_pants(character, config.char_custom_pants)
                                task.wait(0.5)
                                reapply_debounce = false
                            end
                        end
                    end)

                    local body_conn = utility:Connection(character.ChildAdded, function(child)
                        if reapply_debounce then return end
                        if child:IsA("BodyColors") and config.char_custom_skin_color then
                            task.wait(0.1)
                            if child.HeadColor3 ~= config.char_custom_skin_color then
                                reapply_debounce = true
                                apply_skin_color(character, config.char_custom_skin_color)
                                task.wait(0.5)
                                reapply_debounce = false
                            end
                        end
                    end)

                    local head = character:FindFirstChild("Head")
                    if head then
                        local face_conn = utility:Connection(head.ChildAdded, function(child)
                            if reapply_debounce then return end
                            if child:IsA("Decal") and config.char_custom_face ~= "" then
                                task.wait(0.1)
                                local expected_texture = config.char_custom_face:match("^rbxassetid://") and config.char_custom_face or ("rbxassetid://" .. config.char_custom_face)
                                if child.Texture ~= expected_texture then
                                    reapply_debounce = true
                                    apply_face(character, config.char_custom_face)
                                    task.wait(0.5)
                                    reapply_debounce = false
                                end
                            end
                        end)
                        table.insert(char_monitor_connections, face_conn)
                    end

                    table.insert(char_monitor_connections, shirt_conn)
                    table.insert(char_monitor_connections, body_conn)
                end

                setup_monitoring()
            end

            local function clear_all_customizations(character)
                if not character or not character.Parent then return end

                for _, conn in ipairs(char_monitor_connections) do
                    if conn and conn.Disconnect then
                        pcall(function() conn:Disconnect() end)
                    end
                end
                char_monitor_connections = {}

                restore_original_state(character)
            end

            local function setup_char_customization()
                if char_custom_connection then
                    char_custom_connection:Disconnect()
                    char_custom_connection = nil
                end

                char_custom_connection = utility:Connection(plr.CharacterAdded, function(character)
                    apply_all_customizations(character)
                end)

                if plr.Character then
                    apply_all_customizations(plr.Character)
                end
            end

            cheat_client.char_custom_restore = restore_original_state
            cheat_client.char_custom_setup = setup_char_customization
            cheat_client.char_custom_enabled = char_custom_enabled

            group_spoofing:AddToggle("streamer_mode", {
                Text = "Streamer Mode",
                Default = cheat_client.config.streamer_mode,
                Callback = function(state)
                    if cheat_client and cheat_client.config then
                        cheat_client.config.streamer_mode = state
                    end
                    if state then
                        if not original_names[plr] then
                            original_names[plr] = cheat_client:get_name(plr)
                        end
                        -- apply_streamer handles both custom name and Ragoozer logic
                        cheat_client:apply_streamer(state)
                    else
                        cheat_client:apply_streamer(state)
                    end
                end
            })

            group_spoofing:AddInput("custom_name_spoof", {
                Default = cheat_client.config.custom_name_spoof,
                Numeric = false,
                Finished = true,
                Text = "Custom Name",
                Tooltip = "Requires Streamer Mode enabled. Leave empty for default (Fear + random last name)",
                Placeholder = "Leave empty for default",
                Callback = function(value)
                    cheat_client.config.custom_name_spoof = value

                    if not Toggles.streamer_mode or not Toggles.streamer_mode.Value then
                        library:Notify("Enable Streamer Mode first!")
                        return
                    end

                    if not original_names[plr] then
                        original_names[plr] = cheat_client:get_name(plr)
                    end

                    if value and value ~= "" then
                        cheat_client:spoof_name(value)
                    else
                        if cheat_client.last_names and #cheat_client.last_names > 0 then
                            local random_lastname = cheat_client.last_names[math.random(1, #cheat_client.last_names)]
                            cheat_client:spoof_name("Fear " .. random_lastname)
                        end
                    end
                end
            })

            group_spoofing:AddSlider("custom_day_spoof", {
                Text = "Custom Days",
                Default = cheat_client.config.custom_day_spoof,
                Min = 1,
                Max = 999,
                Rounding = 0,
                Compact = false,
                Callback = function(value)
                    cheat_client.config.custom_day_spoof = value
                    if cheat_client.config.spoof_days_enabled then
                        cheat_client:spoof_days(value)
                    end
                end
            })

            group_spoofing:AddToggle("spoof_days_enabled", {
                Text = "Enable Day Spoof",
                Default = cheat_client.config.spoof_days_enabled,
                Callback = function(state)
                    cheat_client.config.spoof_days_enabled = state
                    if state then
                        cheat_client:spoof_days(cheat_client.config.custom_day_spoof)
                    else
                        if original_days.hundred then
                            local stat_gui = plr.PlayerGui:FindFirstChild("StatGui")
                            if stat_gui then
                                local lives = stat_gui.Container.Health:FindFirstChild("Lives")
                                if lives then
                                    -- Get all Roller objects
                                    local rollers = {}
                                    for _, child in ipairs(lives:GetChildren()) do
                                        if child.Name == "Roller" and child:FindFirstChild("Char") then
                                            table.insert(rollers, child)
                                        end
                                    end

                                    if #rollers >= 4 then
                                        local has_thousand = #rollers >= 6

                                        local thousand, hundred, ten, one
                                        if has_thousand then
                                            thousand = rollers[2]
                                            hundred = rollers[3]
                                            ten = rollers[4]
                                            one = rollers[5]
                                        else
                                            hundred = rollers[2]
                                            ten = rollers[3]
                                            one = rollers[4]
                                        end

                                        if thousand and original_days.thousand and original_days.thousand.text then
                                            thousand.Char.Text = original_days.thousand.text
                                        end
                                        if hundred and original_days.hundred.text then
                                            hundred.Char.Text = original_days.hundred.text
                                        end
                                        if ten and original_days.ten.text then
                                            ten.Char.Text = original_days.ten.text
                                        end
                                        if one and original_days.one.text then
                                            one.Char.Text = original_days.one.text
                                        end

                                        if original_days.thousand and original_days.thousand.connection then
                                            original_days.thousand.connection:Disconnect()
                                            original_days.thousand.connection = nil
                                        end
                                        if original_days.hundred.connection then
                                            original_days.hundred.connection:Disconnect()
                                            original_days.hundred.connection = nil
                                        end
                                        if original_days.ten.connection then
                                            original_days.ten.connection:Disconnect()
                                            original_days.ten.connection = nil
                                        end
                                        if original_days.one.connection then
                                            original_days.one.connection:Disconnect()
                                            original_days.one.connection = nil
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            })

            group_spoofing:AddDivider()
            group_spoofing:AddLabel("Character Customization")

            group_spoofing:AddToggle("char_customization_master", {
                Text = "Enable Character Customization",
                Default = cheat_client.config.char_custom_enabled,
                Callback = function(value)
                    cheat_client.config.char_custom_enabled = value

                    if value then
                        if plr.Character then
                            cache_original_state(plr.Character)
                        end
                        setup_char_customization()
                        library:Notify("Character customization enabled")
                    else
                        for type_name, _ in pairs(char_custom_enabled) do
                            char_custom_enabled[type_name] = false
                        end

                        if char_custom_connection then
                            char_custom_connection:Disconnect()
                            char_custom_connection = nil
                        end

                        for _, conn in ipairs(char_monitor_connections) do
                            if conn and conn.Disconnect then
                                pcall(function() conn:Disconnect() end)
                            end
                        end
                        char_monitor_connections = {}

                        if plr.Character then
                            restore_original_state(plr.Character)
                        end

                        library:Notify("Character customization disabled & restored")
                    end
                end,
                Tooltip = "Master toggle for all character customizations"
            })

            if cheat_client.config.char_custom_enabled then
                task.defer(function()
                    if plr.Character then
                        cache_original_state(plr.Character)
                    end
                    setup_char_customization()
                end)
            end

            local face_presets = get_face_presets()
            local face_preset_names = {}
            for name, _ in pairs(face_presets) do
                table.insert(face_preset_names, name)
            end
            table.sort(face_preset_names)

            group_spoofing:AddDropdown("face_preset_dropdown", {
                Values = face_preset_names,
                Default = 1,
                Multi = false,
                Text = "Face Preset",
                Tooltip = "Select a face from game assets",
                Callback = function(value)
                    local texture = face_presets[value]
                    if texture then
                        cheat_client.config.char_custom_face = texture
                        if Options and Options.char_custom_face then
                            Options.char_custom_face:SetValue(texture)
                        end
                    end
                end
            })

            group_spoofing:AddInput("char_custom_face", {
                Default = cheat_client.config.char_custom_face,
                Numeric = false,
                Finished = false,
                Text = "Face ID",
                Tooltip = "Custom Face ID (overrides preset)",
                Placeholder = "Enter Face ID",
                Callback = function(value)
                    cheat_client.config.char_custom_face = value
                end
            })

            group_spoofing:AddButton({
                Text = "Apply Face",
                Func = function()
                    if not (Toggles and Toggles.char_customization_master and Toggles.char_customization_master.Value) then
                        library:Notify("Enable Character Customization master toggle first!")
                        return
                    end

                    local face = cheat_client.config.char_custom_face
                    if face == "" and Options and Options.char_custom_face then
                        face = Options.char_custom_face.Value or ""
                    end
                    cheat_client.config.char_custom_face = face
                    char_custom_enabled.face = true

                    if not char_custom_connection then
                        setup_char_customization()
                    end

                    if plr.Character then
                        apply_face(plr.Character, face)
                        library:Notify("Face enabled & applied")
                    else
                        library:Notify("Face enabled")
                    end
                end
            })

            group_spoofing:AddButton({
                Text = "Clear Face",
                Func = function()
                    cheat_client.config.char_custom_face = ""
                    char_custom_enabled.face = false

                    if plr.Character and original_char_state.face then
                        local head = plr.Character:FindFirstChild("Head")
                        if head then
                            local rlface = head:FindFirstChild("RLFace")
                            if rlface and rlface:IsA("Decal") then
                                rlface.Texture = original_char_state.face
                            end
                        end
                        library:Notify("Face disabled & cleared")
                    else
                        library:Notify("Face disabled")
                    end
                end
            })

            local outfit_presets = get_outfit_presets()
            local outfit_preset_names = {}
            for name, _ in pairs(outfit_presets) do
                table.insert(outfit_preset_names, name)
            end
            table.sort(outfit_preset_names)

            group_spoofing:AddDropdown("outfit_preset_dropdown", {
                Values = outfit_preset_names,
                Default = 1,
                Multi = false,
                Text = "Outfit Preset",
                Tooltip = "Select an outfit from game assets (auto-detects gender)",
                Callback = function(value)
                end
            })

            group_spoofing:AddButton({
                Text = "Apply Outfit",
                Func = function()
                    if not (Toggles and Toggles.char_customization_master and Toggles.char_customization_master.Value) then
                        library:Notify("Enable Character Customization master toggle first!")
                        return
                    end

                    local selected = Options and Options.outfit_preset_dropdown and Options.outfit_preset_dropdown.Value
                    if not selected then
                        library:Notify("Select an outfit first")
                        return
                    end

                    local outfit_folder = outfit_presets[selected]
                    if not outfit_folder then
                        library:Notify("Outfit not found")
                        return
                    end

                    char_custom_enabled.shirt = true
                    char_custom_enabled.pants = true

                    if not char_custom_connection then
                        setup_char_customization()
                    end

                    if plr.Character then
                        apply_outfit(plr.Character, outfit_folder)
                        library:Notify(string.format("Outfit '%s' applied (%s)", selected, get_player_gender()))
                    else
                        library:Notify("No character found")
                    end
                end,
                Tooltip = "Applies both shirt and pants from the selected outfit"
            })

            group_spoofing:AddInput("char_custom_shirt", {
                Default = cheat_client.config.char_custom_shirt,
                Numeric = false,
                Finished = false,
                Text = "Shirt ID",
                Tooltip = "Enter Shirt Template ID",
                Placeholder = "Enter Shirt ID",
                Callback = function(value)
                    cheat_client.config.char_custom_shirt = value
                end
            })

            group_spoofing:AddButton({
                Text = "Apply Shirt",
                Func = function()
                    if not (Toggles and Toggles.char_customization_master and Toggles.char_customization_master.Value) then
                        library:Notify("Enable Character Customization master toggle first!")
                        return
                    end

                    local value = (Options and Options.char_custom_shirt and Options.char_custom_shirt.Value) or cheat_client.config.char_custom_shirt
                    cheat_client.config.char_custom_shirt = value
                    char_custom_enabled.shirt = true

                    if not char_custom_connection then
                        setup_char_customization()
                    end

                    if plr.Character then
                        apply_shirt(plr.Character, value)
                        library:Notify("Shirt enabled & applied")
                    else
                        library:Notify("Shirt enabled")
                    end
                end
            })

            group_spoofing:AddButton({
                Text = "Clear Shirt",
                Func = function()
                    cheat_client.config.char_custom_shirt = ""
                    char_custom_enabled.shirt = false

                    if plr.Character and original_char_state.shirt then
                        clear_character_item(plr.Character, "Shirt")
                        local shirt = Instance.new("Shirt")
                        shirt.ShirtTemplate = original_char_state.shirt
                        shirt.Parent = plr.Character
                        library:Notify("Shirt disabled & cleared")
                    else
                        if plr.Character then
                            clear_character_item(plr.Character, "Shirt")
                        end
                        library:Notify("Shirt disabled")
                    end
                end
            })

            group_spoofing:AddInput("char_custom_pants", {
                Default = cheat_client.config.char_custom_pants,
                Numeric = false,
                Finished = false,
                Text = "Pants ID",
                Tooltip = "Enter Pants Template ID",
                Placeholder = "Enter Pants ID",
                Callback = function(value)
                    cheat_client.config.char_custom_pants = value
                end
            })

            group_spoofing:AddButton({
                Text = "Apply Pants",
                Func = function()
                    if not (Toggles and Toggles.char_customization_master and Toggles.char_customization_master.Value) then
                        library:Notify("Enable Character Customization master toggle first!")
                        return
                    end

                    local value = (Options and Options.char_custom_pants and Options.char_custom_pants.Value) or cheat_client.config.char_custom_pants
                    cheat_client.config.char_custom_pants = value
                    char_custom_enabled.pants = true

                    if not char_custom_connection then
                        setup_char_customization()
                    end

                    if plr.Character then
                        apply_pants(plr.Character, value)
                        library:Notify("Pants enabled & applied")
                    else
                        library:Notify("Pants enabled")
                    end
                end
            })

            group_spoofing:AddButton({
                Text = "Clear Pants",
                Func = function()
                    cheat_client.config.char_custom_pants = ""
                    char_custom_enabled.pants = false

                    if plr.Character and original_char_state.pants then
                        clear_character_item(plr.Character, "Pants")
                        local pants = Instance.new("Pants")
                        pants.PantsTemplate = original_char_state.pants
                        pants.Parent = plr.Character
                        library:Notify("Pants disabled & cleared")
                    else
                        if plr.Character then
                            clear_character_item(plr.Character, "Pants")
                        end
                        library:Notify("Pants disabled")
                    end
                end
            })

            group_spoofing:AddInput("char_custom_accessories", {
                Default = cheat_client.config.char_custom_accessories,
                Numeric = false,
                Finished = false,
                Text = "Accessories",
                Tooltip = "Enter comma-separated accessory IDs",
                Placeholder = "e.g. 123456,789012",
                Callback = function(value)
                    cheat_client.config.char_custom_accessories = value
                end
            })

            group_spoofing:AddButton({
                Text = "Apply Accessories",
                Func = function()
                    if not (Toggles and Toggles.char_customization_master and Toggles.char_customization_master.Value) then
                        library:Notify("Enable Character Customization master toggle first!")
                        return
                    end

                    local value = (Options and Options.char_custom_accessories and Options.char_custom_accessories.Value) or cheat_client.config.char_custom_accessories
                    cheat_client.config.char_custom_accessories = value
                    char_custom_enabled.accessories = true

                    if not char_custom_connection then
                        setup_char_customization()
                    end

                    if plr.Character then
                        apply_accessories(plr.Character, value)
                        library:Notify("Accessories enabled & applied")
                    else
                        library:Notify("Accessories enabled")
                    end
                end
            })

            group_spoofing:AddButton({
                Text = "Clear Accessories",
                Func = function()
                    cheat_client.config.char_custom_accessories = ""
                    char_custom_enabled.accessories = false

                    if plr.Character then
                        -- Clear custom accessories from current_accessories table
                        for _, acc in ipairs(current_accessories) do
                            if acc and acc.Parent then
                                acc:Destroy()
                            end
                        end
                        current_accessories = {}

                        -- Also destroy ALL accessories in the character (including base ones)
                        for _, child in ipairs(plr.Character:GetChildren()) do
                            if child:IsA("Accessory") then
                                child:Destroy()
                            end
                        end

                        library:Notify("All accessories destroyed & cleared")
                    else
                        library:Notify("Accessories disabled")
                    end
                end
            })

            group_spoofing:AddLabel("Skin Color"):AddColorPicker("char_custom_skin_color", {
                Default = cheat_client.config.char_custom_skin_color,
                Title = "Skin Color",
                Transparency = 0,
                Callback = function(value)
                    cheat_client.config.char_custom_skin_color = value
                end
            })

            group_spoofing:AddButton({
                Text = "Apply Skin Color",
                Func = function()
                    if not (Toggles and Toggles.char_customization_master and Toggles.char_customization_master.Value) then
                        library:Notify("Enable Character Customization master toggle first!")
                        return
                    end

                    local value = (Options and Options.char_custom_skin_color and Options.char_custom_skin_color.Value) or cheat_client.config.char_custom_skin_color
                    cheat_client.config.char_custom_skin_color = value
                    char_custom_enabled.skin_color = true

                    if not char_custom_connection then
                        setup_char_customization()
                    end

                    if plr.Character then
                        apply_skin_color(plr.Character, value)
                        library:Notify("Skin color enabled & applied")
                    else
                        library:Notify("Skin color enabled")
                    end
                end
            })

            group_spoofing:AddButton({
                Text = "Clear Skin Color",
                Func = function()
                    cheat_client.config.char_custom_skin_color = Color3.fromRGB(255, 253, 247)
                    char_custom_enabled.skin_color = false

                    if plr.Character and original_char_state.skin_color then
                        local body_colors = plr.Character:FindFirstChildOfClass("BodyColors")
                        if not body_colors then
                            body_colors = Instance.new("BodyColors")
                            body_colors.Parent = plr.Character
                        end
                        body_colors.HeadColor3 = original_char_state.skin_color
                        body_colors.TorsoColor3 = original_char_state.skin_color
                        body_colors.LeftArmColor3 = original_char_state.skin_color
                        body_colors.RightArmColor3 = original_char_state.skin_color
                        body_colors.LeftLegColor3 = original_char_state.skin_color
                        body_colors.RightLegColor3 = original_char_state.skin_color
                        library:Notify("Skin color disabled & cleared")
                    else
                        library:Notify("Skin color disabled")
                    end
                end
            })

            group_spoofing:AddLabel("Clothing Dye"):AddColorPicker("char_custom_clothing_dye", {
                Default = cheat_client.config.char_custom_clothing_dye or Color3.fromRGB(255, 253, 247),
                Title = "Clothing Dye",
                Transparency = 0,
                Callback = function(value)
                    cheat_client.config.char_custom_clothing_dye = value
                end
            })

            group_spoofing:AddButton({
                Text = "Apply Clothing Dye",
                Func = function()
                    if not (Toggles and Toggles.char_customization_master and Toggles.char_customization_master.Value) then
                        library:Notify("Enable Character Customization master toggle first!")
                        return
                    end

                    local value = (Options and Options.char_custom_clothing_dye and Options.char_custom_clothing_dye.Value) or cheat_client.config.char_custom_clothing_dye
                    cheat_client.config.char_custom_clothing_dye = value
                    char_custom_enabled.clothing_dye = true

                    if not char_custom_connection then
                        setup_char_customization()
                    end

                    if plr.Character then
                        apply_clothing_dye(plr.Character, value)
                        library:Notify("Clothing dye enabled & applied")
                    else
                        library:Notify("Clothing dye enabled")
                    end
                end
            })

            group_spoofing:AddButton({
                Text = "Clear Clothing Dye",
                Func = function()
                    cheat_client.config.char_custom_clothing_dye = Color3.fromRGB(255, 253, 247)
                    char_custom_enabled.clothing_dye = false

                    if plr.Character and (original_char_state.shirt_color or original_char_state.pants_color) then
                        local shirt = plr.Character:FindFirstChildOfClass("Shirt")
                        if shirt and original_char_state.shirt_color then
                            shirt.Color3 = original_char_state.shirt_color
                        end

                        local pants = plr.Character:FindFirstChildOfClass("Pants")
                        if pants and original_char_state.pants_color then
                            pants.Color3 = original_char_state.pants_color
                        end
                        library:Notify("Clothing dye disabled & cleared")
                    else
                        library:Notify("Clothing dye disabled")
                    end
                end
            })

            group_spoofing:AddLabel("RLFace Color"):AddColorPicker("char_custom_rlface_color", {
                Default = cheat_client.config.char_custom_rlface_color,
                Title = "RLFace Color",
                Transparency = 0,
                Callback = function(value)
                    cheat_client.config.char_custom_rlface_color = value
                end
            })

            group_spoofing:AddButton({
                Text = "Apply RLFace Color",
                Func = function()
                    if not (Toggles and Toggles.char_customization_master and Toggles.char_customization_master.Value) then
                        library:Notify("Enable Character Customization master toggle first!")
                        return
                    end

                    local value = (Options and Options.char_custom_rlface_color and Options.char_custom_rlface_color.Value) or cheat_client.config.char_custom_rlface_color
                    cheat_client.config.char_custom_rlface_color = value
                    char_custom_enabled.rlface_color = true

                    if not char_custom_connection then
                        setup_char_customization()
                    end

                    if plr.Character then
                        apply_rlface_color(plr.Character, value)
                        library:Notify("RLFace color enabled & applied")
                    else
                        library:Notify("RLFace color enabled")
                    end
                end
            })

            group_spoofing:AddButton({
                Text = "Clear RLFace Color",
                Func = function()
                    cheat_client.config.char_custom_rlface_color = Color3.fromRGB(255, 253, 247)
                    char_custom_enabled.rlface_color = false

                    if plr.Character and original_char_state.rlface_color then
                        local head = plr.Character:FindFirstChild("Head")
                        if head then
                            local rlface = head:FindFirstChild("RLFace")
                            if rlface and rlface:IsA("Decal") then
                                rlface.Color3 = original_char_state.rlface_color
                            end
                        end
                        library:Notify("RLFace color disabled & cleared")
                    else
                        library:Notify("RLFace color disabled")
                    end
                end
            })

            group_spoofing:AddDivider()

            group_spoofing:AddButton({
                Text = "Clear All & Disable",
                Func = function()
                    cheat_client.config.char_custom_face = ""
                    cheat_client.config.char_custom_shirt = ""
                    cheat_client.config.char_custom_pants = ""
                    cheat_client.config.char_custom_accessories = ""
                    cheat_client.config.char_custom_skin_color = Color3.fromRGB(255, 253, 247)
                    cheat_client.config.char_custom_rlface_color = Color3.fromRGB(255, 253, 247)
                    cheat_client.config.char_custom_clothing_dye = Color3.fromRGB(255, 253, 247)

                    char_custom_enabled.face = false
                    char_custom_enabled.shirt = false
                    char_custom_enabled.pants = false
                    char_custom_enabled.accessories = false
                    char_custom_enabled.skin_color = false
                    char_custom_enabled.rlface_color = false
                    char_custom_enabled.clothing_dye = false

                    if char_custom_connection then
                        char_custom_connection:Disconnect()
                        char_custom_connection = nil
                    end

                    if plr.Character then
                        clear_all_customizations(plr.Character)
                    end

                    library:Notify("Character customization disabled and cleared")
                end,
                Tooltip = "Clear all customizations and disable auto-apply"
            })
        end

        do -- Private Server (PS)
            local group_ps = Tabs.Misc:AddRightGroupbox("PS Servers")

            local ps_file = "HYDROXIDE/private_servers.json"
            local http_service = game:GetService("HttpService")

            -- load private servers from json
            local function load_servers()
                if not isfile(ps_file) then
                    return {"1967beef", "ffdc35ae", "555985b2"}
                end
                local success, result = pcall(function()
                    return http_service:JSONDecode(readfile(ps_file))
                end)
                if success and type(result) == "table" then
                    return result
                end
                return {"1967beef", "ffdc35ae", "555985b2"}
            end

            -- save private servers to json
            local function save_servers(servers)
                local success = pcall(function()
                    writefile(ps_file, http_service:JSONEncode(servers))
                end)
                return success
            end

            local server_ids = load_servers()

            local function join_server(server_id)
                if cs:HasTag(plr.Character, "Danger") and not (Toggles and Toggles.ignore_danger and Toggles.ignore_danger.Value) then
                    repeat
                        rs.Heartbeat:Wait()
                    until not cs:HasTag(plr.Character, "Danger") or (Toggles and Toggles.ignore_danger and Toggles.ignore_danger.Value)
                end
                rps.Requests.JoinPrivateServer:FireServer(server_id)
            end

            local function refresh_dropdown()
                server_ids = load_servers()
                if Options.PrivateServerDropdown then
                    Options.PrivateServerDropdown:SetValues(server_ids)
                    if #server_ids > 0 then
                        Options.PrivateServerDropdown:SetValue(server_ids[1])
                    end
                end
            end

            group_ps:AddDropdown("PrivateServerDropdown", {
                Text = "Saved Servers",
                Values = server_ids,
                Default = #server_ids > 0 and server_ids[1] or nil,
                Multi = false,
                Callback = function(value) end
            })

            group_ps:AddButton({
                Text = "Join Selected Server",
                DoubleClick = true,
                Func = function()
                    local server_id = Options.PrivateServerDropdown.Value
                    if server_id and server_id ~= "" then
                        join_server(server_id)
                        library:Notify("Joining private server: " .. server_id, 3)
                    else
                        library:Notify("Please select a server", 3)
                    end
                end
            })

            group_ps:AddDivider()

            group_ps:AddInput("CustomPrivateServer", {
                Text = "Server Code",
                Placeholder = "Enter server code...",
                ClearTextOnFocus = false,
            })

            group_ps:AddButton({
                Text = "Join Server Code",
                DoubleClick = true,
                Func = function()
                    local server_id = Options.CustomPrivateServer.Value
                    if server_id and server_id ~= "" then
                        join_server(server_id)
                        library:Notify("Joining private server: " .. server_id, 3)
                    else
                        library:Notify("Please enter a valid server ID", 3)
                    end
                end
            })

            group_ps:AddButton({
                Text = "Add to Saved Servers",
                Func = function()
                    local server_id = Options.CustomPrivateServer.Value
                    if server_id and server_id ~= "" then
                        for _, id in ipairs(server_ids) do
                            if id == server_id then
                                library:Notify("Server already in list", 3)
                                return
                            end
                        end
                        table.insert(server_ids, server_id)
                        save_servers(server_ids)
                        refresh_dropdown()
                        library:Notify("Added server: " .. server_id, 3)
                    else
                        library:Notify("Please enter a server ID", 3)
                    end
                end
            })

            group_ps:AddButton({
                Text = "Delete Selected Server",
                Func = function()
                    local server_id = Options.PrivateServerDropdown.Value
                    if server_id and server_id ~= "" then
                        for i, id in ipairs(server_ids) do
                            if id == server_id then
                                table.remove(server_ids, i)
                                save_servers(server_ids)
                                refresh_dropdown()
                                library:Notify("Deleted server: " .. server_id, 3)
                                return
                            end
                        end
                        library:Notify("Server not found in list", 3)
                    else
                        library:Notify("Please select a server", 3)
                    end
                end
            })
        end

        do -- Botting
            -- Trinket Bot State
            local trinket_bot = {
                path_points = {},  -- {position = Vector3, wait_for_trinket = bool}
                point_visualizations = {},  -- Parts for visualizing points
                visualize_enabled = false,
                path_running = false,
                current_path_name = "",
                session_loot = {},  -- Track items picked up this session
                session_start_time = 0
            }

            local visited_positions = {}
            local collected_trinket_ids = {}

            -- Kick on trinket state
            local kick_debounce = false
            local kick_after_path = false
            local kick_trinket_name = ""

            -- Proximity warnings table (module level to prevent memory leak in stay-in-server mode)
            local proximity_warnings = {}

            local function already_visited_position(pos)
                for _, visited_pos in ipairs(visited_positions) do
                    if (pos - visited_pos).Magnitude < 5 then  -- 5 stud tolerance
                        return true
                    end
                end
                return false
            end

            local function restore_bot_state()
                if plr and plr.Character then
                    local character = plr.Character
                    local huma = character:FindFirstChildOfClass("Humanoid")

                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            if part.Name == "Head" or part.Name == "Torso" then
                                part.CanCollide = true
                            else
                                part.CanCollide = false
                            end
                        end
                    end

                    if huma then
                        huma:SetStateEnabled(5, true)
                        huma:ChangeState(5)
                    end

                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.Anchored = false
                    end
                end
            end

            local function create_point_visualization(position, is_wait_point)
                local sphere = Instance.new("Part")
                sphere.Shape = Enum.PartType.Ball
                sphere.Size = Vector3.new(2, 2, 2)
                sphere.Position = position
                sphere.Anchored = true
                sphere.CanCollide = false
                sphere.Material = Enum.Material.Neon
                sphere.Color = is_wait_point and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(255, 255, 255)
                sphere.Transparency = 0.3
                sphere.Name = "2holla"
                sphere.Parent = workspace.Thrown
                return sphere
            end

            local function update_visualizations()
                for _, part in ipairs(trinket_bot.point_visualizations) do
                    if part and part.Parent then
                        part:Destroy()
                    end
                end
                trinket_bot.point_visualizations = {}

                if trinket_bot.visualize_enabled then
                    local previous_sphere = nil

                    for i, point in ipairs(trinket_bot.path_points) do
                        local sphere = create_point_visualization(point.position, point.wait_for_trinket)
                        table.insert(trinket_bot.point_visualizations, sphere)

                        local billboard = Instance.new("BillboardGui")
                        billboard.Size = UDim2.new(0, 50, 0, 50)
                        billboard.AlwaysOnTop = true
                        billboard.Adornee = sphere
                        billboard.Parent = hidden_folder
                        table.insert(trinket_bot.point_visualizations, billboard)

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = tostring(i)
                        label.TextColor3 = point.wait_for_trinket and Color3.fromRGB(100, 150, 255) or Color3.new(1, 1, 1)
                        label.TextScaled = true
                        label.Font = Enum.Font.SourceSansBold
                        label.Parent = billboard

                        if previous_sphere then
                            local attachment0 = Instance.new("Attachment")
                            attachment0.Parent = previous_sphere

                            local attachment1 = Instance.new("Attachment")
                            attachment1.Parent = sphere

                            local beam = Instance.new("Beam")
                            beam.Attachment0 = attachment0
                            beam.Attachment1 = attachment1
                            beam.FaceCamera = true
                            beam.Width0 = 0.3
                            beam.Width1 = 0.3
                            beam.Color = ColorSequence.new(Color3.new(1, 1, 1))
                            beam.Transparency = NumberSequence.new(0.3)
                            beam.Parent = sphere

                            table.insert(trinket_bot.point_visualizations, beam)
                        end

                        previous_sphere = sphere
                    end
                end
            end

            local loot_tracking_connection = nil
            local quantity_connections = {}
            local initial_quantities = {}

            local function log_pickup(item_name, quantity)
                quantity = quantity or 1
                if trinket_bot.session_loot[item_name] then
                    trinket_bot.session_loot[item_name] = trinket_bot.session_loot[item_name] + quantity
                else
                    trinket_bot.session_loot[item_name] = quantity
                end
            end

            local function start_loot_tracking()
                trinket_bot.session_loot = {}
                trinket_bot.session_start_time = os.clock()
                initial_quantities = {}

                if loot_tracking_connection then
                    loot_tracking_connection:Disconnect()
                end
                for _, conn in ipairs(quantity_connections) do
                    conn:Disconnect()
                end
                quantity_connections = {}

                -- Track items already in backpack and record their initial quantities
                if plr.Backpack then
                    for _, item in pairs(plr.Backpack:GetDescendants()) do
                        if item:IsA("IntValue") and item.Name == "Quantity" and item.Parent:IsA("Tool") then
                            local tool_name = item.Parent.Name
                            initial_quantities[tool_name] = item.Value

                            local conn = utility:Connection(item:GetPropertyChangedSignal("Value"), function()
                                if not (mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true") then
                                    return
                                end
                                local baseline = initial_quantities[tool_name] or 0
                                local current_session = trinket_bot.session_loot[tool_name] or 0
                                local new_amount = item.Value - baseline - current_session
                                if new_amount > 0 then
                                    log_pickup(tool_name, new_amount)
                                end
                            end)
                            table.insert(quantity_connections, conn)
                        end
                    end
                end

                if not plr.Backpack then
                    warn("[Loot Tracking] Backpack not found, skipping ChildAdded connection")
                    return
                end

                loot_tracking_connection = utility:Connection(plr.Backpack.ChildAdded, function(child)
                    if not (mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true") then
                        return
                    end

                    if not child:IsA("Tool") then return end

                    task.wait(0.5)
                    if child:FindFirstChild("SilverValue") then
                        local tool_name = child.Name

                        -- If this is a new item type, set baseline to 0 (we're logging the first one now)
                        if not initial_quantities[tool_name] then
                            initial_quantities[tool_name] = 0
                        end

                        log_pickup(tool_name)
                        task.wait(1)

                        local quantity_value = child:FindFirstChild("Quantity")
                        if quantity_value and quantity_value:IsA("IntValue") then
                            local conn = utility:Connection(quantity_value:GetPropertyChangedSignal("Value"), function()
                                if not (mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true") then
                                    return
                                end
                                local baseline = initial_quantities[tool_name] or 0
                                local current_session = trinket_bot.session_loot[tool_name] or 0
                                local new_amount = quantity_value.Value - baseline - current_session
                                if new_amount > 0 then
                                    log_pickup(tool_name, new_amount)
                                end
                            end)
                            table.insert(quantity_connections, conn)
                        end
                    end
                end)
            end

            local function format_loot_summary()
                local elapsed_time = os.clock() - trinket_bot.session_start_time
                local minutes = math.floor(elapsed_time / 60)
                local seconds = math.floor(elapsed_time % 60)

                local summary = string.format("**Session: %dm %ds**\n", minutes, seconds)

                if not trinket_bot.session_loot or not next(trinket_bot.session_loot) then
                    summary = summary .. "No items collected"
                    return summary
                end

                local items = {}
                for item_name, count in pairs(trinket_bot.session_loot) do
                    table.insert(items, {name = item_name, count = count})
                end

                table.sort(items, function(a, b)
                    return a.count > b.count
                end)

                for _, item in ipairs(items) do
                    summary = summary .. string.format("%dx %s\n", item.count, item.name)
                end

                return summary
            end

            local function SmoothTeleport(target)
                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                    return
                end

                if shared.is_unloading then
                    return
                end

                local root = plr.Character.HumanoidRootPart
                local targetPosition

                if typeof(target) == "CFrame" then
                    targetPosition = target.Position
                elseif typeof(target) == "Vector3" then
                    targetPosition = target
                elseif typeof(target) == "Instance" and target:IsA("BasePart") then
                    targetPosition = target.Position
                else
                    warn("Invalid target for SmoothTeleport:", target)
                    return
                end

                local character = plr.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:SetStateEnabled(5, false)
                        humanoid:ChangeState(3)
                    end
                end

                local connection
                connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                    if shared.is_unloading then
                        if connection then
                            connection:Disconnect()
                        end
                        return
                    end

                    if plr.Character then
                        for _, v in pairs(plr.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.Velocity = Vector3.new()
                                v.CanCollide = false
                            end
                        end
                    end
                end))

                local distance = (root.Position - targetPosition).Magnitude
                local speed = Options.TrinketBotSpeed and Options.TrinketBotSpeed.Value or 100
                local time = distance / speed

                local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                local tween = ts:Create(root, tweenInfo, {CFrame = CFrame.new(targetPosition)})

                tween:Play()

                local completed = false
                local unload_connection
                unload_connection = utility:Connection(tween.Completed, function()
                    completed = true
                    if unload_connection then
                        unload_connection:Disconnect()
                    end
                end)

                while not completed and not shared.is_unloading do
                    task.wait()
                end

                if shared.is_unloading then
                    tween:Cancel()
                end

                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:SetStateEnabled(5, true)
                        humanoid:ChangeState(5)
                    end

                    if shared.is_unloading then
                        for _, part in ipairs(character:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                if part.Name == "Head" or part.Name == "Torso" then
                                    part.CanCollide = true
                                else
                                    part.CanCollide = false
                                end
                            end
                        end
                    end
                end

                if connection then
                    connection:Disconnect()
                end
            end

            local function CheckForTrinkets()
                local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not root then return end

                local trinkets = {}
                local ignore_ice = not (Toggles.PickupIceEssence and Toggles.PickupIceEssence.Value)
                local ignore_scrolls = not (Toggles.PickupScrolls and Toggles.PickupScrolls.Value)
                local pickup_trinkets = Toggles.PickupTrinkets and Toggles.PickupTrinkets.Value
                local min_distance = 350 -- detection radius

                for _, object in next, ws:GetChildren() do
                    if object.Name == "Part" and object:FindFirstChild("ID") then
                        local trinketName, trinketColor, trinketZIndex = cheat_client:identify_trinket(object)
                        local should_pickup = true

                        if ignore_ice and trinketName == "Ice Essence" then
                            should_pickup = false
                        elseif trinketName == "Scroll" then
                            should_pickup = not ignore_scrolls
                        elseif not pickup_trinkets then
                            -- When pickup_trinkets is OFF, ONLY allow mythic/artifact/event
                            local is_mythic = trinketColor == cheat_client.trinket_colors.mythic.Color
                            local is_artifact = trinketColor == cheat_client.trinket_colors.artifact.Color
                            local is_event = trinketColor == cheat_client.trinket_colors.event.Color
                            should_pickup = is_mythic or is_artifact or is_event
                        end

                        if should_pickup then
                            local distance = (object.Position - root.Position).Magnitude
                            if distance <= min_distance and not already_visited_position(object.Position) then
                                table.insert(trinkets, {object = object, distance = distance})
                            end
                        end
                    end
                end

                local child_added_connection
                child_added_connection = utility:Connection(ws.ChildAdded, function(object)
                    if not trinket_bot.path_running then
                        if child_added_connection then
                            child_added_connection:Disconnect()
                        end
                        return
                    end

                    if object.Name == "Part" and object:FindFirstChild("ID") then
                        local trinketName, trinketColor, trinketZIndex = cheat_client:identify_trinket(object)
                        local should_pickup = true

                        if ignore_ice and trinketName == "Ice Essence" then
                            should_pickup = false
                        elseif trinketName == "Scroll" then
                            should_pickup = not ignore_scrolls
                        elseif not pickup_trinkets then
                            -- When pickup_trinkets is OFF, ONLY allow mythic/artifact/event
                            local is_mythic = trinketColor == cheat_client.trinket_colors.mythic.Color
                            local is_artifact = trinketColor == cheat_client.trinket_colors.artifact.Color
                            local is_event = trinketColor == cheat_client.trinket_colors.event.Color
                            should_pickup = is_mythic or is_artifact or is_event
                        end

                        if should_pickup then
                            local distance = (object.Position - root.Position).Magnitude
                            if distance <= min_distance and not already_visited_position(object.Position) then
                                table.insert(trinkets, {object = object, distance = distance})
                            end
                        end
                    end
                end)

                table.sort(trinkets, function(a, b)
                    return a.distance < b.distance
                end)

                local currentPos = root.Position
                while #trinkets > 0 and trinket_bot.path_running and not shared.is_unloading do
                    table.sort(trinkets, function(a, b)
                        return (a.object.Position - currentPos).Magnitude < (b.object.Position - currentPos).Magnitude
                    end)

                    local trinketData = table.remove(trinkets, 1)
                    if trinketData and trinketData.object and trinketData.object.Parent then
                        local trinket_position = trinketData.object.Position
                        local trinket_id = trinketData.object:FindFirstChild("ID")

                        SmoothTeleport(trinket_position)
                        table.insert(visited_positions, trinket_position)
                        currentPos = trinket_position
                        task.wait(0.5)

                        -- Fire ClickDetector to pick up the trinket
                        local click_detector = trinketData.object:FindFirstChild("ClickDetector", true)
                        if click_detector then
                            fireclickdetector(click_detector)
                            task.wait(0.3)

                            -- Mark as collected AFTER successful pickup attempt
                            if trinket_id and trinket_id:IsA("StringValue") then
                                collected_trinket_ids[trinket_id.Value] = true
                            end
                        end
                    end
                end

                if child_added_connection then
                    child_added_connection:Disconnect()
                end
            end

            local function InAir()
                local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not root then return false end

                local rayOrigin = root.Position
                local rayDirection = Vector3.new(0, -100, 0)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {plr.Character}
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                local result = ws:Raycast(rayOrigin, rayDirection, raycastParams)
                return result == nil
            end

            local function is_moderator(player)
                if not player then return false end

                if cheat_client and cheat_client.mod_list and table.find(cheat_client.mod_list, player.UserId) then
                    return true
                end

                local success, isInGroup = pcall(function()
                    return player:IsInGroup(4556484)
                end)
                if success and isInGroup then
                    local role = player:GetRoleInGroup(4556484)
                    if role ~= "Guest" then
                        return true
                    end
                end

                local success2, isInGroup2 = pcall(function()
                    return player:IsInGroup(281365)
                end)
                if success2 and isInGroup2 then
                    local role = player:GetRoleInGroup(281365)
                    if role ~= "Guest" then
                        return true
                    end
                end

                return false
            end

            local function has_observe(player)
                if not player then return false end

                if player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Observe") then
                    return true
                end

                if player.Character and player.Character:FindFirstChild("Observe") then
                    return true
                end

                return false
            end

            local teleport_debounce = false
            local function TrinketBotServerhop(reason)
                local character = plr.Character
                if character and cs:HasTag(character, "Danger") then
                    repeat
                        task.wait(0.1)
                    until not cs:HasTag(character, "Danger")
                end

                if trinket_bot.current_path_name and trinket_bot.current_path_name ~= "" then
                    mem:SetItem("trinket_bot_path", trinket_bot.current_path_name)
                end

                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local pos = plr.Character.HumanoidRootPart.Position
                    mem:SetItem("lastPlayerPosition", string.format("%s,%s,%s", pos.X, pos.Y, pos.Z))
                end

                if utility then
                    utility:add_server_to_history(game.JobId)
                end

                local current_count = 0
                if mem:HasItem("serverhop_count") then
                    current_count = tonumber(mem:GetItem("serverhop_count")) or 0
                end

                if current_count > 0 and current_count % 10 == 0 and utility then
                    utility:clear_server_history()
                    library:Notify("Server cache cleared (10 serverhops)")
                end

                local httpService = game:GetService("HttpService")
                local settings_to_save = {
                    skip_illusionist = Toggles.SkipIllusionist and Toggles.SkipIllusionist.Value or false,
                    pickup_scrolls = Toggles.PickupScrolls and Toggles.PickupScrolls.Value or false,
                    pickup_ice_essence = Toggles.PickupIceEssence and Toggles.PickupIceEssence.Value or false,
                    pickup_azael_horn = Toggles.PickupAzaelHorn and Toggles.PickupAzaelHorn.Value or false,
                    pickup_trinkets = Toggles.PickupTrinkets and Toggles.PickupTrinkets.Value or false,
                    join_oldest_server = Toggles.JoinOldestServer and Toggles.JoinOldestServer.Value or false,
                    auto_pop_pds = Toggles.AutoPopPDs and Toggles.AutoPopPDs.Value or false,
                    auto_drop_items = Options.AutoDropItems and Options.AutoDropItems.Value or {},
                    kick_on_trinket = Toggles.KickOnTrinket and Toggles.KickOnTrinket.Value or false,
                    kick_trinket_list = Options.KickTrinketList and Options.KickTrinketList.Value or {},
                    stay_in_server = Toggles.StayInServer and Toggles.StayInServer.Value or false,
                    time_between_looting = Options.TimeBetweenLooting and Options.TimeBetweenLooting.Value or 5,
                    proximity_check = Options.ProximityCheck and Options.ProximityCheck.Value or 0,
                    min_player_count = Options.MinPlayerCount and Options.MinPlayerCount.Value or 0,
                    speed = Options.TrinketBotSpeed and Options.TrinketBotSpeed.Value or 100
                }
                pcall(function()
                    mem:SetItem("trinket_bot_settings", httpService:JSONEncode(settings_to_save))
                end)

                if reason and utility then
                    local serverName, serverRegion = get_server_info()
                    local loot_summary = format_loot_summary()

                    local webhook_message = reason .. "\n"
                    webhook_message = webhook_message .. string.format("```ini\n[+] Serverhop #%d | %s (%s)\n```\n", current_count + 1, serverName, serverRegion)

                    if loot_summary and loot_summary ~= "No items collected" then
                        webhook_message = webhook_message .. loot_summary
                    else
                        webhook_message = webhook_message .. "Server looted successfully"
                    end

                    utility:plain_webhook(webhook_message)
                end

                plr.OnTeleport:Connect(function(State)
                    if teleport_debounce then
                        return
                    end
                    teleport_debounce = true

                    local queue_func = queueteleport or queue_on_teleport
                    if queue_func then
                        local success, err = pcall(function()
                            local loader_script
                            if readfile and isfile and isfile("bazaar_loader.txt") then
                                loader_script = [[local s,e=pcall(loadstring(readfile("bazaar_loader.txt")))if not s then print("[QUEUE ERROR]",e)end]]
                            else
                                loader_script = [[local s,e=pcall(loadstring(game:HttpGet("https://bazaar.hydroxide.solutions/v2/loader.lua")))if not s then print("[QUEUE ERROR]",e)end]]
                            end
                            queue_func(loader_script)
                        end)

                        if not success then
                            utility:plain_webhook(string.format("FAILED to queue script: %s", tostring(err)))
                        end
                    else
                        utility:plain_webhook("WARNING: queueteleport/queue_on_teleport not available - script will NOT auto-load!")
                    end
                end)

                if InAir() then
                    utility:Serverhop()
                else
                    pcall(function()
                        rps.Requests.ReturnToMenu:InvokeServer()
                    end)
                    task.wait(0.5)
                    utility:Serverhop()
                end
            end

            local function ExecutePath(test_mode)
                test_mode = test_mode or false

                local serverhop_count = 0
                if mem:HasItem("serverhop_count") then
                    serverhop_count = tonumber(mem:GetItem("serverhop_count")) or 0
                end

                if not cheat_client.config.blatant_mode and serverhop_count < 1 then
                    library:Notify("Blatant Mode must be enabled to run paths!")
                    if mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true" then
                        if utility and utility.plain_webhook then
                            utility:plain_webhook("BOT FAILED TO START: Blatant Mode not enabled - Kicking")
                        end
                        task.wait(1)
                        plr:Kick("Bot failed to start: Blatant Mode not enabled")
                    end
                    return
                end

                if #trinket_bot.path_points == 0 then
                    library:Notify("No points in path!")
                    if mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true" then
                        if utility and utility.plain_webhook then
                            utility:plain_webhook(string.format("BOT FAILED TO START: No path points loaded - Kicking (serverhop_count=%d)", serverhop_count))
                        end
                        task.wait(1)
                        plr:Kick("Bot failed to start: No path points loaded")
                    end
                    return
                end

                if trinket_bot.path_running then
                    library:Notify("Path already running!")
                    return
                end

                -- Set path_running immediately to prevent race conditions
                trinket_bot.path_running = true

                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                    trinket_bot.path_running = false
                    library:Notify("Character not found!")
                    return
                end

                local root = plr.Character.HumanoidRootPart
                local first_point = trinket_bot.path_points[1] and trinket_bot.path_points[1].position

                if not first_point or typeof(first_point) ~= "Vector3" then
                    trinket_bot.path_running = false
                    library:Notify("Invalid path data! Please reload or recreate the path.")
                    return
                end

                -- Skip distance check if stay in server is enabled
                local stay_in_server = Toggles.StayInServer and Toggles.StayInServer.Value or false
                if not stay_in_server then
                    local distance_to_first = (root.Position - first_point).Magnitude
                    if distance_to_first > 200 then
                        trinket_bot.path_running = false
                        library:Notify(string.format("Too far from first point! Distance: %.1f studs (max: 200)", distance_to_first))
                        return
                    end
                end

                -- Check proximity before starting path (skip if stay in server enabled)
                local stay_in_server_manual = Toggles.StayInServer and Toggles.StayInServer.Value or false
                if not stay_in_server_manual then
                    local proximity_check_distance = Options.ProximityCheck and Options.ProximityCheck.Value or 0
                    if proximity_check_distance > 0 then
                        local bot_pos = root.Position
                        for _, other_player in next, game:GetService("Players"):GetPlayers() do
                            if other_player ~= plr and other_player.Character and other_player.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = (other_player.Character.HumanoidRootPart.Position - bot_pos).Magnitude
                                if distance <= proximity_check_distance then
                                    trinket_bot.path_running = false
                                    library:Notify(string.format("Player %s is within %d studs! Cannot start path.", other_player.Name, math.floor(proximity_check_distance)))
                                    return
                                end
                            end
                        end
                    end
                end

                -- Check if any player is camping wait_for_trinket points (skip if stay in server enabled)
                if not stay_in_server_manual then
                    for point_idx, path_point in ipairs(trinket_bot.path_points) do
                        if path_point.wait_for_trinket then
                            for _, other_player in next, game:GetService("Players"):GetPlayers() do
                                if other_player ~= plr and other_player.Character and other_player.Character:FindFirstChild("HumanoidRootPart") then
                                    local player_distance = (other_player.Character.HumanoidRootPart.Position - path_point.position).Magnitude
                                    if player_distance <= 150 then
                                        trinket_bot.path_running = false
                                        library:Notify(string.format("Player %s is near trinket check point %d (%.0f studs)! Cannot start path.", other_player.Name, point_idx, player_distance))
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
                library:Notify(test_mode and "Starting test path..." or "Starting path...")

                visited_positions = {}
                collected_trinket_ids = {}

                if Toggles.auto_trinket then
                    Toggles.auto_trinket:SetValue(false)
                end

                if not test_mode then
                    mem:SetItem("botstarted", "true")
                    if not mem:HasItem("serverhop_count") then
                        mem:SetItem("serverhop_count", "0")
                    end

                    -- Save current path name immediately when bot starts
                    if trinket_bot.current_path_name and trinket_bot.current_path_name ~= "" then
                        mem:SetItem("trinket_bot_path", trinket_bot.current_path_name)
                    end

                    start_loot_tracking()

                    for _, connection in next, getconnections(plr.Idled) do
                        connection:Disable()
                    end
                end

                local death_connection
                local character = plr.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:SetStateEnabled(5, false)
                        humanoid:ChangeState(3)

                        death_connection = utility:Connection(humanoid.Died, function()
                            if death_connection then
                                death_connection:Disconnect()
                            end
                            utility:plain_webhook("player died somehow lol - kicking")
                            task.wait(0.5)
                            plr:Kick("u died lol ??")
                        end)
                    end
                end

                --[[
                local noclip_connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                    if shared.is_unloading or not trinket_bot.path_running then
                        return
                    end

                    if plr.Character then
                        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:SetStateEnabled(5, false)
                            humanoid:ChangeState(3)
                        end

                        local root = plr.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.AssemblyLinearVelocity = Vector3.new()
                        end

                        for _, v in pairs(plr.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.Velocity = Vector3.new()
                                v.CanCollide = false
                            end
                        end
                    end
                end))
                --]]

                for _, other_player in next, game:GetService("Players"):GetPlayers() do
                    if other_player ~= plr and is_moderator(other_player) then
                        library:Notify("Moderator detected! Serverhopping.")
                        --trinket_bot.path_running = false
                        TrinketBotServerhop(string.format("Moderator in server; %s - Serverhopping", other_player.Name))
                        return
                    end
                end

                if Toggles.SkipIllusionist and Toggles.SkipIllusionist.Value then
                    for _, other_player in next, game:GetService("Players"):GetPlayers() do
                        if other_player ~= plr and has_observe(other_player) then
                            library:Notify("Illusionist detected! Serverhopping.")
                            --trinket_bot.path_running = false
                            TrinketBotServerhop(string.format("Illusionist in server; %s - Serverhopping", other_player.Name))
                            return
                        end
                    end
                end

                local mod_connection = utility:Connection(game:GetService("Players").PlayerAdded, function(player)
                    if is_moderator(player) then
                        library:Notify("Moderator joined! Serverhopping.")
                        --trinket_bot.path_running = false
                        TrinketBotServerhop(string.format("Moderator Joined; %s - Serverhopping", player.Name))
                    end
                end)

                local illu_connections = {}
                if Toggles.SkipIllusionist and Toggles.SkipIllusionist.Value then
                    for _, other_player in next, game:GetService("Players"):GetPlayers() do
                        if other_player ~= plr and other_player:FindFirstChild("Backpack") then
                            local conn = utility:Connection(other_player.Backpack.ChildAdded, function(child)
                                if child.Name == "Observe" then
                                    library:Notify("Illusionist detected! Serverhopping.")
                                    --trinket_bot.path_running = false
                                    TrinketBotServerhop(string.format("Illusionist detected; %s acquired Observe - Serverhopping", other_player.Name))
                                end
                            end)
                            table.insert(illu_connections, conn)
                        end

                        local char_conn = utility:Connection(other_player.CharacterAdded, function(character)
                            task.wait(0.5)

                            if has_observe(other_player) then
                                library:Notify("Illusionist detected! Stopping path.")
                                --trinket_bot.path_running = false
                                TrinketBotServerhop(string.format("Illusionist detected; %s respawned with Observe - Serverhopping", other_player.Name))
                            else
                                if other_player:FindFirstChild("Backpack") then
                                    local bp_conn = utility:Connection(other_player.Backpack.ChildAdded, function(child)
                                        if child.Name == "Observe" then
                                            library:Notify("Illusionist detected! Stopping path.")
                                            --trinket_bot.path_running = false
                                            TrinketBotServerhop(string.format("Illusionist detected; %s acquired Observe after respawn - Serverhopping", other_player.Name))
                                        end
                                    end)
                                    table.insert(illu_connections, bp_conn)
                                end
                            end
                        end)
                        table.insert(illu_connections, char_conn)
                    end

                    local player_added_conn = utility:Connection(game:GetService("Players").PlayerAdded, function(player)
                        if player == plr then return end

                        player.CharacterAdded:Wait()
                        task.wait(0.5)

                        if has_observe(player) then
                            library:Notify("Illusionist joined! Stopping path.")
                            --trinket_bot.path_running = false
                            TrinketBotServerhop(string.format("Illusionist joined; %s with Observe - Serverhopping", player.Name))
                        else
                            if player:FindFirstChild("Backpack") then
                                local bp_conn = utility:Connection(player.Backpack.ChildAdded, function(child)
                                    if child.Name == "Observe" then
                                        library:Notify("Illusionist joined! Stopping path.")
                                        --trinket_bot.path_running = false
                                        TrinketBotServerhop(string.format("Illusionist joined; %s acquired Observe - Serverhopping", player.Name))
                                    end
                                end)
                                table.insert(illu_connections, bp_conn)
                            end
                        end
                    end)
                    table.insert(illu_connections, player_added_conn)
                end

                -- Clear proximity warnings for fresh start (uses module-level table)
                proximity_warnings = {}
                local proximity_connection

                local function get_proximity_distance()
                    return Options.ProximityCheck and Options.ProximityCheck.Value or 0
                end

                proximity_connection = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                    local proximity_check_distance = get_proximity_distance()

                    -- Skip proximity check if stay in server is enabled
                    local stay_in_server = Toggles.StayInServer and Toggles.StayInServer.Value or false
                    if stay_in_server or proximity_check_distance == 0 then
                        return
                    end

                    if shared.is_unloading or not trinket_bot.path_running then
                        return
                    end

                    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                        return
                    end

                    local bot_pos = plr.Character.HumanoidRootPart.Position
                    local now = tick()

                    for _, other_player in next, game:GetService("Players"):GetPlayers() do
                        if other_player ~= plr and other_player.Character and other_player.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (other_player.Character.HumanoidRootPart.Position - bot_pos).Magnitude
                            local state = proximity_warnings[other_player.UserId]

                            if distance <= proximity_check_distance then
                                if not state then
                                    proximity_warnings[other_player.UserId] = {
                                        firstSeen = now,
                                        lastSeen = now
                                    }
                                    library:Notify(string.format("Player %s within %d studs! Waiting 5s...", other_player.Name, math.floor(proximity_check_distance)))
                                else
                                    state.lastSeen = now
                                end

                                if distance <= proximity_check_distance/2 then
                                    library:Notify("Proximity serverhop triggered!")
                                    trinket_bot.path_running = false
                                    TrinketBotServerhop(string.format("immediately serverhopping cuz %s at %d studs came too close!", other_player.Name, math.floor(distance)))
                                    return
                                end

                                state = proximity_warnings[other_player.UserId]
                                if state and now - state.firstSeen >= 5 then
                                    library:Notify("Proximity serverhop triggered!")
                                    trinket_bot.path_running = false
                                    TrinketBotServerhop(string.format("%s stayed within %d studs for 5s so i am serverhopping.", other_player.Name, math.floor(proximity_check_distance)))
                                    return
                                end
                            else
                                if state and now - state.lastSeen > 3 then
                                    proximity_warnings[other_player.UserId] = nil
                                end
                            end
                        end
                    end
                end))


                local auto_trinket_connection
                local trinkets_list = {}
                for _,object in next, ws:GetChildren() do
                    if object.Name == "Part" and object:FindFirstChild("ID") then
                        trinkets_list[#trinkets_list + 1] = object
                    end
                end

                local trinket_added_connection = utility:Connection(ws.ChildAdded, function(object)
                    if object.Name == "Part" and object:FindFirstChild("ID") then
                        trinkets_list[#trinkets_list + 1] = object
                    end
                end)

                auto_trinket_connection = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                    if not plr.Character or shared.is_unloading or not trinket_bot.path_running then return end

                    -- Clean up trinkets that no longer exist
                    for i = #trinkets_list, 1, -1 do
                        if not trinkets_list[i] or not trinkets_list[i].Parent then
                            table.remove(trinkets_list, i)
                        end
                    end

                    for _, object in next, trinkets_list do
                        local trinket_name, trinket_color, trinket_zindex = cheat_client:identify_trinket(object)
                        local should_pickup = true

                        if trinket_name == "Azael Horn" then
                            should_pickup = Toggles.PickupAzaelHorn and Toggles.PickupAzaelHorn.Value
                        elseif trinket_name == "Ice Essence" then
                            should_pickup = Toggles.PickupIceEssence and Toggles.PickupIceEssence.Value
                        elseif trinket_name == "Scroll" then
                            should_pickup = Toggles.PickupScrolls and Toggles.PickupScrolls.Value
                        else
                            local is_common = trinket_color == cheat_client.trinket_colors.common.Color
                            local is_rare = trinket_color == cheat_client.trinket_colors.rare.Color
                            local is_mythic = trinket_color == cheat_client.trinket_colors.mythic.Color
                            local is_artifact = trinket_color == cheat_client.trinket_colors.artifact.Color
                            local is_event = trinket_color == cheat_client.trinket_colors.event.Color

                            if is_mythic or is_artifact or is_event then
                                should_pickup = true
                            elseif is_common or is_rare then
                                should_pickup = Toggles.PickupTrinkets and Toggles.PickupTrinkets.Value
                            end
                        end

                        if should_pickup then
                            local click_detector = object:FindFirstChild("ClickDetector", true)
                            local distance = plr:DistanceFromCharacter(object.CFrame.Position)
                            local dist = 9e9

                            if click_detector then
                                dist = click_detector.MaxActivationDistance
                            end

                            if click_detector and distance > 0 and distance < dist then
                                fireclickdetector(click_detector)
                            end
                        end
                    end
                end))

                local container
                if game.PlaceId == 5208655184 then
                    container = ws:FindFirstChild("Map")
                elseif game.PlaceId == 3541987450 then
                    container = ws
                end

                local affected_bricks = {}
                if container then
                    for _, v in next, container:GetChildren() do
                        if v:IsA("BasePart") and v:FindFirstChild("TouchInterest") and not (cheat_client.safe_bricks[v.Name] or cheat_client.must_touch[v.BrickColor.Number]) then
                            if v.CanTouch then
                                affected_bricks[v] = true
                                v.CanTouch = false
                            end
                        end
                    end
                end

                local monsters = workspace:FindFirstChild("MonstersSpawns") or workspace:FindFirstChild("MonsterSpawns")
                if monsters and monsters:FindFirstChild("Triggers") then
                    for _, obj in ipairs(monsters.Triggers:GetDescendants()) do
                        if obj and obj.ClassName == "Part" then
                            pcall(function()
                                obj.CanTouch = false
                            end)
                        end
                    end
                end

                local completed_wait_point = false
                for i, point in ipairs(trinket_bot.path_points) do
                    if not trinket_bot.path_running then
                        break
                    end

                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local current_pos = plr.Character.HumanoidRootPart.Position

                        if completed_wait_point then
                            for _, object in next, workspace:GetChildren() do
                                if not trinket_bot.path_running then break end

                                if object.Name == "Part" and object:FindFirstChild("ID") then
                                    local trinket_id_obj = object:FindFirstChild("ID")
                                    if trinket_id_obj and trinket_id_obj:IsA("StringValue") then
                                        if collected_trinket_ids[trinket_id_obj.Value] then
                                            continue
                                        end
                                    end

                                    if already_visited_position(object.Position) then
                                        continue
                                    end

                                    local trinket_name, trinket_color = cheat_client:identify_trinket(object)
                                    local is_valuable = false

                                    if trinket_name == "Azael Horn" then
                                        is_valuable = Toggles.PickupAzaelHorn and Toggles.PickupAzaelHorn.Value
                                    elseif trinket_name == "Ice Essence" then
                                        is_valuable = Toggles.PickupIceEssence and Toggles.PickupIceEssence.Value
                                    elseif trinket_name == "Scroll" then
                                        is_valuable = Toggles.PickupScrolls and Toggles.PickupScrolls.Value
                                    else
                                        local is_mythic = trinket_color == cheat_client.trinket_colors.mythic.Color
                                        local is_artifact = trinket_color == cheat_client.trinket_colors.artifact.Color
                                        local is_event = trinket_color == cheat_client.trinket_colors.event.Color
                                        is_valuable = is_mythic or is_artifact or is_event
                                    end

                                    if is_valuable then
                                        local trinket_pos = object.Position
                                        local distance_to_trinket = (trinket_pos - current_pos).Magnitude

                                        if distance_to_trinket < 350 then
                                            library:Notify(string.format("Detouring for %s (%.0f studs)", trinket_name or "trinket", distance_to_trinket))

                                            if trinket_id_obj and trinket_id_obj:IsA("StringValue") then
                                                collected_trinket_ids[trinket_id_obj.Value] = true
                                            end

                                            local return_pos = current_pos
                                            SmoothTeleport(trinket_pos)
                                            table.insert(visited_positions, trinket_pos)
                                            task.wait(0.5)

                                            local click_detector = object:FindFirstChild("ClickDetector", true)
                                            if click_detector then
                                                fireclickdetector(click_detector)
                                                task.wait(0.3)
                                            end

                                            SmoothTeleport(return_pos)
                                            task.wait(0.2)
                                        end
                                    end
                                end
                            end
                        end
                    end

                    -- Check if someone is camping the last point
                    local target_point = point
                    if i == #trinket_bot.path_points and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local last_point_pos = point.position
                        local someone_camping = false
                        local camper_name = ""

                        for _, other_player in next, game:GetService("Players"):GetPlayers() do
                            if other_player ~= plr and other_player.Character and other_player.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = (other_player.Character.HumanoidRootPart.Position - last_point_pos).Magnitude
                                if distance <= 65 then
                                    someone_camping = true
                                    camper_name = other_player.Name
                                    break
                                end
                            end
                        end

                        if someone_camping then
                            library:Notify(string.format("Player %s camping last point! Finding alternate...", camper_name))

                            -- Find closest point to last point where nobody is within 50 studs
                            local best_alternate = nil
                            local best_distance = math.huge

                            for j = 1, #trinket_bot.path_points - 1 do -- Check all points except last
                                local check_point = trinket_bot.path_points[j]
                                local distance_to_last = (check_point.position - last_point_pos).Magnitude

                                -- Check if anyone is near this point
                                local point_clear = true
                                for _, other_player in next, game:GetService("Players"):GetPlayers() do
                                    if other_player ~= plr and other_player.Character and other_player.Character:FindFirstChild("HumanoidRootPart") then
                                        local player_dist = (other_player.Character.HumanoidRootPart.Position - check_point.position).Magnitude
                                        if player_dist <= 50 then
                                            point_clear = false
                                            break
                                        end
                                    end
                                end

                                if point_clear and distance_to_last < best_distance then
                                    best_distance = distance_to_last
                                    best_alternate = check_point
                                end
                            end

                            if best_alternate then
                                library:Notify(string.format("Going to alternate point (%.0f studs from last)", best_distance))
                                target_point = best_alternate
                            else
                                library:Notify("No clear alternate point! Going to last point anyway...")
                            end
                        end
                    end

                    library:Notify(string.format("Moving to point %d/%d", i, #trinket_bot.path_points))
                    SmoothTeleport(target_point.position)

                    -- Wait at point if wait_time is set
                    if point.wait_time and point.wait_time > 0 then
                        local start_time = tick()
                        while tick() - start_time < point.wait_time and trinket_bot.path_running and not shared.is_unloading do
                            task.wait(0.5)
                        end
                    end

                    if trinket_bot.original_point_1_position then
                        local dist_to_original_p1 = (point.position - trinket_bot.original_point_1_position).Magnitude
                        if dist_to_original_p1 < 5 and i > 1 then
                            TrinketBotServerhop("back to point 1!!!")
                            return
                        end
                    end

                    if point.wait_for_trinket then
                        local wait_point_count = 0
                        local current_wait_index = 0
                        for idx, p in ipairs(trinket_bot.path_points) do
                            if p.wait_for_trinket then
                                wait_point_count = wait_point_count + 1
                                if idx <= i then
                                    current_wait_index = wait_point_count
                                end
                            end
                        end

                        local is_last_wait_point = (current_wait_index == wait_point_count)

                        if is_last_wait_point then
                            library:Notify(string.format("Waiting at point %d", i))
                        else
                            library:Notify(string.format("Waiting at point %d (%d/%d wait points)", i, current_wait_index, wait_point_count))
                        end

                        local disabled_noclip = false
                        if plr.Character then
                            local huma = plr.Character:FindFirstChildOfClass("Humanoid")
                            if huma then
                                local isInAir = huma.FloorMaterial == Enum.Material.Air
                                if not isInAir then
                                    huma:SetStateEnabled(5, true)
                                    huma:ChangeState(5)
                                    disabled_noclip = true
                                end
                            end
                        end

                        -- Hold position if waiting mid-air (prevents falling)
                        local position_lock_connection
                        if plr.Character then
                            local huma = plr.Character:FindFirstChildOfClass("Humanoid")
                            if huma and huma.FloorMaterial == Enum.Material.Air then
                                local lock_position = point.position
                                position_lock_connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                                    if not trinket_bot.path_running or shared.is_unloading then
                                        if position_lock_connection then
                                            position_lock_connection:Disconnect()
                                        end
                                        return
                                    end

                                    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                                    if root then
                                        root.CFrame = CFrame.new(lock_position)
                                        root.AssemblyLinearVelocity = Vector3.new()
                                    end
                                end))
                            end
                        end

                        local wait_start = tick()
                        local wait_duration = 8.67

                        if is_last_wait_point then
                            local should_collect = false
                            local temp_connection
                            temp_connection = utility:Connection(ws.ChildAdded, function(object)
                                if not trinket_bot.path_running or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                                    return
                                end

                                local root = plr.Character.HumanoidRootPart
                                if object.Name == "Part" and object:FindFirstChild("ID") then
                                    local trinketName, trinketColor, trinketZIndex = cheat_client:identify_trinket(object)
                                    local ignore_ice = not (Toggles.PickupIceEssence and Toggles.PickupIceEssence.Value)
                                    local ignore_scrolls = not (Toggles.PickupScrolls and Toggles.PickupScrolls.Value)
                                    local pickup_trinkets = Toggles.PickupTrinkets and Toggles.PickupTrinkets.Value

                                    local should_pickup = true
                                    if (ignore_ice and trinketName == "Ice Essence") then
                                        should_pickup = false
                                    elseif (ignore_scrolls and trinketName == "Scroll") then
                                        should_pickup = false
                                    elseif not pickup_trinkets then
                                        local is_common = trinketColor == cheat_client.trinket_colors.common.Color
                                        local is_rare = trinketColor == cheat_client.trinket_colors.rare.Color
                                        if is_common or is_rare then
                                            should_pickup = false
                                        end
                                    end

                                    if should_pickup then
                                        local distance = (object.Position - root.Position).Magnitude
                                        if distance <= 100 then
                                            should_collect = true
                                        end
                                    end
                                end
                            end)

                            while tick() - wait_start < wait_duration and not should_collect and trinket_bot.path_running do
                                task.wait(0.1)
                            end

                            if temp_connection then
                                temp_connection:Disconnect()
                            end
                        else
                            -- Replace blocking wait with monitored loop
                            local wait_elapsed = 0
                            while wait_elapsed < wait_duration and trinket_bot.path_running do
                                task.wait(0.5)
                                wait_elapsed = wait_elapsed + 0.5
                            end
                        end

                        -- Cleanup position lock
                        if position_lock_connection then
                            position_lock_connection:Disconnect()
                            position_lock_connection = nil
                        end

                        if disabled_noclip and plr.Character then
                            local huma = plr.Character:FindFirstChildOfClass("Humanoid")
                            if huma then
                                huma:SetStateEnabled(5, false)
                                huma:ChangeState(3)
                            end
                        end

                        CheckForTrinkets()

                        completed_wait_point = true
                    end

                end

                -- Check if we should kick after reaching the last point
                if kick_after_path then
                    library:Notify(string.format("Reached last point! Kicking for %s...", kick_trinket_name))
                    utility:plain_webhook(string.format("@here Reached last point after picking up %s - Kicking now", kick_trinket_name))
                    task.wait(0.5)
                    plr:Kick(string.format("%s picked up (completed path to last point)", kick_trinket_name))
                    return
                end

                if auto_trinket_connection then
                    auto_trinket_connection:Disconnect()
                end
                if trinket_added_connection then
                    trinket_added_connection:Disconnect()
                end
                --[[[]
                if noclip_connection then
                    noclip_connection:Disconnect()
                end
                --]]
                if proximity_connection then
                    proximity_connection:Disconnect()
                end
                if mod_connection then
                    mod_connection:Disconnect()
                end
                if death_connection then
                    death_connection:Disconnect()
                end
                for _, conn in ipairs(illu_connections) do
                    if conn then
                        conn:Disconnect()
                    end
                end
                if loot_tracking_connection then
                    loot_tracking_connection:Disconnect()
                    loot_tracking_connection = nil
                end
                for _, conn in ipairs(quantity_connections) do
                    if conn then
                        conn:Disconnect()
                    end
                end
                quantity_connections = {}

                for brick, _ in pairs(affected_bricks) do
                    if brick and brick.Parent then
                        brick.CanTouch = true
                    end
                end

                restore_bot_state()

                if not test_mode then
                    for _, connection in next, getconnections(plr.Idled) do
                        connection:Enable()
                    end
                end

                if not test_mode and not mem:HasItem("botstarted") then
                    trinket_bot.path_running = false
                    library:Notify("Bot stopped")
                    return
                end

                if not test_mode then
                    local stay_in_server = Toggles.StayInServer and Toggles.StayInServer.Value or false

                    if stay_in_server then
                        library:Notify("Path completed! Respawning...")

                        -- Show loot summary before respawning
                        local loot_summary = format_loot_summary()
                        if loot_summary and loot_summary ~= "No items collected" then
                            local run_number = (mem:HasItem("stay_in_server_runs") and tonumber(mem:GetItem("stay_in_server_runs")) or 0) + 1
                            mem:SetItem("stay_in_server_runs", tostring(run_number))

                            local webhook_message = string.format("```ini\n[+] STAY IN SERVER - Run #%d\n```\n%s", run_number, loot_summary)
                            utility:plain_webhook(webhook_message)
                        end

                        -- Reset session loot for next run
                        trinket_bot.session_loot = {}
                        trinket_bot.session_start_time = os.clock()

                        local wait_time_minutes = Options.TimeBetweenLooting and Options.TimeBetweenLooting.Value or 5
                        local wait_time_seconds = wait_time_minutes * 60

                        -- Wait with stop checks every second
                        for i = 1, wait_time_seconds do
                            if not trinket_bot.path_running or not (mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true") then
                                library:Notify("Bot stopped during wait period")
                                return
                            end
                            task.wait(1)
                        end

                        -- Check again before respawning
                        if not trinket_bot.path_running or not (mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true") then
                            library:Notify("Bot stopped before respawn")
                            return
                        end

                        pcall(function()
                            if plr.PlayerGui:FindFirstChild("StartMenu") and
                               plr.PlayerGui.StartMenu:FindFirstChild("Choices") and
                               plr.PlayerGui.StartMenu.Choices:FindFirstChild("Play") then
                                firesignal(plr.PlayerGui.StartMenu.Choices.Play.MouseButton1Click)
                            end
                        end)

                        repeat
                            if not trinket_bot.path_running or not (mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true") then
                                library:Notify("Bot stopped during respawn wait")
                                return
                            end
                            task.wait(0.25)
                        until plr.Character
                        task.wait(0.5)

                        -- Final check before restarting path
                        if not trinket_bot.path_running or not (mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true") then
                            library:Notify("Bot stopped before path restart")
                            return
                        end

                        library:Notify("Restarting path...")
                        task.wait(1)
                        trinket_bot.path_running = false
                        ExecutePath(false)
                    else
                        trinket_bot.path_running = false
                        library:Notify("Path completed! Serverhopping...")
                        task.wait(0.5)
                        TrinketBotServerhop("Server farmed, serverhopping to next")
                    end
                else
                    trinket_bot.path_running = false
                    library:Notify("Test path completed!")
                end
            end

            local group_trinket_bot = Tabs.Botting:AddLeftGroupbox("Trinket Bot")

            group_trinket_bot:AddInput("PointWaitTime", {
                Default = "0",
                Numeric = true,
                Finished = false,
                Text = "Point Wait Time (seconds)",
                Tooltip = "Time to wait at each new point (0 = no wait)",
                Placeholder = "0"
            })

            group_trinket_bot:AddButton({
                Text = "Create Point",
                Func = function()
                    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                        library:Notify("Character not found!")
                        return
                    end

                    local position = plr.Character.HumanoidRootPart.Position
                    local wait_time = tonumber(Options.PointWaitTime and Options.PointWaitTime.Value or "0") or 0
                    table.insert(trinket_bot.path_points, {
                        position = position,
                        wait_for_trinket = false,
                        wait_time = wait_time
                    })

                    if wait_time > 0 then
                        library:Notify(string.format("Created point %d (wait: %ds)", #trinket_bot.path_points, wait_time))
                    else
                        library:Notify(string.format("Created point %d at current position", #trinket_bot.path_points))
                    end
                    update_visualizations()
                end
            })

            group_trinket_bot:AddButton({
                Text = "Undo Point",
                Func = function()
                    if #trinket_bot.path_points == 0 then
                        library:Notify("No points to undo!")
                        return
                    end

                    table.remove(trinket_bot.path_points)
                    library:Notify(string.format("Removed last point. %d points remaining", #trinket_bot.path_points))
                    update_visualizations()
                end
            })

            group_trinket_bot:AddButton({
                Text = "Set Wait For Trinket",
                Func = function()
                    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                        library:Notify("Character not found!")
                        return
                    end

                    local position = plr.Character.HumanoidRootPart.Position
                    local wait_time = tonumber(Options.PointWaitTime and Options.PointWaitTime.Value or "0") or 0
                    table.insert(trinket_bot.path_points, {
                        position = position,
                        wait_for_trinket = true,
                        wait_time = wait_time
                    })

                    if wait_time > 0 then
                        library:Notify(string.format("Created wait point %d (wait: %ds)", #trinket_bot.path_points, wait_time))
                    else
                        library:Notify(string.format("Created wait point %d at current position", #trinket_bot.path_points))
                    end
                    update_visualizations()
                end
            })

            group_trinket_bot:AddButton({
                Text = "Clear Points",
                Func = function()
                    trinket_bot.path_points = {}
                    library:Notify("Cleared all points")
                    update_visualizations()
                    update_path_label(nil)
                end
            })

            group_trinket_bot:AddDivider()

            group_trinket_bot:AddToggle("VisualizePoints", {
                Text = "Visualize Points",
                Default = false,
                Callback = function(value)
                    trinket_bot.visualize_enabled = value
                    update_visualizations()
                end
            })

            group_trinket_bot:AddDivider()

            group_trinket_bot:AddToggle("SkipIllusionist", {
                Text = "Skip Illusionist Servers",
                Default = false
            })

            group_trinket_bot:AddToggle("PickupScrolls", {
                Text = "Pick up Scrolls",
                Default = false
            })

            group_trinket_bot:AddToggle("PickupIceEssence", {
                Text = "Pick up Ice Essence",
                Default = false
            })

            group_trinket_bot:AddToggle("PickupAzaelHorn", {
                Text = "Pick up Azael Horn",
                Default = false
            })

            group_trinket_bot:AddToggle("PickupTrinkets", {
                Text = "Pick up Common Trinkets",
                Default = false
            })

            group_trinket_bot:AddDivider()

            group_trinket_bot:AddToggle("KickOnTrinket", {
                Text = "Kick on Trinket Pickup",
                Default = false,
                Tooltip = "Kicks and webhooks when selected trinket is picked up"
            })

            group_trinket_bot:AddDropdown("KickTrinketList", {
                Text = "Trinkets to Kick On",
                Values = {
                    "Rift Gem", "Mysterious Artifact", "Phoenix Flower", "Azael Horn",
                    "Amulet of the White King", "Lannis Amulet", "Phoenix Down", "Night Stone", "Howler Friend",
                    "???", "Scroll", "Diamond", "Emerald", "Ruby", "Sapphire", "Ice Essence", "Bound Book",
                    "Idol of the Forgotten", "Old Ring", "Ring", "Goblet", "Old Amulet", "Amulet", "Opal"
                },
                Multi = true,
                Default = {},
                Compact = true
            })

            group_trinket_bot:AddDivider()

            group_trinket_bot:AddToggle("JoinOldestServer", {
                Text = "Join Oldest Server",
                Default = false,
                Tooltip = "Always join the oldest available server when serverhopping"
            })

            group_trinket_bot:AddToggle("AutoPopPDs", {
                Text = "Auto Pop Phoenix Downs",
                Default = false
            })

            group_trinket_bot:AddLabel("Auto Drop Items")
            group_trinket_bot:AddDropdown("AutoDropItems", {
                Text = "Auto Drop",
                Values = {
                    "Howler Friend",
                    "Ice Essence",
                    "Night Stone",
                    "Lannis Amulet",
                    "Amulet of the White King",
                    "Scroll of Trahere",
                    "Scroll of Telorum"
                },
                Multi = true,
                Default = 1,
                Tooltip = "Select items to automatically drop during botting"
            })

            group_trinket_bot:AddSlider("ProximityCheck", {
                Text = "Proximity Check (studs)",
                Default = 0,
                Min = 0,
                Max = 1000,
                Rounding = 0,
                Compact = true,
                Tooltip = "If a player is within X studs, wait 5s then serverhop (0 = disabled)"
            })

            group_trinket_bot:AddSlider("MinPlayerCount", {
                Text = "Min Player Count",
                Default = 0,
                Min = 0,
                Max = 23,
                Rounding = 0,
                Compact = true
            })

            group_trinket_bot:AddSlider("TrinketBotSpeed", {
                Text = "Speed",
                Default = 100,
                Min = 0,
                Max = 300,
                Rounding = 0
            })

            local group_trinket_config = Tabs.Botting:AddRightGroupbox("Trinket Bot Config")
            local current_path_label
            local function update_path_label(path_name)
                trinket_bot.current_path_name = path_name or ""
                if current_path_label and current_path_label.Text then
                    if path_name and path_name ~= "" then
                        current_path_label:SetText("Currently Editing: " .. path_name)
                    else
                        current_path_label:SetText("Currently Editing: None")
                    end
                end
            end

            local function get_saved_paths()
                if not listfiles or not isfolder then
                    return {}
                end

                local folder_path = "HYDROXIDE/trinket_paths"

                if not isfolder(folder_path) then
                    if makefolder then
                        makefolder(folder_path)
                    end
                    return {}
                end

                local files = listfiles(folder_path)
                local path_names = {}

                for _, file_path in ipairs(files) do
                    local file_name = file_path:match("([^/\\]+)%.json$")
                    if file_name then
                        table.insert(path_names, file_name)
                    end
                end

                return path_names
            end

            local function apply_settings(settings)
                if not settings then return end
                if Toggles.SkipIllusionist then Toggles.SkipIllusionist:SetValue(settings.skip_illusionist or false) end
                if Toggles.PickupScrolls then Toggles.PickupScrolls:SetValue(settings.pickup_scrolls or false) end
                if Toggles.PickupIceEssence then Toggles.PickupIceEssence:SetValue(settings.pickup_ice_essence or false) end
                if Toggles.PickupAzaelHorn then Toggles.PickupAzaelHorn:SetValue(settings.pickup_azael_horn or false) end
                if Toggles.PickupTrinkets then Toggles.PickupTrinkets:SetValue(settings.pickup_trinkets or false) end
                if Toggles.JoinOldestServer then Toggles.JoinOldestServer:SetValue(settings.join_oldest_server or false) end
                if Toggles.AutoPopPDs then Toggles.AutoPopPDs:SetValue(settings.auto_pop_pds or false) end
                if Options.AutoDropItems then Options.AutoDropItems:SetValue(settings.auto_drop_items or {}) end
                if Toggles.KickOnTrinket then Toggles.KickOnTrinket:SetValue(settings.kick_on_trinket or false) end
                if Options.KickTrinketList then Options.KickTrinketList:SetValue(settings.kick_trinket_list or {}) end
                if Toggles.StayInServer then Toggles.StayInServer:SetValue(settings.stay_in_server or false) end
                if Options.TimeBetweenLooting then Options.TimeBetweenLooting:SetValue(settings.time_between_looting or 5) end
                if Options.ProximityCheck then Options.ProximityCheck:SetValue(settings.proximity_check or 0) end
                if Options.MinPlayerCount then Options.MinPlayerCount:SetValue(settings.min_player_count or 0) end
                if Options.TrinketBotSpeed then Options.TrinketBotSpeed:SetValue(settings.speed or 100) end
            end

            local function load_path_by_name(path_name)
                if not path_name or path_name == "" then
                    library:Notify("Please select a path!")
                    return
                end

                if not readfile or not isfile then
                    library:Notify("readfile/isfile not supported!")
                    return
                end

                local file_path = "HYDROXIDE/trinket_paths/" .. path_name .. ".json"
                if not isfile(file_path) then
                    library:Notify(string.format("Path '%s' not found!", path_name))
                    return
                end

                local httpService = game:GetService("HttpService")
                local success, save_data = pcall(function()
                    local json = readfile(file_path)
                    return httpService:JSONDecode(json)
                end)

                if success and save_data and save_data.points then
                    trinket_bot.path_points = {}
                    for i, point_data in ipairs(save_data.points) do
                        table.insert(trinket_bot.path_points, {
                            position = Vector3.new(point_data.x, point_data.y, point_data.z),
                            wait_for_trinket = point_data.wait_for_trinket or false,
                            wait_time = point_data.wait_time or 0
                        })
                    end

                    apply_settings(save_data.settings)

                    library:Notify(string.format("Loaded path '%s' with %d points", path_name, #trinket_bot.path_points))
                    update_path_label(path_name)

                    if Options.PathName then
                        Options.PathName:SetValue(path_name)
                    end

                    if Toggles.VisualizePoints then
                        if not Toggles.VisualizePoints.Value then
                            Toggles.VisualizePoints:SetValue(true)
                        end
                        trinket_bot.visualize_enabled = true
                        update_visualizations()
                    end
                else
                    library:Notify("Failed to load path!")
                end
            end

            task.spawn(function()
                if mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true" then
                    task.wait(2)

                    -- Load settings from MemStorage FIRST before doing any checks
                    local should_skip_illusionist = false
                    if mem:HasItem("trinket_bot_settings") then
                        local httpService = game:GetService("HttpService")
                        local success_load, loaded_settings = pcall(function()
                            return httpService:JSONDecode(mem:GetItem("trinket_bot_settings"))
                        end)
                        if success_load and loaded_settings then
                            should_skip_illusionist = loaded_settings.skip_illusionist or false
                        end
                    end

                    -- Moderator check (always enabled)
                    for _, other_player in next, game:GetService("Players"):GetPlayers() do
                        if other_player ~= plr and is_moderator(other_player) then
                            library:Notify("Moderator in server! Serverhopping...")
                            task.wait(0.5)
                            TrinketBotServerhop(string.format("MODERATOR IN SERVER; %s - Serverhopping before spawn", other_player.Name))
                            return
                        end
                    end

                    -- Illusionist check (only if toggle is enabled)
                    if should_skip_illusionist then
                        for _, other_player in next, game:GetService("Players"):GetPlayers() do
                            if other_player ~= plr and has_observe(other_player) then
                                library:Notify("Illusionist in server! Serverhopping...")
                                task.wait(0.5)
                                TrinketBotServerhop(string.format("ILLUSIONIST IN SERVER; %s - Serverhopping before spawn", other_player.Name))
                                return
                            end
                        end
                    end

                    local success = pcall(function()
                        plr.PlayerGui:WaitForChild("StartMenu", 30)
                    end)

                    if success and plr.PlayerGui:FindFirstChild("StartMenu") then
                        task.wait(1)

                        pcall(function()
                            if plr.PlayerGui.StartMenu:FindFirstChild("Choices") and
                               plr.PlayerGui.StartMenu.Choices:FindFirstChild("Play") then
                                firesignal(plr.PlayerGui.StartMenu.Choices.Play.MouseButton1Click)
                            end
                        end)

                        repeat task.wait(0.25) until plr.Character
                        repeat task.wait(0.25) until plr.Character:FindFirstChild("HumanoidRootPart")
                        task.wait(1)  -- Extra time for full character load

                        local saved_path = mem:GetItem("trinket_bot_path")
                        if saved_path and saved_path ~= "" then
                            load_path_by_name(saved_path)
                            task.wait(1)

                            -- Verify path loaded successfully
                            if #trinket_bot.path_points == 0 then
                                utility:plain_webhook(string.format("FAILED TO LOAD PATH: %s - Kicking", saved_path))
                                library:Notify("Path failed to load! Kicking...")
                                task.wait(1)
                                plr:Kick(string.format("Path failed to load: %s", saved_path))
                                return
                            end

                            -- Load settings from MemStorage if available
                            if mem:HasItem("trinket_bot_settings") then
                                local httpService = game:GetService("HttpService")
                                local success, settings = pcall(function()
                                    return httpService:JSONDecode(mem:GetItem("trinket_bot_settings"))
                                end)

                                if success then
                                    apply_settings(settings)
                                end
                            end

                            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                local root = plr.Character.HumanoidRootPart
                                local first_point = trinket_bot.path_points[1] and trinket_bot.path_points[1].position

                                if first_point and typeof(first_point) == "Vector3" then
                                    -- Skip distance check if stay in server is enabled
                                    local stay_in_server = Toggles.StayInServer and Toggles.StayInServer.Value or false

                                    if not stay_in_server then
                                        local distance_to_first = (root.Position - first_point).Magnitude

                                        if distance_to_first >= 20 then
                                            local closest_point_index = 1
                                            local closest_distance = distance_to_first

                                            for idx, path_point in ipairs(trinket_bot.path_points) do
                                                local dist = (root.Position - path_point.position).Magnitude
                                                if dist < closest_distance then
                                                    closest_distance = dist
                                                    closest_point_index = idx
                                                end
                                            end

                                            if closest_distance < 2000 then
                                                if closest_point_index > 1 then
                                                    library:Notify(string.format("Starting from point %d (%.0f studs away), following path to point 1", closest_point_index, closest_distance))

                                                    local original_path = trinket_bot.path_points
                                                    local original_point_1_pos = original_path[1].position
                                                    local temp_path = {}

                                                    for i = closest_point_index, #original_path do
                                                        table.insert(temp_path, original_path[i])
                                                    end

                                                    for i = 1, closest_point_index - 1 do
                                                        table.insert(temp_path, original_path[i])
                                                    end

                                                    trinket_bot.path_points = temp_path
                                                    trinket_bot.original_point_1_position = original_point_1_pos
                                                end
                                            else
                                                trinket_bot.path_running = false
                                                library:Notify(string.format("Bot stopped: Too far from path (%.1f studs from closest point)", closest_distance))
                                                utility:plain_webhook(string.format("Bot stopped: Too far from any path point (%.1f studs from closest)", closest_distance))
                                                return
                                            end
                                        end
                                    end

                                    -- Skip camper checks if stay in server is enabled
                                    local stay_in_server_check = Toggles.StayInServer and Toggles.StayInServer.Value or false

                                    if not stay_in_server_check then
                                        local camper_found = false
                                        local camper_name = ""
                                        local camper_distance = 0

                                        for _, other_player in next, game:GetService("Players"):GetPlayers() do
                                            if other_player ~= plr and other_player.Character and other_player.Character:FindFirstChild("HumanoidRootPart") then
                                                local player_distance = (other_player.Character.HumanoidRootPart.Position - first_point).Magnitude
                                                if player_distance <= 100 then
                                                    camper_found = true
                                                    camper_name = other_player.Name
                                                    camper_distance = player_distance
                                                    break
                                                end
                                            end
                                        end

                                        if camper_found then
                                            library:Notify(string.format("Player %s is near point 1 (%.0f studs). Waiting 10s...", camper_name, camper_distance))
                                            task.wait(10)

                                            local still_camping = false
                                            for _, other_player in next, game:GetService("Players"):GetPlayers() do
                                                if other_player.Name == camper_name and other_player.Character and other_player.Character:FindFirstChild("HumanoidRootPart") then
                                                    local new_distance = (other_player.Character.HumanoidRootPart.Position - first_point).Magnitude
                                                    if new_distance <= 100 then
                                                        still_camping = true
                                                        camper_distance = new_distance
                                                        break
                                                    end
                                                end
                                            end

                                            if still_camping then
                                                library:Notify(string.format("Player %s still at point 1; Skipping server...", camper_name))
                                                task.wait(0.5)
                                                TrinketBotServerhop(string.format("PLAYER CAMPING POINT 1: %s (%.0f studs) - Skipping server", camper_name, camper_distance))
                                                return
                                            else
                                                library:Notify(string.format("Player %s moved away. Continuing...", camper_name))
                                            end
                                        end

                                        for point_idx, path_point in ipairs(trinket_bot.path_points) do
                                            if path_point.wait_for_trinket then
                                                for _, other_player in next, game:GetService("Players"):GetPlayers() do
                                                    if other_player ~= plr and other_player.Character and other_player.Character:FindFirstChild("HumanoidRootPart") then
                                                        local player_distance = (other_player.Character.HumanoidRootPart.Position - path_point.position).Magnitude
                                                        if player_distance <= 150 then
                                                            library:Notify(string.format("Player %s is on the trinket point %d (%.0f studs)! Skipping server...", other_player.Name, point_idx, player_distance))
                                                            task.wait(0.5)
                                                            TrinketBotServerhop(string.format("Player is already on the trinket point %d: %s (%.0f studs) - Skipping server", point_idx, other_player.Name, player_distance))
                                                            return
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end

                            library:Notify("Setting up the trinket bot...")
                            task.wait(2)
                            ExecutePath(false)
                        end
                    end
                end
            end)

            current_path_label = group_trinket_config:AddLabel("Currently Editing: None")
            group_trinket_config:AddDivider()

            group_trinket_config:AddInput("PathName", {
                Text = "Path Name",
                Default = "",
                Placeholder = "Enter new path name to save..."
            })

            group_trinket_config:AddButton({
                Text = "New Path",
                Func = function()
                    trinket_bot.path_points = {}
                    update_path_label(nil)
                    update_visualizations()
                    library:Notify("Started new path - all points cleared")
                end
            })

            group_trinket_config:AddDivider()

            local saved_paths = get_saved_paths()
            group_trinket_config:AddDropdown("SavedPaths", {
                Text = "Saved Paths",
                Values = saved_paths,
                Multi = false,
                Callback = function(value)
                    load_path_by_name(value)
                end
            })

            group_trinket_config:AddButton({
                Text = "Refresh Paths",
                Func = function()
                    local paths = get_saved_paths()
                    if Options.SavedPaths then
                        Options.SavedPaths:SetValues(paths)
                        library:Notify(string.format("Found %d saved paths", #paths))
                    end
                end
            })

            group_trinket_config:AddButton({
                Text = "Save Path",
                Func = function()
                    local path_name = Options.PathName and Options.PathName.Value or ""
                    if path_name == "" then
                        library:Notify("Please enter a path name!")
                        return
                    end

                    if #trinket_bot.path_points == 0 then
                        library:Notify("No points to save!")
                        return
                    end

                    if not writefile then
                        library:Notify("writefile not supported!")
                        return
                    end

                    local folder_path = "HYDROXIDE/trinket_paths"
                    if not isfolder or not isfolder(folder_path) then
                        if makefolder then
                            makefolder(folder_path)
                        end
                    end

                    local httpService = game:GetService("HttpService")
                    local serialized_points = {}
                    for i, point in ipairs(trinket_bot.path_points) do
                        table.insert(serialized_points, {
                            x = point.position.X,
                            y = point.position.Y,
                            z = point.position.Z,
                            wait_for_trinket = point.wait_for_trinket,
                            wait_time = point.wait_time or 0
                        })
                    end

                    local save_data = {
                        points = serialized_points,
                        settings = {
                            skip_illusionist = Toggles.SkipIllusionist and Toggles.SkipIllusionist.Value or false,
                            pickup_scrolls = Toggles.PickupScrolls and Toggles.PickupScrolls.Value or false,
                            pickup_ice_essence = Toggles.PickupIceEssence and Toggles.PickupIceEssence.Value or false,
                            pickup_azael_horn = Toggles.PickupAzaelHorn and Toggles.PickupAzaelHorn.Value or false,
                            pickup_trinkets = Toggles.PickupTrinkets and Toggles.PickupTrinkets.Value or false,
                            auto_pop_pds = Toggles.AutoPopPDs and Toggles.AutoPopPDs.Value or false,
                            auto_drop_items = Options.AutoDropItems and Options.AutoDropItems.Value or {},
                            kick_on_trinket = Toggles.KickOnTrinket and Toggles.KickOnTrinket.Value or false,
                            kick_trinket_list = Options.KickTrinketList and Options.KickTrinketList.Value or {},
                            stay_in_server = Toggles.StayInServer and Toggles.StayInServer.Value or false,
                            time_between_looting = Options.TimeBetweenLooting and Options.TimeBetweenLooting.Value or 5,
                            proximity_check = Options.ProximityCheck and Options.ProximityCheck.Value or 0,
                            min_player_count = Options.MinPlayerCount and Options.MinPlayerCount.Value or 0,
                            speed = Options.TrinketBotSpeed and Options.TrinketBotSpeed.Value or 100
                        }
                    }

                    local file_path = folder_path .. "/" .. path_name .. ".json"
                    local is_overwrite = isfile and isfile(file_path)

                    local success, err = pcall(function()
                        local json = httpService:JSONEncode(save_data)
                        writefile(file_path, json)
                    end)

                    if success then
                        if is_overwrite then
                            library:Notify(string.format("Overwritten path '%s' with %d points", path_name, #trinket_bot.path_points))
                        else
                            library:Notify(string.format("Saved path '%s' with %d points", path_name, #trinket_bot.path_points))
                        end

                        update_path_label(path_name)
                        if Options.SavedPaths then
                            local paths = get_saved_paths()
                            Options.SavedPaths:SetValues(paths)
                        end
                    else
                        library:Notify("Failed to save path: " .. tostring(err))
                    end
                end
            })

            group_trinket_config:AddButton({
                Text = "Delete Path",
                Func = function()
                    local path_name = Options.SavedPaths and Options.SavedPaths.Value or ""
                    if path_name == "" then
                        library:Notify("Please select a path to delete!")
                        return
                    end

                    if not delfile or not isfile then
                        library:Notify("delfile/isfile not supported!")
                        return
                    end

                    local file_path = "HYDROXIDE/trinket_paths/" .. path_name .. ".json"

                    if not isfile(file_path) then
                        library:Notify(string.format("Path '%s' not found!", path_name))
                        return
                    end

                    local success, err = pcall(function()
                        delfile(file_path)
                    end)

                    if success then
                        library:Notify(string.format("Deleted path '%s'", path_name))
                        update_path_label(nil)

                        local paths = get_saved_paths()
                        if Options.SavedPaths then
                            Options.SavedPaths:SetValues(paths)
                        end

                        trinket_bot.path_points = {}
                        update_visualizations()
                    else
                        library:Notify("Failed to delete path: " .. tostring(err))
                    end
                end
            })

            group_trinket_config:AddDivider()

            group_trinket_config:AddButton("start_path", {
                Text = "Start Path",
                Tooltip = "Requires Blatant Mode to be enabled",
                Func = function()
                    task.spawn(ExecutePath, false)
                end
            })

            group_trinket_config:AddButton("test_path", {
                Text = "Test Path",
                Tooltip = "Requires Blatant Mode to be enabled",
                Func = function()
                    task.spawn(ExecutePath, true)
                end
            })

            local stop_button = group_trinket_config:AddButton("stop_bot", {
                Text = "Stop Bot",
                Tooltip = "Stop the currently running bot",
                Func = function()
                    if trinket_bot.path_running then
                        trinket_bot.path_running = false
                        mem:RemoveItem("botstarted")

                        for _, connection in next, getconnections(plr.Idled) do
                            connection:Enable()
                        end

                        -- Clean up loot tracking connections
                        if loot_tracking_connection then
                            loot_tracking_connection:Disconnect()
                            loot_tracking_connection = nil
                        end
                        for _, conn in ipairs(quantity_connections) do
                            if conn then
                                conn:Disconnect()
                            end
                        end
                        quantity_connections = {}

                        -- Clean up visualizations
                        for _, part in ipairs(trinket_bot.point_visualizations) do
                            if part and part.Parent then
                                part:Destroy()
                            end
                        end
                        trinket_bot.point_visualizations = {}

                        restore_bot_state()

                        -- Restore visualizations if enabled
                        if trinket_bot.visualize_enabled then
                            update_visualizations()
                        end

                        library:Notify("Bot manually stopped")
                    else
                        library:Notify("Bot is not running")
                    end
                end
            })

            stop_button:SetVisible(false)

            task.spawn(function()
                while task.wait(0.5) do
                    local is_running = trinket_bot.path_running or (mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true")
                    stop_button:SetVisible(is_running)
                end
            end)

            local group_trinket_looping = Tabs.Botting:AddRightGroupbox("Looping Settings")

            group_trinket_looping:AddToggle("StayInServer", {
                Text = "Stay in Server",
                Default = false,
                Tooltip = "Loops the path in the same server instead of serverhopping"
            })

            group_trinket_looping:AddSlider("TimeBetweenLooting", {
                Text = "Time Between Looting",
                Default = 5,
                Min = 0,
                Max = 30,
                Rounding = 0,
                Suffix = "m",
                Tooltip = "Wait time before respawning and restarting path (in minutes)"
            })

            if game.PlaceId == 3541987450 or game.PlaceId == 5208655184 then
                local lives_table = {
                    ["Azael"] = 2,
                    ["Kasparan"] = 4,
                    ["Cameo"] = 9
                }

                local function Get(value)
                    local success, result = pcall(function()
                        return rps.Requests.Get:InvokeServer(utf8.char(65532) .. "\240\159\152\131", value)[value]
                    end)
                    return success and result or nil
                end

                local function can_pop_pd()
                    if not (mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true") then
                        return false
                    end

                    if not (Toggles.AutoPopPDs and Toggles.AutoPopPDs.Value) then
                        return false
                    end

                    local lives = Get("Lives")
                    if not lives then return false end

                    local race = Get("Race")
                    if not race then return false end

                    local days_survived = Get("DaysSurvived")
                    if not days_survived then return false end

                    local max_lives = lives_table[race] or 3

                    if lives >= max_lives then
                        return false
                    end

                    local last_pd_key = "last_pd_day_" .. plr.UserId
                    if mem:HasItem(last_pd_key) then
                        local last_pd_day = tonumber(mem:GetItem(last_pd_key))
                        if last_pd_day == days_survived then
                            return false
                        end
                    end

                    return true, days_survived
                end

                local function try_pop_pd()
                    local can_pop, current_day = can_pop_pd()
                    if not can_pop then return end

                    local old_lives = Get("Lives")
                    if not old_lives then return end

                    if not plr.Backpack then return end
                    local pd = plr.Backpack:FindFirstChild("Phoenix Down")
                    if pd and pd:IsA("Tool") then
                        local character = plr.Character
                        if character and character:FindFirstChild("Humanoid") then
                            character.Humanoid:EquipTool(pd)

                            task.spawn(function()
                                local timeout = tick() + 5
                                while pd.Parent ~= character and tick() < timeout do
                                    task.wait()
                                end

                                if pd.Parent == character then
                                    pd:Activate()
                                    local last_pd_key = "last_pd_day_" .. plr.UserId
                                    mem:SetItem(last_pd_key, tostring(current_day))

                                    task.wait(1)
                                    local new_lives = Get("Lives")
                                    if new_lives then
                                        local msg = string.format("🔥 Auto Popped Phoenix Down: %d → %d lives", old_lives, new_lives)
                                        library:Notify(msg)
                                        local server_name, server_region = get_server_info()
                                        local webhook_msg = string.format(
                                            "```ini\n[+] AUTO POPPED PHOENIX DOWN\n```\n**Player:** `%s`\n**Lives:** `%d → %d`\n**JobId:** `%s`\n**Server:** `%s (%s)`",
                                            plr.Name,
                                            old_lives,
                                            new_lives,
                                            game.JobId,
                                            server_name ~= "" and server_name or "Unknown",
                                            server_region ~= "" and server_region or "Unknown"
                                        )
                                        utility:plain_webhook(webhook_msg)
                                    else
                                        library:Notify("Used Phoenix Down!")
                                    end
                                end
                            end)
                        end
                    end
                end

                utility:Connection(plr.CharacterAdded, function(character)
                    character:WaitForChild("Humanoid", 10)
                    task.wait(1)
                    try_pop_pd()
                end)

                task.spawn(function()
                    while shared and not shared.is_unloading do
                        try_pop_pd()
                        task.wait(15)
                    end
                end)
            end

            local droppedTools = {}
            local function drop_item(item)
                print(string.format("[DEBUG] drop_item called for: %s", item.Name))

                if not (mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true") then
                    print("[DEBUG] Bot not started, skipping drop")
                    return
                end

                if not (Options.AutoDropItems and Options.AutoDropItems.Value) then
                    print("[DEBUG] AutoDropItems not enabled, skipping drop")
                    return
                end

                if droppedTools[item] then
                    print(string.format("[DEBUG] %s already processed, skipping", item.Name))
                    return
                end
                local selected_items = Options.AutoDropItems.Value
                local should_drop = false

                -- Check item name match (compare with spaces removed)
                for dropdown_name, enabled in pairs(selected_items) do
                    if enabled and item.Name:gsub(" ", "") == dropdown_name:gsub(" ", "") then
                        should_drop = true
                        print(string.format("[DEBUG] Matched %s exactly", item.Name))
                        break
                    end
                end

                if not should_drop then
                    print(string.format("[DEBUG] No match for %s in selected items", item.Name))
                    return
                end

                if should_drop then
                    droppedTools[item] = true

                    local character = plr.Character
                    if character and character:FindFirstChild("Humanoid") then
                        -- Wrap equip in pcall for error protection
                        local equip_success = pcall(function()
                            character.Humanoid:EquipTool(item)
                        end)

                        if not equip_success then
                            print("[DEBUG] Failed to equip item for dropping")
                            droppedTools[item] = nil
                            return
                        end

                        -- Wait for item to be equipped with 3 second timeout
                        local start_time = tick()
                        local timeout = 3
                        while item.Parent ~= character and (tick() - start_time) < timeout do
                            task.wait(0.1)
                        end

                        -- Check if equip succeeded within timeout
                        if item.Parent ~= character then
                            print(string.format("[DEBUG] Timeout waiting for %s to equip", item.Name))
                            droppedTools[item] = nil
                            return
                        end

                        task.wait(0.075)
                        vim:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
                        task.wait()
                        vim:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
                        library:Notify(string.format("Dropped %s", item.Name))

                        task.delay(2, function()
                            droppedTools[item] = nil
                        end)
                    end
                end
            end

            local function setup_backpack_monitoring()
                local backpack = plr:WaitForChild("Backpack", 30)
                if not backpack then
                    warn("[DEBUG] Failed to find backpack after 30 seconds")
                    return
                end

                utility:Connection(backpack.ChildAdded, function(obj)
                    local bot_started = mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true"
                    if not bot_started then return end

                    if not obj:IsA("Tool") then return end

                    print(string.format("[DEBUG] Tool added: %s", obj.Name))
                    task.wait(0.05)

                    if not kick_debounce and Toggles.KickOnTrinket and Toggles.KickOnTrinket.Value and Options.KickTrinketList and Options.KickTrinketList.Value then
                        local selected_trinkets = Options.KickTrinketList.Value
                        for trinket_name, _ in next, selected_trinkets do
                            if obj.Name:gsub(" ", "") == trinket_name:gsub(" ", "") then
                                kick_debounce = true
                                kick_after_path = true
                                kick_trinket_name = trinket_name
                                print(string.format("[Kick on Trinket] MATCH FOUND: %s - will kick after reaching last point", obj.Name))
                                utility:plain_webhook(string.format("@here %s found! Going to last point then kicking.", trinket_name))
                                library:Notify(string.format("%s found! Going to last point...", trinket_name))
                                return
                            end
                        end
                    end

                    task.wait(0.67)
                    task.spawn(drop_item, obj)
                end)
            end

            task.spawn(setup_backpack_monitoring)
            utility:Connection(plr.CharacterAdded, function()
                task.wait(1)
                setup_backpack_monitoring()
            end)
        end

        do -- ui
            local group_ui = Tabs.Interface:AddLeftGroupbox("UI Settings")

            -- General UI Settings
            group_ui:AddLabel("General Settings")
            
            do -- Chat Logger
                group_ui:AddToggle("chat_logger", {
                    Text = "Chat Logger",
                    Default = false,
                    Callback = function(state)
                        if state then
                            local success, result = pcall(function()
                                local LoggerGui = loadstring(game:HttpGet(repo .. "DEPENDENCIES/Chatlogger.lua"))()
                                return LoggerGui.new(cheat_client, utility)
                            end)

                            if success then
                                cheat_client.chat_logger_instance = result
                            else
                                warn("[Chat Logger] Failed to load:", result)
                            end
                        else
                            if cheat_client.chat_logger_instance then
                                cheat_client.chat_logger_instance:Unload()
                                cheat_client.chat_logger_instance = nil
                            end
                        end
                    end
                })
            end

            group_ui:AddToggle("notifications", {
                Text = "Notifications",
                Default = cheat_client.config.notifications,
                Callback = function(state)
                    cheat_client.config.notifications = state
                    if state then
                        --warn("notifications on!")
                    else
                        --warn("notifications turned off")
                    end
                end
            })

            group_ui:AddToggle("webhook_show_username", {
                Text = "Show Username in Webhooks",
                Default = cheat_client.config.webhook_show_username ~= false,
                Tooltip = "When enabled, webhooks will show [**username**] prefix",
                Callback = function(state)
                    cheat_client.config.webhook_show_username = state
                end
            })

            group_ui:AddSlider("notification_volume", {
                Text = "Notification Volume",
                Default = cheat_client.config.notification_volume or 5,
                Min = 0,
                Max = 10,
                Rounding = 1,
                Compact = false,
                Callback = function(value)
                    cheat_client.config.notification_volume = value
                end
            })

            group_ui:AddToggle("blatant_mode", {
                Text = "Blatant Mode",
                Default = cheat_client.config.blatant_mode,
                Callback = function(state)
                    cheat_client.config.blatant_mode = state

                    local function updateBlatantFeature(featureName)
                        local toggle = Toggles[featureName]
                        if not toggle then return end

                        if state then
                            toggle:SetDisabled(false)

                            -- Re-apply stored value to update visual state after enabling
                            if toggle.Value ~= nil then
                                toggle:SetValue(toggle.Value)
                            end

                            if toggle.TextLabel then
                                toggle.TextLabel.TextColor3 = Library.Scheme.FontColor
                                Library.Registry[toggle.TextLabel].TextColor3 = "FontColor"
                            end
                        else
                            if toggle.Value then
                                toggle:SetValue(false)
                            end

                            toggle:SetDisabled(true)

                            if toggle.TextLabel then
                                toggle.TextLabel.TextColor3 = Library.Scheme.Red
                                Library.Registry[toggle.TextLabel].TextColor3 = "Red"
                            end
                        end
                    end

                    for _, featureName in pairs(shared.blatant_features) do
                        updateBlatantFeature(featureName)
                    end
                end
            })

            -- Trigger callback immediately to apply initial state
            if Toggles.blatant_mode then
                Toggles.blatant_mode:SetValue(cheat_client.config.blatant_mode)
            end

            group_ui:AddDivider()

            -- Safety & Security
            group_ui:AddLabel("Safety & Security")

            group_ui:AddToggle("auto_panic", {
                Text = "Auto Panic",
                Default = cheat_client.config.auto_panic or false,
                Callback = function(state)
                    cheat_client.config.auto_panic = state
                end
            })

            group_ui:AddDropdown("AnticheatMode", {
                Text = "Anti-Cheat Mode",
                Values = {"Normal", "Kick"},
                Default = anticheat_mode == "Kick" and 2 or 1,
                Tooltip = "Normal: Silent bypass | Kick: Locks you in kick loop on detection (requires reload to apply)",
                Callback = function(value)
                    cheat_client.config.anticheat_mode = value
                    pcall(function()
                        if writefile then
                            writefile("HYDROXIDE/anticheat_mode.txt", value)
                        end
                    end)
                end
            })

            group_ui:AddDropdown("auto_panic_options", {
                Text = "Panic Conditions",
                Values = {"Unload on mod join", "Unload on Illusionist join"},
                Default = 1,
                Multi = true,
                Callback = function(value)
                    cheat_client.config.auto_panic_options = value
                end
            })

            group_ui:AddInput("webhook_url", {
                Default = cheat_client.config.webhook,
                Numeric = false,
                Finished = false,
                Text = "Discord Webhook URL (press enter to apply)",
                Tooltip = "Enter your Discord webhook URL for notifications",
                Placeholder = "https://discord.com/api/webhooks/...",
                Callback = function(value)
                    if value and value ~= "" then
                        if value:match("^https://discord.com/api/webhooks/%d+/%S+$") then
                            cheat_client.config.webhook = value
                        else
                            library:Notify("Invalid webhook URL format!")
                        end
                    else
                        cheat_client.config.webhook = ""
                    end
                end
            })

            group_ui:AddButton({
                Text = "Test Webhook",
                Func = function()
                    if not cheat_client.config.webhook or cheat_client.config.webhook == "" then
                        library:Notify("Please enter a webhook URL first!")
                        return
                    end

                    if not cheat_client.config.webhook:match("^https://discord.com/api/webhooks/%d+/%S+$") then
                        library:Notify("Invalid webhook URL format!")
                        return
                    end

                    library:Notify("Sending test webhook...")

                    local success, err = pcall(function()
                        utility:plain_webhook("hello from hydroxide.solutions")
                    end)

                    if success then
                        library:Notify("Test webhook sent successfully!")
                    else
                        library:Notify("Failed to send webhook: " .. tostring(err))
                    end
                end,
                DoubleClick = false,
                Tooltip = "Send a test message to verify your webhook is working"
            })
        end

        local status_window

        do -- ui right
            local group_ui_right = Tabs.Interface:AddRightGroupbox("UI Settings")

            -- Ally System
            group_ui_right:AddLabel("Ally System")

            group_ui_right:AddToggle("auto_housemate_ally", {
                Text = "Auto Housemate Ally",
                Default = cheat_client.config.auto_housemate_ally,
                Callback = function(state)
                    cheat_client.config.auto_housemate_ally = state
                end
            })

            group_ui_right:AddToggle("auto_friend_ally", {
                Text = "Auto Friend Ally",
                Default = cheat_client.config.auto_friend_ally,
                Callback = function(state)
                    cheat_client.config.auto_friend_ally = state
                end
            })

            group_ui_right:AddToggle("ignore_friendly", {
                Text = "Ignore Friendly",
                Default = cheat_client.config.ignore_friendly,
                Callback = function(state)
                    cheat_client.config.ignore_friendly = state
                end
            })

            group_ui_right:AddLabel("Set Friendly Keybind"):AddKeyPicker("SetFriendlyKeybind", {
                Default = "MB3",
                Text = "Set Friendly",
                Mode = "Press",
                Callback = function(Value)
                    local Model = mouse.Target and mouse.Target:FindFirstAncestorOfClass("Model")

                    local clickedPlayer = nil
                    if Model then
                        clickedPlayer = plrs:GetPlayerFromCharacter(Model)
                    end

                    if not clickedPlayer then
                        local currentCamera = workspace.CurrentCamera
                        if currentCamera and currentCamera.CameraSubject then
                            local subject = currentCamera.CameraSubject
                            if subject:IsA("Humanoid") then
                                local character = subject.Parent
                                if character then
                                    clickedPlayer = plrs:GetPlayerFromCharacter(character)
                                end
                            elseif subject:IsA("BasePart") then
                                local character = subject.Parent
                                if character and character:IsA("Model") then
                                    clickedPlayer = plrs:GetPlayerFromCharacter(character)
                                end
                            end
                        end
                    end

                    if clickedPlayer then
                        if cheat_client and cheat_client.friends then
                            local isAlreadyFriend = false
                            local friendIndex = nil

                            for i, v in pairs(cheat_client.friends) do
                                if v == clickedPlayer.UserId then
                                    isAlreadyFriend = true
                                    friendIndex = i
                                    break
                                end
                            end

                            if isAlreadyFriend then
                                table.remove(cheat_client.friends, friendIndex)
                            else
                                cheat_client.friends[#cheat_client.friends + 1] = clickedPlayer.UserId
                            end

                            if cheat_client.save_friends then
                                cheat_client:save_friends()
                            end
                        end
                    end
                end
            })

            group_ui_right:AddDivider()

            group_ui_right:AddButton({
                Text = "Clear Friendly List",
                Func = function()
                    if cheat_client and cheat_client.friends then
                        cheat_client.friends = {}
                        if cheat_client.save_friends then
                            cheat_client:save_friends()
                        end
                        library:Notify("Friendly list cleared", 2)
                    end
                end
            })

            group_ui_right:AddDivider()

            -- UI Windows
            group_ui_right:AddLabel("UI Windows")

            status_window = library:StatusWindow({
                name = "Status Effects"
            })

            group_ui_right:AddToggle("StatusEffects", {
                Text = "Status Effects",
                Default = cheat_client.config.status_effects
            })

            group_ui_right:AddToggle("StatusAutoHide", {
                Text = "Auto Hide When Empty",
                Default = true
            })

            library.StatusFrameEnabled = cheat_client.config.status_effects or false
            library.HideInactiveStatus = true
            library:UpdateStatusFrame()

            local status_pos_file = "HYDROXIDE/bin/status_frame_position.json"
            if library.StatusFrame and isfile and readfile and isfile(status_pos_file) then
                local success, pos_data = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(readfile(status_pos_file))
                end)
                if success and pos_data and #pos_data == 4 then
                    library.StatusFrame.Position = UDim2.new(pos_data[1], pos_data[2], pos_data[3], pos_data[4])
                    cheat_client.config.status_frame_position = pos_data
                end
            end

            if library.StatusFrame then
                local status_save_debounce = false
                utility:Connection(library.StatusFrame:GetPropertyChangedSignal("Position"), function()
                    if status_save_debounce then return end
                    status_save_debounce = true

                    task.spawn(function()
                        task.wait(0.05) -- Debounce 0.5s
                        status_save_debounce = false

                        local pos = library.StatusFrame.Position
                        local posTable = {pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset}
                        cheat_client.config.status_frame_position = posTable

                        if writefile and game:GetService("HttpService") then
                            pcall(function()
                                if not isfolder("HYDROXIDE") then makefolder("HYDROXIDE") end
                                if not isfolder("HYDROXIDE/bin") then makefolder("HYDROXIDE/bin") end
                                writefile(status_pos_file, game:GetService("HttpService"):JSONEncode(posTable))
                            end)
                        end
                    end)
                end)
            end

            local keybinds_window = library.KeybindFrame

            group_ui_right:AddToggle("KeybindsUi", {
                Text = "Keybinds",
                Default = cheat_client.config.keybinds_ui
            })

            group_ui_right:AddToggle("KeybindsAutoHide", {
                Text = "Hide Inactive Keybinds",
                Default = false
            })

            library.KeybindFrameEnabled = cheat_client.config.keybinds_ui or false
            library:UpdateKeybindFrame()

            local keybind_pos_file = "HYDROXIDE/bin/keybind_frame_position.json"
            if library.KeybindFrame and isfile and readfile and isfile(keybind_pos_file) then
                local success, pos_data = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(readfile(keybind_pos_file))
                end)
                if success and pos_data and #pos_data == 4 then
                    library.KeybindFrame.Position = UDim2.new(pos_data[1], pos_data[2], pos_data[3], pos_data[4])
                    cheat_client.config.keybind_frame_position = pos_data
                end
            end

            if library.KeybindFrame then
                local keybind_save_debounce = false
                utility:Connection(library.KeybindFrame:GetPropertyChangedSignal("Position"), function()
                    if keybind_save_debounce then return end
                    keybind_save_debounce = true

                    task.spawn(function()
                        task.wait(0.05) -- Debounce 0.5s
                        keybind_save_debounce = false

                        local pos = library.KeybindFrame.Position
                        local posTable = {pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset}
                        cheat_client.config.keybind_frame_position = posTable

                        if writefile and game:GetService("HttpService") then
                            pcall(function()
                                if not isfolder("HYDROXIDE") then makefolder("HYDROXIDE") end
                                if not isfolder("HYDROXIDE/bin") then makefolder("HYDROXIDE/bin") end
                                writefile(keybind_pos_file, game:GetService("HttpService"):JSONEncode(posTable))
                            end)
                        end
                    end)
                end)
            end

            shared.keybinds_window = keybinds_window
        end

        do -- Status Colors & Effects
            local status_colors = {
                parry_cooldown = Color3.fromRGB(255, 255, 0),
                frostbite = Color3.fromRGB(150, 200, 255),
                burned = Color3.fromRGB(255, 100, 0),
                fire_protection = Color3.fromRGB(255, 150, 0),
                grindstone = Color3.fromRGB(150, 150, 255),
                danger = Color3.fromRGB(255, 0, 0),
                unconscious = Color3.fromRGB(150, 0, 0),
                knocked = Color3.fromRGB(200, 100, 0),
                curse = Color3.fromRGB(150, 0, 150),
                kingsbane = Color3.fromRGB(255, 0, 255),
                lordsbane = Color3.fromRGB(255, 0, 255),
                lanncool = Color3.fromRGB(255, 0, 255),
                snapcool = Color3.fromRGB(255, 0, 255),
                flockcool = Color3.fromRGB(128, 100, 255),
                verto = Color3.fromRGB(100, 255, 100),
                spin_kick = Color3.fromRGB(255, 200, 100),
                feather_feet = Color3.fromRGB(200, 255, 200)
            }

            local verto_cooldown_active = false
            local verto_cooldown_end_time = 0

            local fire_protection_active = false
            local fire_protection_end_time = 0

            local feather_feet_active = false
            local feather_feet_end_time = 0

            local kingsbane_active = false
            local kingsbane_end_time = 0

            local lordsbane_active = false
            local lordsbane_end_time = 0

            local lanncool_active = false
            local lanncool_end_time = 0

            local snapcool_active = false
            local snapcool_end_time = 0

            local gate_feather_active = false
            local gate_feather_end_time = 0

            local flockcool_active = false
            local flockcool_end_time = 0

            local function formatTimer(name, remaining_time)
                local minutes = math.floor(remaining_time / 60)
                local seconds = math.floor(remaining_time % 60)
                if minutes > 0 then
                    return ("%s (%dm %ds)"):format(name, minutes, seconds)
                else
                    return ("%s (%ds)"):format(name, seconds)
                end
            end

            local function update_status()
                if not (Toggles and Toggles.StatusEffects and Toggles.StatusEffects.Value) then
                    return
                end
                
                local character = plr.Character
                if not character then 
                    return 
                end
                
                if status_window then
                    status_window:Clear()
                end
                
                if character:FindFirstChild("ParryCool") then
                    status_window:AddItem("Parry Cooldown", status_colors.parry_cooldown)
                end
                
                local frost = character:FindFirstChild("Frostbitten")
                if frost then
                    local frostType = frost:FindFirstChild("Lesser") and "Frostbite (Lesser)" or "Frostbite"
                    status_window:AddItem(frostType, status_colors.frostbite)
                end
                
                if character:FindFirstChild("Burned") then
                    status_window:AddItem("Burned", status_colors.burned)
                end
                
                if character:FindFirstChild("ArmorPolished") then
                    status_window:AddItem("Grindstone", status_colors.grindstone)
                end
                
                --if cs:HasTag(character, "Danger") or character:FindFirstChild("Danger") then
                --    status_window:AddItem("Danger", status_colors.danger)
                --end
                
                if cs:HasTag(character, "Unconscious") then
                    status_window:AddItem("Unconscious", status_colors.unconscious)
                elseif cs:HasTag(character, "Knocked") then
                    status_window:AddItem("Knocked", status_colors.knocked)
                end
                
                local curseCount = 0
                local children = character:GetChildren()
                for i = 1, #children do
                    local child = children[i]
                    if child.Name == "CurseMP" and child:IsA("NumberValue") then
                        curseCount = curseCount + 1
                    end
                end
                if curseCount > 0 then
                    local curse_text = ("%d Curse Stacks%s"):format(curseCount, curseCount > 1 and "s" or "")
                    status_window:AddItem(curse_text, status_colors.curse)
                end

                local dmgMult = 1
                for i = 1, #children do
                    local child = children[i]
                    if child.Name == "CurseMP" and child:IsA("NumberValue") then
                        local toAdd = 1 + child.Value
                        if toAdd > 1 then
                            dmgMult = dmgMult * toAdd
                        end
                    end
                end

                if character:FindFirstChild("Burned") then
                    dmgMult = dmgMult * 1.3
                end

                local frost = character:FindFirstChild("Frostbitten")
                if frost then
                    dmgMult = dmgMult * (frost:FindFirstChild("Lesser") and 1.2 or 1.3)
                end

                if dmgMult > 1 then
                    local damage_text = ("Damage x%.2f"):format(dmgMult)
                    status_window:AddItem(damage_text, Color3.fromRGB(255, 150, 50))
                end
                
                local boosts = character:FindFirstChild("Boosts")
                if boosts then
                    local speed = boosts:FindFirstChild("SpeedBoost")
                    local attack = boosts:FindFirstChild("AttackSpeedBoost")
                    local damage = boosts:FindFirstChild("HaseldanDamageMultiplier")
                    
                    if speed and speed.Value == 8 and attack and attack.Value == 5 then
                        if not kingsbane_active and cs:HasTag(character, "NoPotions") then
                            kingsbane_active = true
                            kingsbane_end_time = tick() + 120
                        end
                    end

                    if damage then
                        if not lordsbane_active and cs:HasTag(character, "NoPotions") then
                            lordsbane_active = true
                            lordsbane_end_time = tick() + 120
                        end
                    end
                end
                
                if cs:HasTag(character, "VertoCD") then
                    if not verto_cooldown_active then
                        verto_cooldown_active = true
                        verto_cooldown_end_time = tick() + 20
                    end
                end

                if cs:HasTag(character, "LannCool") then
                    if not lanncool_active then
                        lanncool_active = true
                        lanncool_end_time = tick() + 20
                    end
                end

                if cs:HasTag(character, "SnapCool") and character:FindFirstChild("GateOut") then
                    if not snapcool_active then
                        snapcool_active = true
                        snapcool_end_time = tick() + 8
                    end
                end

                if cs:HasTag(character, "RecentFlock") then
                    if not flockcool_active then
                        flockcool_active = true
                        flockcool_end_time = tick() + 25
                    end
                end

                if verto_cooldown_active then
                    local remaining_time = math.max(0, verto_cooldown_end_time - tick())
                    if remaining_time > 0 then
                        local timer_text = formatTimer("Verto CD", remaining_time)
                        status_window:AddItem(timer_text, status_colors.verto)
                    else
                        verto_cooldown_active = false
                        verto_cooldown_end_time = 0
                    end
                end

                if lanncool_active then
                    local remaining_time = math.max(0, lanncool_end_time - tick())
                    if remaining_time > 0 then
                        local timer_text = formatTimer("Lannis CD", remaining_time)
                        status_window:AddItem(timer_text, status_colors.lanncool)
                    else
                        lanncool_active = false
                        lanncool_end_time = 0
                    end
                end

                local gate_cd_visible = false
                if snapcool_active then
                    local remaining_time = math.max(0, snapcool_end_time - tick())
                    if remaining_time > 0 then
                        local timer_text = formatTimer("Gate CD", remaining_time)
                        status_window:AddItem(timer_text, status_colors.snapcool)
                        gate_cd_visible = true
                    else
                        snapcool_active = false
                        snapcool_end_time = 0
                    end
                elseif character:FindFirstChild("GateOut") then
                    status_window:AddItem("Gate CD", status_colors.snapcool)
                    gate_cd_visible = true
                end

                if cs:HasTag(character, "SnapCool") and not gate_cd_visible then
                    status_window:AddItem("SnapCool", status_colors.snapcool)
                end

                if flockcool_active then
                    local remaining_time = math.max(0, flockcool_end_time - tick())
                    if remaining_time > 0 then
                        local timer_text = formatTimer("Flock CD", remaining_time)
                        status_window:AddItem(timer_text, status_colors.flockcool)
                    else
                        flockcool_active = false
                        flockcool_end_time = 0
                    end
                end

                if character:FindFirstChild("FireProtection") then
                    if not fire_protection_active and cs:HasTag(character, "NoPotions") then
                        fire_protection_active = true
                        fire_protection_end_time = tick() + 300
                    end
                end

                if fire_protection_active then
                    local remaining_time = math.max(0, fire_protection_end_time - tick())
                    if remaining_time > 0 then
                        local timer_text = formatTimer("Fire Protection", remaining_time)
                        status_window:AddItem(timer_text, status_colors.fire_protection)
                    else
                        fire_protection_active = false
                        fire_protection_end_time = 0
                    end
                elseif character:FindFirstChild("FireProtection") then
                    status_window:AddItem("Fire Protection", status_colors.fire_protection)
                end

                if character:FindFirstChild("NoFall") then
                    if character:FindFirstChild("TPSafe") then
                        if not gate_feather_active then
                            gate_feather_active = true
                            gate_feather_end_time = tick() + 4
                        end
                    elseif not feather_feet_active and cs:HasTag(character, "NoPotions") then
                        feather_feet_active = true
                        feather_feet_end_time = tick() + 30
                    end
                end

                if gate_feather_active then
                    local remaining_time = math.max(0, gate_feather_end_time - tick())
                    if remaining_time > 0 then
                        local timer_text = formatTimer("No Fall", remaining_time)
                        status_window:AddItem(timer_text, Color3.fromRGB(200, 255, 200))
                    else
                        gate_feather_active = false
                        gate_feather_end_time = 0
                    end
                elseif feather_feet_active then
                    local remaining_time = math.max(0, feather_feet_end_time - tick())
                    if remaining_time > 0 then
                        local timer_text = formatTimer("Feather Feet", remaining_time)
                        status_window:AddItem(timer_text, Color3.fromRGB(200, 255, 200))
                    else
                        feather_feet_active = false
                        feather_feet_end_time = 0
                    end
                elseif character:FindFirstChild("NoFall") then
                    status_window:AddItem("Feather Feet", Color3.fromRGB(200, 255, 200))
                end

                if kingsbane_active then
                    local remaining_time = math.max(0, kingsbane_end_time - tick())
                    if remaining_time > 0 then
                        local timer_text = formatTimer("Kingsbane", remaining_time)
                        status_window:AddItem(timer_text, status_colors.kingsbane)
                    else
                        kingsbane_active = false
                        kingsbane_end_time = 0
                    end
                elseif character:FindFirstChild("Boosts") then
                    local boosts = character:FindFirstChild("Boosts")
                    local speed = boosts:FindFirstChild("SpeedBoost")
                    local attack = boosts:FindFirstChild("AttackSpeedBoost")
                    if speed and speed.Value == 8 and attack and attack.Value == 5 then
                        status_window:AddItem("Kingsbane", status_colors.kingsbane)
                    end
                end

                if lordsbane_active then
                    local remaining_time = math.max(0, lordsbane_end_time - tick())
                    if remaining_time > 0 then
                        local timer_text = formatTimer("Lordsbane", remaining_time)
                        status_window:AddItem(timer_text, status_colors.Lordsbane)
                    else
                        lordsbane_active = false
                        lordsbane_end_time = 0
                    end
                elseif character:FindFirstChild("Boosts") then
                    local boosts = character:FindFirstChild("Boosts")
                    local damage = boosts:FindFirstChild("HaseldanDamageMultiplier")
                    if damage then
                        status_window:AddItem("Lordsbane", status_colors.lordsbane)
                    end
                end

                -- Update the status frame to refresh visibility and sizing
                library:UpdateStatusFrame()
            end

            local status_update_connection
            local character_connections = {}
            
            local function setup(character)
                for _, conn in pairs(character_connections) do
                    conn:Disconnect()
                end
                character_connections = {}

                character_connections[#character_connections + 1] = utility:Connection(cs:GetInstanceRemovedSignal("VertoCD"), function(instance)
                    if instance == character and verto_cooldown_active then
                        verto_cooldown_active = false
                        verto_cooldown_end_time = 0
                    end
                end)

                character_connections[#character_connections + 1] = utility:Connection(character.ChildAdded, function(child)
                    if Toggles and Toggles.StatusEffects and Toggles.StatusEffects.Value then
                        task.defer(update_status)
                    end
                end)
                
                character_connections[#character_connections + 1] = utility:Connection(character.ChildRemoved, function(child)
                    if Toggles and Toggles.StatusEffects and Toggles.StatusEffects.Value then
                        task.defer(update_status)
                    end
                end)

                if Toggles and Toggles.StatusEffects and Toggles.StatusEffects.Value then
                    task.defer(update_status)
                end
            end
            
            local function char_added(character)
                if character then
                    setup(character)
                end
            end
            
            if plr.Character then
                char_added(plr.Character)
            end
            
            local player_connection = utility:Connection(plr.CharacterAdded, char_added)

            local function start_status_updates()
                if cheat_client.feature_connections.status_updates then return end

                local heartbeat_counter = 0
                local heartbeat_interval = 30

                cheat_client.feature_connections.status_updates = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                    heartbeat_counter = heartbeat_counter + 1
                    if heartbeat_counter >= heartbeat_interval then
                        heartbeat_counter = 0
                        if plr.Character then
                            update_status()
                        end
                    end
                end))
            end

            local function stop_status_updates()
                if cheat_client.feature_connections.status_updates then
                    cheat_client.feature_connections.status_updates:Disconnect()
                    cheat_client.feature_connections.status_updates = nil
                end
            end

            Toggles.StatusEffects:OnChanged(function()
                local state = Toggles.StatusEffects.Value
                cheat_client.config.status_effects = state
                library.StatusFrameEnabled = state
                library:UpdateStatusFrame()

                if state then
                    start_status_updates()
                else
                    stop_status_updates()
                end
            end)

            if Toggles and Toggles.StatusEffects and Toggles.StatusEffects.Value then
                start_status_updates()
            end

            Toggles.StatusAutoHide:OnChanged(function()
                local state = Toggles.StatusAutoHide.Value
                library.HideInactiveStatus = state
                library:UpdateStatusFrame()
            end)

            Toggles.KeybindsUi:OnChanged(function()
                local state = Toggles.KeybindsUi.Value
                cheat_client.config.keybinds_ui = state
                library.KeybindFrameEnabled = state
                library:UpdateKeybindFrame()
            end)

            Toggles.KeybindsAutoHide:OnChanged(function()
                local state = Toggles.KeybindsAutoHide.Value
                library.HideInactiveKeybinds = state
                library:RefreshKeybindVisibility()
            end)
        end


        local group_keybinds = Tabs.Interface:AddRightGroupbox("Keybind Settings")

        if plr.Name == "Temp11" then
            group_keybinds:AddLabel("Debug Gacha Keybind"):AddKeyPicker("DebugGachaKeybind", {
                Default = cheat_client.config.debug_gacha_keybind or "Y",
                Text = "Debug Gacha Test",
                Mode = "Press",
                Callback = function(Value)
                    if plr.Character then
                        warn("[debug] testing Xenyari interaction by keybind")
                        gacha()
                    end
                end
            })

            Options.DebugGachaKeybind:OnChanged(function()
                cheat_client.config.debug_gacha_keybind = Options.DebugGachaKeybind.Value
            end)
        end

        if game.PlaceId == 3541987450 and not LPH_OBFUSCATED then
            group_keybinds:AddLabel("PS Heal Keybind"):AddKeyPicker("PsHealButtonKeybind", {
                Default = cheat_client.config.ps_heal_button_keybind,
                Text = "PS Heal Button",
                Mode = "Press",
                Callback = function(Value)
                    pcall(function()
                        fireclickdetector(workspace.PrivateServerArena.HealingPads.Part.ClickDetector)
                    end)
                end
            })

            Options.PsHealButtonKeybind:OnChanged(function()
                cheat_client.config.ps_heal_button_keybind = Options.PsHealButtonKeybind.Value
            end)
        end

        group_keybinds:AddLabel("Instant Menu Key"):AddKeyPicker("MenuKey", {
            Default = cheat_client.config.instant_menu_keybind,
            Text = "Instant Menu",
            Mode = "Press",
            Callback = function(Value)
                rps.Requests.ReturnToMenu:InvokeServer()
            end
        })

        Options.MenuKey:OnChanged(function()
            cheat_client.config.instant_menu_keybind = Options.MenuKey.Value
        end)

        do -- Config
            if shared.SaveManager and shared.ThemeManager then
                local config_folder = game.PlaceId == 14341521240 and "HYDROXIDE/rlp_configs" or "HYDROXIDE/configs"
                shared.SaveManager:SetFolder(config_folder)
                shared.ThemeManager:SetFolder("HYDROXIDE")

                shared.SaveManager:SetIgnoreIndexes({ "SavedPaths" })

                shared.SaveManager.OnConfigLoaded = function(configName)
                    -- Persist loaded config across serverhops
                    if mem and configName then
                        mem:SetItem("loaded_config", configName)
                    end

                    if Toggles.blatant_mode then
                        Toggles.blatant_mode:SetValue(cheat_client.config.blatant_mode)
                    end

                    if Toggles.streamer_mode and cheat_client.config.streamer_mode then
                        if cheat_client.config.custom_name_spoof and cheat_client.config.custom_name_spoof ~= "" then
                            if not original_names[plr] then
                                original_names[plr] = cheat_client:get_name(plr)
                            end
                            task.wait(0.1)
                            cheat_client:spoof_name(cheat_client.config.custom_name_spoof)
                        end
                        Toggles.streamer_mode:SetValue(true)
                    end

                    pcall(function()
                        if cheat_client.config.char_custom_enabled then
                            if Toggles.char_customization_master then
                                task.defer(function()
                                    task.wait(0.5)
                                    if cheat_client.config.char_custom_face ~= "" then
                                        cheat_client.char_custom_enabled.face = true
                                    end

                                    if cheat_client.config.char_custom_shirt ~= "" then
                                        cheat_client.char_custom_enabled.shirt = true
                                    end
                                    if cheat_client.config.char_custom_pants ~= "" then
                                        cheat_client.char_custom_enabled.pants = true
                                    end
                                    if cheat_client.config.char_custom_accessories ~= "" then
                                        cheat_client.char_custom_enabled.accessories = true
                                    end
                                    local default_white = Color3.fromRGB(255, 255, 255)
                                    if cheat_client.config.char_custom_skin_color ~= default_white then
                                        cheat_client.char_custom_enabled.skin_color = true
                                    end
                                    if cheat_client.config.char_custom_rlface_color ~= default_white then
                                        cheat_client.char_custom_enabled.rlface_color = true
                                    end
                                    if cheat_client.config.char_custom_clothing_dye ~= default_white then
                                        cheat_client.char_custom_enabled.clothing_dye = true
                                    end

                                    Toggles.char_customization_master:SetValue(true)
                                end)
                            end
                        end
                    end)
                end

                shared.SaveManager:BuildConfigSection(Tabs.Config)
                shared.ThemeManager:ApplyToTab(Tabs.Config)

                local UtilityGroup = Tabs.Config:AddRightGroupbox("Utility")
                UtilityGroup:AddButton({
                    Text = "Unload Script",
                    Func = function()
                        if shared and shared.is_unloading then
                            return
                        end

                        utility:Unload()
                    end
                })


                UtilityGroup:AddButton({
                    Text = "Join Discord",
                    Func = function()
                        local json = {
                            ["cmd"] = "INVITE_BROWSER",
                            ["args"] = {
                                ["code"] = "tu9JKPqbNR"
                            },
                            ["nonce"] = 'a'
                        }

                        local success, result = pcall(function()
                            return request({
                                Url = 'http://127.0.0.1:6463/rpc?v=1',
                                Method = 'POST',
                                Headers = {
                                    ['Content-Type'] = 'application/json',
                                    ['Origin'] = 'https://discord.com'
                                },
                                Body = game:GetService('HttpService'):JSONEncode(json)
                            }).Body
                        end)

                        if not success then
                            library:Notify("Discord not detected or RPC failed", 3)
                        end
                    end
                })

                UtilityGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
                    Default = cheat_client.config.menu_keybind,
                    NoUI = true,
                    Text = "Menu keybind"
                })

                UtilityGroup:AddLabel("Unload bind"):AddKeyPicker("UnloadKeybind", {
                    Default = cheat_client.config.unload_keybind,
                    Text = "Unload Script",
                    Mode = "Toggle",
                    Callback = function(Value)
                        if shared and shared.is_unloading then
                            return
                        end

                        utility:Unload()
                    end
                })

                library.ToggleKeybind = Options.MenuKeybind
                Options.MenuKeybind:OnChanged(function()
                    cheat_client.config.menu_keybind = Options.MenuKeybind.Value
                end)

                Options.UnloadKeybind:OnChanged(function()
                    if cheat_client and cheat_client.config then
                        cheat_client.config.unload_keybind = Options.UnloadKeybind.Value
                    end
                end)

                -- Load persisted config (saved before BuildConfigSection to avoid autoload overwrite)
                print("[CONFIG PERSISTENCE] About to load config...")
                print("[CONFIG PERSISTENCE] persisted_config_name:", persisted_config_name)
                print("[CONFIG PERSISTENCE] Condition check:", persisted_config_name and persisted_config_name ~= "")

                if persisted_config_name and persisted_config_name ~= "" then
                    print("[CONFIG PERSISTENCE] Attempting to load persisted config:", persisted_config_name)
                    local success, err = shared.SaveManager:Load(persisted_config_name)

                    if success then
                        print("[CONFIG PERSISTENCE] Successfully loaded persisted config:", persisted_config_name)
                    else
                        print("[CONFIG PERSISTENCE] Failed to load persisted config:", err)
                        print("[CONFIG PERSISTENCE] Falling back to autoload")
                        shared.SaveManager:LoadAutoloadConfig()
                    end
                else
                    print("[CONFIG PERSISTENCE] No persisted config, loading autoload")
                    -- No persisted config, load autoload (if BuildConfigSection didn't already)
                    if not shared.SaveManager.CurrentConfig or shared.SaveManager.CurrentConfig == "" then
                        shared.SaveManager:LoadAutoloadConfig()
                    end
                end

                task.spawn(function()
                    local success, err = pcall(function()
                        local timeout = 0
                        repeat
                            task.wait(0.1)
                            timeout = timeout + 1
                        until #plrs:GetPlayers() > 0 or timeout > 50 -- Max 5 seconds

                        task.wait(0.5)

                    if Toggles.PlayerEsp and Toggles.PlayerEsp.Value then
                        cheat_client.player_esp_objects = cheat_client.player_esp_objects or {}
                        for _, player in pairs(plrs:GetPlayers()) do
                            if player ~= plr and not cheat_client.player_esp_objects[player] then
                                cheat_client.player_esp_objects[player] = cheat_client:add_player_esp(player)
                            end
                        end
                        cheat_client.esp_rendering.start_player_esp()
                    end

                    if cheat_client.esp_rendering.update_chams then
                        cheat_client.esp_rendering.update_chams()
                    end

                    if Toggles.TrinketEsp and Toggles.TrinketEsp.Value then
                        cheat_client.esp_rendering.start_trinket_esp()
                    end

                    if Toggles.FallionEsp and Toggles.FallionEsp.Value then
                        if game.PlaceId == 5208655184 or game.PlaceId == 109732117428502 then
                            if ws:FindFirstChild("NPCs") then
                                cheat_client.fallion_esp_objects = cheat_client.fallion_esp_objects or {}
                                for _, fallion in next, ws.NPCs:GetChildren() do
                                    if fallion.Name == "Fallion" and not cheat_client.fallion_esp_objects[fallion] then
                                        cheat_client:add_fallion_esp(fallion, fallion.Name)
                                    end
                                end
                            end
                        end
                        cheat_client.esp_rendering.start_fallion_esp()
                    end

                    if Toggles.NpcEsp and Toggles.NpcEsp.Value then
                        if ws:FindFirstChild("NPCs") then
                            cheat_client.npc_esp_objects = cheat_client.npc_esp_objects or {}
                            for _, object in next, ws.NPCs:GetChildren() do
                                if object:FindFirstChildOfClass('Pants') and object:FindFirstChild('Humanoid')
                                   and object:FindFirstChild('Torso') and not cheat_client.npc_esp_objects[object] then
                                    cheat_client:add_npc_esp(object, object.Name)
                                end
                            end
                        end
                        cheat_client.esp_rendering.start_npc_esp()
                    end

                    if Toggles.IngredientEsp and Toggles.IngredientEsp.Value then
                        cheat_client.esp_rendering.start_ingredient_esp()
                    end

                    if Toggles.ore_esp and Toggles.ore_esp.Value then
                        cheat_client.esp_rendering.start_ore_esp()
                    end
                    end)

                    if not success then
                        warn("[HXSOL] failed to initialize ESP in auto-load:", err)
                    end
                end)
            else
                local group_config = Tabs.Config:AddLeftGroupbox("Config Settings")
                group_config:AddLabel("SaveManager not available - Config system disabled")
            end
        end
    end

    do -- Legit Intent System
        local model_path = "HYDROXIDE/bin/watched.rbxm"
        local legit_intent_gui = nil
        local range = 100

        if not isfolder("HYDROXIDE") then
            makefolder("HYDROXIDE")
        end

        if not isfile(model_path) then
            local success, result = pcall(function()
                return game:HttpGet("https://hydroxide.solutions/watched.rbxm")
            end)

            if success and result then
                writefile(model_path, result)
            else
                warn("failed to download intent model")
            end
        end

        if isfile(model_path) then
            local asset = getcustomasset(model_path)
            local success, model = pcall(function()
                return game:GetObjects(asset)[1]
            end)

            if success and model then
                legit_intent_gui = model
                --print("intent model loaded successfully")
            else
                warn("failed to load intent model:", model)
            end
        end

        local function create_watched_gui(character)
            if not legit_intent_gui or not (Toggles and Toggles.LegitIntent and Toggles.LegitIntent.Value) then 
                return 
            end
            
            if character:FindFirstChild("Watched") then 
                return 
            end
            
            repeat task.wait(0.05) until character:FindFirstChild("HumanoidRootPart")
            local root_part = character:FindFirstChild("HumanoidRootPart")
            if not root_part then 
                return 
            end
            
            local eye = legit_intent_gui:Clone()
            local display = eye:FindFirstChild("Tool")
            if not display then 
                return 
            end
            
            local tool = character:FindFirstChildOfClass("Tool")
            display.Text = tool and tool.Name or ""

            eye.Parent = hidden_folder
            eye.Adornee = root_part
            eye.Name = "Watched"
            eye.Active = false
            watched_guis[character] = {gui = eye, display = display}

            utility:Connection(character.ChildAdded, function(object)
                if object:IsA("Tool") then
                    display.Text = object.Name
                end
            end)

            utility:Connection(character.ChildRemoved, function(object)
                if object:IsA("Tool") then
                    display.Text = ""
                end
            end)
            
            local connection
            local heartbeat_counter = 0
            connection = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                heartbeat_counter = heartbeat_counter + 1

                -- Throttle to ~15 FPS (every 4 heartbeats)
                if heartbeat_counter % 4 ~= 0 then return end

                if not character.Parent then
                    connection:Disconnect()
                    return
                end

                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    eye.Adornee = hrp
                    local camera_pos = ws.CurrentCamera.CFrame.Position
                    local distance = (camera_pos - hrp.Position).Magnitude

                    if distance < range then
                        ts:Create(display, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
                    else
                        ts:Create(display, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
                    end
                else
                    eye:Destroy()
                    watched_guis[character] = nil
                    connection:Disconnect()
                end
            end))
        end

        local function remove_watched_gui(character)
            local watched = watched_guis[character]
            if watched and watched.gui then
                ts:Create(watched.display, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
                task.wait(0.25)
                watched.gui:Destroy()
                watched_guis[character] = nil
            end
        end
        
        cheat_client.legit_intent_cleanup = function()
            for character, watched in pairs(watched_guis) do
                if watched and watched.gui then
                    watched.gui:Destroy()
                    watched_guis[character] = nil
                end
            end
        end

        local legit_intent_player_connections = {}
        local function connect_player_legit_intent(player)
            if player == plr then return end

            if legit_intent_player_connections[player] then
                for _, conn in pairs(legit_intent_player_connections[player]) do
                    conn:Disconnect()
                end
            end
            legit_intent_player_connections[player] = {}

            if player.Character then
                create_watched_gui(player.Character)
            end

            legit_intent_player_connections[player].characterAdded = utility:Connection(player.CharacterAdded, function(character)
                if shared and Toggles and Toggles.LegitIntent and Toggles.LegitIntent.Value then
                    create_watched_gui(character)
                end
            end)

            legit_intent_player_connections[player].characterRemoving = utility:Connection(player.CharacterRemoving, function(character)
                if watched_guis[character] then
                    remove_watched_gui(character)
                end
            end)
        end

        local function disconnect_player_legit_intent(player)
            if legit_intent_player_connections[player] then
                for _, conn in pairs(legit_intent_player_connections[player]) do
                    if conn and conn.Connected then
                        conn:Disconnect()
                    end
                end
                legit_intent_player_connections[player] = nil
            end

            if player.Character and watched_guis[player.Character] then
                remove_watched_gui(player.Character)
            end
        end

        local function setup()
            if not (Toggles and Toggles.LegitIntent and Toggles.LegitIntent.Value) then
                return
            end

            for _, player in pairs(plrs:GetPlayers()) do
                connect_player_legit_intent(player)
            end

            utility:Connection(plrs.PlayerAdded, function(player)
                if Toggles and Toggles.LegitIntent and Toggles.LegitIntent.Value then
                    connect_player_legit_intent(player)
                end
            end)

            utility:Connection(plrs.PlayerRemoving, disconnect_player_legit_intent)
        end

        cheat_client.legit_intent_setup = function()
            if legit_intent_gui then
                setup()
            end
        end
        
        if legit_intent_gui and Toggles and Toggles.LegitIntent and Toggles.LegitIntent.Value then
            setup()
        end
    end

    do -- Proximity Notifier System
        cheat_client.proximity_cleanup = function()
            if proximity_connection then
                proximity_connection:Disconnect();
                proximity_connection = nil
            end

            if proximity_gui and proximity_gui.Parent then
                proximity_gui:Destroy()
                proximity_gui = nil
                proximity_label = nil
            end
        end

        local function setup()
            if not (Toggles and Toggles.proximity_notifier and Toggles.proximity_notifier.Value) then
                return
            end

            if not proximity_gui then
                proximity_gui = Instance.new("ScreenGui")
                proximity_gui.Name = "NearbyNotifier"
                proximity_gui.ResetOnSpawn = false
                proximity_gui.Parent = hidden_folder

                proximity_label = Instance.new("TextLabel")
                proximity_label.Size = UDim2.new(0, 400, 0, 50)
                proximity_label.Position = UDim2.new(0.5, -200, 0, 150)
                proximity_label.BackgroundTransparency = 1
                proximity_label.TextColor3 = Color3.fromRGB(255, 255, 255)
                proximity_label.TextStrokeTransparency = 0
                proximity_label.TextSize = 32
                proximity_label.Font = Enum.Font.SourceSansBold
                proximity_label.Text = ""
                proximity_label.Visible = false
                proximity_label.Parent = proximity_gui
            end

            local heartbeat_counter = 0
            proximity_connection = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                heartbeat_counter = heartbeat_counter + 1

                -- Throttle to ~10 FPS (every 6 heartbeats)
                if heartbeat_counter % 6 ~= 0 then return end

                local threshold = Options.proximity_distance and Options.proximity_distance.Value or 100
                if threshold == 0 then
                    if proximity_label then
                        proximity_label.Visible = false
                    end
                    return
                end

                local my_char = plr.Character
                if not my_char then
                    if proximity_label then
                        proximity_label.Visible = false
                    end
                    return
                end

                local my_hrp = my_char:FindFirstChild("HumanoidRootPart")
                if not my_hrp then
                    if proximity_label then
                        proximity_label.Visible = false
                    end
                    return
                end

                local nearest_player = nil
                local nearest_dist = math.huge
                local ignore_allies = Toggles.proximity_ignore_allies and Toggles.proximity_ignore_allies.Value or false

                for _, player in next, plrs:GetPlayers() do
                    if player ~= plr then
                        if ignore_allies and cheat_client:is_friendly(player) then
                            continue
                        end

                        local their_char = player.Character
                        if their_char then
                            local their_hrp = their_char:FindFirstChild("HumanoidRootPart")
                            if their_hrp then
                                local dist = (my_hrp.Position - their_hrp.Position).Magnitude
                                if dist <= threshold and dist < nearest_dist then
                                    nearest_dist = dist
                                    nearest_player = player
                                end
                            end
                        end
                    end
                end

                if nearest_player and proximity_label then
                    local spoofed_name = cheat_client:get_name(nearest_player)
                    local real_name = nearest_player.Name
                    local display_name = string.format("%s (%s)", spoofed_name, real_name)
                    proximity_label.Text = string.format("%s is nearby! [%d]", display_name, math.floor(nearest_dist))
                    proximity_label.Visible = true
                elseif proximity_label then
                    proximity_label.Visible = false
                end
            end))
        end

        cheat_client.proximity_setup = function()
            setup()
        end

        if Toggles and Toggles.proximity_notifier and Toggles.proximity_notifier.Value then
            setup()
        end
    end

    -- Hooks // put anti cheat hooks at top 🙏🙏
    do
        local function getPing()
            local success, ping = pcall(function()
                return game:GetService('Stats'):WaitForChild('PerformanceStats'):WaitForChild('Ping'):GetValue()
            end)
            return success and ping or 0
        end

        do -- Collection Hooks
            old_hastag = hookfunction(cs.HasTag, function(self, object, tag)
                if not checkcaller() then
                    if object == plr.Character then
                        if tag == "Acrobat" and shared and Toggles and Toggles.spoof_acrobat and Toggles.spoof_acrobat.Value then
                            return true
                        elseif tag == "The Soul" and shared and Toggles and Toggles.spoof_the_soul and Toggles.spoof_the_soul.Value then
                            return true
                        end
                    end
                end
                return old_hastag(self, object, tag)
            end)
        end

        do -- Get Dialogue Remote
            local active_connections = {}

            local function sensitive(tbl, key)
                for k, _ in pairs(tbl) do
                    if typeof(k) == "string" and k:lower() == key:lower() then
                        return true
                    end
                end
                return false
            end

            -- For PlaceId 14341521240, directly set dialogue_remote
            if game.PlaceId == 14341521240 then
                local dialogue = rps.Requests:FindFirstChild("Dialogue")
                if dialogue then
                    dialogue_remote = dialogue
                end
            end

            for _, remote in pairs(rps.Requests:GetChildren()) do
                if remote:IsA("RemoteEvent") then
                    local connection
                    connection = utility:Connection(remote.OnClientEvent, function(data)
                        if typeof(data) == "table" and (sensitive(data, "choices") or sensitive(data, "speaker")) then
                            if not dialogue_remote then
                                --warn("found remote:", remote.Name)
                                dialogue_remote = remote

                                if shared and shared.setupAutoDialogue then
                                    shared.setupAutoDialogue()
                                end

                                if Toggles and Toggles.auto_dialogue and Toggles.auto_dialogue.Value then
                                    if plr.Character and plr.Character:FindFirstChild("InDialogue") then
                                        task.defer(function()
                                            if shared.auto_dialogue_handler then
                                                shared.auto_dialogue_handler(data)
                                            end
                                        end)
                                    end
                                end
                                
                                for _, conn in pairs(active_connections) do
                                    conn:Disconnect()
                                end
                                active_connections = {}
                                active_connections[#active_connections + 1] = connection
                            end
                        end
                    end)
                    active_connections[#active_connections + 1] = connection
                end
            end
        end

        do -- Mana Remote Detection
            local function attempt_mana_remote_detection(char)
                mana_remote = nil
                
                local humanoid = char:WaitForChild("Humanoid", 5)
                if not humanoid then return end
                
                local handler = char:WaitForChild("CharacterHandler", 5)
                if not handler then return end
                
                local remotes = handler:WaitForChild("Remotes", 5)
                if not remotes then return end
                
                local forcefield = char:FindFirstChildOfClass("ForceField")
                
                if forcefield then
                    local connection
                    connection = utility:Connection(char.ChildRemoved, function(child)
                        if child == forcefield or child:IsA("ForceField") then
                            --print("ForceField removed!")
                            connection:Disconnect()
                        end
                    end)

                    while shared and not shared.is_unloading and forcefield and forcefield:IsDescendantOf(game) do
                        task.wait(0.5)
                    end
                    
                    if connection then
                        connection:Disconnect()
                    end
                end
                
                task.wait(0.3)
                
                local charge_key = Enum.KeyCode.G
                vim:SendKeyEvent(true, charge_key, false, game)
                task.wait(0.15)
                vim:SendKeyEvent(false, charge_key, false, game)
                task.wait(0.2)
            end

            local function mana_cleanup(char)
                mana_remote = nil
                
                task.spawn(function()
                    attempt_mana_remote_detection(char)
                end)
            end

            if plr.Character then 
                mana_cleanup(plr.Character)
                task.spawn(function()
                    attempt_mana_remote_detection(plr.Character)
                end)
            end
            
            utility:Connection(plr.CharacterAdded, function(char)
                mana_cleanup(char)
                task.spawn(function()
                    attempt_mana_remote_detection(char)
                end)
            end)
        end
    end
    
    -- Init
    do
        utility:setup_error_webhook()

        do -- FOV
            aimbot_fov_circle = utility:Create("Circle", {
                Visible = false,
                Radius = 100,
                Transparency = 1,
                Thickness = 1,
                Color = Color3.fromRGB(255,255,255),
            }, "esp")

            silent_circle = utility:Create("Circle", {
                Visible = false,
                Radius = 5,
                Transparency = 0.7,
                Thickness = 1,
                Color = Color3.fromRGB(255,0,0),
            }, "esp")
        end

        do -- Mana
            spellvis = utility:Create("Square", {
                Visible = false,
                Transparency = 0.45, -- 0.3
                Filled = true,
                ZIndex = 100,
                Color = Color3.fromRGB(255, 0, 0),
            }, "esp")

            snapvis = utility:Create("Square", {
                Visible = false,
                Transparency = 0.45, -- 0.3
                Filled = true,
                ZIndex = 100,
                Color = Color3.fromRGB(0, 0, 255),
            }, "esp")
        end

        do -- Mana Overlay
            local char = plr and plr.Character
            
            local current_spell_instance = nil
            local current_spell = nil
            
            function cheat_client:update_visuals(tool)
                if not plr or not plr.Character then return end
                if not (Toggles and Toggles.mana_overlay and Toggles.mana_overlay.Value) then
                    cheat_client:clear_visuals()
                    return
                end
                
                if not (plr and plr.PlayerGui and 
                    plr.PlayerGui:FindFirstChild("StatGui") and 
                    plr.PlayerGui.StatGui:FindFirstChild("LeftContainer") and 
                    plr.PlayerGui.StatGui.LeftContainer:FindFirstChild("Mana")) then
                    cheat_client:clear_visuals()
                    return
                end
                
                local manaBar = plr.PlayerGui.StatGui.LeftContainer.Mana
                char = plr.Character
                
                if not tool or not tool:IsDescendantOf(char) then
                    cheat_client:clear_visuals()
                    return
                end

                local spell = cheat_client.spell_cost[tool.Name]
                if not spell or not spell[1] then
                    cheat_client:clear_visuals()
                    return
                end

                local lowerbound = spell[1][1]
                local upperbound = spell[1][2]

                local data = char:FindFirstChild("Artifacts")
                local scholar_boost = 0
                local boosts = char:FindFirstChild("Boosts")
                if boosts then
                    local scholars = boosts:FindFirstChild("ScholarsBoon")
                    if scholars then
                        scholar_boost = scholar_boost + scholars.Value
                    end
                end

                local backpack = plr:FindFirstChild("Backpack")
                if backpack then
                    if backpack:FindFirstChild("WiseCasting") then
                        scholar_boost = scholar_boost + 2
                    end
                    if backpack:FindFirstChild("RemTraining") then
                        scholar_boost = scholar_boost + 3
                    end
                end

                lowerbound = math.max(0, lowerbound - scholar_boost)
                upperbound = math.min(100, upperbound + scholar_boost)

                local baseX = manaBar.AbsolutePosition.X
                local baseY = manaBar.AbsolutePosition.Y
                local barWidth = manaBar.AbsoluteSize.X
                local barHeight = manaBar.AbsoluteSize.Y
                local topInset = game:GetService("GuiService"):GetGuiInset().Y

                local function getY(percent)
                    return baseY + barHeight * (1 - percent / 100) + topInset
                end

                local spellTop = getY(upperbound)
                local spellBottom = getY(lowerbound)
                spellvis.Position = Vector2.new(baseX, spellTop)
                spellvis.Size = Vector2.new(barWidth, math.abs(spellBottom - spellTop))
                spellvis.Visible = true

                if spell[2] then
                    local snapLower = math.max(0, spell[2][1] - scholar_boost)
                    local snapUpper = math.min(100, spell[2][2] + scholar_boost)

                    local snapTop = getY(snapUpper)
                    local snapBottom = getY(snapLower)
                    snapvis.Position = Vector2.new(baseX, snapTop)
                    snapvis.Size = Vector2.new(barWidth, math.abs(snapBottom - snapTop))
                    snapvis.Visible = true
                else
                    snapvis.Visible = false
                end

            end

            local mana_overlay_connections = {}

            local function setup_character()
                if not plr or not plr.Character then return end
                char = plr.Character

                -- Clean up old connections
                for _, conn in pairs(mana_overlay_connections) do
                    conn:Disconnect()
                end
                mana_overlay_connections = {}

                if utility then
                    mana_overlay_connections[#mana_overlay_connections + 1] = utility:Connection(char.ChildAdded, function(child)
                        if not (Toggles and Toggles.mana_overlay and Toggles.mana_overlay.Value) then
                            cheat_client:clear_visuals()
                            return
                        end

                        if not cheat_client.spell_cost[child.Name] then return end

                        if current_spell then
                            current_spell:Disconnect()
                            current_spell = nil
                        end

                        current_spell_instance = child
                        cheat_client:update_visuals(child)

                        current_spell = utility:Connection(child.AncestryChanged, function(_, parent)
                            if plr.Backpack and parent == plr.Backpack then
                                cheat_client:clear_visuals()
                                current_spell_instance = nil

                                if current_spell then
                                    current_spell:Disconnect()
                                    current_spell = nil
                                end
                            end
                        end)
                    end)

                    if Toggles and Toggles.mana_overlay and Toggles.mana_overlay.Value then
                        cheat_client:update_visuals(char:FindFirstChildOfClass("Tool"))
                    end
                end
            end

            if plr and plr.Character then
                setup_character()
            end

            if utility and plr then
                utility:Connection(plr.CharacterAdded, function(newChar)
                    char = newChar
                    setup_character()
                end)
            end
        end
        
        do -- No Fall Damage & Anti Gate Backfire
            local function block()
                local blockRemote, unblockRemote
                local handler = plr.Character:FindFirstChild("CharacterHandler", true)
                if handler then
                    local remotes = handler:FindFirstChild("Remotes")
                    if remotes then
                        blockRemote = remotes:FindFirstChild("Block")
                        unblockRemote = remotes:FindFirstChild("Unblock")
                    end
                end

                if blockRemote and unblockRemote then
                    task.wait(0.01)
                    local object = {}
                    blockRemote:FireServer(false)

                    repeat
                        task.wait()
                    until plr.Character:FindFirstChild("Action")

                    unblockRemote:FireServer(object)
                end
            end

            if game.PlaceId == 5208655184 or game.PlaceId == 3541987450 or game.PlaceId == 109732117428502 or game.PlaceId == 14341521240 then
                old_remote = hookfunction(Instance.new("RemoteEvent").FireServer, function(Event, ...)
                	local args = {...}

                    local char = plr.Character
                    local remotes_folder = char
                        and char:FindFirstChild("CharacterHandler")
                        and char.CharacterHandler:FindFirstChild("Remotes")

                    if shared and not mana_remote and remotes_folder and Event.Parent == remotes_folder then
                        if game.PlaceId == 14341521240 then -- 14341521240: SetManaChargeState
                            if Event.Name == "SetManaChargeState" then
                                mana_remote = Event
                            end
                        elseif game.PlaceId == 3541987450 then -- 354: boolean signature
                            if Event.Name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") and #args == 1 and typeof(args[1]) == "boolean" then
                                mana_remote = Event
                            end
                        else
                            if Event.Name:sub(1,4) == "M0ai" and #args == 1 and typeof(args[1]) == "table" then -- normal: M0ai + {num,num}
                                local t = args[1]
                                local keys = 0
                                for _ in pairs(t) do keys+=1 end
                                local a, b = t[1], t[2]
                                if keys == 2 and typeof(a)=="number" and typeof(b)=="number" and b%1~=0 then
                                    mana_remote = Event
                                end
                            end
                        end
                    end


                    if shared and remotes_folder and Event.Parent == remotes_folder then
                        -- Check if no fall is enabled via toggle OR if trinket bot path is running
                        local no_fall_enabled = (Toggles and Toggles.no_fall and Toggles.no_fall.Value) or (trinket_bot and trinket_bot.path_running)
                        if no_fall_enabled and #args == 2 and typeof(args[2]) == "table" then
                            return
                        end
                    end
                    
                	if shared and Toggles and Toggles.gate_anti_backfire and Toggles.gate_anti_backfire.Value and tostring(Event):match("RightClick") then
                        if plr.Character then
                            if plr.Character:FindFirstChild('Gate') then
                                local artifacts_folder = plr.Character:FindFirstChild("Artifacts")
                                if artifacts_folder and artifacts_folder:FindFirstChild("PhilosophersStone") then
                                    return old_remote(Event, ...)
                                end

                                local mana_instance = plr.Character:FindFirstChild('Mana')
                                if mana_instance then
                                    local mana_value = mana_instance.Value;

                                    if (mana_value > 75 and mana_value < 80) or not cs:HasTag(plr.Character,'Danger') and plr.Character:FindFirstChild("AzaelHorn") then
                                        return old_remote(Event, ...)
                                    end
                                    
                                    return
                                end
                            end
                        end
                    end

                    if shared and Toggles and Toggles.AntiBackfireViribus and Toggles.AntiBackfireViribus.Value and tostring(Event) == "RightClick" then
                        if plr and plr.Character and cs:HasTag(plr.Character, "SnapCool") then
                            return old_remote(Event, ...)
                        end
                        
                        if plr and plr.Character and plr.Character:FindFirstChild("Viribus") then
                            local artifacts_folder = plr.Character:FindFirstChild("Artifacts")
                            if not (artifacts_folder and artifacts_folder:FindFirstChild("PhilosophersStone")) then
                                local mana_instance = plr.Character:FindFirstChild("Mana")
                                if mana_instance then
                                    local mana_value = mana_instance.Value
                                    if (mana_value > 0 and mana_value < 60) or (mana_value > 70) then
                                        task.spawn(block)
                                    end
                                end
                            end
                        end
                    end

                    if shared and Toggles and Toggles.temperature_lock and Toggles.temperature_lock.Value and rps.Requests and Event.Parent == rps.Requests and Event.Name ~= "ClearTrinket" then
                        if #args == 1 and typeof(args[1]) == "string" then
                            return 'Oresfall';
                        end
                    end

                	return old_remote(Event, ...)
                end)
            end
        end

        do -- Automation
            local function find_tool(names, matching)
                if not plr.Character then return end
                local function checkItem(item)
                    for _, name in ipairs(names) do
                        if matching == "match" then
                            if string.match(item.Name:lower(), name:lower()) then
                                return item
                            end
                        else
                            if item.Name == name then
                                return item
                            end
                        end
                    end
                    return nil
                end

                if not plr.Backpack then return nil end
                for _, item in ipairs(plr.Backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        local tool = checkItem(item)
                        if tool then return tool end
                    end
                end

                if plr.Character then
                    for _, item in ipairs(plr.Character:GetChildren()) do
                        if item:IsA("Tool") then
                            local tool = checkItem(item)
                            if tool then return tool end
                        end
                    end
                end

                return nil
            end

            local function use(tool)
                if not (plr.Character and tool) then return end

                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                if not humanoid then return end

                humanoid:UnequipTools();

                if plr.Backpack and tool.Parent == plr.Backpack then
                    humanoid:EquipTool(tool)
                end

                if not plr.Character:FindFirstChild(tool.Name) then
                    tool.AncestryChanged:Wait()
                end

                task.wait(0.025) -- utility:random_wait()
                local charTool = plr.Character:FindFirstChild(tool.Name)
                if charTool then
                    charTool:Activate()
                end
            end

            utility:Connection(cs:GetInstanceAddedSignal("Unconscious"), function(instance)
                if plr.Character and instance == plr.Character and shared and Toggles and Toggles.auto_resurrection and Toggles.auto_resurrection.Value then
                    task.spawn(function()
                        task.wait(utility:random_wait())
                        local resurrection = find_tool({ "Resurrection", "Dragon Awakening", "Dragon Resurrection" }, "exact")
                        if resurrection then
                            use(resurrection)
                        end
                    end)
                end
            end)

            utility:Connection(cs:GetInstanceRemovedSignal("Knocked"), function(instance)
                if plr.Character and instance == plr.Character and shared and Toggles and Toggles.auto_chair and Toggles.auto_chair.Value then
                    local shouldUseChair = true
                    if plr.Character:FindFirstChild("HumanoidRootPart") then
                        local bone = plr.Character.HumanoidRootPart:FindFirstChild("Bone")
                        if bone and bone:IsA("BasePart") then
                            shouldUseChair = false
                        end
                    end
                    
                    if shouldUseChair then
                        task.spawn(function()
                            local chair = find_tool({ "chair", "throne" }, "match")
                            if chair then
                                task.wait(0.055)
                                use(chair)
                            end
                        end)
                    end
                end
            end)
        end
        
        do
            local TRANSPARENCY_VALUE = 0.7
            local DETECTION_RADIUS = 25
            
            local function makeNearbyPartsTransparent(character, rootPart)
                for part, originalTransparency in pairs(transparent_parts) do
                    if part and part:IsA("BasePart") then
                        part.Transparency = originalTransparency
                    end
                end
                transparent_parts = {}
                
                local nearbyParts = workspace:GetPartBoundsInRadius(rootPart.Position, DETECTION_RADIUS)
                for _, part in ipairs(nearbyParts) do
                    if not part:IsDescendantOf(character) and part:IsA("BasePart") and part.CanCollide then
                        transparent_parts[part] = part.Transparency
                        part.Transparency = TRANSPARENCY_VALUE
                    end
                end
            end
            
            local function restorePartTransparency()
                for part, originalTransparency in pairs(transparent_parts) do
                    if part and part:IsA("BasePart") then
                        part.Transparency = originalTransparency
                    end
                end
                transparent_parts = {}
            end
            
            function cheat_client:restore_state()
                restorePartTransparency()

                -- Check if trinket bot is running or if flight noclip was enabled
                local is_bot_running = mem and mem:HasItem("botstarted") and mem:GetItem("botstarted") == "true"

                if (was_noclip_enabled or is_bot_running) and plr and plr.Character then
                    restorePartTransparency()

                    local character = plr.Character
                    local huma = character:FindFirstChildOfClass("Humanoid")

                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            if part.Name == "Head" or part.Name == "Torso" then
                                part.CanCollide = true
                            else
                                part.CanCollide = false
                            end
                        end
                    end

                    if huma then
                        huma:SetStateEnabled(5, true)
                        huma:ChangeState(5)
                    end

                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.Anchored = false
                    end

                    was_noclip_enabled = false
                end
            end
            
            local function start_flight_rendering()
                if cheat_client.feature_connections.flight then return end

                cheat_client.feature_connections.flight = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                    -- No isFlightEnabled check needed - only runs when enabled
                    local isNoclipEnabled = Toggles and Toggles.noclip and Toggles.noclip.Value or false
                    local isAutoFallEnabled = Toggles and Toggles.auto_fall and Toggles.auto_fall.Value or false

                    local character = plr.Character
                if character then
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local camCFrame = workspace.CurrentCamera.CFrame
                        local huma = character:FindFirstChildOfClass("Humanoid")
                        
                        if true then -- flight is already checked at start
                            if isNoclipEnabled then
                                makeNearbyPartsTransparent(plr.Character, rootPart)
                                
                                for i,v in next, plr.Character:GetDescendants() do
                                    if v:IsA("BasePart") then
                                        v.CanCollide = false
                                        
                                        if v ~= rootPart then
                                            v.RotVelocity = Vector3.new(0, 0, 0)
                                        end
                                    end
                                end
                                
                                if not was_noclip_enabled and huma then
                                    huma:SetStateEnabled(5, false)
                                    huma:ChangeState(3)
                                end
                                
                                if rootPart then
                                    local lookVector = camCFrame.LookVector
                                    local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
                                    
                                    if flatLook.Magnitude > 0.01 then
                                        rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + flatLook)
                                    end
                                end
                            elseif was_noclip_enabled then
                                restorePartTransparency()
                                
                                for _, part in ipairs(plr.Character:GetDescendants()) do
                                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                        if part.Name == "Head" or part.Name == "Torso" then
                                            part.CanCollide = true
                                        else
                                            part.CanCollide = false
                                        end
                                    end
                                end
                                
                                if huma then
                                    huma:SetStateEnabled(5, true)
                                    huma:ChangeState(5)
                                end
                            end
                            
                            was_noclip_enabled = isNoclipEnabled
                            
                            if not cheat_client.custom_flight_functions["GetFocusedTextBox"](uis) then
                                local eVector = Vector3.new()
                                local rVector, lVector, uVector = camCFrame.RightVector, camCFrame.LookVector, camCFrame.UpVector
            
                                if cheat_client.custom_flight_functions["IsKeyDown"](uis, "W") then eVector += lVector end
                                if cheat_client.custom_flight_functions["IsKeyDown"](uis, "S") then eVector -= lVector end
                                if cheat_client.custom_flight_functions["IsKeyDown"](uis, "D") then eVector += rVector end
                                if cheat_client.custom_flight_functions["IsKeyDown"](uis, "A") then eVector -= rVector end
                                
                                local isHoldingSpace = cheat_client.custom_flight_functions["IsKeyDown"](uis, "Space")
                                if isHoldingSpace then eVector += uVector end
                                if cheat_client.custom_flight_functions["IsKeyDown"](uis, "LeftShift") then eVector -= uVector end
                                
                                local isInAir = huma and huma.FloorMaterial == Enum.Material.Air
                                local isInWater = huma and (huma:GetState() == Enum.HumanoidStateType.Swimming or huma:GetState() == Enum.HumanoidStateType.PlatformStanding and huma.FloorMaterial == Enum.Material.Water)
                                if isAutoFallEnabled and isInAir and not isHoldingSpace and not isInWater then
                                    eVector -= uVector
                                end

                                local isMovingDown = cheat_client.custom_flight_functions["IsKeyDown"](uis, "LeftShift") or (isAutoFallEnabled and isInAir and not isHoldingSpace and not isInWater)
                                if isNoclipEnabled and not isMovingDown and rootPart.AssemblyLinearVelocity.Y < 0 then
                                    local currentVelocity = rootPart.AssemblyLinearVelocity
                                    rootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
                                end
                                
                                if eVector.Unit.X == eVector.Unit.X then
                                    local flightSpeed = (Options and Options.flight_speed and Options.flight_speed.Value) or 100
                                    rootPart.AssemblyLinearVelocity = eVector.Unit * flightSpeed
                                else
                                    local currentVel = rootPart.AssemblyLinearVelocity
                                    rootPart.AssemblyLinearVelocity = currentVel * 0.85
                                end
                                
                                local shouldAnchor = eVector == Vector3.new() or rootPart.AssemblyLinearVelocity.Magnitude < 1
                                rootPart.Anchored = shouldAnchor
                            end
                        elseif was_noclip_enabled then
                            restorePartTransparency()
                            
                            for _, part in ipairs(plr.Character:GetDescendants()) do
                                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                    if part.Name == "Head" or part.Name == "Torso" then
                                        part.CanCollide = true
                                    else
                                        part.CanCollide = false
                                    end
                                end
                            end
                            
                            if huma then
                                huma:SetStateEnabled(5, true)
                                huma:ChangeState(5)
                            end

                            was_noclip_enabled = false
                        end
                    end
                end
                end))
            end

            local function stop_flight_rendering()
                if cheat_client.feature_connections.flight then
                    -- Cleanup when disabling flight
                    if was_noclip_enabled then
                        cheat_client:restore_state()
                    end

                    if Toggles and Toggles.noclip and Toggles.noclip.Value then
                        Toggles.noclip:SetValue(false)
                    end

                    cheat_client.feature_connections.flight:Disconnect()
                    cheat_client.feature_connections.flight = nil
                end
            end

            -- Hook to flight toggle Callback
            cheat_client.start_flight_rendering = start_flight_rendering
            cheat_client.stop_flight_rendering = stop_flight_rendering
        end

        do -- Init Character
            local anti_status_connections = {}

            local function setup_anti_status(character)
                -- Disconnect old connections
                if anti_status_connections.character_child_added then
                    anti_status_connections.character_child_added:Disconnect()
                end
                if anti_status_connections.boosts_child_added then
                    anti_status_connections.boosts_child_added:Disconnect()
                end

                if not character then return end

                local boosts = character:WaitForChild("Boosts")

                -- Anti Hystericus
                if character:FindFirstChild('Confused') and Toggles and Toggles.AntiHystericus and Toggles.AntiHystericus.Value then
                    character.Confused:Destroy()
                end

                -- Mental Injury
                for _,v in pairs(character:GetChildren()) do
                    if cheat_client.mental_injuries[v.Name] then
                        if Toggles and Toggles.NoInsanity and Toggles.NoInsanity.Value then
                            v:Destroy()
                        end
                    end
                end

                anti_status_connections.character_child_added = utility:Connection(character.ChildAdded, function(obj)
                    -- Anti Hystericus
                    if obj.Name == 'Confused' and Toggles and Toggles.AntiHystericus and Toggles.AntiHystericus.Value then
                        task.defer(obj.Destroy, obj)
                        return
                    end

                    -- Mental Injury
                    if cheat_client.mental_injuries[obj.Name] and Toggles and Toggles.NoInsanity and Toggles.NoInsanity.Value then
                        task.defer(obj.Destroy, obj)
                        return
                    end

                    -- No Stun
                    if cheat_client.stuns[obj.Name] and Toggles and Toggles.NoStun and Toggles.NoStun.Value then
                        task.defer(obj.Destroy, obj)
                        return
                    end
                end)

                anti_status_connections.boosts_child_added = utility:Connection(boosts.ChildAdded, function(obj)
                    if obj.Name == "MusicianBuff" and obj.Value ~= "Symphony of Horses" and obj.Value ~= "Song of Lethargy" then
                        task.defer(obj.Destroy, obj)
                        return
                    end

                    if obj.Name == "SpeedBoost" and Toggles and Toggles.NoStun and Toggles.NoStun.Value  then
                        task.defer(obj.Destroy, obj)
                        return
                    end
                end)
            end

            -- Setup for current character
            if plr.Character then
                setup_anti_status(plr.Character)
            end

            -- Re-setup on respawn
            utility:Connection(plr.CharacterAdded, setup_anti_status)
        end
    
        do -- Init ESP
            do -- Trinket
                for _,object in next, ws:GetChildren() do
                    if object.Name == "Part" and object:FindFirstChild("ID") then
                        local trinket_name, trinket_color, trinket_zindex = cheat_client:identify_trinket(object)
                        cheat_client:add_trinket_esp(object, trinket_name, trinket_color, trinket_zindex)
                    end
                end
            end

            do -- Shrieker ESP
                for _, child in pairs(ws.Live:GetChildren()) do
                    if child:IsA("Model") and string.match(child.Name, ".Shrieker") and child:FindFirstChild("MonsterInfo") then
                        cheat_client:add_shrieker_chams(child)
                    end
                end
            end

            do -- Ingredient
                if game.PlaceId ~= 3541987450 then
                    for index, instance in next, ws:GetChildren() do
                        if ingredient_folder then 
                            break
                        end
            
                        if instance.ClassName == "Folder" then
                            for index, ingredient in next, instance:GetChildren() do
                                if ingredient.ClassName == "UnionOperation" and ingredient:FindFirstChild("ClickDetector") and ingredient:FindFirstChild("Blacklist") then
                                    ingredient_folder = instance
                                    break
                                end
                            end
                        end
                    end
        
                    if ingredient_folder then
                        for _,object in next, ingredient_folder:GetChildren() do
                            local ingredient_name = cheat_client:identify_ingredient(object)
                            cheat_client:add_ingredient_esp(object, ingredient_name)
                        end
                    end
                end
            end
    
            do -- Ore
                if game.PlaceId ~= 14341521240 then
                    for _,object in next, ws.Ores:GetChildren() do
                        cheat_client:add_ore_esp(object)
                    end
                end
            end
        end
    
        do -- Init Bard
            if plr.PlayerGui:FindFirstChild("BardGui") then
                utility:Connection(plr.PlayerGui.BardGui.ChildAdded, function(child)
                    if shared and Toggles and Toggles.auto_bard and Toggles.auto_bard.Value then
                        if child:IsA("ImageButton") and child.Name == "Button" then
                            if Toggles and Toggles.hide_bard and Toggles.hide_bard.Value then
                                plr.PlayerGui.BardGui.Enabled = false
                            else
                                child.Parent.Enabled = true
                            end
                            task.wait(.9 + ((math.random(3, 11) / 100)))
                            firesignal(child.MouseButton1Click)
                        end
                    end
                end)
            end
        end
    
        do -- Init Illu Checker
            for _, player in next, plrs:GetPlayers() do
                if player.Character and player:FindFirstChild("Backpack") then
                    local observe_tool = player.Backpack:FindFirstChild("Observe") or player.Character:FindFirstChild("Observe")
    
                    if observe_tool then 
                        if (library ~= nil and library.Notify) then
                            utility:sound("rbxassetid://2865227039",2)
                            library:Notify({
                                Title = "⚠️ ILLUSIONIST DETECTED",
                                Description = cheat_client:get_name(player).." ["..player.Name.."] is an illusionist",
                                Time = 10
                            })
                        end
                    else
                        local waiting_connection 
                        waiting_connection = utility:Connection(player.Backpack.ChildAdded, function(child)
                            if child.Name == "Observe" then
                                if (library ~= nil and library.Notify) then
                                    utility:sound("rbxassetid://2865227039",2)
                                    library:Notify({
                                        Title = "⚠️ ILLUSIONIST DETECTED",
                                        Description = cheat_client:get_name(player).." ["..player.Name.."] is an illusionist",
                                        Time = 10
                                    })
                                end
                                if waiting_connection and utility then
                                    waiting_connection:Disconnect();
                                    waiting_connection = nil
                                end
                            end
                        end)
                    end
                end
                
                utility:Connection(player.CharacterAdded, function(character)
                    --task.wait(1) -- maybe i should remove ts
                    local observe_tool = player.Backpack:FindFirstChild("Observe") or character:FindFirstChild("Observe")
    
                    if observe_tool then 
                        if (library ~= nil and library.Notify) then
                            utility:sound("rbxassetid://2865227039",2)
                            library:Notify({
                                Title = "⚠️ ILLUSIONIST DETECTED",
                                Description = cheat_client:get_name(player).." ["..player.Name.."] is an illusionist",
                                Time = 10
                            })
                        end
                    else
                        local waiting_connection
                        if utility then
                            waiting_connection = utility:Connection(player.Backpack.ChildAdded, function(child)
                                if waiting_connection then
                                    if child.Name == "Observe" then
                                        if (library ~= nil and library.Notify) then
                                            utility:sound("rbxassetid://2865227039",2)
                                            library:Notify({
                                                Title = "⚠️ ILLUSIONIST DETECTED",
                                                Description = cheat_client:get_name(player).." ["..player.Name.."] is an illusionist",
                                                Time = 10
                                            })
                                        end
                                        
                                        if waiting_connection and utility then
                                            waiting_connection:Disconnect();
                                            waiting_connection = nil
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end)
            end
        end
        
        do -- Init Artifact Checker
            if game.PlaceId ~= 14341521240 then
                local artifact_player_connections = {}
                local lastNotify = {} -- [player][artifact] = tick()
                local DEBOUNCE_TIME = 1.26

                local function canNotify(player, artifact)
                    lastNotify[player] = lastNotify[player] or {}
                    local now = tick()
                    if lastNotify[player][artifact] and (now - lastNotify[player][artifact]) < DEBOUNCE_TIME then
                        return false
                    end
                    lastNotify[player][artifact] = now
                    return true
                end

                local function check_artifacts(player)
                    if library ~= nil and library.Notify then
                        for _,v in pairs(player.Backpack:GetChildren()) do
                            if table.find(cheat_client.artifacts, v.Name) and canNotify(player, v.Name) then
                                library:Notify(
                                    cheat_client:get_name(player).." ["..player.Name.."] has a "..v.Name,
                                    Color3.fromRGB(255,0,179)
                                )
                            end
                        end
                    end
                end

                local function connect_artifact_player(player)
                    if player == plr then return end

                    if artifact_player_connections[player] then
                        for _, conn in pairs(artifact_player_connections[player]) do
                            conn:Disconnect()
                        end
                    end
                    artifact_player_connections[player] = {}

                    if player.Character then
                        check_artifacts(player)
                    end

                    artifact_player_connections[player].backpackAdded = utility:Connection(player.Backpack.ChildAdded, function(child)
                        if table.find(cheat_client.artifacts, child.Name) 
                            and library ~= nil and library.Notify 
                            and canNotify(player, child.Name) then
                            library:Notify(
                                cheat_client:get_name(player).." ["..player.Name.."] has a "..child.Name,
                                Color3.fromRGB(255,0,179)
                            )
                        end
                    end)

                    artifact_player_connections[player].characterAdded = utility:Connection(player.CharacterAdded, function(character)
                        check_artifacts(player)
                    end)
                end

                local function disconnect_artifact_player(player)
                    if artifact_player_connections[player] then
                        for _, conn in pairs(artifact_player_connections[player]) do
                            if conn and conn.Connected then
                                conn:Disconnect()
                            end
                        end
                        artifact_player_connections[player] = nil
                    end
                    lastNotify[player] = nil
                end

                for _,player in pairs(plrs:GetPlayers()) do
                    if player.Character then
                        connect_artifact_player(player)
                    end
                end

                utility:Connection(plrs.PlayerAdded, function(player)
                    if player.Character then
                        connect_artifact_player(player)
                    end
                end)

                utility:Connection(plrs.PlayerRemoving, disconnect_artifact_player)
            end
        end
    
        do -- Mod detection
            for _,player in next, plrs:GetPlayers() do
                task.spawn(cheat_client.detect_mod, cheat_client, player)
                if player.Character then
                    task.spawn(cheat_client.detect_specs, cheat_client, player)
                end

                utility:Connection(player.CharacterAdded, function(character)
                    task.wait(0.5)  -- Wait for backpack to load
                    task.spawn(cheat_client.detect_specs, cheat_client, player)
                end)
            end
        end
    end
    
    -- Connections
    do
        do -- Player ESP Object Management
            cheat_client.player_esp_objects = cheat_client.player_esp_objects or {}

            -- Create ESP for new players if ESP/chams are enabled
            utility:Connection(plrs.PlayerAdded, function(player)
                if player ~= plr then
                    local esp_enabled = Toggles and Toggles.PlayerEsp and Toggles.PlayerEsp.Value
                    local chams_enabled = (Toggles and Toggles.PlayerAimbotChams and Toggles.PlayerAimbotChams.Value) or
                                         (Toggles and Toggles.PlayerFriendlyChams and Toggles.PlayerFriendlyChams.Value) or
                                         (Toggles and Toggles.PlayerLowHealth and Toggles.PlayerLowHealth.Value) or
                                         (Toggles and Toggles.PlayerRacialChams and Toggles.PlayerRacialChams.Value)

                    if esp_enabled or chams_enabled then
                        cheat_client.player_esp_objects[player] = cheat_client:add_player_esp(player)
                    end
                end
            end)

            -- Clean up when players leave
            utility:Connection(plrs.PlayerRemoving, function(player)
                if cheat_client.player_esp_objects[player] then
                    if cheat_client.player_esp_objects[player].destruct then
                        cheat_client.player_esp_objects[player]:destruct()
                    end
                    cheat_client.player_esp_objects[player] = nil
                end
            end)
        end
    
        do -- Trinket ESP
            utility:Connection(ws.ChildAdded, function(object)
                if object.Name == "Part" and object:FindFirstChild("ID") then
                    local trinket_name, trinket_color, trinket_zindex = cheat_client:identify_trinket(object)
                    cheat_client:add_trinket_esp(object, trinket_name, trinket_color, trinket_zindex)
                end
            end)

            -- Fix: Cleanup ESP when trinket is removed to prevent memory leak
            utility:Connection(ws.ChildRemoved, function(object)
                if cheat_client.trinket_esp_objects and cheat_client.trinket_esp_objects[object] then
                    if cheat_client.trinket_esp_objects[object].destruct then
                        cheat_client.trinket_esp_objects[object]:destruct()
                    end
                    cheat_client.trinket_esp_objects[object] = nil
                end
            end)
        end
    
        do -- Ingredient ESP
            if game.PlaceId ~= 3541987450 then
                if ingredient_folder then
                    utility:Connection(ingredient_folder.ChildAdded, function(object)
                        local ingredient_name = cheat_client:identify_ingredient(object)
                        cheat_client:add_ingredient_esp(object, ingredient_name)
                    end)

                    -- Fix: Cleanup ESP when ingredient is removed to prevent memory leak
                    utility:Connection(ingredient_folder.ChildRemoved, function(object)
                        if cheat_client.ingredient_esp_objects and cheat_client.ingredient_esp_objects[object] then
                            if cheat_client.ingredient_esp_objects[object].destruct then
                                cheat_client.ingredient_esp_objects[object]:destruct()
                            end
                            cheat_client.ingredient_esp_objects[object] = nil
                        end
                    end)
                end
            end
        end
    
        do -- Ore ESP
            if game.PlaceId ~= 14341521240 then
                utility:Connection(ws.Ores.ChildAdded, function(object)
                    cheat_client:add_ore_esp(object)
                end)

                -- Fix: Cleanup ESP when ore is removed to prevent memory leak
                utility:Connection(ws.Ores.ChildRemoved, function(object)
                    if cheat_client.ore_esp_objects and cheat_client.ore_esp_objects[object] then
                        if cheat_client.ore_esp_objects[object].destruct then
                            cheat_client.ore_esp_objects[object]:destruct()
                        end
                        cheat_client.ore_esp_objects[object] = nil
                    end
                end)
            end
        end

        do -- Shrieker Chams
            utility:Connection(ws.Live.ChildAdded, function(child)
                if child:IsA("Model") and string.match(child.Name, ".Shrieker") then
                    cheat_client:add_shrieker_chams(child)
                end
            end)
        end

        do -- Character
            local character_debuff_connections = {}

            local function setupCharacterDebuffs(char)
                -- Clean up old connections
                for _, conn in pairs(character_debuff_connections) do
                    conn:Disconnect()
                end
                character_debuff_connections = {}

                local boosts = char:WaitForChild("Boosts")

                character_debuff_connections[#character_debuff_connections + 1] = utility:Connection(char.ChildAdded, function(obj)
                    -- Anti Hystericus
                    if obj.Name == 'Confused' and Toggles and Toggles.AntiHystericus and Toggles.AntiHystericus.Value then
                        task.defer(obj.Destroy, obj)
                        return
                    end

                    -- Mental Injury
                    if cheat_client.mental_injuries[obj.Name] and Toggles and Toggles.NoInsanity and Toggles.NoInsanity.Value then
                        task.defer(obj.Destroy, obj)
                        return
                    end

                    -- No Stun
                    if cheat_client.stuns[obj.Name] and Toggles and Toggles.NoStun and Toggles.NoStun.Value then
                        task.defer(obj.Destroy, obj)
                        return
                    end
                end)

                character_debuff_connections[#character_debuff_connections + 1] = utility:Connection(boosts.ChildAdded, function(obj)
                    if obj.Name == "MusicianBuff" and obj.Value ~= "Symphony of Horses" and obj.Value ~= "Song of Lethargy" then
                        task.defer(obj.Destroy, obj)
                        return
                    end

                    if obj.Name == "SpeedBoost" and Toggles and Toggles.NoStun and Toggles.NoStun.Value  then
                        task.defer(obj.Destroy, obj)
                        return
                    end
                end)
            end

            if plr.Character then
                setupCharacterDebuffs(plr.Character)
            end

            utility:Connection(plr.CharacterAdded, setupCharacterDebuffs)
        end

        do -- Streamer Mode
            utility:Connection(ws.Live.ChildAdded, function(child)
                if child:IsA("Model") and child.Name == plr.Name and shared and Toggles and Toggles.streamer_mode and Toggles.streamer_mode.Value then
                    task.spawn(function()
                        local statGui
                        repeat
                            task.wait(0.025)
                            statGui = plr.PlayerGui:FindFirstChild("StatGui")
                        until statGui and statGui:FindFirstChild("Container") and statGui.Container:FindFirstChild("CharacterName")
                        repeat task.wait(0.05) until statGui.Container.CharacterName:FindFirstChild("Shadow")
                        if game.PlaceId ~= 14341521240 then
                            repeat task.wait(0.025) until plr.Character and plr.Character:FindFirstChild("FakeHumanoid",true)
                        end
                        task.wait(0.025) -- 0.186
                        cheat_client:apply_streamer(true)

                        -- Re-apply day spoof after respawn
                        if cheat_client.config.spoof_days_enabled and cheat_client.config.custom_day_spoof then
                            task.wait(0.1) -- Wait for StatGui to fully load
                            cheat_client:spoof_days(cheat_client.config.custom_day_spoof)
                        end
                    end)
                end
            end)
        end
    
        do -- Bard
            utility:Connection(plr.PlayerGui.ChildAdded, function(child)
                if child.Name == "BardGui" then
                    utility:Connection(child.ChildAdded, function(child)
                        if shared and Toggles and Toggles.auto_bard and Toggles.auto_bard.Value then
                            if child:IsA("ImageButton") and child.Name == "Button" then
                                if Toggles and Toggles.hide_bard and Toggles.hide_bard.Value then
                                    plr.PlayerGui.BardGui.Enabled = false
                                else
                                    child.Parent.Enabled = true
                                end
                                task.wait(.9 + ((math.random(3, 11) / 100)))
                                firesignal(child.MouseButton1Click)
                            end
                        end
                    end)
                end
            end)

            --[[
            local x
            x = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self,key)
                if self == plr and key == "Name" and not checkcaller() and shared and Toggles and Toggles.auto_bard and Toggles.auto_bard.Value and getcallingscript().Parent and getcallingscript().Parent.Name == "BardGui" then
                    return "Melon_Sensei"
                end
                return x(self,key)
            end))
            ]]
        end

        do -- Server/Region Search
            if game.PlaceId == 5208655184 then
                local function createSearchBar()
                    if shared and shared.is_unloading then return end

                    local playerGui = plr:FindFirstChild("PlayerGui")
                    if not playerGui then return end

                    local startMenu = playerGui:FindFirstChild("StartMenu")
                    if not startMenu then return end

                    local publicServers = startMenu:FindFirstChild("PublicServers")
                    if not publicServers then return end

                    local sorts = publicServers:FindFirstChild("Sorts")
                    if not sorts then return end

                    if sorts:FindFirstChild("Search") then return end

                    -- Build JobId -> ServerName lookup table
                    local jobIdToServerName = {}
                    local serverInfo = rps:FindFirstChild("ServerInfo")
                    if serverInfo then
                        for _, jobIdFolder in pairs(serverInfo:GetChildren()) do
                            if jobIdFolder:IsA("Folder") then
                                local jobId = jobIdFolder.Name
                                local serverNameValue = jobIdFolder:FindFirstChild("ServerName")
                                if serverNameValue and serverNameValue:IsA("StringValue") then
                                    jobIdToServerName[jobId:lower()] = serverNameValue.Value
                                end
                            end
                        end
                    end

                    local Search = Instance.new("TextBox")
                    local Border = Instance.new("ImageLabel")

                    Search.Name = "Search"
                    Search.Parent = sorts
                    Search.AnchorPoint = Vector2.new(0, 1)
                    Search.BackgroundColor3 = Color3.fromRGB(226, 226, 226)
                    Search.BorderColor3 = Color3.fromRGB(27, 42, 53)
                    Search.BorderSizePixel = 0
                    Search.Position = UDim2.new(0, 135, 0, 5)
                    Search.Size = UDim2.new(0, 330, 0, 20)  -- Expanded width for JobIds
                    Search.ZIndex = 2
                    Search.ClearTextOnFocus = false
                    Search.Font = Enum.Font.Bodoni
                    Search.PlaceholderColor3 = Color3.fromRGB(22, 22, 22)
                    Search.Text = ""
                    Search.TextColor3 = Color3.fromRGB(27, 25, 23)
                    Search.TextSize = 20.000
                    Search.TextTransparency = 0.100

                    Border.Name = "Border"
                    Border.Parent = Search
                    Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Border.BackgroundTransparency = 1.000
                    Border.BorderColor3 = Color3.fromRGB(27, 42, 53)
                    Border.BorderSizePixel = 0
                    Border.Position = UDim2.new(0, -2, 0, -2)
                    Border.Size = UDim2.new(1, 4, 1, 5)
                    Border.ZIndex = 3
                    Border.Image = "rbxassetid://2739347995"
                    Border.ImageColor3 = Color3.fromRGB(245, 197, 130)
                    Border.ScaleType = Enum.ScaleType.Slice
                    Border.SliceCenter = Rect.new(5, 5, 5, 5)

                    utility:Connection(Search:GetPropertyChangedSignal("Text"), function()
                        if shared and shared.is_unloading then return end

                        -- Trim leading and trailing spaces
                        local text = Search.Text:match("^%s*(.-)%s*$"):lower()
                        local scrollingFrame = publicServers:FindFirstChild("ScrollingFrame")
                        if not scrollingFrame then return end

                        if text == "" then
                            for _, server in pairs(scrollingFrame:GetChildren()) do
                                if server:IsA("Frame") then
                                    local serverName = server:FindFirstChild("ServerName")
                                    local serverRegion = server:FindFirstChild("ServerRegion")
                                    if serverName or serverRegion then
                                        server.Visible = true
                                    end
                                end
                            end
                            return
                        end

                        local targetServerName = jobIdToServerName[text]
                        for _, server in pairs(scrollingFrame:GetChildren()) do
                            if server:IsA("Frame") then
                                local serverNameObj = server:FindFirstChild("ServerName")
                                local serverRegion = server:FindFirstChild("ServerRegion")

                                if serverNameObj and serverRegion then
                                    local matches = false

                                    -- Search by JobId (if found in lookup)
                                    if targetServerName and serverNameObj.Text == targetServerName then
                                        matches = true
                                    elseif server.Name:lower():find(text) then
                                        matches = true
                                    elseif serverRegion.Text:lower():find(text) then
                                        matches = true
                                    else
                                        for jobId, serverName in pairs(jobIdToServerName) do
                                            if jobId:find(text) and serverNameObj.Text == serverName then
                                                matches = true
                                                break
                                            end
                                        end
                                    end

                                    server.Visible = matches
                                end
                            end
                        end
                    end)

                    task.spawn(function()
                        while Search and Search.Parent and shared and not shared.is_unloading do
                            task.wait(1)
                        end
                        if Search and Search.Parent then
                            pcall(function()
                                Search:Destroy()
                            end)
                        end
                    end)
                end

                task.spawn(function()
                    task.wait(1)
                    createSearchBar()
                end)

                utility:Connection(plr.PlayerGui.ChildAdded, function(child)
                    if shared and shared.is_unloading then return end

                    if child.Name == "StartMenu" then
                        task.wait(0.5)
                        createSearchBar()
                    end
                end)
            end
        end

        do -- Invis cam
            local x
            x = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self,key)
                if self == plr and key == "DevCameraOcclusionMode" and not checkcaller() and shared and Toggles and Toggles.invis_cam and Toggles.invis_cam.Value and getcallingscript().Name == "Input" then -- This is from Phrax
                    return Enum.DevCameraOcclusionMode.Zoom
                elseif self == plr and key == 'CameraMaxZoomDistance' and getcallingscript().Name == 'Input' then
                    return 50
                end
                return x(self,key)
            end))
        end

        do -- Leaderboard Color System
            local tool_list = {
                "Demon Step", "Axe Kick", "Demon Flip",
                "Lightning Drop", "Lightning Elbow",
                "Floresco",
                "Command Monsters",
                "The Wraith", "The Shadow", "The Soul", "Elegant Slash", "Needle's Eye", "Acrobat", "RapierTraining",
                "Joyous Dance", "Sweet Soothing", "Song of Lethargy",
                "Shadow Fan", "Ethereal Strike",
                "Grapple", "Resurrection",
                "Wing Soar", "Thunder Spear Crash", "Dragon Awakening",
                "Harpoon", "Skewer", "Hunter's Focus",
                "Deep Sacrifice", "Leviathan Plunge", "Chain Pull", "PrinceBlessing",
                "Charged Blow", "Hyper Body", "White Flame Charge",
                "Darkflame Burst", "Dark Sigil Helmet",
                "Remote Smithing", "Grindstone",
                "Calm Mind", "Swallow Reversal", "Triple Slash", "Blade Flash", "Flowing Counter",
                "Abyssal Scream", "Wrathful Leap",
                "Brandish", "Puncture", "Azure Ignition", "Blade Crash"
            }
            
            local tool_dict = {}
            for _, toolName in ipairs(tool_list) do
                tool_dict[toolName] = true
            end
            
            local function hasListedTools(player)
                if not player then return false end
                
                if player:FindFirstChild("Backpack") then
                    for _, tool in ipairs(player.Backpack:GetChildren()) do
                        if tool_dict[tool.Name] then
                            return true
                        end
                    end
                end
                
                if player.Character then
                    for _, tool in ipairs(player.Character:GetChildren()) do
                        if tool_dict[tool.Name] then
                            return true
                        end
                    end
                end
                
                return false
            end
            
            local function hasObserveTool(player)
                if not player then return false end
                
                if player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Observe") then
                    return true
                end
                
                if player.Character and player.Character:FindFirstChild("Observe") then
                    return true
                end
                
                return false
            end
            
            getPlayerColor = function(player)
                if not player then return Color3.new(1, 1, 1) end
                local hasCharacter = player.Character ~= nil

                if player == plr then
                    return Color3.fromRGB(40, 225, 90)
                end

                local isModerator = false
                local isHidden = player:GetAttribute("Hidden") or false

                if cheat_client and cheat_client.mod_list and table.find(cheat_client.mod_list, player.UserId) then
                    isModerator = true
                end

                if not isModerator then
                    local success, isInGroup = pcall(function()
                        return player:IsInGroup(4556484)
                    end)
                    if success and isInGroup then
                        isModerator = true
                    end
                end

                local function hasJackTool(p)
                    local char = p.Character
                    local backpack = p:FindFirstChildOfClass("Backpack")

                    if char then
                        local jack = char:FindFirstChild("Jack")
                        if jack and jack:IsA("Tool") then
                            return true
                        end
                    end

                    if backpack then
                        local jack = backpack:FindFirstChild("Jack")
                        if jack and jack:IsA("Tool") then
                            return true
                        end
                    end

                    return false
                end

                local hasJack = hasJackTool(player)
                if isModerator or isHidden or hasJack then
                    return hasCharacter and Color3.fromRGB(255, 90, 255) or Color3.fromRGB(200, 70, 200)
                end

                if hasObserveTool(player) then
                    return hasCharacter and Color3.fromRGB(41, 212, 255) or Color3.fromRGB(77, 150, 158)
                end

                if player:GetAttribute("MaxEdict") or (is_khei and player:FindFirstChild("leaderstats")
                    and player.leaderstats:FindFirstChild("MaxEdict")
                    and player.leaderstats.MaxEdict.Value) then
                    return hasCharacter and Color3.fromRGB(255, 214, 81) or Color3.fromRGB(180, 160, 7)
                end

                if hasListedTools(player) then
                    return hasCharacter and Color3.fromRGB(240, 80, 80) or Color3.fromRGB(150, 60, 60)
                end

                return hasCharacter and Color3.new(1, 1, 1) or Color3.fromRGB(120, 120, 120)
            end
            
            updatePlayerLabel = function(player, label)
                if not player or not label or not label:IsA("TextLabel") then return end

                if shared and Toggles and Toggles.better_leaderboard and Toggles.better_leaderboard.Value then
                    local color = getPlayerColor(player)
                    label.TextColor3 = color
                else
                    local hasMaxEdict = player:GetAttribute("MaxEdict") == true
                    local hasLeaderstat = is_khei
                        and player:FindFirstChild("leaderstats")
                        and player.leaderstats:FindFirstChild("MaxEdict")
                        and player.leaderstats.MaxEdict.Value == true

                    label.TextColor3 = (hasMaxEdict or hasLeaderstat)
                        and Color3.fromRGB(255, 214, 81)
                        or Color3.new(1, 1, 1)
                end
            end
            
            local function updateAllLabels()
                if not (shared and playerLabels) then return end

                local snapshot = {}
                for label, player in pairs(playerLabels) do
                    snapshot[label] = player
                end

                for label, player in pairs(snapshot) do
                    if label and label.Parent and label:IsA("TextLabel") and player and plrs:FindFirstChild(player.Name) then
                        local ok = pcall(updatePlayerLabel, player, label)
                        if not ok then
                            playerLabels[label] = nil
                        end
                    else
                        playerLabels[label] = nil
                    end
                end
            end
            
            local player_monitor_connections = {}
            local function updatePlayerLabels(player)
                if playerLabels then
                    for label, p in pairs(playerLabels) do
                        if p == player then
                            updatePlayerLabel(player, label)
                        end
                    end
                end
            end

            local function monitorPlayer(player)
                -- Clean up old connections
                if player_monitor_connections[player] then
                    for _, conn in pairs(player_monitor_connections[player]) do
                        conn:Disconnect()
                    end
                end
                player_monitor_connections[player] = {}

                -- CharacterAdded
                player_monitor_connections[player].characterAdded = utility:Connection(player.CharacterAdded, function(character)
                    task.wait(2)

                    if player_monitor_connections[player] and player_monitor_connections[player].characterChildAdded then
                        player_monitor_connections[player].characterChildAdded:Disconnect()
                    end

                    if character and player_monitor_connections[player] then
                        player_monitor_connections[player].characterChildAdded = utility:Connection(character.ChildAdded, function(child)
                            if child:IsA("Tool") then
                                task.wait(2)
                                updatePlayerLabels(player)
                            end
                        end)
                    end

                    updatePlayerLabels(player)
                end)

                -- CharacterRemoving
                player_monitor_connections[player].characterRemoving = utility:Connection(player.CharacterRemoving, function()
                    task.wait(0.1)
                    updatePlayerLabels(player)
                end)

                -- Backpack.ChildAdded
                if player:FindFirstChild("Backpack") then
                    player_monitor_connections[player].backpackAdded = utility:Connection(player.Backpack.ChildAdded, function()
                        task.wait(1)
                        updatePlayerLabels(player)
                    end)
                end

                if game.PlaceId == 5208655184 then
                    player_monitor_connections[player].maxEdictAttr = utility:Connection(player:GetAttributeChangedSignal("MaxEdict"), function()
                        updatePlayerLabels(player)
                    end)
                end

                if player.Character then
                    player_monitor_connections[player].characterChildAdded = utility:Connection(player.Character.ChildAdded, function(child)
                        if child:IsA("Tool") then
                            task.wait(2)
                            updatePlayerLabels(player)
                        end
                    end)
                end
            end

            local function disconnectPlayerMonitor(player)
                if player_monitor_connections[player] then
                    for _, conn in pairs(player_monitor_connections[player]) do
                        if conn and conn.Connected then
                            conn:Disconnect()
                        end
                    end
                    player_monitor_connections[player] = nil
                end
            end

            for _, player in ipairs(plrs:GetPlayers()) do
                monitorPlayer(player)
            end

            utility:Connection(plrs.PlayerAdded, monitorPlayer)
            utility:Connection(plrs.PlayerRemoving, disconnectPlayerMonitor)

            if not shared.labelsNeedingButtons then
                shared.labelsNeedingButtons = {}
            end

            local processLeaderboardLabel = LPH_NO_VIRTUALIZE(function(label)
                if not label:IsA("TextLabel") then return end

                task.spawn(function()
                    for _, connection in pairs(getconnections(label.MouseEnter)) do
                        if connection.Function then
                            local upvalues = debug.getupvalues(connection.Function)
                            for index, value in pairs(upvalues) do
                                local player = nil

                                -- Gaia: Check for string upvalue (player name)
                                if type(value) == "string" then
                                    local username = value:gsub("\226\128\142", "")
                                    player = plrs:FindFirstChild(username)
                                -- Khei: Check for Player object upvalue
                                elseif typeof(value) == "Instance" and value:IsA("Player") then
                                    player = value
                                end

                                if player then
                                    playerLabels[label] = player
                                    updatePlayerLabel(player, label)
                                    return
                                end
                            end
                        end
                    end
                end)
            end)

            local function initializeLeaderboard()
                if not plr.PlayerGui:FindFirstChild("LeaderboardGui") then
                    return
                end

                local leaderboardFrame = plr.PlayerGui.LeaderboardGui:WaitForChild("MainFrame"):WaitForChild("ScrollingFrame")
                for _, label in ipairs(leaderboardFrame:GetChildren()) do
                    if label:IsA("TextLabel") then
                        processLeaderboardLabel(label)
                    end
                end

                utility:Connection(leaderboardFrame.ChildAdded, function(label)
                    if label:IsA("TextLabel") then
                        task.wait(0.1)
                        processLeaderboardLabel(label)
                    end
                end)

                utility:Connection(leaderboardFrame.ChildRemoved, function(label)
                    if playerLabels[label] then
                        playerLabels[label] = nil
                    end
                end)
            end

            task.spawn(function()
                while shared and not shared.is_unloading and not plr.PlayerGui:FindFirstChild("LeaderboardGui") do
                    task.wait(0.5)
                end

                initializeLeaderboard()
                utility:Connection(plr.PlayerGui.ChildAdded, function(child)
                    if child.Name == "LeaderboardGui" then
                        task.wait(0.5)
                        initializeLeaderboard()
                    end
                end)
            end)

            utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                if #shared.labelsNeedingButtons > 0 then
                    local toProcess = {}
                    for i, item in ipairs(shared.labelsNeedingButtons) do
                        toProcess[i] = item
                    end

                    for i = #shared.labelsNeedingButtons, 1, -1 do
                        shared.labelsNeedingButtons[i] = nil
                    end

                    for _, item in ipairs(toProcess) do
                        local label = item.label
                        local player = item.player

                        if label and label.Parent and player then
                            local oldButton = label:FindFirstChild("SPB")
                            if oldButton then
                                oldButton:Destroy()
                            end

                            if shared.NameRightClick then
                                shared.NameRightClick(player, label)
                            end
                        end
                    end
                end
            end))
            
            local originalNameRightClick = shared.NameRightClick
            if originalNameRightClick then
                shared.NameRightClick = function(Player, Label, ...)
                    local result = originalNameRightClick(Player, Label, ...)
                    if Player and Label then
                        playerLabels[Label] = Player
                        updatePlayerLabel(Player, Label)
                    end
                    return result
                end
            end
            
            task.spawn(function()
                while shared and not shared.is_unloading and playerLabels and task.wait(3) do
                    updateAllLabels()
                end
            end)
        end
    
        do -- Observe
            local THIS_SCRIPT = script
            local Spectating
            
            if shared == nil then
                shared = {}
            end
        
            shared.SPRLS = THIS_SCRIPT
            
            if shared.SPROC == nil then
                shared.SPROC = {}
            end

            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

            if not plr.PlayerGui:FindFirstChild(LPH_ENCSTR("LeaderboardGui")) then
                local newLB = sui:FindFirstChild(LPH_ENCSTR("LeaderboardGui")):Clone()
                newLB.Parent = plr.PlayerGui
                newLB.ResetOnSpawn = true

                local connection
                connection = utility:Connection(plr.CharacterAdded, function()
                    newLB:Destroy()
                    connection:Disconnect()
                    InitSpectator()  -- Re-enabled
                end)
            end

            local startMenu = plr.PlayerGui:FindFirstChild(LPH_ENCSTR("StartMenu"))
            if startMenu then
                local copyright = startMenu:FindFirstChild(LPH_ENCSTR("CopyrightBar"))
                if copyright then
                    copyright:Destroy()
                end
            end

            task.spawn(function()
                local gui = plr:FindFirstChild("PlayerGui")
                while utility and shared and not shared.is_unloading and gui and gui.Parent do
                    local leaderboardGui = gui:FindFirstChild(LPH_ENCSTR("LeaderboardGui"))
                    if leaderboardGui and not leaderboardGui.Enabled then
                        leaderboardGui.Enabled = true
                    end
                    task.wait(0.2)
                end
            end)

            task.spawn(function()
                if utility then
                    local gui = plr:FindFirstChild("PlayerGui")
                    if not plr.Character and gui then
                        local function ensureLeaderboardGui()
                            if not gui:FindFirstChild(LPH_ENCSTR('LeaderboardGui')) then
                                local leaderboardSrc = sui:FindFirstChild(LPH_ENCSTR('LeaderboardGui'))
                                if leaderboardSrc then
                                    local tempGui = leaderboardSrc:Clone()
                                    tempGui.Parent = gui
                                    task.spawn(function()
                                        task.wait()
                                        if InitSpectator then
                                            InitSpectator()
                                        end
                                    end)
                                    return tempGui
                                end
                            end
                            return gui:FindFirstChild(LPH_ENCSTR('LeaderboardGui'))
                        end

                        local tempGui = ensureLeaderboardGui()
                        local removeConnection = utility:Connection(gui.ChildRemoved, function(child)
                            if child.Name == "LeaderboardGui" and not plr.Character then
                                task.wait(0.1)
                                ensureLeaderboardGui()
                            end
                        end)

                        local connection
                        connection = utility:Connection(plr.CharacterAdded, function()
                            if removeConnection then
                                removeConnection:Disconnect()
                            end
                            local leaderboardGui = gui:FindFirstChild(LPH_ENCSTR('LeaderboardGui'))
                            if leaderboardGui then
                                leaderboardGui:Destroy()
                            end
                            connection:Disconnect()
                            if InitSpectator then
                                InitSpectator()
                            end
                        end)
                    end
                end
            end)


            local Find = LPH_NO_VIRTUALIZE(function(Upvalues, Function)
                local Constants = {}
                if typeof(Upvalues) == "function" then
                    Constants = debug.getconstants(Upvalues)
                    Upvalues = debug.getupvalues(Upvalues)
                end

                for i, v in pairs(Upvalues) do
                    local Env = getfenv(Function)
                    Env.Constants = Constants
                    setfenv(Function, Env)
                    local S, E = pcall(Function, v)

                    if S and E then
                        local Env = getfenv(2)
                        Env.Value = v
                        Env.Index = i
                        setfenv(2, Env)
                        return v
                    end
                end

                return false
            end)

            local function InTable(Table, Value)
                for i, v in pairs(Table) do
                    if v == Value then
                        return true
                    end
                end

                return false
            end

            local ClickMenu = Instance.new("ScreenGui")
            local ClickMenuMain = Instance.new("ImageLabel")
            local ClickMenuSubtitle = Instance.new("TextLabel")
            local ClickMenuClass = Instance.new("TextLabel")
            local ClickMenuClassPadding = Instance.new("UIPadding")
            local ClickMenuBlessings = Instance.new("TextLabel")
            local ClickMenuArtifacts = Instance.new("TextLabel")
            local ClickMenuSkills = Instance.new("TextLabel")
            local ClickMenuSpells = Instance.new("TextLabel")
            local ClickMenuHealth = Instance.new("Frame")
            local ClickMenuSlider = Instance.new("Frame")
            local ClickMenuDivider = Instance.new("Frame")
            local ClickMenuNum = Instance.new("TextLabel")
            local ClickMenuHealthPadding = Instance.new("UIPadding")
            local ClickMenuOverlay = Instance.new("ImageLabel")
            local ClickMenuListLayout = Instance.new("UIListLayout")
            local ClickMenuPadding = Instance.new("UIPadding")
            local ClickMenuTags = Instance.new("TextLabel")
            local ClickMenuTitle = Instance.new("TextButton")

            ClickMenu.Name = "ClickMenu"
            ClickMenu.Parent = hidden_folder
            ClickMenu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ClickMenu.Enabled = false

            ClickMenuMain.Name = "MainFrame"
            ClickMenuMain.Parent = ClickMenu
            ClickMenuMain.AnchorPoint = Vector2.new(1, 0)
            ClickMenuMain.BackgroundTransparency = 1.000
            ClickMenuMain.Position = UDim2.new(0.882764041, 0, -0.000833299418, 0)
            ClickMenuMain.Size = UDim2.new(0.149999991, 0, 0, 0)
            ClickMenuMain.Image = "rbxassetid://1327087642"
            ClickMenuMain.ImageTransparency = 0.800
            ClickMenuMain.ScaleType = Enum.ScaleType.Slice
            ClickMenuMain.SliceCenter = Rect.new(20, 20, 190, 190)
            ClickMenuMain.AutomaticSize = Enum.AutomaticSize.Y

            ClickMenuSubtitle.Name = "Subtitle"
            ClickMenuSubtitle.Parent = ClickMenuMain
            ClickMenuSubtitle.BackgroundTransparency = 1.000
            ClickMenuSubtitle.LayoutOrder = 2
            ClickMenuSubtitle.Position = UDim2.new(0, 0, 0.036629919, 0)
            ClickMenuSubtitle.Size = UDim2.new(1, 0, 0, 0)
            ClickMenuSubtitle.Font = Enum.Font.SourceSans
            ClickMenuSubtitle.Text = "Race / Class"
            ClickMenuSubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
            ClickMenuSubtitle.TextSize = 20.000
            ClickMenuSubtitle.TextStrokeTransparency = 0.500
            ClickMenuSubtitle.TextWrapped = true
            ClickMenuSubtitle.AutomaticSize = Enum.AutomaticSize.Y

            ClickMenuClass.Name = "ClassLabel"
            ClickMenuClass.Parent = ClickMenuMain
            ClickMenuClass.BackgroundTransparency = 1.000
            ClickMenuClass.LayoutOrder = 3
            ClickMenuClass.Size = UDim2.new(1, 0, 0, 0)
            ClickMenuClass.Font = Enum.Font.SourceSansBold
            ClickMenuClass.Text = ""
            ClickMenuClass.TextColor3 = Color3.fromRGB(240, 80, 80)
            ClickMenuClass.TextSize = 19.000
            ClickMenuClass.TextStrokeTransparency = 0.500
            ClickMenuClass.TextWrapped = true
            ClickMenuClass.AutomaticSize = Enum.AutomaticSize.Y

            ClickMenuClassPadding.Name = "ClassPadding"
            ClickMenuClassPadding.Parent = ClickMenuClass
            ClickMenuClassPadding.PaddingTop = UDim.new(0, -15)

            ClickMenuBlessings.Name = "BlessingsLabel"
            ClickMenuBlessings.Parent = ClickMenuMain
            ClickMenuBlessings.BackgroundTransparency = 1.000
            ClickMenuBlessings.LayoutOrder = 4
            ClickMenuBlessings.Size = UDim2.new(1, 0, 0, 0)
            ClickMenuBlessings.Font = Enum.Font.SourceSans
            ClickMenuBlessings.Text = "Blessings: None"
            ClickMenuBlessings.TextColor3 = Color3.fromRGB(255, 215, 0)
            ClickMenuBlessings.TextSize = 18.000
            ClickMenuBlessings.TextStrokeTransparency = 0.500
            ClickMenuBlessings.TextWrapped = true
            ClickMenuBlessings.AutomaticSize = Enum.AutomaticSize.Y
            ClickMenuBlessings.Visible = false

            ClickMenuArtifacts.Name = "ArtifactsLabel"
            ClickMenuArtifacts.Parent = ClickMenuMain
            ClickMenuArtifacts.BackgroundTransparency = 1.000
            ClickMenuArtifacts.LayoutOrder = 4.5
            ClickMenuArtifacts.Size = UDim2.new(1, 0, 0, 0)
            ClickMenuArtifacts.Font = Enum.Font.SourceSansBold
            ClickMenuArtifacts.Text = "Artifacts: None"
            ClickMenuArtifacts.TextColor3 = Color3.fromRGB(255, 255, 255)
            ClickMenuArtifacts.TextSize = 18.000
            ClickMenuArtifacts.TextStrokeTransparency = 0.500
            ClickMenuArtifacts.TextWrapped = true
            ClickMenuArtifacts.AutomaticSize = Enum.AutomaticSize.Y
            ClickMenuArtifacts.RichText = true
            ClickMenuArtifacts.Visible = false

            ClickMenuSkills.Name = "SkillsLabel"
            ClickMenuSkills.Parent = ClickMenuMain
            ClickMenuSkills.BackgroundTransparency = 1.000
            ClickMenuSkills.LayoutOrder = 5
            ClickMenuSkills.Size = UDim2.new(1, 0, 0, 0)
            ClickMenuSkills.Font = Enum.Font.SourceSans
            ClickMenuSkills.Text = "Skills: Placeholder skills data"
            ClickMenuSkills.TextColor3 = Color3.fromRGB(255, 255, 255)
            ClickMenuSkills.TextSize = 18.000
            ClickMenuSkills.TextStrokeTransparency = 0.500
            ClickMenuSkills.TextWrapped = true
            ClickMenuSkills.AutomaticSize = Enum.AutomaticSize.Y

            ClickMenuSpells.Name = "SpellsLabel"
            ClickMenuSpells.Parent = ClickMenuMain
            ClickMenuSpells.BackgroundTransparency = 1.000
            ClickMenuSpells.LayoutOrder = 6
            ClickMenuSpells.Size = UDim2.new(1, 0, 0, 0)
            ClickMenuSpells.Font = Enum.Font.SourceSans
            ClickMenuSpells.Text = "Spells: Placeholder spells data"
            ClickMenuSpells.TextColor3 = Color3.fromRGB(255, 255, 255)
            ClickMenuSpells.TextSize = 18.000
            ClickMenuSpells.TextStrokeTransparency = 0.500
            ClickMenuSpells.TextWrapped = true
            ClickMenuSpells.AutomaticSize = Enum.AutomaticSize.Y

            ClickMenuTags.Name = "TagsLabel"
            ClickMenuTags.Parent = ClickMenuMain
            ClickMenuTags.BackgroundTransparency = 1.000
            ClickMenuTags.LayoutOrder = 7
            ClickMenuTags.Position = UDim2.new(0, 0, 0.858957887, 0)
            ClickMenuTags.Size = UDim2.new(1, 0, 0, 0)
            ClickMenuTags.Font = Enum.Font.SourceSans
            ClickMenuTags.Text = "Tags: Placeholder tags data"
            ClickMenuTags.TextColor3 = Color3.fromRGB(255, 255, 255)
            ClickMenuTags.TextSize = 18.000
            ClickMenuTags.TextStrokeTransparency = 0.500
            ClickMenuTags.TextWrapped = true
            ClickMenuTags.AutomaticSize = Enum.AutomaticSize.Y

            ClickMenuHealth.Name = "Health"
            ClickMenuHealth.Parent = ClickMenuMain
            ClickMenuHealth.AnchorPoint = Vector2.new(0.5, 0)
            ClickMenuHealth.BackgroundColor3 = Color3.fromRGB(88, 69, 78)
            ClickMenuHealth.BorderColor3 = Color3.fromRGB(27, 42, 53)
            ClickMenuHealth.BorderSizePixel = 0
            ClickMenuHealth.LayoutOrder = 8
            ClickMenuHealth.Size = UDim2.new(0.867702961, 0, 0, 24)
            ClickMenuHealth.SizeConstraint = Enum.SizeConstraint.RelativeXX
            ClickMenuHealth.ZIndex = 4

            ClickMenuSlider.Name = "Slider"
            ClickMenuSlider.Parent = ClickMenuHealth
            ClickMenuSlider.BackgroundColor3 = Color3.fromRGB(206, 61, 48)
            ClickMenuSlider.BorderColor3 = Color3.fromRGB(27, 42, 53)
            ClickMenuSlider.BorderSizePixel = 0
            ClickMenuSlider.Size = UDim2.new(1.00247765, 0, 1, 0)
            ClickMenuSlider.ZIndex = 4

            ClickMenuDivider.Name = "Divider"
            ClickMenuDivider.Parent = ClickMenuSlider
            ClickMenuDivider.BackgroundColor3 = Color3.fromRGB(97, 25, 25)
            ClickMenuDivider.BorderColor3 = Color3.fromRGB(27, 42, 53)
            ClickMenuDivider.BorderSizePixel = 0
            ClickMenuDivider.Position = UDim2.new(1, 0, 0, 0)
            ClickMenuDivider.Size = UDim2.new(0, 1, 1, 0)
            ClickMenuDivider.ZIndex = 4

            ClickMenuNum.Name = "Num"
            ClickMenuNum.Parent = ClickMenuHealth
            ClickMenuNum.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ClickMenuNum.BackgroundTransparency = 1.000
            ClickMenuNum.BorderColor3 = Color3.fromRGB(27, 42, 53)
            ClickMenuNum.Position = UDim2.new(0.5, 0, 0.5, 0)
            ClickMenuNum.AnchorPoint = Vector2.new(0.5, 0.5)
            ClickMenuNum.Size = UDim2.new(1, 0, 1, 0)
            ClickMenuNum.ZIndex = 4
            ClickMenuNum.Font = Enum.Font.SourceSans
            ClickMenuNum.Text = "100 / 100"
            ClickMenuNum.TextColor3 = Color3.fromRGB(255, 255, 255)
            ClickMenuNum.TextScaled = true
            ClickMenuNum.TextSize = 12.000
            ClickMenuNum.TextStrokeTransparency = 0.000
            ClickMenuNum.TextWrapped = true

            ClickMenuHealthPadding.Parent = ClickMenuHealth
            ClickMenuHealthPadding.PaddingTop = UDim.new(0, 2)

            ClickMenuOverlay.Name = "Overlay"
            ClickMenuOverlay.Parent = ClickMenuHealth
            ClickMenuOverlay.AnchorPoint = Vector2.new(0.5, 0)
            ClickMenuOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ClickMenuOverlay.BackgroundTransparency = 1.000
            ClickMenuOverlay.BorderColor3 = Color3.fromRGB(27, 42, 53)
            ClickMenuOverlay.Position = UDim2.new(0.5, 0, 0, -9)
            ClickMenuOverlay.Size = UDim2.new(1, 16, 1, 19)
            ClickMenuOverlay.ZIndex = 4
            ClickMenuOverlay.Image = "rbxassetid://2560512359"
            ClickMenuOverlay.ImageColor3 = Color3.fromRGB(245, 197, 130)
            ClickMenuOverlay.ScaleType = Enum.ScaleType.Slice
            ClickMenuOverlay.SliceCenter = Rect.new(21, 21, 21, 21)

            ClickMenuListLayout.Name = "ListLayout"
            ClickMenuListLayout.Parent = ClickMenuMain
            ClickMenuListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ClickMenuListLayout.Padding = UDim.new(0, 15)
            ClickMenuListLayout.FillDirection = Enum.FillDirection.Vertical
            ClickMenuListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

            ClickMenuPadding.Name = "Padding"
            ClickMenuPadding.Parent = ClickMenuMain
            ClickMenuPadding.PaddingBottom = UDim.new(0, 35)
            ClickMenuPadding.PaddingLeft = UDim.new(0, 10)
            ClickMenuPadding.PaddingRight = UDim.new(0, 10)
            ClickMenuPadding.PaddingTop = UDim.new(0, 8)

            ClickMenuTitle.Name = "Title"
            ClickMenuTitle.Parent = ClickMenuMain
            ClickMenuTitle.BackgroundTransparency = 1.000
            ClickMenuTitle.LayoutOrder = 1
            ClickMenuTitle.Size = UDim2.new(1, 0, 0, 0)
            ClickMenuTitle.Font = Enum.Font.SourceSansSemibold
            ClickMenuTitle.Text = "PlayerName"
            ClickMenuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ClickMenuTitle.TextSize = 28.000
            ClickMenuTitle.TextStrokeTransparency = 0.500
            ClickMenuTitle.TextWrapped = true
            ClickMenuTitle.AutomaticSize = Enum.AutomaticSize.Y

            local clickMenuSelectedPlayer = nil
            local clickMenuHealthConnection = nil
            local clickMenuTagsPolling = false

            local function isPlayerAlly(player)
                if not player or not cheat_client or not cheat_client.friends then
                    return false
                end

                for _, userId in pairs(cheat_client.friends) do
                    if userId == player.UserId then
                        return true
                    end
                end
                return false
            end

            local function updateTitleColor()
                if not clickMenuSelectedPlayer then
                    ClickMenuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                    return
                end

                if isPlayerAlly(clickMenuSelectedPlayer) then
                    ClickMenuTitle.TextColor3 = Color3.fromRGB(144, 238, 144)
                else
                    ClickMenuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end

            utility:Connection(ClickMenuTitle.MouseButton1Click, function()
                if not clickMenuSelectedPlayer then
                    return
                end

                if cheat_client and cheat_client.friends then
                    local isAlreadyFriend = false
                    local friendIndex = nil

                    for i, userId in pairs(cheat_client.friends) do
                        if userId == clickMenuSelectedPlayer.UserId then
                            isAlreadyFriend = true
                            friendIndex = i
                            break
                        end
                    end

                    if isAlreadyFriend then
                        table.remove(cheat_client.friends, friendIndex)
                    else
                        cheat_client.friends[#cheat_client.friends + 1] = clickMenuSelectedPlayer.UserId
                    end

                    cheat_client:save_friends()
                    updateTitleColor()
                end
            end)

            local function RoundHealth(num)
                if typeof(num) ~= "number" then
                    return 0
                end
                return math.floor(num)
            end

            local function getArtifactRarity(artifactName)
                -- Map artifact names to rarity based on identify_trinket logic
                local mythic_artifacts = {
                    ["Rift Gem"] = true,
                    ["Mysterious Artifact"] = true,
                    ["Azael Horn"] = true,
                    ["Phoenix Flower"] = true,
                }
                local artifact_tier = {
                    ["Amulet of the White King"] = true,
                    ["Lannis's Amulet"] = true,
                    ["Lannis Amulet"] = true,
                    ["Phoenix Down"] = true,
                    ["Night Stone"] = true,
                    ["Howler Friend"] = true,
                    ["Spider Cloak"] = true,
                    ["Philosophers Stone"] = true,
                    ["Fairfrozen"] = true,
                }
                local rare_artifacts = {
                    ["Scroll of Fimbulvetr"] = true,
                    ["Scroll of Percutiens"] = true,
                    ["Scroll of Hoppa"] = true,
                    ["Scroll of Snarvindur"] = true,
                    ["Scroll of Manus Dei"] = true,
                }

                if mythic_artifacts[artifactName] then
                    return cheat_client.trinket_colors.mythic.Color
                elseif artifact_tier[artifactName] then
                    return cheat_client.trinket_colors.artifact.Color
                elseif rare_artifacts[artifactName] then
                    return cheat_client.trinket_colors.rare.Color
                else
                    return cheat_client.trinket_colors.common.Color
                end
            end

            local function updateClickMenuHealth(player)
                if not player or not player.Character then
                    ClickMenuHealth.Visible = false
                    return
                end

                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if not humanoid then
                    ClickMenuHealth.Visible = false
                    return
                end

                ClickMenuHealth.Visible = true
                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                ClickMenuSlider.Size = UDim2.new(healthPercent, 0, 1, 0)
                ClickMenuNum.Text = tostring(RoundHealth(humanoid.Health)) .. " / " .. tostring(RoundHealth(humanoid.MaxHealth))
            end

            local function showClickMenuForPlayer(player)
                if not player then
                    ClickMenu.Enabled = false
                    return
                end

                if clickMenuSelectedPlayer == player and ClickMenu.Enabled then
                    ClickMenu.Enabled = false
                    clickMenuSelectedPlayer = nil
                    clickMenuTagsPolling = false
                    if clickMenuHealthConnection then
                        clickMenuHealthConnection:Disconnect()
                        clickMenuHealthConnection = nil
                    end
                    return
                end

                ClickMenuClass.Text = "";
                ClickMenuSpells.Text = "Spells: None";
                ClickMenuSkills.Text = "Skills: None";
                ClickMenuTags.Text = "Tags: None";

                clickMenuTagsPolling = false
                if clickMenuHealthConnection then
                    clickMenuHealthConnection:Disconnect()
                    clickMenuHealthConnection = nil
                end

                clickMenuSelectedPlayer = player

                pcall(function()
                    local menuReturnGui = plr.PlayerGui:FindFirstChild("MenuReturnGui")
                    if menuReturnGui then
                        local menuButton = menuReturnGui:FindFirstChild("Menu")
                        if menuButton and menuButton:IsA("GuiButton") then
                            -- Position dynamically based on menu button position (30 pixels to the left)
                            local menuPos = menuButton.Position
                            ClickMenuMain.Position = UDim2.new(menuPos.X.Scale, menuPos.X.Offset - 35, -0.000833299418, 0)
                        else
                            ClickMenuMain.Position = UDim2.new(0.882764041, 0, -0.000833299418, 0)
                        end
                    else
                        ClickMenuMain.Position = UDim2.new(0.882764041, 0, -0.000833299418, 0)
                    end
                end)

                if cheat_client and cheat_client.config and cheat_client.config.streamer_mode and player == plr then
                    ClickMenuTitle.Text = "Ragoozer"
                else
                    ClickMenuTitle.Text = player.Name
                end

                updateTitleColor()

                if cheat_client and cheat_client.get_name then
                    local success, name = pcall(function()
                        return cheat_client:get_name(player)
                    end)
                    ClickMenuSubtitle.Text = success and name or "Unknown"
                else
                    ClickMenuSubtitle.Text = "Unknown"
                end

                pcall(function()
                    local classText = ""
                    local playerTools = {}

                    local backpack = player:FindFirstChild("Backpack")
                    if backpack then
                        for _, tool in ipairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") or tool:IsA("Folder") then
                                table.insert(playerTools, tool.Name)
                            end
                        end
                    end

                    if player.Character then
                        for _, tool in ipairs(player.Character:GetChildren()) do
                            if tool:IsA("Tool") then
                                table.insert(playerTools, tool.Name)
                            end
                        end
                    end

                    if cheat_client and cheat_client.class_identifiers then
                        for className, classTools in pairs(cheat_client.class_identifiers) do
                            for _, toolName in ipairs(playerTools) do
                                for _, classToolName in ipairs(classTools) do
                                    if toolName == classToolName then
                                        classText = className
                                        break
                                    end
                                end
                                if classText ~= "" then break end
                            end
                            if classText ~= "" then break end
                        end
                    end

                    if classText == "" then
                        if hasListedTools(player) then
                            classText = "Ultra Class"
                        elseif hasObserveTool(player) then
                            classText = "Observing"
                        else
                            classText = "Freshie"
                        end
                    end

                    ClickMenuClass.Text = classText
                end)

                if game.PlaceId == 3541987450 then
                    pcall(function()
                        if player.Character then
                            local blessings_folder = player.Character:FindFirstChild("Blessings")
                            if blessings_folder then
                                local blessing_names = {}
                                for _, blessing in pairs(blessings_folder:GetChildren()) do
                                    table.insert(blessing_names, blessing.Name)
                                end
                                if #blessing_names > 0 then
                                    ClickMenuBlessings.Text = table.concat(blessing_names, ", ")
                                    ClickMenuBlessings.Visible = true
                                else
                                    ClickMenuBlessings.Visible = false
                                end
                            else
                                ClickMenuBlessings.Visible = false
                            end
                        else
                            ClickMenuBlessings.Visible = false
                        end
                    end)
                else
                    ClickMenuBlessings.Visible = false
                end

                -- Check for artifacts in backpack
                pcall(function()
                    local artifact_counts = {}
                    local backpack = player:FindFirstChild("Backpack")
                    if backpack then
                        for _, item in ipairs(backpack:GetChildren()) do
                            if item:IsA("Tool") and cheat_client and cheat_client.artifacts and table.find(cheat_client.artifacts, item.Name) then
                                artifact_counts[item.Name] = (artifact_counts[item.Name] or 0) + 1
                            end
                        end
                    end

                    local total_artifacts = 0
                    for _, count in pairs(artifact_counts) do
                        total_artifacts = total_artifacts + count
                    end

                    if total_artifacts > 0 then
                        local artifact_text = "Artifacts: "
                        local artifact_parts = {}
                        for name, count in pairs(artifact_counts) do
                            local color = getArtifactRarity(name)
                            local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
                            local colored_name = string.format('<font color="rgb(%d,%d,%d)">%dx %s</font>', r, g, b, count, name)
                            table.insert(artifact_parts, colored_name)
                        end
                        ClickMenuArtifacts.Text = artifact_text .. table.concat(artifact_parts, ", ")
                        ClickMenuArtifacts.Visible = true
                    else
                        ClickMenuArtifacts.Visible = false
                    end
                end)

                updateClickMenuHealth(player)

                local tags = {}
                local spells = {}
                local skills = {}

                if player.Character then
                    local success, playerTags = pcall(function()
                        return game:GetService("CollectionService"):GetTags(player.Character)
                    end)
                    if success and playerTags then
                        tags = playerTags
                    end
                end

                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") then
                            if item:FindFirstChild("Spell") then
                                table.insert(spells, item.Name)
                            end
                            if item:FindFirstChild("Skill") or item:FindFirstChild("SkillSpell") then
                                table.insert(skills, item.Name)
                            end
                        elseif item:IsA("Folder") then
                            if item:FindFirstChild("Skill") then
                                table.insert(skills, item.Name)
                            end
                        end
                    end
                end

                if player.Character then
                    for _, item in ipairs(player.Character:GetChildren()) do
                        if item:IsA("Tool") then
                            if item:FindFirstChild("Spell") then
                                table.insert(spells, item.Name)
                            end
                            if item:FindFirstChild("Skill") or item:FindFirstChild("SkillSpell") then
                                table.insert(skills, item.Name)
                            end
                        end
                    end
                end

                ClickMenuTags.Text = #tags > 0 and "Tags: " .. table.concat(tags, ", ") or "Tags: None"
                ClickMenuSpells.Text = #spells > 0 and "Spells: " .. table.concat(spells, ", ") or "Spells: None"
                ClickMenuSkills.Text = #skills > 0 and "Skills: " .. table.concat(skills, ", ") or "Skills: None"

                if player.Character then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        clickMenuHealthConnection = utility:Connection(humanoid.HealthChanged, function()
                            updateClickMenuHealth(player)
                        end)
                    end
                end

                local tags = {}
                if player.Character then
                    local success, playerTags = pcall(function()
                        return cs:GetTags(player.Character)
                    end)
                    if success and playerTags then
                        tags = playerTags
                    end
                end
                ClickMenuTags.Text = #tags > 0 and "Tags: " .. table.concat(tags, ", ") or "Tags: None"

                ClickMenu.Enabled = true

                clickMenuTagsPolling = true
                task.spawn(function()
                    while clickMenuTagsPolling and clickMenuSelectedPlayer == player and ClickMenu.Enabled do
                        local tags = {}
                        if player.Character then
                            local success, playerTags = pcall(function()
                                return cs:GetTags(player.Character)
                            end)
                            if success and playerTags then
                                tags = playerTags
                            end
                        end
                        ClickMenuTags.Text = #tags > 0 and "Tags: " .. table.concat(tags, ", ") or "Tags: None"
                        task.wait(0.05)
                    end
                end)
            end

            local function NameRightClick(Player, Label)
                if not shared.NameRightClick then
                    shared.NameRightClick = NameRightClick
                end
                if shared == nil or shared.SPRLS ~= THIS_SCRIPT then
                    if script ~= THIS_SCRIPT then
                        return false
                    end
                end

                local Button = Label:FindFirstChild(LPH_ENCSTR("SPB")) or Instance.new(LPH_ENCSTR("TextButton"), Label)
                Button.Name = LPH_ENCSTR("SPB")
                Button.Transparency = 1
                Button.Text = ""
                Button.Size = UDim2.new(1, 0, 1, 0)
                Button.Position = UDim2.new(0, 0, 0, 0)

                utility:Connection(Button.MouseButton2Click, function()
                    if shared == nil or shared.SPRLS ~= THIS_SCRIPT then
                        if script ~= THIS_SCRIPT then
                            return false
                        end
                    end

                    if (Spectating == Player or Player == plr) and plr.Character then
                        Spectating = nil
                        workspace.CurrentCamera.CameraSubject = plr.Character:FindFirstChildOfClass(LPH_ENCSTR("Humanoid"))
                    else
                        if Player.Character and Player.Character:FindFirstChild(LPH_ENCSTR("Humanoid")) then
                            Spectating = Player
                            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

                            local T = Spectating.Character:GetDescendants()
                            
                            if plr.Character then
                                for i, v in pairs(plr.Character:GetDescendants()) do
                                    T[#T + 1] = v
                                end
                            end

                            workspace.CurrentCamera.CameraSubject = Player.Character:FindFirstChildOfClass(LPH_ENCSTR("Humanoid"))
                        end
                    end
                end)

                utility:Connection(Button.MouseButton1Click, function()
                    if shared == nil or shared.SPRLS ~= THIS_SCRIPT then
                        if script ~= THIS_SCRIPT then
                            return false
                        end
                    end

                    showClickMenuForPlayer(Player)
                end)

                return Label
            end

            function InitSpectator()
                pcall(LPH_NO_VIRTUALIZE(function()
                    plr.PlayerGui:WaitForChild("LeaderboardGui"):WaitForChild("LeaderboardClient")
                    wait()
                    
                    for i, v in pairs(getreg()) do
                        if typeof(v) == "function" and islclosure(v) and not (isourclosure and isourclosure(v)) then
                            local ups = debug.getupvalues(v)
                            local scr = getfenv(v).script

                            if Find(ups, function(x)
                                return scr.Name == "LeaderboardClient" and typeof(x) == "function" and
                                    InTable(debug.getconstants(x), "HouseRank")
                            end) then
                                local Labels = {}

                                if Find(Value, function(x)
                                    return typeof(x) == "table" and x[plr]
                                end) then
                                    Labels = Value
                                    for i, v in pairs(Value) do
                                        pcall(NameRightClick, i, v)
                                    end
                                end

                                if shared == nil then
                                    shared = {}
                                end
                                
                                if shared.SPROC == nil then
                                    shared.SPROC = {}
                                end

                                local Index = (shared.SPROC[v] and shared.SPROC[v].Index) or Index
                                local Original = (shared.SPROC[v] and shared.SPROC[v].Function) or debug.getupvalues(v)[Index]
                                
                                if shared.SPROC then
                                    shared.SPROC[v] = {Index = Index, Function = Original}
                                end

                                debug.setupvalue(v, Index, function(Player, ...)
                                    local Label = Original(Player, ...)
                                    local DummyConstant = "HouseRank"
                                    local DummyTable = Labels

                                    if Player and Label and shared.labelsNeedingButtons then
                                        if #shared.labelsNeedingButtons < 100 then
                                            table.insert(shared.labelsNeedingButtons, {label = Label, player = Player})
                                        end
                                    end

                                    return Label
                                end)
                            end
                        end
                    end
                end))
            end

            InitSpectator()

            task.spawn(function()
                while shared and not shared.is_unloading do
                    task.wait(1)
                end
                if player_monitor_connections then
                    for player, connections in pairs(player_monitor_connections) do
                        for _, conn in pairs(connections) do
                            if conn and conn.Connected then
                                conn:Disconnect()
                            end
                        end
                    end
                    table.clear(player_monitor_connections)
                end
            end)
        end
    
        do -- Rendering Handler
            utility:Connection(uis.WindowFocused, function() 
                cheat_client.window_active = true
            end)
        
            utility:Connection(uis.WindowFocusReleased, function() 
                cheat_client.window_active = false
            end)
        end
    
        do -- Notification Updater
            local notification_connection = nil
            local last_check = 0
            local check_interval = 1 -- Check every 1 second if notifications exist when not connected

            local function start_notification_updater()
                if notification_connection then return end

                notification_connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                    if #shared.notifications == 0 then
                        -- Disconnect when no notifications to save performance
                        if notification_connection then
                            notification_connection:Disconnect()
                            notification_connection = nil
                        end
                        return
                    end

                    local count = #shared.notifications
                    local removed_first = false

                    for i = 1, count do
                        local current_tick = tick()
                        local notification = shared.notifications[i]
                        if notification then
                            if current_tick - notification.start_tick > notification.lifetime then
                                task.spawn(notification.destruct, notification)
                                table.remove(shared.notifications, i)
                            elseif count > 35 and not removed_first then -- 10
                                removed_first = true
                                local first = table.remove(shared.notifications, 1)
                                task.spawn(first.destruct, first)
                            else
                                local previous_notification = shared.notifications[i - 1]
                                local basePosition
                                if previous_notification then
                                    basePosition = Vector2.new(16, previous_notification.drawings.main_text.Position.y + previous_notification.drawings.main_text.TextBounds.y + 1)
                                else
                                    basePosition = Vector2.new(16, 40)
                                end

                                notification.drawings.shadow_text.Position = basePosition + Vector2.new(1, 1)
                                notification.drawings.main_text.Position = basePosition
                                notification.drawings.shadow_text.Visible = true
                                notification.drawings.main_text.Visible = true
                            end
                        end
                    end
                end))
            end

            -- Check periodically if notifications were added externally
            utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                local current_time = tick()
                if current_time - last_check >= check_interval then
                    last_check = current_time
                    if shared.notifications and #shared.notifications > 0 and not notification_connection then
                        start_notification_updater()
                    end
                end
            end))

            -- Start immediately if there are already notifications
            if shared.notifications and #shared.notifications > 0 then
                start_notification_updater()
            end
        end
    
        do -- Auto Panic Handler
            local function is_moderator_check(player)
                if cheat_client and cheat_client.mod_list and table.find(cheat_client.mod_list, player.UserId) then
                    return true
                end

                local success, isInGroup = pcall(function()
                    return player:IsInGroup(4556484)
                end)

                if success and isInGroup then
                    return true
                end

                return false
            end

            utility:Connection(plrs.PlayerAdded, function(player)
                if is_moderator_check(player) then
                    if Toggles and Toggles.auto_panic and Toggles.auto_panic.Value and
                       Options and Options.auto_panic_options and Options.auto_panic_options.Value and
                       Options.auto_panic_options.Value["Unload on mod join"] then
                        utility:plain_webhook(string.format("**AUTO PANIC** Unloading because a moderator joined - %s (%s)", player.Name, player.UserId))
                        task.wait(0.05)
                        utility:Unload()
                    end
                end
            end)
        end

        do -- Illusionist Checker
            utility:Connection(plrs.PlayerAdded, function(player)
                if player.Character and player:FindFirstChild("Backpack") then
    
                    local observe_tool = player.Backpack:FindFirstChild("Observe") or player.Character:FindFirstChild("Observe")

                    if observe_tool then
                        if (library ~= nil and library.Notify) then
                            utility:sound("rbxassetid://2865227039",2)
                            library:Notify({
                                Title = "⚠️ ILLUSIONIST DETECTED",
                                Description = cheat_client:get_name(player).." ["..player.Name.."] is an illusionist",
                                Time = 10
                            })
                        end

                        if Toggles and Toggles.auto_panic and Toggles.auto_panic.Value and
                           Options and Options.auto_panic_options and Options.auto_panic_options.Value and
                           Options.auto_panic_options.Value["Unload on Illusionist join"] then
                            utility:plain_webhook(string.format("**AUTO PANIC** Unloading because an Illusionist joined - %s (%s)", player.Name, player.UserId))
                            task.wait(0.05)
                            utility:Unload()
                        end
                    else
                        local waiting_connection
                        waiting_connection = utility:Connection(player.Backpack.ChildAdded, function(child)
                            if child.Name == "Observe" then
                                if (library ~= nil and library.Notify) then
                                    utility:sound("rbxassetid://2865227039",2)
                                    library:Notify({
                                        Title = "⚠️ ILLUSIONIST DETECTED",
                                        Description = cheat_client:get_name(player).." ["..player.Name.."] is an illusionist",
                                        Time = 10
                                    })
                                end

                                if Toggles and Toggles.auto_panic and Toggles.auto_panic.Value and
                                   Options and Options.auto_panic_options and Options.auto_panic_options.Value and
                                   Options.auto_panic_options.Value["Unload on Illusionist join"] then
                                    utility:plain_webhook(string.format("**AUTO PANIC** Unloading because an Illusionist joined - %s (%s)", player.Name, player.UserId))
                                    task.wait(0.05)
                                    utility:Unload()
                                end
                                if waiting_connection and utility then
                                    waiting_connection:Disconnect();
                                    waiting_connection = nil
                                end
                            end
                        end)
                    end
                end
    
                utility:Connection(player.CharacterAdded, function(character)
                    --task.wait(1)
                    local observe_tool = player.Backpack:FindFirstChild("Observe") or character:FindFirstChild("Observe")

                    if observe_tool then
                        if (library ~= nil and library.Notify) then
                            utility:sound("rbxassetid://2865227039",2)
                            library:Notify({
                                Title = "⚠️ ILLUSIONIST DETECTED",
                                Description = cheat_client:get_name(player).." ["..player.Name.."] is an illusionist",
                                Time = 10
                            })
                        end

                        if Toggles and Toggles.auto_panic and Toggles.auto_panic.Value and
                           Options and Options.auto_panic_options and Options.auto_panic_options.Value and
                           Options.auto_panic_options.Value["Unload on Illusionist join"] then
                            utility:plain_webhook(string.format("**AUTO PANIC** Unloading because an Illusionist joined - %s (%s)", player.Name, player.UserId))
                            task.wait(0.05)
                            utility:Unload()
                        end
                    else
                        if utility then
                            local waiting_connection
                            waiting_connection = utility:Connection(player.Backpack.ChildAdded, function(child)
                                if child.Name == "Observe" then
                                    if (library ~= nil and library.Notify) then
                                        utility:sound("rbxassetid://2865227039",2)
                                        library:Notify({
                                            Title = "⚠️ ILLUSIONIST DETECTED",
                                            Description = cheat_client:get_name(player).." ["..player.Name.."] is an illusionist",
                                            Time = 10
                                        })
                                    end

                                    if Toggles and Toggles.auto_panic and Toggles.auto_panic.Value and
                                       Options and Options.auto_panic_options and Options.auto_panic_options.Value and
                                       Options.auto_panic_options.Value["Unload on Illusionist join"] then
                                        utility:plain_webhook(string.format("**AUTO PANIC** Unloading because an Illusionist joined - %s (%s)", player.Name, player.UserId))
                                        task.wait(0.05)
                                        utility:Unload()
                                    end

                                    if waiting_connection and utility then
                                        waiting_connection:Disconnect();
                                        waiting_connection = nil
                                    end
                                end
                            end)
                        end
                    end
                end)
            end)
        end
        
        do -- Combat log checker
            utility:Connection(plrs.PlayerRemoving, function(player)
                if player.Character and cs:HasTag(player.Character,'Danger') then
                    if (library ~= nil and library.Notify) then
                        library:Notify(cheat_client:get_name(player).." ["..player.Name.."] combat logged, what a retard LOL", Color3.fromRGB(5,139,252))
                    end
                end
            end)
        end
        
        do -- Artifact Checker
            if game.PlaceId ~= 14341521240 then
                utility:Connection(plrs.PlayerAdded, function(player)
                    if (library ~= nil and library.Notify) then
                        utility:Connection(player.CharacterAdded, function(character)
                            --task.wait(1)
                            for _,v in pairs(player.Backpack:GetChildren()) do
                                if cheat_client and cheat_client.artifacts and table.find(cheat_client.artifacts, v.Name) then
                                    if (library ~= nil and library.Notify) then
                                        library:Notify(cheat_client:get_name(player).." ["..player.Name.."] has a "..v.Name, Color3.fromRGB(255,0,179))
                                    end
                                end
                            end
                            utility:Connection(player.Backpack.ChildAdded, function(child)
                                if cheat_client and cheat_client.artifacts and table.find(cheat_client.artifacts, child.Name) then
                                    if (library ~= nil and library.Notify) then
                                        library:Notify(cheat_client:get_name(player).." ["..player.Name.."] has a "..child.Name, Color3.fromRGB(255,0,179))
                                    end
                                end
                            end)
                        end)
                    end
                end)
            end
        end

        do -- Mod Detection
            utility:Connection(plrs.PlayerAdded, function(player)
                task.spawn(cheat_client.detect_mod, cheat_client, player)

                if player.Character then
                    task.spawn(cheat_client.detect_specs, cheat_client, player)
                end

                utility:Connection(player.CharacterAdded, function(character)
                    task.wait(0.5)  -- Wait for backpack to load
                    task.spawn(cheat_client.detect_specs, cheat_client, player)
                end)
            end)
        end

        do -- Day Farm
            local function readCSG(union)
                local result = gethiddenproperty(union, "PhysicalConfigData")
                local unionData
                
                if type(result) == "table" and #result >= 2 then
                    unionData = result[2]
                else
                    unionData = select(2, pcall(function() return gethiddenproperty(union, "PhysicalConfigData") end))
                    
                    if type(unionData) ~= "string" then
                        warn("DEBUG - PhysicalConfigData type:", type(result))
                        
                        for _, prop in pairs({"BinaryData", "MeshData", "RawData", "ConfigData"}) do
                            local success, data = pcall(function() return gethiddenproperty(union, prop) end)
                            if success and type(data) == "string" and #data > 100 then
                                warn("Found usable data in property:", prop)
                                unionData = data
                                break
                            end
                        end
                        
                        if type(unionData) ~= "string" then
                            warn("WARNING: Could not get valid CSG data. Captcha bypass may fail.")
                            return {}
                        end
                    end
                end
                
                local unionDataStream = tostring(unionData)
                if type(unionDataStream) ~= "string" then
                    warn("ERROR: Failed to convert union data to string")
                    return {}
                end

                local function readByte(n)
                    if #unionDataStream < n then
                        return ""
                    end
                    local returnData = unionDataStream:sub(1, n)
                    unionDataStream = unionDataStream:sub(n+1, #unionDataStream)
                    return returnData
                end;

                readByte(51); -- useless data

                local points = {};

                while #unionDataStream > 0 do
                    readByte(20) -- trash
                    readByte(20) -- trash 2

                    local vertSize = string.unpack('ii', readByte(8));

                    for i = 1, (vertSize/3) do
                        local x, y, z = string.unpack('fff', readByte(12))
                        points[#points + 1] = union.CFrame:ToWorldSpace(CFrame.new(x, y, z)).Position;
                    end;

                    local faceSize = string.unpack('I', readByte(4));
                    readByte(faceSize * 4);
                end;

                return points;
            end;

            function solveCaptcha(union)
                local worldModel = Instance.new('WorldModel');
                worldModel.Parent = cg;

                local newUnion = union:Clone()
                newUnion.Parent = worldModel;

                local cameraCFrame = gethiddenproperty(union.Parent, "CameraCFrame");
                local points = readCSG(union);

                local rangePart = Instance.new('Part');
                rangePart.Parent = worldModel;
                rangePart.CFrame = cameraCFrame:ToWorldSpace(CFrame.new(-8, 0, 0))
                rangePart.Size = Vector3.new(1, 100, 100);

                local model = Instance.new('Model', worldModel);
                local baseModel = Instance.new('Model', worldModel);

                baseModel.Name = 'Base';
                model.Name = 'Final';

                for i, v in next, points do
                    local part = Instance.new('Part', baseModel);
                    part.CFrame = CFrame.new(v);
                    part.Size = Vector3.new(0.1, 0.1, 0.1);
                end;

                local seen = false;
                for i = 0, 100 do
                    rangePart.CFrame = rangePart.CFrame * CFrame.new(1, 0, 0)

                    local overlapParams = OverlapParams.new();
                    overlapParams.FilterType = Enum.RaycastFilterType.Whitelist;
                    overlapParams.FilterDescendantsInstances = {baseModel};

                    local bob = worldModel:GetPartsInPart(rangePart, overlapParams);
                    if(seen and #bob <= 0) then break end;

                    for i, v in next, bob do
                        seen = true;

                        local new = v:Clone();

                        new.Parent = model;
                        new.CFrame = CFrame.new(new.Position);
                    end;
                end;

                for i, v in next, model:GetChildren() do
                    v.CFrame = v.CFrame * CFrame.Angles(0, math.rad(union.Orientation.Y), 0);
                end;

                local shorter, found = math.huge, '';
                local result = model:GetExtentsSize();

                local values = {
                    ['Arocknid'] = Vector3.new(11.963972091675, 6.2284870147705, 12.341609954834),
                    ['Howler'] = Vector3.new(2.904595375061, 7.5143890380859, 6.4855442047119),
                    ['Evil Eye'] = Vector3.new(6.7253036499023, 6.2872190475464, 11.757738113403),
                    ['Zombie Scroom'] = Vector3.new(4.71413230896, 4.400146484375, 4.7931442260742),
                    ['Golem'] = Vector3.new(17.123439788818, 21.224365234375, 6.9429664611816),
                };

                for i, v in next, values do
                    if((result - v).Magnitude < shorter) then
                        found = i;
                        shorter = (result - v).Magnitude;
                    end;
                end;

                worldModel:Destroy();
                worldModel = nil;

                return found;
            end

            local time_elapsed = 0
            local playerDays = 0

            local function no_kick()
                if Toggles and Toggles.no_kick and Toggles.no_kick.Value then
                    return true
                end
                return false
            end
            
            local function kickPlayer(message)
                if cs:HasTag(plr.Character, "Danger") then
                    repeat task.wait() until not cs:HasTag(plr.Character, "Danger")
                end

                --print("[DEBUG] Kicking player: " .. message)
                utility:plain_webhook(message)
                rps.Requests.ReturnToMenu:InvokeServer()
                plr:Kick(message)
                utility:Unload()
            end

            local function Get(value)
                local success, result = pcall(function()
                    return rps.Requests.Get:InvokeServer(utf8.char(65532) .. "\240\159\152\131", value)[value]
                end)
                return success and result or nil
            end

            local function check_silver()
                local silver = Get("Silver")

                if not silver then
                    return true
                end

                local has_enough = silver >= 250

                -- If no_kick enabled and not enough silver, webhook with ping
                if not has_enough and no_kick() then
                    utility:plain_webhook(string.format("@here %s (%s) tried gacha without enough silver (250 needed, has %d)", plr.Name, plr.UserId, silver))
                    return true -- Don't kick, return true to prevent kick
                end

                return has_enough
            end

            local function gacha()
                if not (Toggles and Toggles.day_farm and Toggles.day_farm.Value) and plr.Name ~= "Tharxifen" then return false end
                if not plr.Character then return end

                local npc = workspace.NPCs:FindFirstChild("Xenyari")
                local npcHead = npc:FindFirstChild("Head")
                local clickDetector = npc:FindFirstChildWhichIsA("ClickDetector")
                
                if not workspace.NPCs or not workspace.NPCs:FindFirstChild("Xenyari") or 
                not workspace.NPCs.Xenyari:FindFirstChild("Head") or
                not workspace.NPCs.Xenyari:FindFirstChildWhichIsA("ClickDetector") then
                    return false
                end

                local distanceFromNPC = plr:DistanceFromCharacter(npcHead.Position)
                if distanceFromNPC > 20 then
                    return false
                end

                if not check_silver() then
                    kickPlayer(string.format("%s (%s) tried gacha without enough silver (250 needed)", plr.Name, plr.UserId))
                    return false
                end
                
                if not playerDays then
                    playerDays = utility:getPlayerDays() or 0
                    if not playerDays then
                        repeat
                            playerDays = utility:getPlayerDays()
                            task.wait(0.1)
                        until playerDays
                    end
                end
                
                if dialogue_remote then
                    local dialogConnection
                    dialogConnection = utility:Connection(dialogue_remote.OnClientEvent, function(dialogData)
                        task.wait(1)
                        
                        if not dialogData.choices then
                            dialogue_remote:FireServer({exit = true})
                            task.wait(1)
                            dialogConnection:Disconnect()
                        else
                            dialogue_remote:FireServer({choice = dialogData.choices[1]})
                        end
                    end)
                end

                repeat
                    fireclickdetector(clickDetector)
                task.wait(0.25);
                until plr.PlayerGui:FindFirstChild('CaptchaLoad') or plr.PlayerGui:FindFirstChild('Captcha');
                
                repeat task.wait(0.05) until plr.PlayerGui:FindFirstChild('Captcha');
                repeat
                    local captchaGUI = plr.PlayerGui:FindFirstChild('Captcha');
                    local choices = captchaGUI and captchaGUI.MainFrame.Options:GetChildren();
                    local union = captchaGUI and captchaGUI.MainFrame.Viewport.Union;

                    utility:random_wait(true);

                    if(choices and union) then
                        local captchaAnswer = solveCaptcha(union);

                        for i, v in next, choices do
                            if(v.Name == captchaAnswer) then
                                local objVector = v.AbsolutePosition;
                                vim:SendMouseButtonEvent(objVector.X + 65, objVector.Y + 65, 0, true, game, 0);
                                utility:random_wait(true);
                                vim:SendMouseButtonEvent(objVector.X + 65, objVector.Y + 65, 0, false, game, 0);
                                break
                            end
                        end
                    end

                    task.wait(1);
                until not plr.PlayerGui:FindFirstChild('Captcha');
                
                return true
            end

            local function day_goal()
                local day_goal_value = (Options and Options.day_goal and Options.day_goal.Value) or "1"
                local day_goal = tonumber(day_goal_value) or 1

                if playerDays >= day_goal then
                    if Toggles and Toggles.day_goal_kick and Toggles.day_goal_kick.Value then
                        if no_kick() then
                            utility:plain_webhook(string.format("@here %s (%s) reached day goal: %d (no_kick enabled, not kicking)", plr.Name, plr.UserId, playerDays))
                        else
                            kickPlayer(string.format("%s (%s) reached day goal: %d", plr.Name, plr.UserId, playerDays))
                        end
                    end
                    return true
                end
                return false
            end

            utility:Connection(rps.Requests.DaysSurvivedChanged.OnClientEvent, function(days)
                if not (Toggles and Toggles.day_farm and Toggles.day_farm.Value) then return end
                
                playerDays = days
                utility:plain_webhook(plr.Name .. " is now at " .. playerDays .. " days")

                if day_goal() then
                    return
                end
                
                if gacha() then
                    warn("Successfully interacted with Xenyari!")
                else
                    warn("Not near Xenyari, continuing with normal day farm")
                end
            end)
        end
    
        do -- Inventory Value
            local function get_inventory_value() -- This is from Underware
                local inventory_value = 0

                if not plr.Backpack then return 0 end
                local backpack_children = plr.Backpack:GetChildren()

                for index = 1, #backpack_children do
                    local backpack_child = backpack_children[index]
                    local silver_value = backpack_child:FindFirstChild("SilverValue")

                    if silver_value then
                        inventory_value = inventory_value + silver_value.Value
                    end
                end
                
                return inventory_value
            end 
    
            local time_elapsed = 0
            utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(delta_time)
                time_elapsed += delta_time
                if time_elapsed >= 1 then
                    time_elapsed = 0
                    if Labels and Labels.InventoryValue then
                        Labels.InventoryValue:SetText("Inventory Value: " .. get_inventory_value())
                    end
                end
            end))
        end

        do -- Last Looted
            if game.PlaceId == 5208655184 then
                local function last_looted(where)
                    if where == "cr" then
                        return math.floor((os.time() - workspace:WaitForChild("MonsterSpawns"):WaitForChild("Triggers"):WaitForChild("CastleRockSnake"):WaitForChild("LastSpawned").Value) / 60).."m" -- CastleRockSnake
                    elseif where == "deepsunken" then
                            return math.floor((os.time() - workspace:WaitForChild("MonsterSpawns"):WaitForChild("Triggers"):WaitForChild("evileye2"):WaitForChild("LastSpawned").Value) / 60).."m"
                    elseif where == "crypt" then
                        return math.floor((os.time() - workspace:WaitForChild("MonsterSpawns"):WaitForChild("Triggers"):WaitForChild("CryptTrigger"):WaitForChild("LastSpawned").Value) / 60).."m"
                    elseif where == "temple" then
                        return math.floor((os.time() - workspace:WaitForChild("MonsterSpawns"):WaitForChild("Triggers"):WaitForChild("MazeSnakes"):WaitForChild("LastSpawned").Value) / 60).."m"
                    end
                end

                local time_elapsed_cr = 0
                utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(delta_time)
                    time_elapsed_cr += delta_time
                    if time_elapsed_cr >= 1 then
                        time_elapsed_cr = 0
                        if Labels and Labels.CrLastLooted then
                            Labels.CrLastLooted:SetText("Castle Rock: " .. last_looted("cr"))
                        end
                        if Labels and Labels.TempleLastLooted then
                            Labels.TempleLastLooted:SetText("Temple of Fire: " .. last_looted("temple"))
                        end
                        if Labels and Labels.DeepLastLooted then
                            Labels.DeepLastLooted:SetText("Deep Sunken: " .. last_looted("deepsunken"))
                        end
                        if Labels and Labels.CryptLastLooted then
                            Labels.CryptLastLooted:SetText("Crypt of Kings: " .. last_looted("crypt"))
                        end
                    end
                end))
            elseif game.PlaceId == 3541987450 then
                local time_elapsed_blessings = 0
                utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(delta_time)
                    time_elapsed_blessings += delta_time
                    if time_elapsed_blessings >= 1 then
                        time_elapsed_blessings = 0
                        if Labels and Labels.PlayerBlessings and plr.Character then
                            local blessings_folder = plr.Character:FindFirstChild("Blessings")
                            if blessings_folder then
                                local blessing_names = {}
                                for _, blessing in pairs(blessings_folder:GetChildren()) do
                                    table.insert(blessing_names, blessing.Name)
                                end
                                if #blessing_names > 0 then
                                    Labels.PlayerBlessings:SetText("Blessings:\n" .. table.concat(blessing_names, "\n"))
                                else
                                    Labels.PlayerBlessings:SetText("Blessings: None")
                                end
                            else
                                Labels.PlayerBlessings:SetText("Blessings: None")
                            end
                        end
                    end
                end))
            end
        end
    
        do -- Server size check
            local function update_count()
                if Labels and Labels.PlrsServer then
                    Labels.PlrsServer:SetText("Players: " .. #plrs:GetPlayers())
                end
            end

            task.spawn(function()
                while shared and not shared.is_unloading and cheat_client do
                    update_count()
                    task.wait(1)
                end
            end)

            utility:Connection(plrs.PlayerAdded, update_count)
            utility:Connection(plrs.PlayerRemoving, update_count)
        end
        
        do -- Fullbright
            local is_updating_ambient = false
            utility:Connection(lit:GetPropertyChangedSignal("Ambient"), function()
                if is_updating_ambient then return end
                is_updating_ambient = true

                if Toggles and Toggles.fullbright and Toggles.fullbright.Value then
                    local brightness_multiplier = (cheat_client.config.brightness_level or 80) / 100
                    local color = Color3.new(brightness_multiplier, brightness_multiplier, brightness_multiplier)
                    lit.Ambient = color
                    lit.OutdoorAmbient = color
                else
                    cheat_client:restore_ambience()
                end

                task.defer(function() is_updating_ambient = false end)
            end)

            local is_updating_brightness = false
            utility:Connection(lit:GetPropertyChangedSignal("Brightness"), function()
                if is_updating_brightness then return end
                is_updating_brightness = true

                if Toggles and Toggles.fullbright and Toggles.fullbright.Value then
                    local brightness_multiplier = (cheat_client.config.brightness_level or 80) / 100
                    local target_brightness = 1 + (brightness_multiplier * 2) -- Range: 1-3

                    if lit.Brightness ~= target_brightness then
                        lit.Brightness = target_brightness
                    end
                end

                task.defer(function() is_updating_brightness = false end)
            end)

            local is_updating_fog = false
            utility:Connection(lit:GetPropertyChangedSignal("FogEnd"), function()
                if is_updating_fog then return end
                is_updating_fog = true

                if Toggles and Toggles.no_fog and Toggles.no_fog.Value then
                    lit.FogColor = Color3.fromRGB(254, 254, 254)
                    lit.FogEnd = 100000
                    lit.FogStart = 50
                else
                    cheat_client:restore_ambience()
                end

                task.defer(function() is_updating_fog = false end)
            end)

            local is_updating_fog_start = false
            utility:Connection(lit:GetPropertyChangedSignal("FogStart"), function()
                if is_updating_fog_start then return end
                is_updating_fog_start = true

                if Toggles and Toggles.no_fog and Toggles.no_fog.Value then
                    if lit.FogStart ~= 50 then
                        lit.FogStart = 50
                    end
                else
                    cheat_client:restore_ambience()
                end

                task.defer(function() is_updating_fog_start = false end)
            end)

            local is_updating_fog_color = false
            utility:Connection(lit:GetPropertyChangedSignal("FogColor"), function()
                if is_updating_fog_color then return end
                is_updating_fog_color = true

                if Toggles and Toggles.no_fog and Toggles.no_fog.Value then
                    local target_color = Color3.fromRGB(254, 254, 254)
                    if lit.FogColor ~= target_color then
                        lit.FogColor = target_color
                    end
                else
                    cheat_client:restore_ambience()
                end

                task.defer(function() is_updating_fog_color = false end)
            end)
        end
    
        do -- Clock Time
            utility:Connection(lit:GetPropertyChangedSignal("ClockTime"), function()
                if Toggles and Toggles.change_time and Toggles.change_time.Value then
                    local target_time = (Options and Options.clock_time and Options.clock_time.Value) or 12
                    if lit.ClockTime ~= target_time then
                        lit.ClockTime = target_time
                    end
                end
            end)
        end


        do -- Instant Mine
            local can_mine = true
            utility:Connection(uis.InputBegan, function(input, chatcheck)
                if chatcheck then return end
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                if not (shared and Toggles and Toggles.instant_mine and Toggles.instant_mine.Value) then return end
                if not (plr.Character and plr.Character:FindFirstChild("Pickaxe")) then return end
                if not can_mine then return end

                can_mine = false
                plr.Character.Humanoid:UnequipTools()
                for _,v in pairs(plr.Backpack:GetChildren()) do
                     if v.Name == "Pickaxe" then
                        plr.Character.Humanoid:EquipTool(v)
                        for i = 1, 8 do
                            v:Activate();
                            plr.Character.Humanoid:UnequipTools()
                        end
                        plr.Character.Humanoid:EquipTool(v)
                    end
                end

                task.wait(0.05)
                can_mine = true
            end)
        end


        do -- Better Mana
            local key_code_g = Enum.KeyCode.G

            local function getPing()
                local success, ping = pcall(function()
                    return game:GetService('Stats'):WaitForChild('PerformanceStats'):WaitForChild('Ping'):GetValue()
                end)
                return success and ping or 0
            end

            utility:Connection(uis.InputBegan, function(input, chatcheck)
                if chatcheck then return end
                if input.KeyCode ~= key_code_g then return end
                if not plr.Character then return end
                if not (shared and Toggles and Toggles.better_mana and Toggles.better_mana.Value) then return end
                if not mana_remote then return end

                task.spawn(function()
                    if not mana_remote or not utility then return end

                    utility:charge_mana()
                    task.wait(0.1 + ((utility and getPing() or 0) / 900))

                    repeat
                        task.wait()
                        if not utility or not mana_remote then return end
                        local character = plr.Character
                        if character and not character:FindFirstChild("Charge") then
                            utility:charge_mana()
                            task.wait(0.1 + ((utility and getPing() or 0) / 900))
                        end
                    until not uis:IsKeyDown(key_code_g)

                    if utility and mana_remote then
                        utility:decharge_mana()
                    end
                end)
            end)
        end

        do -- Auto Dialogue
            local AUTO_DIALOGUE_SPEAKERS = {
                ["Doctor"] = true,
                ["Engineer"] = true,
                ["Miner John"] = true,
                ["Mysterious Stranger"] = true,
                ["Gary"] = true,
                ["Yeti"] = true,
                ["Inn Keeper"] = true,
                ["Fallion"] = true,
                --["Willow"] = true, = ...
                --["Xenyari"] = true,
                --["The Eagle"] = true
            }
            
            local dialogConnection
            local function auto_dialogue_handler(dialogData)
                if not (Toggles and Toggles.auto_dialogue and Toggles.auto_dialogue.Value) then
                    return
                end
                
                if not plr.Character or not plr.Character:FindFirstChild("InDialogue") then
                    return
                end
                
                local speaker = dialogData.speaker
                local msg = dialogData.msg

                if msg and msg == "_The Obelisk radiates a great power._" then
                elseif not speaker or speaker == "" or speaker:match("^%s*$") then
                    return
                elseif speaker == "..." then -- willow
                    local choices = dialogData.choices
                    if msg and msg:find("drop back to your inn") and choices and choices[1] == "Take me away." then
                        -- yes
                    else
                        return
                    end
                elseif not AUTO_DIALOGUE_SPEAKERS[speaker] then
                    return
                end
                
                task.wait(0.1)
                
                if not dialogData.choices or #dialogData.choices == 0 then
                    if dialogue_remote then
                        dialogue_remote:FireServer({exit = true})
                    end
                else
                    if dialogue_remote then
                        dialogue_remote:FireServer({choice = dialogData.choices[1]})
                    end
                end
            end
            
            local function setupAutoDialogue()
                if not dialogue_remote then
                    return
                end
                
                if dialogConnection then
                    return
                end
                
                dialogConnection = utility:Connection(dialogue_remote.OnClientEvent, auto_dialogue_handler)
            end
            
            shared.setupAutoDialogue = setupAutoDialogue
            shared.auto_dialogue_handler = auto_dialogue_handler
        end

        do -- Auto Weapon
            local thrown_folder = ws:WaitForChild("Thrown")

            utility:Connection(thrown_folder.ChildAdded, function(weapon)
                task.wait(1)
                local pickup = weapon:FindFirstChild("ClickDetector")

                if weapon:FindFirstChild("Prop") and pickup then
                    local main_part = weapon:IsA("Model") and weapon:FindFirstChildWhichIsA("BasePart") or weapon
                    local activation_distance = pickup.MaxActivationDistance - 2

                    task.spawn(function()
                        while
                            (not shared)
                            or (not Toggles)
                            or (not Toggles.auto_weapon)
                            or (not Toggles.auto_weapon.Value)
                            or (not plr.Character)
                            or (not plr.Character:FindFirstChild("Head"))
                            or (plr:DistanceFromCharacter(main_part.Position) > activation_distance)
                        do
                            task.wait(0.1)
                        end

                        repeat
                            local character = plr.Character
                            if
                                character
                                and character:FindFirstChild("Head")
                                and plr:DistanceFromCharacter(main_part.Position) <= activation_distance
                            then
                                fireclickdetector(pickup)
                            end

                            task.wait(0.1)
                        until not weapon or not weapon:IsDescendantOf(thrown_folder)
                    end)
                end
            end)
        end


        do -- Anti Globus
            local thrown_folder = ws:WaitForChild("Thrown")
            utility:Connection(thrown_folder.ChildAdded, function(child)
                if not shared or not (Toggles and Toggles.AntiGlobus and Toggles.AntiGlobus.Value) then return end

                if child.Name == 'OrderBubble' then
                    task.defer(function()
                        child.CanTouch = false
                    end)
                end
            end)
        end

        do -- Trinket Autopickup
            local trinkets = {}
            
            for _,object in next, ws:GetChildren() do
                if object.Name == "Part" and object:FindFirstChild("ID") then
                    trinkets[#trinkets + 1] = object
                end
            end
    
            utility:Connection(ws.ChildAdded, function(object)
                if object.Name == "Part" and object:FindFirstChild("ID") then
                    trinkets[#trinkets + 1] = object

                    -- Artifact notifier
                    local trinket_name, trinket_color, trinket_zindex = cheat_client:identify_trinket(object)
                    if trinket_color == cheat_client.trinket_colors.artifact.Color or trinket_color == cheat_client.trinket_colors.mythic.Color then
                        local function detectArtifactArea()
                            if not ws:FindFirstChild("AreaMarkers") then return "None" end

                            local LocationName = "None"
                            local LocationNumSq = math.huge
                            local Area = ws.AreaMarkers
                            local artifactPos = object.Position

                            for i,v in pairs(Area:GetChildren()) do
                                local diff = artifactPos - v.Position
                                local distSq = diff.X * diff.X + diff.Y * diff.Y + diff.Z * diff.Z
                                if distSq < LocationNumSq then
                                    LocationName = v.Name
                                    LocationNumSq = distSq
                                end
                            end

                            return LocationName
                        end

                        local area = detectArtifactArea()
                        local area_text = area ~= "None" and " ("..area..")" or ""
                        local msg = string.format("✨ Artifact Spawned: %s%s", trinket_name, area_text)
                        library:Notify(msg, 10)

                        -- Enhanced webhook with player, jobid, and server info
                        local server_name, server_region = get_server_info()
                        local webhook_msg = string.format(
                            "```ini\n[+] ARTIFACT SPAWNED\n```\n**Trinket:** `%s`\n**Location:** `%s`\n**Player:** `%s`\n**JobId:** `%s`\n**Server:** `%s (%s)`\n@here",
                            trinket_name,
                            area ~= "None" and area or "Unknown",
                            plr.Name,
                            game.JobId,
                            server_name ~= "" and server_name or "Unknown",
                            server_region ~= "" and server_region or "Unknown"
                        )
                        utility:plain_webhook(webhook_msg)
                        utility:sound("rbxassetid://6432593850", 2)
                    end
                end
            end)

            local function start_auto_trinket_rendering()
                if cheat_client.feature_connections.auto_trinket then return end

                cheat_client.feature_connections.auto_trinket = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(delta_time)
                    if not plr.Character then return end

                    for i = #trinkets, 1, -1 do
                        if not trinkets[i] or not trinkets[i].Parent then
                            table.remove(trinkets, i)
                        end
                    end

                    for _, object in next, trinkets do
                        local trinket_name = cheat_client:identify_trinket(object)
                        if trinket_name == "Azael Horn" then
                            continue
                        end

                        local click_detector = object:FindFirstChild("ClickDetector", true)
                        local distance = plr:DistanceFromCharacter(object.CFrame.Position)
                        local dist = 9e9

                        if click_detector then
                            dist = click_detector.MaxActivationDistance -- - 2
                        end

                        if click_detector and distance > 0 and distance < dist then
                            fireclickdetector(click_detector)
                        end
                    end
                end))
            end

            local function stop_auto_trinket_rendering()
                if cheat_client.feature_connections.auto_trinket then
                    cheat_client.feature_connections.auto_trinket:Disconnect()
                    cheat_client.feature_connections.auto_trinket = nil
                end
            end

            cheat_client.start_auto_trinket_rendering = start_auto_trinket_rendering
            cheat_client.stop_auto_trinket_rendering = stop_auto_trinket_rendering

            -- Start if enabled by default/autoload
            if Toggles and Toggles.auto_trinket and Toggles.auto_trinket.Value then
                start_auto_trinket_rendering()
            end
        end

        do -- Ingredient Autopickup
            if game.PlaceId ~= 3541987450 then
                if ingredient_folder then
                    local ingredients = {}
                    local last_check_time = 0
                    local check_interval = 0.2
                    local active_ingredients = {}
                    local player_position = nil
                    local max_distance = 0
                    
                    local function update_active_ingredients()
                        if not plr.Character then return end
                        player_position = plr.Character.HumanoidRootPart.Position
                        active_ingredients = {}
                        
                        for _, object in next, ingredients do
                            if object and object.Parent then
                                local click_detector = object:FindFirstChild("ClickDetector")
                                if click_detector then
                                    max_distance = click_detector.MaxActivationDistance - 2
                                    local distance = (object.Position - player_position).Magnitude
                                    
                                    if distance > 0 and distance < max_distance then
                                        active_ingredients[#active_ingredients + 1] = {
                                            object = object,
                                            detector = click_detector
                                        }
                                    end
                                end
                            end
                        end
                    end
        
                    for _, object in next, ingredient_folder:GetChildren() do
                        if not cheat_client.blacklisted_ingredients[object.Position] then
                            ingredients[#ingredients + 1] = object
                        end
                    end
                    
                    utility:Connection(ingredient_folder.ChildAdded, function(object)
                        if not cheat_client.blacklisted_ingredients[object.Position] then
                            ingredients[#ingredients + 1] = object
                            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and cheat_client.feature_connections.auto_ingredient then
                                local click_detector = object:FindFirstChild("ClickDetector")
                                if click_detector then
                                    local distance = (object.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                                    if distance > 0 and distance < click_detector.MaxActivationDistance - 2 then
                                        active_ingredients[#active_ingredients + 1] = {
                                            object = object,
                                            detector = click_detector
                                        }
                                    end
                                end
                            end
                        end
                    end)
                    
                    utility:Connection(ingredient_folder.ChildRemoved, function(object)
                        for i, ingredient in ipairs(ingredients) do
                            if ingredient == object then
                                table.remove(ingredients, i)
                                break
                            end
                        end
                    end)
                    
                    local last_position = nil

                    local function start_auto_ingredient_rendering()
                        if cheat_client.feature_connections.auto_ingredient then return end

                        cheat_client.feature_connections.auto_ingredient = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(delta_time)
                            if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end

                            local current_time = tick()
                            local current_position = plr.Character.HumanoidRootPart.Position

                            if last_position == nil or
                               current_time - last_check_time > check_interval or
                               (current_time - last_check_time > 0.1 and (current_position - last_position).Magnitude > 2) then

                                last_check_time = current_time
                                last_position = current_position
                                update_active_ingredients()
                            end

                            for _, data in ipairs(active_ingredients) do
                                fireclickdetector(data.detector)
                            end
                        end))
                    end

                    local function stop_auto_ingredient_rendering()
                        if cheat_client.feature_connections.auto_ingredient then
                            cheat_client.feature_connections.auto_ingredient:Disconnect()
                            cheat_client.feature_connections.auto_ingredient = nil
                        end
                    end

                    cheat_client.start_auto_ingredient_rendering = start_auto_ingredient_rendering
                    cheat_client.stop_auto_ingredient_rendering = stop_auto_ingredient_rendering

                    -- Start if enabled by default/autoload
                    if Toggles and Toggles.auto_ingredient and Toggles.auto_ingredient.Value then
                        start_auto_ingredient_rendering()
                    end
                end
            end
        end

        do -- Hold Block
            local holdingF = false
            local last_block_time = 0

            local function start_hold_block()
                if cheat_client.feature_connections.hold_block then return end

                cheat_client.feature_connections.hold_block_input_began = utility:Connection(uis.InputBegan, function(input, processed)
                    if not processed and input.KeyCode == Enum.KeyCode.F then
                        holdingF = true
                    end
                end)

                cheat_client.feature_connections.hold_block_input_ended = utility:Connection(uis.InputEnded, function(input, processed)
                    if input.KeyCode == Enum.KeyCode.F then
                        holdingF = false
                    end
                end)

                cheat_client.feature_connections.hold_block = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                    if holdingF and plr.Character then
                        local delay = ((Options and Options.HoldBlockDelay and Options.HoldBlockDelay.Value) or 0) / 1000
                        local now = tick()

                        if now - last_block_time >= delay then
                            local remote = plr.Character:FindFirstChild("CharacterHandler")
                                and plr.Character.CharacterHandler:FindFirstChild("Remotes")
                                and plr.Character.CharacterHandler.Remotes:FindFirstChild("Block")

                            if remote then
                                pcall(function()
                                    remote:FireServer(false)
                                end)
                                last_block_time = now
                            end
                        end
                    end
                end))
            end

            local function stop_hold_block()
                holdingF = false

                if cheat_client.feature_connections.hold_block then
                    cheat_client.feature_connections.hold_block:Disconnect()
                    cheat_client.feature_connections.hold_block = nil
                end

                if cheat_client.feature_connections.hold_block_input_began then
                    cheat_client.feature_connections.hold_block_input_began:Disconnect()
                    cheat_client.feature_connections.hold_block_input_began = nil
                end

                if cheat_client.feature_connections.hold_block_input_ended then
                    cheat_client.feature_connections.hold_block_input_ended:Disconnect()
                    cheat_client.feature_connections.hold_block_input_ended = nil
                end
            end

            cheat_client.start_hold_block = start_hold_block
            cheat_client.stop_hold_block = stop_hold_block

            if HXD_UserNote and string.find(HXD_UserNote:lower(), "beta") then
                if Toggles and Toggles.HoldBlock and Toggles.HoldBlock.Value then
                    start_hold_block()
                end
            end
        end

        do -- Bag Autopickup
            local bags = {}

            local function isValidBag(object)
                return object:IsA("BasePart") and object.Name:find("Bag")
            end

            local function start_auto_bag()
                if cheat_client.feature_connections.auto_bag then return end

                bags = {}
                for _, object in ipairs(ws.Thrown:GetChildren()) do
                    if isValidBag(object) then
                        bags[#bags + 1] = object
                    end
                end

                cheat_client.feature_connections.auto_bag_child_added = utility:Connection(ws.Thrown.ChildAdded, function(object)
                    if isValidBag(object) then
                        bags[#bags + 1] = object
                    end
                end)

                cheat_client.feature_connections.auto_bag_child_removed = utility:Connection(ws.Thrown.ChildRemoved, function(object)
                    for i = #bags, 1, -1 do
                        if bags[i] == object then
                            table.remove(bags, i)
                            break
                        end
                    end
                end)

                cheat_client.feature_connections.auto_bag = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                    local character = plr.Character
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                    if not rootPart then return end

                    local range = (Options and Options.bag_range and Options.bag_range.Value) or 20
                    for i = #bags, 1, -1 do
                        local object = bags[i]
                        if not object:IsDescendantOf(ws) then
                            table.remove(bags, i)
                        elseif (object.Position - rootPart.Position).Magnitude <= range then
                            firetouchinterest(object, rootPart, 0)
                            firetouchinterest(object, rootPart, 1)
                        end
                    end
                end))
            end

            local function stop_auto_bag()
                if cheat_client.feature_connections.auto_bag then
                    cheat_client.feature_connections.auto_bag:Disconnect()
                    cheat_client.feature_connections.auto_bag = nil
                end

                if cheat_client.feature_connections.auto_bag_child_added then
                    cheat_client.feature_connections.auto_bag_child_added:Disconnect()
                    cheat_client.feature_connections.auto_bag_child_added = nil
                end

                if cheat_client.feature_connections.auto_bag_child_removed then
                    cheat_client.feature_connections.auto_bag_child_removed:Disconnect()
                    cheat_client.feature_connections.auto_bag_child_removed = nil
                end

                bags = {}
            end

            cheat_client.start_auto_bag = start_auto_bag
            cheat_client.stop_auto_bag = stop_auto_bag

            if Toggles and Toggles.auto_bag and Toggles.auto_bag.Value then
                start_auto_bag()
            end
        end
        
        
    
        do -- Perflora Teleport + Attach to Back
            local function IsTargetValid(Target)
                if (plr.Character and Target ~= nil and Target.Name == 'Humanoid' and Target.Parent:FindFirstChild('HumanoidRootPart') and Target.Parent ~= plr.Character) then
                    return true
                end
                return false
            end

            local function IsValidProjectile(Projectile)
                for i,v in pairs(cheat_client.valid_projectiles) do
                    if (string.match(v, Projectile)) then return true; end
                end
                return false
            end

            local active_projectiles = {}

            local function start_perflora_teleport()
                if cheat_client.feature_connections.perflora_teleport then return end

                active_projectiles = {}
                for _, child in ipairs(ws.Thrown:GetChildren()) do
                    if typeof(child) == 'Instance' and IsValidProjectile(child.Name) then
                        active_projectiles[child] = true
                    end
                end

                cheat_client.feature_connections.perflora_child_added = utility:Connection(ws.Thrown.ChildAdded, function(Child)
                    if typeof(Child) == 'Instance' and IsValidProjectile(Child.Name) then
                        active_projectiles[Child] = true
                    end
                end)

                cheat_client.feature_connections.perflora_child_removed = utility:Connection(ws.Thrown.ChildRemoved, function(Child)
                    active_projectiles[Child] = nil
                end)

                cheat_client.feature_connections.perflora_teleport = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                    if not IsTargetValid(workspace.CurrentCamera.CameraSubject) then
                        return
                    end

                    local target_pos = workspace.CurrentCamera.CameraSubject.Parent.HumanoidRootPart.Position

                    for projectile in pairs(active_projectiles) do
                        if projectile and projectile.Parent then
                            projectile.Position = target_pos
                        else
                            active_projectiles[projectile] = nil
                        end
                    end
                end))
            end

            local function stop_perflora_teleport()
                if cheat_client.feature_connections.perflora_teleport then
                    cheat_client.feature_connections.perflora_teleport:Disconnect()
                    cheat_client.feature_connections.perflora_teleport = nil
                end

                if cheat_client.feature_connections.perflora_child_added then
                    cheat_client.feature_connections.perflora_child_added:Disconnect()
                    cheat_client.feature_connections.perflora_child_added = nil
                end

                if cheat_client.feature_connections.perflora_child_removed then
                    cheat_client.feature_connections.perflora_child_removed:Disconnect()
                    cheat_client.feature_connections.perflora_child_removed = nil
                end

                active_projectiles = {}
            end

            cheat_client.start_perflora_teleport = start_perflora_teleport
            cheat_client.stop_perflora_teleport = stop_perflora_teleport

            if Toggles and Toggles.PerfloraTeleport and Toggles.PerfloraTeleport.Value then
                start_perflora_teleport()
            end

            -- attach to back
            local attach_victim = nil
            local attach_connection = nil
            local attach_notified = false
            local camera = utility:GetCamera()

            local function get_nearby_player()
                if not plr.Character then return nil end
                local plr_hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if not plr_hrp then return nil end

                local closest_plr = nil
                local min_dist = 350

                for _, target_player in ipairs(plrs:GetPlayers()) do
                    if target_player ~= plr and target_player.Character then
                        local target_hrp = target_player.Character:FindFirstChild("HumanoidRootPart")
                        local target_humanoid = target_player.Character:FindFirstChild("Humanoid")

                        if target_hrp and target_humanoid and target_humanoid.Health > 0 then
                            local screen_pos, on_screen = camera:WorldToViewportPoint(target_hrp.Position)
                            if on_screen then
                                local screen_distance = (Vector2.new(screen_pos.X, screen_pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                                local world_distance = (plr_hrp.Position - target_hrp.Position).Magnitude

                                if screen_distance < min_dist and world_distance < 130 then
                                    min_dist = screen_distance
                                    closest_plr = target_player
                                end
                            end
                        end
                    end
                end

                return closest_plr
            end

            local function start_attach()
                if attach_connection then return end

                attach_connection = utility:Connection(rs.Stepped, function()
                    if not (Toggles and Toggles.blatant_mode and Toggles.blatant_mode.Value) then
                        attach_victim = nil
                        return
                    end

                    if not attach_victim then
                        attach_victim = get_nearby_player()
                        if not attach_victim then return end
                    end

                    if not attach_victim.Character or not plr.Character then
                        attach_victim = nil
                        return
                    end

                    local victim_hrp = attach_victim.Character:FindFirstChild("HumanoidRootPart")
                    local plr_hrp = plr.Character:FindFirstChild("HumanoidRootPart")

                    if not victim_hrp or not plr_hrp then
                        attach_victim = nil
                        return
                    end

                    local distance_check = (plr_hrp.Position - victim_hrp.Position).Magnitude
                    if distance_check > 130 then
                        attach_victim = nil
                        return
                    end

                    plr_hrp.Velocity = Vector3.new(0, 0, 0)

                    local torso = plr.Character:FindFirstChild("Torso")
                    local head = plr.Character:FindFirstChild("Head")
                    if torso then torso.CanCollide = false end
                    if head then head.CanCollide = false end

                    local offset = 2
                    if uis:IsKeyDown(Enum.KeyCode.W) then
                        offset = -1
                    elseif uis:IsKeyDown(Enum.KeyCode.S) then
                        offset = 6.5
                    end

                    if uis:IsKeyDown(Enum.KeyCode.A) then
                        plr_hrp.CFrame = victim_hrp.CFrame + victim_hrp.CFrame:vectorToWorldSpace(Vector3.new(1, 0, 0) * -3) + (victim_hrp.CFrame.lookVector * -offset)
                    elseif uis:IsKeyDown(Enum.KeyCode.D) then
                        plr_hrp.CFrame = victim_hrp.CFrame + victim_hrp.CFrame:vectorToWorldSpace(Vector3.new(-1, 0, 0) * -3) + (victim_hrp.CFrame.lookVector * -offset)
                    else
                        plr_hrp.CFrame = victim_hrp.CFrame + (victim_hrp.CFrame.lookVector * -offset)
                    end
                end)
            end

            local function stop_attach()
                if attach_connection then
                    attach_connection:Disconnect()
                    attach_connection = nil
                end
                attach_victim = nil
            end

            utility:Connection(uis.InputBegan, function(input, chat)
                if chat or not Options.AttachToBackKeybind then return end
                if Options.AttachToBackKeybind.Value == "None" then return end
                if input.KeyCode == Enum.KeyCode[Options.AttachToBackKeybind.Value] then
                    if not (Toggles and Toggles.blatant_mode and Toggles.blatant_mode.Value) then
                        library:Notify("Attach to Back requires Blatant Mode enabled!", 3)
                        return
                    end

                    if attach_victim ~= nil then
                        stop_attach()
                    else
                        local nearby = get_nearby_player()
                        if nearby ~= nil then
                            if nearby ~= attach_victim then
                                attach_victim = nearby
                                start_attach()
                            else
                                stop_attach()
                            end
                        else
                            stop_attach()
                        end
                    end
                end
            end)
        end

        do -- Auto Misogi
            local misogi_connections = {}

            local function handleAutoMisogi(obj)
                if not (Toggles and Toggles.AutoMisogi and Toggles.AutoMisogi.Value) then return end

                if obj.Name == "LandedShoryuExcept" then
                    task.wait(0.02)
                    if not plr.Backpack then return end
                    local tool = plr.Backpack:FindFirstChild("Rising Dragon")
                    if tool then
                        plr.Character.Humanoid:EquipTool(tool)

                        task.spawn(function()
                            while shared and not shared.is_unloading and obj.Parent == plr.Character and not plr.Character:FindFirstChild("TPSafe") do
                                if not plr.Character:FindFirstChild("Rising Dragon") and plr.Backpack then
                                    local backpackTool = plr.Backpack:FindFirstChild("Rising Dragon")
                                    if backpackTool then
                                        plr.Character.Humanoid:EquipTool(backpackTool)
                                    end
                                end

                                utility:RightClick()
                                task.wait(0.1)
                            end
                        end)
                    end
                end
            end

            local function setupMisogi(character)
                for _, conn in pairs(misogi_connections) do
                    conn:Disconnect()
                end
                misogi_connections = {}
                misogi_connections[#misogi_connections + 1] = utility:Connection(character.ChildAdded, handleAutoMisogi)
            end

            if plr.Character then
                setupMisogi(plr.Character)
            end

            utility:Connection(plr.CharacterAdded, setupMisogi)
        end

        do -- Auto Parry
            local DETECTION_RANGE = 30
            local AUTO_PARRY_COOLDOWN = 0.1
            local LAST_PARRY = 0
            local EARTH_PILLAR_PARRY_DISTANCE = 10
            local EARTH_PILLAR_BLOCK_DURATION = 0.45
            local INPUT_BLOCKED = false
            local BLOCKED_KEYS = {Enum.KeyCode.F, Enum.KeyCode.G}

            local function getPing()
                local success, ping = pcall(function()
                    return game:GetService('Stats'):WaitForChild('PerformanceStats'):WaitForChild('Ping'):GetValue()
                end)
                return success and ping or 0
            end

            local AUTO_PARRY_SOUNDS = {
                ["OwlSlash"] = {delay = 0.1, blockDuration = 0.7, requiresVisibility = false},
                ["Shadowrush"] = {delay = 0.05, blockDuration = 0.3, requiresVisibility = true},
                ["ShadowrushCharge"] = {delay = 0.05, blockDuration = 0.3, requiresVisibility = true},
                ["PerfectCast"] = {delay = 0, blockDuration = 0.25, requiresVisibility = true}
            }
            
            local function blockInputs()
                INPUT_BLOCKED = true
                
                cas:BindAction("BlockAutoParryInputs", function()
                    return Enum.ContextActionResult.Sink
                end, false, unpack(BLOCKED_KEYS))
                
                local mouseConnection = utility:Connection(uis.InputBegan, function(input)
                    if INPUT_BLOCKED and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) then
                        -- consume the input to prevent it from registering
                    end
                end)
                
                return mouseConnection
            end
            
            local function unblockInputs(mouseConnection)
                INPUT_BLOCKED = false
                cas:UnbindAction("BlockAutoParryInputs")
                if mouseConnection then
                    mouseConnection:Disconnect()
                end
            end

            -- Functions
            -- Check if on screen with raycast, NO FOV restriction
            local function is_on_screen_visible(characterHRP)
                local vector, on_screen = ws.CurrentCamera:WorldToScreenPoint(characterHRP.Position)

                if not on_screen then
                    return false
                end

                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                    return false
                end

                local playerHRP = plr.Character.HumanoidRootPart
                local directionToCharacter = (characterHRP.Position - playerHRP.Position).Unit

                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {plr.Character}
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist

                local rayResult = workspace:Raycast(
                    playerHRP.Position,
                    directionToCharacter * (playerHRP.Position - characterHRP.Position).Magnitude,
                    rayParams
                )

                return not rayResult or rayResult.Instance:IsDescendantOf(characterHRP.Parent)
            end

            local function is_visible(characterHRP)
                local vector, on_screen = ws.CurrentCamera:WorldToScreenPoint(characterHRP.Position)

                if not on_screen then
                    return false
                end

                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                    return false
                end

                local playerHRP = plr.Character.HumanoidRootPart
                local playerLookVector = playerHRP.CFrame.LookVector
                local directionToCharacter = (characterHRP.Position - playerHRP.Position).Unit

                local dotProduct = playerLookVector:Dot(directionToCharacter)
                local fovAngle = Options.ParryFovAngle.Value
                local angleThreshold = math.cos(math.rad(fovAngle / 2))

                if dotProduct > angleThreshold then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {plr.Character}
                    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

                    local rayResult = workspace:Raycast(
                        playerHRP.Position,
                        directionToCharacter * (playerHRP.Position - characterHRP.Position).Magnitude,
                        rayParams
                    )

                    if rayResult and rayResult.Instance:IsDescendantOf(characterHRP.Parent) then
                        return true
                    end
                end

                return false
            end

            local function on_cooldown()
                if not plr.Character then return true end
                
                if plr.Character:FindFirstChild("ParryCool") then
                    return true
                end
                
                return false
            end

            local function performAutoParry(delay, blockDuration, useVim, attackingPlayer)
                if attackingPlayer and cheat_client:is_friendly(attackingPlayer) then
                    return
                end

                local disableWhenUnfocused = Toggles.ParryDisableWhenUnfocused.Value
                if disableWhenUnfocused then
                    if not cheat_client.window_active or uis:GetFocusedTextBox() then
                        return
                    end
                end
                
                local currentTime = tick()
                if currentTime - LAST_PARRY < AUTO_PARRY_COOLDOWN then return end

                local semiBlatantBlock = Toggles.ParrySemiBlatantBlock and Toggles.ParrySemiBlatantBlock.Value
                if not semiBlatantBlock and plr.Character:FindFirstChild("NoDash") then return end

                if plr.Character:FindFirstChildOfClass("ForceField") then return end
                if on_cooldown() then return end

                LAST_PARRY = currentTime
                blockDuration = blockDuration or 0.3
                
                local adjustedDelay = delay or 0
                if Toggles and Toggles.ParryCustomDelay and Toggles.ParryCustomDelay.Value then
                    local customDelayMs = Options.ParryCustomDelayMs.Value
                    adjustedDelay = adjustedDelay + (customDelayMs / 1000)  -- convert ms to seconds
                elseif Toggles.ParryPingAdjust.Value then
                    local ping = getPing()
                    local pingCompensation = ping / 2000  -- convert to seconds and divide by 2 (round trip)
                    adjustedDelay = adjustedDelay - pingCompensation
                end
                
                adjustedDelay = math.max(0, adjustedDelay)
                local mouseConnection = blockInputs()
                
                if adjustedDelay > 0 then
                    task.wait(adjustedDelay)
                    if on_cooldown() then
                        unblockInputs(mouseConnection)
                        return
                    end
                end

                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                local mana = plr.Character:FindFirstChild("Mana")
                if humanoid and mana and mana.Value > 0 then
                    humanoid:UnequipTools()
                end

                local blockRemote, unblockRemote
                if plr.Character then
                    local remotes = plr.Character:FindFirstChild("CharacterHandler", true) and
                                plr.Character.CharacterHandler:FindFirstChild("Remotes")

                    if remotes then
                        blockRemote = remotes:FindFirstChild("Block")
                        unblockRemote = remotes:FindFirstChild("Unblock")
                    end
                end

                local semiBlatantBlock = Toggles.ParrySemiBlatantBlock and Toggles.ParrySemiBlatantBlock.Value
                if semiBlatantBlock and blockRemote and unblockRemote then
                    task.spawn(function()
                        local endTime = tick() + blockDuration
                        while tick() < endTime do
                            blockRemote:FireServer(false)
                            task.wait()
                        end

                        local inputObject = {}
                        unblockRemote:FireServer(inputObject)
                        unblockInputs(mouseConnection)
                    end)
                elseif useVim or not (blockRemote and unblockRemote) then
                    vim:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    task.wait(blockDuration)
                    vim:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                    unblockInputs(mouseConnection)
                else
                    blockRemote:FireServer(false)

                    task.delay(blockDuration, function()
                        local inputObject = {}
                        unblockRemote:FireServer(inputObject)
                        unblockInputs(mouseConnection)
                    end)
                end
            end

            local connectedSounds = {}
            local characterConnections = {}
            
            local function disconnect_character_sounds(player)
                if characterConnections[player] then
                    for _, connection in pairs(characterConnections[player]) do
                        if connection and connection.Connected then
                            connection:Disconnect();
                        end
                    end
                    characterConnections[player] = nil
                end
                connectedSounds[player] = nil
            end
            
            local function connect_sounds(character)
                local player = plrs:GetPlayerFromCharacter(character)
                if not player or player == plr then
                    return
                end

                disconnect_character_sounds(player)
                characterConnections[player] = {}
                connectedSounds[player] = true

                local characterHRP = character:WaitForChild("HumanoidRootPart", 3)
                if not characterHRP then
                    return
                end
                
                local function handleSound(sound)
                    if not utility then return end
                    return utility:Connection(sound.Played, function()
                        if not shared or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                            return
                        end
                        local playerHRP = plr.Character.HumanoidRootPart
                        local distance = (playerHRP.Position - characterHRP.Position).Magnitude
                        if distance <= DETECTION_RANGE then
                            if sound.Name == "OwlSlash" and shared and Toggles and Toggles.ParryOwl and Toggles.ParryOwl.Value then
                                if plr.Character and plr.Character:FindFirstChild("AIRSLASH") then
                                    local soundInfo = AUTO_PARRY_SOUNDS[sound.Name]
                                    local ignoreVisibility = shared and Toggles.ParryIgnoreVisibility and Toggles.ParryIgnoreVisibility.Value
                                    local should_parry = ignoreVisibility or not soundInfo.requiresVisibility or is_visible(characterHRP)
                                    if should_parry then
                                        task.spawn(function()
                                            if shared then
                                                performAutoParry(soundInfo.delay, soundInfo.blockDuration, false, player)
                                            end
                                        end)
                                    end
                                end
                            elseif (sound.Name == "Shadowrush" or sound.Name == "ShadowrushCharge") and shared and Toggles and Toggles.ParryShadowrush and Toggles.ParryShadowrush.Value then
                                local attackerLookDirection = characterHRP.CFrame.LookVector
                                local directionToPlayer = (playerHRP.Position - characterHRP.Position).Unit
                                local facingDotProduct = attackerLookDirection:Dot(directionToPlayer)

                                if facingDotProduct > -0.17 then
                                    local soundInfo = AUTO_PARRY_SOUNDS[sound.Name]
                                    local ignoreVisibility = shared and Toggles.ParryIgnoreVisibility and Toggles.ParryIgnoreVisibility.Value
                                    local should_parry = ignoreVisibility or not soundInfo.requiresVisibility or is_visible(characterHRP)
                                    if should_parry then
                                        local actualDelay = soundInfo.delay
                                        if (sound.Name == "Shadowrush" or sound.Name == "ShadowrushCharge") and distance <= 9 then
                                            actualDelay = 0
                                        end
                                        task.defer(function()
                                            if shared then
                                                performAutoParry(actualDelay, soundInfo.blockDuration, false, player)
                                            end
                                        end)
                                    end
                                end
                            elseif sound.Name == "PerfectCast" and shared and Toggles and Toggles.ParryVerdien and Toggles.ParryVerdien.Value then
                                local soundInfo = AUTO_PARRY_SOUNDS[sound.Name]
                                local hasVerdien = character:FindFirstChild("Verdien") or character:FindFirstChild("New Verdien")

                                if hasVerdien then
                                    local ignoreVisibility = shared and Toggles.ParryIgnoreVisibility and Toggles.ParryIgnoreVisibility.Value
                                    local should_parry = ignoreVisibility or not soundInfo.requiresVisibility or is_visible(characterHRP)
                                    if should_parry then
                                        task.spawn(function()
                                            if shared then
                                                performAutoParry(soundInfo.delay, soundInfo.blockDuration, false, player)
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                end

                for _, sound in ipairs(characterHRP:GetChildren()) do
                    if sound:IsA("Sound") then
                        local soundConnection = handleSound(sound)
                        if soundConnection then
                            table.insert(characterConnections[player], soundConnection)
                        end
                    end
                end

                if utility and utility.Connection then
                    local childAddedConnection = utility:Connection(characterHRP.ChildAdded, function(child)
                        if child:IsA("Sound") then
                            task.wait(0.1)
                            local soundConnection = handleSound(child)
                            if soundConnection then
                                characterConnections[player] = characterConnections[player] or {}
                                table.insert(characterConnections[player], soundConnection)
                            end
                        end
                    end)
                    table.insert(characterConnections[player], childAddedConnection)
                end
            end

            local playerConnections = {}
            local function connect_player(player)
                if player == plr or playerConnections[player] then
                    return
                end

                playerConnections[player] = {}

                if player.Character then
                    connect_sounds(player.Character)
                end

                playerConnections[player].characterAdded = utility:Connection(player.CharacterAdded, function(character)
                    task.wait(0.5)
                    connect_sounds(character)
                end)

                playerConnections[player].characterRemoving = utility:Connection(player.CharacterRemoving, function()
                    disconnect_character_sounds(player)
                end)
            end

            local function disconnect_player(player)
                if playerConnections[player] then
                    for _, connection in pairs(playerConnections[player]) do
                        if connection and connection.Connected then
                            connection:Disconnect()
                        end
                    end
                    playerConnections[player] = nil
                end
                disconnect_character_sounds(player)
            end

            local function connect_players()
                for _, player in ipairs(plrs:GetPlayers()) do
                    if player ~= plr then
                        connect_player(player)
                    end
                end

                utility:Connection(plrs.PlayerAdded, function(player)
                    if player ~= plr then
                        connect_player(player)
                    end
                end)

                utility:Connection(plrs.PlayerRemoving, function(player)
                    disconnect_player(player)
                end)
            end


            utility:Connection(workspace.Thrown.ChildAdded, function(model)
                if not (Toggles and Toggles.ParryViribus and Toggles.ParryViribus.Value) then return end
                if not model:IsA("Model") then return end

                local crater = model:WaitForChild("Crater", 1)
                if not crater then return end

                if crater:IsA("Model") then
                    crater = crater.PrimaryPart or crater:FindFirstChildWhichIsA("BasePart")
                    if not crater then return end
                end

                if not crater:IsA("BasePart") then return end
                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end

                local playerHRP = plr.Character.HumanoidRootPart
                if model:FindFirstChild("EarthSpear" .. plr.Name) then return end

                local distance = (crater.Position - playerHRP.Position).Magnitude
                if distance > EARTH_PILLAR_PARRY_DISTANCE then return end

                local closestCaster, closestDistance = nil, math.huge

                for _, player in ipairs(plrs:GetPlayers()) do
                    if player ~= plr and player.Character then
                        local casterHRP = player.Character:FindFirstChild("HumanoidRootPart")
                        if casterHRP then
                            local casterToEarthPillar = (casterHRP.Position - crater.Position).Magnitude
                            if casterToEarthPillar < 50 and casterToEarthPillar < closestDistance then
                                closestCaster, closestDistance = player.Character, casterToEarthPillar
                            end
                        end
                    end
                end

                local function isInFov(direction)
                    local playerLookVector = playerHRP.CFrame.LookVector
                    local dotProduct = playerLookVector:Dot(direction)
                    local fovAngle = Options.ParryFovAngle.Value
                    local angleThreshold = math.cos(math.rad(fovAngle / 2))
                    return dotProduct > angleThreshold
                end

                if closestCaster then
                    local casterHRP = closestCaster:FindFirstChild("HumanoidRootPart")
                    if casterHRP and isInFov((casterHRP.Position - playerHRP.Position).Unit) then
                        local attackingPlayer = plrs:GetPlayerFromCharacter(closestCaster)
                        performAutoParry(0, EARTH_PILLAR_BLOCK_DURATION, false, attackingPlayer)
                    end
                else
                    if isInFov((crater.Position - playerHRP.Position).Unit) then
                        performAutoParry(0, EARTH_PILLAR_BLOCK_DURATION, false, nil)
                    end
                end
            end)


            connect_players()
        end

        do -- Silent Aim
            local valid_tools = { Celeritas = true, Armis = true, Vulnere = true, ["Dagger Throw"] = true, Arguere = true, Grapple = true, ["Autumn Rain"] = true, Ignis = true, Percutiens = true }

            local get_nearest_player = LPH_NO_VIRTUALIZE(function()
                local players_list = plrs:GetPlayers()
                local camera = ws.CurrentCamera
                local smallest_distance = math.huge
                local nearest
            
                local plr_humanoid_root_part = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                local mouse_position = Vector2.new(mouse.X, mouse.Y)
            
                if not plr_humanoid_root_part then
                    return nil
                end
            
                local fov_radius = (Options and Options.SilentAimFov and Options.SilentAimFov.Value) or 100
                local hitparts = {
                    ["Head"] = true
                }
            
                local function is_visible_from_camera(part, target_character)
                    local camera_position = camera.CFrame.Position
                    local direction = (part.Position - camera_position).Unit
                    local distance = (part.Position - camera_position).Magnitude

                    local raycast_params = RaycastParams.new()
                    raycast_params.FilterDescendantsInstances = {plr.Character, target_character}
                    raycast_params.FilterType = Enum.RaycastFilterType.Blacklist

                    local result = workspace:Raycast(camera_position, direction * distance, raycast_params)

                    if not result then
                        return true
                    end

                    if result.Instance == part then
                        return true
                    end

                    if result.Instance.Transparency > 0.9 and not result.Instance.CanCollide then
                        return true
                    end

                    local hit_distance = (result.Position - camera_position).Magnitude
                    local target_distance = (part.Position - camera_position).Magnitude

                    return math.abs(hit_distance - target_distance) < 1
                end
            
                for _, target_player in ipairs(players_list) do
                    if target_player ~= plr and not cheat_client:is_friendly(target_player) then
                        local target_character = target_player.Character
                        if target_character then
                            local closest_part = nil
                            local closest_part_distance = math.huge
                            
                            for part_name, _ in next, hitparts do
                                local part = target_character:FindFirstChild(part_name)
                                if part then
                                    local screen_position, on_screen = camera:WorldToScreenPoint(part.Position)
                                    
                                    if on_screen then
                                        local target_screen_position = Vector2.new(screen_position.X, screen_position.Y)
                                        local distance_to_mouse = (mouse_position - target_screen_position).Magnitude
                                        
                                        if distance_to_mouse <= fov_radius and distance_to_mouse < closest_part_distance then
                                            -- Use camera-based visibility check
                                            if is_visible_from_camera(part, target_character) then
                                                closest_part = part
                                                closest_part_distance = distance_to_mouse
                                            end
                                        end
                                    end
                                end
                            end
                            
                            if closest_part and closest_part_distance <= fov_radius and closest_part_distance < smallest_distance then
                                smallest_distance = closest_part_distance
                                nearest = target_player
                                cheat_client.aimbot.silent_vector = closest_part.Position
                                cheat_client.aimbot.current_target_part = closest_part
                            end
                        end
                    end
                end
                return nearest
            end)
            
            function is_valid_tool_equipped()
                local equipped_tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
                return equipped_tool and valid_tools[equipped_tool.Name]
            end

            local function start_silent_aim_rendering()
                if cheat_client.feature_connections.silent_aim then return end

                cheat_client.feature_connections.silent_aim = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                    local isHideFovCircleEnabled = Toggles and Toggles.HideFovCircle and Toggles.HideFovCircle.Value or false
                    local mouse_pos = Vector2.new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y)
                    aimbot_fov_circle.Position = mouse_pos
                    aimbot_fov_circle.Radius = (Options and Options.SilentAimFov and Options.SilentAimFov.Value) or 100
                    aimbot_fov_circle.Visible = cheat_client.window_active and not isHideFovCircleEnabled

                    local nearest_player = get_nearest_player()
                    if cheat_client and cheat_client.aimbot then
                        cheat_client.aimbot.current_target = nearest_player
                    end

                    if game.PlaceId ~= 14341521240 and get_mouse_remote then
                        get_mouse_remote.OnClientInvoke = function()
                            if not is_valid_tool_equipped() then
                                return {
                                    Hit = mouse.Hit,
                                    Target = mouse.Target,
                                    UnitRay = mouse.UnitRay,
                                    X = mouse.X,
                                    Y = mouse.Y
                                }
                            end

                            if cheat_client and cheat_client.aimbot and cheat_client.aimbot.current_target and cheat_client.aimbot.silent_vector and cheat_client.aimbot.current_target_part then
                                local camera = ws.CurrentCamera
                                local target_screen_point = camera:WorldToScreenPoint(cheat_client.aimbot.silent_vector)
                                local target_cframe = CFrame.new(cheat_client.aimbot.silent_vector)

                                return {
                                    Hit = target_cframe,
                                    Target = cheat_client.aimbot.current_target_part,
                                    X = target_screen_point.X,
                                    Y = target_screen_point.Y,
                                    UnitRay = Ray.new(camera.CFrame.Position, (cheat_client.aimbot.silent_vector - camera.CFrame.Position).Unit)
                                }
                            end

                            return {
                                Hit = mouse.Hit,
                                Target = mouse.Target,
                                UnitRay = mouse.UnitRay,
                                X = mouse.X,
                                Y = mouse.Y
                            }
                        end
                    end
                end))
            end

            local function stop_silent_aim_rendering()
                if cheat_client.feature_connections.silent_aim then
                    cheat_client.feature_connections.silent_aim:Disconnect()
                    cheat_client.feature_connections.silent_aim = nil

                    -- Cleanup
                    cheat_client.aimbot.silent_vector = nil
                    cheat_client.aimbot.current_target = nil
                    cheat_client.aimbot.current_target_part = nil
                    aimbot_fov_circle.Visible = false
                    silent_circle.Visible = false
                end
            end

            cheat_client.start_silent_aim_rendering = start_silent_aim_rendering
            cheat_client.stop_silent_aim_rendering = stop_silent_aim_rendering

            -- Start if enabled by default/autoload
            if Toggles and Toggles.SilentAim and Toggles.SilentAim.Value then
                start_silent_aim_rendering()
            end
        end

        do -- Better Flight
            local direction = Vector3.new()
            local interpolated_dir = direction
            local tilt = 0
            local interpolated_tilt = tilt
            local sprinting = false
            local camera_pos = ws.CurrentCamera.CFrame.Position
            local cached_parts = {}
            local last_character = nil

            local function lerp(a, b, t)
                return a + (b - a) * t
            end

            local function cache_character_parts(character)
                cached_parts = {}
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        table.insert(cached_parts, v)
                    end
                end
            end

            local function start_better_flight()
                if cheat_client.feature_connections.better_flight then return end

                cheat_client.feature_connections.better_flight_input_began = utility:Connection(uis.InputBegan, function(input, processed)
                    if processed then return end
                    if input.KeyCode == nil then return end

                    local key = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")

                    if key == "LeftControl" then
                        sprinting = true
                    elseif key == "W" then
                        tilt = -20
                        direction = Vector3.new(direction.X, direction.Y, -1)
                    elseif key == "A" then
                        direction = Vector3.new(-1, direction.Y, direction.Z)
                    elseif key == "S" then
                        tilt = 20
                        direction = Vector3.new(direction.X, direction.Y, 1)
                    elseif key == "D" then
                        direction = Vector3.new(1, direction.Y, direction.Z)
                    end
                end)

                cheat_client.feature_connections.better_flight_input_ended = utility:Connection(uis.InputEnded, function(input, processed)
                    if processed then return end
                    if input.KeyCode == nil then return end

                    local key = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")

                    if key == "LeftControl" then
                        sprinting = false
                    elseif key == "W" then
                        tilt = 0
                        direction = Vector3.new(direction.X, direction.Y, 0)
                    elseif key == "A" then
                        direction = Vector3.new(0, direction.Y, direction.Z)
                    elseif key == "S" then
                        tilt = 0
                        direction = Vector3.new(direction.X, direction.Y, 0)
                    elseif key == "D" then
                        direction = Vector3.new(0, direction.Y, direction.Z)
                    end
                end)

                cheat_client.feature_connections.better_flight = utility:Connection(rs.Stepped, LPH_NO_VIRTUALIZE(function()
                    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end

                    if last_character ~= plr.Character then
                        last_character = plr.Character
                        cache_character_parts(plr.Character)
                    end

                    for _, v in ipairs(cached_parts) do
                        if v and v.Parent then
                            v.Velocity = Vector3.new()
                            v.CanCollide = false
                        end
                    end

                    local root_part = plr.Character.HumanoidRootPart

                    interpolated_dir = interpolated_dir:Lerp((direction * (sprinting and 15 or 5)), 0.2)
                    interpolated_tilt = lerp(interpolated_tilt, tilt * (sprinting and 2 or 1), tilt == 0 and 0.2 or 0.1)

                    root_part.CFrame = root_part.CFrame:Lerp(
                        CFrame.new(root_part.Position, root_part.Position + mouse.UnitRay.Direction) *
                        CFrame.Angles(0, math.rad(0), 0) *
                        CFrame.new(interpolated_dir) *
                        CFrame.Angles(math.rad(interpolated_tilt), 0, 0),
                        0.2
                    )
                end))
            end

            local function stop_better_flight()
                direction = Vector3.new()
                interpolated_dir = direction
                tilt = 0
                interpolated_tilt = tilt
                sprinting = false

                if cheat_client.feature_connections.better_flight then
                    cheat_client.feature_connections.better_flight:Disconnect()
                    cheat_client.feature_connections.better_flight = nil
                end

                if cheat_client.feature_connections.better_flight_input_began then
                    cheat_client.feature_connections.better_flight_input_began:Disconnect()
                    cheat_client.feature_connections.better_flight_input_began = nil
                end

                if cheat_client.feature_connections.better_flight_input_ended then
                    cheat_client.feature_connections.better_flight_input_ended:Disconnect()
                    cheat_client.feature_connections.better_flight_input_ended = nil
                end
            end

            cheat_client.start_better_flight = start_better_flight
            cheat_client.stop_better_flight = stop_better_flight
        end
    
        do -- freecam
            local empty_vector = Vector3.new(0, 0, 0)
    
            local move_position = Vector2.new(0, 0)
            local move_direction = empty_vector
    
            local last_right_button_down = Vector2.new(0, 0)
            local right_mouse_button_down = false
    
            local keys_down = {}
            
            local enum_keycode = Enum.KeyCode
            local zoom_keycode = enum_keycode.Z
    
            local mouse_movement = Enum.UserInputType.MouseMovement
            local mouse_button_2 = Enum.UserInputType.MouseButton2
            
            local begin_state = Enum.UserInputState.Begin
            local end_state = Enum.UserInputState.End
    
            local lock_current_position = Enum.MouseBehavior.LockCurrentPosition
            local default_mouse = Enum.MouseBehavior.Default
    
            local camera = utility:GetCamera()
            local camera_scriptable = Enum.CameraType.Scriptable
            local camera_custom = Enum.CameraType.Custom
    
            local move_keys = {
                [enum_keycode.D] = Vector3.new(1, 0, 0),
                [enum_keycode.A] = Vector3.new(-1, 0, 0),
                [enum_keycode.S] = Vector3.new(0, 0, 1),
                [enum_keycode.W] = Vector3.new(0, 0, -1),
                [enum_keycode.E] = Vector3.new(0, 1, 0),
                [enum_keycode.Q] = Vector3.new(0, -1, 0)
            }
    
            utility:Connection(uis.InputChanged, LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == mouse_movement then
                    move_position = move_position + Vector2.new(input.Delta.X, input.Delta.Y)
                end
            end))
    
            local keyboard = {
        		W = 0,
        		A = 0,
        		S = 0,
        		D = 0,
        		E = 0,
        		Q = 0,
        		U = 0,
        		H = 0,
        		J = 0,
        		K = 0,
        		I = 0,
        		Y = 0,
        		Up = 0,
        		Down = 0,
        		LeftShift = 0,
        		RightShift = 0,
    	   }
            
            local function Keypress(action, state, input)
                local freecam_keybind_string = Options.FreecamKeybind and Options.FreecamKeybind.Value
                local freecam_keybind_enum = freecam_keybind_string and Enum.KeyCode[freecam_keybind_string]

                if freecam_keybind_enum and input.KeyCode == freecam_keybind_enum then
                    return Enum.ContextActionResult.Pass
                end

                keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
                return Enum.ContextActionResult.Sink
            end
    
            function StartCapture()
    		    cas:BindActionAtPriority("FreecamKeyboard", Keypress, false, Enum.ContextActionPriority.High.Value,
        			Enum.KeyCode.W, Enum.KeyCode.U,
        			Enum.KeyCode.A, Enum.KeyCode.H,
        			Enum.KeyCode.S, Enum.KeyCode.J,
        			Enum.KeyCode.D, Enum.KeyCode.K,
        			Enum.KeyCode.E, Enum.KeyCode.I,
        			Enum.KeyCode.Q, Enum.KeyCode.Y,
        			Enum.KeyCode.Up, Enum.KeyCode.Down
        		)
    	    end
    
            local function Zero(t)
    			for k, v in pairs(t) do
    				t[k] = v*0
    			end
            end
    	
    		function StopCapture()
    			navSpeed = 1
    			Zero(keyboard)
    			cas:UnbindAction("FreecamKeyboard")
    		end
    
            local calculate_movement = LPH_NO_VIRTUALIZE(function()
                local new_movement = empty_vector
                
                for index, value in next, keys_down do
                    new_movement = new_movement + (move_keys[index] or empty_vector)
                end
                
                return new_movement
            end)
    
            local function input_register(input)
                local key_code = input.KeyCode
    
                if move_keys[key_code] then
                    if input.UserInputState == begin_state then
                        keys_down[key_code] = true
                    elseif input.UserInputState == end_state then
                        keys_down[key_code] = nil
                    end
                else
                    if input.UserInputState == begin_state and shared and Toggles and Toggles.freecam and Toggles.freecam.Value then
                        if input.UserInputType == mouse_button_2 then
                            right_mouse_button_down = true
                            last_right_button_down = Vector2.new(mouse.X, mouse.Y)
                            uis.MouseBehavior = lock_current_position
                        end
                    else
                        if input.UserInputType == mouse_button_2 and shared and Toggles and Toggles.freecam and Toggles.freecam.Value then
                            right_mouse_button_down = false
                            uis.MouseBehavior = default_mouse
                        end
                    end
                end
            end
    
            utility:Connection(mouse.WheelForward, function()
                camera.CoordinateFrame = camera.CoordinateFrame * CFrame.new(0, 0, -5)
            end)
    
            utility:Connection(mouse.WheelBackward, function()
                camera.CoordinateFrame = camera.CoordinateFrame * CFrame.new(0, 0, 5)
            end)
    
            utility:Connection(uis.InputBegan, input_register)
            utility:Connection(uis.InputEnded, input_register)
    
            local function start_freecam_rendering()
                if cheat_client.feature_connections.freecam then return end

                cheat_client.feature_connections.freecam = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                    local freecamSpeed = (Options and Options.freecam_speed and Options.freecam_speed.Value) or 16
                    camera.CoordinateFrame = CFrame.new(camera.CoordinateFrame.Position) * CFrame.fromEulerAnglesYXZ(-move_position.Y / 300, -move_position.X / 300, 0) * CFrame.new(calculate_movement() * freecamSpeed)

                    if right_mouse_button_down then
                        local mouse_position = Vector2.new(mouse.X, mouse.Y)

                        uis.MouseBehavior = lock_current_position
                        move_position = move_position - (last_right_button_down - mouse_position)
                        last_right_button_down = mouse_position
                    end
                end))
            end

            local function stop_freecam_rendering()
                if cheat_client.feature_connections.freecam then
                    cheat_client.feature_connections.freecam:Disconnect()
                    cheat_client.feature_connections.freecam = nil
                end
            end

            -- Hook to freecam toggle OnChanged (will be called after toggle setup)
            cheat_client.start_freecam_rendering = start_freecam_rendering
            cheat_client.stop_freecam_rendering = stop_freecam_rendering
        end


        do -- Execute on Serverhop Handler
            local teleport_debounce = false

            utility:Connection(plr.OnTeleport, function(State)
                if teleport_debounce then
                    return
                end
                teleport_debounce = true

                if cheat_client.config.execute_on_serverhop then
                    local queue_func = queueteleport or queue_on_teleport
                    if queue_func then
                        local success, err = pcall(function()
                            local loader_script
                            if readfile and isfile and isfile("bazaar_loader.txt") then
                                loader_script = [[local s,e=pcall(loadstring(readfile("bazaar_loader.txt")))if not s then print("[QUEUE ERROR]",e)end]]
                            else
                                loader_script = [[local s,e=pcall(loadstring(game:HttpGet("https://bazaar.hydroxide.solutions/v2/loader.lua")))if not s then print("[QUEUE ERROR]",e)end]]
                            end
                            queue_func(loader_script)
                        end)
                    end
                end
            end)
        end
    
        do -- Auto Charge Mana
            local stats = game:GetService("Stats")
            local pingStat = stats:WaitForChild("PerformanceStats"):WaitForChild("Ping")
            local smoothed_ping = 0

            -- smooth ping (light)
            task.spawn(function()
                while shared and not shared.is_unloading do
                    local raw = pingStat and pingStat:GetValue() or 0
                    smoothed_ping = math.clamp((smoothed_ping * 0.3) + (raw * 0.7), 0, 300)
                    task.wait(0.25)
                end
            end)

            local function adjusted_wait(base, mult)
                mult = mult or 1
                task.wait(base + (math.min(smoothed_ping, 150) / 2000) * mult)
            end

            local function apply_auto_charge(character)
                local mana = character:WaitForChild("Mana")
                local cached_tool = nil

                task.spawn(function()
                    while shared and not shared.is_unloading do
                        if Toggles.SnapTrain and Toggles.SnapTrain.Value then
                            task.wait(0.01)
                        else
                            if not utility then break end
                            task.wait(utility:random_wait(true))
                        end

                        -- Break if character changed (prevents coroutine leak on respawn)
                        if not plr.Character or plr.Character ~= character or not utility or not Toggles or not Options then
                            break
                        end

                        local char = plr.Character
                        local mana_val = mana.Value

                        ------------------------------------------------------------
                        -- SNAP TRAIN MODE
                        ------------------------------------------------------------
                        if Toggles.SnapTrain and Toggles.SnapTrain.Value and utility then
                            if Toggles.AutoCharge and Toggles.AutoCharge.Value then
                                Toggles.AutoCharge:SetValue(false)
                            end

                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool and tool:FindFirstChild("Spell") and not cached_tool then
                                cached_tool = tool
                            end

                            if cached_tool and cheat_client.spell_cost[cached_tool.Name] then
                                local spell_data = cheat_client.spell_cost[cached_tool.Name][1]
                                local min_cost, max_cost = spell_data[1], spell_data[2]
                                local mid_cost = (min_cost + max_cost) / 2
                                local range = max_cost - min_cost
                                
                                local buffer = math.min(3, math.floor(range / 3))
                                if buffer < 1 then buffer = 0 end

                                if mana_val < (mid_cost - 1) then
                                    utility:charge_mana_until(mid_cost)
                                end

                                if mana_val >= (min_cost + buffer)
                                    and mana_val <= (max_cost - buffer)
                                    and not cs:HasTag(char, "Casting")
                                then
                                    if char:FindFirstChildOfClass("Tool") ~= cached_tool then
                                        if cached_tool.Parent == plr.Backpack then
                                            char.Humanoid:EquipTool(cached_tool)
                                            adjusted_wait(0.01)
                                        end
                                    end

                                    if utility then
                                        utility:LeftClick()
                                    end

                                    --[[
                                    if cached_tool and cached_tool.Name == "Gate" then
                                        repeat
                                            task.wait()
                                        until char:FindFirstChild("Action")

                                        task.wait()
                                        char.Action:Destroy();
                                        char.GateOut:Destroy();
                                    end
                                    --]]

                                    local timeout = 0
                                    repeat
                                        task.wait(0.005)
                                        timeout = timeout + 1
                                    until cs:HasTag(char, "Casting") or not utility or timeout > 20

                                    if cs:HasTag(char, "Casting") then
                                        char.Humanoid:UnequipTools()
                                        
                                        timeout = 0
                                        repeat 
                                            task.wait(0.01)
                                            timeout = timeout + 1
                                        until not cs:HasTag(char, "Casting") or not utility or timeout > 100
                                        
                                        if not utility then return end
                                        task.wait(utility:random_wait(true))

                                        if cached_tool.Parent == plr.Backpack then
                                            char.Humanoid:EquipTool(cached_tool)
                                        end
                                    end
                                end
                            end
                        else
                            cached_tool = nil
                        end

                        ------------------------------------------------------------
                        -- AUTO CHARGE MODE
                        ------------------------------------------------------------
                        if Toggles.AutoCharge and Toggles.AutoCharge.Value
                            and mana_remote
                            and mana_val <= Options.AutoChargeThreshold.Value
                            and not cs:HasTag(char, "Casting")
                        then
                            if Toggles.train_climb and Toggles.train_climb.Value then
                                Toggles.train_climb:SetValue(false)
                            end

                            utility:charge_mana_until(Options.AutoChargeThreshold.Value)
                        end

                        ------------------------------------------------------------
                        -- TRAIN CLIMB MODE
                        ------------------------------------------------------------
                        if Toggles.train_climb and Toggles.train_climb.Value then
                            if Toggles.AutoCharge and Toggles.AutoCharge.Value then
                                Toggles.AutoCharge:SetValue(false)
                            end

                            utility:charge_mana_until(100)
                            repeat
                                vim:SendKeyEvent(true, "Space", false, game)
                                adjusted_wait(0.05)
                                vim:SendKeyEvent(false, "Space", false, game)
                                adjusted_wait(0.05)
                            until mana.Value == 0 or not Toggles.train_climb.Value
                        end
                    end
                end)
            end

            local character = plr.Character or plr.CharacterAdded:Wait()
            apply_auto_charge(character)
            utility:Connection(plr.CharacterAdded, apply_auto_charge)
        end


        do -- Loop Gain Orderly
            while shared and not shared.is_unloading and task.wait(0.6) do
                if plr.Backpack and plr.Character and not cs:HasTag(plr.Character, "Danger") and shared and Toggles and Toggles.loop_orderly and Toggles.loop_orderly.Value then
                    local elixir = plr.Backpack:FindFirstChild("Tespian Elixir")
                    if elixir then
                        plr.Character.Humanoid:EquipTool(elixir)
                        task.wait(0.1)
        
                        local equippedElixir = plr.Character:FindFirstChild("Tespian Elixir")
                        if equippedElixir and equippedElixir:FindFirstChild("RemoteEvent") then
                            equippedElixir.RemoteEvent:FireServer(plr.Character.HumanoidRootPart.CFrame, "Part", "Self")
                            task.wait(1.5)
                            plr.Character:BreakJoints()
                            
                            repeat task.wait(0.5)
                            until plr.Character:FindFirstChild("Immortal")
                        end
                    end
                end
            end
        end
    end
    end, function(err)
        return debug.traceback(err, 2)
    end)

    if not success then
        warn("[hydroxide.sol] Script error:", err)
    end
end