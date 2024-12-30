{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "devtools";
      paths = [
        gcc
        neovim
        fd
        ripgrep
        fzf
        nodejs_22
      ];
    };
  };
}
