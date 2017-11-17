# Override the arch with `make ARCH=i386`
ARCH ?= $(shell flatpak --default-arch)
REPO ?= repo
REPO_NAME ?= local-endless-electron-apps

FLATPAKS = \
	io.atom.electron.BaseApp \
	io.atom.electron.DevApp \
	com.endlessm.ElectronKnowledgeBaseApp \
	com.endlessm.ElectronKnowledgeDevApp \
	$(NULL)

all: $(FLATPAKS)

.PHONY: $(FLATPAKS)

$(FLATPAKS): %: %.json ${REPO}
	flatpak-builder --force-clean --ccache --require-changes --repo=${REPO} --arch=${ARCH} \
		--subject="build of $@, `date`" \
		${EXPORT_ARGS} $@ $< && \
	flatpak install --user ${REPO_NAME} $@/${ARCH}/ || true && \
	flatpak --user update $@/${ARCH}/

io.atom.electron.DevApp: io.atom.electron.BaseApp

com.endlessm.ElectronKnowledgeBaseApp: io.atom.electron.BaseApp

com.endlessm.ElectronKnowledgeDevApp: io.atom.electron.DevApp

${REPO}:
	ostree init --mode=archive-z2 --repo=${REPO} && \
	flatpak --user remote-add --if-not-exists --no-gpg-verify ${REPO_NAME} ${REPO}

# Convenience to install dependencies
install-deps:
	if ! flatpak info --show-commit org.freedesktop.Platform/${ARCH}/1.6; then \
		flatpak --user remote-add --if-not-exists --from gnome https://sdk.gnome.org/gnome.flatpakrepo && \
		flatpak --user install gnome org.freedesktop.Platform/${ARCH}/1.6; \
	fi && \
	if ! flatpak info --show-commit org.freedesktop.Sdk/${ARCH}/1.6; then \
		flatpak --user remote-add --if-not-exists --from gnome https://sdk.gnome.org/gnome.flatpakrepo && \
		flatpak --user install gnome org.freedesktop.Sdk/${ARCH}/1.6; \
	fi
