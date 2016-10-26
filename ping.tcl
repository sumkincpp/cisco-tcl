
# TODO: argv! / check on real device

foreach address $argv {
  ping $address
}

foreach address {
1.1.1.1
1.1.1.2
} { ping $address source vlan 100 }
