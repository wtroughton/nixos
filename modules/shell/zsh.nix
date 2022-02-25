{ config, lib, pkgs, ... }:

with lib;

let 
  cfg = config.modules.shell.zsh;
  aliasesStr = concatStringsSep "\n" (
    mapAttrsToList (k: v: "alias ${k}=${lib.escapeShellArg v}") cfg.shellAliases
  );

in {
  options.modules.shell.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    loginShellInit = mkOption {
      default = "";
      description = ''
        Shell script code called during zsh login shell initialization.
      '';
      type = types.lines;
    };

    shellAliases = mkOption {
      default = {};
      description = ''
        An attribute set mapping aliases to command strings.
      '';
      example = literalExpression ''
        {
          ll = "ls -l";
          ".." = "cd ..";
        }
      '';
      type = types.attrsOf types.str;
    };
  };

  config = mkIf cfg.enable {
    home.file.".zlogin".text = ''
      ${cfg.loginShellInit}
    '';
    
    home.file.".zshrc".text = ''
      ${aliasesStr}
    '';
  };
}
