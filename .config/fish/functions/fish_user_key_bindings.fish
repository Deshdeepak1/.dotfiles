function fish_user_key_bindings
    fzf_key_bindings
    fish_vi_key_bindings
    bind -M insert -m default jk backward-char force-repaint 
    bind -M insert \cb fzf_bcd_widget
end

