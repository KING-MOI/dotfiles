.PHONY: install uninstall dry-run brew test lint fmt

SHELL_FILES := install.sh tests/*.sh

install:
	./install.sh

uninstall:
	./install.sh --uninstall

dry-run:
	./install.sh --dry-run

brew:
	brew bundle --file brew/Brewfile

test:
	./tests/run.sh

lint:
	shellcheck $(SHELL_FILES)
	stylua --check nvim

fmt:
	stylua nvim
