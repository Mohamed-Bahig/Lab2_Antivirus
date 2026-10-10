DIR = dir
MALICIOUS_DIR = malicious_dir
INTERVAL = 5

# first target = what plain "make" runs
run: setup
	bash ./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)

restore: setup
	bash ./restore.sh $(DIR) $(MALICIOUS_DIR)

# pre-build step
setup:
	mkdir -p $(MALICIOUS_DIR)

.PHONY: run restore setup
