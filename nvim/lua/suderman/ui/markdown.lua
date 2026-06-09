local ok_rm, rm = pcall(require, "render-markdown")
if ok_rm then
  rm.setup({
    file_types = { "markdown", "opencode_output" },
  })
end
