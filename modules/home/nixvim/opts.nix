{ nixvim, ...}:
{
programs.nixvim.opts = {
      termguicolors = true;
      updatetime = 100;
      relativenumber = true;
      number = true;
      smartcase = true;
      scrolloff = 8;
      tabstop = 2;
      shiftwidth = 2;
      autoindent = true;
			smartindent = true;
			wrap = true;
		linebreak = true;
		breakindent = true;
	}; 
}
