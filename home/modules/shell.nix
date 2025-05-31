{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory $character";
    };
  };

  home.packages = with pkgs; [ zsh starship ];
}
