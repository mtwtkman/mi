local fzf_to_qf = require("quickfix.processor").fzf_to_qf
local parser = require("quickfix.parser")

local M = {}

function M.symbols()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local client = clients[1]

  if not client then
    vim.notify("No LSP client attached", vim.log.levels.WARN)
    return
  end
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)

  vim.lsp.buf_request(0, "textDocument/documentSymbol", params, function(err, result, ctx, config)
    if err then
      vim.notify("LSP Error: " .. tostring(err), vim.log.levels.ERROR)
      return
    end

    if not result or type(result) ~= "table" or vim.tbl_isempty(result) then
      vim.notify("No symbols found", vim.log.level.WARN)
      return
    end

    local lines = {}

    local function flatten(syms, level)
      table.sort(syms, function(a, b)
        local a_line = a.range and a.range.start.line or (a.selectionRange and a.selectionRange.start.line or 0)
        local b_line = b.range and b.range.start.line or (b.selectionRange and b.selectionRange.start.line or 0)
        return a_line < b_line
      end)

      for _, s in ipairs(syms) do
        local indent = string.rep(" ", level)
        local kind = vim.lsp.protocol.SymbolKind[s.kind] or "Other"
        local range = s.range or s.selectionRange
        local lnum = range.start.line + 1
        local col = range.start.character + 1

        table.insert(lines, string.format("%s%s [%s]||%d||%d", indent, s.name, kind, lnum, col))

        if s.children then
          flatten(s.children, level + 1)
        end
      end
    end

    flatten(result, 0)

    fzf_to_qf(
      "echo " .. vim.fn.shellescape(table.concat(lines, "\n")),
      "LSP Symbols",
      "--prompt='Symbols> ' --tiebreak=index",
      parser.lsp_symbol
    )
  end)
end

return M
