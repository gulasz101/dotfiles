local system = vim.fn.system
local fn = vim.fn

local lua_rocks_exists, _ = pcall(system, {"luarocks", "--version"})
local lua_format_exits, _ = pcall(system, {"lua-format", "-h"})

local opts = {filetypes = {}, init_options = {linters = {}, filetypes = {}, formatters = {}, formatFiletypes = {}}}

if lua_rocks_exists and lua_format_exits then
    opts.filetypes = {"lua"}
    opts.init_options.formatters.luaformat = {
        command = "lua-format",
        args = {"-i", "--no-keep-simple-function-one-line", "--no-break-after-operator", "--column-limit=150", "--break-after-table-lb"}
    }
    opts.init_options.formatFiletypes.lua = "luaformat"
end

local php_install_path = fn.stdpath "data" .. "/php"
local phpcspath = php_install_path .. "/PHP_CodeSniffer"
local phpstanpath = php_install_path .. "/phpstan"
local ecspath = php_install_path .. "/ecs"

local bin_phpcspath = phpcspath .. "/bin/phpcs"
local bin_phpstanpath = phpstanpath .. "/phpstan"
local bin_ecspath = ecspath .. "/bin/ecs"

if fn.empty(fn.glob(php_install_path)) > 0 then
    system {"git", "clone", "--depth", "1", "https://github.com/squizlabs/PHP_CodeSniffer.git", phpcspath}
    system {"git", "clone", "--depth", "1", "https://github.com/phpstan/phpstan.git", phpstanpath}
    system {"git", "clone", "--depth", "1", "https://github.com/symplify/easy-coding-standard.git", ecspath}
    -- fn.system { "cd", phpcspath, "&&", "composer", "install" }
end

local ecs_exists, _ = pcall(system, {bin_ecspath, "--help"})
if ecs_exists then
    opts.init_options.formatters.ecs = {
        command = "zsh",
        args = {
            "-c",
            "() { tmpfile=$(mktemp /tmp/ecs.XXXXXX) && cat <&0 >> $tmpfile && " .. bin_ecspath
                .. " check --fix -c ~/.config/nvim/ecs.php -q $tmpfile && cat $tmpfile && rm $tmpfile }"
        },
        rootPatterns = {"composer.json", "composer.lock", "vendor", ".git"}
        -- requiredFiles = {"./vendor/bin/ecs", "ecs.php"}
    }
    opts.init_options.formatFiletypes.php = "ecs"
end

local phpstan_exists, _ = pcall(system, {bin_phpstanpath, "--help"})
opts.init_options.filetypes.php = {}

if phpstan_exists then
    opts.init_options.linters.phpstan = {
        sourceName = "phpstan",
        command = bin_phpstanpath,
        args = {"analyze", "--level", "max", "--error-format", "raw", "--no-progress", "%file"},
        rootPatterns = {"composer.json", "composer.lock", "vendor", ".git"},
        debounce = 100,
        offsetLine = 0,
        offsetColumn = 0,
        formatLines = 1,
        formatPattern = {"^[^:]+:(\\d+):(.*)(\\r|\\n)*$", {line = 1, message = 2}}
        -- requiredFiles = {"./vendor/bin/phpstan"}
    }
    table.insert(opts.init_options.filetypes.php, "phpstan")
end

local phpcs_exists, _ = pcall(system, {bin_phpcspath, "--help"})
if phpcs_exists then
    opts.init_options.linters.phpcs = {
        sourceName = "phpcs",
        command = bin_phpcspath,
        args = {"--standard=PSR12", "--report=emacs", "-s", "-"},
        rootPatterns = {"composer.json", "composer.lock", "vendor", ".git"},
        offsetLine = 0,
        formatLines = 1,
        formatPattern = {"^.*:(\\d+):(\\d+):\\s+(.*)\\s+-\\s+(.*)(\\r|\\n)*$", {line = 1, column = 2, message = 4, security = 3}},
        securieties = {error = "error", warning = "warning"}
        -- requiredFiles = {"./vendor/bin/phpcs"}
    }
    table.insert(opts.init_options.filetypes.php, "phpcs")
end

if ecs_exists or phpcs_exists or phpstan_exists then table.insert(opts.filetypes, "php") end

return opts
