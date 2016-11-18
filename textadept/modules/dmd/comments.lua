local M = {}

--------------------------------------------------------------------------------
-- Continues /* */ style comments
-- @return true if other functions should try to handle the event
-- @param block_start_chars The characters that define the start of a stream
--     comment
-- @param block_middle_chars The characters that define the middle of a stream
--     comment. This can be an empty string
-- @param block_end_chars The characters that define the end of a stream
--     comment
-- @param block_start_pattern The lua pattern that defines the start of a
--     stream comment. This is necessary because block_start_chars might
--     contain characters that need to be escaped
-- @param block_middle_pattern The lua pattern for the middle of a comment.
--     This can be an empty string
-- @param block_end_pattern The lua pattern for the end of a comment.
--------------------------------------------------------------------------------
function M.continue_block_comment(block_start_chars, block_middle_chars,
	block_end_chars, block_start_pattern, block_middle_pattern,
	block_end_pattern)
	-- Check with the lexer to see if we're actually in a comment. Otherwise
	-- this code will think that a multi-line multiplication is a C comment
	-- because of lines beginning with "*"
	if buffer.style_name[buffer.style_at[buffer.current_pos]] ~= "comment" then
		return true
	end

	local line_num = buffer:line_from_position(buffer.current_pos)
	local prev_line = buffer:get_line(line_num - 1)
	local curr_line = buffer:get_line(line_num + 1)
    local prev_is_end = prev_line:find(block_end_pattern.."%s*$") ~= nil
    local prev_is_middle = prev_line:find("^%s*"..block_middle_pattern) ~= nil
    local curr_is_middle = curr_line:find("^%s*"..block_middle_pattern) ~= nil
    local prev_is_start = prev_line:find("^%s*"..block_start_pattern) ~= nil
	if prev_is_end then
		buffer:null()
	elseif prev_is_middle or (curr_is_middle and prev_is_start) then
		local indent = buffer.line_indentation[line_num - 1]
		buffer:add_text(block_middle_chars)
		local aftermiddle = prev_line:match(
			"^%s*"..block_middle_pattern.."([ \t]+)")
		if aftermiddle ~= nil then
			buffer:add_text(aftermiddle)
		elseif prev_is_start then
			buffer:add_text(" ")
		end
        if prev_is_start then
            buffer.line_indentation[line_num] = indent + 1
        else
            buffer.line_indentation[line_num] = indent
        end
		return false
	elseif prev_is_start then
		local indent = buffer.line_indentation[line_num - 1]
		buffer:add_text(' '..block_middle_chars..' ')
		buffer:line_end()
		buffer:new_line()
		buffer:add_text(block_end_chars)
		buffer:line_up()
		buffer:line_end()
		return false
	else
		return true
	end
end


--------------------------------------------------------------------------------
-- Continues single-line comments
-- @return true if other functions should try to handle the event
-- @param line_pattern The lua pattern for the start of the comment
-- @param line_chars The characters for the start of the comment
--------------------------------------------------------------------------------
function M.continue_line_comment(line_chars, line_pattern)
	local line_num = buffer:line_from_position(buffer.current_pos)
	local prev_line = buffer:get_line(line_num - 1)
	if prev_line:find(line_pattern.."%s*$") then
		buffer:line_up()
		buffer:line_end()
		buffer:del_line_left()
		buffer:delete_back()
		buffer:line_down()
		return false
	elseif prev_line:find("^%s*"..line_pattern) then
		local indent = buffer.line_indentation[line_num - 1]
		buffer:add_text(line_chars)
		local aftercomment = prev_line:match(
			"^%s*"..line_pattern.."([ \t]+)")
		if aftercomment ~= nil then
			buffer:add_text(aftercomment)
		end
		p = buffer.current_pos
		buffer.line_indentation[line_num] = indent
		buffer:goto_pos(p)
		return false
	else
		return true
	end
end

return M
