{ nixvim, ... }:
{
	programs.nixvim.plugins.telescope = {
		enable = true;
		settings.defaults = {
			wrap_results = true;
		};
		keymaps = {
			"<leader>ff" = {
					action = "find_files";
			};
			"<leader>fg" = {
				action = "live_grep";
			};
		};
	};
}
