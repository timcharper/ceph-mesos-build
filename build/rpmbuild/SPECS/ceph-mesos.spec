Name: ceph-mesos
Version: {version}
Release: 1
Summary: Ceph-Mesos framework
Source0: ceph-mesos-{version}.tar.gz
License: Apache
Group: System Environment/Libraries
BuildArch: x86_64
BuildRoot: %{_tmppath}/%{name}-buildroot
AutoReqProv: no # it's broken for mesos package for reasons
Requires: mesos = 0.28.2, libmicrohttpd, jsoncpp, gflags, yaml-cpp, protobuf
BuildRequires: cmake, mesos, protobuf-devel, boost-devel, gflags-devel, glog-devel, yaml-cpp-devel, jsoncpp-devel, libmicrohttpd-devel, gmock-devel, gtest-devel
%description
Ceph Mesos framework
%prep
%setup -q
%build
mkdir -p build
cd build
cmake ..
make VERBOSE=1
strip ceph-mesos*
%install
cd build
mkdir -p $RPM_BUILD_ROOT/usr/bin/
install -m 0755 ceph-mesos $RPM_BUILD_ROOT/usr/bin/ceph-mesos
install -m 0755 ceph-mesos-disk-executor $RPM_BUILD_ROOT/usr/bin/ceph-mesos-disk-executor
install -m 0755 ceph-mesos-executor $RPM_BUILD_ROOT/usr/bin/ceph-mesos-executor
%clean
rm -rf $RPM_BUILD_ROOT
%post
echo . .

%files
/usr/bin/ceph-mesos
/usr/bin/ceph-mesos-disk-executor
/usr/bin/ceph-mesos-executor
# /etc/dbbackup/backup.sh
