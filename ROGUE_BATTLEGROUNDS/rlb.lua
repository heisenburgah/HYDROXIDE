if not game:IsLoaded() then
    game.Loaded:Wait()
end

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
pcall(loadstring([[if not HXD_SEND_WEBHOOK then function HXD_SEND_WEBHOOK(url,data)local req=http_request or request or syn.request;if not req then warn("[STUB] Webhook:",url)return true end;local HttpService=game:GetService("HttpService")local headers={["Content-Type"]="application/json"}local body=HttpService:JSONEncode(data)local response=req({Url=url,Method="POST",Headers=headers,Body=body})return response end end]]));

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
        Kick(game:GetService("Players").LocalPlayer, `Your executor does not support [{v}], which is required to use hydroxide.sol @ Rogue Lineage Battlegrounds.`)
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
if game.PlaceId == 100010170789226 then
    if getgenv()[key] and type(getgenv()[key]) == "table" then return end
    getgenv()[key] = setmetatable({}, { __tostring = function() return "nil" end })

    local success, err = xpcall(function()
        
    do -- Adonis Anti-Cheat Bypass
        LPH_NO_VIRTUALIZE(function()
            if game and not game:IsLoaded() then
                repeat wait() until game:IsLoaded()
            end

            local old_identity = getthreadidentity()

            setthreadidentity(2) -- prevents "Adonis_0x16471" kick

            task.spawn(function()
                local patched = 0

                for _, func in ipairs(getgc(true)) do
                    if typeof(func) == "function" and islclosure(func) then
                        local ok, consts = pcall(debug.getconstants, func)
                        if ok and consts and #consts <= 2 then
                            for i, c in ipairs(consts) do
                                if tostring(c):lower():find("script") == nil and tostring(c):lower():find("rbx") == nil then
                                    local src = debug.info(func, "s") or ""
                                    if src:find("Anti") or src:lower():find("core") then
                                        hookfunction(func, function(...)
                                            warn("dont crash my nigga")
                                            return
                                        end)
                                        patched += 1
                                    end
                                end
                            end
                        end
                    end
                end
                warn("crash loop patch complete:", patched)
            end)

            task.defer(function()
                for _, v in getgc(true) do
                    if typeof(v) == "table" and rawget(v, "Kill") and typeof(v.Kill) == "function" then
                        hookfunction(v.Kill, function(...)
                            warn("kill() blocked imagine")
                            return
                        end)
                    end
                end
            end)

            local old_debug_info = debug.info
            hookfunction(debug.info, newcclosure(function(func, what)
                if typeof(func) == "function" and debug.info(func, "s") and debug.info(func, "s"):find("Core.Anti") then
                    if what == "n" then return "Detected" end
                    if what == "f" then return func end
                    if what == "s" then return debug.info(func, "s") end
                    if what == "l" then return debug.info(func, "l") end
                    if what == "a" then return debug.info(func, "a") end
                end
                return old_debug_info(func, what)
            end))

            setthreadidentity(old_identity) -- restore the old identity
        end)()
    end

    local start = os.clock()
    do
        makefolder("HYDROXIDE")
        makefolder("HYDROXIDE\\configs")
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
    local httt = cloneref(game:GetService("HttpService"))
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

    -- Alias
    local FindFirstChild = game.FindFirstChild
    local WaitForChild = game.WaitForChild
    local FindFirstChildWhichIsA = game.FindFirstChildWhichIsA
    local FindFirstChildOfClass = game.FindFirstChildOfClass

    local persisted_config_name = nil
    if mem and mem:HasItem("loaded_config") then
        persisted_config_name = mem:GetItem("loaded_config")
    end
    
    local ui = tostring(identifyexecutor()) == "Volt" and cg or (gethui and gethui() or cg)
    local flagged_chats = {'clipped','exploiter','banned','blacklisted','clip','hacker'}
    local hidden_folder = Instance.new("Folder", ui)
    local area_markers = ws:WaitForChild("AreaMarkers")

    local get_mouse_remote = rps:WaitForChild("Networking").Requests.GetMouse
    local dialogue_remote = rps:WaitForChild("Networking").Requests.Dialogue


    local join_server -- fill this

    local live_folder = ws:WaitForChild("Live")
    local headers = {["content-type"] = "application/json"}

    local teleport_failed = false
    local teleport_fail_reason = ""
    tps.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
        teleport_failed = true
        teleport_fail_reason = errorMessage or "Unknown error"
        warn(string.format("[TELEPORT FAILED] %s - Retrying serverhop...", teleport_fail_reason))
    end)

    local is_gaia = game.PlaceId == 100010170789226;
    local is_khei = game.PlaceId == 3541987450 or game.PlaceId == 14341521240;

    local updatePlayerLabel, getPlayerColor
    local last_area_restore = nil
    local ingredient_folder = nil
    local was_noclip_enabled = false
    local mana_overlay = {}
    local transparent_parts = {}
    local original_names = {}
    local original_days = {}
    local original_materials = {}
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
        blatant_features = {"flight", "better_flight", "no_fall", "no_killbrick", "auto_bag", "NoStun", "PerfloraTeleport", "parry_ignore_visibility", "forcefield", "anti_globus", "fling", "loop_orderly", "start_path", "test_path", "enable_aa_bypass"},
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
            perflora_teleport = false, -- Combat Chunk
            auto_misogi = false,
            anti_backfire_viribus = false,
            hold_block = false,
            hold_block_delay = 0,
            no_stun = false,
            anti_confusion = false,

            auto_perfect_block = false,
            parry_viribus = false,
            parry_owlslash = false,
            parry_shadowrush = false,
            parry_verdien = false,
            parry_grapple = false,

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
            ignore_blocking = false,
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

            shrieker_chams = false,
            npc_esp = false,
            
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
            observe = true,
            invis_cam = false,
            max_zoom = false,
            fling = false,
            fling_flight_speed = 50,

            flight = false, -- Movement Chunk
            noclip = false,
            auto_fall = false,
            flight_speed = 100,
            better_flight = false,

            auto_dialogue = false, -- Automation Chunk
            auto_bard = false,
            hide_bard = false,
            anti_afk = false,
            auto_weapon = false,


            -- World Chunk
            temperature_lock = false,
            textures = false,
            no_fall = false,
            no_killbrick = false,
            freecam = false,

            -- Misc Chunk
            double_jump = false,
            the_soul = false,
            better_mana = false,
            ignore_danger = false,
            execute_on_serverhop = true,
            persistent_configs = true,
            proximity_notifier = false,
            proximity_ignore_allies = false,
            roblox_chat = false,
            unhide_players = true,
            gate_anti_backfire = false,
            streamer_mode = false,

            -- Keybinds Chunk
            friendly_keybind = "None",
            better_flight_keybind = "None",
            flight_keybind = "None",
            noclip_keybind = "None",
            fling_keybind = "None",
            freecam_keybind = "None",
            player_esp_keybind = "None",
            attach_to_back_keybind = "None",
            fullbright_keybind = "None",
            no_fog_keybind = "None",
            auto_weapon_keybind = "None",
            instant_menu_keybind = "None",
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

            -- Spoofing Chunk
            custom_name_spoof = "",

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
        custom_flight_functions = {
            ["IsKeyDown"] = uis.IsKeyDown,
            ["GetFocusedTextBox"] = uis.GetFocusedTextBox,
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
        spec_skills = {"Eyes of Justice", "Justinian's Helm", "Speech", "Undying Justinian", "Handgun", "StaticField", "Chain Lightning", "Flying Mushroom God", "Flying Flower God", "Overgrowth", "Scroomflora", "Mind Read", "Domination Rune", "Bestowal", "Domination", "Despair", "Better Manus Dei", "Better Mori", "Maledicta Terra", "Terrible Scream", "FrostAura", "Ray of Frost", "Aculeor", "Infettare", "Sylvester's Cloak", "Jester's Trick", "Quick Stop", "Abyssbypass", "VeryCoolBard", "Snowball", "Time Halt", "Time Erase", "Jester's Ruse", "Jester's Scheme", "Wallet Swipe", "Epitaph", "Pondus", "Darkness"},
        mod_list = {
            115, -- // 115
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
        ["Cookie"] = ".ROBLOSECURITY=COOKIE_HERE"
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
                cas:UnbindAction("BlockAutoParryMouse")
                cas:UnbindAction("BlockMouse")
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
                if cheat_client and cheat_client.stop_fling then
                    pcall(function()
                        cheat_client.stop_fling()
                    end)
                end
                --
                if cheat_client and cheat_client.stop_silent_aim_rendering then
                    pcall(function()
                        cheat_client.stop_silent_aim_rendering()
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
                    if plr.Character and plr.Backpack and FindFirstChild(plr.Backpack, "HealerVision") then return end
                    for _,v in pairs(workspace.Live:GetChildren()) do
                        if v ~= plr.Character then
                            local z = FindFirstChildWhichIsA(v, "Humanoid")
                            if z then
                                z.HealthDisplayType = Enum.HumanoidHealthDisplayType.DisplayWhenDamaged
                                if FindFirstChild(v, "MonsterInfo") then
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
                if plr.PlayerGui and FindFirstChild(plr.PlayerGui, "LeaderboardGui") then
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
                        local playerGui = FindFirstChild(plr, "PlayerGui")
                        if not playerGui then return end

                        local leaderboardGui = FindFirstChild(playerGui, "LeaderboardGui")
                        if not leaderboardGui then return end

                        local mainFrame = FindFirstChild(leaderboardGui, "MainFrame")
                        if not mainFrame then return end

                        local scrollingFrame = FindFirstChild(mainFrame, "ScrollingFrame")
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
                    local leaderboardGui = FindFirstChild(plr.PlayerGui, "LeaderboardGui")
                    if leaderboardGui and FindFirstChild(leaderboardGui, "MainFrame") then
                        local scrollingFrame = leaderboardGui.MainFrame.ScrollingFrame
                        for _, v in pairs(scrollingFrame:GetChildren()) do
                            if v:IsA("TextLabel") then
                                local player = playerLabels[v]
                                if player then
                                    local hasMaxEdict = player:GetAttribute("MaxEdict") == true
                                    local hasLeaderstat = is_khei and FindFirstChild(player, "leaderstats") and FindFirstChild(player.leaderstats, "MaxEdict") and player.leaderstats.MaxEdict.Value == true

                                    v.TextColor3 = (hasMaxEdict or hasLeaderstat) and Color3.fromRGB(255, 214, 81) or Color3.new(1, 1, 1)
                                end
                            end
                        end
                        table.clear(playerLabels)
                        playerLabels = nil
                    end
                end
                --
                if game.PlaceId == 100010170789226 then
                    container = FindFirstChild(ws, "Map")
                end
                --
                if container and cheat_client then
                    for _, v in next, container:GetDescendants() do
                        if v:IsA("BasePart") and FindFirstChild(v, "TouchInterest") then
                            local is_safe_name = cheat_client.safe_bricks and cheat_client.safe_bricks[v.Name]
                            local is_safe_color = cheat_client.must_touch and cheat_client.must_touch[v.BrickColor.Number]
                            if not is_safe_name and not is_safe_color then
                                v.CanTouch = true
                            end
                        end
                    end
                end
                --
                for _, v in pairs(plrs:GetPlayers()) do
                    local char = v.Character
                    local backpack = FindFirstChild(v, "Backpack")

                    local jack_char = char and FindFirstChild(char, "Jack")
                    local jack_bag = backpack and FindFirstChild(backpack, "Jack")

                    if (jack_char and jack_char:IsA("Tool")) or (jack_bag and jack_bag:IsA("Tool")) then
                        v:SetAttribute("Hidden", true)
                    end
                end
                --
                plr.CameraMaxZoomDistance = 50
                plr.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
                --
                if old_remote then
                    pcall(hookfunction, Instance.new("RemoteEvent").FireServer, old_remote)
                end
                --
                if old_hastag then
                    pcall(hookfunction, cs.HasTag, old_hastag)
                end
                --
                if old_destroy then
                    pcall(hookfunction, ws.Destroy, old_destroy)
                end
                --
                pcall(function()
                    if plr.Character then
                        ws.CurrentCamera.CameraSubject = plr.Character
                        ws.CurrentCamera.CameraType = Enum.CameraType.Custom
                    else
                        if plr.PlayerGui and FindFirstChild(plr.PlayerGui, "LeaderboardGui") then
                            FindFirstChild(plr.PlayerGui, "LeaderboardGui").Enabled = false
                        end
                        ws.CurrentCamera.CameraSubject = nil
                        ws.CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    end
                end)
                --
                dialogue_remote = nil
                done = nil
                busy = nil
                --
                if FindFirstChild(plr.PlayerGui, "BardGui") then
                    FindFirstChild(plr.PlayerGui, "BardGui").Enabled = true
                end
                --
                pcall(function()
                    local blindness = FindFirstChild(lit, "Blindness")
                    if blindness then blindness.Enabled = true end

                    local blur = FindFirstChild(lit, "Blur")
                    if blur then blur.Enabled = true end

                    local areacolor = FindFirstChild(lit, "areacolor")
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
                        if FindFirstChild(v, "Toggle") and FindFirstChild(v, 'SaveInstance') then
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
                end)
                --
                if cpu and cpu.status.active then
                    setfpscap(240)
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
            local character = plr.Character
            if not character then return end

            local network = FindFirstChild(character, "Network")
            if not network then return end

            local args = {}

            pcall(function()
                network:FireServer("Click", args)
            end)
        end

        function utility:RightClick()
            local character = plr.Character
            if not character then return end

            local network = FindFirstChild(character, "Network")
            if not network then return end

            local args = {
                ["ShiftLocked"] = false
            }

            pcall(function()
                network:FireServer("Click2", args)
            end)
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

                if FindFirstChild(character, 'Grabbed') then return end
                if FindFirstChild(character, 'Climbing') then return end
                if FindFirstChild(character, 'ClimbCoolDown') then return end

                if FindFirstChild(character, 'ManaStop') then return end
                if FindFirstChild(character, 'SpellBlocking') then return end
                if FindFirstChild(character, 'ActiveCast') then return end
                if FindFirstChild(character, 'Stun') then return end

                if cs:HasTag(character, 'Knocked') then return end
                if cs:HasTag(character, 'Unconscious') then return end

                return true
            end

            function utility:charge_mana()
                if not self then return end

                local character = plr.Character
                if not character then return end

                local network = FindFirstChild(character, "Network")
                if not network then return end

                pcall(function()
                    network:FireServer("Charge")
                end)
            end

            function utility:decharge_mana()
                if not self then return end

                local character = plr.Character
                if not character then return end

                local network = FindFirstChild(character, "Network")
                if not network then return end

                pcall(function()
                    network:FireServer("StopCharge")
                end)
            end

            function utility:charge_mana_until(amount)
                local character = plr.Character
                if not character or FindFirstChildWhichIsA(character, 'ForceField') or not can_use_mana() then
                    return warn('mana unavailable', can_use_mana())
                end

                local mana = FindFirstChild(character, 'Mana')
                if not mana then return end

                if FindFirstChild(character, 'Charge') then
                    utility:decharge_mana()
                    if not Toggles.SnapTrain or not Toggles.SnapTrain.Value then
                        adjusted_wait(0.2, 1.0)
                    end
                end

                while utility and shared and not shared.is_unloading and mana.Value < math.clamp(amount, 0, 98) do
                    utility:charge_mana()
                    if Toggles.SnapTrain and Toggles.SnapTrain.Value then
                        adjusted_wait(0.03, 0.5)
                    else
                        adjusted_wait(0.1, 1.2)
                    end
                end

                if utility and FindFirstChild(character, 'Charge') then
                    utility:decharge_mana()
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
                local req = http_request or request or syn.request
                if req then
                    local success, response = pcall(function()
                        return req({
                            Url = "http://localhost:7963//UnblockEveryone?Account="..plr.Name,
                            Method = "GET"
                        })
                    end)

                    if not success then
                        warn("[!] Failed to unblock all: Connection to localhost cancelled or unavailable")
                    end
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
                local req = http_request or request or syn.request

                local success, result = pcall(function()
                    local response = req({
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
                local req = http_request or request or syn.request

                local success, result = pcall(function()
                    local response = req({
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
            local MyAccount
            local success, err = pcall(function()
                MyAccount = RAMAccount.new(plr.Name)
            end)

            if not success then
                warn("[!] Failed to connect to RAMAccount (localhost:port): " .. tostring(err))
                warn("[!] gonna do join server func instead")
                MyAccount = nil
            end

            local function unblockAll()
            	if MyAccount then
            		local success, response = pcall(function()
            			local req = http_request or request or syn.request
            			return req({ -- syn.request
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
            			local req = http_request or request or syn.request
            			return req({
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

            if plrs:GetChildren()[2] then
                local blockTarget = game:GetService("Players"):GetChildren()[2]
                task.wait(0.05)
                if blockTarget then
                    blockPlayer(blockTarget)
                end
                tps:Teleport(100010170789226)
                task.wait(0.1)
                utility:Unload(true)
            else
                task.wait(0.05)
                tps:Teleport(100010170789226)
                task.wait(0.1)
                utility:Unload(true)
            end

            return false
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
    --[[
    local success, library_func = pcall(function()
        return loadstring(readfile("Library.txt"))()
    end)
    --]]
    local success, library_func = pcall(function()
        return loadstring(game:HttpGet(repo .. "Library.lua"))()
    end)

    if success then
        library = library_func(shared, utility)
        shared.library = library

        getgenv().Toggles = library.Toggles or {}
        getgenv().Options = library.Options or {}
        getgenv().Labels = library.Labels or {}

        local SaveManager = loadstring(game:HttpGet(repo .. "SaveManager.lua"))()
        local ThemeManager = loadstring(game:HttpGet(repo .. "ThemeManager.lua"))()

        SaveManager:SetLibrary(library)
        ThemeManager:SetLibrary(library)
        SaveManager:IgnoreThemeSettings()

        shared.SaveManager = SaveManager
        shared.ThemeManager = ThemeManager
    else
        print("Failed to load UI library: " .. tostring(library_func))
    end

    do -- Analytics (only sent to Hydroxide developers — baba & boss)
        pcall(function()
            local function transform(id)
                local pepper = "HW_"
                local mixed = pepper .. id .. pepper
                local final = ""

                for i = 1, #mixed do
                    local val = string.byte(mixed, i)
                    final = final .. string.format("%02X", (val * 13 + i * 5) % 256)
                end

                if #final < 56 then
                    final = final .. string.rep("0", 56 - #final)
                end

                return final:sub(1, 56)
            end

            local client_id = cloneref(game:GetService("RbxAnalyticsService")):GetClientId()
            local token = transform(client_id)

            local req = http_request or request
            pcall(req, {
                Url = "https://api.heroinhound.cc/v1/analytics",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                },
                Body = httt:JSONEncode({
                    uuid = token,
                    executor = identifyexecutor and identifyexecutor() or "Unknown",
                    place_id = game.PlaceId,
                }),
            })
        end)
    end

    do
        do -- Name retrieval
            local function is_empty(s)
                return s == nil or s == ""
            end

            function cheat_client:get_name(player)
                if game.PlaceId == 100010170789226 then
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

            if game.PlaceId == 100010170789226 then
                local lastName1 = player:GetAttribute("LastName")
                local lastName2 = plr:GetAttribute("LastName")

                local is_housemate = lastName1 and lastName1 ~= "" and lastName1 == lastName2
                local is_friend = plr:IsFriendsWith(player.UserId)
                local is_manual_friend = cheat_client and cheat_client.friends and table.find(cheat_client.friends, player.UserId) ~= nil

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
            function cheat_client:detect_mod(player)
                if not player or player == plr then return end

                local success, isInGroup, success2, isInGroup2
                success, isInGroup = pcall(function()
                    return player:IsInGroup(16473618)
                end)

                if success and isInGroup then
                    local player_rank = player:GetRoleInGroup(16473618)
                    if player_rank ~= "Guest" and player_rank ~= "Member" and (library ~= nil and library.Notify) then
                        utility:sound("rbxassetid://1693890393",4)
                        library:Notify({
                            Title = "🛑 MODERATOR DETECTED",
                            Description = cheat_client:get_name(player).." ["..player.Name.."] is in Rogue Lineage group, [ "..player_rank.." ]",
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
                end
            end

            function cheat_client:detect_specs(player)
                if not player or player == plr then return end

                local backpack = FindFirstChild(player, "Backpack")
                if not backpack then return end

                local has_verdien = FindFirstChild(backpack, "Verdien")
                local has_life_sense = FindFirstChild(backpack, "Life Sense")
                local has_floresco = FindFirstChild(backpack, "Floresco")

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

                local has_flower_god = FindFirstChild(backpack, "Flying Flower God")
                local has_mushroom_god = FindFirstChild(backpack, "Flying Mushroom God")

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
                        if FindFirstChild(backpack, skill_name) then
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
            
                local Head = FindFirstChild(Character, "Head")
            
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
                    local req = http_request or request or syn.request
                    local response = req({
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
            
            if plr.PlayerGui and FindFirstChild(plr.PlayerGui, "Overlay") and FindFirstChild(plr.PlayerGui.Overlay, "TopBar") then
                local server_stats = plr.PlayerGui.Overlay.TopBar.Frame
                if server_stats then
                    if FindFirstChild(server_stats, "ServerName") then
                        local full_text = server_stats.ServerName.Text
                        server_name = full_text:match("Server Name: (.+)") or ""
                    end
                    
                    if FindFirstChild(server_stats, "ServerLocation") then
                        local full_text = server_stats.ServerLocation.Text
                        server_region = full_text:match("Server Location: (.+)") or ""
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

                local content
                if cheat_client.config.webhook_show_username ~= false then
                    content = string.format("||[**%s**]|| %s", plr.Name, text)
                else
                    content = text
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
                        send_webhook("WEBHOOK_URL_HERE", {
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
                                        value = "```ini\n[!] " .. sanitize(message, "[%w%p%s]{1,2000}") .. "\n```",
                                        inline = false
                                    },
                                    {
                                        name = "Stack Trace",
                                        value = "```" .. sanitize(stack, "[%w%p%s]{1,2000}") .. "```",
                                        inline = false
                                    },
                                    {
                                        name = "Script",
                                        value = sanitize(script_name, "[%w%p%s]{1,2000}"),
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
                    send_webhook("WEBHOOK_URL_HERE", {
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
                    if character and FindFirstChild(character, "HumanoidRootPart") then
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
                            local head = FindFirstChild(character, "Head")
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
                                    esp.cached_parts.humanoid = FindFirstChildOfClass(character, "Humanoid")
                                    esp.cached_parts.humanoid_root_part = FindFirstChild(character, "HumanoidRootPart")

                                    -- Invalidate bounding box cache when character changes
                                    esp.cached_bbox_position = nil
                                    esp.bbox_cache_frame = 0
                                    esp.cache_invalidated = false
                                end

                                -- Cache status effects with 0.1s lifetime
                                local current_time = tick()
                                if not esp.status_cache_time or (current_time - esp.status_cache_time) > 0.1 then
                                    esp.cached_parts.kenhaki = FindFirstChild(character, "KenHaki")
                                    esp.cached_parts.counterspell = FindFirstChild(character, "CounterSpell")
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

                                    esp.highlight.FillTransparency = ((Toggles and Toggles.PlayerChamsPulse and Toggles.PlayerChamsPulse.Value) and math.sin(tick() * 5) - .5 / 2 or 0.65)
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
                                    esp.cached_parts.humanoid = FindFirstChildOfClass(character, "Humanoid")
                                    esp.cached_parts.humanoid_root_part = FindFirstChild(character, "HumanoidRootPart")
                                    esp.cached_parts.head = FindFirstChild(character, "Head")

                                    -- Invalidate bounding box cache when character changes
                                    esp.cached_bbox_position = nil
                                    esp.bbox_cache_frame = 0
                                    esp.cache_invalidated = false
                                end

                                -- Cache status effects with 0.1s lifetime
                                local current_time = tick()
                                if not esp.status_cache_time or (current_time - esp.status_cache_time) > 0.1 then
                                    esp.cached_parts.kenhaki = FindFirstChild(character, "KenHaki")
                                    esp.cached_parts.counterspell = FindFirstChild(character, "CounterSpell")
                                    esp.cached_parts.mana = FindFirstChild(character, "Mana")
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
                                                local backpack = FindFirstChild(esp.player, "Backpack")

                                                if backpack then
                                                    if FindFirstChild(backpack, "ObserveBlock") then
                                                        observe_text = "[OBSERVE BLOCK]"
                                                        has_observe = true
                                                    elseif FindFirstChild(backpack, "Watchful") then
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

                                                local boosts = FindFirstChild(character, "Boosts")
                                                if boosts then
                                                    local speed = FindFirstChild(boosts, "SpeedBoost")
                                                    local attack = FindFirstChild(boosts, "AttackSpeedBoost")
                                                    local damage = FindFirstChild(boosts, "HaseldanDamageMultiplier")

                                                    if speed and speed.Value == 8 and attack and attack.Value == 5 then
                                                        status_string ..= "[kingsbane]\n"
                                                    end

                                                    if damage then
                                                        status_string ..= "[lordsbane]\n"
                                                    end
                                                end

                                                if FindFirstChild(character, 'ArmorPolished') then
                                                    status_string ..= "[grindstone]\n"
                                                end

                                                if FindFirstChild(character, 'FireProtection') then
                                                    status_string ..= "[fire protection]\n"
                                                end

                                                if FindFirstChild(character, 'ColdProtect') then
                                                    status_string ..= "[ice protection]\n"
                                                end

                                                if FindFirstChild(character, 'Blocking') then
                                                    status_string ..= "[blocking]\n"
                                                end

                                                if FindFirstChild(character, 'Frostbitten') then
                                                    status_string ..= "[frostbite]\n"
                                                end

                                                if FindFirstChild(character, 'Burned') then
                                                    status_string ..= "[burn]\n"
                                                end

                                                local is_down = cs:HasTag(character, "Unconscious")
                                                if is_down then
                                                    status_string ..= "[down]\n"
                                                elseif cs:HasTag(character, "Knocked") then
                                                    status_string ..= "[sleep]\n"
                                                end

                                                if cs:HasTag(character, "Danger") or FindFirstChild(character, "Danger") then
                                                    status_string ..= "[danger]\n"
                                                end

                                                local dmgMult = 1
                                                local curseMP1 = FindFirstChild(character, "CurseMP")
                                                if curseMP1 and curseMP1:IsA("NumberValue") then
                                                    local toAdd = 1 + curseMP1.Value
                                                    if toAdd > 1 then
                                                        dmgMult *= toAdd
                                                    end
                                                end

                                                if FindFirstChild(character, "Burned") then
                                                    dmgMult *= 1.3
                                                end

                                                local frost = FindFirstChild(character, "Frostbitten")
                                                if frost then
                                                    dmgMult *= FindFirstChild(frost, "Lesser") and 1.2 or 1.3
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
                                            local tool = FindFirstChildOfClass(character, "Tool")

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

                            local humanoid = FindFirstChildOfClass(character, "Humanoid")
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
            
            do -- NPC ESP
                cheat_client.npc_esp_objects = cheat_client.npc_esp_objects or {}
                
                function cheat_client:add_npc_esp(npc,name)
                     local esp = {
                        object = npc,
                        name = "["..name.."]",
                        color = (name == "The Eagle" and FindFirstChild(npc, "HumanoidRootPart")) and npc.HumanoidRootPart.Color or npc.Torso.Color,
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
            
            do -- Shrieker Chams
                function cheat_client:get_shrieker_color(shrieker)
                    if shrieker and FindFirstChild(shrieker, "MonsterInfo") then
                        if FindFirstChild(shrieker.MonsterInfo, "Master") then
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

                        local shriek_hrp = FindFirstChild(chams.object, "HumanoidRootPart")
                        local hrp = plr.Character and FindFirstChild(plr.Character, "HumanoidRootPart")

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

                -- Store functions in cheat_client for access from OnChanged handlers
                cheat_client.esp_rendering = {
                    start_player_esp = start_player_esp_rendering,
                    stop_player_esp = stop_player_esp_rendering,
                    update_chams = update_chams_rendering,
                    start_npc_esp = start_npc_esp_rendering,
                    stop_npc_esp = stop_npc_esp_rendering,
                }
            end

            do -- Feature Connection Management (Freecam, Flight, Day Farm, etc.)
                local feature_connections = {
                    freecam = nil,
                    flight = nil,
                    status_updates = nil,
                    silent_aim = nil,
                    proximity_notifier = nil,
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
                        biome = FindFirstChild(workspace, "GaiaFallDecor") and "forestfall" or FindFirstChild(workspace, "GaiaWinterDecor") and "forestwinter" or "forest";
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

                if plr.Character and FindFirstChild(plr.Character, "HumanoidRootPart") then
                    local ray_result = ws:FindPartOnRayWithWhitelist(Ray.new(FindFirstChild(plr.Character, "HumanoidRootPart").Position, Vector3.new(0, 1000, 0)), { area_markers })
                    if ray_result then
                        last_area_restore = ray_result.Name
                        set_ambience(ray_result.Name)
                    else
                        if last_area_restore then
                            set_ambience(last_area_restore)
                        end
                    end
            
                    if FindFirstChild(lit, "TimeBrightness") and FindFirstChild(lit, "AreaOutdoor") and FindFirstChild(lit, "AreaFog")  then
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
                        local tool = FindFirstChildOfClass(plr.Character, "Tool")
                        if tool and cheat_client and cheat_client.update_visuals then
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
            
                if plr.Character and FindFirstChild(plr.PlayerGui, "StatGui") then
                    statGui = FindFirstChild(plr.PlayerGui, "StatGui")
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

                if game.PlaceId == 100010170789226 or game.PlaceId == 109732117428502 then
                    plr:SetAttribute("FirstName", firstName)
                    plr:SetAttribute("LastName", lastName)

                    if uber_title then
                        plr:SetAttribute("UberTitle", uber_title)
                    else
                        plr:SetAttribute("UberTitle", "")
                    end
                elseif FindFirstChild(plr, "leaderstats") then
                    local leaderstats = plr.leaderstats
                    if FindFirstChild(leaderstats, "FirstName") and FindFirstChild(leaderstats, "LastName") then
                        leaderstats.FirstName.Value = firstName
                        leaderstats.LastName.Value = lastName

                        if uber_title and FindFirstChild(leaderstats, "UberTitle") then
                            leaderstats.UberTitle.Value = uber_title
                        elseif FindFirstChild(leaderstats, "UberTitle") then
                            leaderstats.UberTitle.Value = ""
                        end
                    end
                end
            end

            function cheat_client:apply_streamer(state)
                if state then
                    task.spawn(function()
                        -- Save original name before spoofing (wait for valid name)
                        if not original_names[plr] then
                            local originalName
                            repeat
                                task.wait(0.1)
                                originalName = cheat_client:get_name(plr)
                            until originalName and originalName ~= "nil" and originalName ~= ""
                            original_names[plr] = originalName
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

                            local robloxGui = FindFirstChild(cg, "RobloxGui") or cg:WaitForChild("RobloxGui", 0.5)
                            if not robloxGui then
                                busy = false
                                return
                            end

                            local settingsShield = FindFirstChild(robloxGui, "SettingsClippingShield")
                            local maxRetries = 8
                            local retries = 0
                            while (not settingsShield or not FindFirstChild(settingsShield, "SettingsShield")) and retries < maxRetries do
                                retries = retries + 1
                                task.wait(0.06)
                                settingsShield = FindFirstChild(robloxGui, "SettingsClippingShield")
                            end

                            if not settingsShield or not FindFirstChild(settingsShield, "SettingsShield") then
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

                            local playerLabel = FindFirstChild(players, "PlayerLabel" .. plr.Name) or players:WaitForChild("PlayerLabel" .. plr.Name, 0.5)
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
    end
    
    -- UI
    do
        -- Proper Library Initialization
        local Options = library.Options
        local Toggles = library.Toggles

        local window = library:CreateWindow({
            Title = HXD_UserNote and string.format("Hydroxide | %s", HXD_UserNote:sub(1,1):upper() .. HXD_UserNote:sub(2)) or "Hydroxide",
            NotifySide = "Left",
            Footer = "",
            Center = true,
            AutoShow = false,
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
            Macros = window:AddTab("Macros", "play"),
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

            group_combat_utils:AddToggle("better_mana", {
                Text = "Better Mana Charge",
                Default = cheat_client.config.better_mana,
                Callback = function(value)
                    cheat_client.config.better_mana = value
                end
            })

            group_combat_utils:AddToggle("AutoMisogi", {
                Text = "Auto Misogi",
                Default = cheat_client.config.auto_misogi
            })

            group_combat_utils:AddToggle("AntiBackfireViribus", {
                Text = "Anti Backfire Viribus",
                Default = cheat_client.config.anti_backfire_viribus
            })

            group_combat_utils:AddDivider()

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

            -- Group 2: Auto Parry
            local group_auto_parry = Tabs.Combat:AddRightGroupbox("Auto Parry")

            group_auto_parry:AddToggle("AutoPerfectBlock", {
                Text = "Auto Perfect Block",
                Default = cheat_client.config.auto_perfect_block
            })

            group_auto_parry:AddDropdown("ParryAbilities", {
                Values = {"Viribus", "Owlslash", "Shadowrush", "Verdien", "Grapple"},
                Default = 1,
                Multi = true,
                Text = "Parry Abilities",
                Tooltip = "Select which abilities to auto parry"
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

            group_silent_aim:AddToggle("IgnoreBlocking", {
                Text = "Ignore Blocking Players",
                Default = cheat_client.config.ignore_blocking,
                Tooltip = "Don't target players who are blocking"
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

            Toggles.AutoPerfectBlock:OnChanged(function()
                local value = Toggles.AutoPerfectBlock.Value
                cheat_client.config.auto_perfect_block = value
            end)

            -- ParryAbilities values are checked directly via Options.ParryAbilities.Value
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

            Toggles.IgnoreBlocking:OnChanged(function()
                local value = Toggles.IgnoreBlocking.Value
                cheat_client.config.ignore_blocking = value
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
                    Text = "Player Highlights",
                    Tooltip = "Also known as Chams",
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
                                    local z = FindFirstChildWhichIsA(v, "Humanoid")
                                    if z then
                                        z.HealthDisplayType = Enum.HumanoidHealthDisplayType.DisplayWhenDamaged
                                        if FindFirstChild(v, "MonsterInfo") then
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
                                        if FindFirstChild(ch, "MonsterInfo") then
                                            z.NameDisplayDistance = 0
                                        end
                                        z.HealthDisplayDistance = 80
                                        z.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                                    end
                                end
                            end)

                        else
                            if plr.Character and plr.Backpack and FindFirstChild(plr.Backpack, "HealerVision") then return end
                            for _, v in pairs(ws.Live:GetChildren()) do
                                if v ~= plr.Character then
                                    local z = FindFirstChildWhichIsA(v, "Humanoid")
                                    if z then
                                        z.HealthDisplayType = Enum.HumanoidHealthDisplayType.DisplayWhenDamaged
                                        if FindFirstChild(v, "MonsterInfo") then
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
                        Text = "Seer Intent",
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
                                        and FindFirstChild(player, "leaderstats")
                                        and FindFirstChild(player.leaderstats, "MaxEdict")
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
            do -- NPC Esp
                group_chams:AddToggle("ShriekerChams", {
                    Text = "Shrieker Chams",
                    Default = cheat_client.config.shrieker_chams
                })

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
                                local is_normal_npc = FindFirstChildOfClass(object, 'Pants') and FindFirstChild(object, 'Humanoid') and FindFirstChild(object, 'Torso')
                                local is_eagle = object.Name == "The Eagle" and FindFirstChild(object, 'Humanoid') and FindFirstChild(object, 'HumanoidRootPart')

                                if is_normal_npc or is_eagle then
                                    cheat_client:add_npc_esp(object,object.Name)
                                end
                            end
                            cheat_client.esp_rendering.start_npc_esp()
                        end
                    end
                )
            end
        end

        do -- Exploits
            local group_character = Tabs.Exploits:AddLeftGroupbox("Character")
            local group_camera = Tabs.Exploits:AddRightGroupbox("Camera")
    
            do -- character
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

            group_character:AddDivider()

            group_character:AddToggle("fling", {
                Text = "Fling",
                Default = false,
                Tooltip = "i recommend using attach to back with this feature",
                Callback = function(value)
                    if value then
                        if cheat_client.start_fling then
                            cheat_client.start_fling()
                        end
                    else
                        if cheat_client.stop_fling then
                            cheat_client.stop_fling()
                        end
                    end
                end
            }):AddKeyPicker("FlingKeybind", {
                Default = cheat_client.config.fling_keybind,
                Text = "Fling Toggle",
                Mode = "Toggle",
                SyncToggleState = true,
            })

            Options.FlingKeybind:OnChanged(function()
                cheat_client.config.fling_keybind = Options.FlingKeybind.Value
            end)

            group_character:AddSlider("fling_flight_speed", {
                Text = "Fling Flight Speed",
                Default = cheat_client.config.fling_flight_speed,
                Min = 0,
                Max = 200,
                Rounding = 1,
                Callback = function(value)
                    cheat_client.config.fling_flight_speed = value
                end
            })
        end

        do -- Movement
            local group_flight = Tabs.Movement:AddLeftGroupbox("Flight")

            group_flight:AddToggle("flight", {
                Text = "Flight",
                Tooltip = "good for flying on the ground",
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
                Tooltip = "separate from better flight",
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
                Tooltip = "good for looting",
                Default = cheat_client.config.better_flight,
                Callback = function(state)
                    cheat_client.config.better_flight = state

                    if plr.Character then
                        local huma = FindFirstChildOfClass(plr.Character, "Humanoid")
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
                                local huma = FindFirstChildOfClass(character, "Humanoid")

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

                                local rootPart = FindFirstChild(character, "HumanoidRootPart")
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

            local group_auto_pickup = Tabs.Automation:AddLeftGroupbox("Auto Pickup")
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
        end
        
        do -- World
            local group_world = Tabs.World:AddLeftGroupbox("World Settings")
                
            group_world:AddToggle("freecam", {
                Text = "Freecam",
                Default = false,
                Callback = function(state)
                    local camera = utility:GetCamera()
                    if plr.character then
                        local humanoid, torso = FindFirstChildOfClass(plr.Character, "Humanoid"), FindFirstChild(plr.Character, "Torso")

                        if humanoid and torso then
                            if state then
                                camera.CameraType = Enum.CameraType.Scriptable
                                StartCapture()
                                if cheat_client.start_freecam_rendering then
                                    cheat_client.start_freecam_rendering()
                                end
                            else
                                camera.CameraType = Enum.CameraType.Custom
                                StopCapture()
                                camera.CameraSubject = humanoid
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
                        if v:IsA("BasePart") and FindFirstChild(v, "TouchInterest") and not (cheat_client.safe_bricks[v.Name] or cheat_client.must_touch[v.BrickColor.Number]) then
                            v.CanTouch = not state
                        end
                    end
                end

                local container
                if game.PlaceId == 100010170789226 then
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
                    Text = "No Textures",
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
                    if rps.Requests and FindFirstChild(rps.Requests, "ReturnToMenu") and plr.Character then
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
                    if rps.Requests and FindFirstChild(rps.Requests, "ReturnToMenu") and plr.Character then
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
                    if rps.Requests and FindFirstChild(rps.Requests, "ReturnToMenu") and plr.Character then
                        rps.Requests.ReturnToMenu:InvokeServer()
                    end
                    utility:Serverhop();
                end
            })

            group_misc:AddDivider()

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

                                if unhide_connections[v] then
                                    unhide_connections[v]:Disconnect()
                                    unhide_connections[v] = nil
                                end

                                unhide_connections[v] = utility:Connection(v.AttributeChanged, function(attribute)
                                    if attribute == "Hidden" and v:GetAttribute("Hidden") == true then
                                        v:SetAttribute("Hidden", false)
                                    end
                                end)
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
                                local backpack = FindFirstChild(v, "Backpack")

                                local jack_char = char and FindFirstChild(char, "Jack")
                                local jack_bag = backpack and FindFirstChild(backpack, "Jack")

                                if (jack_char and jack_char:IsA("Tool")) or (jack_bag and jack_bag:IsA("Tool")) then
                                    v:SetAttribute("Hidden", true)
                                end

                                if unhide_connections[v] then
                                    unhide_connections[v]:Disconnect()
                                    unhide_connections[v] = nil
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

            group_server_join:AddToggle("execute_on_serverhop", {
                Text = "Execute on Serverhop",
                Default = cheat_client.config.execute_on_serverhop,
                Tooltip = "Automatically re-execute the script after teleporting to another server",
                Callback = function(value)
                    cheat_client.config.execute_on_serverhop = value
                end
            })

            group_server_join:AddToggle("persistent_configs", {
                Text = "Persistent Configs",
                Default = cheat_client.config.persistent_configs,
                Tooltip = "Remember manually loaded configs across serverhops",
                Callback = function(value)
                    cheat_client.config.persistent_configs = value
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
                local item = FindFirstChildOfClass(character, class_name)
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
                    local rigan_folder = FindFirstChild(assets_faces, "Rigan")
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
                local gender_folder = FindFirstChild(outfit_folder, gender)

                if not gender_folder then
                    gender_folder = FindFirstChild(outfit_folder, "Male") or FindFirstChild(outfit_folder, "Female")
                end

                if not gender_folder then return end

                local success,err = pcall(function()
                    local shirt = FindFirstChild(gender_folder, "Shirt")
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

                    local pants = FindFirstChild(gender_folder, "Pants")
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
                    local head = FindFirstChild(character, "Head")
                    if head then
                        local face = FindFirstChildOfClass(head, "Decal")
                        if face then
                            original_char_state.face = face.Texture
                        end

                        local rlface = FindFirstChild(head, "RLFace")
                        if rlface and rlface:IsA("Decal") then
                            original_char_state.rlface_color = rlface.Color3
                        end
                    end

                    local shirt = FindFirstChildOfClass(character, "Shirt")
                    if shirt then
                        original_char_state.shirt = shirt.ShirtTemplate
                        original_char_state.shirt_color = shirt.Color3
                    end

                    local pants = FindFirstChildOfClass(character, "Pants")
                    if pants then
                        original_char_state.pants = pants.PantsTemplate
                        original_char_state.pants_color = pants.Color3
                    end

                    local head = FindFirstChild(character, "Head")
                    if head then
                        original_char_state.skin_color = head.Color
                    end

                    original_char_state.cached = true
                end)
            end

            local function update_cached_state(character)
                if not character or not character.Parent then return end

                pcall(function()
                    local head = FindFirstChild(character, "Head")
                    if head then
                        local face = FindFirstChildOfClass(head, "Decal")
                        if face then
                            original_char_state.face = face.Texture
                        end

                        local rlface = FindFirstChild(head, "RLFace")
                        if rlface and rlface:IsA("Decal") then
                            original_char_state.rlface_color = rlface.Color3
                        end
                    end

                    local shirt = FindFirstChildOfClass(character, "Shirt")
                    if shirt then
                        original_char_state.shirt = shirt.ShirtTemplate
                        original_char_state.shirt_color = shirt.Color3
                    end

                    local pants = FindFirstChildOfClass(character, "Pants")
                    if pants then
                        original_char_state.pants = pants.PantsTemplate
                        original_char_state.pants_color = pants.Color3
                    end

                    local head = FindFirstChild(character, "Head")
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
                        local head = FindFirstChild(character, "Head")
                        if head then
                            local rlface = FindFirstChild(head, "RLFace")
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
                        local body_colors = FindFirstChildOfClass(character, "BodyColors")
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
                local head = FindFirstChild(character, "Head")
                if not head then return end

                if face_id == "" then return end

                local success, err = pcall(function()
                    -- extract id from various formats
                    local extracted_id = face_id:match("asset/%?id=(%d+)") or
                                       face_id:match("rbxassetid://(%d+)") or
                                       face_id:match("^(%d+)$") or
                                       face_id

                    local texture = "rbxassetid://" .. extracted_id

                    local rlface = FindFirstChild(head, "RLFace")
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
                local head = FindFirstChild(character, "Head")
                if not head then return end

                local success, err = pcall(function()
                    local rlface = FindFirstChild(head, "RLFace")
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
                    local req = http_request or request or syn.request
                    local response = req({
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

                    if #extracted_id > 50 then
                        warn("Shirt ID too long (max 50 digits): " .. extracted_id)
                        return
                    end
                    
                    local template_id = get_template_id(extracted_id)
                    local target_template = template_id and ("rbxassetid://" .. template_id) or ("rbxassetid://" .. extracted_id)

                    local old_shirt = FindFirstChildOfClass(character, "Shirt")
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

                    if #extracted_id > 50 then
                        warn("Pants ID too long (max 50 digits): " .. extracted_id)
                        return
                    end

                    local template_id = get_template_id(extracted_id)
                    local target_template = template_id and ("rbxassetid://" .. template_id) or ("rbxassetid://" .. extracted_id)

                    local old_pants = FindFirstChildOfClass(character, "Pants")
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
                    local body_colors = FindFirstChildOfClass(character, "BodyColors")
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
                    local shirt = FindFirstChildOfClass(character, "Shirt")
                    if shirt then
                        shirt.Color3 = color
                    end

                    local pants = FindFirstChildOfClass(character, "Pants")
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

                local head = FindFirstChild(character, "Head")
                if not head then return end

                for id in accessories_string:gmatch("[^,]+") do
                    id = id:match("^%s*(.-)%s*$")
                    local extracted_id = id:match("rbxassetid://(%d+)") or id:match("^(%d+)$") or id

                    local success, err = pcall(function()
                        local acc = game:GetObjects("rbxassetid://" .. extracted_id)[1]
                        if not acc then return end

                        if acc then
                            acc.Name = "Asset:" .. extracted_id
                            acc.Parent = character

                            local handle = acc:WaitForChild("Handle", 5)
                            if not handle then return end

                            for _, obj in ipairs(handle:GetChildren()) do
                                if obj:IsA("Weld") or obj:IsA("WeldConstraint") or obj:IsA("Motor6D") then
                                    obj:Destroy()
                                end
                            end

                            local accAtt = FindFirstChildWhichIsA(handle, "Attachment")
                            if not accAtt then
                                warn("Accessory " .. extracted_id .. " has no attachment inside Handle")
                                return
                            end

                            local headAtt = FindFirstChild(head, accAtt.Name)
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
                        end
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
                repeat task.wait() until FindFirstChild(character, "Humanoid")
                repeat task.wait() until FindFirstChild(character, "Head")
                repeat task.wait() until FindFirstChild(character, "Head"):FindFirstChild("RLFace")

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
                        local shirt = FindFirstChildOfClass(character, "Shirt")
                        if shirt then
                            shirt.Color3 = config.outfit_shirt_color
                        end
                    end
                end

                if char_custom_enabled.pants and config.char_custom_pants ~= "" then
                    apply_pants(character, config.char_custom_pants)
                    if config.outfit_pants_color then
                        task.wait(0.1)
                        local pants = FindFirstChildOfClass(character, "Pants")
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

                    local head = FindFirstChild(character, "Head")
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

                if utility then
                    setup_monitoring()
                end
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
                            local originalName
                            repeat
                                task.wait(0.1)
                                originalName = cheat_client:get_name(plr)
                            until originalName and originalName ~= "nil" and originalName ~= ""
                            original_names[plr] = originalName
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
                        local originalName
                        repeat
                            task.wait(0.1)
                            originalName = cheat_client:get_name(plr)
                        until originalName and originalName ~= "nil" and originalName ~= ""
                        original_names[plr] = originalName
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
                        local head = FindFirstChild(plr.Character, "Head")
                        if head then
                            local rlface = FindFirstChild(head, "RLFace")
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
                        local body_colors = FindFirstChildOfClass(plr.Character, "BodyColors")
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
                        local shirt = FindFirstChildOfClass(plr.Character, "Shirt")
                        if shirt and original_char_state.shirt_color then
                            shirt.Color3 = original_char_state.shirt_color
                        end

                        local pants = FindFirstChildOfClass(plr.Character, "Pants")
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
                        local head = FindFirstChild(plr.Character, "Head")
                        if head then
                            local rlface = FindFirstChild(head, "RLFace")
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

        do -- Macros
            local macro_system = {
                current_actions = {},
                loaded_macros = {},
                is_running = {},
                stopping = false,
            }
            cheat_client.macro_system = macro_system

            local last_m1 = 0
            utility:Connection(uis.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if plr.Character and FindFirstChild(plr.Character, "Dagger") then
                        last_m1 = tick()
                    end
                end
            end)

            local function left_click()
                if macro_system.stopping then return end
                
                last_m1 = tick()
                task.spawn(function()
                    if vim then
                        vim:SendMouseButtonEvent(0,0,0, true, game, 1)
                        task.wait(math.random(1, 15) / 1000)
                        vim:SendMouseButtonEvent(0,0,0, false, game, 1)
                    end
                end)

                if utility and utility.LeftClick then
                    utility:LeftClick()
                end
            end

            local function right_click()
                if macro_system.stopping then return end
                if utility and utility.RightClick then
                    utility:RightClick()
                end
            end

            local function is_stunned()
                local char = plr.Character
                if not char then return false end
                for _, obj in ipairs(char:GetChildren()) do
                    if cheat_client.im_lazy_stuns[obj.Name] then
                        return true
                    end
                end
                return false
            end

            local function buffer_action()
                if tick() - last_m1 < 0.05 then
                    repeat task.wait() until tick() - last_m1 > 0.05
                end
            end

            local vk_code_map = {
                A = 0x41, B = 0x42, C = 0x43, D = 0x44, E = 0x45, F = 0x46, G = 0x47,
                H = 0x48, I = 0x49, J = 0x4A, K = 0x4B, L = 0x4C, M = 0x4D, N = 0x4E,
                O = 0x4F, P = 0x50, Q = 0x51, R = 0x52, S = 0x53, T = 0x54, U = 0x55,
                V = 0x56, W = 0x57, X = 0x58, Y = 0x59, Z = 0x5A,
                Zero = 0x30, One = 0x31, Two = 0x32, Three = 0x33, Four = 0x34,
                Five = 0x35, Six = 0x36, Seven = 0x37, Eight = 0x38, Nine = 0x39,
                F1 = 0x70, F2 = 0x71, F3 = 0x72, F4 = 0x73, F5 = 0x74, F6 = 0x75,
                F7 = 0x76, F8 = 0x77, F9 = 0x78, F10 = 0x79, F11 = 0x7A, F12 = 0x7B,
                Space = 0x20, Return = 0x0D, Tab = 0x09, Escape = 0x1B, Backspace = 0x08,
                LeftShift = 0xA0, RightShift = 0xA1, LeftControl = 0xA2, RightControl = 0xA3,
                LeftAlt = 0xA4, RightAlt = 0xA5, CapsLock = 0x14,
                Up = 0x26, Down = 0x28, Left = 0x25, Right = 0x27,
                Insert = 0x2D, Delete = 0x2E, Home = 0x24, End = 0x23,
                PageUp = 0x21, PageDown = 0x22,
                NumLock = 0x90, KeypadZero = 0x60, KeypadOne = 0x61, KeypadTwo = 0x62,
                KeypadThree = 0x63, KeypadFour = 0x64, KeypadFive = 0x65, KeypadSix = 0x66,
                KeypadSeven = 0x67, KeypadEight = 0x68, KeypadNine = 0x69,
                KeypadMultiply = 0x6A, KeypadPlus = 0x6B, KeypadMinus = 0x6D,
                KeypadPeriod = 0x6E, KeypadDivide = 0x6F,
            }

            local vk_name_map = {}
            for name, code in pairs(vk_code_map) do
                vk_name_map[code] = name
            end

            local function find_tool(name)
                local lower = name:lower()
                for _, t in ipairs(plr.Backpack:GetChildren()) do
                    if t:IsA("Tool") and t.Name:lower() == lower then return t end
                end
                if plr.Character then
                    for _, t in ipairs(plr.Character:GetChildren()) do
                        if t:IsA("Tool") and t.Name:lower() == lower then return t end
                    end
                end
            end

            local active_nostun_conns = {}
            local function run_action(action)
                if macro_system.stopping then return end
                local char = plr.Character
                if action.type == "equip" then
                    local tool = find_tool(action.tool)
                    if tool and char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum:EquipTool(tool) end
                    end
                elseif action.type == "unequip" then
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum:UnequipTools() end
                    end
                    task.wait(0.005)
                elseif action.type == "wait" then
                    task.wait(action.duration or 0.1)
                elseif action.type == "bufferaction" then
                    buffer_action()
                elseif action.type == "waitstun" then
                    if is_stunned() then
                        repeat task.wait() until not is_stunned() or macro_system.stopping
                    end
                elseif action.type == "loopclick" then
                    local duration = action.duration or 1
                    local start_time = tick()
                    while tick() - start_time < duration and macro_system.is_running and not macro_system.stopping do
                        left_click()
                        task.wait()
                    end
                elseif action.type == "leftclick" then
                    left_click()
                    task.wait()
                elseif action.type == "rightclick" then
                    right_click()
                    task.wait()
                elseif action.type == "activate" then
                    if char then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end
                elseif action.type == "charge" then
                    if utility and utility.charge_mana then
                        utility:charge_mana()
                    end
                elseif action.type == "stopcharge" then
                    if utility and utility.decharge_mana then
                        utility:decharge_mana()
                    end
                elseif action.type == "chargeuntil" then
                    if utility and utility.charge_mana_until then utility:charge_mana_until(action.amount or 50) end
                elseif action.type == "nostun" then
                    local dur = action.duration or 0.2
                    local char = plr.Character
                    if not char or not utility or not utility.Connection then return end
                    local conn
                    conn = utility:Connection(char.ChildAdded, function(obj)
                        if cheat_client and cheat_client.stuns and cheat_client.stuns[obj.Name] then
                            task.defer(obj.Destroy, obj)
                        end
                    end)
                    table.insert(active_nostun_conns, conn)
                    task.delay(dur, function()
                        if conn then
                            conn:Disconnect()
                            local idx = table.find(active_nostun_conns, conn)
                            if idx then table.remove(active_nostun_conns, idx) end
                        end
                    end)
                elseif action.type == "punch" then
                    if char and utility and utility.Connection then
                        local punched = false
                        local conn

                        conn = utility:Connection(char.ChildAdded, function(obj)
                            if obj:IsA("Accessory") and obj.Name == "LightAttack" then
                                punched = true
                                if conn then conn:Disconnect() end
                            end
                        end)

                        local hum = char:FindFirstChildOfClass("Humanoid")

                        local hasDagger = FindFirstChild(char, "Dagger")
                        local hasSword = FindFirstChild(char, "Sword")

                        if hasDagger or hasSword then
                            local bypass
                            if hasDagger then
                                bypass = find_tool("Agility")
                            elseif hasSword then
                                bypass = find_tool("Action Surge")
                            end

                            if bypass and hum then
                                hum:EquipTool(bypass)
                                task.wait(0.04)
                            end
                        end

                        if hum then hum:UnequipTools() end
                        task.wait(0.01)

                        while not punched and not macro_system.stopping do
                            left_click()
                            task.wait(0.01)
                        end

                        if conn then conn:Disconnect() end
                    end
                elseif action.type == "heavypunch" then
                    if char and utility and utility.Connection then
                        local punched = false
                        local conn

                        conn = utility:Connection(char.ChildAdded, function(obj)
                            if obj:IsA("Accessory") and obj.Name == "HeavyAttack" then
                                punched = true
                                if conn then conn:Disconnect() end
                            end
                        end)

                        local hum = char:FindFirstChildOfClass("Humanoid")

                        local hasDagger = FindFirstChild(char, "Dagger")
                        local hasSword = FindFirstChild(char, "Sword")

                        if hasDagger or hasSword then
                            local bypass
                            if hasDagger then
                                bypass = find_tool("Agility")
                            elseif hasSword then
                                bypass = find_tool("Action Surge")
                            end

                            if bypass and hum then
                                hum:EquipTool(bypass)
                                task.wait(0.04)
                            end
                        end

                        if hum then hum:UnequipTools() end
                        task.wait(0.01)

                        while not punched and not macro_system.stopping do
                            right_click()
                            task.wait(0.01)
                        end

                        if conn then conn:Disconnect() end
                    end
                elseif action.type == "keyclick" then
                    local vk = tonumber(action.keycode)
                    if vk then
                        if not cheat_client.window_active then return end
                        keypress(vk)
                        task.wait(0.05)
                        keyrelease(vk)
                    end
                elseif action.type == "keypress" then
                    local vk = tonumber(action.keycode)
                    if vk then
                        if not cheat_client.window_active then return end
                        keypress(vk)
                    end
                elseif action.type == "keyrelease" then
                    local vk = tonumber(action.keycode)
                    if vk then
                        keyrelease(vk)
                    end
                elseif action.type == "executecode" then
                    if action.file and action.file ~= "" then
                        local file_path = "HYDROXIDE/macros/" .. action.file
                        if isfile(file_path) then
                            local success, err = pcall(function()
                                loadstring(readfile(file_path))()
                            end)
                            if not success then
                                warn("ExecuteCode error: " .. tostring(err))
                            end
                        else
                            warn("ExecuteCode: File not found - " .. action.file)
                        end
                    end
                end
            end

            local function run_macro(actions, macro_name)
                if not plr.Character then return end

                local name = macro_name or "unnamed"
                macro_system.is_running[name] = true

                for _, action in ipairs(actions) do
                    if action.type == "loopclick" or action.type == "chargeuntil" then
                        task.spawn(run_action, action)
                    else
                        run_action(action)
                    end
                end

                task.wait(0.5)
                macro_system.is_running[name] = nil
            end

            local function format_list(actions)
                if #actions == 0 then return "No actions added" end

                local regular_actions = {}
                local keybind_actions = {}

                for i, a in ipairs(actions) do
                    if a.type == "keybind" then
                        table.insert(keybind_actions, a)
                    else
                        table.insert(regular_actions, a)
                    end
                end

                local lines = {}
                local max_show = 8

                for i, a in ipairs(regular_actions) do
                    if i > max_show then
                        table.insert(lines, "... +" .. (#regular_actions - max_show) .. " more")
                        break
                    end
                    local text
                    if a.type == "equip" then text = i .. ". Equip: " .. a.tool
                    elseif a.type == "unequip" then text = i .. ". Unequip"
                    elseif a.type == "wait" then text = string.format("%d. Wait: %.2fs", i, a.duration)
                    elseif a.type == "click" then text = i .. ". Click"
                    elseif a.type == "activate" then text = i .. ". Activate"
                    elseif a.type == "charge" then text = i .. ". Charge Mana"
                    elseif a.type == "stopcharge" then text = i .. ". Stop Charge"
                    elseif a.type == "chargeuntil" then text = i .. ". Charge Until: " .. (a.amount or 50)
                    elseif a.type == "nostun" then text = string.format("%d. No Stun: %.2fs", i, a.duration or 0.2)
                    elseif a.type == "punch" then text = i .. ". Punch"
                    elseif a.type == "heavypunch" then text = i .. ". Heavy Punch"
                    elseif a.type == "leftclick" then text = i .. ". Left Click"
                    elseif a.type == "rightclick" then text = i .. ". Right Click"
                    elseif a.type == "loopclick" then text = string.format("%d. Loop Click: %.2fs", i, a.duration or 1)
                    elseif a.type == "bufferaction" then text = i .. ". Buffer Action"
                    elseif a.type == "waitstun" then text = i .. ". Wait Stun"
                    elseif a.type == "keyclick" then text = i .. ". Key Click: " .. (vk_name_map[a.keycode] or string.format("0x%02X", a.keycode or 0))
                    elseif a.type == "keypress" then text = i .. ". Key Press: " .. (vk_name_map[a.keycode] or string.format("0x%02X", a.keycode or 0))
                    elseif a.type == "keyrelease" then text = i .. ". Key Release: " .. (vk_name_map[a.keycode] or string.format("0x%02X", a.keycode or 0))
                    elseif a.type == "executecode" then text = i .. ". Execute: " .. (a.file or "?")
                    end
                    if text then table.insert(lines, text) end
                end

                if #keybind_actions > 0 then
                    table.insert(lines, "")
                    table.insert(lines, "")
                    table.insert(lines, "- Keybinds")

                    for i, a in ipairs(keybind_actions) do
                        local text = string.format("%d. %s -> %s", i, a.key or "?", a.tool or "?")
                        table.insert(lines, text)
                    end
                end

                if #lines == 0 then return "No actions added" end
                return table.concat(lines, "\n")
            end

            local function get_macros()
                local folder = "HYDROXIDE/macros"
                if not isfolder then return {} end
                if not isfolder(folder) then
                    if makefolder then makefolder(folder) end
                    return {}
                end
                local names = {}
                for _, path in ipairs(listfiles(folder)) do
                    local name = path:match("([^/\\]+)%.json$")
                    if name then table.insert(names, name) end
                end
                return names
            end

            local function get_lua_scripts()
                local folder = "HYDROXIDE/macros"
                if not isfolder then return {} end
                if not isfolder(folder) then
                    if makefolder then makefolder(folder) end
                    return {}
                end
                local scripts = {}
                for _, path in ipairs(listfiles(folder)) do
                    local name = path:match("([^/\\]+)%.lua$")
                    if name then table.insert(scripts, name .. ".lua") end
                end
                return scripts
            end

            local function encode_value(val)
                local t = typeof(val)
                if t == "string" then
                    return "\"" .. val:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\n", "\\n") .. "\""
                elseif t == "number" or t == "boolean" then
                    return tostring(val)
                elseif t == "table" then
                    local parts = {}
                    for k, v in pairs(val) do
                        table.insert(parts, "\"" .. tostring(k) .. "\": " .. encode_value(v))
                    end
                    return "{ " .. table.concat(parts, ", ") .. " }"
                else
                    return "null"
                end
            end

            local function pretty_json(data)
                local lines = {"{"}
                table.insert(lines, "  \"name\": " .. encode_value(data.name) .. ",")
                table.insert(lines, "  \"keybind\": " .. encode_value(data.keybind) .. ",")
                table.insert(lines, "  \"actions\": [")
                for i, action in ipairs(data.actions) do
                    local comma = i < #data.actions and "," or ""
                    table.insert(lines, "    " .. encode_value(action) .. comma)
                end

                local actions_closing = "  ]"
                if data.keybinds and #data.keybinds > 0 then
                    actions_closing = actions_closing .. ","
                end
                table.insert(lines, actions_closing)

                if data.keybinds and #data.keybinds > 0 then
                    table.insert(lines, "  \"keybinds\": [")
                    for i, kb in ipairs(data.keybinds) do
                        local comma = i < #data.keybinds and "," or ""
                        table.insert(lines, "    " .. encode_value(kb) .. comma)
                    end
                    table.insert(lines, "  ]")
                end

                table.insert(lines, "}")
                return table.concat(lines, "\n")
            end

            local function save_macro(name, actions, keybind)
                if not name or name == "" then
                    library:Notify("Enter a macro name!")
                    return false
                end
                if #actions == 0 then
                    library:Notify("Add at least one action!")
                    return false
                end
                local folder = "HYDROXIDE/macros"
                if not isfolder(folder) then makefolder(folder) end
                local path = folder .. "/" .. name .. ".json"
                local exists = isfile(path)

                local regular_actions = {}
                local keybinds_array = {}
                for _, action in ipairs(actions) do
                    if action.type == "keybind" then
                        table.insert(keybinds_array, {key = action.key, tool = action.tool})
                    else
                        table.insert(regular_actions, action)
                    end
                end

                local data = {
                    name = name,
                    keybind = keybind or "None",
                    actions = regular_actions,
                    keybinds = #keybinds_array > 0 and keybinds_array or nil
                }
                local ok = pcall(function()
                    writefile(path, pretty_json(data))
                end)
                if ok then
                    library:Notify(exists and "Overwrote: " .. name or "Saved: " .. name)
                else
                    library:Notify("Failed to save macro!")
                end
                return ok
            end

            local function load_macro(name)
                local path = "HYDROXIDE/macros/" .. name .. ".json"
                if not isfile(path) then
                    library:Notify("Macro not found!")
                    return nil
                end
                local ok, data = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(readfile(path))
                end)
                return ok and data or nil
            end

            local function delete_macro(name)
                local path = "HYDROXIDE/macros/" .. name .. ".json"
                if isfile(path) then
                    delfile(path)
                    library:Notify("Deleted macro: " .. name)
                    return true
                end
                return false
            end

            local function setup_macro_keybind(name, macro_data)
                if not macro_data or macro_data.keybind == "None" then return end
                local key = Enum.KeyCode[macro_data.keybind]
                if not key then return end

                local running = false
                local conn = utility:Connection(uis.InputBegan, function(input, gpe)
                    if gpe or running then return end
                    if input.KeyCode == key then
                        running = true
                        task.spawn(function()
                            run_macro(macro_data.actions, name)
                            running = false
                        end)
                    end
                end)

                return conn
            end

            local function setup_keybinds_array(keybinds_data)
                local connections = {}

                if keybinds_data then
                    for _, kb in ipairs(keybinds_data) do
                        if kb.key and kb.tool then
                            local key = Enum.KeyCode[kb.key]
                            if key then
                                local conn = utility:Connection(uis.InputBegan, function(input, gpe)
                                    if gpe then return end
                                    if input.KeyCode == key then
                                        local character = plr.Character
                                        if not character then return end

                                        local hum = character:FindFirstChildOfClass("Humanoid")
                                        if not hum then return end

                                        -- Check if tool is already equipped
                                        local equipped_tool = character:FindFirstChild(kb.tool)

                                        if equipped_tool and equipped_tool:IsA("Tool") then
                                            -- Unequip if already equipped
                                            hum:UnequipTools()
                                        else
                                            -- Find and equip if not equipped
                                            local tool = find_tool(kb.tool)
                                            if tool then
                                                hum:EquipTool(tool)
                                            end
                                        end
                                    end
                                end)
                                table.insert(connections, conn)
                            end
                        end
                    end
                end

                return connections
            end

            local group_builder = Tabs.Macros:AddLeftGroupbox("Macro Builder")
            local group_config = Tabs.Macros:AddRightGroupbox("Macro Config")

            local current_action_type = "Equip Tool"
            local current_tool_name = ""
            local current_wait_dur = 0.15
            local current_charge_amt = 50
            local current_nostun_dur = 0.2
            local current_loopclick_dur = 1
            local current_script_file = ""

            group_builder:AddLabel("Current Actions")
            local actions_list = group_builder:AddActionList({ Height = 100 })
            group_builder:AddDivider()

            group_builder:AddDropdown("MacroActionType", {
                Text = "Action Type",
                Default = "Equip Tool",
                Values = {"Equip Tool", "Unequip", "Wait", "Activate", "Punch", "Heavy Punch", "Charge Mana", "Stop Charge", "Charge Until", "No Stun", "Wait Stun", "BufferAction", "LoopClick", "LeftClick", "RightClick", "Key Click", "Key Press", "Key Release", "Keybind", "Execute Code"},
                Callback = function(v) current_action_type = v end
            })

            local script_dropdown = group_builder:AddDropdown("MacroScriptFile", {
                Text = "Script File",
                Default = "",
                Values = get_lua_scripts(),
                Callback = function(v) current_script_file = v end
            })

            group_builder:AddButton({
                Text = "Refresh Scripts",
                Func = function()
                    local scripts = get_lua_scripts()
                    script_dropdown:SetValues(scripts)
                    library:Notify("Refreshed " .. #scripts .. " script(s)")
                end
            })

            group_builder:AddInput("MacroToolName", {
                Default = "",
                Text = "Tool Name",
                Tooltip = "Case-insensitive",
                Placeholder = "e.g. Lethality",
                Callback = function(v) current_tool_name = v end
            })

            group_builder:AddButton({
                Text = "Add Equipped",
                Func = function()
                    local action

                    if current_action_type == "Equip Tool" then
                        if plr.Character then
                            local tool = plr.Character:FindFirstChildOfClass("Tool")
                            if tool then
                                action = {type = "equip", tool = tool.Name}
                            else
                                library:Notify("No tool equipped!")
                                return
                            end
                        end
                    elseif current_action_type == "Unequip" then
                        action = {type = "unequip"}
                    elseif current_action_type == "Wait" then
                        action = {type = "wait", duration = current_wait_dur}
                    elseif current_action_type == "Activate" then
                        action = {type = "activate"}
                    elseif current_action_type == "Punch" then
                        action = {type = "punch"}
                    elseif current_action_type == "Heavy Punch" then
                        action = {type = "heavypunch"}
                    elseif current_action_type == "Charge Mana" then
                        action = {type = "charge"}
                    elseif current_action_type == "Stop Charge" then
                        action = {type = "stopcharge"}
                    elseif current_action_type == "Charge Until" then
                        action = {type = "chargeuntil", amount = current_charge_amt}
                    elseif current_action_type == "No Stun" then
                        action = {type = "nostun", duration = current_nostun_dur}
                    elseif current_action_type == "BufferAction" then
                        action = {type = "bufferaction"}
                    elseif current_action_type == "Wait Stun" then
                        action = {type = "waitstun"}
                    elseif current_action_type == "LoopClick" then
                        action = {type = "loopclick", duration = current_loopclick_dur}
                    elseif current_action_type == "LeftClick" then
                        action = {type = "leftclick"}
                    elseif current_action_type == "RightClick" then
                        action = {type = "rightclick"}
                    elseif current_action_type == "Key Click" or current_action_type == "Key Press" or current_action_type == "Key Release" then
                        local key_name = Options.MacroKeyActionKey and Options.MacroKeyActionKey.Value or "E"
                        local vk = vk_code_map[key_name]
                        if not vk then
                            library:Notify("Unsupported key: " .. tostring(key_name))
                            return
                        end
                        local type_map = {["Key Click"] = "keyclick", ["Key Press"] = "keypress", ["Key Release"] = "keyrelease"}
                        action = {type = type_map[current_action_type], keycode = vk}
                    elseif current_action_type == "Keybind" then
                        if plr.Character then
                            local tool = plr.Character:FindFirstChildOfClass("Tool")
                            if tool then
                                local key = Options.MacroKeybindKey and Options.MacroKeybindKey.Value or "E"
                                action = {type = "keybind", tool = tool.Name, key = key}
                            else
                                library:Notify("No tool equipped!")
                                return
                            end
                        end
                    end

                    if action then
                        table.insert(macro_system.current_actions, action)
                        actions_list:SetActions(macro_system.current_actions)
                        library:Notify("Added: " .. current_action_type)
                    end
                end
            })

            group_builder:AddInput("MacroWaitDuration", {
                Default = "0.15",
                Text = "Wait Duration (s)",
                Numeric = true,
                Placeholder = "0.15",
                Callback = function(v)
                    local num = tonumber(v)
                    if num then current_wait_dur = math.clamp(num, 0.01, 10000) end
                end
            })

            group_builder:AddInput("MacroNoStunDuration", {
                Default = "0.2",
                Text = "No Stun Duration (s)",
                Numeric = true,
                Placeholder = "0.2",
                Callback = function(v)
                    local num = tonumber(v)
                    if num then current_nostun_dur = math.clamp(num, 0.01, 10000) end
                end
            })

            group_builder:AddInput("MacroLoopClickDuration", {
                Default = "1",
                Text = "Loop Click Duration (s)",
                Numeric = true,
                Placeholder = "1",
                Callback = function(v)
                    local num = tonumber(v)
                    if num then current_loopclick_dur = math.clamp(num, 0.01, 10000) end
                end
            })

            group_builder:AddSlider("MacroChargeAmount", {
                Text = "Charge Until Amount",
                Default = 50,
                Min = 1,
                Max = 100,
                Rounding = 0,
                Callback = function(v) current_charge_amt = v end
            })

            group_builder:AddLabel("Keybind Key"):AddKeyPicker("MacroKeybindKey", {
                Default = "E",
                Mode = "Press",
                Text = "Keybind Key",
                NoUI = true
            })

            group_builder:AddLabel("Key Action Key"):AddKeyPicker("MacroKeyActionKey", {
                Default = "E",
                Mode = "Press",
                Text = "Key Action Key",
                NoUI = true
            })

            group_builder:AddButton({
                Text = "Add Action",
                Func = function()
                    local action
                    if current_action_type == "Equip Tool" then
                        if current_tool_name == "" then library:Notify("Enter a tool name!") return end
                        action = {type = "equip", tool = current_tool_name}
                    elseif current_action_type == "Unequip" then
                        action = {type = "unequip"}
                    elseif current_action_type == "Wait" then
                        action = {type = "wait", duration = current_wait_dur}
                    elseif current_action_type == "Activate" then
                        action = {type = "activate"}
                    elseif current_action_type == "Punch" then
                        action = {type = "punch"}
                    elseif current_action_type == "Heavy Punch" then
                        action = {type = "heavypunch"}
                    elseif current_action_type == "Charge Mana" then
                        action = {type = "charge"}
                    elseif current_action_type == "Stop Charge" then
                        action = {type = "stopcharge"}
                    elseif current_action_type == "Charge Until" then
                        action = {type = "chargeuntil", amount = current_charge_amt}
                    elseif current_action_type == "No Stun" then
                        action = {type = "nostun", duration = current_nostun_dur}
                    elseif current_action_type == "BufferAction" then
                        action = {type = "bufferaction"}
                    elseif current_action_type == "Wait Stun" then
                        action = {type = "waitstun"}
                    elseif current_action_type == "LoopClick" then
                        action = {type = "loopclick", duration = current_loopclick_dur}
                    elseif current_action_type == "LeftClick" then
                        action = {type = "leftclick"}
                    elseif current_action_type == "RightClick" then
                        action = {type = "rightclick"}
                    elseif current_action_type == "Key Click" or current_action_type == "Key Press" or current_action_type == "Key Release" then
                        local key_name = Options.MacroKeyActionKey and Options.MacroKeyActionKey.Value or "E"
                        local vk = vk_code_map[key_name]
                        if not vk then
                            library:Notify("Unsupported key: " .. tostring(key_name))
                            return
                        end
                        local type_map = {["Key Click"] = "keyclick", ["Key Press"] = "keypress", ["Key Release"] = "keyrelease"}
                        action = {type = type_map[current_action_type], keycode = vk}
                    elseif current_action_type == "Keybind" then
                        if current_tool_name == "" then library:Notify("Enter a tool name!") return end
                        local key = Options.MacroKeybindKey and Options.MacroKeybindKey.Value or "E"
                        action = {type = "keybind", tool = current_tool_name, key = key}
                    elseif current_action_type == "Execute Code" then
                        if current_script_file == "" then library:Notify("Select a script file!") return end
                        action = {type = "executecode", file = current_script_file}
                    end
                    if action then
                        table.insert(macro_system.current_actions, action)
                        actions_list:SetActions(macro_system.current_actions)
                        library:Notify("Added: " .. current_action_type)
                    end
                end
            })

            group_builder:AddButton({
                Text = "Remove Last",
                Func = function()
                    if #macro_system.current_actions > 0 then
                        table.remove(macro_system.current_actions)
                        actions_list:SetActions(macro_system.current_actions)
                        library:Notify("Removed last action")
                    else
                        library:Notify("No actions to remove!")
                    end
                end
            })

            group_builder:AddButton({
                Text = "Clear All",
                Func = function()
                    macro_system.current_actions = {}
                    actions_list:SetActions({})
                    library:Notify("Cleared all actions")
                end
            })

            local saved_dropdown
            local current_macro_name = ""
            local selected_macro_name = ""
            local active_macro_toggles = {}

            local function save_macro_state()
                local httpService = httt
                pcall(function()
                    local shared_settings = {}
                    if mem:HasItem("shared_settings") then
                        local success, loaded = pcall(function()
                            return httpService:JSONDecode(mem:GetItem("shared_settings"))
                        end)
                        if success and loaded then
                            shared_settings = loaded
                        end
                    end

                    local active_macros = {}
                    for macro_name, toggle in pairs(active_macro_toggles) do
                        if toggle and toggle.Value then
                            table.insert(active_macros, macro_name)
                        end
                    end

                    shared_settings.active_macros = active_macros
                    mem:SetItem("shared_settings", httpService:JSONEncode(shared_settings))
                end)
            end

            local function load_macro_state()
                local httpService = httt
                local macros_to_load = {}

                if mem:HasItem("shared_settings") then
                    local success, shared_settings = pcall(function()
                        return httpService:JSONDecode(mem:GetItem("shared_settings"))
                    end)
                    if success and shared_settings and shared_settings.active_macros then
                        macros_to_load = shared_settings.active_macros
                    end
                end

                return macros_to_load
            end

            local macro_name_input = group_config:AddInput("MacroName", {
                Default = "",
                Text = "Macro Name",
                Placeholder = "e.g. Shadow Combo",
                Callback = function(v) current_macro_name = v end
            })

            group_config:AddLabel("Trigger Keybind"):AddKeyPicker("MacroSaveKeybind", {
                Default = "None",
                Mode = "Press",
                Text = "Keybind",
                NoUI = true
            })

            group_config:AddButton({
                Text = "Save Macro",
                Func = function()
                    local kb = Options.MacroSaveKeybind and Options.MacroSaveKeybind.Value or "None"
                    if save_macro(current_macro_name, macro_system.current_actions, kb) then
                        local saved = get_macros()
                        if saved_dropdown and #saved > 0 then saved_dropdown:SetValues(saved) end

                        if macro_system.loaded_macros[current_macro_name] then
                            local old_data = macro_system.loaded_macros[current_macro_name]
                            if old_data.connection then
                                old_data.connection:Disconnect()
                            end
                            if old_data.keybind_connections then
                                for _, conn in ipairs(old_data.keybind_connections) do
                                    if conn then conn:Disconnect() end
                                end
                            end

                            local new_data = load_macro(current_macro_name)
                            if new_data then
                                local trigger_conn = nil
                                if new_data.keybind and new_data.keybind ~= "None" then
                                    trigger_conn = setup_macro_keybind(current_macro_name, new_data)
                                end

                                local keybind_conns = {}
                                if new_data.keybinds then
                                    keybind_conns = setup_keybinds_array(new_data.keybinds)
                                end

                                macro_system.loaded_macros[current_macro_name] = {
                                    name = current_macro_name,
                                    keybind = new_data.keybind,
                                    actions = new_data.actions,
                                    connection = trigger_conn,
                                    keybind_connections = keybind_conns
                                }

                                local toggle = active_macro_toggles[current_macro_name]
                                if toggle then
                                    local kb_text = (new_data.keybind and new_data.keybind ~= "None") and new_data.keybind or "No Key"
                                    toggle:SetText(current_macro_name .. " (" .. kb_text .. ")")
                                end

                                library:Notify("Updated loaded macro: " .. current_macro_name)
                            end
                        end
                    end
                end
            })

            group_config:AddDivider()

            saved_dropdown = group_config:AddDropdown("SavedMacros", {
                Text = "Saved Macros",
                Default = {},
                Values = get_macros(),
                Multi = true,
                Callback = function(selected_values)
                    selected_macro_name = ""
                    for macro_name, is_selected in pairs(selected_values) do
                        if is_selected then
                            selected_macro_name = macro_name
                            break
                        end
                    end

                    for macro_name, toggle in pairs(active_macro_toggles) do
                        if not selected_values[macro_name] then
                            if toggle.Value then
                                toggle:SetValue(false)
                            end

                            local macro_data = macro_system.loaded_macros[macro_name]
                            if macro_data then
                                if macro_data.connection then
                                    macro_data.connection:Disconnect()
                                end
                                if macro_data.keybind_connections then
                                    for _, conn in ipairs(macro_data.keybind_connections) do
                                        if conn then conn:Disconnect() end
                                    end
                                end
                                macro_system.loaded_macros[macro_name] = nil
                                macro_system.is_running[macro_name] = nil
                            end

                            library:Notify("Removed: " .. macro_name)
                            save_macro_state()
                        end
                    end

                    for macro_name, is_selected in pairs(selected_values) do
                        if is_selected and not active_macro_toggles[macro_name] then
                            local data = load_macro(macro_name)
                            if data then
                                local kb_text = (data.keybind and data.keybind ~= "None") and data.keybind or "No Key"
                                local toggle = group_config:AddToggle("MacroActive_" .. macro_name, {
                                    Text = macro_name .. " (" .. kb_text .. ")",
                                    Default = false,
                                    Callback = function(state)
                                        if state then
                                            if not macro_system.loaded_macros[macro_name] then
                                                local trigger_conn = nil
                                                if data.keybind and data.keybind ~= "None" then
                                                    trigger_conn = setup_macro_keybind(macro_name, data)
                                                end

                                                local keybind_conns = {}
                                                if data.keybinds then
                                                    keybind_conns = setup_keybinds_array(data.keybinds)
                                                end

                                                macro_system.loaded_macros[macro_name] = {
                                                    name = macro_name,
                                                    keybind = data.keybind,
                                                    actions = data.actions,
                                                    connection = trigger_conn,
                                                    keybind_connections = keybind_conns
                                                }

                                                library:Notify("Activated: " .. macro_name)
                                                save_macro_state()
                                            end
                                        else
                                            local macro_data = macro_system.loaded_macros[macro_name]
                                            if macro_data then
                                                if macro_data.connection then
                                                    macro_data.connection:Disconnect()
                                                end

                                                if macro_data.keybind_connections then
                                                    for _, conn in ipairs(macro_data.keybind_connections) do
                                                        if conn then conn:Disconnect() end
                                                    end
                                                end

                                                macro_system.loaded_macros[macro_name] = nil
                                                macro_system.is_running[macro_name] = nil
                                                library:Notify("Deactivated: " .. macro_name)
                                                save_macro_state()
                                            end
                                        end
                                    end
                                })

                                active_macro_toggles[macro_name] = toggle
                                library:Notify("Toggle created for: " .. macro_name)
                            end
                        end
                    end
                end
            })

            group_config:AddLabel("Active Macros")

            local delete_confirm_name = ""
            group_config:AddButton({
                Text = "Delete Macro",
                Func = function()
                    if not selected_macro_name or selected_macro_name == "" then
                        library:Notify("Select a macro to delete!")
                        return
                    end

                    if delete_confirm_name ~= selected_macro_name then
                        delete_confirm_name = selected_macro_name
                        library:Notify("Click again to confirm delete: " .. selected_macro_name)
                        return
                    end

                    delete_confirm_name = ""
                    if delete_macro(selected_macro_name) then
                        local toggle = active_macro_toggles[selected_macro_name]
                        if toggle then
                            if toggle.Value then
                                toggle:SetValue(false)
                            end
                            active_macro_toggles[selected_macro_name] = nil
                        end

                        local macro_data = macro_system.loaded_macros[selected_macro_name]
                        if macro_data then
                            if macro_data.connection then
                                macro_data.connection:Disconnect()
                            end
                            if macro_data.keybind_connections then
                                for _, conn in ipairs(macro_data.keybind_connections) do
                                    if conn then conn:Disconnect() end
                                end
                            end
                            macro_system.loaded_macros[selected_macro_name] = nil
                            macro_system.is_running[selected_macro_name] = nil
                        end

                        if current_macro_name == selected_macro_name then
                            macro_system.current_actions = {}
                            actions_list:SetActions({})
                            current_macro_name = ""
                            if macro_name_input then
                                macro_name_input:SetValue("")
                            end
                            if Options.MacroSaveKeybind then
                                Options.MacroSaveKeybind:SetValue({"None", "Press", {}})
                            end
                        end

                        saved_dropdown:SetValues(get_macros())
                        library:Notify("Deleted: " .. selected_macro_name)
                        selected_macro_name = ""
                        save_macro_state()  -- Update persistence after deletion
                    end
                end
            })

            group_config:AddButton({
                Text = "Reload Macros",
                Func = function()
                    local saved = get_macros()
                    if saved_dropdown then
                        saved_dropdown:SetValues(saved)
                        library:Notify("Reloaded " .. #saved .. " macro(s)")
                    end
                end
            })

            group_config:AddButton({
                Text = "Load into Builder",
                Func = function()
                    local enabled_macros = {}
                    for macro_name, toggle in pairs(active_macro_toggles) do
                        if toggle and toggle.Value then
                            table.insert(enabled_macros, macro_name)
                        end
                    end

                    if #enabled_macros == 0 then
                        library:Notify("Enable a macro toggle to load it!")
                        return
                    elseif #enabled_macros > 1 then
                        library:Notify("Multiple macros enabled! Disable all but one to edit.")
                        return
                    end

                    local macro_name = enabled_macros[1]
                    local data = load_macro(macro_name)
                    if data then
                        macro_system.current_actions = {}

                        for _, action in ipairs(data.actions or {}) do
                            table.insert(macro_system.current_actions, action)
                        end

                        if data.keybinds then
                            for _, kb in ipairs(data.keybinds) do
                                table.insert(macro_system.current_actions, {
                                    type = "keybind",
                                    tool = kb.tool,
                                    key = kb.key
                                })
                            end
                        end

                        actions_list:SetActions(macro_system.current_actions)
                        current_macro_name = macro_name
                        if macro_name_input then
                            macro_name_input:SetValue(current_macro_name)
                        end

                        if Options.MacroSaveKeybind then
                            local kb = (data.keybind and data.keybind ~= "None" and data.keybind ~= "") and data.keybind or "None"
                            Options.MacroSaveKeybind:SetValue({kb, "Press", {}})
                        end

                        library:Notify("Loaded: " .. current_macro_name)
                    end
                end
            })

            group_config:AddDivider()

            local test_running = false
            group_config:AddButton({
                Text = "Test Macro",
                Func = function()
                    if test_running then return end
                    if #macro_system.current_actions == 0 then
                        library:Notify("No actions to test!")
                        return
                    end
                    test_running = true
                    library:Notify("Running macro...")
                    task.spawn(function()
                        run_macro(macro_system.current_actions)
                        test_running = false
                    end)
                end
            })

            task.spawn(function()
                task.wait(0.5)  -- Wait for UI to initialize
                local macros_to_load = load_macro_state()
                if #macros_to_load > 0 then
                    library:Notify(string.format("Restoring %d macro(s) from previous session...", #macros_to_load))

                    local dropdown_selection = {}
                    for _, macro_name in ipairs(macros_to_load) do
                        dropdown_selection[macro_name] = true
                    end

                    if saved_dropdown then
                        saved_dropdown:SetValue(dropdown_selection)
                    end

                    task.wait(0.2)

                    for _, macro_name in ipairs(macros_to_load) do
                        local toggle = active_macro_toggles[macro_name]
                        if toggle then
                            toggle:SetValue(true)
                        end
                    end
                end
            end)
        end

        do -- ui
            local group_ui = Tabs.Interface:AddLeftGroupbox("UI Settings")
            group_ui:AddLabel("General Settings")

            do -- Chat Logger
                group_ui:AddToggle("chat_logger", {
                    Text = "Chat Logger",
                    Default = false,
                    Callback = function(state)
                        if state then
                            local success, result = pcall(function()
                                local LoggerGui = loadstring(game:HttpGet(repo .. "Chatlogger.lua"))()
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

            group_ui:AddDropdown("auto_panic_options", {
                Text = "Panic Conditions",
                Values = {"Unload on mod join", "Unload on Illusionist join"},
                Default = 1,
                Multi = true,
                Callback = function(value)
                    cheat_client.config.auto_panic_options = value
                end
            })

            if not LPH_OBFUSCATED then
                group_ui:AddButton({
                    Text = "Debug Info",
                    Func = function()
                        print("=== HYDROXIDE DEBUG INFO ===")

                        print("\n[Feature Connections]")
                        if cheat_client.feature_connections then
                            local active_count = 0
                            for name, connection in pairs(cheat_client.feature_connections) do
                                local status = connection and "Active" or "Inactive"
                                print(string.format("  %s: %s", name, status))
                                if connection then active_count = active_count + 1 end
                            end
                            print(string.format("  Total Active: %d", active_count))
                        end

                        -- Shared Connections & Drawings
                        print("\n[Shared Connections]")
                        if shared then
                            if shared.connections then
                                local conn_count = 0
                                for _, _ in pairs(shared.connections) do
                                    conn_count = conn_count + 1
                                end
                                print(string.format("  Total Connections: %d", conn_count))
                            end

                            if shared.hidden_connections then
                                local hidden_count = 0
                                for _, _ in pairs(shared.hidden_connections) do
                                    hidden_count = hidden_count + 1
                                end
                                print(string.format("  Hidden Connections: %d", hidden_count))
                            end

                            if shared.drawing_containers then
                                print("\n[Drawing Containers]")
                                local total_drawings = 0
                                for container_name, drawings in pairs(shared.drawing_containers) do
                                    local count = #drawings
                                    total_drawings = total_drawings + count
                                    if count > 0 then
                                        print(string.format("  %s: %d drawings", container_name, count))
                                    end
                                end
                                print(string.format("  Total Drawings: %d", total_drawings))
                            end
                        end

                        print("\n[Player Info]")
                        print(string.format("  Players in Game: %d", #plrs:GetPlayers()))
                        print(string.format("  Local Player: %s", plr.Name))
                        print(string.format("  Character Exists: %s", tostring(plr.Character ~= nil)))

                        print("\n[Memory Items]")
                        if mem then
                            local items = {"botstarted", "current_path", "current_point"}
                            for _, item in ipairs(items) do
                                if mem:HasItem(item) then
                                    print(string.format("  %s: %s", item, tostring(mem:GetItem(item))))
                                else
                                    print(string.format("  %s: Not Set", item))
                                end
                            end
                        end

                        print("\n[Active Toggles]")
                        if Toggles then
                            local active_toggles = {}
                            for name, toggle in pairs(Toggles) do
                                if toggle.Value then
                                    table.insert(active_toggles, name)
                                end
                            end
                            print(string.format("  Active: %s", table.concat(active_toggles, ", ")))
                        end
                        library:Notify("Debug info printed to console (F9)")
                    end,
                    DoubleClick = false,
                    Tooltip = "Print debug information to console"
                })
            end
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
                Default = cheat_client.config.friendly_keybind,
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
                
                if FindFirstChild(character, "ParryCool") then
                    status_window:AddItem("Parry Cooldown", status_colors.parry_cooldown)
                end
                
                local frost = FindFirstChild(character, "Frostbitten")
                if frost then
                    local frostType = FindFirstChild(frost, "Lesser") and "Frostbite (Lesser)" or "Frostbite"
                    status_window:AddItem(frostType, status_colors.frostbite)
                end
                
                if FindFirstChild(character, "Burned") then
                    status_window:AddItem("Burned", status_colors.burned)
                end
                
                if FindFirstChild(character, "ArmorPolished") then
                    status_window:AddItem("Grindstone", status_colors.grindstone)
                end
                
                --if cs:HasTag(character, "Danger") or FindFirstChild(character, "Danger") then
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

                if FindFirstChild(character, "Burned") then
                    dmgMult = dmgMult * 1.3
                end

                local frost = FindFirstChild(character, "Frostbitten")
                if frost then
                    dmgMult = dmgMult * (FindFirstChild(frost, "Lesser") and 1.2 or 1.3)
                end

                if dmgMult > 1 then
                    local damage_text = ("Damage x%.2f"):format(dmgMult)
                    status_window:AddItem(damage_text, Color3.fromRGB(255, 150, 50))
                end
                
                local boosts = FindFirstChild(character, "Boosts")
                if boosts then
                    local speed = FindFirstChild(boosts, "SpeedBoost")
                    local attack = FindFirstChild(boosts, "AttackSpeedBoost")
                    local damage = FindFirstChild(boosts, "HaseldanDamageMultiplier")
                    
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

                if cs:HasTag(character, "SnapCool") and FindFirstChild(character, "GateOut") then
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
                elseif FindFirstChild(character, "GateOut") then
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

                if FindFirstChild(character, "FireProtection") then
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
                elseif FindFirstChild(character, "FireProtection") then
                    status_window:AddItem("Fire Protection", status_colors.fire_protection)
                end

                if FindFirstChild(character, "NoFall") then
                    if FindFirstChild(character, "TPSafe") then
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
                elseif FindFirstChild(character, "NoFall") then
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
                elseif FindFirstChild(character, "Boosts") then
                    local boosts = FindFirstChild(character, "Boosts")
                    local speed = FindFirstChild(boosts, "SpeedBoost")
                    local attack = FindFirstChild(boosts, "AttackSpeedBoost")
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
                elseif FindFirstChild(character, "Boosts") then
                    local boosts = FindFirstChild(character, "Boosts")
                    local damage = FindFirstChild(boosts, "HaseldanDamageMultiplier")
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
                local config_folder = "HYDROXIDE/configs"
                shared.SaveManager:SetFolder(config_folder)
                shared.ThemeManager:SetFolder("HYDROXIDE")

                shared.SaveManager:SetIgnoreIndexes({ "SavedPaths" })

                shared.SaveManager.OnConfigLoaded = function(configName)
                    -- Persist loaded config across serverhops if enabled
                    if cheat_client.config.persistent_configs and mem and configName then
                        mem:SetItem("loaded_config", configName)
                    end

                    if Toggles.blatant_mode then
                        Toggles.blatant_mode:SetValue(cheat_client.config.blatant_mode)
                    end

                    if Toggles.streamer_mode and cheat_client.config.streamer_mode then
                        if cheat_client.config.custom_name_spoof and cheat_client.config.custom_name_spoof ~= "" then
                            if not original_names[plr] then
                                local originalName
                                repeat
                                    task.wait(0.1)
                                    originalName = cheat_client:get_name(plr)
                                until originalName and originalName ~= "nil" and originalName ~= ""
                                original_names[plr] = originalName
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
                            local req = http_request or request or syn.request
                            return req({
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

                -- Load persisted config if enabled and available
                if cheat_client.config.persistent_configs and persisted_config_name and persisted_config_name ~= "" then
                    local success, err = shared.SaveManager:Load(persisted_config_name)

                    if success then
                        library:Notify(string.format("Loaded persistent config: %s", persisted_config_name))
                    else
                        shared.SaveManager:LoadAutoloadConfig()
                    end
                else
                    -- No persisted config or disabled, load autoload (if BuildConfigSection didn't already)
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

                    if Toggles.NpcEsp and Toggles.NpcEsp.Value then
                        if FindFirstChild(ws, "NPCs") then
                            cheat_client.npc_esp_objects = cheat_client.npc_esp_objects or {}
                            for _, object in next, ws.NPCs:GetChildren() do
                                local is_normal_npc = FindFirstChildOfClass(object, 'Pants') and FindFirstChild(object, 'Humanoid') and FindFirstChild(object, 'Torso')
                                local is_eagle = object.Name == "The Eagle" and FindFirstChild(object, 'Humanoid') and FindFirstChild(object, 'HumanoidRootPart')

                                if (is_normal_npc or is_eagle) and not cheat_client.npc_esp_objects[object] then
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
            
            if FindFirstChild(character, "Watched") then 
                return 
            end
            
            repeat task.wait(0.05) until FindFirstChild(character, "HumanoidRootPart")
            local root_part = FindFirstChild(character, "HumanoidRootPart")
            if not root_part then 
                return 
            end
            
            local eye = legit_intent_gui:Clone()
            local display = FindFirstChild(eye, "Tool")
            if not display then 
                return 
            end
            
            local tool = FindFirstChildOfClass(character, "Tool")
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

                local hrp = FindFirstChild(character, "HumanoidRootPart")
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

                local my_hrp = FindFirstChild(my_char, "HumanoidRootPart")
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
                            local their_hrp = FindFirstChild(their_char, "HumanoidRootPart")
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
                    FindFirstChild(plr.PlayerGui, "StatGui") and 
                    FindFirstChild(plr.PlayerGui.StatGui, "LeftContainer") and 
                    FindFirstChild(plr.PlayerGui.StatGui.LeftContainer, "Mana")) then
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

                local data = FindFirstChild(char, "Artifacts")
                local scholar_boost = 0
                local boosts = FindFirstChild(char, "Boosts")
                if boosts then
                    local scholars = FindFirstChild(boosts, "ScholarsBoon")
                    if scholars then
                        scholar_boost = scholar_boost + scholars.Value
                    end
                end

                local backpack = FindFirstChild(plr, "Backpack")
                if backpack then
                    if FindFirstChild(backpack, "WiseCasting") then
                        scholar_boost = scholar_boost + 2
                    end
                    if FindFirstChild(backpack, "RemTraining") then
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
                        cheat_client:update_visuals(FindFirstChildOfClass(char, "Tool"))
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
                local character = plr.Character
                if not character then return end

                local network = character:FindFirstChild("Network")
                if not network then return end

                pcall(function()
                    network:FireServer("Block")
                end)

                task.wait(0.01)

                repeat
                    task.wait()
                until character:FindFirstChild("Action")

                pcall(function()
                    network:FireServer("Unblock")
                end)
            end

            local function hook_network(character)
                local network = character:WaitForChild("Network", 5)
                if not network then return end

                if old_remote then return end

                old_remote = hookfunction(network.FireServer, function(self, ...)
                    local args = {...}
                    local cmd = args[1]

                    -- sanity
                    if type(cmd) ~= "string" then
                        return old_remote(self, ...)
                    end

                    -- No Fall Damage
                    if Toggles and Toggles.no_fall and Toggles.no_fall.Value and cmd == "ApplyFallDamage" then
                        return
                    end

                    if Toggles and Toggles.AntiBackfireViribus and Toggles.AntiBackfireViribus.Value and cmd == "Click2" then
                        local character = plr.Character
                        if character and character:FindFirstChild("Viribus") then
                            local artifacts = character:FindFirstChild("Artifacts")
                            if not (artifacts and artifacts:FindFirstChild("PhilosophersStone")) then
                                local mana = character:FindFirstChild("Mana")
                                if mana then
                                    local v = mana.Value
                                    if (v > 0 and v < 60) or v > 70 then
                                        task.spawn(block)
                                    end
                                end
                            end
                        end
                    end

                    return old_remote(self, ...)
                end)
            end

            if plr.Character then
                hook_network(plr.Character)
            end

            utility:Connection(plr.CharacterAdded, function(character)
                old_remote = nil
                hook_network(character)
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
                    local huma = FindFirstChildOfClass(character, "Humanoid")

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

                    local rootPart = FindFirstChild(character, "HumanoidRootPart")
                    if rootPart then
                        rootPart.Anchored = false
                    end

                    was_noclip_enabled = false
                end
            end
            
            local function start_flight_rendering()
                if cheat_client.feature_connections.flight then return end

                cheat_client.feature_connections.flight = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                    local isNoclipEnabled = Toggles and Toggles.noclip and Toggles.noclip.Value or false
                    local isAutoFallEnabled = Toggles and Toggles.auto_fall and Toggles.auto_fall.Value or false

                    local character = plr.Character
                    if character then
                        local rootPart = FindFirstChild(character, "HumanoidRootPart")
                        if rootPart then
                            local camCFrame = workspace.CurrentCamera.CFrame
                            local huma = FindFirstChildOfClass(character, "Humanoid")
                            
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
                                        eVector -= Vector3.new(0, 1, 0)
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

                local boosts = WaitForChild(character, "Boosts")

                -- Anti Hystericus
                if FindFirstChild(character, 'Confused') and Toggles and Toggles.AntiHystericus and Toggles.AntiHystericus.Value then
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

            if plr.Character then
                setup_anti_status(plr.Character)
            end

            utility:Connection(plr.CharacterAdded, setup_anti_status)
        end
    
        do -- Init ESP
            do -- Shrieker ESP
                for _, child in pairs(ws.Live:GetChildren()) do
                    if child:IsA("Model") and string.match(child.Name, ".Shrieker") and FindFirstChild(child, "MonsterInfo") then
                        cheat_client:add_shrieker_chams(child)
                    end
                end
            end
        end
    
        do -- Init Bard
            if FindFirstChild(plr.PlayerGui, "BardGui") then
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

                local boosts = WaitForChild(char, "Boosts")
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
                            statGui = FindFirstChild(plr.PlayerGui, "StatGui")
                        until statGui and FindFirstChild(statGui, "Container") and FindFirstChild(statGui.Container, "CharacterName")
                        repeat task.wait(0.05) until FindFirstChild(statGui.Container.CharacterName, "Shadow")
                        if game.PlaceId ~= 14341521240 then
                            repeat task.wait(0.025) until plr.Character and FindFirstChild(plr.Character, "FakeHumanoid",true)
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
        end

        do -- Invis cam
            local isVolt = false
            if identifyexecutor then
                local executorName = identifyexecutor()
                isVolt = executorName:lower():find("volt") ~= nil
            end
            
            if not isVolt then
                local oldIndex
                oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
                    if not checkcaller() and self == plr then
                        local callingScript = getcallingscript()
                        
                        if callingScript then
                            local scriptName = callingScript.Name
                            
                            if key == "DevCameraOcclusionMode" and scriptName == "Input" then
                                return Enum.DevCameraOcclusionMode.Zoom
                            end
                            
                            if key == "CameraMaxZoomDistance" and scriptName == "Input" then
                                return 50
                            end
                        end
                    end
                    
                    return oldIndex(self, key)
                end))
            end
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
                
                if FindFirstChild(player, "Backpack") then
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
                
                if FindFirstChild(player, "Backpack") and FindFirstChild(player.Backpack, "Observe") then
                    return true
                end
                
                if player.Character and FindFirstChild(player.Character, "Observe") then
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
                    local backpack = FindFirstChildOfClass(p, "Backpack")

                    if char then
                        local jack = FindFirstChild(char, "Jack")
                        if jack and jack:IsA("Tool") then
                            return true
                        end
                    end

                    if backpack then
                        local jack = FindFirstChild(backpack, "Jack")
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

                if player:GetAttribute("MaxEdict") or (is_khei and FindFirstChild(player, "leaderstats")
                    and FindFirstChild(player.leaderstats, "MaxEdict")
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
                        and FindFirstChild(player, "leaderstats")
                        and FindFirstChild(player.leaderstats, "MaxEdict")
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
                    if label and label.Parent and label:IsA("TextLabel") and player and FindFirstChild(plrs, player.Name) then
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

                    if character and player_monitor_connections[player] and utility then
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
                if FindFirstChild(player, "Backpack") then
                    player_monitor_connections[player].backpackAdded = utility:Connection(player.Backpack.ChildAdded, function()
                        task.wait(1)
                        updatePlayerLabels(player)
                    end)
                end

                if game.PlaceId == 100010170789226 then
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
                                    player = FindFirstChild(plrs, username)
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
                if not FindFirstChild(plr.PlayerGui, "LeaderboardGui") then
                    return
                end

                local leaderboardFrame = WaitForChild(plr.PlayerGui.LeaderboardGui, "MainFrame"):WaitForChild("ScrollingFrame")
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
                while shared and not shared.is_unloading and not FindFirstChild(plr.PlayerGui, "LeaderboardGui") do
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
                            local oldButton = FindFirstChild(label, "SPB")
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

            if not FindFirstChild(plr.PlayerGui, LPH_ENCSTR("LeaderboardGui")) then
                local newLB = FindFirstChild(sui, LPH_ENCSTR("LeaderboardGui")):Clone()
                newLB.Parent = plr.PlayerGui
                newLB.ResetOnSpawn = true

                local connection
                connection = utility:Connection(plr.CharacterAdded, function()
                    newLB:Destroy()
                    connection:Disconnect()
                    task.wait(1)  -- Delay to ensure clean timing before recreation
                    -- Check if LeaderboardGui already exists, if not then create it
                    local existingLB = FindFirstChild(plr.PlayerGui, LPH_ENCSTR('LeaderboardGui'))
                    if not existingLB then
                        local leaderboardSrc = FindFirstChild(sui, LPH_ENCSTR('LeaderboardGui'))
                        if leaderboardSrc then
                            existingLB = leaderboardSrc:Clone()
                            existingLB.Parent = plr.PlayerGui
                            existingLB.ResetOnSpawn = true
                        end
                    end
                    if InitSpectator then
                        InitSpectator()
                    end
                end)
            end

            local startMenu = FindFirstChild(plr.PlayerGui, LPH_ENCSTR("StartMenu"))
            if startMenu then
                local copyright = FindFirstChild(startMenu, LPH_ENCSTR("CopyrightBar"))
                if copyright then
                    copyright:Destroy()
                end
            end

            task.spawn(function()
                local gui = FindFirstChild(plr, "PlayerGui")
                while utility and shared and not shared.is_unloading and gui and gui.Parent do
                    local leaderboardGui = FindFirstChild(gui, LPH_ENCSTR("LeaderboardGui"))
                    if leaderboardGui and not leaderboardGui.Enabled then
                        leaderboardGui.Enabled = true
                    end
                    task.wait(0.2)
                end
            end)

            task.spawn(function()
                if utility then
                    local gui = FindFirstChild(plr, "PlayerGui")
                    if not plr.Character and gui then
                        local function ensureLeaderboardGui()
                            if not FindFirstChild(gui, LPH_ENCSTR('LeaderboardGui')) then
                                -- Delay to ensure no conflicts with game's GUI creation
                                task.wait(1)
                                local leaderboardSrc = FindFirstChild(sui, LPH_ENCSTR('LeaderboardGui'))
                                if leaderboardSrc then
                                    local tempGui = leaderboardSrc:Clone()
                                    tempGui.Parent = gui
                                    return tempGui
                                end
                            end
                            return FindFirstChild(gui, LPH_ENCSTR('LeaderboardGui'))
                        end

                        ensureLeaderboardGui()
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
                            local leaderboardGui = FindFirstChild(gui, LPH_ENCSTR('LeaderboardGui'))
                            if leaderboardGui then
                                leaderboardGui:Destroy()
                            end
                            connection:Disconnect()
                            task.wait(1)  -- Delay to ensure clean timing before recreation
                            -- Check if LeaderboardGui already exists, if not then create it
                            local existingLB = FindFirstChild(gui, LPH_ENCSTR('LeaderboardGui'))
                            if not existingLB then
                                local leaderboardSrc = FindFirstChild(sui, LPH_ENCSTR('LeaderboardGui'))
                                if leaderboardSrc then
                                    existingLB = leaderboardSrc:Clone()
                                    existingLB.Parent = gui
                                end
                            end
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

                local humanoid = FindFirstChildOfClass(player.Character, "Humanoid")
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
                    local menuReturnGui = FindFirstChild(plr.PlayerGui, "MenuReturnGui")
                    if menuReturnGui then
                        local menuButton = FindFirstChild(menuReturnGui, "Menu")
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

                    local backpack = FindFirstChild(player, "Backpack")
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
                            local blessings_folder = FindFirstChild(player.Character, "Blessings")
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
                    local backpack = FindFirstChild(player, "Backpack")
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

                local backpack = FindFirstChild(player, "Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") then
                            if FindFirstChild(item, "Spell") then
                                table.insert(spells, item.Name)
                            end
                            if FindFirstChild(item, "Skill") or FindFirstChild(item, "SkillSpell") then
                                table.insert(skills, item.Name)
                            end
                        elseif item:IsA("Folder") then
                            if FindFirstChild(item, "Skill") then
                                table.insert(skills, item.Name)
                            end
                        end
                    end
                end

                if player.Character then
                    for _, item in ipairs(player.Character:GetChildren()) do
                        if item:IsA("Tool") then
                            if FindFirstChild(item, "Spell") then
                                table.insert(spells, item.Name)
                            end
                            if FindFirstChild(item, "Skill") or FindFirstChild(item, "SkillSpell") then
                                table.insert(skills, item.Name)
                            end
                        end
                    end
                end

                ClickMenuTags.Text = #tags > 0 and "Tags: " .. table.concat(tags, ", ") or "Tags: None"
                ClickMenuSpells.Text = #spells > 0 and "Spells: " .. table.concat(spells, ", ") or "Spells: None"
                ClickMenuSkills.Text = #skills > 0 and "Skills: " .. table.concat(skills, ", ") or "Skills: None"

                if player.Character then
                    local humanoid = FindFirstChildOfClass(player.Character, "Humanoid")
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

                local Button = FindFirstChild(Label, LPH_ENCSTR("SPB")) or Instance.new(LPH_ENCSTR("TextButton"), Label)
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
                        workspace.CurrentCamera.CameraSubject = FindFirstChildOfClass(plr.Character, LPH_ENCSTR("Humanoid"))
                    else
                        if Player.Character and FindFirstChild(Player.Character, LPH_ENCSTR("Humanoid")) then
                            Spectating = Player
                            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

                            local T = Spectating.Character:GetDescendants()
                            
                            if plr.Character then
                                for i, v in pairs(plr.Character:GetDescendants()) do
                                    T[#T + 1] = v
                                end
                            end

                            workspace.CurrentCamera.CameraSubject = FindFirstChildOfClass(Player.Character, LPH_ENCSTR("Humanoid"))
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
                    local leaderboardGui = WaitForChild(plr.PlayerGui, "LeaderboardGui", 50)
                    if not leaderboardGui then
                        warn("LeaderboardGui not found after 30s timeout")
                        return
                    end
                    WaitForChild(leaderboardGui, "LeaderboardClient", 10)
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

            utility:Connection(plr.PlayerGui.ChildAdded, function(child)
                if child.Name == "LeaderboardGui" then
                    task.wait(1)
                    InitSpectator()
                end
            end)

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

                task.spawn(function()
                    if not utility then return end

                    utility:charge_mana()
                    task.wait(0.1 + ((utility and getPing() or 0) / 900))

                    repeat
                        task.wait()
                        if not utility then return end
                        local character = plr.Character
                        if character and not FindFirstChild(character, "Charge") then
                            utility:charge_mana()
                            task.wait(0.1 + ((utility and getPing() or 0) / 900))
                        end
                    until not uis:IsKeyDown(key_code_g)

                    if utility then
                        utility:decharge_mana()
                    end
                end)
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
                ["Kyley"] = true,
                --["Willow"] = true, = ...
                --["Xenyari"] = true,
                --["The Eagle"] = true
            }
            
            local dialogConnection
            local function auto_dialogue_handler(dialogData)
                if not (Toggles and Toggles.auto_dialogue and Toggles.auto_dialogue.Value) then
                    return
                end
                
                if not plr.Character or not FindFirstChild(plr.Character, "InDialogue") then
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
            local thrown_folder = WaitForChild(ws, "Thrown")
            local players_folder = WaitForChild(thrown_folder, "Players")

            local function handle_weapon(weapon)
                task.wait(0.5)

                if not weapon:IsA("BasePart") then
                    return
                end

                local pickup = FindFirstChild(weapon, "ClickDetector")
                local prop = FindFirstChild(weapon, "Prop")
                
                if not (pickup and prop) then
                    return
                end

                local activation_distance = pickup.MaxActivationDistance - 2
                
                task.spawn(function()
                    while
                        (not shared)
                        or (not Toggles)
                        or (not Toggles.auto_weapon)
                        or (not Toggles.auto_weapon.Value)
                        or (not plr.Character)
                        or (not FindFirstChild(plr.Character, "Head"))
                        or (plr:DistanceFromCharacter(weapon.Position) > activation_distance)
                    do
                        task.wait(0.1)
                    end

                    repeat
                        local character = plr.Character
                        if
                            character
                            and FindFirstChild(character, "Head")
                            and plr:DistanceFromCharacter(weapon.Position) <= activation_distance
                        then
                            fireclickdetector(pickup)
                        end
                        task.wait(0.1)
                    until not weapon or not weapon:IsDescendantOf(players_folder)
                end)
            end

            local function handle_player_folder(player_folder)
                utility:Connection(player_folder.ChildAdded, function(child)
                    handle_weapon(child)
                end)

                for _, child in ipairs(player_folder:GetChildren()) do
                    handle_weapon(child)
                end
            end

            utility:Connection(players_folder.ChildAdded, function(player_folder)
                handle_player_folder(player_folder)
            end)

            for _, player_folder in ipairs(players_folder:GetChildren()) do
                handle_player_folder(player_folder)
            end
        end

        do -- Hold Block
            local function start_hold_block()
                if cheat_client.feature_connections.hold_block then return end

                cheat_client.feature_connections.hold_block = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                    if uis:IsKeyDown(Enum.KeyCode.F) then
                        local character = plr.Character

                        if character then
                            local remote = FindFirstChild(character, "Network")
                            if remote then
                                pcall(function()
                                    remote:FireServer("Block")
                                end)
                            end
                        end
                    end
                end))
            end

            local function stop_hold_block()
                if cheat_client.feature_connections.hold_block then
                    cheat_client.feature_connections.hold_block:Disconnect()
                    cheat_client.feature_connections.hold_block = nil
                end
            end

            cheat_client.start_hold_block = start_hold_block
            cheat_client.stop_hold_block = stop_hold_block

            if Toggles and Toggles.HoldBlock and Toggles.HoldBlock.Value then
                start_hold_block()
            end
        end
    
        do -- Perflora Teleport + Attach to Back
            local function IsTargetValid(Target)
                if (plr.Character and Target ~= nil and Target.Name == 'Humanoid' and FindFirstChild(Target.Parent, 'HumanoidRootPart') and Target.Parent ~= plr.Character) then
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
                local plr_hrp = FindFirstChild(plr.Character, "HumanoidRootPart")
                if not plr_hrp then return nil end

                local closest_plr = nil
                local min_dist = 350

                for _, target_player in ipairs(plrs:GetPlayers()) do
                    if target_player ~= plr and target_player.Character then
                        local target_hrp = FindFirstChild(target_player.Character, "HumanoidRootPart")
                        local target_humanoid = FindFirstChild(target_player.Character, "Humanoid")

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

                    local victim_hrp = FindFirstChild(attach_victim.Character, "HumanoidRootPart")
                    local victim_humanoid = FindFirstChild(attach_victim.Character, "Humanoid")
                    local plr_hrp = FindFirstChild(plr.Character, "HumanoidRootPart")

                    if not victim_hrp or not plr_hrp then
                        attach_victim = nil
                        return
                    end

                    if not victim_humanoid or victim_humanoid.Health <= 0 then
                        attach_victim = nil
                        return
                    end

                    local distance_check = (plr_hrp.Position - victim_hrp.Position).Magnitude
                    if distance_check > 130 then
                        attach_victim = nil
                        return
                    end

                    plr_hrp.Velocity = Vector3.new(0, 0, 0)

                    local torso = FindFirstChild(plr.Character, "Torso")
                    local head = FindFirstChild(plr.Character, "Head")
                    if torso then torso.CanCollide = false end
                    if head then head.CanCollide = false end

                    local is_flinging = Toggles and Toggles.fling and Toggles.fling.Value
                    if is_flinging then
                        plr_hrp.CFrame = victim_hrp.CFrame * CFrame.new(0, -2, 0)
                    else
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
                    local tool = FindFirstChild(plr.Backpack, "Rising Dragon")
                    if tool then
                        plr.Character.Humanoid:EquipTool(tool)

                        task.spawn(function()
                            while shared and not shared.is_unloading and obj.Parent == plr.Character and not FindFirstChild(plr.Character, "TPSafe") do
                                if not FindFirstChild(plr.Character, "Rising Dragon") and plr.Backpack then
                                    local backpackTool = FindFirstChild(plr.Backpack, "Rising Dragon")
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

                cas:BindAction("BlockAutoParryMouse", function()
                    if INPUT_BLOCKED then
                        return Enum.ContextActionResult.Sink
                    end
                end, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2)
            end

            local function unblockInputs()
                INPUT_BLOCKED = false
                cas:UnbindAction("BlockAutoParryInputs")
                cas:UnbindAction("BlockAutoParryMouse")
            end

            -- Functions
            -- Check if on screen with raycast, NO FOV restriction
            local function is_on_screen_visible(characterHRP)
                local vector, on_screen = ws.CurrentCamera:WorldToScreenPoint(characterHRP.Position)

                if not on_screen then
                    return false
                end

                if not plr.Character or not FindFirstChild(plr.Character, "HumanoidRootPart") then
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

                if not plr.Character or not FindFirstChild(plr.Character, "HumanoidRootPart") then
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
                
                if FindFirstChild(plr.Character, "ParryCool") then
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
                if not semiBlatantBlock and FindFirstChild(plr.Character, "NoDash") then return end

                if FindFirstChildOfClass(plr.Character, "ForceField") then return end
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

                if not useVim then
                    blockInputs()
                end

                if adjustedDelay > 0 then
                    task.wait(adjustedDelay)
                    if on_cooldown() then
                        if not useVim then
                            unblockInputs()
                        end
                        return
                    end
                end

                local humanoid = FindFirstChildOfClass(plr.Character, "Humanoid")
                local mana = FindFirstChild(plr.Character, "Mana")
                if humanoid and mana and mana.Value > 0 then
                    humanoid:UnequipTools()
                end

                local network = plr.Character and FindFirstChild(plr.Character, "Network")

                local semiBlatantBlock = Toggles.ParrySemiBlatantBlock and Toggles.ParrySemiBlatantBlock.Value
                if semiBlatantBlock and network then
                    task.spawn(function()
                        local endTime = tick() + blockDuration
                        while tick() < endTime do
                            pcall(function()
                                network:FireServer("Block")
                            end)
                            task.wait()
                        end

                        pcall(function()
                            network:FireServer("Unblock")
                        end)
                        unblockInputs()
                    end)
                elseif useVim or not network then
                    task.spawn(function()
                        vim:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        task.wait(blockDuration)
                        vim:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                    end)
                else
                    pcall(function()
                        network:FireServer("Block")
                    end)

                    task.delay(blockDuration, function()
                        pcall(function()
                            network:FireServer("Unblock")
                        end)
                        unblockInputs()
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

                local characterHRP = WaitForChild(character, "HumanoidRootPart", 3)
                if not characterHRP then
                    return
                end
                
                local function handleSound(sound)
                    if not utility then return end
                    return utility:Connection(sound.Played, function()
                        if not shared or not plr.Character or not FindFirstChild(plr.Character, "HumanoidRootPart") then
                            return
                        end
                        local playerHRP = plr.Character.HumanoidRootPart
                        local distance = (playerHRP.Position - characterHRP.Position).Magnitude
                        if distance <= DETECTION_RANGE then
                            if sound.Name == "OwlSlash" and shared and Toggles and Toggles.AutoPerfectBlock and Toggles.AutoPerfectBlock.Value and Options.ParryAbilities.Value["Owlslash"] then
                                if plr.Character and FindFirstChild(plr.Character, "AIRSLASH") then
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
                            elseif (sound.Name == "Shadowrush" or sound.Name == "ShadowrushCharge") and shared and Toggles and Toggles.AutoPerfectBlock and Toggles.AutoPerfectBlock.Value and Options.ParryAbilities.Value["Shadowrush"] then
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
                            elseif sound.Name == "PerfectCast" and shared and Toggles and Toggles.AutoPerfectBlock and Toggles.AutoPerfectBlock.Value and Options.ParryAbilities.Value["Verdien"] then
                                local soundInfo = AUTO_PARRY_SOUNDS[sound.Name]
                                local hasVerdien = FindFirstChild(character, "Verdien") or FindFirstChild(character, "New Verdien")

                                if hasVerdien then
                                    local ignoreVisibility = shared and Toggles.ParryIgnoreVisibility and Toggles.ParryIgnoreVisibility.Value
                                    local should_parry = ignoreVisibility or not soundInfo.requiresVisibility or is_visible(characterHRP)
                                    if should_parry then
                                        task.spawn(function()
                                            if shared then
                                                performAutoParry(soundInfo.delay, soundInfo.blockDuration, true, player)
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
                if not (Toggles and Toggles.AutoPerfectBlock and Toggles.AutoPerfectBlock.Value and Options.ParryAbilities.Value["Viribus"]) then return end
                if not model:IsA("Model") then return end

                local crater = WaitForChild(model, "Crater", 1)
                if not crater then return end

                if crater:IsA("Model") then
                    crater = crater.PrimaryPart or FindFirstChildWhichIsA(crater, "BasePart")
                    if not crater then return end
                end

                if not crater:IsA("BasePart") then return end
                if not plr.Character or not FindFirstChild(plr.Character, "HumanoidRootPart") then return end

                local playerHRP = plr.Character.HumanoidRootPart
                if FindFirstChild(model, "EarthSpear" .. plr.Name) then return end

                local distance = (crater.Position - playerHRP.Position).Magnitude
                if distance > EARTH_PILLAR_PARRY_DISTANCE then return end

                local closestCaster, closestDistance = nil, math.huge

                for _, player in ipairs(plrs:GetPlayers()) do
                    if player ~= plr and player.Character then
                        local casterHRP = FindFirstChild(player.Character, "HumanoidRootPart")
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
                    local casterHRP = FindFirstChild(closestCaster, "HumanoidRootPart")
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


            -- Grapple Parry
            local function setup_grapple_parry()
                if not plr.Character then return end

                utility:Connection(plr.Character.DescendantAdded, function(child)
                    if not (Toggles and Toggles.AutoPerfectBlock and Toggles.AutoPerfectBlock.Value and Options.ParryAbilities.Value["Grapple"]) then return end
                    if not (child:IsA("Attachment") and child.Name == "Attachment2") then return end

                    local enemyPlayer = nil
                    local should_parry = true

                    task.wait(0.05)

                    for _, player in ipairs(plrs:GetPlayers()) do
                        if player == plr or not player.Character then continue end

                        local leftArm = FindFirstChild(player.Character, "Left Arm")
                        if not leftArm then continue end

                        local cord = FindFirstChild(leftArm, "Cord")
                        if not cord or not cord:IsA("Beam") or cord.Attachment1 ~= child then continue end
                        enemyPlayer = player

                        local ignoreVisibility = Toggles.ParryIgnoreVisibility and Toggles.ParryIgnoreVisibility.Value
                        if not ignoreVisibility then
                            local enemyHRP = FindFirstChild(player.Character, "HumanoidRootPart")
                            if enemyHRP then
                                should_parry = is_on_screen_visible(enemyHRP)
                            end
                        end
                        break
                    end

                    if not enemyPlayer then return end
                    if plr.Character and FindFirstChild(plr.Character, "HumanoidRootPart") and enemyPlayer.Character then
                        local playerHRP = plr.Character.HumanoidRootPart
                        local enemyHRP = FindFirstChild(enemyPlayer.Character, "HumanoidRootPart")

                        if enemyHRP then
                            local distance = (playerHRP.Position - enemyHRP.Position).Magnitude
                            local semiBlatantBlock = Toggles.ParrySemiBlatantBlock and Toggles.ParrySemiBlatantBlock.Value
                            if not semiBlatantBlock and distance > 60 then
                                return
                            end
                        end
                    end

                    if should_parry then
                        performAutoParry(0, 0.25, true, enemyPlayer)
                    end
                end)
            end

            if plr.Character then
                setup_grapple_parry()
            end

            utility:Connection(plr.CharacterAdded, function()
                task.wait(0.5)
                setup_grapple_parry()
            end)

            connect_players()
        end

        do -- Silent Aim
            local valid_tools = { 
                Celeritas = true, 
                Armis = true, 
                Vulnere = true, 
                ["Dagger Throw"] = true, 
                Arguere = true, 
                Grapple = true, 
                ["Autumn Rain"] = true, 
                Ignis = true, 
                Percutiens = true 
            }

            local get_nearest_player = LPH_NO_VIRTUALIZE(function()
                local players_list = plrs:GetPlayers()
                local camera = ws.CurrentCamera
                local smallest_distance = math.huge
                local nearest
            
                local plr_humanoid_root_part = plr.Character and FindFirstChild(plr.Character, "HumanoidRootPart")
                local mouse_position = uis:GetMouseLocation()
            
                if not plr_humanoid_root_part then
                    return nil, nil
                end
            
                local fov_radius = (Options and Options.SilentAimFov and Options.SilentAimFov.Value) or 100
                local hitparts = {
                    ["Head"] = true,
                    ["HumanoidRootPart"] = true
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
                            local ignore_blocking = Toggles and Toggles.IgnoreBlocking and Toggles.IgnoreBlocking.Value
                            if ignore_blocking and FindFirstChild(target_character, "Blocking") then
                                continue
                            end

                            local closest_part = nil
                            local closest_part_distance = math.huge
                            
                            for part_name, _ in next, hitparts do
                                local part = FindFirstChild(target_character, part_name)
                                if part then
                                    local screen_position, on_screen = camera:WorldToScreenPoint(part.Position)
                                    
                                    if on_screen then
                                        local target_screen_position = Vector2.new(screen_position.X, screen_position.Y)
                                        local distance_to_mouse = (mouse_position - target_screen_position).Magnitude
                                        
                                        if distance_to_mouse <= fov_radius and distance_to_mouse < closest_part_distance then
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
                                cheat_client.aimbot.silent_instance = closest_part
                                cheat_client.aimbot.silent_position = closest_part.Position
                            end
                        end
                    end
                end
                return nearest, cheat_client.aimbot.silent_instance
            end)
            
            local function start_silent_aim_rendering()
                if cheat_client.feature_connections.silent_aim then return end

                cheat_client.feature_connections.silent_aim = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                    local isHideFovCircleEnabled = Toggles and Toggles.HideFovCircle and Toggles.HideFovCircle.Value or false
                    local mouse_pos = uis:GetMouseLocation()
                    aimbot_fov_circle.Position = mouse_pos
                    aimbot_fov_circle.Radius = (Options and Options.SilentAimFov and Options.SilentAimFov.Value) or 100
                    aimbot_fov_circle.Visible = cheat_client.window_active and not isHideFovCircleEnabled

                    local nearest_player, nearest_part = get_nearest_player()
                    if cheat_client and cheat_client.aimbot then
                        cheat_client.aimbot.current_target = nearest_player
                    end
                end))
            end

            local function stop_silent_aim_rendering()
                -- Disconnect heartbeat
                if cheat_client.feature_connections.silent_aim then
                    cheat_client.feature_connections.silent_aim:Disconnect()
                    cheat_client.feature_connections.silent_aim = nil
                end
                
                -- Cleanup aimbot data
                if cheat_client.aimbot then
                    cheat_client.aimbot.silent_instance = nil
                    cheat_client.aimbot.silent_position = nil
                    cheat_client.aimbot.current_target = nil
                end
                
                -- Hide FOV circle
                if aimbot_fov_circle then
                    aimbot_fov_circle.Visible = false
                end
                
                -- CRITICAL: Unhook the namecall
                if cheat_client.silent_aim_hook and cheat_client.silent_aim_original_namecall then
                    pcall(function()
                        hookmetamethod(game, "__namecall", cheat_client.silent_aim_original_namecall)
                    end)
                    cheat_client.silent_aim_hook = nil
                    cheat_client.silent_aim_original_namecall = nil
                end
            end

            -- Store the original namecall BEFORE hooking
            cheat_client.silent_aim_original_namecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                if method == "FireServer" and self.Name == "Network" then
                    local cmd = args[1]
                    local data = args[2]
                    
                    if type(cmd) == "string" and cmd == "Click" and type(data) == "table" then
                        -- Add safety checks to prevent errors when unloaded
                        local safe_to_modify = pcall(function()
                            return Toggles and Toggles.SilentAim and Toggles.SilentAim.Value 
                                and cheat_client and cheat_client.aimbot
                        end)
                        
                        if safe_to_modify then
                            local tool = data.Tool
                            
                            if tool and valid_tools[tool.Name] then
                                if cheat_client.aimbot.current_target 
                                and cheat_client.aimbot.silent_instance 
                                and cheat_client.aimbot.silent_position then
                                    
                                    if data.ClientData and data.ClientData.Mouse then
                                        local pos = cheat_client.aimbot.silent_position
                                        
                                        data.ClientData.Mouse = {
                                            ["Instance"] = cheat_client.aimbot.silent_instance,
                                            ["Position"] = pos
                                        }
                                    end
                                end
                            end
                        end
                    end
                end
                
                return cheat_client.silent_aim_original_namecall(self, ...)
            end)
            
            -- Mark that hook is active
            cheat_client.silent_aim_hook = true

            cheat_client.start_silent_aim_rendering = start_silent_aim_rendering
            cheat_client.stop_silent_aim_rendering = stop_silent_aim_rendering

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
            local death_connection

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

                local character = plr.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        death_connection = utility:Connection(humanoid.Died, function()
                            if Toggles.better_flight then
                                Toggles.better_flight:SetValue(false)
                            end
                        end)
                    end
                end

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
                    if not plr.Character or not FindFirstChild(plr.Character, "HumanoidRootPart") then return end

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

                if death_connection then
                    death_connection:Disconnect()
                    death_connection = nil
                end
            end

            cheat_client.start_better_flight = start_better_flight
            cheat_client.stop_better_flight = stop_better_flight
        end

        do -- Fling
            local flingEnabled = false
            local Y_VELOCITY = 9e9
            local death_connection
            local FLING_FLIGHT_SPEED = 50
            local was_noclip_enabled_fling = false

            local function start_fling()
                if cheat_client.feature_connections.fling then return end

                flingEnabled = true

                local character = plr.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        death_connection = utility:Connection(humanoid.Died, function()
                            if Toggles.fling then
                                Toggles.fling:SetValue(false)
                            end
                        end)
                    end
                end

                cheat_client.feature_connections.fling = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                    local character = plr.Character
                    if not character or not flingEnabled then return end

                    local rootPart = FindFirstChild(character, "HumanoidRootPart")
                    if not rootPart then return end

                    local camCFrame = workspace.CurrentCamera.CFrame
                    local huma = FindFirstChildOfClass(character, "Humanoid")

                    for i, v in next, character:GetDescendants() do
                        if v:IsA("BasePart") then
                            v.Velocity = Vector3.new()
                            v.CanCollide = false
                            if v ~= rootPart then
                                v.RotVelocity = Vector3.new(0, 0, 0)
                            end
                        end
                    end

                    if not was_noclip_enabled_fling and huma then
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

                    was_noclip_enabled_fling = true

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

                        local isMovingDown = cheat_client.custom_flight_functions["IsKeyDown"](uis, "LeftShift")
                        if not isMovingDown and rootPart.AssemblyLinearVelocity.Y < 0 then
                            local currentVelocity = rootPart.AssemblyLinearVelocity
                            rootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
                        end

                        if eVector.Unit.X == eVector.Unit.X then
                            local flight_speed = Options.fling_flight_speed and Options.fling_flight_speed.Value or 50
                            rootPart.AssemblyLinearVelocity = eVector.Unit * flight_speed
                        else
                            local currentVel = rootPart.AssemblyLinearVelocity
                            rootPart.AssemblyLinearVelocity = currentVel * 0.85
                        end

                        local shouldAnchor = eVector == Vector3.new() or rootPart.AssemblyLinearVelocity.Magnitude < 1
                        rootPart.Anchored = shouldAnchor
                    end
                end))

                cheat_client.feature_connections.fling_heartbeat = utility:Connection(rs.Heartbeat, function()
                    if not flingEnabled then return end

                    local character = plr.Character
                    if not character then return end

                    local originalVelocities = {}
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            originalVelocities[part] = part.AssemblyLinearVelocity
                            part.AssemblyLinearVelocity = Vector3.new(0, Y_VELOCITY, 0)
                        end
                    end

                    rs.RenderStepped:Wait()

                    if not flingEnabled then
                        for part, _ in pairs(originalVelocities) do
                            if part and part.Parent then
                                part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            end
                        end
                        return
                    end

                    for part, velocity in pairs(originalVelocities) do
                        if part and part.Parent then
                            part.AssemblyLinearVelocity = velocity
                        end
                    end
                end)
            end

            local function stop_fling()
                flingEnabled = false

                rs.Heartbeat:Wait()
                rs.RenderStepped:Wait()

                if cheat_client.feature_connections.fling then
                    cheat_client.feature_connections.fling:Disconnect()
                    cheat_client.feature_connections.fling = nil
                end

                if cheat_client.feature_connections.fling_heartbeat then
                    cheat_client.feature_connections.fling_heartbeat:Disconnect()
                    cheat_client.feature_connections.fling_heartbeat = nil
                end

                if death_connection then
                    death_connection:Disconnect()
                    death_connection = nil
                end

                if plr and plr.Character then
                    local character = plr.Character
                    local huma = FindFirstChildOfClass(character, "Humanoid")
                    local rootPart = FindFirstChild(character, "HumanoidRootPart")

                    if rootPart then
                        rootPart.Anchored = false
                    end

                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            part.Velocity = Vector3.new(0, 0, 0)

                            -- Restore collision
                            if part.Name ~= "HumanoidRootPart" then
                                if part.Name == "Head" or part.Name == "Torso" then
                                    part.CanCollide = true
                                else
                                    part.CanCollide = false
                                end
                            end
                        end
                    end

                    if huma then
                        huma:SetStateEnabled(5, true)
                        huma:ChangeState(Enum.HumanoidStateType.Physics)
                        task.wait()
                        huma:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end

                was_noclip_enabled_fling = false
            end

            cheat_client.start_fling = start_fling
            cheat_client.stop_fling = stop_fling
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
    end
    end, function(err)
        return debug.traceback(err, 2)
    end)

    if not success then
        if key then
            getgenv()[key] = nil
        end
        warn("[hydroxide.sol] Script error:", err)
    end
end