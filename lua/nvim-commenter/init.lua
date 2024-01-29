local M = {}

M.setup = function(opts)
  local augroup = vim.api.nvim_create_augroup("CommenterGroup", { clear = true })
  local map = {
    single = {
      { type = "lua", str = "--" }
    },
    double = {
      { type = "html", strs = { "<!--", "-->" } }
    }
  }

  if #opts.mappings.single > 0 then
    for _, mapping in ipairs(opts.mappings.single) do
      table.insert(map.single, mapping)
    end
  end

  local command = opts.command or {
    comment = "gcc",
    uncomment = "guc"
  }

  for _, pair in ipairs(map.single) do
    local pattern = "*." .. pair.type
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = pattern,
      group = augroup,
      callback = function()
        vim.keymap.set("n", command.comment, "^i" .. pair.str .. "<Esc>", { desc = "Commenter: comment line" })
        vim.keymap.set("n", command.uncomment, "^" .. #pair.str .. "x", { desc = "Commenter: uncomment line" })
      end
    })
    vim.api.nvim_create_autocmd("BufLeave", {
      pattern = pattern,
      group = augroup,
      callback = function()
        vim.keymap.del("n", command.comment)
        vim.keymap.del("n", command.uncomment)
      end
    })
  end

  for _, pair in ipairs(map.double) do
    local pattern = "*." .. pair.type
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = pattern,
      group = augroup,
      callback = function()
        vim.keymap.set("n", command.comment, "^i" .. pair.strs[1] .. "<Esc>A" .. pair.strs[2] .. "<Esc>",
          { desc = "Commenter: comment line" })
        vim.keymap.set("n", command.uncomment, "^" .. #pair.strs[1] .. "x$" .. #pair.strs[2] - 1 .. "hd$",
          { desc = "Commenter: uncomment line" })
      end
    })
    vim.api.nvim_create_autocmd("BufLeave", {
      pattern = pattern,
      group = augroup,
      callback = function()
        vim.keymap.del("n", command.comment)
        vim.keymap.del("n", command.uncomment)
      end
    })
  end
end

return M
