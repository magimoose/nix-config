{ pkgs, ... }:
{
  home.packages = with pkgs; [ viewnior ];

	xdg.configFile."opencode/opencode.json".text = ''
		{
			"edit": "ask",
		}
	'';
}
