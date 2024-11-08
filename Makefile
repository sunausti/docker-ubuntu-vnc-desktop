.PHONY: build run

# Default values for variables
REPO  ?= ubuntu-desktop-lxde-vnc-realsense
TAG   ?= v0.1
# you can choose other base image versions
IMAGE ?= ubuntu:20.04
# IMAGE ?= nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
# choose from supported flavors (see available ones in ./flavors/*.yml)
FLAVOR ?= lxde
# armhf or amd64
ARCH ?= amd64
LIBRS_VERSION=2.56.2

# These files will be generated from teh Jinja templates (.j2 sources)
templates = Dockerfile rootfs/etc/supervisor/conf.d/supervisord.conf

# Rebuild the container image
build: $(templates)
	docker build --build-arg LIBRS_VERSION=${LIBRS_VERSION} -t $(REPO):$(TAG) .

# Test run the container
# the local dir will be mounted under /src read-only
run:
	docker rm -f realsense-lxde \
	&& docker run -p 6080:80 -p 5900:5900 \
	-v /dev:/dev \
	--device-cgroup-rule "c 81:* rmw" \
	--device-cgroup-rule "c 189:* rmw" \
	--name realsense-lxde \
	$(REPO):$(TAG)


# Connect inside the running container for debugging
shell:
	docker exec -it ubuntu-desktop-lxde-test bash

# Generate the SSL/TLS config for HTTPS
gen-ssl:
	mkdir -p ssl
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout ssl/nginx.key -out ssl/nginx.crt

clean:
	rm -f $(templates)

extra-clean:
	docker rmi $(REPO):$(TAG)
	docker image prune -f

