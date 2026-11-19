if [ -f ~/.bash_profile.extra ]; then
  source ~/.bash_profile.extra
fi

if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && command -v dbus-run-session > /dev/null && command -v sway > /dev/null; then
  export XDG_SESSION_TYPE=wayland
  export XDG_SESSION_DESKTOP=sway
  export XDG_CURRENT_DESKTOP=sway
  export GTK_THEME="Adwaita:dark"
  exec dbus-run-session sway
fi

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
