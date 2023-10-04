local buffer = require("ide.buffers.buffer")

local Popup = {}

function calculate_dimensions(lines)
	local h = #lines
	if h > 100 then
		h = 100
	end
	local w = 0
	for _, l in ipairs(lines) do
		if #l > w then
			w = #l
		end
	end
	if w > 100 then
		w = 100
	end
	return h, w
end

function Popup.until_cursor_move(lines)
	local buf = buffer.new(nil, false, true)
	buf.write_lines(lines)

	local h, w = calculate_dimensions(lines)

	local win = vim.api.nvim_open_win(buf.buf, false, {
		relative = "cursor",
		col = 0,
		row = 0,
		width = w,
		height = h,
		zindex = 99,
		style = "minimal",
		border = "rounded",
		noautocmd = true,
	})
	local aucmd = nil
	aucmd = vim.api.nvim_create_autocmd({ "CursorMoved" }, {
		callback = function()
			local cur_win = vim.api.nvim_get_current_win()
			vim.api.nvim_win_close(win, true)
			vim.api.nvim_del_autocmd(aucmd)
		end,
	})
end

return Popup
