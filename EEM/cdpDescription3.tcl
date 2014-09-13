# Improved even further, please comment and/or improve further:

#     Trim domain name - now with regexp
#     Verifiy switch or router remote end. I don't want this script to update decription on AP's and so on.
#     Do not update description if remote host and interface is unchanged. This will retain additional information in description like circuit id, vendor and so on even after a link failure
#     If description is changed, show old description in syslog message

# regexp in the event are for the uplink module on 3750-X/3560-X, adapt to your own need.

event manager applet auto-update-port-description authorization bypass
description "Auto-update port-description based on CDP neighbors info"
action 0.0 comment "Event line regexp: Deside which interface to auto-update description on"

event neighbor-discovery interface regexp .*GigabitEthernet[1-9]/1/[1-4]$ cdp add

action 1.0 comment "Verify CDP neighbor to be Switch or Router"

action 1.1 regexp "(Switch|Router)" $_nd_cdp_capabilities_string

action 1.2 if $_regexp_result eq 1

action 2.0 comment "Trim domain name"

action 2.1 regexp "^([^\.]+)\." $_nd_cdp_entry_name match host

action 3.0 comment "Convert long interface name to short"

action 3.1 string first "Ethernet" "$_nd_port_id"

action 3.2 if "$_string_result" eq 7

action 3.21 string replace "$_nd_port_id" 0 14 "Gi"

action 3.3 elseif "$_string_result" eq 10

action 3.31 string replace "$_nd_port_id" 0 17 "Te"

action 3.4 elseif "$_string_result" eq 4

action 3.41 string replace "$_nd_port_id" 0 11 "Fa"

action 3.5 end

action 3.6 set int "$_string_result"

action 4.0 comment "Check old description if any, and do no change if same host:int"

action 4.1 cli command "enable"

action 4.11 cli command "config t"

action 4.2 cli command "do show interface $_nd_local_intf_name | incl Description:"

action 4.21 set olddesc "<none>"

action 4.22 set olddesc_sub1 "<none>"

action 4.23 regexp "Description: ([a-zA-Z0-9:/\-]*)([a-zA-Z0-9:/\-\ ]*)" "$_cli_result" olddesc olddesc_sub1

action 4.24 if "$olddesc_sub1" eq "$host:$int"

action 4.25 syslog msg "EEM script did NOT change desciption on $_nd_local_intf_name, since remote host and interface is unchanged"

action 4.26 exit 10

action 4.27 end

action 4.3 cli command "interface $_nd_local_intf_name"

action 4.4 cli command "description $host:$int"

action 4.5 cli command "do write"

action 4.6 syslog msg "EEM script updated description on $_nd_local_intf_name from $olddesc to Description: $host:$int and saved config"

action 5.0 end

action 6.0 exit 1

# Description would be something like: my-test-sw:Gi1/1/1 instead of my-test-sw.my.domain.name:GigabitEthernet1/1/1
