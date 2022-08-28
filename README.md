# Ubuntu 20.04 toolbx images

Various ubuntu images that I use to setup my development environment using [containers/toolbx](https://github.com/containers/toolbox).

## Requirements

* make
* podman
* toolbx
* buildah (optional)

## Images
### Base image

This image contains a minimal ubuntu 20.04 cli installation ready to use with toolbx

To build this image, simply run:

```shell
make base
```

This will create the image `ubuntu-toolbox:20.04` on your podman installation. The following arguments can be changed:

* `UBUNTU_RELEASE`: by default, 20.04
* `IMAGE`: the name of the image tagged on your system

### CUDA

This image extends over the base image and generates a development environment with nvidia CUDA toolkit

To build this image, simply run:

```shell
make cuda
```

By default, will generate a installation with CUDA toolkit 10.1 and cudnn 7.6 libs provided in `bins` folder.

In addition to the arguments used in base image, the following arguments can be modified:

* `BASE_IMAGE`: base image, by default uses `$(IMAGE):$(UBUNTU_RELEASE)`
* `CUDA_RELEASE`: version of cuda toolkit to install, by default `10-1`
* `CUDA_PLATFORM`: target distro repos to use, in case of cuda 10, use `ubuntu1804`, for cuda 11 and later, use `ubuntu2004`
* `CUDNN_RELEASE`: version of cudnn libraries to install. Debian packages must be available on `bins/` directory. This files have a custom license and are behind a login wall on https://developer.nvidia.com/cudnn. By default, set to `7.6.5.32-1+cuda10.1`
    * `CUDNN_BRANCH`: major version number of the cudnn libraries, by default `7`.
* `BINARIES_DIR`: location of the directory with binaries in the build environment. By default `/data/bins`

### Dev

Development environment image that install varios crosscompiling and multimedia libraries.

To build this image, simply run:

```shell
make dev
```

By default this image will use the cuda devenv image as base.

On top of arguments accepted by previous images, the following additional parameters are available:

* `VIDEOSDK_RELEASE`: nvidia video codecs sdk version, by default `9.1.23.2`
* `OPENCV_RELEASE`: version of opencv built and installed, by default `4.5.5`
* `FFMPEG_RELEASE`: version of ffmpeg built and installed, by default `4.4.2`

## Use

This images are ready to use in [toolbx](https://github.com/containers/toolbox)

### Create your toolbox container:

```
[user@hostname ~]$ toolbox create -c test -i ubuntu-toolbox:20.04
Created container: test
Enter with: toolbox enter test
[user@hostname ~]$
```
This will create a container called `test` using the image `ubuntu-toolbox:20.04`.

### Enter the toolbox:

```
[user@hostname ~]$ toolbox enter test
⬢[user@toolbox ~]$ cat /etc/os-release 
NAME="Ubuntu"
VERSION="20.04.4 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.4 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
```