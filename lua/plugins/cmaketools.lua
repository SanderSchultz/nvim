-- Cmake commands
return {
	'Civitasv/cmake-tools.nvim',
	opts = {
		cmake_executor = {
			name = "toggleterm",
			opts = {
				direction = "float",
				close_on_exit = false,
			},
		},
		cmake_runner = {
			name = "toggleterm",
			opts = {
				direction = "float",
				close_on_exit = false,
			},
		},
	},
}
