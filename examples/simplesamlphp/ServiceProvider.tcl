#!/usr/bin/env tclsh
	
set auto_path [linsert $auto_path 0 ../../packages/]

package require XOTcl
package require xotcl::comm::httpd
package require xoSAML

::xoSAML::load
::xoSAML::loadBinding HTTP::Post


#
# Define some variables:
#

variable SPHostname		"localhost"
variable SPPort			"8008"

variable SPMetadataUrl		"http://$SPHostname:$SPPort/Metadata"
variable SPAssertionConsumerUrl	"http://$SPHostname:$SPPort/AssertionConsumer"

variable IdPUrl			"http://localhost/~patailama/simplesaml/saml2/idp/SSOService.php"


#
# Implement a specialised Http-Worker:
#

::xotcl::Class Worker -superclass Httpd::Wrk

Worker instproc respond {} {
	set response respond-[my set resourceName] 
	if { [my procsearch $response] eq ""} {
		set response respond-default
	} 
	my $response
}

Worker instproc respond-default {} {
	global IdPUrl SPMetadataUrl SPHostname SPPort
	
	#
	# Create the SAML (Authn)Request:
	#
	
	saml::Issuer issuer $SPMetadataUrl
	
	samlp::NameIDPolicy policy
	policy AllowCreate "true"
	policy Format "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
	
	samlp::AuthnRequest request
	request ID "identifier_1"
	request AssertionConsumerServiceIndex "1"
	request Issuer issuer
	request NameIDPolicy policy
	
	set SAMLRequest [request send] 
	set RelayState "http://$SPHostname:$SPPort/[my set resourceName]"
	
	my returnResponse [subst {
		<html>
		<body>
		<h1>Restricted area</h1>
		<p>
			You're trying to access <i>$RelayState</i>...<br>
			Please authenticate yourself!
		</p>
		<form action="$IdPUrl" method="POST">
			<input type="hidden" name="SAMLRequest" value="$SAMLRequest">
			<input type="hidden" name="RelayState" value="$RelayState">
			<input type="submit" value="Continue...">
		</form>
		</body>
		</html>
	} ]
}

Worker instproc respond-AssertionConsumer {} {
	
	#
	# Read the POST'ed formdata:
	#
	
	set SAMLResponse [[lindex [my set formData] 0] set content]
	set RelayState   [[lindex [my set formData] 1] set content] 

	#
	# Create a SAML Response:
	#
	
	samlp::Response response
	response receive $SAMLResponse
	
	set o {
		<html><body>
		<h1>AssertionConsumer</h1>
		<ol>
			<li>The SAML Response's StatusCode is: <i>[response . Status . StatusCode . Value getContent]</i></li>
			<li>The Subject has been authenticated via: <i>[response . Assertion . AuthnStatement . AuthnContext . AuthnContextClassRef getContent]</i></li>
			<li>The Session is valid till: <i>[clock format [response . Assertion . Conditions . NotOnOrAfter getTimestamp]]</i></li>
		</ol>
		The following Attributes have been found:
		<ul>
	}
	foreach attribute [response . Assertion . AttributeStatement . Attribute] {
		append o "<li>[$attribute . Name getContent]:<ul>"
		foreach value [$attribute AttributeValue] {
			append o "<li>Value: <i>[$value getContent]</i></li>"	
		}
		append o "</ul></li>"
	}
	append o {
		</ul>
		<b>The requested resource was: <i>$RelayState</i></b>
		</body></html>
	}
	
	my returnResponse [subst $o]
}

Worker instproc respond-Metadata {} {
	global SPMetadataUrl SPAssertionConsumerUrl
	
	my returnResponse [subst {
		<?xml version="1.0"?>
		<EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata" entityID="$SPMetadataUrl"> 
			<SPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol"> 
				<NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</NameIDFormat> 
				 <AssertionConsumerService index="0" Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="$SPAssertionConsumerUrl"/> 
			</SPSSODescriptor>
		</EntityDescriptor> 
	} ]
}

Worker instproc returnResponse {content {code 200}} { 
	my replyCode $code
	my connection puts "Content-Type: text/html"
	my connection puts "Content-Length: [string length $content]\n"
	my connection puts-nonewline $content
	my close   
}

Httpd server -ipaddr $SPHostname -port $SPPort -root /tmp -httpdWrk Worker 

vwait forever
