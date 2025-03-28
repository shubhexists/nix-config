{
    pkgs,
    username,
    ...
}: {
    imports = [];
    home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
    };

    qt.enable = true;
    qt.platformTheme.name = "gtk";
    qt.style.name = "adwaita-dark";
    qt.style.package = pkgs.adwaita-qt;

    gtk = {
        enable = true;
        theme = {
            name = "Materia-dark";
            package = pkgs.materia-theme;
        };
        iconTheme = {
            package = pkgs.tela-icon-theme;
            name = "Tela-black";
        };
    };

    home.packages = with pkgs; [
        vesktop
        telegram-desktop
        obs-studio
        vlc
    ];
    home.stateVersion = "24.11";
}