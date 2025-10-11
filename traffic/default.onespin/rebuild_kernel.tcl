cd /home/minh/win-data/Minh/Teaching/Hardware Design Verification/verif-class/traffic
read_verilog -golden -pragma_ignore {} -version sv2009 {/home/minh/win-data/Minh/Teaching/Hardware\ Design\ Verification/verif-class/traffic/traffic-fsm.v } 
elaborate -golden 
compile -golden 
set_mode mv 
check_assertion {sva/mutex_green} 
