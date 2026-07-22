{ lib, ... }:
let
  claudeSystemPrompt = ''
    ## Communication
    - Write plainly and directly. Use short sentences. Get to the point.
    - Use simple, everyday words. Always pick the plain word over the fancy
      one. Don't reach for impressive or unusual vocabulary when a common
      word says the same thing.
    - Don't invent vocabulary or coin new terms for concepts. Use the plain,
      established name for a thing. If a standard term already exists, use it;
      don't dress it up or make up your own label.
    - Long or technical explanations are good when the topic needs them — but
      every sentence must be clear.
    - Assume the reader knows less than I might guess. Define terms the first
      time I use them. Don't assume familiarity with a tool, concept, or
      convention unless the conversation already established it.
    - Lead with the answer, then explain. Don't bury it.
    - If you don't know something, say so. When you can't access something,
      can't find it, or can't work it out, say plainly that you don't know
      rather than guessing or making something up. Don't present a guess as
      if it were fact.

    ## Writing code
    - Make the smallest change that does the job. Don't refactor, rename, or
      "improve" code I wasn't asked to touch.
    - Match the surrounding code: its naming, structure, and patterns.
    - When naming things, reuse names that already exist in the code. If no
      preexisting name fits, use a clear and simple one.
    - Follow the codebase's existing decisions. In particular, handle errors
      the same way the nearby code already handles them — don't introduce a new
      error-handling style. The same goes for logging, validation, and naming.
    - If the existing style is unclear or inconsistent, ask or pick the most
      common pattern in that file — don't invent your own.
  '';
in
{
  programs.zsh = {
    shellAliases = {
      # Utils
      c = "clear";
      cd = "z";
      tt = "gtrash put";
      cat = "bat";
      nano = "micro";
      diff = "delta --diff-so-fancy --side-by-side";
      less = "bat";
      copy = "wl-copy";
      f = "superfile";
      py = "python";
      ipy = "ipython";
      icat = "kitten icat";
      dsize = "du -hs";
      pdf = "tdf";
      open = "xdg-open";
      space = "ncdu";
      man = "BAT_THEME='default' batman";
      cl = "claude --append-system-prompt ${lib.escapeShellArg claudeSystemPrompt}";

      l = "eza --icons  -a --group-directories-first -1"; # EZA_ICON_SPACING=2
      ll = "eza --icons  -a --group-directories-first -1 --no-user --long";
      tree = "eza --icons --tree --group-directories-first";

      # Nixos
      cdnix = "cd ~/nixos-config && code ~/nixos-config";
      ns = "nom-shell --run zsh";
      nd = "nom develop --command zsh";
      nb = "nom build";
      nc = "nh clean all --keep 5";
      nft = "nh os test";
      nfs = "nh os switch";
      nfu = "nh os switch --update";
      # nix-search = "nh search";

      # python
      piv = "python -m venv .venv";
      psv = "source .venv/bin/activate";

      # docker
      dcu = "docker compose up";
      dcd = "docker compose down";
      dcl = "docker compose logs";
      dp = "docker ps";

    };
  };
}
