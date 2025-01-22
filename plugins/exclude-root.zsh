# Plugins which are skipped for root user.

if [[ $UID == 0 ]]; then
  return
fi

zinit ice wait"1" lucid as"program" pick"todo"
zinit load todotxt/todo.txt-cli

# Tungsten - WolframAlpha CLI. https://github.com/ASzc/tungsten
zinit ice wait"2" lucid as"program" pick"tungsten.sh" atload"alias ask=tungsten.sh"
zinit load ASzc/tungsten

# A CLI tool that scrapes Google search results and SERPs that provides
# instant and concise answers. https://github.com/Bugswriter/tuxi
zinit ice wait"2" as"program" pick"tuxi" lucid
zinit load Bugswriter/tuxi

