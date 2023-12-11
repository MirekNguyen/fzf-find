function _fzf_find_search
  set -l fzf_base_dir "$(pwd)"
  set -l swap_path false
  if [ (count $argv) -eq 1 ]
    if [ ! -e "$argv[1]" ]
      echo "Provided path doesn't exist"
      return 1;
    end
    set fzf_base_dir "$argv[1]"
  else if [ (count $argv) -eq 2 ]
    if [ ! -e "$argv[1]" ] || [ ! -e "$argv[2]" ]
      echo "Provided path doesn't exist"
      return 1;
    end
    set fzf_base_dir "$argv[1]"
    set swap_path true
  end
  set -l number $(echo $(echo "$fzf_base_dir" | awk -F'/' '{print NF}') + 1 | bc);
  set -l fzf \
    $(rg -x '^.*.{4,}' -n --ignore-file "$fzf_find_search_ignore" -H . "$fzf_base_dir" \
    | fzf -e --delimiter / --with-nth $number.. --preview="$fzf_find_search_preview" \
      --cycle --preview-window="$fzf_find_search_preview_window" --height 30% --border rounded);
  if [ "$fzf" = "" ]
    commandline --function repaint;
    return 0;
  end
  set -l file_path $(echo "$fzf" | cut -d':' -f1,1);
  set -l line $(echo "$fzf" | cut -d':' -f2,2);
  if test [[ which nvim ]]
    if [ $swap_path = 'true' ]
      set file_path "$(string replace $argv[1] $argv[2] $file_path)"
    end
    cd "$(dirname "$file_path")";
    nvim +"$line" "$file_path" -c 'normal zt';
  else
    "$EDITOR" "$file_path";
  end
  commandline --function repaint;
  return 0;
end
