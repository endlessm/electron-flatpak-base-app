**Obsolete**, superseded by https://github.com/flathub/org.electronjs.Electron2.BaseApp and https://github.com/flathub/io.atom.electron.BaseApp.

# electron-flatpak-base-app
This repo contains flatpak builder manifests for building a number of
applications to help with electron flatpak development.

Built versions for x86_64, i386 and arm are hosted on [Flathub](https://flathub.org).

To get started with the electron base app for your current architecture.
```
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.atom.electron.BaseApp
```

## Apps
The most useful app here will probably be the `io.atom.electron.BaseApp`
which can be layered into your flatpak electron app with all the library
dependencies electron needs to run. For a high level overview of flatpak,
electron and the applications here see.

#### General Apps
 - **io.atom.electron.BaseApp**: contains all the library dependencies of an
   electron application, allowing your app to target the freedesktop runtime.
   Should be suitable for targeting *any* linux distribution.
 - **io.atom.electron.DevApp**: layered on top of the base app, this application
   contains flatpak, git and nodejs installed. You can use it to build electron
   flatpaks on a system where either git or nodejs is not available.

#### EndlessOS Apps
 - **com.endless.ElectronKnowledgeBaseApp**: layered on top of the base app,
   contains the library dependencies needed to build offline content browsing
   apps for EndlessOS.
 - **com.endless.ElectronKnowledgeDevApp**: adds flatpak, git and nodejs to
   the ElectronKnowledgeBaseApp. You can build EndlessOS content browsing
   flatpaks from within this app.

## Building
Building the apps require `flatpak` and `flatpak-builder` to be installed on
your system. You will also need the freedesktop runtime, which if you don't
already have, can be installed by running
```
make install-deps
```

Any of the app manifests can be built directly using the `flatpak-builder`
command. The makefile contains a recipe for building all the apps in this
repo sequentially, to do so just run
```
make
```

You can use the following environment variables to configure the build.
 - ARCH: architecture to use when building the base application. You must
   have the freedesktop runtimes installed for the same architecture.
 - REPO: the location of the flatpak repository to publish the base app to.
   Defaults to `repo` wherever `make` is run.
 - REPO_NAME: the name to use when setting up a local flatpak remote for the
   repo. Default to `local-endless-electron-apps`.
 - EXPORT_ARGS: extra arguments to use when exporting the application with
   `flatpak-builder`, such as `--gpg-sign=KEYID` for gpg signing.

## Using
You can use the base app to build an electron application flatpak. One way to do
this is to specify it in a `flatpak-builder` manifest file.
```json
{
    "id": "com.website.MyElectronApp",
    "base": "io.atom.electron.BaseApp",
    "base-version": "master",
    "runtime": "org.freedesktop.Platform",
    "runtime-version": "1.6",
    "sdk": "org.freedesktop.Sdk",
```
