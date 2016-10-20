# Override the arch with `make ARCH=i386`
ARCH ?= $(shell flatpak --default-arch)
REPO ?= repo

all: ${REPO}
	flatpak-builder --force-clean --ccache --require-changes --repo=${REPO} --arch=${ARCH} \
		--subject="build of io.atom.electron.BaseApp, `date`" \
		${EXPORT_ARGS} build io.atom.electron.BaseApp.json

${REPO}:
	ostree  init --mode=archive-z2 --repo=${REPO}
