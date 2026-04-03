{ ... }:
{
	imports = [ ./cmp.nix ];
	programs.nixvim.plugins.lsp = {
		enable = true;
		servers = {
			ts_ls.enable = true;
			lua_ls.enable = true;
			nixd.enable = true;
			pyright.enable = true;
		};
		keymaps.lspBuf = {
			"K" = "hover";
			"<leader>rn" = "rename";
		};
	};
	programs.nixvim.keymaps = [
		{ mode = "n"; key = "gd"; action = "<cmd>Telescope lsp_definitions<cr>"; options.desc = "Go to definition"; }
		{ mode = "n"; key = "gD"; action = "<cmd>Telescope lsp_type_definitions<cr>"; options.desc = "Go to type definition"; }
		{ mode = "n"; key = "gr"; action = "<cmd>Telescope lsp_references<cr>"; options.desc = "Show references"; }
		{ mode = "n"; key = "gi"; action = "<cmd>Telescope lsp_implementations<cr>"; options.desc = "Go to implementation"; }
	];
}
