alias gem="docker-compose run --rm jekyll gem"
alias bundle="docker-compose run --rm jekyll bundle"
alias jekyll="docker-compose run --rm jekyll jekyll"

clean_shell() {
  unalias gem
  unalias bundle
  unalias jekyll

  unset -f clean_shell
}
