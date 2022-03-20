local status_ok, theme = pcall(require, "github-theme")
if not status_ok then 
    return 
end

theme.setup({
  theme_style = "light",
  -- other config
})

