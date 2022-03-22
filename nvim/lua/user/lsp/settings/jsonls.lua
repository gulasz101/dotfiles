local schemas = {
    {
        description = "Composer configuration file",
        fileMatch = {"composer.json"},
        url = "https://raw.githubusercontent.com/composer/composer/master/res/composer-schema.json"
    }, {description = "NPM configuration file", fileMatch = {"package.json"}, url = "https://json.schemastore.org/package.json"}
}

local opts = {
    settings = {json = {schemas = schemas}},
    setup = {
        commands = {
            Format = {
                function()
                    vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line "$", 0})
                end
            }
        },
        capabilities = { completion = { completionItem = { snippetSupport = true}}},
    }
}

return opts
