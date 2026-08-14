# ============================================================
# Makefile for running SpyGlass (sg_shell) lint flow
# ============================================================

# SpyGlass shell 執行檔（若不在 PATH 中，改成完整路徑）
SG_SHELL    := sg_shell

# 要執行的 tcl script
TCL_SCRIPT  := run_shell.tcl

# top module 名稱：預設 test_proc
# 可用 `make run top_module=top` 覆寫（小寫變數優先）
top_module  ?= test_proc
TOP_MODULE  := $(top_module)

# sg_shell log（依你 script 內容調整）
LOGS        := dashboard.log datasheet.log html.log spyglass.log

.PHONY: all run clean distclean

all: run

# 動態產生的 wrapper tcl（設定 top_module 後 source 原本的 run_shell.tcl）
WRAPPER     := .run_top.tcl

# 執行 lint flow：先產生 wrapper，再用 -tcl 執行 wrapper（-tcl 吃檔案最保險）
run:
	@echo "set top_module $(TOP_MODULE)"  > $(WRAPPER)
	@echo "source $(TCL_SCRIPT)"         >> $(WRAPPER)
	$(SG_SHELL) -tcl $(WRAPPER)
	@rm -f $(WRAPPER)

# 只清除 log，保留 project 檔
clean:
	rm -f $(LOGS)

# 清除 log + project 檔 + spyglass 產生的其他資料夾
distclean: clean
	rm -rf $(TOP_MODULE).prj
	rm -rf spyglass_reports spyglass_work