#
# Generating Syslog messages from Tclsh
# http://wiki.nil.com/Generating_Syslog_messages_from_Tclsh
# 
set syslog [open "syslog:" w+]
puts $syslog "%PING-6-starting ping"
flush $syslog
exec "ping 10.0.0.2"
puts $syslog "%PING-6-finished"
close $syslog 
