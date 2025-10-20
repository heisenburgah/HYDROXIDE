-- WAIT WHAT HYDROXIDE CHAT LOGGER OPENSOURCE??!!?!?!?!?!?!?!!?!!?!!?!!?!!?!!?!!?!!?!!!?!?!?!?!!?!!?!!?!!?!!?!!?!!?!!?
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
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

	-- Declare messages table early so button handlers can access it
	local messages: {TextLabel} = {}

	local currentPlayerFilter = "All"

	-- Define updateSearch function early so it can be called by button handlers
	local function updateSearch()
		local query = searchBox.Text:lower()
		for _, msgLabel in ipairs(messages) do
			local matchesSearch = query == "" or msgLabel.Text:lower():find(query)
			local matchesPlayer = currentPlayerFilter == "All" or msgLabel.Text:find("%[" .. currentPlayerFilter)
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
			utility:Connection(input.Changed, function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					mainFrame.Draggable = true
				end
			end)
		end
	end)

	utility:Connection(resizeHandle.InputChanged, function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			utility:Connection(input.Changed, function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					mainFrame.Draggable = true
				end
			end)
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
			if mainFrame.Size.X.Offset < 400 then
				searchBox.Visible = false
			else
				searchBox.Visible = true
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
		local time = os.date("%H:%M:%S")
		local playerName = player.Name
		local characterName = cheat_client and cheat_client:get_name(player) or "nil"

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
			chatEntry.Text = string.format("[%s] [Private Message to %s] %s", time, targetName, message)
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

		local currentSpectated = nil
		local localPlayer = Players.LocalPlayer
		local Camera = workspace.CurrentCamera

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
		messages = {}
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
	

	self.OriginalOnIncomingMessage = TextChatService.OnIncomingMessage
	TextChatService.OnIncomingMessage = function(MessageData)
		print("[Chat Logger] OnIncomingMessage triggered")
		if MessageData.Status ~= Enum.TextChatMessageStatus.Success then
			print("[Chat Logger] Message status not success:", MessageData.Status)
			return
		end
		if not MessageData.TextSource then
			print("[Chat Logger] No TextSource")
			return
		end

		local player = Players:GetPlayerByUserId(MessageData.TextSource.UserId)
		if not player then
			print("[Chat Logger] Player not found for UserId:", MessageData.TextSource.UserId)
			return
		end

		local message = MessageData.Text
		print("[Chat Logger] Adding message from", player.Name, ":", message)
		addMessage(player, message)
	end


	self.GUI = screenGui
	self.MainFrame = mainFrame
	self.ChatLog = scrollFrame
	self.ClearButton = clearButton
	self.SearchBox = searchBox

	return self
end

function LoggerGui:Destroy()
	local TextChatService = game:GetService("TextChatService")
	TextChatService.OnIncomingMessage = self.OriginalOnIncomingMessage

	if self.GUI then
		self.GUI:Destroy()
		self.GUI = nil
	end
end

function LoggerGui:SetVisible(visible)
	if self.GUI then
		self.GUI.Enabled = visible
	end
end

return LoggerGui
