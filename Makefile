VIDEOSDK_RELEASE	?= 12.2.72.0
OPENCV_RELEASE		?= 4.9.0
FFMPEG_RELEASE		?= 7.0
UBUNTU_RELEASE		?= 24.04
CUDNN_RELEASE 		?= 8.9.7.29-1+cuda12.2
CUDA_PLATFORM		?= ubuntu2204
CUDA_ARCH_BIN		?= 8.6
CUDNN_BRANCH		?= 8
CUDA_RELEASE		?= 12-2
BINARIES_DIR		?= /data/bins
IMAGE				?= ubuntu-toolbox

.PHONY: base
base:
	podman build --rm --build-arg "RELEASE=$(UBUNTU_RELEASE)" -t $(IMAGE):$(UBUNTU_RELEASE) -f Dockerfile .

.PHONY: cuda
cuda: base
	podman build --rm -t $(IMAGE):$(UBUNTU_RELEASE)-cuda$(subst -,.,$(CUDA_RELEASE)) \
		--build-arg "BASE_IMAGE=$(IMAGE):$(UBUNTU_RELEASE)" \
		--build-arg "CUDA_PLATFORM=$(CUDA_PLATFORM)" \
		--build-arg "CUDNN_RELEASE=$(CUDNN_RELEASE)" \
		--build-arg "CUDNN_BRANCH=$(CUDNN_BRANCH)" \
		--build-arg "CUDA_RELEASE=$(CUDA_RELEASE)" \
		--build-arg "BINARIES_DIR=$(BINARIES_DIR)" \
		--build-arg "RELEASE=$(UBUNTU_RELEASE)" \
		-v $(CURDIR)/bins:$(BINARIES_DIR):ro,Z \
		-f Dockerfile.cuda .

.PHONY: dev
dev: cuda
	podman build --rm -t $(IMAGE):$(UBUNTU_RELEASE)-dev \
		--build-arg "BASE_IMAGE=$(IMAGE):$(UBUNTU_RELEASE)-cuda$(subst -,.,$(CUDA_RELEASE))" \
		--build-arg "VIDEOSDK_RELEASE=$(VIDEOSDK_RELEASE)" \
		--build-arg "OPENCV_RELEASE=$(OPENCV_RELEASE)" \
		--build-arg "FFMPEG_RELEASE=$(FFMPEG_RELEASE)" \
		--build-arg "CUDA_ARCH_BIN=$(CUDA_ARCH_BIN)" \
		-f Dockerfile.dev .

