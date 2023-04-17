function _fzf_find_ff
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
  set -l fzf "$(\
    fd -I --base-directory="$search_path" --ignore-file="$fish_fzf_find_ff_ignore_file" --strip-cwd-prefix -H -t f -t d \
    | fzf -e --preview="$fish_fzf_find_preview" --cycle --preview-window="$fish_fzf_find_preview" --height 30% --border rounded --color="$color" \
  )";
  if [ "$fzf" = "" ]
    commandline --function repaint;
    return 0;
  end
  set -l fzf "$search_path/$fzf";
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
