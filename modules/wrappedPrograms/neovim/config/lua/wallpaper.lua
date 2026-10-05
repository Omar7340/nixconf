(function()
-- Other hosts retain Oxocarbon; Niri follows the desktop's data-only palette.
if vim.env.XDG_CURRENT_DESKTOP ~= "niri" then return end
local path = vim.fn.expand("~/.local/state/niri-desktop/theme/greeter.json")
local previous
local function apply()
  local file = io.open(path, "r")
  if not file then return end
  local content = file:read("*a")
  file:close()
  if content == previous then return end
  local ok, p = pcall(vim.json.decode, content)
  if not ok or type(p) ~= "table" then return end
  for _, key in ipairs({ "surface", "text", "primary", "onPrimary", "container", "outline", "error", "base", "muted", "secondary", "tertiary" }) do
    if type(p[key]) ~= "string" or not p[key]:match("^#%x%x%x%x%x%x$") then return end
  end
  previous = content
  local groups = {
    Normal = { fg = p.text, bg = p.surface }, NormalNC = { fg = p.text, bg = p.surface },
    NormalFloat = { fg = p.text, bg = p.container }, FloatBorder = { fg = p.primary, bg = p.container },
    SignColumn = { bg = p.surface }, LineNr = { fg = p.outline, bg = p.surface },
    CursorLine = { bg = p.container }, CursorLineNr = { fg = p.primary, bold = true },
    Visual = { bg = p.outline }, Search = { fg = p.onPrimary, bg = p.primary },
    IncSearch = { fg = p.onPrimary, bg = p.primary, bold = true },
    Pmenu = { fg = p.text, bg = p.container }, PmenuSel = { fg = p.onPrimary, bg = p.primary },
    StatusLine = { fg = p.text, bg = p.container }, StatusLineNC = { fg = p.muted, bg = p.base },
    WinSeparator = { fg = p.outline }, Folded = { fg = p.muted, bg = p.container },
    Comment = { fg = p.muted, italic = true }, String = { fg = p.secondary },
    Function = { fg = p.primary }, Keyword = { fg = p.tertiary, bold = true },
    Statement = { fg = p.tertiary }, Type = { fg = p.secondary }, Identifier = { fg = p.text },
    Constant = { fg = p.tertiary }, Number = { fg = p.tertiary }, Special = { fg = p.primary },
    DiagnosticError = { fg = p.error }, DiagnosticWarn = { fg = "#e5c07b" },
    DiagnosticInfo = { fg = p.secondary }, DiagnosticHint = { fg = p.primary },
    TelescopeNormal = { fg = p.text, bg = p.container }, TelescopeBorder = { fg = p.primary },
    TelescopeSelection = { fg = p.onPrimary, bg = p.primary },
  }
  for name, attrs in pairs(groups) do vim.api.nvim_set_hl(0, name, attrs) end
  for capture, group in pairs({ ["@comment"] = "Comment", ["@string"] = "String", ["@function"] = "Function", ["@function.call"] = "Function", ["@keyword"] = "Keyword", ["@type"] = "Type", ["@variable"] = "Identifier", ["@constant"] = "Constant", ["@number"] = "Number" }) do
    vim.api.nvim_set_hl(0, capture, { link = group })
  end
  vim.g.colors_name = "niri-wallpaper"
  vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "niri-wallpaper", modeline = false })
end
apply()
vim.api.nvim_create_user_command("WallpaperTheme", apply, { desc = "Reload the desktop wallpaper palette" })
vim.api.nvim_create_autocmd("FocusGained", { callback = apply })
-- Polling handles atomic file replacement, including while Neovim stays focused.
local watcher = vim.uv.new_fs_poll()
if watcher then
  watcher:start(path, 2000, vim.schedule_wrap(function(err) if not err then apply() end end))
  vim.api.nvim_create_autocmd("VimLeavePre", { once = true, callback = function()
    watcher:stop()
    watcher:close()
  end })
end
end)()
