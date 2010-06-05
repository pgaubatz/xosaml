#!/usr/bin/tclsh

set auto_path [linsert $auto_path 0 ../packages/]
package require xoSAML

xoSAML {

#
#<element name="SubjectConfirmationData" type="saml:SubjectConfirmationDataType"/>
#<complexType name="SubjectConfirmationDataType" mixed="true">
#	<complexContent>
#		<restriction base="anyType">
#			<sequence>
#				<any namespace="##any" processContents="lax" minOccurs="0" maxOccurs="unbounded"/>
#			</sequence>
#			<attribute name="NotBefore" type="dateTime" use="optional"/>
#			<attribute name="NotOnOrAfter" type="dateTime" use="optional"/>
#			<attribute name="Recipient" type="anyURI" use="optional"/>
#			<attribute name="InResponseTo" type="NCName" use="optional"/>
#			<attribute name="Address" type="string" use="optional"/>
#			<anyAttribute namespace="##other" processContents="lax"/>
#		</restriction>
#	</complexContent>
#</complexType>
#

Audience aud1 "http://audience"

SubjectConfirmationData s1

s1 printSlots

s1 Address "http://address"
s1 addAny aud1
s1 addAnyAttribute ANewAttribute ::xoXSD::DataTypes::string "SomeContent"
s1 print

s1 printSlots

}
