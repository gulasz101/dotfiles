local default_schemas = nil
local status_ok, jsonls_settings = pcall(require, "nlspsettings.jsonls")
if not status_ok then
    print("!! jsonls is down !!")
    return
end
if status_ok then default_schemas = jsonls_settings.get_default_schemas() end
local schemas = {
    {
        description = "Composer configuration file",
        fileMatch = {"composer.json"},
        url = "https://raw.githubusercontent.com/composer/composer/master/res/composer-schema.json"
    }, {description = "NPM configuration file", fileMatch = {"package.json"}, url = "https://json.schemastore.org/package.json"}
}

local function extend(tab1, tab2)
    for _, value in ipairs(tab2) do table.insert(tab1, value) end
    return tab1
end

local extended_schemas = extend(schemas, default_schemas)

local opts = {
    settings = {json = {schemas = extended_schemas}},
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
