catch { file mkdir work }
catch { file mkdir reports }
catch { file mkdir netlist }

set TOP CHIP
set_svf netlist/${TOP}_syn.svf


# ---------------------------------------------------------------------
# Set variables 
# ---------------------------------------------------------------------
set hdlin_translate_off_skip_text "TRUE"
set hdlin_enable_presto_for_vhdl "TRUE"
set enable_recovery_removal_arcs true
set remove_unloaded_register true
set remove_constant_register true
set compile_delete_unloaded_sequential_cells true
set high_fanout_net_threshold 0

# ---------------------------------------------------------------------
# Set library
# ---------------------------------------------------------------------
define_design_lib -path work work
# ---------------------------------------------------------------------
# Read designs
# ---------------------------------------------------------------------
analyze -format Verilog ./rtl_32_FSM/CHIP.v -library work
analyze -format Verilog ./rtl_32_FSM/TOP.v -library work
analyze -format Verilog ./rtl_32_FSM/Control_Unit.v -library work
analyze -format Verilog ./rtl_32_FSM/EKF.v -library work
analyze -format Verilog ./rtl_32_FSM/single_adder.v -library work
analyze -format Verilog ./rtl_32_FSM/single_multiplier.v -library work
analyze -format Verilog ./rtl_32_FSM/single_divider.v -library work

elaborate -library work ${TOP}

#current_design ${TOP}
current_design [get_designs CHIP]
link
uniquify

set_min_library slow.db -min_version fast.db


# ---------------------------------------------------------------------
# Set constraints
# ---------------------------------------------------------------------
set_dont_touch [get_cells ipad_*] true
set_dont_touch [get_cells opad_*] true
set_dont_touch_network -no_propagate [ get_nets -of_objects [get_pins ipad_*/PAD] ]
set_dont_touch_network -no_propagate [ get_nets -of_objects [get_pins opad_*/PAD] ]

source -v -e sdc/EKF_syn.sdc
#set_critical_range 0.5 [current_design]

check_timing > reports/check_timing.rpt

# ---------------------------------------------------------------------
# Run synthesis
# ---------------------------------------------------------------------

set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
set_max_area 0.0
set power_default_toggle_rate 0.05

compile_ultra -no_seq_output_inversion -no_autoungroup -no_boundary_optimization
compile_ultra -no_seq_output_inversion -no_autoungroup -no_boundary_optimization -incr

remove_unconnected_ports -blast_buses [get_cells -hierarchical *]
set bus_inference_style {%s[%d]}
set bus_naming_style {%s[%d]}
set hdlout_internal_busses true
change_names -hierarchy -rule verilog
define_name_rules name_rule -allowed {a-z A-Z 0-9 _} -max_length 255 -type cell
define_name_rules name_rule -allowed {a-z A-Z 0-9 _[]} -max_length 255 -type net
define_name_rules name_rule -map {{"\*cell\*" "cell"}}
define_name_rules name_rule -case_insensitive

change_names -hierarchy -rules name_rule

# ---------------------------------------------------------------------
# Write results
# ---------------------------------------------------------------------
report_area > reports/${TOP}_area.rpt
report_timing -max_paths 100 -nosplit > reports/${TOP}_timing.rpt
report_constraint -all_violators -nosplit > reports/${TOP}.cstr
report_power -hierarchy > reports/${TOP}_power.rpt
report_qor > reports/${TOP}.qor

# write net name
# ---------------------------------------------------------------------
set wfid [open reports/net_name_post.rpt w]
foreach_in_collection net [get_net * -h] {
    set netName [get_object_name $net]
    puts $wfid $netName
}
close $wfid

write -format verilog -hierarchy -output netlist/${TOP}_syn.v
write -format ddc -hierarchy -output netlist/${TOP}_syn.ddc
write_sdf -version 2.1 -context verilog -load_delay net netlist/${TOP}_syn.sdf
write_sdc netlist/${TOP}_syn.sdc

exit