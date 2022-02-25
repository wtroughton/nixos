{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.shell.neovim;

in {
  options.modules.shell.neovim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    # TODO: Configure option to modify ZSH alias
    vimAlias = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Symlink <command>vim</command> to <command>nvim</command> binary.
      '';
    };

    lineNumbers = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.neovim ];

    xdg.configFile."nvim/init.lua".text = ''
      local map = require("utils").map

      map("n", ",<Space>", ":nohlsearch<CR>", { silent = true })
      map("n", "<Leader>", ":<C-u>WhichKey ','<CR>", { silent = true })
      map("n", "<Leader>?", ":WhichKey ','<CR>")
      map("n", "<Leader>a", ":cclose<CR>")

      vim.api.nvim_command('set number')
    '';

    xdg.configFile."nvim/lua/utils.lua".text = ''
      -- Assign an empty table to the local variable named M (it's standard to name the variable as "M")
      local M = {}
      
      -- Define your function & add it the M table
      function M.map(mode, lhs, rhs, opts)
        local options = { noremap = true }
        if opts then
          options = vim.tbl_extend("force", options, opts)
        end
        vim.api.nvim_set_keymap(mode, lhs, rhs, options)
      end
      
      -- Since the M table is scoped, it has to be returned for usage elsewhere
      return M
    '';
  };
}
