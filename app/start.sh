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
    # add show more indication
    echo Variable contents too large to preview.
    scr_txt="\
    -gravity SouthEast
    img/more.png -geometry ${icn_s}+0+0 -composite \
    "
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

convert -size ${MAX_RES}x${MIN_RES} xc:${bg_cl} \
  /data/qr.png -composite \
  -gravity NorthEast \
  img/${icn_n} -geometry ${icn_s}+0+0 -composite \
  ${scr_txt} \
  main.png

# Display the QR code
fbi -d /dev/fb1 -T 1 --noverbose main.png
