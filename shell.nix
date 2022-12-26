{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell rec {
    ocamlPackages = with pkgs.ocamlPackages; [
      ocaml
      dune_3
      ocaml-lsp
    ];

    neovim = pkgs.neovim.override {
      configure = {
        customRC = ''
          set number
          ${import ./nix/neovim-lsp.nix {}}
          ${import ./nix/neovim-cmp.nix {}}
        '';

        packages.packages = with pkgs.vimPlugins; {
          start = [
            nvim-lspconfig
            nvim-cmp
            cmp-nvim-lsp
          ];
        };
      };
    };

    nativeBuildInputs = ocamlPackages ++ [ neovim ];

    shellHook = ''
      alias vim='nvim'
    '';
}
