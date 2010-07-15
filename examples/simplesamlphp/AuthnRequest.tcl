#!/usr/bin/env tclsh
	
set auto_path [linsert $auto_path 0 ../../packages/]

package require xoSAML

::xoSAML::load
::xoSAML::loadBinding HTTP::Post


#
# Define some variables:
#

set IdPUrl "http://localhost/~patailama/simplesaml/saml2/idp/SSOService.php"
set SPUrl  "http://localhost/~patailama/simplesaml/saml2/sp/metadata.php"

set Username "student"
set Password "studentpass"


#
# Create the SAML (Authn)Request:
#

saml::Issuer issuer $SPUrl

samlp::NameIDPolicy policy
policy AllowCreate "true"
policy Format "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"

samlp::AuthnRequest request
request ID "identifier_1"
request Version "2.0"
request IssueInstant now
request AssertionConsumerServiceIndex "1"
request Issuer issuer
request NameIDPolicy policy


#
# Post the SAML (Authn)Request
#

set http [request send $IdPUrl]


#
# Get the IdP's login-site (User's duty)
#

set loginurl [$http getHeader "Location"]

$http getUrl $loginurl


#
# Post the login-data (User's duty)
#

set pos [string first "?" $loginurl]
set posturl [string range $loginurl 0 $pos] 

set doc [$http getDocumentElement]
set authstate [[$doc find "name" "AuthState"] getAttribute "value"]

$http addQuery username $Username
$http addQuery password $Password
$http addQuery AuthState $authstate

$http getUrl $posturl


#
# Post the SAML Response (User's duty)
#

set url [$http getHeader "Location"]

$http getUrl $url


#
# Create a SAML Response
#

samlp::Response response

response receive [$http getData]

puts "1) The SAML Response's StatusCode is: [response . Status . StatusCode . Value getContent]\n"
puts "2) The Subject has been authenticated via: [response . Assertion . AuthnStatement . AuthnContext . AuthnContextClassRef getContent]\n"
puts "3) The following Attributes have been found:"
foreach attribute [response . Assertion . AttributeStatement . Attribute] {
	puts "\n\to) [$attribute . Name getContent]"
	foreach value [$attribute AttributeValue] {
		puts "\t\to) Value: \"[$value getContent]\" "	
	}
}

#
# This example should generate the following output:
#

#
#	1) The SAML Response's StatusCode is: urn:oasis:names:tc:SAML:2.0:status:Success
#	
#	2) The Subject has been authenticated via: urn:oasis:names:tc:SAML:2.0:ac:classes:Password
#	
#	3) The following Attributes have been found:
#	
#		o) eduPersonAffiliation
#			o) Value: "student" 
#			o) Value: "member" 
#	
#		o) uid
#			o) Value: "testuid" 
#

