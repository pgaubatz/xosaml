#!/usr/bin/tclsh

set auto_path [linsert $auto_path 0 ../packages/] 
 
package require XOTcl
package require xoXSD

namespace import -force ::xotcl::*
namespace import -force ::xoXSD::DataTypes::*

set cmdcountstart [info cmdcount]

::xoXSD::DataTypes::anyURI t1 "http://sp.example.com/SAML2"
puts "[t1 class]: [t1 getContent]"

::xoXSD::DataTypes::string t2 "test 99"
puts "[t2 class]: [t2 getContent]"

::xoXSD::DataTypes::ID t3 "id"
puts "[t3 class]: [t3 getContent]"

::xoXSD::DataTypes::dateTime t4 0
puts "[t4 class]: [t4 getContent]"

::xoXSD::DataTypes::base64Binary t5 1234
puts "[t5 class]: [t5 getContent]"

::xoXSD::DataTypes::boolean t6 false
puts "[t6 class]: [t6 getContent]"

::xoXSD::DataTypes::NCName t7 "hallo_"
puts "[t7 class]: [t7 getContent]"

::xoXSD::DataTypes::nonNegativeInteger t8 123
puts "[t8 class]: [t8 getContent]"

::xoXSD::DataTypes::unsignedShort t9 0
puts "[t9 class]: [t9 getContent]"

::xoXSD::DataTypes::anyType t10 ""
puts "[t10 class]: [t10 getContent]"

::xoXSD::DataTypes::integer t11 9
puts "[t11 class]: [t11 getContent]"

puts "COMMANDS: [expr {[info cmdcount] - $cmdcountstart}]"


