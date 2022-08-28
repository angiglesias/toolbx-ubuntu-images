VIDEOSDK_RELEASE	?= 9.1.23.2
OPENCV_RELEASE		?= 4.5.5
FFMPEG_RELEASE		?= 4.4.2
UBUNTU_RELEASE		?= 20.04
CUDNN_RELEASE 		?= 7.6.5.32-1+cuda10.1
CUDA_PLATFORM		?= ubuntu1804
CUDNN_BRANCH		?= 7
CUDA_RELEASE		?= 10-1
BINARIES_DIR		?= /data/bins
IMAGE			?= ubuntu-toolbox

.PHONY: base
base:
	podman build --build-arg "RELEASE=$(UBUNTU_RELEASE)" -t $(IMAGE):$(UBUNTU_RELEASE) -f Dockerfile .

.PHONY: cuda
cuda: base
	podman build -t $(IMAGE):$(UBUNTU_RELEASE)-cuda$(subst -,.,$(CUDA_RELEASE)) \
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
	podman build -t $(IMAGE):$(UBUNTU_RELEASE)-dev \
		--build-arg "BASE_IMAGE=$(IMAGE):$(UBUNTU_RELEASE)-cuda$(subst -,.,$(CUDA_RELEASE))" \
		--build-arg "VIDEOSDK_RELEASE=$(VIDEOSDK_RELEASE)" \
		--build-arg "OPENCV_RELEASE=$(OPENCV_RELEASE)" \
		--build-arg "FFMPEG_RELEASE=$(FFMPEG_RELEASE)" \
		-f Dockerfile.dev .

