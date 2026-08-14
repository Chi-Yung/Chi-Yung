# ============================================================
# Makefile for running SpyGlass (sg_shell) lint flow
# ============================================================

# SpyGlass shell 執行檔（若不在 PATH 中，改成完整路徑）
SG_SHELL    := sg_shell

# 要執行的 tcl script
TCL_SCRIPT  := run_shell.tcl

# top module 名稱（需與 run_shell.tcl 內一致，用於清除 .prj）
TOP_MODULE  := test_proc

# sg_shell log（依你 script 內容調整）
LOGS        := dashboard.log datasheet.log html.log spyglass.log

.PHONY: all run clean distclean

all: run

# 執行 lint flow
run:
	$(SG_SHELL) -tcl $(TCL_SCRIPT)

# 只清除 log，保留 project 檔
clean:
	rm -f $(LOGS)

# 清除 log + project 檔 + spyglass 產生的其他資料夾
distclean: clean
	rm -rf $(TOP_MODULE).prj
	rm -rf spyglass_reports spyglass_work