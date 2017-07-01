#!/bin/bash

# Get the QR code containing the device's UUID
curl -s \
--data-urlencode data="${RESIN_DEVICE_UUID}" \
--data-urlencode format=png \
--data-urlencode size="${MIN_RES}x${MIN_RES}" \
--data-urlencode margin=5 \
"${API_URL}" -o /data/qr.png

((side_s=MAX_RES - MIN_RES))
icn_s="${side_s}x${side_s}"
scr_txt=""

if [[ -z "${!ID_NAME}" ]]; then
  icn_n='wait.png'
  bg_cl='OrangeRed2'
else
  icn_n='check.png'
  bg_cl='green'

  if [[ `expr length ${!ID_NAME}` -gt 3 ]]; then
    # add show more button
    echo too much!
  else
    # show it in one screen
    scr_txt="\
    -gravity SouthEast \
    -weight 20 \
    -pointsize 40 \
    -annotate 0 "${!ID_NAME}" \
    "
  fi
fi

convert -size 320x240 xc:${bg_cl} \
  /data/qr.png -composite \
  img/${icn_n} -geometry ${icn_s}+${MIN_RES}+0 -composite \
  ${scr_txt} \
  render.png

# Display the QR code
fbi -d /dev/fb1 -T 1 --noverbose render.png
