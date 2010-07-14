#!/usr/bin/env tclsh

set auto_path [linsert $auto_path 0 ../packages/] 
 
package require xoXSD

set cmdcountstart [info cmdcount]

::xoXSD::DataTypes::load [namespace current]

xsd::anyURI t1 "http://sp.example.com/SAML2"
puts "[t1 class]: [t1 getContent]"

xsd::string t2 "test 99"
puts "[t2 class]: [t2 getContent]"

xsd::ID t3 "id"
puts "[t3 class]: [t3 getContent]"

xsd::dateTime t4 0
puts "[t4 class]: [t4 getContent]"

xsd::base64Binary t5 1234
puts "[t5 class]: [t5 getContent]"

xsd::boolean t6 false
puts "[t6 class]: [t6 getContent]"

xsd::NCName t7 "hallo_"
puts "[t7 class]: [t7 getContent]"

xsd::nonNegativeInteger t8 123
puts "[t8 class]: [t8 getContent]"

xsd::unsignedShort t9 0
puts "[t9 class]: [t9 getContent]"

xsd::anyType t10 ""
puts "[t10 class]: [t10 getContent]"

xsd::integer t11 9
puts "[t11 class]: [t11 getContent]"

puts "COMMANDS: [expr {[info cmdcount] - $cmdcountstart}]"


