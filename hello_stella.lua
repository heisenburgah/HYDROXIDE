-- // hydroxide.solutions PROPIETRARRY code?????

--[[
getgenv().stella_token = "the_token_here"
getgenv().stella_debug = false  -- optional, enables debug logging

pcall(function()
    loadstring(game:HttpGet("https://api.hydroxide.solutions/hello.lua",true))()
end)
--]]

if not game:IsLoaded() then
    game.Loaded:Wait()
end

if game.GameId ~= 1087859240 then
    return
end

local cloneref = cloneref or function(v) return v end
local req = http_request or request
local function generate_key()
    local players_service = cloneref(game:GetService("Players"))
    local str = game.PlaceId ..
        "_" .. game.JobId:sub(1, 5) .. "_" .. tostring(players_service.LocalPlayer.UserId):sub(-3)
    local chars = {}
    for i = 1, #str do
        local char = string.byte(str, i)
        chars[i] = string.char(bit32.bxor(char, 27 + (i % 7)))
    end
    return table.concat(chars)
end

if not getgenv().stella_token then
    warn("Stella | stella_token not set! Set getgenv().stella_token before loading.")
    return
end

local _key = generate_key()
if getgenv()[_key] and type(getgenv()[_key]) == "table" then
    --warn("Stella | already running!")
    return
end

getgenv()[_key] = setmetatable({}, { __tostring = function() return "nil" end })
local user_token = getgenv().stella_token
local user_debug = getgenv().stella_debug or false
getgenv().stella_token = nil
getgenv().stella_debug = nil

local success, err = xpcall(function()
    local config = {
        api_url = "https://stella.heroinhound.cc/api/bulk",
        api_token = user_token,
        send_interval = 35,
        api_fetch_interval = 300, -- seconds between Roblox API server list fetches

        debug = user_debug,
    }

    local function debug_info(level, ...)
        if not config.debug then return end
        if level == "warn" then
            warn("[Stella]", ...)
        else
            print("[Stella]", ...)
        end
    end

    local services = setmetatable({}, {
        __index = function(self, name)
            local success, result = pcall(game.GetService, game, name)
            if success then
                local service = cloneref(result)
                rawset(self, name, service)
                return service
            end
            debug_info("warn", "Invalid Service:", tostring(name))
        end
    })

    for _, v in pairs(getconnections(services.ScriptContext.Error)) do
        v:Disable()
    end

    local http_service = services.HttpService
    local players = services.Players
    local replicated_storage = services.ReplicatedStorage
    local workspace = services.Workspace

    local race_colors = {}
    local race_eye_colors = {}
    local player_races = {}

    local race_tools = {
        ["Bloodline"] = "Haseldan",
        ["Awakened"] = "Dzin",
        ["Dissolve"] = "Fischeran",
        ["Flood"] = "Rigan",
        ["Tempest Soul"] = "Vind",
        ["Flock"] = "Morvid",
        ["Soul Rip"] = "Dinakeri",
        ["Shift"] = "Madrasian",
        ["Vagrant Soul"] = "Lich",
        ["Emulate"] = "LesserNavaran",
        ["Jack"] = "Navaran",
        ["Respirare"] = "Kasparan",
        ["Repair"] = "Gaian",
        ["Galvanize"] = "Construct",
        ["Pumpkin Grenade"] = "Dullahan",
        ["Biting Grenade"] = "Dullahan",
    }

    local function colors_match(c1, c2, tolerance)
        if not c1 or not c2 then return false end
        tolerance = tolerance or 0.01
        local success, result = pcall(function()
            return math.abs(c1.R - c2.R) <= tolerance
                and math.abs(c1.G - c2.G) <= tolerance
                and math.abs(c1.B - c2.B) <= tolerance
        end)
        return success and result
    end

    local function init_race_colors()
        local info = replicated_storage:FindFirstChild("Info")
        if not info then return end

        local races = info:FindFirstChild("Races")
        if not races then return end

        for _, race_category in next, races:GetChildren() do
            if not race_category:IsA("Folder") then continue end

            local direct_skin_color = race_category:FindFirstChild("SkinColor")
            if direct_skin_color and direct_skin_color:IsA("Color3Value") then
                table.insert(race_colors, {
                    direct_skin_color.Value,
                    race_category.Name
                })
            end

            local direct_eye_color = race_category:FindFirstChild("EyeColor")
            if direct_eye_color and direct_eye_color:IsA("Color3Value") then
                table.insert(race_eye_colors, {
                    direct_eye_color.Value,
                    race_category.Name
                })
            end

            for _, race_variant in next, race_category:GetChildren() do
                if not race_variant:IsA("Folder") then continue end

                local skin_color = race_variant:FindFirstChild("SkinColor")
                if skin_color and skin_color:IsA("Color3Value") then
                    table.insert(race_colors, {
                        skin_color.Value,
                        race_category.Name
                    })
                end

                local eye_color = race_variant:FindFirstChild("EyeColor")
                if eye_color and eye_color:IsA("Color3Value") then
                    table.insert(race_eye_colors, {
                        eye_color.Value,
                        race_variant.Name ~= race_category.Name and race_category.Name or race_category.Name
                    })
                end
            end
        end

        -- Cameo: unique eye color (111, 16, 158) in 0-255 scale
        table.insert(race_eye_colors, {
            Color3.fromRGB(111, 16, 158),
            "Cameo"
        })
    end

    local function get_player_tools(player)
        local tools = {}

        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            local success, children = pcall(function() return backpack:GetChildren() end)
            if success and children then
                for _, tool in ipairs(children) do
                    if tool:IsA("Tool") or tool:IsA("Folder") then
                        table.insert(tools, tool.Name)
                    end
                end
            end
        end

        local character = player.Character
        if character then
            local success, children = pcall(function() return character:GetChildren() end)
            if success and children then
                for _, tool in ipairs(children) do
                    if tool:IsA("Tool") then
                        table.insert(tools, tool.Name)
                    end
                end
            end
        end

        return tools
    end

    local function get_player_race(player)
        if player_races[player] and tick() - player_races[player].last_update_at <= 5 then
            return player_races[player].name
        end

        local race_found = "Unknown"
        local character = player.Character

        if not character then
            return race_found
        end

        local scroom_head = character:FindFirstChild("ScroomHead")
        local is_metascroom = scroom_head and pcall(function() return scroom_head.Material.Name end) and
            scroom_head.Material.Name == "DiamondPlate"

        if scroom_head then
            if is_metascroom then
                race_found = "Metascroom"
            else
                race_found = "Scroom"
            end
            player_races[player] = {
                last_update_at = tick(),
                name = race_found
            }
            return race_found
        end

        local player_tools = get_player_tools(player)

        local tool_set = {}
        for _, t in ipairs(player_tools) do
            tool_set[t] = true
        end

        for _, tool_name in ipairs(player_tools) do
            local race = race_tools[tool_name]
            if race then
                if tool_name == "Soul Rip" and (tool_set["Dark Charged Blow"] or tool_set["Mirror"]) then
                    continue
                end
                if tool_name == "Repair" and is_metascroom then
                    continue
                end
                if tool_name == "Emulate" and tool_set["Jack"] then
                    continue
                end
                race_found = race
                break
            end
        end

        if race_found == "Unknown" then
            local head = character:FindFirstChild("Head")
            if head then
                local rl_face = head:FindFirstChild("RLFace")
                if rl_face then
                    local ok, eye_color = pcall(function() return rl_face.Color3 end)
                    if ok and eye_color then
                        for _, v in next, race_eye_colors do
                            local ref_color, race_name = v[1], v[2]
                            if colors_match(eye_color, ref_color) then
                                race_found = race_name
                                break
                            end
                        end
                    end
                end

                if race_found == "Unknown" then
                    local success, head_color = pcall(function() return head.Color end)
                    if success and head_color then
                        for _, v in next, race_colors do
                            local skin_color, race_name = v[1], v[2]
                            if colors_match(head_color, skin_color) then
                                race_found = race_name
                                break
                            end
                        end
                    end
                end
            end
        end

        player_races[player] = {
            last_update_at = tick(),
            name = race_found
        }

        return race_found
    end

    local function get_player_artifact(player)
        local character = player.Character
        if not character then return nil end

        local artifacts_folder = character:FindFirstChild("Artifacts")
        if not artifacts_folder then return nil end

        local success, children = pcall(function() return artifacts_folder:GetChildren() end)
        if not success or not children then return nil end
        if #children == 0 then return "None" end

        for _, v in pairs(children) do
            if v.Name ~= " " and v.Name ~= "" then
                return v.Name
            end
        end

        return "None"
    end

    local function get_edict_hint(player)
        local character = player.Character
        if not character then return nil end

        local head = character:FindFirstChild("Head")
        if not head then return nil end

        local facial_marking = head:FindFirstChild("FacialMarking")
        if not facial_marking then return nil end

        local success, texture = pcall(function() return tostring(facial_marking.Texture) end)
        if not success or not texture then return nil end

        local base_url = "http://www.roblox.com/asset/?id="
        if texture == base_url .. "4072968006" then
            return "Healer"
        elseif texture == base_url .. "4072968656" then
            return "Blademaster"
        elseif texture == base_url .. "4072914434" then
            return "Seer"
        end

        return nil
    end

    local function get_player_dye(player)
        local character = player.Character
        if not character then return nil end

        local shirt = character:FindFirstChildOfClass("Shirt")
        if not shirt then return nil end

        local success, color = pcall(function() return tostring(shirt.Color3) end)
        if not success then return nil end

        return color
    end

    local function get_player_attr(player, attr_name)
        if game.PlaceId == 3541987450 then
            local success, result = pcall(function()
                return player.leaderstats[attr_name].Value
            end)
            if success then return result end
        else
            local success, result = pcall(function()
                return player:GetAttribute(attr_name)
            end)
            if success then return result end
        end
        return nil
    end

    local function get_player_name(player)
        local first_name = get_player_attr(player, "FirstName")
        if not first_name or first_name == "" then
            for _ = 1, 6 do -- check if attributes have not replicated yet -zyu
                task.wait(0.5)
                first_name = get_player_attr(player, "FirstName")
                if first_name and first_name ~= "" then break end
            end
        end
        if not first_name or first_name == "" then
            return "Unknown"
        end

        local uber_title = get_player_attr(player, "UberTitle")
        if uber_title and uber_title ~= "" then
            return first_name .. ", " .. uber_title
        end

        return first_name
    end

    local function get_player_house(player)
        local last_name = get_player_attr(player, "LastName")
        if last_name and last_name ~= "" then
            return last_name
        end
        return nil
    end

    local function get_lord_status(player)
        local house_rank = get_player_attr(player, "HouseRank")
        if not house_rank then return nil end

        if house_rank == "Owner" then
            local gender = get_player_attr(player, "Gender")
            if gender == "Female" then
                return "Lady"
            else
                return "Lord"
            end
        end
        return nil
    end

    local function get_player_gender(player)
        local gender = get_player_attr(player, "Gender")
        if not gender then return true end
        return gender == "Male"
    end

    local function get_location_name(player)
        local success, result = pcall(function()
            local pos = nil

            local recently_spawned = player:FindFirstChild("RecentlySpawned")
            if recently_spawned and recently_spawned:IsA("Vector3Value") then
                pos = recently_spawned.Value
            end

            if not pos and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pos = hrp.Position
                end
            end

            if not pos then return nil end
            local area_markers = workspace:FindFirstChild("AreaMarkers")
            if not area_markers then
                return string.format("(%.0f, %.0f, %.0f)", pos.X, pos.Y, pos.Z)
            end

            local location_name = nil
            local markers = area_markers:GetChildren()
            local ray_params = RaycastParams.new()
            ray_params.FilterType = Enum.RaycastFilterType.Include
            ray_params.FilterDescendantsInstances = { area_markers }

            local ray_result = workspace:Raycast(pos, Vector3.new(0, -1, 0) * 9999, ray_params)
            if ray_result and ray_result.Instance then
                local hit = ray_result.Instance
                if hit.Parent == area_markers then
                    location_name = hit.Name
                else
                    for _, marker in pairs(markers) do
                        if hit:IsDescendantOf(marker) then
                            location_name = marker.Name
                            break
                        end
                    end
                end
            end

            if not location_name then
                local closest_dist = math.huge
                for _, marker in pairs(markers) do
                    local dist = (marker.Position - pos).Magnitude
                    if dist < closest_dist then
                        closest_dist = dist
                        location_name = marker.Name
                    end
                end
            end

            if location_name then
                return string.format("%s (%.0f, %.0f, %.0f)", location_name, pos.X, pos.Y, pos.Z)
            end

            return string.format("(%.0f, %.0f, %.0f)", pos.X, pos.Y, pos.Z)
        end)

        return success and result or nil
    end

    local function get_player_blessings(player)
        if game.PlaceId ~= 3541987450 then
            return nil
        end

        local success, result = pcall(function()
            if not player.Character then return nil end
            local blessings_folder = player.Character:FindFirstChild("Blessings")
            if not blessings_folder then return nil end

            local blessing_names = {}
            for _, blessing in pairs(blessings_folder:GetChildren()) do
                table.insert(blessing_names, blessing.Name)
            end

            if #blessing_names > 0 then
                return table.concat(blessing_names, ", ")
            end
            return nil
        end)

        if success then
            return result
        end
        return nil
    end

    local function get_player_outfit(player)
        local outfit_assets = replicated_storage:FindFirstChild("Assets") and replicated_storage.Assets:FindFirstChild("Outfits")
        if not outfit_assets then return nil end
        local character = player.Character
        if not character then return nil end

        local success, result = pcall(function()
            local player_pants = nil
            for _, v in pairs(character:GetChildren()) do
                if v.ClassName == "Pants" then
                    player_pants = v
                    break
                end
            end
            if not player_pants then return nil end

            for _, outfit in pairs(outfit_assets:GetChildren()) do
                for _, gender_name in ipairs({"Male", "Female"}) do
                    local gender_folder = outfit:FindFirstChild(gender_name)
                    if gender_folder then
                        local pants = gender_folder:FindFirstChild("Pants")
                        if pants and pants:IsA("Pants") and player_pants.PantsTemplate == pants.PantsTemplate then
                            return outfit.Name
                        end
                    end
                end
            end
            return nil
        end)

        if success then return result end
        return nil
    end

    local function get_player_data(player)
        local character = player.Character

        local first_name = get_player_name(player)
        if first_name == "Unknown" then
            return nil -- Skip player, attributes not loaded yet
        end

        local data = {
            roblox_id = player.UserId,
            roblox_username = player.Name,
            first_name = first_name,
            house = get_player_house(player),
            is_male = get_player_gender(player),
            lord_status = get_lord_status(player),
            location = game.JobId,
            last_position = get_location_name(player),
        }

        if character then
            data.backpack_data = get_player_tools(player)
            data.edict_hint = get_edict_hint(player)
            data.race = get_player_race(player)
            data.artifacts = get_player_artifact(player)
            data.dye = get_player_dye(player)
            data.blessings = get_player_blessings(player)
            data.outfit = get_player_outfit(player)
        end

        return data
    end

    local function get_all_servers()
        local servers = {}
        local server_info_folder = replicated_storage:FindFirstChild("ServerInfo")

        if not server_info_folder then
            return servers
        end

        for _, job_folder in ipairs(server_info_folder:GetChildren()) do
            if not job_folder:IsA("Folder") then continue end

            local job_id = job_folder.Name

            local houses_value = job_folder:FindFirstChild("Houses")
            local houses = nil
            if houses_value and houses_value:IsA("StringValue") then
                local success, decoded = pcall(function()
                    return http_service:JSONDecode(houses_value.Value)
                end)
                if success then
                    houses = decoded
                end
            end

            local players_value = job_folder:FindFirstChild("Players")
            local server_player_list = {}
            if players_value and players_value:IsA("StringValue") then
                local success, decoded = pcall(function()
                    return http_service:JSONDecode(players_value.Value)
                end)
                if success and type(decoded) == "table" then
                    -- [{Name, UserId}, ...]
                    for _, player_data in ipairs(decoded) do
                        if type(player_data) == "table" and player_data.UserId then
                            table.insert(server_player_list, {
                                name = player_data.Name,
                                id = player_data.UserId
                            })
                        elseif type(player_data) == "number" then
                            table.insert(server_player_list, {
                                name = "Unknown",
                                id = player_data
                            })
                        end
                    end
                end
            end

            local server_name_value = job_folder:FindFirstChild("ServerName")
            local region_value = job_folder:FindFirstChild("Region")
            local version_value = job_folder:FindFirstChild("Version")
            local lifespan_value = job_folder:FindFirstChild("Lifespan")
            local origin_value = job_folder:FindFirstChild("Origin")
            local last_heard_value = job_folder:FindFirstChild("LastHeardFrom")

            table.insert(servers, {
                job_id = job_id,
                place_id = game.PlaceId,
                server_name = server_name_value and server_name_value.Value or "Unknown Server",
                players = server_player_list, -- [{name, id}, ...]
                region = region_value and region_value.Value or nil,
                version = version_value and tostring(version_value.Value) or nil,
                houses = houses,
                lifespan = lifespan_value and lifespan_value.Value or nil,
                origin = origin_value and origin_value.Value or nil,
                last_heard_from = last_heard_value and last_heard_value.Value or nil,
                is_public = true,
            })
        end

        return servers
    end

    local last_api_fetch_time = 0

    local function fetch_roblox_api_servers()
        local now = os.time()
        if now - last_api_fetch_time < config.api_fetch_interval then
            return {}
        end
        last_api_fetch_time = now

        local api_servers = {}
        local place_id = game.PlaceId
        local url = "https://games.roblox.com/v1/games/" ..
            place_id .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=false"

        local ok, response = pcall(req, {
            Url = url,
            Method = "GET",
        })

        if not ok or not response or not response.Success then
            debug_info("warn", "Failed to fetch Roblox API servers:",
                ok and (response and response.StatusCode or "no response") or tostring(response))
            return {}
        end

        local decode_ok, data = pcall(function()
            return http_service:JSONDecode(response.Body)
        end)

        if not decode_ok or type(data) ~= "table" or not data.data then
            return {}
        end

        for _, srv in ipairs(data.data) do
            if srv.id then
                table.insert(api_servers, {
                    job_id = srv.id,
                    place_id = place_id,
                    server_name = "ROBLOX API",
                    players = srv.playing or 0,
                    max_players = srv.maxPlayers or 23,
                    is_public = false,
                })
            end
        end

        debug_info("print", "Fetched", #api_servers, "servers from Roblox API")
        return api_servers
    end

    local function collect_all_data()
        local player_list = {}
        local current_player_list = {}
        local local_player = players.LocalPlayer

        for _, player in ipairs(players:GetPlayers()) do
            if player == local_player then
                continue
            end

            local success, player_data = pcall(get_player_data, player)
            if success and player_data then
                table.insert(player_list, player_data)
                table.insert(current_player_list, {
                    name = player.Name,
                    id = player.UserId
                })
            else
                debug_info("warn", "Failed to collect data for player:", player.Name, "| Error:", tostring(player_data))
                table.insert(current_player_list, {
                    name = player.Name,
                    id = player.UserId
                })
            end
        end

        local success, servers = pcall(get_all_servers)
        if not success then
            debug_info("warn", "Failed to collect server data:", tostring(servers))
            servers = {}
        end

        local current_job_id = game.JobId
        local found_current = false
        for _, server in ipairs(servers) do
            if server.job_id == current_job_id then
                server.players = current_player_list
                found_current = true
                break
            end
        end

        if not found_current and current_job_id ~= "" then
            local server_name = "Unknown Server"
            local region = nil
            local version = nil

            local gui_success, _ = pcall(function()
                local stats_gui = players.LocalPlayer.PlayerGui:FindFirstChild("ServerStatsGui")
                if stats_gui then
                    local frame = stats_gui:FindFirstChild("Frame")
                    if frame then
                        local stats = frame:FindFirstChild("Stats")
                        if stats then
                            local name_label = stats:FindFirstChild("ServerName")
                            if name_label and name_label.Text then
                                server_name = name_label.Text:gsub("^Server Name: ", "")
                            end

                            local region_label = stats:FindFirstChild("ServerRegion")
                            if region_label and region_label.Text then
                                region = region_label.Text:gsub("^Server Region: ", "")
                            end

                            local version_label = stats:FindFirstChild("ServerVersion")
                            if version_label and version_label.Text then
                                version = version_label.Text:gsub("^Server Version: v", "")
                            end
                        end
                    end
                end
            end)

            table.insert(servers, {
                job_id = current_job_id,
                place_id = game.PlaceId,
                server_name = server_name,
                players = current_player_list,
                region = region,
                version = version,
                is_public = false,
            })
        end
        
        local known_job_ids = {}
        for _, server in ipairs(servers) do
            known_job_ids[server.job_id] = true
        end

        local api_servers = fetch_roblox_api_servers()
        for _, api_srv in ipairs(api_servers) do
            if not known_job_ids[api_srv.job_id] then
                table.insert(servers, api_srv)
            end
        end

        return {
            players = player_list,
            servers = servers,
            sender_job_id = game.JobId,
        }
    end

    local function generate_signature(token, timestamp, sender_id, job_id, body)
        local body_hash = crypt.hash(body, "sha256")
        return crypt.hash(token .. timestamp .. sender_id .. job_id .. body_hash, "sha256")
    end

    local function send_payload(payload)
        local json_payload = http_service:JSONEncode(payload)
        local timestamp = tostring(os.time())
        local sender_id = tostring(players.LocalPlayer.UserId)
        local job_id = game.JobId
        local signature = generate_signature(config.api_token, timestamp, sender_id, job_id, json_payload)

        local success, response = pcall(req, {
            Url = config.api_url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer " .. config.api_token,
                ["X-Timestamp"] = timestamp,
                ["X-Sender-ID"] = sender_id,
                ["X-Job-ID"] = job_id,
                ["X-Signature"] = signature,
            },
            Body = json_payload,
        })

        if success and response.Success then
            debug_info("print", "Data sent successfully:", response.Body)
        elseif success then
            debug_info("warn", "API error:", response.StatusCode, response.StatusMessage)
        else
            debug_info("warn", "Request failed:", response)
        end

        return success and response.Success
    end

    local function send_player_leave(roblox_id)
        local leave_url = config.api_url:gsub("/bulk$", "/player/leave")
        local json_payload = http_service:JSONEncode({ roblox_id = roblox_id })
        local timestamp = tostring(os.time())
        local sender_id = tostring(players.LocalPlayer.UserId)
        local job_id = game.JobId
        local signature = generate_signature(config.api_token, timestamp, sender_id, job_id, json_payload)

        local success, response = pcall(req, {
            Url = leave_url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer " .. config.api_token,
                ["X-Timestamp"] = timestamp,
                ["X-Sender-ID"] = sender_id,
                ["X-Job-ID"] = job_id,
                ["X-Signature"] = signature,
            },
            Body = json_payload,
        })

        if success and response.Success then
            debug_info("print", "Player leave sent for:", roblox_id)
        elseif success then
            debug_info("warn", "Player leave API error:", response.StatusCode)
        else
            debug_info("warn", "Player leave request failed:", response)
        end
    end

    local function send_unobserve()
        local unobserve_url = config.api_url:gsub("/bulk$", "/server/unobserve")
        local job_id = game.JobId
        local json_payload = http_service:JSONEncode({ job_id = job_id })
        local timestamp = tostring(os.time())
        local sender_id = tostring(players.LocalPlayer.UserId)
        local signature = generate_signature(config.api_token, timestamp, sender_id, job_id, json_payload)

        local success, response = pcall(req, {
            Url = unobserve_url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer " .. config.api_token,
                ["X-Timestamp"] = timestamp,
                ["X-Sender-ID"] = sender_id,
                ["X-Job-ID"] = job_id,
                ["X-Signature"] = signature,
            },
            Body = json_payload,
        })

        if success and response.Success then
            debug_info("print", "Server unobserve sent for:", game.JobId)
        elseif success then
            debug_info("warn", "Server unobserve API error:", response.StatusCode)
        else
            debug_info("warn", "Server unobserve request failed:", response)
        end
    end

    local function send_batch_player_leave(roblox_ids, job_id)
        local batch_url = config.api_url:gsub("/bulk$", "/players/leave")
        local payload = { roblox_ids = roblox_ids }
        if job_id then
            payload.job_id = job_id
        end
        local json_payload = http_service:JSONEncode(payload)
        local timestamp = tostring(os.time())
        local sender_id = tostring(players.LocalPlayer.UserId)
        local sig_job_id = game.JobId
        local signature = generate_signature(config.api_token, timestamp, sender_id, sig_job_id, json_payload)

        local success, response = pcall(req, {
            Url = batch_url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer " .. config.api_token,
                ["X-Timestamp"] = timestamp,
                ["X-Sender-ID"] = sender_id,
                ["X-Job-ID"] = sig_job_id,
                ["X-Signature"] = signature,
            },
            Body = json_payload,
        })

        if success and response.Success then
            debug_info("print", "Batch player leave sent for", #roblox_ids, "players")
        elseif success then
            debug_info("warn", "Batch player leave API error:", response.StatusCode)
        else
            debug_info("warn", "Batch player leave request failed:", response)
        end
    end

    local function main()
        debug_info("print", "Player data collector started")
        debug_info("print", "Sending data every", config.send_interval, "seconds")

        init_race_colors()

        while true do
            local payload = collect_all_data()
            debug_info("print", "Collected", #payload.players, "players")
            send_payload(payload)
            task.wait(config.send_interval)
        end
    end

    task.spawn(main)

    players.PlayerAdded:Connect(function(player)
        task.wait(5)
        local payload = collect_all_data()
        send_payload(payload)
    end)

    local server_leaving = false

    players.PlayerRemoving:Connect(function(player)
        if player_races[player] then
            player_races[player] = nil
        end

        if player == players.LocalPlayer then
            -- Leaving server: batch-clear all players + unobserve in one request
            server_leaving = true
            local roblox_ids = {}
            for _, p in ipairs(players:GetPlayers()) do
                table.insert(roblox_ids, p.UserId)
            end
            send_batch_player_leave(roblox_ids, game.JobId)
            return
        end

        -- Normal single-player departure (skip if server is shutting down)
        if server_leaving then return end
        task.spawn(function()
            send_player_leave(player.UserId)
        end)
        task.wait(1)
        local payload = collect_all_data()
        send_payload(payload)
    end)
end, function(err)
    return debug.traceback(err, 2)
end)

if not success then
    warn("[Stella] Script error:", err)
end
