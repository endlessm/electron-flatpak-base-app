# electron-flatpak-base-app
Base application for building electron flatpaks.

## Overview
This project contains a recipe for building the library dependencies of an
[electron](http://electron.atom.io/) app for use with [flatpak](http://flatpak.org/).

It helps to be familiar with the anatomy of a flatpak to understand this
project. The base app you can build here is not independently useful, but will
contain all library dependencies of an electron app inside of `/app` for use
with the freedesktop runtime. An actual electron app can then add its
application binaries and assets to `/app` to produce a functioning flatpak.
[flatpak-builder](http://flatpak.org/flatpak/flatpak-docs.html#flatpak-builder)
supports the `base` and `base-version` manifest properties for this purpose.

By distributing the library requirements as a base application and not a runtime
we can still allow the freedesktop runtime to handle things like critical
security updates. If multiple electron apps are built against the same
version of the base app, the libraries will still be deduplicated on disk when
installed on a user machine.

## Building
Building the base app requires flatpak to be installed on your system. It builds
on top of the freedesktop runtime and requires both org.freedesktop.Platform and
org.freedesktop.Sdk to be installed.

The freedesktop runtime is available from the GNOME runtime repository. If you
are working from a completely clean system, you can run `make install-deps` to
automatically configure the gnome remote for you and install the required
runtimes. If you already have a gnome remote configured, just install from that.

Once all the dependencies are installed just run `make` to build the base app.
You can use the following environment variables to configure the build.
 - ARCH: architecture to use when building the base application. You must
   have the freedesktop runtimes installed for the same architecture.
 - REPO: the location of the flatpak repository to publish the base app to.
   Defaults to `repo` wherever `make` is run.
 - EXPORT_ARGS: extra arguments to use when exporting the application with
   `flatpak-builder`, such as `--gpg-sign=KEYID` for gpg signing.

## Using
Once the application is installed run the following to install.
```shell
flatpak --user remote-add --no-gpg-verify local-electron repo
flatpak --user install local-electron io.atom.electron.BaseApp
```
The base app on its own will not do anything, but it can be used as a starting
point for an actual electron app. You can specify it in a `flatpak-builder`
manifest file.
```json
{
    "id": "com.website.SomeApp",
    "base": "io.atom.electron.BaseApp",
    "base-verson": "master",
    "runtime": "org.freedesktop.Platform",
    "runtime-version": "1.4",
    "sdk": "org.freedesktop.Sdk",
    ...
```
Your installed version of flatpak must be greater than 0.6.13 to use the base
app property.
