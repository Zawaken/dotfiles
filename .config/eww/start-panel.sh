#!/usr/bin/env bash

# A workaround because eww is yuck and doesn't allow starting windows on dynamically defined monitors.

CONFIG_DIR="${HOME}/.config/eww"
PRIMARY_BAR_WIDGET="bar"
ALT_BAR_WIDGET="alt-bar"

get_yuck() {
  monitor="${1:?}"
  widget="${2:?}"

	cat <<-EOF > /dev/stdout
	(defwindow bar-${monitor}
	  :monitor ${monitor}
	  :class "bar"
	  :windowtype "dock"
	  :stacking "bg"
	  :wm-ignore false
	  :hexpand false
	  :vexpand false
	  :geometry (geometry :x "0%"
	                      :y "0%"
	                      :width "99%"
	                      :height "11px" ; Has to be odd for pixel-perfect vertical centering
	                      :anchor "top center")
	  :reserve (struts :side "top"
	                   :distance "36px")
	  (${widget}))
	EOF
}

eww kill

rm -f "${CONFIG_DIR}/bars.yuck"

while read -r monitor; do
  _id="$(printf '%s' "${monitor}" | awk -F ':' '/1/ {print $1}')"
  #_id_alpha="$(printf '%s' "${_id}" | tr '[0-9]' '[a-j]')"
  if [[ "$(printf '%s' "${monitor}" | awk '{print $2}')" == *"*"* ]]; then
    _widget="${PRIMARY_BAR_WIDGET}"
  else
    _widget="${ALT_BAR_WIDGET}"
  fi
  printf '%s\n\n' "$(get_yuck "${_id}" "${_widget}")" | tee -a "${CONFIG_DIR}/bars.yuck"

  eww open "bar-${_id}"
done < <(xrandr --listmonitors | tail -n+2)
