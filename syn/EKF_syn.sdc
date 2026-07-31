set case_analysis_with_logic_constants true

#Setting Clock Constraints
create_clock -name clk -period 10  [get_ports clk] 
set_dont_touch_network  [get_clocks clk]
set_fix_hold            [get_clocks clk]
set_clock_uncertainty       0.3   [get_clocks clk]
set_clock_latency           2     [get_clocks clk] 
set_input_transition        0.5   [all_inputs]
set_clock_transition        0.3   [all_clocks]

set_operating_conditions -min_library fast -min fast -max_library slow -max slow 
set_wire_load_model -name tsmc090_wl10 -library slow
set_wire_load_mode  top
set_flatten false

set_driving_cell -library tpzn090gv3wc -lib_cell PDIDGZ_33 -pin {C} [all_inputs ]
set_load [load_of "tpzn090gv3wc/PDO16CDG_33/I"] [all_outputs ]
set_input_delay -clock clk -max 5 [all_inputs ]
set_output_delay -clock clk -max 3 [all_outputs ]

#set_dont_touch [get_cells ipad_*]
#set_dont_touch [get_cells opad_*]
set_ideal_network [get_ports clk]
set_ideal_network [get_ports rst]
uniquify

set_max_area 0
