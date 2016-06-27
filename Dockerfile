FROM centos:7

RUN rpm -Uvh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm

RUN yum install -y epel-release \
 && yum groupinstall -y "Development Tools" \
 && yum install -y cmake mesos protobuf-devel boost-devel gflags-devel glog-devel yaml-cpp-devel  jsoncpp-devel libmicrohttpd-devel gmock-devel gtest-devel

RUN yum install -y rpm-build rpmdevtools
