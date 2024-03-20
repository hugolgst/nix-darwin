-- https://github.com/LazyVim/starter

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

vim.opt.number = true
vim.opt.relativenumber = false

require("lazy").setup({
	spec = {
		-- add LazyVim and import its plugins
		{
			"LazyVim/LazyVim",
			import = "lazyvim.plugins",
			opts = {
				colorscheme = "catppuccin-macchiato",
			},
		},
		-- Extras
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.linting.eslint" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		-- { import = "lazyvim.plugins.extras.lang.go" },
		{ import = "lazyvim.plugins.extras.ui.mini-animate" },
		{ import = "lazyvim.plugins.extras.coding.copilot" },
		-- import/override with your plugins
		-- { "catppuccin/nvim" },
		{
			"nvim-neo-tree/neo-tree.nvim",
			opts = {
				window = {
					position = "right",
				},
			},
		},

		{ "rcarriga/nvim-notify", enabled = false },
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
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      build = ":Copilot auth",
      opts = {
        suggestion = { 
          enabled = true,
          auto_trigger = true,
        },
        panel = { enabled = true },
        filetypes = {
          markdown = true,
          help = true,
        },
      },
    },



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
	checker = { enabled = true }, -- automatically check for plugin updates
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
