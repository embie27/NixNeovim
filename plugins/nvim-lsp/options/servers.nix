{ lib, config, pkgs, ... }:

with lib;
with types;

let

  helpers = import ../../helpers.nix { inherit lib config; };
  servers = (import ../lsp-helpers.nix { inherit lib config pkgs; }).servers;

  toLspModule = server:
    with helpers;
    let
      # cfg = config.programs.nixvim.plugins.lsp.servers.${server.name};
    in mkOption {
      type = nullOr (submodule {
        options = {
          enable = mkEnableOption "";
          onAttachExtra = mkOption {
            type = types.lines;
            description = "A lua function to be run when ${server.name} is attached. The argument `client` and `bufnr` are provided.";
            default = "";
          };
        };
        # config = mkIf cfg.enable {
        #     programs.nixvim.extraPackages = server.packages;
        # };
      });
      description = "Module for the ${name} (${package}) lsp server for nvim-lsp";
      default = null;
    };

   moduleList = forEach servers (server: { "name" = server.name; "value" = toLspModule server; });

in listToAttrs moduleList
