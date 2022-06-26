Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Check that we've correct system info:

  $ R "ubus call system board | jsonfilter -e @.model -e @.board_name"
  GL.iNet GL-B1300
  glinet,gl-b1300
