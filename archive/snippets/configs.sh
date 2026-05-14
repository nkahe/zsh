
# vimwiki: Personal Wiki for Vim. https://github.com/vimwiki/vimwiki
# ( <Leader>ww is keymap for VimWiki in Vim)

if has nvim; then
  WikiEditor="nvim"
elif has vim; then
  WikiEditor="vim"
fi

# Add 'wincmd w' if want to focus file.
ww() { $WikiEditor -c ":execute 'cd ~/Documents/notes|NERDTreeToggle|wincmd w|VimwikiIndex'"; }

