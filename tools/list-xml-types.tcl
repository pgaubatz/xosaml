#!/usr/bin/tclsh

package require tdom

if { $argc < 1 } {
	puts "Usage: $argv0 \[file 1\] ... \[file n\]"
	exit
}

proc parse {data} {
	global types
	
	set doc [dom parse $data] 
	set root [$doc documentElement]
	
	foreach query {"//xsd:element[@type]" "//xsd:attribute[@type]"} {
		foreach node [$doc selectNodes -namespaces {xsd http://www.w3.org/2001/XMLSchema} $query] {
			set type [$node getAttribute type]
			# skip namespace'd types: 
			if { [string first ":" $type] != -1 } {
				continue
			}
			if { ![info exists types($type)] } {
				set types($type) 1
			} else {
				incr types($type)	
			}
		}
	}
}

foreach filename $argv {
	set fd [open $filename]
	parse [read $fd]
	close $fd
}

set output [list]
foreach type [array names types] {
	lappend output [list $types($type) $type]
} 

foreach line [lsort -decreasing -integer -index 0 $output] {
	puts "[lindex $line 0]\t -> [lindex $line 1]"
}
