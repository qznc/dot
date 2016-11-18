--------------------------------------------------------------------------------
-- Functions for C-style languages such as C,C++,C#,D, and Java
--------------------------------------------------------------------------------

local M = {}

local comments = require 'dmd.comments'
local continue_block_comment = comments.continue_block_comment
local continue_line_comment = comments.continue_line_comment

--------------------------------------------------------------------------------
-- Selects the scope that the cursor is currently inside of.
--------------------------------------------------------------------------------
function M.selectScope()
	local cursor = buffer.current_pos
	local depth = -1
	while depth ~= 0 do
		buffer:search_anchor()
		if buffer:search_prev(2097158, "[{}()]") < 0 then break end
		if buffer.current_pos == 0 then break end
		if buffer:get_sel_text():match("[)}]") then
			depth = depth - 1
		else
			depth = depth + 1
		end
	end
	local scopeBegin = buffer.current_pos
	local scopeEnd = buffer:brace_match(buffer.current_pos)
	buffer:set_sel(scopeBegin, scopeEnd + 1)
end

-- Returns true if other functions should try to handle the event
function M.indent_after_brace()
	local buffer = buffer
	local line_num = buffer:line_from_position(buffer.current_pos)
	local prev_line = buffer:get_line(line_num - 1)
	local curr_line = buffer:get_line(line_num)
	if prev_line:find("{%s*$") then
		local indent = buffer.line_indentation[line_num - 1]
		local new_indent = indent
		if buffer.indent == 0 then new_indent = new_indent + buffer.tab_width end
		if curr_line:find("}") then
			buffer:new_line()
			buffer.line_indentation[line_num] = new_indent
			buffer.line_indentation[line_num + 1] = indent
			buffer:line_up()
			buffer:line_end()
		else
			buffer.line_indentation[line_num] = new_indent
			buffer:line_end()
		end
		return false
	else
		return true
	end
end

-- Matches the closing } character with the indent level of its corresponding {
-- Does not properly handle the case of an opening brace inside a string.
function M.match_brace_indent()
	local buffer = buffer
	local style = buffer.style_at[buffer.current_pos]
	-- Don't do this if in a comment or string
	if style == 3 or style == 2 then return false end
	buffer:begin_undo_action()
	local line_num = buffer:line_from_position(buffer.current_pos)
	local brace_count = 1 -- +1 for closing, -1 for opening
	for i = line_num,0,-1 do
		local il = buffer:get_line(i)
		if il:find("{") then
			brace_count = brace_count - 1
		elseif il:find("}") then
			brace_count = brace_count + 1
		end
		if brace_count == 0 then
			buffer:line_up()
			buffer.line_indentation[line_num] = buffer.line_indentation[i]
			buffer:line_down()
			break
		end
	end
	buffer:end_undo_action()
	return false
end

-- Call this when the enter key is pressed
function M.enter_key_pressed()
	if buffer:auto_c_active() then return false end
	buffer:begin_undo_action()
	buffer:new_line()
	local cont = M.indent_after_brace()
	if cont then
		cont = continue_block_comment("/**", "*", "*/", "/%*", "%*", "%*/")
	end
	if cont then
		cont = continue_block_comment("/+", "+", "+/", "/%+", "%+", "%+/")
	end
	if cont then
		cont = continue_line_comment("//", "//")
	end
	buffer:end_undo_action()
end

function M.endline_semicolon()
	buffer:begin_undo_action()
	buffer:line_end()
	buffer:add_text(';')
	buffer:end_undo_action()
end

function M.newline_semicolon()
	buffer:begin_undo_action()
	buffer:line_end()
	buffer:add_text(';')
	buffer:new_line()
	buffer:end_undo_action()
end

function M.newline()
	buffer:begin_undo_action()
	buffer:line_end()
	buffer:new_line()
	buffer:end_undo_action()
end

-- allmanStyle: true to newline before opening brace, false for K&R style
function M.openBraceMagic(allmanStyle)
	buffer:begin_undo_action()
	buffer:line_end()
	if allmanStyle then
		buffer:new_line()
	else
		if buffer.char_at[buffer.current_pos - 1] ~= string.byte(" ") then
			buffer:add_text(" ")
		end
	end
	buffer:add_text("{}")
	buffer:char_left()
	M.enter_key_pressed()
	buffer:end_undo_action()
end

return M
