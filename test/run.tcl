#!/usr/bin/tclsh

set auto_path [linsert $auto_path 0 ../packages/]
package require xoXSD::Validator
package require xoSAML::Schema
package require xoSAML::Environment

namespace eval ::test {
	
::xoSAML::Environment::load [namespace current]

foreach test [glob tests/*.xotcl] {
	namespace eval ::test source $test
}

::xoXSD::Validator val "../tools/validator/lib"

foreach schema [glob ../xsd/*.xsd] {
	val addSchema $schema
}
	
set instances [lsearch -inline -all -glob [::xoXSD::Core::Generic info instances -closure] "::test::*"]
set i 0
foreach instance $instances {
	set s [namespace tail [[$instance class] info superclass]]
	if { $s eq "Sequence" || $s eq "Choice" } continue
	puts -nonewline "Validating $instance ([incr i])... "
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

}
