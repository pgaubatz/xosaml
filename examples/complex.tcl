#!/usr/bin/env tclsh

set auto_path [linsert $auto_path 0 ../xoXSD/] 
 
package require XOTcl
package require xoXSD

namespace import -force ::xotcl::*
namespace import -force ::xoXSD::Slots::*

set cmdcountstart [info cmdcount]

namespace eval ::xoXSD addNamespace "::SAML"

namespace eval ::SAML {

variable xmlNamespace 	"urn:oasis:names:tc:SAML:2.0:assertion"
variable xmlPrefix 	"saml"

#<complexType name="SubjectType">
#	<choice>
#		<sequence>
#			<choice>
#				<element ref="saml:BaseID"/>
#				<element ref="saml:NameID"/>
#				<element ref="saml:EncryptedID"/>
#			</choice>
#			<element ref="saml:SubjectConfirmation" minOccurs="0" maxOccurs="unbounded"/>
#		</sequence>
#		<element ref="saml:SubjectConfirmation" maxOccurs="unbounded"/>
#	</choice>
#</complexType>

Class SubjectType -superclass ::xoXSD::Core::xsd:complexType 

Class SubjectType::__choice0 -superclass ::xoXSD::Core::xsd:choice -slots { 
	XML:Element SubjectConfirmation -type ::xoXSD::DataTypes::string -maxOccurs unbounded -text true
}

Class SubjectType::__choice0::__sequence0 -superclass ::xoXSD::Core::xsd:sequence -slots {
	XML:Child   __choice0 		-sequence 1
	XML:Element SubjectConfirmation -type ::xoXSD::DataTypes::string -maxOccurs unbounded -text true -sequence 2
}

Class SubjectType::__choice0::__sequence0::__choice0 -superclass ::xoXSD::Core::xsd:choice -slots {
	XML:Element BaseID		-type ::xoXSD::DataTypes::string -minOccurs 0 -text true 
	XML:Element NameID		-type ::xoXSD::DataTypes::string -minOccurs 0 -text true 
	XML:Element EncryptedID		-type ::xoXSD::DataTypes::string -minOccurs 0 -text true 
}

}

::SAML::SubjectType sub1
sub1 setSlot BaseID [::xoXSD::DataTypes::string new "My BaseID"]
sub1 setSlot SubjectConfirmation [::xoXSD::DataTypes::string new "My SubjectConfirmation"]
sub1 printSlots
puts [sub1 export]

::SAML::SubjectType sub2
sub2 setSlot SubjectConfirmation [::xoXSD::DataTypes::string new "My SubjectConfirmation"]
sub2 setSlot BaseID [::xoXSD::DataTypes::string new "My BaseID"]
sub2 printSlots
puts [sub2 export]

puts "COMMANDS: [expr {[info cmdcount] - $cmdcountstart}]"


