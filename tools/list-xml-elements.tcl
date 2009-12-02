#!/usr/bin/env tclsh

package require tdom
package require XOTcl

namespace import ::xotcl::*

if { $argc < 1 } {
	puts "Usage: $argv0 \[file 1\] ... \[file n\]"
	exit
}

proc handler {name attlist} {
	global elements
	if { ![info exists elements($name)] } {
		set elements($name) 1
	} else {
		incr elements($name)	
	}
}

set parser [xml::parser]
$parser configure -elementstartcommand handler

foreach filename $argv {
	set fd [open $filename]
	$parser parse [read $fd]
	close $fd
}

set output [list]
foreach element [array names elements] {
	lappend output [list $elements($element) $element]
} 

foreach line [lsort -decreasing -integer -index 0 $output] {
	puts "[lindex $line 0]\t -> [lindex $line 1]"
}


