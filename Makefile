.PHONY: install uninstall dry-run

install:
	./install.sh

uninstall:
	./install.sh --uninstall

dry-run:
	./install.sh --dry-run
