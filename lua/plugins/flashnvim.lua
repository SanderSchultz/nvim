--Its what happens when you press "s" in normal mode
--Lets you search for patterns in visual buffer and move to it

return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {
		modes = {
			search = {
				enabled = false  -- Disable Flash integration with / search
			}
		}
	},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump({ search = { mode = "search" } })
			end,
			desc = "Flash Full Buffer Search"
		},
		{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
		{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
		{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
		{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
	}
}
