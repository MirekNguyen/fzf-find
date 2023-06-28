function _fzf_find
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
  set -l color $(string join '' \
    "fg:#f8f8f2,bg:#282a36,hl:#bd93f9,"\
    "fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9,"\
    "info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6,"\
    "marker:#ff79c6,spinner:#ffb86c,header:#6272a4")
  set -l fzf "$(\
    fd -I --base-directory="$fzf_base_dir" --ignore-file="$fzf_find_ignore" --strip-cwd-prefix -H -t f -t d \
    | fzf -e --preview="$fzf_find_preview" --cycle --preview-window="$fzf_find_preview" --height 30% --border rounded --color="$color" \
  )";
  if [ "$fzf" = "" ]
    commandline --function repaint;
    return 0;
  end
  if [ $swap_path = 'false' ]
    set fzf "$fzf_base_dir/$fzf";
  else
    set fzf "$argv[2]/$fzf";
  end
  if [ -f "$fzf" ];
    cd "$(dirname "$fzf")";
    switch $argv[(count $argv)]
      case '--mime'
        echo "Mime flag is triggered";
    end
    set extension (string match -r '\.([^.]+)$' "$fzf" --groups);
    switch "$extension"
      case mkv mp4
        nohup mpv --player-operation-mode=pseudo-gui "$fzf" >/dev/null 2>&1 &;
        disown;
      case pdf
        nohup zathura -- "$fzf" >/dev/null 2>&1 &;
        disown;
      case odt ods odp sxw doc docx xls xlsx ppt pptx
        nohup libreoffice "$fzf" >/dev/null 2>&1 &;
        disown;
      case '*'
        "$EDITOR" "$fzf";
    end
    commandline --function repaint;
    return 0;
  end
  if [ -d "$fzf" ];
    cd "$fzf";
    commandline --function repaint;
    return 0;
  end
  echo "Path is not a file or a directory";
  commandline --function repaint;
  return 1;
end
