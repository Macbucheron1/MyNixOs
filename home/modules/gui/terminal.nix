{ pkgs, ... }: {
  home.packages = with pkgs; [
    alacritty
  ];

  # Service utilisateur pour Alacritty (auto-démarrage)
  systemd.user.services.alacritty = {
    Unit = {
      Description = "Alacritty Terminal";
      After = "graphical-session.target";
      PartOf = "graphical-session.target";
    };
    Service = {
      ExecStart = "${pkgs.alacritty}/bin/alacritty";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}