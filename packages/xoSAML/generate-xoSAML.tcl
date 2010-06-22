#!/usr/bin/env tclsh

set auto_path [linsert $auto_path 0 ..] 

package require XOTcl
package require fileutil
package require xoXSD::SchemaGenerator

::xoXSD::SchemaGenerator gen "::xoSAML"

foreach schema [glob ../../xsd/*.xsd] {
	set fd [open $schema]
	gen addSchema [read $fd]
	close $fd
}

set o "package provide xoSAML::Schema 0.1\n\n"
append o [gen generateSchema]
::fileutil::writeFile "generated/Schema.xotcl" $o

set o "package provide xoSAML::Environment 0.1\n"
append o "package require xoSAML::Schema\n\n"
append o [gen generateEnvironment]
::fileutil::writeFile "generated/Environment.xotcl" $o
