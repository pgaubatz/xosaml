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

Worker instproc respond {} {
	set httpd [my info parent]
	set protoHostPort "http://[$httpd ipaddr]:[$httpd port]"
	
	if { [my set resourceName] eq "AssertionConsumer" } {
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
		if { [llength [response . Assertion getAttributes]] } {
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
		if { [response RelayState] ne "" } {
			append o {
				<b>You may now access the restricted resource: <a href="[response RelayState]">[response RelayState]</a></b>
				</body></html>
			}
		}
		
		set content [subst $o]
		
	} elseif { [my set resourceName] eq "Metadata" } {
		set content [subst {
			 <?xml version="1.0"?>
			 <EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata" entityID="$protoHostPort/Metadata"> 
				 <SPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol"> 
					 <NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</NameIDFormat> 
					 <AssertionConsumerService index="0" Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="$protoHostPort/AssertionConsumer"/> 
				 </SPSSODescriptor>
			 </EntityDescriptor> 
		 } ]
		
	} else {
		saml::Issuer issuer "$protoHostPort/Metadata"
			
		samlp::AuthnRequest request
		request ID "identifier_1"
		request Issuer issuer
		request ForceAuthn true
		
		request RelayState "$protoHostPort/[my set resourceName]"
	
		set content [request send "http://localhost/~patailama/simplesaml/saml2/idp/SSOService.php"] 
	}
	
	my replyCode 200
	my connection puts "Content-Type: text/html"
	my connection puts "Content-Length: [string length $content]\n"
	my connection puts-nonewline $content
	my close
}


#
# Finally start the Http-Server:
#

::xotcl::comm::httpd::Httpd server \
	-ipaddr localhost 	   \
	-port 8008 		   \
	-root /tmp 		   \
	-httpdWrk Worker
	
vwait forever
