{ pkgs, ... }: {

    imports = [
        ./starship.nix
        ./zsh.nix
    ];

    home.packages = with pkgs; [ zsh starship ];
}
