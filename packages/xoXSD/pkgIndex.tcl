# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded xoXSD 0.1 [list source [file join $dir "lib" xoXSD.xotcl]]
package ifneeded xoXSD::Core 0.1 [list source [file join $dir "lib" Core.xotcl]]
package ifneeded xoXSD::DataTypes 0.1 [list source [file join $dir "lib" DataTypes.xotcl]]
package ifneeded xoXSD::Slots 0.1 [list source [file join $dir "lib" Slots.xotcl]]
package ifneeded xoXSD::CodeGenerator 0.1 [list source [file join $dir "generator" CodeGenerator.xotcl]]
package ifneeded xoXSD::SchemaGenerator 0.1 [list source [file join $dir "generator" SchemaGenerator.xotcl]]
package ifneeded xoXSD::SchemaGenerator::Parser 0.1 [list source [file join $dir "generator" Parser.xotcl]]
package ifneeded xoXSD::SchemaGenerator::Virtual 0.1 [list source [file join $dir "generator" Virtual.xotcl]]
package ifneeded xoXSD::Validator 0.1 [list source [file join $dir "validator" Validator.xotcl]]
