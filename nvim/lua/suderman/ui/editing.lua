local ok_ai, mini_ai = pcall(require, "mini.ai")
if ok_ai then
  mini_ai.setup({
    custom_textobjects = nil,
    matter = nil,
    moves = nil,
  })
end

local ok_align, mini_align = pcall(require, "mini.align")
if ok_align then
  mini_align.setup()
end

local ok_bracketed, mini_bracketed = pcall(require, "mini.bracketed")
if ok_bracketed then
  mini_bracketed.setup()
end

local ok_surround, mini_surround = pcall(require, "mini.surround")
if ok_surround then
  mini_surround.setup()
end

local ok_diff, mini_diff = pcall(require, "mini.diff")
if ok_diff then
  mini_diff.setup({
    source = mini_diff.gen_source.none(),
  })
end
