let
  # Votre clé SSH publique utilisateur
  mac = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIDwcD7QgxMXWNvB5hwy2pnsbBYwFGEDuXavXh/pbE1 nathandeprat@hotmail.fr";
  
  # Clé SSH publique du système (host key)
  macNixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7osaGHOAG/vEgRyKvuNxUu/wLE6t3rO8w/YY9ZDwKp root@Mac-NixOs";
in
{
  # Les secrets seront définis ici au fur et à mesure
  # Format: "nom-du-fichier.age".publicKeys = [ liste des clés autorisées ];
  
  # Exemple: secret pour une base de données
  "db-password.age".publicKeys = [ mac macNixos ];
}