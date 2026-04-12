{ nixvim, ... }:
{
	programs.nixvim.plugins.treesitter = {
		enable = true;
		autoLoad = true;
		settings = {
			highlight.enable = true;
			indent.enable = true;
			ensure_installed = [
				"nix"
				"typescript"
				"tsx"
				"javascript"
				"python"
				"lua"
				"c"
				"cpp"
				"zig"
				"go"
				"toml"
				"json"
				"yaml"
				"html"
				"css"
				"bash"
				"markdown"
				"vim"
				"vimdoc"
				"regex"
			];
		};
	};
}

