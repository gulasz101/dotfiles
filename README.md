### install Volta
```
curl https://get.volta.sh | bash
```

### install Node
```
volta install node
```
## PHP
put license into file
```sh
echo LICENSE >> $HOME/intelephense/licence.txt
```
install server
```
volta install intelephense
```
## JSON
### json lsp (supports json, css, html)
```
volta install vscode-langservers-extracted
```
## LUA
### sumneko lua lsp
#### for not not really working
get latest build from here (fetch artifacts for latest build):
https://github.com/sumneko/lua-language-server/actions/workflows/build.yml
put build into your `$HOME/.bin`
add `$HOME/.bin` to your `$PATH`
and make $HOME/.bin/lua-language-server executable
```sh
cmod +x $HOME/.bin/lua-language-server
```
### efm-language-server for LUA formatting
```sh
brew install luarocks
luarocks install --server=https://luarocks.org/dev luaformatter
brew install efm-langserver
```

