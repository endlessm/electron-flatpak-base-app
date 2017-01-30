# electron-flatpak-dev-app
Development application for building electron flatpaks

## Overview
This application includes all the dependencies needed for electron app development
packaged in a flatpak application.

## Developing on EndlessOS
This app can be used to allow electron app development on EndlessOS, where nodejs
and git will not be available on the system by default. We will detail an
example of doing this with a tool called [electron-forge](https://github.com/electron-userland/electron-forge).
EndlessOS version 3.1 is required.

### Installing flatpak application dependencies
First download the electron base app and dev app from the endless electron
repository.
```shell
flatpak install gnome org.freedesktop.Platform//1.4
flatpak --user remote-add endless-electron-apps --from https://s3-us-west-2.amazonaws.com/electron-flatpak.endlessm.com/endless-electron-apps.flatpakrepo
flatpak --user install endless-electron-apps io.atom.electron.BaseApp io.atom.electron.DevApp
```

Now you can run the dev app in a terminal to pull up a bash shell with nodejs
available.
```shell
flatpak run io.atom.electron.DevApp
```
With this command you are now running inside a flatpak sandbox with development
tools available. You can test this by running `node --version`, future commands
in this document will be run from inside the dev application bash shell.

### Installing electron-forge
Next we will install the electron-forge tool globally for development. There
are many ways to configure npm to install packages globally, but we suggest
setting up a directory in your home dir, as [described by npm here](https://docs.npmjs.com/getting-started/fixing-npm-permissions#option-2-change-npms-default-directory-to-another-directory).

Once npm is configured, you can get started using electron forge
```shell
npm install -g electron-forge
electron-forge init my-new-app
cd my-new-app
electron-forge start
```
You should see your new electron application window pop up!

### Setting up you app for flatpak distribution
Finally, we need to set up your new app for flatpak distribution. In your new
app directory, open up your `package.json` file. In the "make-targets" section, replace
```
"linux": [
  "deb",
  "rpm"
]
```
with
```
"linux": [
  "flatpak"
]
```

That's it! You can now run
```shell
electron-forge make
```
To build your application as a flatpak. You should find your app in the
`out/make` for your new app, e.g. `out/make/io.atom.electron.my-new-app_master_x86_64.flatpak`

### Get developing!
As you develop, you can just run
```shell
electron forge start
```
to quickly test changes to your app.

If you want to test your built flatpak, open a new terminal outside of the dev
app sandbox, and run
```shell
flatpak --user install --bundle out/make/io.atom.electron.my-new-app_master_x86_64.flatpak
flatpak run io.atom.electron.my-new-app
```

See the [electron-forge documentation](https://github.com/electron-userland/electron-forge)
for details on how to publish your app directly to github.

See the [electron-forge templates](https://beta.electronforge.io/templates) to
get started using react, angular, jade and other common web frameworks.
