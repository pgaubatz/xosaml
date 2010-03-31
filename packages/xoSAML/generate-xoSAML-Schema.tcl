#!/usr/bin/tclsh

set auto_path [linsert $auto_path 0 ..] 

package require XOTcl
package require fileutil
package require xoXSD::Generator

::xoXSD::Generator gen
gen setNamespace "::xoSAML"

foreach schema [glob ../../xsd/*.xsd] {
	set fd [open $schema]
	gen addSchema [read $fd]
	close $fd
}

set o "package provide xoSAML::Schema 0.1\n\n"
append o [gen generate]
::fileutil::writeFile "xoSAML-Schema.xotcl" $o
