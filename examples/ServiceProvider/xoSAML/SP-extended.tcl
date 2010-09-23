#!/usr/bin/env tclsh
	
set auto_path [linsert $auto_path 0 ../../packages/]

package require XOTcl
package require uuid
package require xotcl::comm::httpd
package require xoSAML

::xoSAML::load
::xoSAML::loadBinding HTTP::Post


#
# Implement a specialised Http-Worker:
#

::xotcl::Class Worker -superclass Httpd::Wrk 

Worker instforward getSession		{% my info parent} %proc
Worker instforward addSession		{% my info parent} %proc

Worker instforward HostPort		{% my info parent} %proc
Worker instforward MetadataUrl		{% my info parent} %proc
Worker instforward AssertionConsumerUrl	{% my info parent} %proc
Worker instforward IdPUrl		{% my info parent} %proc
Worker instforward SessionExpiry	{% my info parent} %proc

Worker instproc respond {} {
	set response respond-[my set resourceName] 
	if { [my procsearch $response] eq ""} {
		set response respond-default
	} 
	my $response
}

Worker instproc respond-default {} {
	if { [my exists meta(cookie)] } {
        	foreach c [split [my set meta(cookie)] ";"] {
        		set c [split [string trim $c] "="]
        		if { [lindex $c 0] eq "xoSAMLSession" } {
        			set session [lindex $c 1]
        			set expires [my getSession $session]
        			set now [clock seconds] 
        			if { $expires != -1 && $now < $expires } {
					set expiresIn [expr $expires - $now]
        			} 
        		}
        	}
	}
	if { [info exists expiresIn] } {
		my returnResponse [subst {
        		<html><body><h1>Restricted area</h1><p>
			You're successfully authenticated and now have access to this restricted resource.<br>
			Your session will expire in $expiresIn seconds...
			</p></body></html>
		} ] 
	} else {
		my respond-AuthenticationRequest
	}
}

Worker instproc respond-AuthenticationRequest {} {
	
	#
	# Create the SAML (Authn)Request:
	#
	
	saml::Issuer issuer [my MetadataUrl]
		
	samlp::AuthnRequest request
	request ID "identifier_1"
	request Issuer issuer
	request ForceAuthn true
	
	request RelayState "http://[my HostPort]/[my set resourceName]"

	my returnResponse [request send [my IdPUrl]] 
}

Worker instproc respond-AssertionConsumer {} {
	
	#
	# Create a SAML Response:
	#
	
	samlp::Response response
	response receive [my set data]
	
	set o {
		<html><body><h1>AssertionConsumer</h1>
		<ol>
			<li>The SAML Response's StatusCode is: <i>[response . Status getStatusCode]</i></li>
			<li>The Subject has been authenticated via: <i>[response . Assertion getAuthenticationMechanism]</i></li>
			<li>The Session is valid till: <i>[response . Assertion getExpiry]</i></li>
		</ol>
	}
	if { [response . Assertion hasAttributes] } {
		append o "The following Attributes have been found:<ul>"
        	foreach attribute [response . Assertion getAttributes] {
        		append o "<li>[$attribute getName]:<ul>"
        		foreach value [$attribute getValues] {
        			append o "<li>Value: <i>$value</i></li>"	
        		}
        		append o "</ul></li>"
        	}
		append o "</ul>"
	}
	if { [response hasRelayState] } {
        	append o {
        		<b>You may now access the restricted resource: <a href="[response RelayState]">[response RelayState]</a></b>
        		</body></html>
        	}
	}
	
	set uuid [::uuid::uuid generate]
	set expires [response . Assertion getExpiry -timestamp true]
	set expires_text [clock format $expires -format {%a, %d %b %Y %T GMT} -gmt true]
	set cookie "Set-Cookie: xoSAMLSession=$uuid; expires=$expires_text; Version=1"
	
	my addSession $uuid $expires
	
	my returnResponse [subst $o] 200 [list $cookie]
}

Worker instproc respond-Metadata {} {
	my returnResponse [subst {
		<?xml version="1.0"?>
		<EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata" entityID="[my MetadataUrl]"> 
			<SPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol"> 
				<NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</NameIDFormat> 
				<AssertionConsumerService index="0" Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="[my AssertionConsumerUrl]"/> 
			</SPSSODescriptor>
		</EntityDescriptor> 
	} ]
}

Worker instproc returnResponse {content {code 200} {headers {}}} { 
	my replyCode $code
	my connection puts "Content-Type: text/html"
	foreach h $headers {
		my connection puts $h
	}
	my connection puts "Content-Length: [string length $content]\n"
	my connection puts-nonewline $content
	my close   
}


#
# Implement a specialised Http-Server:
#

::xotcl::Class Server -superclass ::xotcl::comm::httpd::Httpd -slots {
	::xotcl::Attribute HostPort
	::xotcl::Attribute MetadataUrl
	::xotcl::Attribute AssertionConsumerUrl
	::xotcl::Attribute IdPUrl
}

Server instproc init args {
	next
	
	my HostPort		"[my ipaddr]:[my port]"
	my MetadataUrl 	 	"http://[my HostPort]/Metadata" 					
	my AssertionConsumerUrl "http://[my HostPort]/AssertionConsumer"
	
	my instvar Sessions
	set Sessions() [list]
}

Server instproc getSession {uuid} {
	my instvar Sessions
	if { [info exists Sessions($uuid)] } {
		return $Sessions($uuid)
	}
	return -1
}

Server instproc addSession {uuid expires} {
	my instvar Sessions
	set Sessions($uuid) $expires
}


#
# Finally start the Http-Server:
#

Server server 									\
	-ipaddr localhost 							\
	-port 8008 								\
	-root /tmp 								\
	-httpdWrk Worker 							\
	-IdPUrl http://localhost/~patailama/simplesaml/saml2/idp/SSOService.php 
	
vwait forever
