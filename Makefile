.PHONY: install uninstall dry-run test lint fmt

SHELL_FILES := install.sh tests/*.sh

install:
	./install.sh

uninstall:
	./install.sh --uninstall

dry-run:
	./install.sh --dry-run

test:
	./tests/run.sh

lint:
	shellcheck $(SHELL_FILES)
	stylua --check nvim

fmt:
	stylua nvim
