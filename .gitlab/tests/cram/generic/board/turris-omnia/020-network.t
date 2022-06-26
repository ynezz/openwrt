Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Check correct routing table:

  $ R ip route
  default via 10.0.0.1 dev eth2  src 10.0.0.2 
  10.0.0.0/24 dev eth2 scope link  src 10.0.0.2 
  192.168.1.0/24 dev br-lan scope link  src 192.168.1.1 
