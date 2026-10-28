# Build theme in container

image = docker.io/library/node:latest
podman = podman run --rm --pull=newer --userns=keep-id -e HOME=/tmp -v .:/app:Z -w /app
source = .vscode/settings.json
out = build

.PHONY: generate build clean

# Generate theme and settings parts from settings.json
generate:
	$(podman) --network=none $(image) node generate.js $(source)

# Package theme as .vsix
build: generate
	$(podman) $(image) sh -c "\
		cp package.json package-lock.json /tmp && \
		npm ci --prefix /tmp --ignore-scripts && \
		npm audit --prefix /tmp && \
		/tmp/node_modules/.bin/vsce package --out $(out)/"

clean:
	rm -rf $(out)
