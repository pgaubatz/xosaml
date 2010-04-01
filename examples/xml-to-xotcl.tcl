#!/usr/bin/tclsh

set auto_path [linsert $auto_path 0 ../packages/]
package require xoXSD::CodeGenerator

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

puts {#!/usr/bin/tclsh
	
set auto_path [linsert $auto_path 0 ../packages/]
package require xoSAML::Schema
}

::xoXSD::CodeGenerator gen
puts [gen parse $data]
