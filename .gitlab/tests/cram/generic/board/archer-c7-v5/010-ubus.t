Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Check that we've correct system info:

  $ R "ubus call system board | jsonfilter -e @.model -e @.board_name"
  TP-Link Archer C7 v5
  tplink,archer-c7-v5
