-- by lovrewe
-- Optimized for Hydroxide

assert(getscriptbytecode, "Exploit not supported.")

local API = "http://api.plusgiant5.com"
local RATE_LIMIT = 0.5

local last_call = 0

local API_ENDPOINTS = {
	decompile = API .. "/konstant/decompile",
	disassemble = API .. "/konstant/disassemble"
}

local HEADERS = {
	["Content-Type"] = "text/plain"
}

local function call(konstantType, scriptPath)
	local success, bytecode = pcall(getscriptbytecode, scriptPath)

	if not success then
		return "-- Failed to get script bytecode, error:\n\n--[[\n" .. bytecode .. "\n--]]"
	end

	local current_time = os.clock()
	local time_elapsed = current_time - last_call
	if time_elapsed < RATE_LIMIT then
		task.wait(RATE_LIMIT - time_elapsed)
		current_time = os.clock()
	end

	local httpResult = request({
		Url = konstantType,
		Body = bytecode,
		Method = "POST",
		Headers = HEADERS
	})

	last_call = current_time

	if httpResult.StatusCode ~= 200 then
		return "-- Error occurred while requesting Konstant API, error:\n\n--[[\n" .. httpResult.Body .. "\n--]]"
	else
		return httpResult.Body
	end
end

local function decompile(scriptPath)
	return call(API_ENDPOINTS.decompile, scriptPath)
end

local function disassemble(scriptPath)
	return call(API_ENDPOINTS.disassemble, scriptPath)
end

getgenv().decompile = decompile
getgenv().disassemble = disassemble
