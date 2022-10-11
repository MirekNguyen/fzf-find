function fzf_find
  export FZF_DEFAULT_OPTS='--cycle --preview-window=right,40% --height 30% --border rounded --color='bg:#4B4B4B,bg+:#3F3F3F,info:#BDBB72,border:#6B6B6B,spinner:#98BC99,hl:#719872,fg:#D9D9D9,header:#719872,fg+:#D9D9D9,pointer:#E12672,marker:#E17899,prompt:#98BEDE,hl+:#98BC99'';
  set -l fzf "$(fd --base-directory="$HOME" --strip-cwd-prefix -H -t f -t d | fzf -e --preview="bat --style=plain --theme gruvbox-dark --color=always "$HOME"/{} 2>/dev/null || exa --icons --oneline -g "$HOME"/{} 2>/dev/null")";
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
