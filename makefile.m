# ===== 參數設定 =====
TOP       = tb_usb_pd
FILELIST  = file_list.f
FSDB_NAME ?= sim_out.fsdb

# ===== 目錄 =====
WORK_DIR   = work
RESULT_DIR = result

# ===== VCS 編譯選項 =====
VCS_OPTS = -full64 \
           -timescale=1ns/1ps \
           -Mdir=$(WORK_DIR) \
           -o $(WORK_DIR)/simv \
           -l $(RESULT_DIR)/compile.log \
           +define+FSDB_DUMP \
           +define+MAX_ST=48000

# ===== 執行選項 =====
SIM_OPTS = +FSDB=$(RESULT_DIR)/$(FSDB_NAME) \
           -l $(RESULT_DIR)/sim.log

# ===== 目標 =====
all: compile run

compile:
	mkdir -p $(WORK_DIR) $(RESULT_DIR)
	vcs -f $(FILELIST) -top $(TOP) $(VCS_OPTS)

run:
	$(WORK_DIR)/simv $(SIM_OPTS)

clean:
	rm -rf $(WORK_DIR) $(RESULT_DIR)

.PHONY: all compile run clean