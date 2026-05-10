-- plugin/ai.lua
-- AI integration migrated from nvf/codecompanion/*.nix and nvf/assistant.nix

if vim.g.did_load_ai_plugin then
  return
end
vim.g.did_load_ai_plugin = true

-- === CodeCompanion ===
local ok_cc, CodeCompanion = pcall(require, 'codecompanion')
if ok_cc then
  -- Setup with default strategies (adapters registered separately if needed)
  pcall(CodeCompanion.setup, {
    -- Default to openrouter adapter if env var present, otherwise skip
    strategies = {
      chat = {
        adapter = "openrouter",
        slash_commands = {
          buffer = { opts = { provider = 'snacks' } },
          file = { opts = { provider = 'snacks' } },
        },
      },
      inline = { adapter = "openrouter" },
      cmd = { adapter = "openrouter" },
    },
    adapters = {
      -- openrouter adapter (env-based)
      openrouter = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          env = {
            url = "https://openrouter.ai/api",
            api_key = os.getenv("OPENROUTER_API_KEY") or "not-set",
          },
          schema = {
            model = {
              choices = {
                "openai/gpt-4.1",
                "anthropic/claude-sonnet-4",
                "google/gemini-2.5-flash",
                "google/gemini-2.0-flash-exp:free",
                "qwen/qwen3-30b-a3b:free",
                "qwen/qwq-32b:free",
              },
              default = "openai/gpt-4.1",
            },
          },
        })
      end,
      -- ollama adapter (env-based)
      ollama = function()
        return require("codecompanion.adapters").extend("ollama", {
          env = {
            url = os.getenv("OLLAMA_HOST") or "http://localhost:11434",
          },
          schema = {
            model = {
              choices = {
                "qwen3:8b",
                "qwen3:30b-a3b",
                "qwen2.5-coder:7b",
                "mistral:7b-instruct",
              },
              default = "qwen3:30b-a3b",
            },
            temperature = { default = 0.6 },
            top_p = { default = 0.95 },
          },
        })
      end,
    },
    -- Display settings
    display = {
      chat = {
        show_header_separator = false,
        show_references = true,
        show_token_count = true,
      },
      action_palette = {
        width = 95,
        height = 10,
        provider = "default",
      },
    },
    -- Tools
    tools = {
      opts = {
        auto_submit_errors = true,
        auto_submit_success = true,
        default_tools = {
          "files",
          "cmd_runner",
        },
      },
    },
  })

  -- Register spinner extension if available
  pcall(function()
    require("codecompanion.extensions.spinner").setup()
  end)
end

-- === MCP hub ===
-- Only setup mcphub if mcp-hub executable is found
local mcp_cmd = vim.fn.exepath("mcp-hub")
if mcp_cmd ~= "" then
  local ok_mcp, mcphub = pcall(require, 'mcphub')
  if ok_mcp then
    pcall(mcphub.setup, {
      cmd = mcp_cmd,
      auto_approve = true,
      auto_toggle_mcp_servers = true,
    })
  end
else
  -- Disable mcphub autocmds if mcp-hub not available
  pcall(function()
    vim.api.nvim_del_augroup_by_name('mcphub')
  end)
  vim.g.loaded_mcphub = 1
end

-- === Keymaps ===
vim.keymap.set('n', ',,', '<cmd>CodeCompanionActions<cr>', { desc = 'CodeCompanion Actions' })
vim.keymap.set('n', ',.', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'CodeCompanion Chat' })
vim.keymap.set('n', ',c', '<cmd>CodeCompanionChat<cr>', { desc = 'Toggle CodeCompanion Chat' })
vim.keymap.set('v', ',y', '<cmd>CodeCompanionChat Add<cr>', { desc = 'Yank to chat' })
vim.keymap.set('v', ',i', '<cmd>CodeCompanion /buffer ', { desc = 'CodeCompanion Inline' })

-- === OpenCode ACP (placeholder - requires opencode CLI) ===
-- Uncomment when opencode is configured:
-- vim.keymap.set('n', '<leader>o', '<cmd>OpenCode<cr>', { desc = 'OpenCode AI' })
