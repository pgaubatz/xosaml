#!/usr/bin/tclsh

set auto_path [linsert $auto_path 0 ../packages/]
package require xoXSD::Validator
package require xoSAML::Schema

foreach test [glob tests/*.xotcl] {
	source $test
}

::xoXSD::Validator val "../tools/validator/lib"

foreach schema [glob ../xsd/*.xsd] {
	val addSchema $schema
}

set instances [::xoXSD::Generic info instances]
set i 0
foreach instance $instances {
	puts -nonewline "Validating $instance ([incr i]/[llength $instances])... "
	if { [val validate [$instance export]] == true } {
		puts "OK"
	} else {
		puts "FAILURE ([val getResult])"
		foreach err [val getErrors] {
			puts $err
		}
		puts ""
	}
}

