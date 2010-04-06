#!/usr/bin/tclsh

set auto_path [linsert $auto_path 0 ../packages/]
package require xoXSD::CodeGenerator

if { $argc < 1 } {
	puts "Usage: $argv0 \[file 1\] ... \[file n\]"
	exit
}

puts {#!/usr/bin/tclsh
	
set auto_path [linsert $auto_path 0 ../packages/]
package require xoSAML::Schema
}

::xoXSD::CodeGenerator gen

foreach filename $argv {
	set fd [open $filename]
	puts [gen parse [read $fd] [list {ds "http://www.w3.org/2000/09/xmldsig#"}]]
	close $fd
}
