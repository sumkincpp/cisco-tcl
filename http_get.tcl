source "tmpsys:lib/tcl/http.tcl"
set Token [::http::geturl "http://172.16.3.106/NameQuery.aspx?number=90771470xxxx"]
puts [::http::data $Token]
