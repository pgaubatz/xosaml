#!/usr/bin/env tclsh

set auto_path "../packages/ $auto_path"

package require STORM

# This file has been adapted from Mark Strembeck's xoRBAC test-suite
# see: http://wi.wu-wien.ac.at/home/mark/xoRBAC/

# eliminate duplicate list elements while retaining element order
proc luniqueorder {list} {
        set nl ""
        while {$list != ""} {
                set l [lindex $list 0]
                set list [lreplace $list 0 0]
                if {[lsearch $nl $l] == -1} {
			lappend nl $l
                }
        }
        return $nl
}

foreach test [lsort -dictionary [glob tests/*.test.xotcl]] {
	if { ![file isfile $test] } continue
	source $test
	set cases [join [lappend cases [::STORM::TestCase info instances -closure]]]
}

::STORM::TestSuite xoSAMLTestSuite -detailed_report 1 -order [luniqueorder $cases]
xoSAMLTestSuite runAllTestCases
