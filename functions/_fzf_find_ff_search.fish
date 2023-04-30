function _fzf_find_ff_search
  set -l search_path ""
  if [ (count $argv) -eq 0 ]
    set search_path $(pwd);
  else if [ (count $argv) -eq 1 ]
    set search_path $argv[1];
  else
    echo "Too many arguments";
    return
  end

  set -l color $(string join '' \
    "fg:#f8f8f2,bg:#282a36,hl:#bd93f9,"\
    "fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9,"\
    "info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6,"\
    "marker:#ff79c6,spinner:#ffb86c,header:#6272a4")
  set -l number $(echo $(echo "$search_path" | awk -F'/' '{print NF}') + 1 | bc);
  set -l fzf \
    $(rg -n --ignore-file "$ff_search_ignore" -H . "$search_path" \
    | fzf -e --delimiter / --with-nth $number.. --preview="$ff_search_preview" \
      --cycle --preview-window="$ff_search_preview_window" --height 30% --border rounded --color="$color");
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
