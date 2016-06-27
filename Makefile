.PHONY: clean default

VERSION=0.1

default: build/rpmbuild/RPMS/x86_64/ceph-mesos-$(VERSION)-1.x86_64.rpm

clean:
	rm -rf build/rpmbuild/SOURCES
	rm -rf build/ceph-mesos/build

build/ceph-mesos:
	mkdir -p build && cd build && git clone https://github.com/Intel-bigdata/ceph-mesos.git

image-built: Dockerfile
	docker build --tag ceph-mesos-builder .
	touch $@

build/ceph-mesos/build/Makefile: image-built build/ceph-mesos
	docker run -it --rm -v $(PWD)/build:/build ceph-mesos-builder bash -c "cd /build/ceph-mesos && mkdir -p build && cd build && cmake .."

build/ceph-mesos/build/ceph-mesos: build/ceph-mesos/build/Makefile
	docker run -it --rm -v $(PWD)/build:/build ceph-mesos-builder bash -c "cd /build/ceph-mesos/build && make VERBOSE=1"

build/rpmbuild/SOURCES/ceph-mesos-$(VERSION).tar.gz: build/ceph-mesos
	mkdir -p build/rpmbuild/SOURCES
	git archive --remote build/ceph-mesos master --format tgz --prefix=ceph-mesos-$(VERSION)/ > build/rpmbuild/SOURCES/ceph-mesos-$(VERSION).tar.gz

build/rpmbuild/RPMS/x86_64/ceph-mesos-$(VERSION)-1.x86_64.rpm: image-built build/rpmbuild/SOURCES/ceph-mesos-$(VERSION).tar.gz
	mkdir -p build/rpmbuild/{RPMS,SRPMS}
	docker run -it --rm -v $(PWD)/build:/build ceph-mesos-builder bash -x -c "mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS,tmp} && cat /build/rpmbuild/SPECS/ceph-mesos.spec | sed 's/{version}/$(VERSION)/g' > ~/rpmbuild/SPECS/ceph-mesos.spec && cp /build/rpmbuild/SOURCES/ceph-mesos-$(VERSION).tar.gz ~/rpmbuild/SOURCES && cd ~/rpmbuild && rpmbuild -ba SPECS/ceph-mesos.spec && cp -R ~/rpmbuild/{,S}RPMS /build/rpmbuild/"
