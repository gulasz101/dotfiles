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
install diagnostic-languageserver for phpstan, phpcs, ecs support
```
volta install intelephense
volta install diagnostic-languageserver
```
## JSON
### json lsp (supports json, css, html)
```
volta install vscode-langservers-extracted
```
## LUA
### Formatting
```sh
volta install diagnostic-languageserver
```
