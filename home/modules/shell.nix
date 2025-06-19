{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initContent = ''
      alias nixupdate='
        if [[ -n $(git -C /etc/nixos status --porcelain) ]]; then
          echo "❌ Git tree is dirty. Please commit your changes before rebuilding.";
          echo ""
          git -C /etc/nixos status
	  return 1;
        else
          echo "✅ Git tree is clean. Proceeding with rebuild...";
          sudo nixos-rebuild switch --flake /etc/nixos#Acer-Aspire;
        fi
      '
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory $git_branch $git_status $character";
    };
  };

  home.packages = with pkgs; [ zsh starship ];
}
