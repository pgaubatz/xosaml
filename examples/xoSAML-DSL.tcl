#!/usr/bin/tclsh

set auto_path [linsert $auto_path 0 ../packages/]
package require xoSAML

#
#these examples were taken from [sstc-saml-tech-overview-2.0-cd-02] chapter 5.1.2
#

Issuer iss1 https://sp.example.com/SAML2

NameIDPolicy pol1
pol1 AllowCreate true
pol1 Format urn:oasis:names:tc:SAML:2.0:nameid-format:transient

Request req1
req1 ID identifier_1
req1 AssertionConsumerServiceIndex 1
req1 Issuer iss1
req1 NameIDPolicy pol1
req1 print

#
#<samlp:AuthnRequest 
#	xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
#	xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" 
#	ID="identifier_1" 
#	Version="2.0" 
#	IssueInstant="2004-12-05T09:21:59Z" 
#	AssertionConsumerServiceIndex="1"> 
#	
#	<saml:Issuer>https://sp.example.com/SAML2</saml:Issuer> 
#
#	<samlp:NameIDPolicy 
#		AllowCreate="true"
#		Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient"/> 
#
#</samlp:AuthnRequest>
#

Issuer iss2 https://idp.example.org/SAML2

Status sta1 Success

NameID nam1 3f7b3dcf-1674-4ecd-92c8-1544f346baf8
nam1 Format urn:oasis:names:tc:SAML:2.0:nameid-format:transient

SubjectConfirmationData scd1
scd1 InResponseTo identifier_1
scd1 Recipient https://sp.example.com/SAML2/SSO/POST
scd1 NotOnOrAfter now

SubjectConfirmation sc1
sc1 Method urn:oasis:names:tc:SAML:2.0:cm:bearer
sc1 SubjectConfirmationData scd1

Subject sub1
sub1 NameID nam1
sub1 SubjectConfirmation sc1

Audience aud1 https://sp.example.com/SAML2

AudienceRestriction aur1
aur1 Audience aud1

Conditions con1
con1 NotBefore 1
con1 NotOnOrAfter now
con1 AudienceRestriction aur1

AuthnContextClassRef ref1 urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport

AuthnContext ctx1
ctx1 AuthnContextClassRef ref1

AuthnStatement ast1
ast1 AuthnInstant now
ast1 SessionIndex identifier_3
ast1 AuthnContext ctx1

Assertion ass1
ass1 ID identifier_3
ass1 Issuer iss2
ass1 Subject sub1
ass1 Conditions con1
ass1 AuthnStatement ast1

Response res1
res1 ID identifier_2
res1 InResponseTo indentifier_1
res1 Destination https://sp.example.com/SAML2/SSO/POST
res1 Issuer iss2
res1 Status sta1
res1 Assertion ass1
res1 print

#
#<samlp:Response 
#	xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" 
#	xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" 
#	ID="identifier_2" 
#	InResponseTo="identifier_1" 
#	Version="2.0" 
#	IssueInstant="2004-12-05T09:22:05Z" 
#	Destination="https://sp.example.com/SAML2/SSO/POST"> 
#
#	<saml:Issuer>https://idp.example.org/SAML2</saml:Issuer> 
#	
#	<samlp:Status>
#		<samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
#	</samlp:Status> 
#
#	<saml:Assertion
#		xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" 
#		ID="identifier_3" 
#		Version="2.0" 	
#		IssueInstant="2004-12-05T09:22:05Z"> 
#	
#		<saml:Issuer>https://idp.example.org/SAML2</saml:Issuer> 
#		
#		<!-- a POSTed assertion MUST be signed --> 
#		<ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">...</ds:Signature> 
#		
#		<saml:Subject>
#			<saml:NameID Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient">3f7b3dcf-1674-4ecd-92c8-1544f346baf8</saml:NameID> 
#			<saml:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer"> 
#				<saml:SubjectConfirmationData
#					InResponseTo="identifier_1" 
#					Recipient="https://sp.example.com/SAML2/SSO/POST" 
#					NotOnOrAfter="2004-12-05T09:27:05Z"/>
#			</saml:SubjectConfirmation> 
#		</saml:Subject> 
#		
#		<saml:Conditions
#			NotBefore="2004-12-05T09:17:05Z" 
#			NotOnOrAfter="2004-12-05T09:27:05Z"> 
#		
#			<saml:AudienceRestriction>
#				<saml:Audience>https://sp.example.com/SAML2</saml:Audience> 
#			</saml:AudienceRestriction>
#		
#		</saml:Conditions> 
#		
#		<saml:AuthnStatement
#			AuthnInstant="2004-12-05T09:22:00Z" 
#			SessionIndex="identifier_3"> 
#			
#			<saml:AuthnContext>
#				<saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport</saml:AuthnContextClassRef> 
#			</saml:AuthnContext>
#		</saml:AuthnStatement> 
#	</saml:Assertion>
#</samlp:Response>
#
