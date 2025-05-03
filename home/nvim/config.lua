local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

vim.opt.number = true
vim.opt.relativenumber = true

-- RFC-style text document settings
vim.api.nvim_create_augroup("RFCTextSettings", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = "RFCTextSettings",
	pattern = "*.txt",
	callback = function()
		-- Set line wrapping at 72 characters
		vim.opt_local.textwidth = 72
		vim.opt_local.formatoptions:append("t") -- Auto-wrap text

		-- Setting for pagination (66 lines per page)
		vim.opt_local.colorcolumn = "72" -- Visual indicator for line length

		-- Create a command to insert page breaks
		vim.api.nvim_buf_create_user_command(0, "RFCPageBreak", function()
			local line_count = vim.fn.line("$")
			local pages = math.ceil(line_count / 66)
			local current_line = 1

			for page = 1, pages do
				if current_line + 66 <= line_count then
					vim.fn.append(current_line + 66 - 1, string.rep("-", 72))
					current_line = current_line + 66
				end
			end
		end, { desc = "Insert RFC-style page breaks every 66 lines" })

		-- Create command to center all-caps lines
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = "RFCTextSettings",
			buffer = 0,
			callback = function()
				-- Save cursor position
				local cursor_pos = vim.fn.getcurpos()

				-- Find and center all-caps lines that are >72 characters
				vim.cmd([[
          silent! %s/^\([A-Z][A-Z0-9 :.,-_]\{72,\}\)$/\=printf('%*s', (72 + len(submatch(1))) / 2, submatch(1))/ge
        ]])

				-- Restore cursor position
				vim.fn.setpos(".", cursor_pos)
			end,
		})

		-- Key mapping for inserting page breaks
		vim.keymap.set("n", "<leader>rp", ":RFCPageBreak<CR>", { buffer = true, desc = "Insert RFC page breaks" })

		vim.keymap.set("n", "<leader>rc", ":center 72<CR>", { buffer = true, desc = "Center line with width 72" })

		-- Key mapping for adding dots to column 72
		vim.keymap.set("n", "<leader>rd", function()
			-- Get current line number
			local line_num = vim.fn.line(".")
			-- Get current line content
			local line_content = vim.fn.getline(".")
			-- Calculate how many dots needed
			local current_length = vim.fn.strdisplaywidth(line_content)
			if current_length >= 72 then
				-- Line already at or beyond 72 chars, do nothing
				return
			end
			-- Create string of dots to fill to column 72
			local dots = string.rep(".", 72 - current_length)
			-- Append dots to the current line
			vim.fn.setline(line_num, line_content .. dots)
		end, { buffer = true, desc = "Fill line with dots to column 72" })

		-- Status message
		vim.api.nvim_echo({ { "RFC-style text document settings applied", "Normal" } }, false, {})
	end,
})

require("lazy").setup({
	spec = {
		-- add LazyVim and import its plugins
		{
			"LazyVim/LazyVim",
			import = "lazyvim.plugins",
			opts = {
				colorscheme = "catppuccin-macchiato",
			},
			keys = function()
				local map = vim.keymap.set

				-- Paste without overwriting yank register
				map("x", "p", '"_dP', { desc = "Paste without yanking" })

				-- Delete without yanking
				map({ "n", "x" }, "d", '"_d', { desc = "Delete without yanking" })
				map({ "n", "x" }, "D", '"_D', { desc = "Delete line without yanking" })
			end,
		},
		-- Extras
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		-- { import = "lazyvim.plugins.extras.linting.eslint" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.ui.mini-animate" },
		{ import = "lazyvim.plugins.extras.lang.vue" },
		-- { import = "lazyvim.plugins.extras.lang.go" },
		-- { import = "lazyvim.plugins.extras.coding.copilot" },
		-- import/override with your plugins
		-- { "catppuccin/nvim" },
		--
		{
			"nvim-telescope/telescope.nvim",
			keys = {
				{ "<leader>sS", false },
				{
					"<leader>ss",
					"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
					desc = "Search/Go to symbols in workspace",
				},
			},
		},

		{
			"neovim/nvim-lspconfig",
			-- other settings removed for brevity
			opts = {
				---@type lspconfig.options
				servers = {
					eslint = {
						settings = {
							-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
							workingDirectories = { mode = "auto" },
						},
					},
					pylsp = {
						settings = {
							pylsp = {
								plugins = {
									-- Disable autopep8
									autopep8 = { enabled = false },
									-- Disable other formatters
									yapf = { enabled = false },
									black = { enabled = false },
									-- Enable Ruff linter
									ruff = { enabled = true },
								},
							},
						},
					},
				},
				setup = {
					eslint = function()
						local function get_client(buf)
							return LazyVim.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
						end

						local formatter = LazyVim.lsp.formatter({
							name = "eslint: lsp",
							primary = true,
							priority = 10000,
							filter = "eslint",
						})

						-- Use EslintFixAll on Neovim < 0.10.0
						if not pcall(require, "vim.lsp._dynamic") then
							formatter.name = "eslint: EslintFixAll"
							formatter.sources = function(buf)
								local client = get_client(buf)
								return client and { "eslint" } or {}
							end
							formatter.format = function(buf)
								local client = get_client(buf)
								if client then
									local diag = vim.diagnostic.get(
										buf,
										{ namespace = vim.lsp.diagnostic.get_namespace(client.id) }
									)
									if #diag > 0 then
										vim.cmd("EslintFixAll")
									end
								end
							end
						end

						-- register the formatter with LazyVim
						LazyVim.format.register(formatter)
					end,
				},
			},
		},

		{
			"williamboman/mason-lspconfig.nvim",
			opts = {
				ensure_installed = {
					"eslint@4.8.0",
				},
			},
		},

		{
			"nvim-neo-tree/neo-tree.nvim",
			opts = {
				window = {
					position = "right",
				},
			},
			keys = {
				{ "<leader>E", "<cmd>Neotree current<cr>", desc = "Explorer (current dir)" },
			},
		},

		{ "ThePrimeagen/vim-be-good" },

		-- { "rcarriga/nvim-notify", enabled = false },
		{
			"nvim-tree/nvim-web-devicons",
			opts = {
				color_icons = false,
			},
		},

		{
			"nvim-lualine/lualine.nvim",
			opts = function()
				local lualine_require = require("lualine_require")
				lualine_require.require = require

				vim.o.laststatus = vim.g.lualine_laststatus

				local colors = {
					blue = "#80a0ff",
					cyan = "#79dac8",
					black = "#080808",
					white = "#c6c6c6",
					red = "#ff5189",
					violet = "#d183e8",
					grey = "#303030",
				}

				local bubbles_theme = {
					normal = {
						a = { fg = colors.black, bg = colors.violet },
						b = { fg = colors.white, bg = colors.grey },
						c = { fg = colors.white },
					},

					insert = { a = { fg = colors.black, bg = colors.blue } },
					visual = { a = { fg = colors.black, bg = colors.cyan } },
					replace = { a = { fg = colors.black, bg = colors.red } },

					inactive = {
						a = { fg = colors.white, bg = colors.black },
						b = { fg = colors.white, bg = colors.black },
						c = { fg = colors.white },
					},
				}

				return {
					options = {
						theme = bubbles_theme,
						component_separators = "",
						section_separators = { left = "", right = "" },
					},
					sections = {
						lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
						lualine_b = { "filename", "branch" },
						lualine_c = {
							"%=", --[[ add your center compoentnts here in place of this comment ]]
						},
						lualine_x = {},
						lualine_y = { "filetype", "progress" },
						lualine_z = {
							{ "location", separator = { right = "" }, left_padding = 2 },
						},
					},
					inactive_sections = {
						lualine_a = { "filename" },
						lualine_b = {},
						lualine_c = {},
						lualine_x = {},
						lualine_y = {},
						lualine_z = { "location" },
					},
					tabline = {},
					extensions = {},
				}
			end,
		},

		{ "echasnovski/mini.hipatterns" },
		{ "akinsho/git-conflict.nvim", version = "*", config = true },

		-- themes
		{ "catppuccin/nvim" },
		{ "rebelot/kanagawa.nvim" },
		{ "ellisonleao/gruvbox.nvim" },
		{ "nyoom-engineering/nyoom.nvim" },
		{ "AlexvZyl/nordic.nvim" },
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false, -- always use the latest git commit
		-- version = "*", -- try installing the latest stable version for plugins that support semver
	},
	install = {
		colorscheme = {
			"tokyonight",
			"habamax",
		},
	},
	checker = { enabled = true, notify = false }, -- automatically check for plugin updates
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
