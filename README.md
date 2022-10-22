# VoidWSL
Void Linux on WSL (Windows 10 FCU or later) based on [wsldl](https://github.com/yuk7/wsldl).
This project hosts both the GNU-libc and musl-libc Void Linux variants.

![screenshot](https://raw.githubusercontent.com/wiki/yuk7/wsldl/img/Arch_Alpine_Ubuntu.png)

[![Main CI Workflow](https://github.com/am11/VoidWSL/actions/workflows/main.yml/badge.svg)](https://github.com/am11/VoidWSL/actions/workflows/main.yml)
[![Github All Releases](https://img.shields.io/github/downloads/am11/VoidWSL/total.svg?style=flat-square)](https://github.com/am11/VoidWSL/releases/latest)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
![License](https://img.shields.io/github/license/am11/VoidWSL.svg?style=flat-square)

### [Download](https://github.com/am11/VoidWSL/releases/latest)


## Requirements
* Windows 10 1709 Fall Creators Update 64bit or later.
* Windows Subsystem for Linux feature is enabled.

## Install
#### 1. [Download](https://github.com/am11/VoidWSL/releases/latest) installer zip

#### 2. Extract all files in zip file to same directory

#### 3.Run Void.exe to Extract rootfs and Register to WSL
Exe filename is using to the instance name to register.
If you rename it you can register with a diffrent name and have multiple installs.


## How-to-Use(for Installed Instance)
#### exe Usage
```dos
Usage :
    <no args>
      - Launches the distro's default behavior. By default, this launches your default shell.

    run <command line>
      - Run the given command line in that distro.

    config [setting [value]]
      - `--default-user <user>`: Set the default user for this distro to <user>
      - `--default-uid <uid>`: Set the default user uid for this distro to <uid>
      - `--append-path <on|off>`: Switch of Append Windows PATH to $PATH
      - `--mount-drive <on|off>`: Switch of Mount drives

    get [setting]
      - `--default-uid`: Get the default user uid in this distro
      - `--append-path`: Get on/off status of Append Windows PATH to $PATH
      - `--mount-drive`: Get on/off status of Mount drives
      - `--lxuid`: Get LxUID key for this distro

    clean
     - Uninstalls the distro.

    help
      - Print this usage message.
```


#### How to uninstall instance
```dos
>Void.exe clean

```

## How-to-Build
VoidWSL can build on GNU/Linux or WSL.

`curl`,`zip`,`unzip`,`tar`(gnu) and `sudo` is required for build.
```shell
$ make
```
