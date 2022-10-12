function _fzf_find_notes
  set -l path "/Users/mireknguyen/Library/Mobile Documents/com~apple~CloudDocs/Notes";
  if ! [ -d "$path" ]
    commandline --function repaint;
    return 1;
  end
  set -l color $(string join '' \
    "bg:#4B4B4B,bg+:#3F3F3F,"\
    "fg:#D9D9D9,fg+:#D9D9D9,"\
    "hl:#719872,hl+:#98BC99,"\
    "info:#BDBB72,border:#6B6B6B,"\
    "spinner:#98BC99,header:#719872,"\
    "pointer:#E12672,marker:#E17899,"\
    "prompt:#98BEDE")
  set -l preview \
    "tail -n +(echo {} | cut -d':' -f2) < (echo {} | cut -d':' -f1)"
  set -l number $(echo $(echo "$path" | awk -F'/' '{print NF}') + 1 | bc);
  set -l fzf \
    $(rg -n -H . $path \
    | fzf -e --delimiter / --with-nth $number.. --preview="$preview" \
      --cycle --preview-window=right,40% --height 30% --border rounded --color="$color");
  if [ "$fzf" = "" ]
    commandline --function repaint;
    return 0;
  end

  set -l file_path $(echo "$fzf" | cut -d':' -f1,1);
  set -l line $(echo "$fzf" | cut -d':' -f2,2);
  if test [[ which nvim ]]
    cd "$(dirname "$fzf")";
    nvim +"$line" "$file_path";
  else
    "$EDITOR" "$file_path";
  end
  commandline --function repaint;
  return 0;
end
