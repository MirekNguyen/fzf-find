# fzf_find
set -gx fish_fzf_find_scope "$HOME"
set -gx fish_fzf_find_ignore_file "$HOME/.dotfiles/.fdignore"
set -gx fish_fzf_find_preview ""

# fzf_find_notes
set -gx fish_fzf_find_notes_scope "$HOME/notes/"
set -gx fish_fzf_find_notes_preview "tail -n +(echo {} | cut -d':' -f2) < (echo {} | cut -d':' -f1)"
set -gx fish_fzf_find_notes_preview_window "right,40%"

# fzf_find_notes 'bat' command (with highlight and colors)

# set -gx fish_fzf_find_notes_preview \
# "bat --theme=gruvbox-dark \
# --style=plain --color=always \
# --line-range=(echo {} | cut -d':' -f2): \
# --highlight-line=(echo {} | cut -d':' -f2) \
# (echo {} | cut -d':' -f1)"
