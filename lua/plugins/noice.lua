-- Better cmd visuals when doing :
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		messages = {
			enabled = false,
		},
		views = {
			cmdline_popup = {
				border = {
					style = "rounded"
				}
			}
		},
		lsp = {
			progress = {
				enabled = false, -- Disables LSP progress messages
			},
			hover = {
				enabled = false, -- Disables LSP hover messages
			},
			signature = {
				enabled = false, -- Disables signature help messages
			},
		},
		popupmenu = {
			enabled = false, -- Disables Noice popup menu
		},
		notify = {
			enabled = false, -- Disables Noice notifications
		},
		cmdline = {
			view = "cmdline_popup",
			format = {
				cmdline = { pattern = "^:", icon = "", lang = "vim" },
				filter = false,
				shell = { pattern = "^:!", icon = "$", lang = "bash" },
				ssh = {
					pattern = "^:Oil%s+oil%-ssh://",
					icon    = "󰌘 SSH",
					lang    = "bash",
					filter  = true, -- hides that prefix in the popup
				},
			},
		}
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	}
}
