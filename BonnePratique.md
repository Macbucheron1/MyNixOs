# Configuration de NixOS 25.05 avec Flakes et Home Manager : Guide de bonnes pratiques

## 1. Introduction à *flakes* et *Home Manager*

**Flakes**, introduits de manière expérimentale dans Nix, apportent une structure standardisée aux configurations NixOS tout en améliorant la **reproductibilité** et la **composabilité** des environnements. Concrètement, un flake est un dépôt (ou répertoire) contenant un fichier `flake.nix` définissant les **composants Nix** du projet (paquets, modules NixOS, configurations, etc.), avec un fichier de verrouillage `flake.lock` qui fige les révisions exactes de chaque dépendance. Cela signifie que la même configuration peut être reconstruite à l’identique plus tard ou sur une autre machine, garantissant un environnement stable dans le temps. Les flakes facilitent également le partage et la composition de configurations Nix : on peut facilement importer des modules ou paquets d’autres flakes, tout en évitant les écueils des anciennes approches (chaînes de canaux non verrouillées, `NIX_PATH` global, etc.).

**Home Manager**, de son côté, est un module complémentaire à NixOS conçu pour gérer l’environnement *utilisateur* de façon déclarative avec Nix. Plutôt que d’installer vos logiciels utilisateur via `nix-env` ou de gérer manuellement vos fichiers de configuration (dotfiles) dans votre dossier home, Home Manager permet de :

* **Installer des logiciels** dans le profil utilisateur de manière déclarative (via des options Nix) au lieu d’installations impératives. Cela évite par exemple les mises à jour indésirables que pouvait provoquer `nix-env --upgrade` sur des paquets installés manuellement.
* **Gérer vos dotfiles et configurations utilisateur** dans Nix. Home Manager peut créer ou lier des fichiers de configuration (dans `~/.config`, `~/`...) de façon déclarative. Il fournit de nombreuses options prédéfinies pour configurer les programmes courants (shell, éditeurs, terminal, etc.), ou permet de simplement intégrer vos propres fichiers de configuration dans le système Nix (via des options comme `home.file` ou `xdg.configFile`).

**Pourquoi utiliser flakes et Home Manager ?** Pour un usage personnel, combiner ces deux outils apporte de grands avantages en termes de **maintenabilité** et de **reproductibilité**. Vous conservez **toute votre configuration dans du code** versionné (généralement dans un dépôt Git), ce qui facilite le suivi des modifications et le déploiement de votre environnement sur une nouvelle machine. Les modifications sont centralisées dans les fichiers Nix, réduisant les risques d’erreurs manuelles et permettant des **rollbacks** faciles en cas de problème (grâce au système de générations de NixOS). De plus, l’utilisation de Home Manager évite de devoir donner les droits *root* pour installer des logiciels utilisateur ou modifier des fichiers dans votre `$HOME` – tout est géré via la configuration Nix et appliqué proprement. En résumé, flakes assure que chaque build du système utilise exactement les mêmes bases logicielles (versions de NixOS, de Home Manager, etc.), et Home Manager assure une intégration transparente des paramètres utilisateur dans cette configuration unifiée.

## 2. Structure recommandée de la configuration NixOS flakée

Pour organiser une configuration NixOS 25.05 avec flakes et Home Manager, il est conseillé d’adopter une **structure modulaire** claire. Un schéma courant consiste à avoir un dépôt (par ex. `dotfiles` ou `nixos-config`) contenant au minimum :

* **`flake.nix`** – le fichier principal du flake, point d’entrée qui définit les outputs (notamment la configuration NixOS, éventuellement les configurations Home Manager) et les dépendances du flake.
* **`flake.lock`** – le fichier de verrouillage auto-généré, qui enregistre les versions exactes de chaque entrée (inputs) du flake pour garantir la reproductibilité.
* **`configuration.nix`** – le module NixOS principal pour la configuration système. Traditionnellement, sous NixOS, on modifie `/etc/nixos/configuration.nix`. Dans un projet à base de flake, on place ce fichier dans le dépôt et on l’importe depuis `flake.nix`. Ce fichier contient les réglages *système* (services système, matériel, réseau, etc.).
* **`home.nix`** – un module de configuration Home Manager pour l’utilisateur. On y déclare les réglages *utilisateur* (logiciels de l’utilisateur, configuration des applications, variables d’environnement utilisateur, etc.), et il sera importé par le module Home Manager intégré au système.

Un exemple d’arborescence pourrait être :

```bash
my-nixos-config/
├── flake.nix
├── flake.lock
├── nixos/
│   ├── configuration.nix
│   ├── hardware-configuration.nix
│   └── modules/
│       ├── bureau.nix
│       ├── reseau.nix
│       └── ... 
└── home/
    └── home.nix   (configuration Home Manager de l'utilisateur)
```

Dans cet exemple, on a rangé `configuration.nix` et d’autres modules système dans un dossier `nixos/`, et la config Home Manager de l’utilisateur dans `home/`. La séparation en plusieurs fichiers est facultative mais fortement conseillée dès que la configuration devient conséquente, pour garder des fichiers courts et lisibles. NixOS permet de **modulariser** la config grâce à l’option `imports` : on peut lister dans `configuration.nix` (ou même dans un module dédié) d’autres fichiers `.nix` à importer, et Nix fusionnera automatiquement ces configurations. Les valeurs définies dans plusieurs modules sont combinées intelligemment (par exemple les listes de paquets provenant de différents modules seront concaténées). Ainsi, on peut organiser ses fichiers par thématique (un module pour l’environnement de bureau, un pour le développement, un pour les paramètres matériel, etc.), ce qui améliore la maintenabilité.

**`hardware-configuration.nix`** est le fichier généré par l’installateur NixOS contenant la configuration matériel (détection des disques, pilotes, etc.). Il est généralement importé depuis `configuration.nix`. Il convient de le laisser tel quel (sauf besoin particulier) et de le conserver à jour si le matériel change.

En synthèse, la racine du flake contiendra `flake.nix` et `flake.lock`, et vous pouvez structurer les configurations NixOS et Home Manager dans des sous-dossiers. Cette séparation permet de clairement distinguer ce qui relève du système et de l’utilisateur, et de tirer parti du système de modules pour éviter un fichier monolithique difficile à maintenir.

Enfin, veillez à **versionner** (git) votre flake.nix, flake.lock et vos modules. Cela vous permettra de revenir en arrière facilement ou de comparer les changements lorsque vous mettrez à jour NixOS ou vos configurations.

## 3. Intégration de Home Manager comme module NixOS (et non en standalone)

Home Manager peut être utilisé de deux façons sur NixOS : soit **standalone** (installation utilisateur indépendante) en utilisant la commande `home-manager` séparément, soit comme **module intégré à NixOS** (via la configuration du système). Dans le cadre d’une machine personnelle avec NixOS, il est recommandé d’utiliser **Home Manager en module NixOS**, c’est-à-dire intégré à la configuration du système, afin de gérer à la fois le système *et* l’environnement utilisateur avec une seule commande (`nixos-rebuild`). En effet, sur une machine personnelle, il est plus simple et cohérent de ne pas multiplier les outils de déploiement : en intégrant Home Manager, toute la configuration (root et user) est reconstruite et activée en même temps, ce qui évite d’avoir à exécuter deux commandes et assure la synchronisation entre les versions du système et de l’environnement utilisateur.

**Mise en place dans le flake :** pour intégrer Home Manager, il faut l’ajouter en tant que **dépendance du flake** et l’inclure dans les modules NixOS. Concrètement :

* Dans `flake.nix`, déclarez un input pointant vers le dépôt Home Manager. Par exemple, dans l’attribut `inputs` :

  ```nix
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";   # branche stable 25.05 de NixOS
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # ... éventuels autres inputs
  };
  ```

  Ici, on spécifie que `home-manager` vient du dépôt GitHub officiel. On ajoute également la ligne `home-manager.inputs.nixpkgs.follows = "nixpkgs";` afin de **réutiliser la même version de nixpkgs** pour Home Manager que pour notre système. Cela évite que Home Manager importe sa propre version de nixpkgs différente – ce qui économise de l’espace et garantit que tous les paquets (système et utilisateur) proviennent de la même base NixOS. En somme, on s’aligne sur l’input `nixpkgs` défini pour NixOS.

* Toujours dans `flake.nix`, dans l’attribut `outputs`, incluez le module NixOS de Home Manager. Par exemple, pour la configuration NixOS (souvent sous `outputs.nixosConfigurations.<nom_machine>`), on pourra écrire :

  ```nix
  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      <hostname> = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix              # module principal NixOS
          home-manager.nixosModules.home-manager # module Home Manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.<utilisateur> = import ./home/home.nix;
          }
        ];
      };
    };
  };
  ```

  Quelques explications sur ces options importantes du module Home Manager intégré :

  * `home-manager.useGlobalPkgs = true;` indique à Home Manager d’utiliser **le même ensemble de paquets `pkgs` que le système**. Sans cela, Home Manager aurait son propre `pkgs` (pointant par défaut sur nixpkgs-unstable) et pourrait installer des paquets d’une version différente. En activant useGlobalPkgs, on garde une cohérence totale : les paquets Home Manager seront pris dans la même version de nixpkgs (ici NixOS 25.05) que le système.
  * `home-manager.useUserPackages = true;` permet d’installer les paquets utilisateur via l’option NixOS `users.users.<utilisateur>.packages` plutôt que via `home.packages` de Home Manager. Autrement dit, les paquets de l’utilisateur seront déclarés dans la configuration NixOS (profil de l’utilisateur) au lieu d’être gérés séparément par Home Manager. Cela évite les doublons et consolide la liste des paquets à un seul endroit. C’est un choix optionnel, mais souvent adopté pour simplifier la maintenance sur un système à utilisateur unique.
  * `home-manager.users.<utilisateur> = import ./home/home.nix;` lie le module Home Manager à votre utilisateur. On importe ici le fichier `home.nix` (chemin d’exemple) qui contient la configuration Home Manager de l’utilisateur en question. Vous pouvez aussi écrire la configuration utilisateur inline, mais l’importer depuis un fichier dédié améliore la lisibilité.

  **NB :** Veillez à remplacer `<hostname>` et `<utilisateur>` par le nom de votre machine (tel que souhaité dans la config NixOS) et votre nom d’utilisateur UNIX.

* Une fois ce schéma en place, **Home Manager est intégré**. Cela signifie que lors d’un `nixos-rebuild switch`, NixOS va construire la configuration système ainsi qu’une génération Home Manager pour l’utilisateur spécifié, puis activer le tout. Home Manager crée en arrière-plan un service systemd utilisateur qui applique la configuration (via un `home-manager-generation`), mais vous n’avez pas à l’exécuter manuellement – c’est géré via le rebuild du système.

* **`home.stateVersion` :** N’oubliez pas de définir l’option `home.stateVersion` pour votre configuration Home Manager utilisateur. Cette option n’a pas de valeur par défaut et sert de référence de version pour d’éventuelles migrations de Home Manager. Par exemple, dans votre `home.nix` (ou dans le bloc `home-manager.users...` directement), ajoutez : `home.stateVersion = "25.05";`. On la fixe généralement à la version de NixOS/Home Manager correspondant au système initial, et on la met à jour lors des mises à niveau majeures si nécessaire. Si vous oubliez de la définir, une erreur vous le rappellera lors du rebuild (option non définie).

**Déclaration des paquets, services et configurations utilisateur :** Une fois Home Manager intégré, vous disposez de deux possibilités pour déclarer les **paquets utilisateur** :

* **Via Home Manager** – En définissant `home.packages = [ pkg1 pkg2 ... ];` dans la configuration Home Manager de l’utilisateur (fichier home.nix). Cela fera installer ces paquets dans le profil utilisateur Home Manager. *Remarque:* Si `useUserPackages = true` (comme ci-dessus), l’option `home.packages` de Home Manager est désactivée au profit de la méthode suivante.
* **Via NixOS (profil utilisateur déclaré)** – En listant les paquets dans `users.users.<utilisateur>.packages` (dans la config système). Cette liste de paquets sera installée dans le profil Nix standard de l’utilisateur (comme si on utilisait `environment.systemPackages` mais pour le user spécifiquement). Avec `home-manager.useUserPackages = true`, Home Manager **utilisera cette liste** pour le profil de l’utilisateur. L’avantage est de n’avoir qu’une seule liste de paquets à maintenir. Par exemple, dans `configuration.nix` on peut ajouter :

  ```nix
  users.users.<utilisateur>.packages = with pkgs; [
    firefox
    thunderbird
    ... 
  ];
  ```

  Ainsi, ces logiciels seront installés pour l’utilisateur et utilisables directement.

Pour les **services et démons utilisateur** : Home Manager propose un sous-module `home-manager.services` (ou simplement `services` dans le contexte Home Manager) permettant de gérer des services au niveau utilisateur (via systemd --user). Par exemple, vous pouvez activer le daemon de wallpapers *Hyprpaper* via `services.hyprpaper.enable = true;` dans votre home.nix. De nombreuses options de ce type existent pour lancer des agents ou services de session (notification, agents secrets, etc.) en user space. Par exemple, en activant `services.hyprpaper.enable`, Home Manager installera *hyprpaper* et générera une unité systemd --user pour le lancer automatiquement en arrière-plan (avec la configuration indiquée dans `services.hyprpaper.settings`). De même, il existe des modules pour d’autres services courants (par ex. `services.gpg-agent`, `services.dunst`, etc.). Cela vous évite d’écrire manuellement des fichiers d’unité ou des scripts d’auto-lancement.

Pour les **configurations utilisateur** (fichiers de config des applications, dotfiles personnalisés, etc.), Home Manager offre plusieurs approches :

* Utiliser les **options de modules Home Manager dédiés** pour vos programmes. Par exemple, Home Manager a des modules pour de nombreux programmes : `programs.zsh` (configuration du shell Zsh), `programs.git` (configurer nom d’utilisateur, email dans git), `programs.vim`, etc. Si un module existe, il suffit de renseigner ses options. Par exemple, pour configurer Git :

  ```nix
  programs.git = {
    enable = true;
    userName = "John Doe";
    userEmail = "john.doe@example.com";
  };
  ```

  Home Manager créera alors automatiquement le fichier `~/.gitconfig` avec ces informations.

* Pour les programmes plus spécifiques ou lorsque vous avez déjà un fichier de configuration bien rodé, utiliser les options **`home.file` ou `xdg.configFile`**. Par exemple, si vous avez un fichier de configuration pour un outil qui doit se trouver à `~/.config/myapp/config.yaml`, vous pouvez faire :

  ```nix
  xdg.configFile."myapp/config.yaml".source = ./configs/myapp-config.yaml;
  ```

  Home Manager copiera (en fait *linkera*) alors ce fichier dans `$XDG_CONFIG_HOME/myapp/config.yaml`. Vous pouvez aussi utiliser `text = "..."` au lieu de `source` pour écrire directement le contenu. L’important est que ces fichiers seront pris en charge par Nix (stockés dans le store et liés dans le home) – plus besoin de les gérer manuellement.

En résumé, l’intégration de Home Manager en module NixOS vous permet de déclarer **au même endroit** vos logiciels utilisateurs, vos configurations (fichiers ou options), et les éventuels services de session, avec tous les bénéfices du déploiement déclaratif (cohérence, reproductibilité, facilité de sauvegarde).

*Remarque :* En mode intégré, toute modification de la configuration Home Manager nécessite de reconstruire le système (commande `nixos-rebuild`). C’est logique car Home Manager est appliqué via le système. Sur une machine personnelle, ce n’est pas un inconvénient majeur, mais sachez-le : par exemple, ajouter un nouveau paquet utilisateur impliquera un rebuild global (vous ne pouvez pas utiliser `home-manager switch` seul, qui d’ailleurs n’est probablement pas installé en global dans cette configuration).

## 4. Configuration de l’environnement Hyprland avec flakes et Home Manager

Vous avez choisi d’utiliser **Hyprland** comme environnement de bureau (compositeur Wayland tiling). Configurer Hyprland via NixOS + Home Manager permet d’obtenir un *desktop* Wayland entièrement reproductible et géré par Nix, du serveur d’affichage aux barres, menus et fonds d’écran. Voici les bonnes pratiques pour une intégration propre de Hyprland et des composants associés (Waybar, rofi, hyprpaper, etc.) :

**a. Module NixOS pour Hyprland (côté système) :** D’après la documentation officielle de Hyprland, il est requis d’activer un module NixOS qui prépare le système pour Hyprland. Ce module configure les composants critiques tels que : **polkit** (nécessaire pour les autorisations d’administration en session Wayland), **xdg-desktop-portal** spécifique Hyprland (pour la prise en charge des captures d’écran, pipewire, etc.), les pilotes graphiques et réglages relatifs (par ex. patchs Nvidia si vous avez une carte Nvidia), la police par défaut, les schémas dconf, etc. Sur NixOS 25.05, ce module Hyprland est disponible via l’option `programs.hyprland.enable`. En pratique, dans votre `configuration.nix`, ajoutez :

```nix
programs.hyprland = {
  enable = true;
  xwayland.enable = true;      # Activer XWayland pour les applications X11
  nvidiaPatches = true;        # Si vous utilisez un GPU Nvidia (ajuste wlroots)
};
```

Cette configuration de base active Hyprland au niveau système. Le module NixOS se charge alors d’installer Hyprland et d’activer tout ce qu’il faut autour. Par exemple, `programs.hyprland.enable` va automatiquement installer le **paquet Hyprland** (et ses dépendances) et peut activer le service `xdg-desktop-portal-hyprland` approprié, etc. (vérifiez la documentation NixOS 25.05 pour les détails exacts du module). L’option `xwayland.enable` est vivement recommandée pour pouvoir lancer des applications X11 dans votre session Wayland. L’option `nvidiaPatches` est à activer seulement si vous avez une carte Nvidia propriétaire – elle applique des correctifs permettant à Hyprland (et wlroots) de fonctionner correctement avec les pilotes Nvidia.

**Utilisation du flake Hyprland officiel (optionnel) :** Le projet Hyprland fournit un flake Nix officiel (dépôt `hyprwm/Hyprland` sur GitHub) qui contient les modules NixOS et Home Manager nécessaires. Sur une version stable de NixOS, vous pourriez simplement utiliser le module inclus dans nixpkgs, mais si vous souhaitez la *toute dernière version* de Hyprland ou profiter de la config “upstream”, vous pouvez importer ce flake. Pour ce faire, ajoutez dans vos inputs de `flake.nix` quelque chose comme :

```nix
hyprland.url = "github:hyprwm/Hyprland";
hyprland.inputs.nixpkgs.follows = "nixpkgs";
```

et incluez son module NixOS lors du build :

```nix
modules = [
  ./nixos/configuration.nix
  hyprland.nixosModules.default
  { programs.hyprland.enable = true; /* + options */ }
  ... ];
```

Ce flake externe permet de s’assurer d’installer Hyprland tel que fourni par ses développeurs et *« installe tout ce dont on a besoin en une seule fois »*. La différence est subtile si le module est désormais dans nixpkgs stable, mais l’approche flake officiel garantit la version la plus récente de Hyprland. Dans tous les cas, le résultat est qu’une fois `programs.hyprland.enable` activé et reconstruit, vous aurez Hyprland disponible. Pour lancer une session Hyprland, deux options : soit utiliser un **gestionnaire de connexion (display manager)** compatible Wayland (par exemple GDM, SDDM) où Hyprland apparaîtra comme session disponible, soit démarrer Hyprland manuellement après connexion sur un TTY (via `exec Hyprland` dans votre `.bash_profile` ou en démarrant un service de login automatique qui lance Hyprland). De nombreux utilisateurs utilisent aussi **`greetd`** avec un greeter Wayland (par ex. `gtkgreet` ou `wlgreet`) pour lancer automatiquement Hyprland sans passer par un environnement lourd de DM – c’est une piste possible si vous cherchez une solution légère.

**b. Module Home Manager pour Hyprland (côté utilisateur) :** Le module NixOS prépare le terrain, mais pour la configuration fine de Hyprland (raccourcis clavier, disposition des fenêtres, apparence, etc.), on utilise le **module Home Manager de Hyprland**. Ce dernier permet de **déclarer la configuration de Hyprland de façon déclarative** dans Home Manager, au lieu d’écrire manuellement le fichier `~/.config/hypr/hyprland.conf`. Activez-le en ajoutant dans votre `home.nix` (configuration Home Manager de l’utilisateur) :

```nix
wayland.windowManager.hyprland.enable = true;
wayland.windowManager.hyprland.settings = {
  # Configuration de Hyprland exprimée en Nix
  general.gaps_in = 0;
  general.gaps_out = 0;
  general.border_size = 5;
  ...
};
# wayland.windowManager.hyprland.extraConfig = '' ... '';
```

L’option `wayland.windowManager.hyprland.enable` à `true` indique à Home Manager d’activer son module Hyprland. Celui-ci va installer Hyprland (au besoin) dans le profil utilisateur et surtout **générer le fichier de configuration** Hyprland. Les sous-options permettent deux approches : `settings` pour fournir la config sous forme d’attributs Nix (comme ci-dessus, où on définit quelques valeurs dans la section `[general]` par exemple), et `extraConfig` pour insérer du texte brut tel quel si vous avez des bouts de config non couverts par les attributs. Vous pouvez combiner les deux. Après un rebuild, Home Manager va placer votre config dans `~/.config/hypr/hyprland.conf` (ou un chemin similaire) – généralement via un lien symbolique vers le fichier généré dans le store Nix. À partir de là, toute modification de la config Hyprland doit se faire en éditant `home.nix` puis en reconstruisant, et plus en éditant le fichier à la main (sinon Home Manager écraserait vos changements la prochaine fois).

**c. Autres composants de l’environnement graphique :** Un environnement Hyprland complet comprend typiquement une *barre système* (bar), un *launcher* d’applications, un *wallpaper* et d’autres utilitaires. Voici comment les intégrer proprement :

* **Waybar** (barre d’état pour Wayland) : Home Manager propose un module pour Waybar. Vous pouvez l’activer via :

  ```nix
  programs.waybar.enable = true;
  programs.waybar.settings = {
    "layer-shell" = {
      # configuration Waybar au format JSON, exprimée en Nix
      monitor = "eDP-1";
      height = 30;
      # ...
      modules-right = [ "clock" "pulseaudio" ];
    };
  };
  programs.waybar.style = ''  /* CSS pour styliser la barre */  '';
  ```

  L’option `programs.waybar.enable` installe Waybar et, si vous spécifiez `settings`, Home Manager va générer le fichier de configuration JSON de Waybar automatiquement. Les attributs Nix doivent correspondre à la structure attendue (par ex. on crée une section `"layer-shell"` contenant certains champs). Alternativement, si vous possédez déjà un fichier de config Waybar ou préférez l’écrire vous-même, vous pourriez désactiver `settings` et utiliser à la place `xdg.configFile."waybar/config".source = ./waybar-config.json;` pour que Home Manager installe votre fichier custom dans `~/.config/waybar/config`. Dans tous les cas, Waybar sera disponible. **Important** : Waybar n’est pas lancé automatiquement par Home Manager (il n’y a pas de service *persistant* pour Waybar car c’est un programme de session). Pour le lancer à l’ouverture de la session Hyprland, le plus simple est d’utiliser la configuration Hyprland elle-même : par exemple, ajoutez dans `hyprland.settings` un `exec-once = "waybar &"` (il existe une section `misc` ou autre pour les commandes de lancement automatique). Ainsi, à chaque démarrage de Hyprland, Waybar sera exécuté. Vous pouvez aussi créer une unité systemd --user pour Waybar, mais c’est souvent plus simple de laisser Hyprland gérer ça via son fichier de config.

* **Rofi** (lanceur d’applications) : Rofi est fréquemment utilisé en complément. Home Manager a également un module pour rofi. On peut l’activer :

  ```nix
  programs.rofi.enable = true;
  programs.rofi.theme = "Papirus-Dark";    # exemple de thème
  programs.rofi.font = "monospace 10";     # police
  # programs.rofi.config = `` # éventuellement configuration additionnelle
  ```

  Cela installera rofi et peut générer un fichier de config selon les options fournies (par exemple `theme` va appliquer le thème désiré). Comme pour Waybar, le lancement de rofi se fait à la demande (typiquement lié à un raccourci clavier défini dans Hyprland). Vous devrez donc configurer un binding dans Hyprland, par ex. dans `hyprland.settings` ajouter quelque chose comme: `bind = $mod, D, exec, rofi -show drun` (juste pour illustration – la syntaxe exacte dépend de Hyprland).

* **Hyprpaper** (gestionnaire de fonds d’écran pour Hyprland) : Home Manager fournit un module *service* pour Hyprpaper. En l’activant, Hyprpaper tournera en arrière-plan pour afficher vos fonds d’écran. Exemple dans `home.nix` :

  ```nix
  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    preload = [ "/home/<utilisateur>/Images/wall1.png" "/home/<utilisateur>/Images/wall2.jpg" ];
    wallpaper = [
      "DP-1,/home/<utilisateur>/Images/wall1.png"
      "eDP-1,/home/<utilisateur>/Images/wall2.jpg"
    ];
  };
  ```

  Ici on active Hyprpaper et on définit, via `settings`, la configuration équivalente au fichier hyprpaper.conf (chemins des images à précharger et quelle image sur quel moniteur). Home Manager créera l’unité systemd --user correspondante et lancera Hyprpaper. Notez qu’on fournit les chemins absolus des images (on pourrait aussi les empaqueter via Nix mais ce n’est pas nécessaire pour un usage perso – veillez simplement à ce que ces fichiers existent à l’emplacement indiqué). Grâce à cela, vous n’avez pas besoin de lancer Hyprpaper manuellement ni via Hyprland, il se lance en service user et se reconnecte à Hyprland automatiquement.

* **Autres** : Vous pourriez également installer d’autres utilitaires comme **dunst** (notifications), **NetworkManager applet** (nm-applet) si besoin d’un gestionnaire réseau en barre, **pavucontrol** ou **wireplumber** pour le son, etc. Beaucoup de ces composants peuvent être installés via Home Manager ou NixOS. Par exemple, pour les notifications, Home Manager a `services.dunst.enable`. Pour la gestion du son sous Wayland, NixOS offre souvent des modules (ex: `hardware.pulseaudio` ou mieux, `hardware.audio.pipewire.enable = true;` qui active PipeWire pour audio+video, et on peut ajouter `services.pipewire.pulse.enable = true;` pour la compatibilité PulseAudio, etc.). Assurez-vous aussi d’inclure `programs.swayidle` ou `swaylock` si vous voulez gérer la veille et le verrouillage d’écran (il existe `services.xidlehook` ou `services.swayidle` selon préférences). L’idée générale est de rechercher s’il existe un module Home Manager ou NixOS pour le composant voulu, et sinon, d’installer le paquet et de gérer sa config via un fichier dans `home.file` ou via Hyprland.

En suivant ces étapes, votre environnement Hyprland sera entièrement déclaré. **Hyprland (compositeur)** est géré par NixOS (stabilité, services systèmes prêts), tandis que la **personnalisation de Hyprland** et des outils de l’utilisateur est gérée par Home Manager (souplesse, dotfiles gérés). Cette séparation des responsabilités est très efficace avec Nix.

**Conseil :** si vous rencontrez un comportement étrange (ex: une config Hyprland qui ne semble pas appliquée), vérifiez que vous n’avez pas d’ancien fichier de configuration qui entre en conflit. Par exemple, si vous aviez déjà un `~/.config/hypr/hyprland.conf` existant avant d’utiliser Home Manager, celui-ci risque de bloquer la création du lien par Home Manager (erreur du type *« existing file in the way »*). La solution est de supprimer ou renommer l’ancien fichier pour laisser Home Manager gérer le chemin. De manière générale, lorsqu’on adopte Home Manager, il faut laisser Nix prendre le contrôle des fichiers de config concernés – toute modification manuelle doit être convertie en déclaration Nix, sans quoi elle sera écrasée ou causera un conflit.

## 5. Gestion des secrets et variables sensibles

Gérer des **données sensibles (clés API, mots de passe, certificats, etc.)** dans une configuration NixOS/Home Manager nécessite quelques précautions. Par défaut, **tout fichier ou valeur intégré dans la configuration Nix** se retrouve dans le *Nix Store* et peut être lu par n’importe quel utilisateur avec les commandes adéquates. Il est donc déconseillé de mettre en clair des secrets (par exemple une clé API dans un `home.nix`). Pour concilier déclaration et confidentialité, on utilisera une solution de **chiffrement des secrets**.

Une approche répandue consiste à utiliser **sops-nix** (ou son équivalent *agenix*). **Sops-nix** est un module qui s’appuie sur l’outil Mozilla SOPS pour chiffrer vos secrets et permet à NixOS de les déchiffrer *au moment de l’activation* du système (donc sans jamais stocker le secret en clair dans le Nix Store). Le principe : on garde un fichier (YAML, JSON…) contenant les secrets chiffrés (souvent avec une clé asymétrique *age*), commité dans le repo. Sops-nix, intégré à NixOS et Home Manager, va lors du `nixos-rebuild` déchiffrer ce fichier et mettre à disposition le contenu sous forme de fichiers temporaires non lisibles par les autres utilisateurs. Votre configuration Nix peut ensuite lire ces fichiers pour exporter les secrets comme variables d’environnement, fichiers de config, etc.

**Mise en place rapide de sops-nix :**

* Ajoutez `sops-nix` aux inputs de votre flake :

  ```nix
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  ```

* Dans les `modules` de votre configuration NixOS (flake.nix), importez les modules NixOS et Home Manager de sops-nix :

  ```nix
  modules = [
    ./configuration.nix
    sops-nix.nixosModules.sops   # intègre sops-nix au système NixOS
    home-manager.nixosModules.home-manager {
      # ... config Home Manager ...
      home-manager.sharedModules = [ 
        sops-nix.homeManagerModules.sops  # intègre sops-nix à Home Manager
      ];
    }
  ];
  ```



  Ci-dessus, `home-manager.sharedModules` est utilisé pour que le module Home Manager de sops-nix soit pris en compte.

* Créez votre clé de chiffrement *age* (par ex avec `age-keygen`) et un fichier de configuration `.sops.yaml` définissant quelle clé utiliser pour quel fichier de secrets.

* Créez un fichier de secrets chiffrés, par ex `secrets.yaml`, en utilisant SOPS : `nix run nixpkgs#sops -- secrets.yaml` (cela ouvrira un éditeur pour saisir les secrets en clair, puis SOPS les chiffrera à la sauvegarde).

* Dans votre config NixOS/Home Manager, déclarez l’utilisation des secrets. Sops-nix expose généralement les secrets sous forme d’attributs `config.secrets."nom"` ou via des fichiers dans `/run/secrets`. Par exemple, sops-nix permet de définir une option comme :

  ```nix
  environment.etc."my-secret".source = config.secrets.mySecret.path;
  environment.variables.MY_SECRET = "${config.secrets.mySecret.content}";
  ```

  *(Le nom exact des attributs dépend de la config sops-nix que vous aurez, mais l’idée est qu’on peut lire le contenu déchiffré).*

  Pour Home Manager, sops-nix offre aussi un moyen d’intégrer les secrets au scope utilisateur. Par exemple, on peut obtenir un `home.secrets` similaire pour l’utilisateur. Ainsi, vous pourrez passer ces secrets à des programmes Home Manager. Un cas d’usage : exporter `OPENAI_API_KEY` dans votre environnement utilisateur de façon sécurisée – on le stocke chiffré et on le ressort en variable d’environnement uniquement à l’exécution.

L’avantage de cette approche est que **vos secrets restent chiffrés dans le dépôt Git** et ne sont déchiffrés qu’au moment nécessaire, en mémoire ou dans des fichiers protégés (permissions strictes). Même si quelqu’un accède à votre Nix Store ou votre repo, il ne verra que des données chiffrées.

En alternative à sops-nix, **agenix** est un autre outil similaire, focalisé sur *age*, avec une syntaxe légèrement différente mais le même principe (un module NixOS pour déchiffrer des fichiers listés). À vous de voir la solution qui vous convient le mieux. Dans tous les cas, l’idée principale est : **ne pas écrire de secret en clair** dans `configuration.nix` ou `home.nix`. Utilisez un module de secrets, ou a minima une technique comme les `passwordFile` disponibles dans certaines options (de nombreux modules NixOS/Home Manager proposent `[...]PasswordFile` pour pointer vers un fichier externe contenant un mot de passe). Si vous utilisez `passwordFile`, vous devrez alors déployer ledit fichier de manière sécurisée sur la machine (hors Nix) – ce qui est moins pratique, d’où l’intérêt des solutions comme sops-nix pour l’intégrer au déploiement Nix.

Enfin, pensez aux aspects *runtime* : si un programme a besoin d’un mot de passe en variable d’env, assurez-vous qu’il n’écrit pas cette variable dans ses logs ou ailleurs. Nix vous aide pour la partie stockage, mais la prudence d’usage générale reste de mise.

## 6. Astuces de débogage et commandes utiles

Travailler avec NixOS et les flakes peut parfois être déroutant au début. Voici quelques commandes et astuces indispensables pour gérer et déboguer votre configuration :

* **Reconstruction du système flaké :** Utilisez toujours `nixos-rebuild` avec l’option `--flake`. Par exemple, si vous êtes dans le répertoire de votre flake, exécutez `sudo nixos-rebuild switch --flake .#<hostname>` pour construire et activer la configuration `<hostname>` définie dans votre flake. Le `.#<hostname>` fait référence à l’attribut dans `flake.nix` (sous `outputs.nixosConfigurations`) correspondant à votre machine. S’il n’y a qu’une configuration et qu’elle s’appelle `default`, vous pouvez aussi faire `--flake .#default` ou même `--flake .`. La commande `switch` construit la nouvelle configuration, puis active immédiatement cette génération (et la définit comme choix par défaut pour le prochain boot).

  * **`nixos-rebuild dry-run`** est utile pour simuler une construction sans appliquer les changements. Cela permet de voir quels services seraient redémarrés, quels paquets seraient construits/téléchargés, etc., sans risque pour le système.
  * **`nixos-rebuild test`** construit et active la config SANS changer le lien de système courant. Autrement dit, on charge la nouvelle config immédiatement, mais en cas de reboot, on reviendra sur l’ancienne (sauf si on fait un switch ensuite). Pratique pour tester une modification risquée : si quelque chose ne va pas, un redémarrage annulera les changements.
  * **`nixos-rebuild boot`** construit la config mais ne l’active pas de suite – elle sera seulement disponible au prochain démarrage (utile par ex. si on ne veut pas interrompre la session en cours, ou pour préparer une màj du kernel qu’on activera via un reboot manuel plus tard).

* **Mettre à jour les dépendances du flake (`flake.lock`) :** Pour suivre les mises à jour de NixOS (ou de vos autres inputs), utilisez la commande `nix flake update`. Sans argument, elle va **mettre à jour tous les inputs** du flake vers la dernière version disponible (selon les URLs suivies). Par exemple, si votre `flake.nix` pointe vers `nixos-25.05`, elle ira chercher les dernières révisions de la branche 25.05. Si vous suivez `nixpkgs` unstable, elle pointera vers la dernière révision *unstable*. Après cela, vous pourrez reconstruire le système pour appliquer (pensez à committer le nouveau `flake.lock` en Git). Vous pouvez cibler un input en particulier avec `nix flake update <nom_input>` (par ex. `nix flake update home-manager` pour ne mettre à jour que Home Manager).
  Une alternative : `nixos-rebuild switch --update --flake ...` peut exister (selon version de Nix), qui combinerait l’update du flake puis le rebuild en une commande. Vérifiez dans la documentation de votre version de Nix, car ce comportement a évolué. En cas de doute, la séquence sûre est : `nix flake update` puis `nixos-rebuild switch --flake ...`.

* **Inspecter les options et leur valeur effective :** La commande `nixos-option <option>` permet de voir la valeur d’une option NixOS actuelle ou de vérifier sa définition. Par exemple `nixos-option programs.hyprland.enable` montrera si Hyprland est activé et où c’est défini. Pour les options Home Manager intégrées, il se peut que `nixos-option` puisse les voir également (puisqu’elles sont fusionnées dans la config), mais ce n’est pas garanti pour toutes. Vous pouvez aussi consulter la **documentation en ligne** : le site [search.nixos.org/options](https://search.nixos.org/options) pour NixOS, et [mynixos.com/home-manager/options](https://mynixos.com/home-manager/options) pour Home Manager, sont très utiles pour trouver la syntaxe des options et leurs valeurs par défaut.

* **Chercher des paquets :** utilisez `nix search nixpkgs <mot-clé>` (avec le nouveau CLI, sinon `nix-env -qaP <mot>` avec l’ancien) pour trouver un attribut de paquet. Exemple : `nix search nixpkgs hyprland` vous montrera le paquet hyprland disponible. De même, `nix search nixpkgs waybar` etc. Ceci interroge en fait le flake nixpkgs que vous avez configuré (donc il respectera la version de `nixpkgs` de votre flake.lock).

* **Debug des erreurs de build :** Si `nixos-rebuild` échoue, lisez attentivement le message. Souvent, c’est une option mal orthographiée ou un conflit de types. La trace Nix peut être verbeuse ; n’hésitez pas à utiliser `nix repl` pour tester des expressions Nix isolément. Par exemple, pour comprendre pourquoi une certaine valeur ne passe pas, vous pouvez ouvrir un REPL (`nix repl`) puis `:lf .` (load flake) et essayer d’évaluer des sous-parties. C’est avancé, mais utile.

* **Logs des services :** Si un service système ne démarre pas, utilisez `journalctl -xe` ou `journalctl -u <nom_service> -b` pour voir les logs. Dans le cas de Home Manager intégré, rappelez-vous que Home Manager s’exécute via un service *user* systemd. Pour voir son log d’activation, faites `journalctl -xeu home-manager-<utilisateur>.service`. En cas d’erreur (comme mentionné plus haut pour un fichier existant gênant le lien), le log vous le dira explicitement. Vous pouvez alors corriger le problème (supprimer le fichier conflictuel, etc.) puis relancer un rebuild.

* **Rollback :** Une des super fonctionnalités de NixOS est la possibilité de revenir à une génération précédente si quelque chose se passe mal. Si après un `switch` votre système a un problème grave, redémarrez et, dans le menu de boot (GRUB), sélectionnez l’ancienne génération NixOS. Vous pouvez aussi, depuis le système, exécuter `sudo nixos-rebuild rollback` pour revenir à la précédente configuration **sans redémarrer** (ça activera directement la génération précédente). Ceci peut vous sauver en cas de configuration foireuse. Prenez le temps d’identifier ensuite ce qui posait problème avant de retenter un `switch` avec vos modifications.

* **Nettoyage du store :** Au fil des mises à jour, votre Nix Store va croître (chaque génération garde ses paquets). Vous pouvez nettoyer les anciennes générations et paquets plus référencés avec `sudo nix-collect-garbage -d`. Attention cela supprimera *définitivement* toutes les générations sauf la courante et éventuellement les  précédentes spécifiquement gardées. À faire après s’être assuré que la config actuelle fonctionne bien.

Enfin, restez curieux et n’hésitez pas à consulter la documentation officielle (manuels NixOS, Home Manager) et la communauté (Discourse NixOS, Reddit r/NixOS) en cas de doute. Le débogage de NixOS s’améliore avec l’expérience : plus vous comprendrez comment les modules fusionnent et comment lire les erreurs Nix, plus il sera facile de trouver l’origine d’un problème.

## 7. Bonnes pratiques de mise à jour et suivi des canaux stables

Garder sa configuration à jour est essentiel, que ce soit pour bénéficier des **correctifs de sécurité** ou des nouvelles fonctionnalités. Voici quelques conseils pour gérer les mises à jour dans le monde des flakes (où la notion de *canal* est gérée un peu différemment) :

* **Suivre une branche stable de NixOS :** Pour un usage personnel où la stabilité prime, il est recommandé de cibler la branche stable de NixOS dans votre flake. Par exemple, dans l’input `nixpkgs.url`, utiliser `nixos-25.05` (ce qui correspond au canal stable 25.05). Cela signifie que `nix flake update` ira chercher les dernières *minor releases* et correctifs de cette version. Les branches stables NixOS reçoivent des mises à jour de sécurité et bugfix pendant environ 6 mois après leur sortie initiale. En restant sur 25.05, vous évitez les changements disruptifs tout en étant à jour niveau sécurité. Il suffit d’exécuter régulièrement `nix flake update` (ou de l’automatiser via par ex. une GitHub Action ou un cron sur votre machine) pour suivre le canal stable. Pensez à consulter les notes de version de temps en temps (sur le site de NixOS) pour voir les changements notables ou les dépréciations d’options qui pourraient vous concerner.

* **Passage à une nouvelle version stable :** NixOS sort une version stable deux fois par an (05 et 11). Quand la 25.11 sortira, la 25.05 deviendra obsolète au bout d’un certain temps. Pour migrer : modifiez votre `flake.nix` pour pointer `nixpkgs.url` vers `"github:NixOS/nixpkgs/nixos-25.11"` (ou peut-être `"25.11"` si c’est la convention) et mettez à jour. Il est possible que certaines options aient changé ou que `home.stateVersion` doive être mis à jour (Home Manager suit généralement les versions annuelles correspondantes, par exemple de 25.05 à 25.11, vous pourriez passer `home.stateVersion` à "25.11" une fois la migration terminée, afin d’adopter les nouveaux comportements par défaut). Lisez attentivement le *release notes* de NixOS 25.11 et de Home Manager (s’il y en a) pour ajuster votre config en conséquence. Mettez à jour le flake.lock, reconstruisez, et testez.

* **Choisir stable vs unstable :** Le canal *unstable* de NixOS (nixpkgs-unstable) fournit les dernières versions de paquets en rolling release. Vous pourriez être tenté de l’utiliser pour avoir des versions plus récentes de vos logiciels ou de Hyprland. C’est possible – par exemple `nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";` – mais notez que cela implique des mises à jour très fréquentes et parfois des *builds cassés*. Pour un environnement de travail principal, ce n’est pas toujours idéal. Une approche consiste à rester sur stable mais à piocher *ponctuellement* sur unstable pour quelques paquets spécifiques via des overlays ou en ajoutant un deuxième input nixpkgs. Par exemple, vous pourriez avoir `inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";` et utiliser `pkgsUnstable.somePackage` pour un logiciel plus récent. Toutefois, cela complexifie la gestion. Si possible, restez cohérent : tout stable ou tout unstable. **Recommandation :** stable pour la base système et Home Manager (release), unstable seulement si vous aimez vivre à la pointe et êtes prêt à debug les problèmes au fil de l’eau.

* **Mise à jour de Home Manager :** Home Manager étant un projet distinct, il a ses propres versions. Souvent, une branche `release-<version>` existe, alignée sur la version stable de NixOS (ex: `release-23.05` pour NixOS 23.05). Pour NixOS 25.05, vous pouvez vérifier s’il y a une branche correspondante (sinon, la branche `master` de Home Manager est généralement compatible avec unstable et les stables récentes, d’où l’importance du `follows = "nixpkgs"` qu’on a mis). Si vous préférez la stabilité, vous pouvez pointer `home-manager.url = "github:nix-community/home-manager/archive/release-25.05.tar.gz";` par exemple. Sinon, garder `home-manager` sur `master` peut fonctionner tant que vous suivez stable nixpkgs, car en suivant le même nixpkgs on évite les incompatibilités de version. À vous de voir, mais en cas de souci avec Home Manager master, il peut être utile de passer sur la branche stable correspondante.

* **Surveiller les annonces et la documentation :** Le site de NixOS, le *channel* Matrix/IRC et le forum Discourse publient des informations lors de sorties de versions ou de modifications importantes. Par exemple, si une option de Hyprland change de nom dans une prochaine version, la note de version le signalera. Essayez de garder un œil sur ces informations lors des mises à niveau.

* **Tester ses mises à jour :** Lors d’une grosse mise à jour (ex: passage de 25.05 à 25.11, ou bascule vers unstable), il est sage d’utiliser d’abord `nixos-rebuild build --flake ...` pour *construire* la nouvelle configuration sans la déployer, puis éventuellement tester dans une VM ou au moins inspecter que tous les services sont actifs via `nixos-rebuild test` ou en redémarrant sur la nouvelle génération tout en gardant l’ancienne comme fallback. Ce prudence vous évitera de mauvaises surprises.

En résumé, **flakes remplace la notion de channel** par celle d’input git fixé dans le flake.nix. Vous contrôlez explicitement quelle branche ou commit de nixpkgs (et de Home Manager, etc.) vous utilisez. Profitez-en pour adopter un rythme de mise à jour régulier mais maîtrisé. Sur un système perso, mettre à jour NixOS stable toutes les 1-2 semaines est une bonne cadence (vous aurez peu de changements à chaque fois, surtout des patchs). Évitez de rester des mois sans mettre à jour car la reprise peut être plus délicate (beaucoup de changements d’un coup). NixOS offre également la possibilité d’**automatiser les updates** (par ex. via un service `nixos-upgrade` ou des actions GitHub qui ouvrent une PR quand une nouvelle version est dispo), mais ce sont des optimisations facultatives.

---

En suivant ce guide, vous devriez disposer d’un système NixOS 25.05 avec Hyprland, géré par flakes et Home Manager, qui est non seulement **déclaratif et reproductible**, mais aussi proprement organisé et relativement aisé à maintenir à jour. Cette configuration personnelle vous permettra de profiter d’un environnement de bureau Wayland performant (Hyprland) tout en bénéficiant de la puissance de Nix pour la gestion de vos logiciels et configurations. Bon hacking sous NixOS !

**Sources :** NixOS Wiki, documentation Home Manager et Hyprland, et diverses contributions de la communauté ont inspiré ces recommandations, parmi d’autres.