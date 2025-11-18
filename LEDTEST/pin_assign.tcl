##################################################################
# pin_assign.tcl
#
# This script allows you to make pin assignments to the Ledtest design
#
# Written by: Hans.Lin
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
##################################################################
set_location_assignment PIN_18 -to clk
set_location_assignment PIN_23 -to rst
set_location_assignment PIN_24 -to u_d
set_location_assignment PIN_27 -to sel\[0\]
set_location_assignment PIN_28 -to sel\[1\]
set_location_assignment PIN_1 -to led\[0\]
set_location_assignment PIN_2 -to led\[1\]
set_location_assignment PIN_3 -to led\[2\]
set_location_assignment PIN_4 -to led\[3\]
set_location_assignment PIN_5 -to led\[4\]
set_location_assignment PIN_6 -to led\[5\]
set_location_assignment PIN_7 -to led\[6\]
set_location_assignment PIN_8 -to led\[7\]
