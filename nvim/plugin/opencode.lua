-- plugin/opencode.lua
-- OpenCode integration

if vim.g.did_load_opencode_plugin then
	return
end
vim.g.did_load_opencode_plugin = true

local ok_opencode, opencode = pcall(require, "opencode")
if not ok_opencode then
	return
end

vim.o.autoread = true

local opencode_executable = vim.fn.expand("~/.local/bin/opencode")
if vim.fn.executable(opencode_executable) ~= 1 then
	opencode_executable = "opencode"
end

opencode.setup({
	opencode_executable = opencode_executable,
	preferred_picker = "snacks",
	preferred_completion = "blink",
	default_mode = "mini",
	default_global_keymaps = false,
	keymap = {
		input_window = {
			["<tab>"] = { "switch_mode", mode = { "n", "i" }, desc = "Switch agent mode", defer_to_completion = true },
			["<M-m>"] = false,
		},
		output_window = {
			["<tab>"] = { "switch_mode", mode = { "n" }, desc = "Switch agent mode" },
		},
	},
})

local api = require("opencode.api")

local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

map({ "n", "t" }, ",,", api.toggle, "Toggle opencode")
map({ "n", "t" }, ",g", api.toggle, "Toggle opencode")
map("n", ",i", api.open_input, "Open opencode input")
map("n", ",I", api.open_input_new_session, "Open opencode input in new session")
map("n", ",o", api.open_output, "Open opencode output")
map("n", ",t", api.toggle_focus, "Toggle opencode focus")
map("n", ",T", api.timeline, "Open opencode session timeline")
map("n", ",q", api.close, "Close opencode")
map("n", ",s", api.select_session, "Select opencode session")
map("n", ",S", function()
	api.navigate_session_tree("child", "picker")
end, "Select opencode child session")
map("n", ",P", function()
	api.navigate_session_tree("parent")
end, "Go to opencode parent session")
map("n", ",B", function()
	api.navigate_session_tree("sibling", "picker")
end, "Select opencode sibling session")
map("n", ",R", api.rename_session, "Rename opencode session")
map("n", ",h", api.select_history, "Select opencode prompt history")

map("n", ",p", api.configure_provider, "Configure opencode provider/model")
map("n", ",V", api.configure_variant, "Configure opencode model variant")
map("n", ",m", api.switch_mode, "Cycle opencode agent mode")

map({ "n", "x" }, ",/", api.quick_chat, "Open opencode quick chat")
map("x", ",y", api.add_visual_selection, "Add selection to opencode context")
map("x", ",Y", api.add_visual_selection_inline, "Insert selection into opencode input")
map("n", ",v", api.paste_image, "Paste image into opencode")

map("n", ",z", api.toggle_zoom, "Toggle opencode zoom")
map("n", ",x", api.swap_position, "Swap opencode window position")
map("n", ",tr", api.toggle_reasoning_output, "Toggle opencode reasoning output")
map("n", ",tt", api.toggle_tool_output, "Toggle opencode tool output")
map("n", ",tm", api.toggle_max_messages, "Toggle opencode max messages")

map("n", ",D", api.debug_message, "Open raw opencode message debug view")
map("n", ",O", api.debug_output, "Open raw opencode output debug view")
map("n", ",ds", api.debug_session, "Open raw opencode session debug view")

map("n", ",d", api.diff_open, "Open opencode diff")
map("n", ",]", api.diff_next, "Next opencode diff")
map("n", ",[", api.diff_prev, "Previous opencode diff")
map("n", ",c", api.diff_close, "Close opencode diff")
map("n", ",ra", api.diff_revert_all_last_prompt, "Revert all opencode changes from last prompt")
map("n", ",rt", api.diff_revert_this_last_prompt, "Revert this opencode change from last prompt")
map("n", ",rA", api.diff_revert_all, "Revert all opencode changes")
map("n", ",rT", api.diff_revert_this, "Revert this opencode change")
map("n", ",rr", api.diff_restore_snapshot_file, "Restore opencode file snapshot")
map("n", ",rR", api.diff_restore_snapshot_all, "Restore all opencode snapshots")
