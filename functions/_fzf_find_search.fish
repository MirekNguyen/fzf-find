function _fzf_find_search
  if ! [ -d "$fzf_find_search_scope" ]
    commandline --function repaint;
    return 1;
  end
  set -l color $(string join '' \
    "fg:#f8f8f2,bg:#282a36,hl:#bd93f9,"\
    "fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9,"\
    "info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6,"\
    "marker:#ff79c6,spinner:#ffb86c,header:#6272a4")
  set -l number $(echo $(echo "$fzf_find_search_scope" | awk -F'/' '{print NF}') + 1 | bc);
  set -l fzf \
    $(rg -n -H . "$fzf_find_search_scope" \
    | fzf -e --delimiter / --with-nth $number.. --preview="$fzf_find_search_preview" \
      --cycle --preview-window="$fzf_find_search_preview_window" --height 30% --border rounded --color="$color");
  if [ "$fzf" = "" ]
    commandline --function repaint;
    return 0;
  end

  set -l file_path $(echo "$fzf" | cut -d':' -f1,1);
  set -l line $(echo "$fzf" | cut -d':' -f2,2);
  if test [[ which nvim ]]
    cd "$(dirname "$file_path")";
    nvim +"$line" "$file_path" -c 'normal zt';
  else
    "$EDITOR" "$file_path";
  end
  commandline --function repaint;
  return 0;
end
