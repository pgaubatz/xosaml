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
	
	if { [$root nodeName] != "schema" } {
		error "ERROR: $filename is not an XML schema file."
	}

	return [::xoXSD::Generator::Parser::parse $root $targetPrefix $xoNamespacePrefix]
}

variable xoNamespacePrefix "::SAML"

set parsers [list]
foreach arg $argv {
	set fd [open $arg]
	lappend parsers [generateClasses [read $fd]]
	close $fd 
}

puts {#!/usr/bin/tclsh

set auto_path [linsert $auto_path 0 /Users/patailama/xoSAML/packages/xoXSD/] 
 
package require XOTcl
package require xoXSD

namespace import -force ::xotcl::*
namespace import -force ::xoXSD::Slots::*
	
}

foreach parser $parsers {
	puts [$parser getDummyClasses]
}

foreach parser $parsers {
	puts [$parser getClasses]
}

