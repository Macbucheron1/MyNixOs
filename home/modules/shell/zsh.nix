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
        echo "🔍 Testing system flake build (without root)..."
        nix build /etc/nixos#nixosConfigurations.mac-nixos.config.system.build.toplevel -o /tmp/nixos-test-build || {
          echo "❌ System flake build failed.";
	  return 1;
        }
        echo "✅ System flake is valid. Ready to commit and deploy!";
      '';
    };
  };

  home.packages = with pkgs; [ 
    zsh 
    wdisplays 
  ];
}