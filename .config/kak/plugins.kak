# bootstrap the plugin manager
evaluate-commands %sh{
    plugins="${kak_config:?}/plugins"
    mkdir -p "$plugins"
    [ ! -e "$plugins/plug.kak" ] && \
        git clone -q https://github.com/andreyorst/plug.kak.git --branch master "$plugins/plug.kak"
    printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
}

set-option global plug_always_ensure true
set-option global plug_profile true

# Plugin configurations
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
plug-chain "andreyorst/plug.kak" noload \
plug "delapouite/kakoune-text-objects" \
plug "occivink/kakoune-vertical-selection" \
plug "occivink/kakoune-find" config %{
    define-command -docstring "grep-apply-changes: apply changes specified in current *grep* buffer to their respective files" \
    grep-apply-changes %{ find-apply-changes -force }
} plug "andreyorst/base16-gruvbox.kak" theme %{
    if %sh{ [ -n "${PATH##*termux*}" ] && echo true || echo false } %{
        colorscheme ayu-mirage
    } %{
        colorscheme ayu-mirage
    }
} plug "andreyorst/fzf.kak" config %{
    map -docstring 'fzf mode' global normal '<c-p>' ': fzf-mode<ret>'
} defer fzf %{
    set-option global fzf_preview_width '65%'
    when %sh{ [ -n "$(command -v bat)"  ] && echo true || echo false } %{
        set-option global fzf_highlight_command bat
    }
} defer fzf-project %{
    set-option global fzf_project_use_tilda true
} defer fzf-file %{
    declare-option str-list fzf_exclude_files "*.o" "*.bin" "*.obj" ".*cleanfiles"
    declare-option str-list fzf_exclude_dirs ".git" ".svn"
    set-option global fzf_file_command %sh{
        if [ -n "$(command -v fd)" ]; then
            eval "set -- ${kak_quoted_opt_fzf_exclude_files:-} ${kak_quoted_opt_fzf_exclude_dirs:-}"
            while [ $# -gt 0 ]; do
                exclude="$exclude --exclude '$1'"
                shift
            done
            cmd="fd . --no-ignore --type f --follow --hidden $exclude"
        else
            eval "set -- $kak_quoted_opt_fzf_exclude_files"
            while [ $# -gt 0 ]; do
                exclude="$exclude -name '$1' -o"
                shift
            done
            eval "set -- $kak_quoted_opt_fzf_exclude_dirs"
            while [ $# -gt 0 ]; do
                exclude="$exclude -path '*/$1' -o"
                shift
            done
            cmd="find . \( ${exclude% -o} \) -prune -o -type f -follow -print"
        fi
        echo "$cmd"
    }
} plug "andreyorst/powerline.kak" defer powerline %{
    set-option global powerline_ignore_warnings true
    set-option global powerline_format 'git bufname langmap smarttab mode_info filetype client session position'
    set-option global powerline_separator ''
} defer powerline_bufname %{
    set-option global powerline_shorten_bufname 'short'
} defer powerline_solarized-dark-termcolors %{
    powerline-theme solarized-dark-termcolors
} config %{
    powerline-start
} plug "andreyorst/smarttab.kak" defer smarttab %{
    set-option global softtabstop 4
    set-option global smarttab_expandtab_mode_name   '⋅a⋅'
    set-option global smarttab_noexpandtab_mode_name '→a→'
    set-option global smarttab_smarttab_mode_name    '→a⋅'
} config %{
    hook global WinSetOption filetype=(rust|markdown|kak|lisp|scheme|sh|perl) expandtab
    hook global WinSetOption filetype=(makefile|gas) noexpandtab
    hook global WinSetOption filetype=(c|cpp) smarttab
} plug "andreyorst/langmap.kak" config %{
    set-option global langmap %opt{langmap_ru_jcuken}
} demand langmap %{
    map -docstring "toggle layout" global normal '<c-\>' ':      toggle-langmap<ret>'
    map -docstring "toggle layout" global insert '<c-\>' '<a-;>: toggle-langmap<ret>'
    map -docstring "toggle layout" global prompt '<c-\>' '<a-;>: toggle-langmap prompt<ret>'
} plug "andreyorst/kaktree" defer kaktree %{
    map global user 'f' ": kaktree-toggle<ret>" -docstring "toggle filetree panel"
    set-option global kaktree_show_help false
    if %sh{ [ -n "${PATH##*termux*}" ] && echo true || echo false } %{
        set-option global kaktree_double_click_duration '0.5'
        set-option global kaktree_indentation 1
        set-option global kaktree_dir_icon_open  '▾ 🗁 '
        set-option global kaktree_dir_icon_close '▸ 🗀 '
        set-option global kaktree_file_icon      '⠀⠀🖺'
    } %{
        set-option global kaktree_split vertical
        set-option global kaktree_size 30%
    }
} config %{
    hook global WinSetOption filetype=kaktree %{
        remove-highlighter buffer/numbers
        remove-highlighter buffer/matching
        remove-highlighter buffer/wrap
        remove-highlighter buffer/show-whitespaces
    }
    kaktree-enable
} plug "andreyorst/pmanage.kak" \
plug "Screwtapello/kakoune-shellcheck" domain gitlab.com
plug "kak-lsp/kak-lsp" do %{
        cargo build --release --locked
            cargo install --force --path .
} config %{

    eval %sh{echo ${kak_opt_lsp_cmd} >> /tmp/kak-lsp.log}
    set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"

    #is not necessary; the `lsp-enable-window` will take care of it
    #eval %sh{${kak_opt_lsp_cmd} --kakoune -s $kak_session}

    set global lsp_diagnostic_line_error_sign '║'
    set global lsp_diagnostic_line_warning_sign '┊'
    define-command ne -docstring 'go to next error/warning from lsp' %{ lsp-find-error --include-warnings }
    define-command pe -docstring 'go to previous error/warning from lsp' %{ lsp-find-error --previous --include-warnings }
    define-command ee -docstring 'go to current error/warning from lsp' %{ lsp-find-error --include-warnings; lsp-find-error --previous --include-warnings }

    define-command lsp-restart -docstring 'restart lsp server' %{ lsp-stop; lsp-start }
    hook global WinSetOption filetype=(c|cpp|cc|rust|javascript|typescript) %{
        set-option window lsp_auto_highlight_references true
        set-option window lsp_hover_anchor false lsp-auto-hover-enable
        echo -debug "Enabling LSP for filtetype %opt{filetype}"
        lsp-enable-window
}
    hook global WinSetOption filetype=(rust) %{
        set window lsp_server_configuration rust.clippy_preference="on"
    }
    hook global WinSetOption filetype=rust %{
        hook window BufWritePre .* %{
            evaluate-commands %sh{
                test -f rustfmt.toml && printf lsp-formatting-sync
            }
        }
    }
    hook global KakEnd .* lsp-exit
}
