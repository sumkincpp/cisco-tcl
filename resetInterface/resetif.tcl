# Reset interface 
#           * download the file into flash:resetif.tcl
#           * configure alias exec resetif tclsh flash:resetif.tcl
#           * invoke with resetif [interface]
#           * uncomment puts lines to debug
proc usage {} {
	#puts {Syntax: resetif interface}
}
proc getState { ifnum } {
	if { [ catch { set ifstate [exec "show interface $ifnum"] } iferror ] } {
		# puts "No such interface: $ifnum";
		return 1;
	}
	set result [ expr [ string first {administratively down} $ifstate ] < 0]
	return $result;
}
proc doConfig { mode cmd } { 
  if { [ catch { ios_config $mode $cmd } errmsg ] } { error "IOS configuration $mode / $cmd failed"; }
}
proc resetInterface { ifnum } {
	if { [getState $ifnum] } {
		# puts "shut down interface $ifnum" ;
		doConfig "interface $ifnum" "shutdown";
		after 6000;
		# puts "enable interface $ifnum";
		doConfig "interface $ifnum" "no shutdown";
	} else {
		# puts "$ifnum is administratively shutdown"
	}
}
global paramIP paramInterface
set paramInterface [lindex $argv 0]
if {[string equal $paramInterface ""]} { usage; return; }
resetInterface $paramInterface
