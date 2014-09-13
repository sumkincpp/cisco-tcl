# @tommy-vindvik
#
# Have made an improved version, please comment and/or improve further:
#
#    Trim domain name
#    Short interface name (Te/Gi/Fa)
#    Write config changes, and post a syslog message
#
# regexp in the event are for the uplink module on 3750-X/3560-X, adapt to your own need.

event manager applet auto-update-port-description authorization bypass

description "Auto-update port-description based on CDP neighbors info"

action 0.0 comment "Event line regexp: Deside which interface to auto-update description on"

event neighbor-discovery interface regexp .*GigabitEthernet[1-9]/1/[1-4]$ cdp add

action 1.0 comment "Trim domain name"

action 1.1 string trimright "$_nd_cdp_entry_name" ".your.domain.name"

action 1.2 string trimright "$_string_result" ".another.domain.name"

action 1.3 set _host "$_string_result"

action 2.0 comment "Convert long interface name to short"

action 2.1 string first "Ethernet" "$_nd_port_id"

action 2.2 if "$_string_result" eq 7

action 2.21 string replace "$_nd_port_id" 0 14 "Gi"

action 2.3 elseif "$_string_result" eq 10

action 2.31 string replace "$_nd_port_id" 0 17 "Te"

action 2.4 elseif "$_string_result" eq 4

action 2.41 string replace "$_nd_port_id" 0 11 "Fa"

action 2.5 end

action 2.6 set _int "$_string_result"

action 3.0 comment "Actual config of port description"

action 3.1 cli command "enable"

action 3.2 cli command "config t"

action 3.3 cli command "interface $_nd_local_intf_name"

action 3.4 cli command "description $_host:$_int"

action 3.5 cli command "do write"

action 4.0 syslog msg "EEM script updated description on $_nd_local_intf_name and saved config"

# Description would be something like: my-test-sw:Gi1/1/1 instead of my-test-sw.my.domain.name:GigabitEthernet1/1/1
