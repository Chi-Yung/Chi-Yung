# ==== SpyGlass Makefile ====

SPYGLASS     := sg_shell
TCL_TEMPLATE := run_lint.tcl
GEN_DIR      := gen
GEN_TCL      := $(GEN_DIR)/run_lint_$(TOP_MODULE).tcl
LOG_DIR      := logs
LOG_FILE     := $(LOG_DIR)/spyglass_$(TOP_MODULE)_$(shell date +%Y%m%d_%H%M%S).log

.PHONY: lint clean help

lint:
ifndef TOP_MODULE
	$(error 請指定 TOP_MODULE，例如: make lint TOP_MODULE=my_top)
endif
	@mkdir -p $(GEN_DIR) $(LOG_DIR)
	@sed 's/{TOP_module}/$(TOP_MODULE)/g' $(TCL_TEMPLATE) > $(GEN_TCL)
	$(SPYGLASS) -tcl $(GEN_TCL) -batch -log $(LOG_FILE)

clean:
	rm -rf $(GEN_DIR) $(LOG_DIR) spyglass_reports rule_status* *.rpt sg_*

help:
	@echo "用法: make lint TOP_MODULE=<top層模組名稱>"