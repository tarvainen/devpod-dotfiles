{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "devtools";
      paths = [
        neovim
        fd
        ripgrep
        fzf
        nodejs_22
      ];
    };
  };
}
