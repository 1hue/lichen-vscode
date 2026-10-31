.PHONY: generate build install setup sh clean

# Colours when run in terminal - vsce never exits with terminal attached
COLOR := $(shell [ -t 0 ] && echo --env=FORCE_COLOR=1)
RUN = podman run --rm $(COLOR) -e TERM --pull=newer --userns=keep-id -e HOME=/tmp
# No network
RUN_OFFLINE = $(RUN) --network=none
# Image with project mount
NODE = -v .:/app:Z -w /app docker.io/library/node:latest

# Which VSCode binary
VSCODE ?= codium

SOURCE = .vscode/settings.json
VSIX = build/lichen-theme.vsix

# Generate theme and settings parts from settings.json
generate:
	$(RUN_OFFLINE) $(NODE) node generate.ts $(SOURCE)

# Package theme as .vsix
build: generate | node_modules
	$(RUN_OFFLINE) $(NODE) node_modules/.bin/vsce package --out $(VSIX)

install: build
	$(VSCODE) --install-extension $(VSIX) --force

# Install deps and audit
setup:
	$(RUN) $(NODE) sh -c 'npm ci --ignore-scripts && npm audit'

# Install deps when missing
node_modules:
	$(MAKE) setup

# Shell into container with Debian colours
sh:
	$(RUN) -it $(NODE) bash --rcfile /etc/skel/.bashrc

clean:
	rm -rf build
