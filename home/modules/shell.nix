{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      nixupdate = ''
        if [[ -n $(git -C /etc/nixos status --porcelain) ]]; then
          echo "❌ Git tree is dirty. Please commit your changes before rebuilding.";
          echo ""
          git -C /etc/nixos status;
          return 1;
        else
          echo "✅ Git tree is clean. Proceeding with rebuild...";
          sudo nixos-rebuild switch --flake /etc/nixos#mac-nixos;
        fi
      '';

      nixtest = ''
        echo "🔍 Testing system flake build..." &&
        nix build /etc/nixos#nixosConfigurations.mac-nixos.config.system.build.toplevel &&
        echo "🔍 Testing home-manager switch (dry-run)..." &&
        home-manager switch --flake /etc/nixos#mac --dry-run &&
        echo "✅ All tests passed."
      '';
    };
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

