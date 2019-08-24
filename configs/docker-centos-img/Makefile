SRPM ?= "git-2.3.0-1.el7.centos.src.rpm"
SRPM_URL ?= "https://copr-be.cloud.fedoraproject.org/results/snoopotic/git-rpms/epel-7-x86_64/git-2.3.0-1.el6/git-2.3.0-1.el7.centos.src.rpm"
MOUNT ?= "/tmp/rpmbuild/"
MOCK_CONFIG ?= "epel-6-i386"
IMAGE_NAME ?= "centos-mock:latest"
PATH_TO_FILE=/tmp/rpmbuild/$(SRPM)

export $(MOUNT)

all:
	docker build -t $(IMAGE_NAME) .
srpm:
	@echo $(SRPM)
	@echo $(PATH_TO_FILE)
	@if test -f $(PATH_TO_FILE); then echo SRPM exists; else echo Error: No SRPM && exit 1; fi
	docker run --privileged -e MOCK_CONFIG=$(MOCK_CONFIG) \
		-e SOURCE_RPM=/rpmbuild/$(SRPM) \
		-v $(MOUNT):/rpmbuild $(IMAGE_NAME)
	@echo "RPMs generated at $(MOUNT)/output/"
test:
	@echo Testing the build system with upstream $(SRPM) from $(SRPM_URL)
	@if test -f $(PATH_TO_FILE); then echo SRPM exists; else wget $(SRPM_URL) -P $(MOUNT); fi
	docker run --privileged -e MOCK_CONFIG=$(MOCK_CONFIG) \
		-e SOURCE_RPM=/rpmbuild/$(SRPM) \
		-v $(MOUNT):/rpmbuild $(IMAGE_NAME)
	@echo "RPMs generated at $(TMP_MOUNT)/output/"
debug:
	docker run --privileged -e MOCK_CONFIG=$(MOCK_CONFIG) \
		-e SOURCE_RPM=/rpmbuild/$(SRPM) \
		-v $(MOUNT):/rpmbuild -it $(IMAGE_NAME) /bin/bash
	@echo "RPMs generated at $(MOUNT)/output/"
clean:
	rm -rf $(MOUNT)/output
