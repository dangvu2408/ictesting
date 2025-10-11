###########################################################################
# TCL script for ModelSim to automatically generate virtual functions
# and virtual types for a Verilog design since Verilog has no
# enumerated types which makes state machines a pain to investigate
# in ModelSim.
#
# Tested with ModelSim SE 6.2g
###########################################################################
#
# Version 1.0
#
# AUTHOR:
#   Andreas Ehliar <ehliar@isy.liu.se>
#
# USAGE:
#   Either source it by hand in ModelSim or add it to the modelsim.tcl
#   file.
#
# BUGS:
#   The menu entry is not added to the wave window unless the wave window
#   is undocked from the main window. Nothing stops you from running
#   modify_state_variables directly from the vsim prompt however.
#   
# CAUTION:
#   Note that many undocumented ModelSim functions are used in this file,
#   it is likely that future ModelSim versions will handle the wave window
#   internal functions differently.
#
###########################################################################
# Copyright (c) 2007, Andreas Ehliar
# This file is distributed under the new BSD license without the
# advertising clause.
###########################################################################


# Keep track of a unique number we can use to create our own virtual types
set usertypenum 0

proc modify_state_variables {} {
    global usertypenum
    global WildcardFilter
    set wave [view wave]
    set selection [$wave.tree cursel]

    # Save previous value of WildcardFilter
    set PrevFilter $WildcardFilter
    # We don't want to find Parameters in the find command below
    set WildcardFilter Parameter

    # We use a catch block here because we really want to set WildcardFilter
    # back to the previous value if something goes wrong.
    if { [catch {
	set state_variables {}
	set state_parameters {}
	
	foreach i $selection {
	    set thename [$wave.tree itemname $i]
	    if { [find signals $thename] ne "" } {
		lappend state_variables [list $thename $i]
	    } else {
		lappend state_parameters $thename
	    }
	}

	if {[llength $state_parameters] == 0} {
		echo "Error: No state parameters/localparams, not doing anything more"
        } else {
	    
	    set typeinfo {}
	    foreach param $state_parameters {
		set tmp [split "$param" /]
		set basename [lindex "$tmp" [expr [llength "$tmp"]-1]]
		
		lappend typeinfo [list "16\#[examine -hexadecimal $param]" $basename ]
	    }

	    lappend typeinfo [list default "**UNKNOWN**"]

	    virtual type "$typeinfo" usertype$usertypenum
	    
	    foreach statevar $state_variables {
		set index [lindex $statevar 1]
		set statevar [lindex $statevar 0]
		set tmp [split "$statevar" /]
		set basename [lindex "$tmp" [expr [llength "$tmp"]-1]]

		# My experiments indicate that the itemtype of an enumeration is 2002
		# This check is here because ModelSim crashes hard
		# if we try to enumerate an enumeration...
		if { [$wave.tree itemtype $index] == 2002 } {
		    echo "Cowardly refusing to enumerate an enumeration ($statevar)"
		} else {
		    echo "Enumerating $statevar"
		    virtual function " (usertype${usertypenum})$statevar" ${basename}_type$usertypenum
		    $wave.tree delete $index
		    # I have to use this undocumented function here instead of the official add wave approach
		    # since I cannot specify a certain index to add wave
		    $wave.tree insert $index -label $basename ${statevar}_type$usertypenum 
		}
	    }
	    
	    set usertypenum [expr $usertypenum + 1]
	}
    } errmsg] } {
# Catch any error (most likely with a virtual type that already
# exists such as if fsmhelper.do is sourced twice and usertype is
# reset to 0
	echo "Error: Failed to enumerate: \"$errmsg\""
    }

    set WildcardFilter $PrevFilter
    # Restore WildcardFilter
    return ""
}

proc AddFsmhelperButton winname {
    set wave [view wave]
    $wave.wavenameareapopup_popup add separator
    $wave.wavenameareapopup_popup add command -label "Enumerate states" -command {modify_state_variables}
#    echo "State Enumerate menu added succesfully (v1.0)"

# Use something like the below if you prefer a button (or if the above command doesn't work for you)
#    _add_menu $winname controls right \#d9d9d9 black {Fix state variables} {modify_state_variables}
}

# Unfortunately this hook will not be called until the user clicks the
# button that opens the wave view in a separate window instead of
# inside the ModelSim main window...
lappend PrefWave(user_hook) AddFsmhelperButton
