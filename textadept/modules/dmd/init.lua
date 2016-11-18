local M = {}

local cstyle = require "dmd.cstyle"
local icons = require "dmd.icons"
local dsnippets = require "dmd.snippets"
local snippets = _G.snippets
local keys = _G.keys

-- Used for dscanner/ctags symbol finder
local lineDict = {}

-- Used for DCD call tips
local calltips = {}
local currentCalltip = 1

M.PATH_TO_DCD_SERVER = "dcd-server"
M.PATH_TO_DCD_CLIENT = "dcd-client"
M.PATH_TO_DSCANNER = "dscanner"
M.PATH_TO_DFMT = "dfmt"

textadept.editing.comment_string.dmd = '//'
textadept.run.compile_commands.dmd = 'dmd -c -o- %(filename)'
textadept.run.error_patterns.dmd = {
	pattern = '^(.-)%((%d+)%): (.+)$',
	filename = 1, line = 2, message = 3
}

M.kindToIconMapping = {}
M.kindToIconMapping['c'] = _SCINTILLA.next_image_type()
M.kindToIconMapping['e'] = _SCINTILLA.next_image_type()
M.kindToIconMapping['f'] = _SCINTILLA.next_image_type()
M.kindToIconMapping['i'] = _SCINTILLA.next_image_type()
M.kindToIconMapping['k'] = _SCINTILLA.next_image_type()
M.kindToIconMapping['l'] = _SCINTILLA.next_image_type()
M.kindToIconMapping['M'] = _SCINTILLA.next_image_type()
M.kindToIconMapping['P'] = _SCINTILLA.next_image_type()
M.kindToIconMapping['s'] = _SCINTILLA.next_image_type()
M.kindToIconMapping['t'] = _SCINTILLA.next_image_type()
M.kindToIconMapping['u'] = _SCINTILLA.next_image_type()
M.kindToIconMapping['v'] = _SCINTILLA.next_image_type()
M.kindToIconMapping['m'] = M.kindToIconMapping['v']
M.kindToIconMapping['g'] = M.kindToIconMapping['e']
M.kindToIconMapping['T'] = M.kindToIconMapping['t']

local function registerImages()
	buffer:register_image(M.kindToIconMapping['c'], icons.CLASS)
	buffer:register_image(M.kindToIconMapping['e'], icons.ENUM)
	buffer:register_image(M.kindToIconMapping['f'], icons.FUNCTION)
	buffer:register_image(M.kindToIconMapping['i'], icons.INTERFACE)
	buffer:register_image(M.kindToIconMapping['k'], icons.KEYWORD)
	buffer:register_image(M.kindToIconMapping['l'], icons.ALIAS)
	buffer:register_image(M.kindToIconMapping['M'], icons.MODULE)
	buffer:register_image(M.kindToIconMapping['P'], icons.PACKAGE)
	buffer:register_image(M.kindToIconMapping['s'], icons.STRUCT)
	buffer:register_image(M.kindToIconMapping['t'], icons.TEMPLATE)
	buffer:register_image(M.kindToIconMapping['u'], icons.UNION)
	buffer:register_image(M.kindToIconMapping['v'], icons.FIELD)
end

local function showCompletionList(r)
	buffer.auto_c_choose_single = false;
	buffer.auto_c_max_width = 0
	local completions = {}
	for symbol, kind in r:gmatch("([^%s]+)\t(%a)\r?\n") do
		completions[#completions + 1] = symbol .. "?" .. M.kindToIconMapping[kind]
	end
	table.sort(completions, function(a, b) return string.upper(a) < string.upper(b) end)
	local charactersEntered = buffer.current_pos - buffer:word_start_position(buffer.current_pos)
	local prevChar = buffer.char_at[buffer.current_pos - 1]
	if prevChar == string.byte('.')
			or prevChar == string.byte(':')
			or prevChar == string.byte(' ')
			or prevChar == string.byte('\t')
			or prevChar == string.byte('(')
			or prevChar == string.byte('[') then
		charactersEntered = 0
	end
	if not buffer:auto_c_active() then registerImages() end
	local setting = buffer.auto_c_choose_single
	buffer:auto_c_show(charactersEntered, table.concat(completions, " "))
	buffer.auto_c_choose_single = setting
end

local function showCurrentCallTip()
	local tip = calltips[currentCalltip]
	buffer:call_tip_show(buffer:word_start_position(buffer.current_pos),
		string.format("%d of %d\1\2\n%s", currentCalltip, #calltips,
			calltips[currentCalltip]:gsub("(%f[\\])\\n", "%1\n")
			:gsub("\\\\n", "\\n")))
end

local function showCalltips(calltip)
	currentCalltip = 1
	calltips = {}
	for tip in calltip:gmatch("(.-)\r?\n") do
		if tip ~= "calltips" then
			table.insert(calltips, tip)
		end
	end
	if (#calltips > 0) then
		showCurrentCallTip()
	end
end

local function cycleCalltips(delta)
	if not buffer:call_tip_active() then
		return false
	end
	if delta > 0 then
		currentCalltip = math.max(math.min(#calltips, currentCalltip + 1), 1)
	else
		currentCalltip = math.min(math.max(1, currentCalltip - 1), #calltips)
	end
	showCurrentCallTip()
end

local function runDCDClient(args)
	local command = M.PATH_TO_DCD_CLIENT .. " " .. args .. " -c" .. buffer.current_pos
	local p = spawn(command)
	p:write(buffer:get_text():sub(1, buffer.length))
	p:close()
	return p:read("*a") or ""
end

local function showDoc()
	local r = runDCDClient("-d")
	if r ~= "\n" then
		showCalltips(r)
	end
end


M.gotoStack = {}

function M.goBack()
	if #M.gotoStack == 0 then return end
	local top = M.gotoStack[#M.gotoStack]
	if top.file ~= nil then
		ui.goto_file(top.file, false, _VIEWS[top.view])
	else
		if top.buffer > _BUFFERS then
			table.remove(M.gotoStack)
			return
		end
		view:goto_buffer(top.buffer)
	end
	buffer:goto_line(top.line)
	buffer:vertical_centre_caret()
	table.remove(M.gotoStack) -- pop last item
end

function M.gotoDeclaration()
	local r = runDCDClient("-l")
	if r ~= "Not found\n" then
		path, position = r:match("^(.-)\t(%d+)")
		if (path ~= nil and position ~= nil) then
			table.insert(M.gotoStack, {
				line = buffer:line_from_position(buffer.current_pos),
				file = buffer.filename,
				buffer = _BUFFERS[_G.buffer],
				view = _VIEWS[_G.view]
			})
			if (path ~= "stdin") then
				ui.goto_file(path, false, _G.view)
			end
			buffer:goto_pos(tonumber(position))
			buffer:vertical_centre_caret()
			buffer:word_right_end_extend()
		end
	end
end

local function expandContext(meta)
	local patterns = {"struct:(%w+)", "class:([%w_]+)", "template:([%w_]+)",
		"interface:([%w_]+)", "union:([%w_]+)", "function:([%w_]+)"}
	if meta == nil or meta == "" then return "" end
	for item in meta:gmatch("%w+:[%w%d_]+") do
		for _, pattern in ipairs(patterns) do
			local result = item:match(pattern)
			if result ~= nil then return result end
		end
	end
	return ""
end

-- Expands ctags type abbreviations to full words
local function expandCtagsType(tagType)
	if tagType == "g" then return "enum"
	elseif tagType == "e" then return ""
	elseif tagType == "v" then return "variable"
	elseif tagType == "i" then return "interface"
	elseif tagType == "c" then return "class"
	elseif tagType == "s" then return "struct"
	elseif tagType == "f" then return "function"
	elseif tagType == "u" then return "union"
	elseif tagType == "T" then return "template"
	else return "" end
end

local function onSymbolListSelection(list, item)
	list:close()
	buffer:goto_line(item[4] - 1)
	buffer:vertical_centre_caret()
end

-- Uses dscanner's --ctags option to create a symbol index for the contents of
-- the buffer. Automatically uses Textadept's normal dialogs or textredux lists.
local function symbolIndex()
	local fileName = os.tmpname()
	local mode = "w"
	if _G.WIN32 then mode = "wb" end
	local tmpFile = io.open(fileName, mode)
	tmpFile:write(buffer:get_text():sub(1, buffer.length))
	tmpFile:flush()
	tmpFile:close()
	local command = M.PATH_TO_DSCANNER .. " --ctags " .. fileName
	local p = spawn(command)
	local r = p:read("*a")
	os.remove(fileName)
	local symbolList = {}
	local i = 0

	for line in r:gmatch("(.-)\r?\n") do
		if not line:match("^!") then
			local name, file, lineNumber, tagType, meta = line:match(
				"([~%w_]+)\t([%w/\\._ ]+)\t(%d+);\"\t(%w)\t?(.*)")
			if package.loaded['textredux'] then
				table.insert(symbolList, {name, expandCtagsType(tagType), expandContext(meta), lineNumber})
			else
				table.insert(symbolList, name)
				table.insert(symbolList, expandCtagsType(tagType))
				table.insert(symbolList, expandContext(meta))
				table.insert(symbolList, lineNumber)
			end
			lineDict[i + 1] = tonumber(lineNumber - 1)
			i = i + 1
		end
	end

	local headers = {"Name", "Kind", "Context", "Line"}

	if package.loaded['textredux'] then
		local reduxlist = require 'textredux.core.list'
		local reduxstyle = require 'textredux.core.style'
		local list = reduxlist.new('Go to symbol')
		list.items = symbolList
		list.on_selection = onSymbolListSelection
		list.headers = headers
		list.column_styles = { reduxstyle.variable, reduxstyle.keyword, reduxstyle.class, reduxstyle.number }
		list:show()
	else
		local button, i = ui.dialogs.filteredlist{
			title = "Go to symbol",
			columns = headers,
			items = symbolList
		}
		if i ~= nil then
			buffer:goto_line(lineDict[i])
			buffer:vertical_centre_caret()
		end
	end
end

local function autocomplete()
	if not buffer:auto_c_active() then registerImages() end
	local r = runDCDClient("")
	if r ~= "\n" and r ~= "\r\n" then
		if r:match("^identifiers.*") then
			showCompletionList(r)
		else
			showCalltips(r)
		end
	end
	if not buffer:auto_c_active() then
		textadept.editing.autocomplete("word")
	end
end

-- Autocomplete handler. Launches DCD on '(', '.', or ':' character insertion
events.connect(events.CHAR_ADDED, function(ch)
	if buffer:get_lexer() ~= "dmd" or ch > 255 then return end
	if string.char(ch) == '(' or string.char(ch) == '.' or string.char(ch) == ':' then
		local setting = buffer.auto_c_choose_single
		buffer.auto_c_choose_single = false
		autocomplete(ch)
		buffer.auto_c_choose_single = setting
	end
end)

-- Run dscanner's static analysis after saves and print the warnings and errors
-- reported to the buffer as annotations
events.connect(events.FILE_AFTER_SAVE, function()
	if buffer:get_lexer() ~= "dmd" then return end
	buffer:annotation_clear_all()
	local command = M.PATH_TO_DSCANNER .. " --styleCheck " .. buffer.filename
	local p = spawn(command)
	local result = p:read("*a") or ""
	for line in result:gmatch("(.-)\r?\n") do
		lineNumber, column, level, message = string.match(line, "^.-%((%d+):(%d+)%)%[(%w+)%]: (.+)$")
		if lineNumber == nil then return end
		local l = tonumber(lineNumber) - 1
		if l >= 0 then
			local c = tonumber(column)
			if level == "error" then
				buffer.annotation_style[l] = 8
			elseif buffer.annotation_style[l] ~= 8 then
				buffer.annotation_style[l] = 2
			end

			local t = buffer.annotation_text[l]
			if #t > 0 then
				buffer.annotation_text[l] = buffer.annotation_text[l] .. "\n" .. message
			else
				buffer.annotation_text[l] = message
			end
		end
	end
end)

-- Handler for clicks on the up and down arrow on function call tips
events.connect(events.CALL_TIP_CLICK, function(arrow)
	if buffer:get_lexer() ~= "dmd" then return end
	if arrow == 1 then
		cycleCalltips(-1)
	elseif arrow == 2 then
		cycleCalltips(1)
	end
end)

if not _G.WIN32 then
	-- Spawn the dcd-server
	M.serverProcess = spawn(M.PATH_TO_DCD_SERVER, nil, function() end, function() end)

	-- Set an event handler that shuts down the DCD server, but only if this
	-- module successfully started it. Do nothing if somebody else owns the
	-- server instance
	events.connect(events.QUIT, function()
		if (M.serverProcess:status() == "running") then
			spawn(M.PATH_TO_DCD_CLIENT .. " --shutdown")
			_G.timeout(1, function()
				if (M.serverProcess:status() == "running") then
					M.serverProcess:kill()
				end
			end)
		else
			print('Warning: something other than us killed the DCD server')
		end
	end)
end

-- Key bindings
keys.dmd = {
	['a\n'] = cstyle.newline,
	['s\n'] = cstyle.newline_semicolon,
	['c;'] = cstyle.endline_semicolon,
	['}'] = cstyle.match_brace_indent,
	['c{'] = function() return cstyle.openBraceMagic(true) end,
	['\n'] = cstyle.enter_key_pressed,
	['c\n'] = autocomplete,
	['cH'] = showDoc,
	['down'] = function() return cycleCalltips(1) end,
	['up'] = function() return cycleCalltips(-1) end,
	['cG'] = M.gotoDeclaration,
	['caG'] = M.goBack,
	['cM'] = symbolIndex,
	['f7'] = function()
		if buffer.use_tabs then
			textadept.editing.filter_through(M.PATH_TO_DFMT .. " --indent_style=tab")
		else
			textadept.editing.filter_through(M.PATH_TO_DFMT .. " --indent_style=space")
		end
	end
}

-- Snippets
if type(snippets) == 'table' then
	snippets.dmd = dsnippets.snippets
end

function M.set_buffer_properties()
end

return M
