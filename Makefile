# Build theme in container

image = docker.io/library/node:latest
podman = podman run --rm --pull=newer --userns=keep-id -e HOME=/tmp -v .:/app:Z -w /app
source = .vscode/settings.json
out = build
# Patched vsce dependency
overrides = overrides[@azure/msal-node]=^7.1.2

.PHONY: generate build clean

# Generate theme and settings parts from settings.json
generate:
	$(podman) --network=none $(image) node generate.js $(source)

# Package theme as .vsix
build: generate
	$(podman) $(image) sh -c "\
		cd /tmp && \
		npm init -y && \
		npm pkg set '$(overrides)' && \
		npm install --ignore-scripts @vscode/vsce && \
		npm audit && \
		cd /app && \
		/tmp/node_modules/.bin/vsce package --out $(out)/"

clean:
	rm -rf $(out)
