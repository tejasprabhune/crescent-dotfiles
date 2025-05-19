set fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/prabhune/miniforge3/bin/conda
    eval /Users/prabhune/miniforge3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/Users/prabhune/miniforge3/etc/fish/conf.d/conda.fish"
        . "/Users/prabhune/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/Users/prabhune/miniforge3/bin" $PATH
    end
end
# <<< conda initialize <<<

# pnpm
set -gx PNPM_HOME "/Users/prabhune/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/prabhune/Documents/google-cloud-sdk/path.fish.inc' ]; . '/Users/prabhune/Documents/google-cloud-sdk/path.fish.inc'; end
uv generate-shell-completion fish | source
uvx --generate-shell-completion fish | source

# typst SSG path
set -gx TYPST_HOME "/Users/prabhune/Documents/typst_ssg/typst/target/debug/"
if not string match -q -- $TYPST_HOME $PATH
  set -gx PATH "$TYPST_HOME" $PATH
end
# typst end


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/Users/prabhune/.opam/opam-init/init.fish' && source '/Users/prabhune/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration
