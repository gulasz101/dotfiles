local ls = require"luasnip"
local lsp = ls.parser.parse_snippet;

require("luasnip/loaders/from_vscode").load({ paths = { "~/.config/nvim/lua/my-snippets" } }) -- Load snippets from my-snippets folder

--ls.snippets = {
--   all = {
--   },
--    php = {
--     lsp(
--            "newclassfile",
--            "<?php\
--\
--declare(strict_types=1);\
--\
--namespace ${1:Yours\\App\\Namespace};\
--\
--class ${TM_FILENAME_BASE} ${2|implements,extends|} ${3:ClassOrInterface}\
--{\
--\
--}\
--"
--        ),
--    }
--}
