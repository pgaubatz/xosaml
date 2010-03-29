#!/usr/bin/tclsh

set auto_path [linsert $auto_path 0 ../packages/xoXSD/]
source SAML-Core.xotcl

package require tdom

set data {
<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" InResponseTo="indentifier_1" ID="identifier_2" Version="2.0" Destination="https://sp.example.com/SAML2/SSO/POST" IssueInstant="2010-03-29T10:23:44Z">
	<saml:Issuer>https://idp.example.org/SAML2</saml:Issuer>
	<samlp:Status>
		<samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
	</samlp:Status>
	<saml:Assertion ID="identifier_3" Version="2.0" IssueInstant="2010-03-29T10:23:44Z">
		<saml:Issuer>https://idp.example.org/SAML2</saml:Issuer>
		<saml:Subject>
			<saml:NameID Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient">3f7b3dcf-1674-4ecd-92c8-1544f346baf8</saml:NameID>
			<saml:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer">
				<saml:SubjectConfirmationData NotOnOrAfter="2010-03-29T10:23:44Z" InResponseTo="identifier_1" Recipient="https://sp.example.com/SAML2/SSO/POST"/>
			</saml:SubjectConfirmation>
		</saml:Subject>
		<saml:Conditions NotBefore="1970-01-01T00:00:01Z" NotOnOrAfter="2010-03-29T10:23:44Z">
			<saml:AudienceRestriction>
				<saml:Audience>https://sp.example.com/SAML2</saml:Audience>
			</saml:AudienceRestriction>
		</saml:Conditions>
		<saml:AuthnStatement SessionIndex="identifier_3" AuthnInstant="2010-03-29T10:23:44Z">
			<saml:AuthnContext>
				<saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport</saml:AuthnContextClassRef>
			</saml:AuthnContext>
		</saml:AuthnStatement>
	</saml:Assertion>
</samlp:Response>
}

proc stripPrefix {name} {
	set pos [string first ":" $name]
	if { $pos == -1 } { return $name }
	return [string range $name [expr {$pos + 1}] end]
}

proc stripInitString {name} {
	set pos [string first "\"" $name]
	if { $pos == -1 } { return $name }
	return [string range $name 0 [expr {$pos - 2}]]
}

proc handleNode {node} {
	set nodeName [$node nodeName]
	if { $nodeName == "#comment" || $nodeName == "#cdata" } {
		return
	}
	
	set name [stripPrefix [$node nodeName]]
	set objname [Object autoname obj]
	set obj [list]
	
	set init "$name $objname"
	foreach child [$node childNodes] {
		if { [$child nodeName] == "#text" } {
			append init " \"[$child nodeValue]\""
			$child delete
			break
		}
	}
	
	lappend obj $init
	
	foreach attribute [$node attributes "xmlns:*"] {
		$node removeAttribute "xmlns:[lindex $attribute 0]"
	}
	
	foreach attribute [$node attributes] {
		lappend obj "$objname $attribute \"[$node getAttribute $attribute]\""
	}
	
	foreach child [$node childNodes] {
		set childobj [stripInitString [lindex [handleNode $child] 0]]
		lappend obj "$objname $childobj"
	}
	
	global objects
	lappend objects $obj
	return $obj
}

set doc [dom parse $data] 
set root [$doc documentElement]
set objects [list]
handleNode $root

puts {#!/usr/bin/tclsh
	
set auto_path [linsert $auto_path 0 ../packages/xoXSD/]
source SAML-Core.xotcl	
}

foreach object $objects {
	foreach line $object {
		puts $line
	}
	puts ""
}
