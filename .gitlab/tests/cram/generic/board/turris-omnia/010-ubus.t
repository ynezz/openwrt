Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Check that we've correct system info:

  $ R "ubus call system board | jsonfilter -e @.model -e @.board_name"
  Turris Omnia
  cznic,turris-omnia
