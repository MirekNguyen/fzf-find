function _fzf_find
  set -l color $(string join '' \
    "fg:#f8f8f2,bg:#282a36,hl:#bd93f9,"\
    "fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9,"\
    "info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6,"\
    "marker:#ff79c6,spinner:#ffb86c,header:#6272a4")
  set -l preview \
    "bat --style=plain --theme gruvbox-dark --color=always "$HOME"/{} 2>/dev/null \
    || exa --icons --oneline -g "$HOME"/{} 2>/dev/null"
  set -l fzf "$(\
    fd --base-directory="$HOME" --strip-cwd-prefix -H -t f -t d \
    | fzf -e --preview="$preview" --cycle --preview-window=right,40% --height 30% --border rounded --color="$color" \
  )";
  if [ "$fzf" = "" ]
    commandline --function repaint;
    return 0;
  end
  set -l fzf "$HOME/$fzf";
  if [ -f "$fzf" ];
    cd "$(dirname "$fzf")";
    "$EDITOR" "$fzf";
    commandline --function repaint;
    return 0;
  end
  if [ -d "$fzf" ];
    cd "$fzf";
    commandline --function repaint;
    return 0;
  end
  echo "$fzf";
  echo "Path is not a file or a directory";
  commandline --function repaint;
  return 1;
end
