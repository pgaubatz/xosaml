#!/usr/bin/tclsh

set auto_path [linsert $auto_path 0 /Users/patailama/xoSAML/packages/xoXSD/] 

package require tdom
package require XOTcl
package require xoXSD::Generator::Parser

namespace import ::xotcl::*

if { $argc < 1 } {
	puts "Usage: $argv0 \[XSD-file 1\] ... \[XSD-file n\]"
	exit
}

proc getTargetPrefix {document} {
	set xoNamespaces() ""
	set xoTargetNamespace [$document getAttribute "targetNamespace"]
	
	foreach attr [$document attributes "xmlns:*"] {
		set prefix [lindex $attr 0]
		set attr "xmlns:$prefix"
		set ns [$document getAttribute $attr]
		set xoNamespaces($prefix) $ns
		set xoNamespaces($ns) $prefix
	}
	
	return $xoNamespaces($xoTargetNamespace)
}

proc generateClasses {data} {
	global xoNamespacePrefix
	
	set doc [dom parse $data] 
	set root [$doc documentElement]
	set targetPrefix [getTargetPrefix $root]
	set targetNamespace [$root getAttribute "targetNamespace"]
	
	if { [$root nodeName] != "schema" } {
		error "ERROR: $filename is not an XML schema file."
	}

	return [::xoXSD::Generator::Parser::parse $root $targetPrefix $targetNamespace $xoNamespacePrefix]
}

variable xoNamespacePrefix "::SAML"
set cmdline "$argv0 $argv"

puts {#!/usr/bin/tclsh

#
# This document has been generated using the following commandline:
#}
puts "# $cmdline\n#"	
puts {
set auto_path [linsert $auto_path 0 /Users/patailama/xoSAML/packages/xoXSD/] 
 
package require XOTcl
package require xoXSD

namespace import -force ::xotcl::*
namespace import -force ::xoXSD::Slots::*
}

set parsers [list]
foreach arg $argv {
	set fd [open $arg]
	lappend parsers [generateClasses [read $fd]]
	close $fd 
}

foreach parser $parsers {
	puts "namespace eval ::xoXSD addNamespace \"[$parser getNamespace]\""
}
puts ""

foreach parser $parsers {
	puts [$parser getDummyClasses]
}

foreach parser $parsers {
	puts [$parser getClasses]
}

