{ ... }:
{
	programs.nixvim.plugins.gitsigns = {
		enable = true;
		settings = {
			current_line_blame = false;
			current_line_blame_opts = {
				delay = 300;
				virt_text_pos = "eol";
			};
		};
	};
}
