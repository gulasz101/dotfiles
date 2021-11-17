--local vim = vim
--local api = vim.api
--local util = vim.lsp.util
--local callbacks = require 'vim.lsp.handlers'
--local log = vim.lsp.log
--
--local location_callback = function(_, method, result)
--  if result == nil or vim.tbl_isempty(result) then
--  local _ = log.info() and log.info(method, 'No location found')
--  return nil
--  end
--
--  api.nvim_command('tab split')
--
--  if vim.tbl_islist(result) then
--    util.jump_to_location(result)
--    if #result > 1 then
--      util.set_qflist(util.locations_to_items(result))
--      api.nvim_command("copen")
--      api.nvim_command("wincmd p")
--    end
--  else
--    util.jump_to_location(result)
--  end
--end

--callbacks['textDocument/declaration']    = location_callback
--callbacks['textDocument/definition']     = location_callback
--callbacks['textDocument/typeDefinition'] = location_callback
--callbacks['textDocument/implementation'] = location_callback

local function goto_definition(split_cmd)
  local util = vim.lsp.util
  local log = require("vim.lsp.log")
  local api = vim.api

  local handler = function(_, method, result)
    -- stolen from $VIMRUNTIME/lua/vim/lsp/callbacks.lua

    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info() and log.info(method, "No location found")
      return nil
    end

    if split_cmd then
      vim.cmd(split_cmd)
    end

    if vim.tbl_islist(result[1]) then
      util.jump_to_location(result)

      if #result > 1 then
        util.set_qflist(util.locations_to_items(result))
        api.nvim_command("copen")
        api.nvim_command("wincmd p")
      end
    else
      util.jump_to_location(result)
    end
  end

  return handler
end

vim.lsp.handlers["textDocument/definition"] = goto_definition('split')
