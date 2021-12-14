local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = {noremap = true, silent = true}

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspacefolder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
-- local servers = { 
-- 'clangd', 
-- 'rust_analyzer', 
-- 'pyright', 
-- 'tsserver'
--	'intelephense',
--    'jsonls'
-- }

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

----------------------------------
-- PHP - intelehense -------------
----------------------------------
nvim_lsp.intelephense.setup {on_attach = on_attach, capabilities = capabilities}

----------------------------------
-- JSON - jsonls -----------------
----------------------------------
local jsonls_capabilities = capabilities
jsonls_capabilities.textDocument.completion.completionItem.snippetSupport = true
nvim_lsp.jsonls.setup {
    on_attach = on_attach,
    capabilities = jsonls_capabilities,
    commands = {
        Format = {
            function()
                vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"), 0})
            end
        }
    }
}

----------------------------------
-- diagnosticls ------------------
----------------------------------
-- PHP - phpstan - formatting ----
----------------------------------
-- LUA - formatting --------------
----------------------------------
vim.lsp.set_log_level("debug")
nvim_lsp.diagnosticls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = {"php", "lua"},
    init_options = {
        trace = {server = verbose},
        linters = {
            phpstan = {
                sourceName = "phpstan",
                command = "./vendor/bin/phpstan",
                args = {"analyze", "--level", "max", "--error-format", "raw", "--no-progress", "%file"},
                rootPatterns = {"composer.json", "composer.lock", "vendor", ".git"},
                debounce = 100,
                offsetLine = 0,
                offsetColumn = 0,
                formatLines = 1,
                formatPattern = {"^[^:]+:(\\d+):(.*)(\\r|\\n)*$", {line = 1, message = 2}},
                requiredFiles = {"./vendor/bin/phpstan"}
            },
            phpcs = {
                sourceName = "phpcs",
                command = "./vendor/bin/phpcs",
                args = {"--standard=PSR12", "--report=emacs", "-s", "-"},
                rootPatterns = {"composer.json", "composer.lock", "vendor", ".git"},
                offsetLine = 0,
                offsetLine = 0,
                formatLines = 1,
                formatPattern = {"^.*:(\\d+):(\\d+):\\s+(.*)\\s+-\\s+(.*)(\\r|\\n)*$", {line = 1, column = 2, message = 4, security = 3}},
                securieties = {error = "error", warning = "warning"},
                requiredFiles = {"./vendor/bin/phpcs"}
            }
        },
        filetypes = {php = {"phpstan", "phpcs"}},
        formatters = {
            luaformat = {
                command = "lua-format",
                args = {"-i", "--no-keep-simple-function-one-line", "--no-break-after-operator", "--column-limit=150", "--break-after-table-lb"}
            },
            ecs = {
                command = "zsh",
                args = {
                    "-c",
                    "() { tmpfile=$(mktemp /tmp/ecs.XXXXXX) && cat <&0 >> $tmpfile && ./vendor/bin/ecs check --fix -q $tmpfile && cat $tmpfile && rm $tmpfile }"
                },
                rootPatterns = {"composer.json", "composer.lock", "vendor", ".git"},
                requiredFiles = {"./vendor/bin/ecs", "ecs.php"}
            },
            phpcsf = {
                command = 'zsh',
                args = {
                    "-c",
                    "() { tmpfile=$(mktemp /tmp/phpcsf.XXXXXX) && cat <&0 >> $tmpfile && ./vendor/bin/php-cs-fixer fix --rules=@PSR12 -q $tmpfile && cat $tmpfile && rm $tmpfile }"
                },
                rootPatterns = {"composer.json", "composer.lock", "vendor", ".git"},
                requiredFiles = {"./vendor/bin/php-cs-fixer"}
            }
        },
        formatFiletypes = {lua = "luaformat", php = "ecs"}
    }
}

