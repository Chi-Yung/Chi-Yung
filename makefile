.PHONY:clean vcs_kdb vcs_cov verdi_kdb verdi_cov

VCS = Rvcs
VERDI = Rverdi

#***** coverage option *****
COV_METRICS_SEL = line+cond+fsm+branch
#COV_METRICS_SEL = line+cond+fsm+branch+tgl  #for postsim


#***** VCS compile option *****
VCS_COMP_OPT =				\
			-full64			\
			-debug_acc+all	\
			-j4				\
			-lca			\
			-kdb			\
			-sverilog		\
			-Xkeyopt=rtopt	\
			-Mupdate		\
			-R   			\
			+v2k			\
			
			
#***** VCS simulate option *****
VCS_SIM_OPT =					\
			+vcs+fsdbon			\
			-timescale=1ns/1ps	\
			-l ./logfile/vcs_kdb_compiled.logfile/vcs_kdb_compiled\
			+vcs_flush+all		\
			
			
#***** VCS coverage option *****
VCS_COV_OPT =						\
			-cm	$(COV_METRICS_SEL)	\
			-cm_log	./logfile/vcs_cov_$(COV_METRICS_SEL)_compiled.log	\
			-cm_dir ./coverage/coverage.vdb							\
			-cm_name coverage
			
				
#***** VCS compilation  *****		
vcs_kdb:			
		$(VCS)				\
		$(VCS_COMP_OPT)		\
		$(VCS_SIM_OPT)		\
		-file filelist.f	\
		
vcs_cov:
		$(VCS)				\
		$(VCS_COMP_OPT)		\
		$(VCS_SIM_OPT)		\
		$(VCS_COV_OPT)		\
		-file filelist.f	\
		

#***** Verdi compilation  *****
verdi_kdb:
		$(VERDI) -f filelist.f -ssf novas.fsdb

verdi_cov:
	    $(VERDI) -cov -covdir ./coverage/coverage.vdb
		
		
clean:
       rm -rf unrSimv* csrc* ./logfile/* *key *fsdb *vcd *Log *bak *el *report no_trace* *.dump
	   rm -rf simv* verdi_* partition* dprof* clk* *DB *dir work *lib *.daidir nWave* DVE* *.out
	   rm -rf novas* cm.* ./coverage/* *.log *.vdb