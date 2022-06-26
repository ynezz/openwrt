Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Check for correct SSID setup:

  $ R "iwinfo | grep ESSID"
  wlan0     ESSID: unknown
  wlan1     ESSID: unknown
