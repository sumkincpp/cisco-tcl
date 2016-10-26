set output [exec "show ip int brief"]
set fd [open "flash:/ip_int.txt" "w"]
puts $fd $output
close $fd

ios_config "file prompt quiet" "end"
copy flash:/ip_int.txt tftp://10.1.1.1/ip_int.txt
ios_config "no file prompt quiet" "end"
file delete -force "flash:/ip_int.txt"
