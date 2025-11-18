###############################################################################
# pin_assign.tcl
#
# This script allows you to make pin assignments to the Ledtest design
#
# Written by: Yuchang.Lin
# Rev 1.0
# 2005/04/10
#
# You can run this script from Quartus by observing the following steps:
# 1. Place this TCL script in your project directory
# 2. Open your project
# 3. Go to the View Menu and Auxilary Windows -> TCL console
# 4. In the TCL console type:
#						source pin_assign.tcl
# 5. The script will assign pins.
###############################################################################
set project_name max2_test
set top_name max2_test
cmp add_assignment $top_name "" "" DEVICE EPM1270T144C5ES

########## Set the pin location variables ############
### Control Pins
set clk 18
set rst 23
set en  24
set sw3 27
set sw4 28
set dip {22 21 16 15 14 13 12 11}
set seven_seg {37 38 39 40 41 42 43 44}
set dig1 29
set dig2 30
set dig3 31
set dig4 32
set led {1 2 3 4 5 6 7 8}

################################################
#### Make the clock, reset and u_d signal assignments
cmp add_assignment $top_name "" clk LOCATION "Pin_$clk"
cmp add_assignment $top_name "" rst LOCATION "Pin_$rst"
cmp add_assignment $top_name "" en LOCATION "Pin_$en"
cmp add_assignment $top_name "" sw3 LOCATION "Pin_$sw3"
cmp add_assignment $top_name "" sw4 LOCATION "Pin_$sw4"
cmp add_assignment $top_name "" dig1 LOCATION "Pin_$dig1"
cmp add_assignment $top_name "" dig2 LOCATION "Pin_$dig2"
cmp add_assignment $top_name "" dig3 LOCATION "Pin_$dig3"
cmp add_assignment $top_name "" dig4 LOCATION "Pin_$dig4"

#################################################
#### Make the sel and led assignments
set i 0
foreach {a} $dip {
	cmp add_assignment $top_name "" "dip\[$i\]" LOCATION "Pin_$a" 
	set i [expr $i+1]
}
set i 0
foreach {a} $seven_seg {
	cmp add_assignment $top_name "" "seven_seg\[$i\]" LOCATION "Pin_$a" 
	set i [expr $i+1]
}
set i 0
foreach {a} $led {
	cmp add_assignment $top_name "" "led\[$i\]" LOCATION "Pin_$a" 
	set i [expr $i+1]
}
