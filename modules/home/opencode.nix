{ pkgs, ... }:
{
  home.packages = with pkgs; [ opencode ];

	xdg.configFile."opencode/opencode.json".text = ''
		{
			"permission": {
				"edit": "ask",
			},
			"lsp": false
		}
	'';
}
