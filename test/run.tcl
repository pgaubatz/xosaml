#!/usr/bin/tclsh

set auto_path [linsert $auto_path 0 ../packages/xoXSD/]
package require xoXSD::Validator

source ../examples/SAML-Core.xotcl

foreach test [glob tests/*.xotcl] {
	source $test
}

::xoXSD::Validator val "../tools/validator/lib"

val addSchema "../xsd/xenc-schema.xsd"
val addSchema "../xsd/xmldsig-core-schema.xsd"
val addSchema "../xsd/saml-schema-assertion-2.0.xsd"
val addSchema "../xsd/saml-schema-protocol-2.0.xsd"

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

