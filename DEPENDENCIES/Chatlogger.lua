-- wait what. Hydroxide chat logger semi open source? Thx to Phrax.
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local CoreGui = cloneref(game:GetService("CoreGui"))
local HttpService = game:GetService("HttpService")

local LoggerGui = {}
LoggerGui.__index = LoggerGui

local HIGHLIGHT_WORDS = {
	"clipped",
	"clip",
	"your banned",
	"banned",
	"recorded",
	"reporting",
	"exploiter",
	"hacker",
	"cheater",
	"hack",
	"exploiting",
	"hacking",
	"cheating",
	"report",
	"reported",
	"ban",
	"blacklisted",
	"hydroxide"
}
local HIGHLIGHT_COLOR = Color3.fromRGB(255, 100, 100)

local antiblackpeople = {
	["@"] = "a",
	["4"] = "a",
	["^"] = "a",
	["1"] = "i",
	["!"] = "i",
	["|"] = "i",
	["3"] = "e",
	["€"] = "e",
	["0"] = "o",
	["$"] = "s",
	["5"] = "s",
	["+"] = "t",
	["7"] = "t",
	["8"] = "b",
	["%"] = "o",
	["|"] = "l",
	["£"] = "l",
	["?"] = "q",
	["9"] = "g",
	["6"] = "g",
	["("] = "c",
	[")"] = "c",
	["<"] = "c",
	["}"] = "d",
	["+"] = "t",
	["*"] = "x",
	["#"] = "h",
	["&"] = "n",
	["~"] = "n",
	["`"] = "l",
	[":"] = "i",
	[";"] = "i",
	["<"] = "k"
}
local function bypassblackpeople(msg)
	msg = msg:lower()
	for k, v in pairs(antiblackpeople) do
		local key = k:gsub("([^%w])","%%%1")
		msg = msg:gsub(key, v)
	end
	return msg
end

local function goingtojail(msg)
	local normalized = bypassblackpeople(msg)
	for _, word in ipairs(HIGHLIGHT_WORDS) do
		if normalized:find(word:lower(), 1, true) then
			return true
		end
	end
	return false
end

local function createFrame(name, size, position, backgroundColor, transparency)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = size
	frame.Position = position
	frame.BackgroundColor3 = backgroundColor
	frame.BackgroundTransparency = transparency or 0
	frame.BorderSizePixel = 0
	return frame
end

local function createButton(name, size, position, text, bgColor, transparency)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = size
	button.Position = position
	button.BackgroundColor3 = bgColor
	button.BackgroundTransparency = transparency or 0
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 14
	button.Font = Enum.Font.GothamBold
	return button
end

local function createTextBox(name, size, position, placeholder)
	local textBox = Instance.new("TextBox")
	textBox.Name = name
	textBox.Size = size
	textBox.Position = position
	textBox.PlaceholderText = placeholder
	textBox.Text = ""
	textBox.ClearTextOnFocus = false
	textBox.TextColor3 = Color3.fromRGB(245, 245, 245)
	textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	textBox.BackgroundTransparency = 0.45
	textBox.BorderSizePixel = 0
	textBox.Font = Enum.Font.Gotham
	textBox.TextSize = 14
	textBox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
	return textBox
end

local function addCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
	return corner
end

local function addStroke(parent, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = thickness
	stroke.Transparency = transparency
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	return stroke
end

function LoggerGui.new(cheat_client, utility)
	if CoreGui:FindFirstChild("LoggerGui") then
		CoreGui.LoggerGui:Destroy()
	end

	local self = setmetatable({}, LoggerGui)
	self.utility = utility

	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "LoggerGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = CoreGui

	local mainFrame = createFrame("MainFrame", UDim2.new(0, 600, 0, 370), UDim2.new(0.5, -300, 0.5, -225), Color3.fromRGB(20, 20, 20), 0.12)
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = screenGui
	addStroke(mainFrame, 1, 0.75)
	addCorner(mainFrame, 8)

	local chatlogger_data_file = "HYDROXIDE/bin/chatlogger_data.json"
	if isfile and readfile and isfile(chatlogger_data_file) then
		local success, data = pcall(function()
			return HttpService:JSONDecode(readfile(chatlogger_data_file))
		end)
		if success and data then
			if data.position and #data.position == 4 then
				mainFrame.Position = UDim2.new(data.position[1], data.position[2], data.position[3], data.position[4])
			end
			if data.size and #data.size == 4 then
				mainFrame.Size = UDim2.new(data.size[1], data.size[2], data.size[3], data.size[4])
			end
		end
	end

	local save_debounce = false
	local function saveWindowData()
		if save_debounce then return end
		save_debounce = true

		task.spawn(function()
			task.wait(0.05)
			save_debounce = false

			local pos = mainFrame.Position
			local size = mainFrame.Size
			local data = {
				position = {pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset},
				size = {size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset}
			}

			if writefile and HttpService then
				pcall(function()
					if not isfolder("HYDROXIDE") then makefolder("HYDROXIDE") end
					writefile(chatlogger_data_file, HttpService:JSONEncode(data))
				end)
			end
		end)
	end

	utility:Connection(mainFrame:GetPropertyChangedSignal("Position"), saveWindowData)
	utility:Connection(mainFrame:GetPropertyChangedSignal("Size"), saveWindowData)

	local titleBar = createFrame("TitleBar", UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 0), Color3.fromRGB(30, 30, 30), 0.35)
	titleBar.Parent = mainFrame
	addStroke(titleBar, 1, 0.8)

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(0, 150, 1, 0)
	title.Position = UDim2.new(0, 15, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "Chat Logger"
	title.TextColor3 = Color3.fromRGB(240, 240, 240)
	title.TextSize = 18
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextYAlignment = Enum.TextYAlignment.Center
	title.Parent = titleBar

	local resizeHandle = createFrame("ResizeHandle", UDim2.new(0, 16, 0, 16), UDim2.new(1, -16, 1, -16), Color3.fromRGB(255, 255, 255), 0.92)
	resizeHandle.Parent = mainFrame
	addCorner(resizeHandle, 4)

	local searchBox = createTextBox("SearchBox", UDim2.new(0, 150, 0, 24), UDim2.new(0, 225, 0.5, -12), "Search...")
	searchBox.Parent = titleBar
	addCorner(searchBox, 6)
	addStroke(searchBox, 1, 0.7)

	local messages = {}
	local currentPlayerFilter = "All"
	local currentSpectated = nil

	local function updateSearch()
		local query = searchBox.Text:lower()
		for _, msgLabel in ipairs(messages) do
			local matchesSearch = query == "" or msgLabel.Text:lower():find(query, 1, true)
			local matchesPlayer = currentPlayerFilter == "All" or msgLabel.Text:find("[" .. currentPlayerFilter, 1, true)
			msgLabel.Visible = matchesSearch and matchesPlayer
		end
	end

	local playerFilterButton = createButton("PlayerFilter", UDim2.new(0, 80, 0, 24), UDim2.new(0, 385, 0.5, -12), "All Players", Color3.fromRGB(40, 130, 255), 0.3)
	playerFilterButton.Font = Enum.Font.Gotham
	playerFilterButton.TextSize = 12
	playerFilterButton.Parent = titleBar
	addCorner(playerFilterButton, 6)
	addStroke(playerFilterButton, 1, 0.7)

	utility:Connection(playerFilterButton.MouseButton1Click, function()
		local playerList = {"All"}
		local playerSet = {}

		for _, msgLabel in ipairs(messages) do
			local playerName = msgLabel:GetAttribute("PlayerName")
			if playerName and not playerSet[playerName] then
				playerSet[playerName] = true
				table.insert(playerList, playerName)
			end
		end

		local currentIndex = 1
		for i, name in ipairs(playerList) do
			if name == currentPlayerFilter then
				currentIndex = i
				break
			end
		end

		local nextIndex = (currentIndex % #playerList) + 1
		currentPlayerFilter = playerList[nextIndex]

		if currentPlayerFilter == "All" then
			playerFilterButton.Text = "All Players"
		else
			playerFilterButton.Text = currentPlayerFilter
		end

		updateSearch()
	end)

	local closeButton = createButton("CloseButton", UDim2.new(0, 27, 0, 27), UDim2.new(1, -30, 0.5, -12), "X", Color3.fromRGB(190, 30, 30), 0.18)
	closeButton.Parent = titleBar
	addCorner(closeButton, 4)

	utility:Connection(closeButton.MouseButton1Click, function()
		screenGui:Destroy()
	end)

	local clearButton = createButton("ClearButton", UDim2.new(0, 27, 0, 27), UDim2.new(1, -60, 0.5, -12), "C", Color3.fromRGB(40, 130, 255), 0.18)
	clearButton.Parent = titleBar
	addCorner(clearButton, 4)

	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ChatLog"
	scrollFrame.Size = UDim2.new(1, -20, 1, -50)
	scrollFrame.Position = UDim2.new(0, 10, 0, 50)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollFrame.Parent = mainFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 4)
	listLayout.Parent = scrollFrame
	
	
	local saveButton = createButton("SaveButton", UDim2.new(0, 27, 0, 27), UDim2.new(1, -90, 0.5, -12), "S", Color3.fromRGB(40, 200, 40), 0.18)
	saveButton.Parent = titleBar
	addCorner(saveButton, 4)

	utility:Connection(saveButton.MouseButton1Click, function()
		if not isfolder("HYDROXIDE/Chatlogs") then
			local folderSuccess, folderErr = pcall(function()
				makefolder("HYDROXIDE/Chatlogs")
			end)
			if not folderSuccess then
				warn("Could not create folder: " .. tostring(folderErr))
				return
			end
		end
		local date = os.date("%Y-%m-%d")
        local time = os.date("%H-%M-%S")  
		local lines = {}
		for _, msgLabel in ipairs(messages) do
			table.insert(lines, msgLabel.Text)
		end
		local content = table.concat(lines, "\n")
		local fileName = "HYDROXIDE/Chatlogs/HYDROXIDE Chatlog_" .. date .. "-" .. time .. ".txt"

		local success, err = pcall(function()
			writefile(fileName, content)
		end)
		if success then
			warn("Chat log saved as HYDROXIDE/Chatlogs/HYDROXIDE Chatlog.txt")
		else
			warn("Could not write file: " .. tostring(err))
		end
	end)

	local dragging = false
	local dragStart = Vector2.new()
	local startSize = mainFrame.Size

	utility:Connection(resizeHandle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startSize = mainFrame.Size
			mainFrame.Active = true
			mainFrame.Draggable = false
		end
	end)

	utility:Connection(resizeHandle.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
			mainFrame.Draggable = true
		end
	end)

	utility:Connection(game:GetService("UserInputService").InputChanged, function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Size = UDim2.new(
				0,
				math.clamp(startSize.X.Offset + delta.X, 200, 1200),
				0,
				math.clamp(startSize.Y.Offset + delta.Y, 150, 800)
			)
			if mainFrame.Size.X.Offset < 500 then
				searchBox.Visible = false
				playerFilterButton.Visible = false
			else
				searchBox.Visible = true
				playerFilterButton.Visible = true
			end
		end
	end)

	local searchDebounce
	utility:Connection(searchBox:GetPropertyChangedSignal("Text"), function()
		if searchDebounce then
			task.cancel(searchDebounce)
		end
		searchDebounce = task.delay(0.2, updateSearch)
	end)

	local function addMessage(player, message, chatType, targetName)
		if not cheat_client or not cheat_client.get_name or type(cheat_client.get_name) ~= "function" then
			return
		end

		local time = os.date("%H:%M:%S")
		local playerName = player.Name
		local characterName = cheat_client:get_name(player) or "nil"
		local isLocalPlayer = player == Players.LocalPlayer

		if isLocalPlayer and cheat_client and cheat_client.config and cheat_client.config.streamer_mode then
			playerName = "Ragoozer"
		end

		local chatEntry = Instance.new("TextLabel")
		chatEntry.Size = UDim2.new(1, -10, 0, 0)
		chatEntry.BackgroundTransparency = 1
		chatEntry.TextWrapped = true
		chatEntry.AutomaticSize = Enum.AutomaticSize.Y
		chatEntry.Font = Enum.Font.Gotham
		chatEntry.TextSize = 16
		chatEntry.TextXAlignment = Enum.TextXAlignment.Left
		chatEntry.TextYAlignment = Enum.TextYAlignment.Top

		local displayName = string.format("%s (%s)", playerName, characterName)
		if chatType == "Private" then
			chatEntry.TextColor3 = Color3.fromRGB(100, 180, 255)
			chatEntry.Text = string.format("[%s] [WHISPER to %s] %s: %s", time, targetName, displayName, message)
		elseif isLocalPlayer then
			chatEntry.TextColor3 = Color3.fromRGB(255, 220, 100)
			chatEntry.Text = string.format("[%s] [%s]: %s", time, displayName, message)
		elseif goingtojail(message) then
			chatEntry.TextColor3 = HIGHLIGHT_COLOR
			chatEntry.Text = string.format("[%s] [%s]: %s", time, displayName, message)
		else
			chatEntry.TextColor3 = Color3.fromRGB(240, 240, 240)
			chatEntry.Text = string.format("[%s] [%s]: %s", time, displayName, message)
		end

		chatEntry.TextStrokeTransparency = 0.8
		chatEntry.Parent = scrollFrame
		table.insert(messages, chatEntry)

		if #messages > 1000 then
			messages[1]:Destroy()
			table.remove(messages, 1)
		end

		pcall(function()
			TweenService:Create(scrollFrame, TweenInfo.new(0.15), {
				CanvasPosition = Vector2.new(0, scrollFrame.AbsoluteCanvasSize.Y)
			}):Play()
		end)

		chatEntry:SetAttribute("PlayerName", playerName)

		local localPlayer = Players.LocalPlayer
		local Camera = workspace.CurrentCamera
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

		utility:Connection(chatEntry.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				local targetPlayerName = chatEntry:GetAttribute("PlayerName")

				if targetPlayerName then
					local targetPlayer = Players:FindFirstChild(targetPlayerName)

					if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
						if currentSpectated == targetPlayerName then
							if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
								Camera.CameraSubject = localPlayer.Character.Humanoid
								currentSpectated = nil
							end
						else
							workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
							Camera.CameraSubject = targetPlayer.Character.Humanoid
							currentSpectated = targetPlayerName
						end
					end
				end
			end
		end)
	end


	utility:Connection(clearButton.MouseButton1Click, function()
		for _, child in ipairs(scrollFrame:GetChildren()) do
			if child:IsA("TextLabel") then
				child:Destroy()
			end
		end
		table.clear(messages)
	end)
	
	
	utility:Connection(mainFrame.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton3 then
			pcall(function()
				TweenService:Create(scrollFrame, TweenInfo.new(0.15), {
					CanvasPosition = Vector2.new(0, scrollFrame.AbsoluteCanvasSize.Y)
				}):Play()
			end)
		end
	end)
	

	local MemStorageService = game:GetService("MemStorageService")
	local responses = {
		"I'm flattered you'd think I'm a bot, but unfortunately for your theory, I'm just naturally him—running at a frequency you can't decode.",
		"I'm flattered you'd assume I'm a bot. Sadly for your hypothesis, the reality is far more inconvenient—I'm simply optimized beyond your comprehension.",
		"A bot? No, just a human with above-average reaction time and below-average tolerance for mediocrity.",
		"Not a bot, just built different. Literally and figuratively.",
		"What's hydroxide.solutions?"
	}

	local triggers = {
		"bot",
		"exploiter",
		"are you a bot",
		"hacker",
		"cheater",
		"hacking",
		"are you botting",
		"this is a bot",
		"you're a bot",
		"you are a bot",
		"is this a bot",
		"definitely a bot",
		"such a bot",
		"this guy's botted",
		"script",
		"what script is that",
		"autofarm",
		"you cheat",
		"cheater",
		"hacker",
		"exploiter",
		"sus",
		"ai",
		"robot"
	}

	local cooldowns = {}

	local function trigger_check(msg)
		msg = msg:lower()
		for _, word in ipairs(triggers) do
			if msg == word then
				return true
			end
		end
		return false
	end

	local function send_bot_response(message)
		local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
		if channel then
			pcall(function()
				channel:SendAsync(message)
			end)
		end
	end

	TextChatService.OnIncomingMessage = function(MessageData)
		if MessageData.Status ~= Enum.TextChatMessageStatus.Success then
			return
		end
		if not MessageData.TextSource then
			return
		end

		local player = Players:GetPlayerByUserId(MessageData.TextSource.UserId)
		if not player then
			return
		end

		local message = MessageData.Text
		local chatType = "Public"
		local targetName = nil

		if MessageData.TextChannel then
			local channelName = MessageData.TextChannel.Name

			if channelName:find("Whisper") or channelName:find("Private") then
				chatType = "Private"

				if MessageData.Metadata then
					targetName = MessageData.Metadata.recipient or MessageData.Metadata.targetPlayer or "Unknown"
				end

				if not targetName or targetName == "Unknown" then
					pcall(function()
						local channelMembers = MessageData.TextChannel:GetChildren()
						for _, member in ipairs(channelMembers) do
							if member:IsA("TextSource") and member.UserId ~= player.UserId then
								local targetPlayer = Players:GetPlayerByUserId(member.UserId)
								if targetPlayer then
									targetName = targetPlayer.Name
									break
								end
							end
						end
					end)
				end

				targetName = targetName or "Unknown"
			end
		end

		addMessage(player, message, chatType, targetName)

		if player ~= Players.LocalPlayer then
			local bot_started = pcall(function()
				return MemStorageService:HasItem("botstarted") and MemStorageService:GetItem("botstarted") == "true"
			end) and MemStorageService:HasItem("botstarted") and MemStorageService:GetItem("botstarted") == "true"

			if bot_started and trigger_check(message) and not cooldowns[player.UserId] then
				cooldowns[player.UserId] = true
				local response = responses[math.random(1, #responses)]
				send_bot_response(response)

				task.delay(1.5, function()
					cooldowns[player.UserId] = nil
				end)
			end
		end
	end


	self.GUI = screenGui
	self.MainFrame = mainFrame
	self.ChatLog = scrollFrame
	self.ClearButton = clearButton
	self.SearchBox = searchBox

	return self
end

function LoggerGui:Unload()
	if self.GUI then
		self.GUI:Destroy()
		self.GUI = nil
	end
end

function LoggerGui:Destroy()
	self:Unload()
end

function LoggerGui:SetVisible(visible)
	if self.GUI then
		self.GUI.Enabled = visible
	end
end

return LoggerGui