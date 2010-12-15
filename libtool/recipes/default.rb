#
# Cookbook Name:: libtool
# Recipe:: default
#
# Copyright 2010, Blue Box Group, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"

execute "remove-libtool-packages" do
  user "root"
  command "rpm -qa | grep libtool | rpm -e --nodeps $(xargs)"
  only_if "rpm -qa | grep libtool"
end

remote_file "/tmp/libtool-2.2.8.tar.gz" do
  owner "root"
  group "root"
  mode "0644"
  source "http://ftp.gnu.org/gnu/libtool/libtool-2.2.8.tar.gz"
  backup false
  action :create_if_missing
end

script "install-libtool" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  tar xzvf libtool-2.2.8.tar.gz
  cd libtool-2.2.8
  ./configure
  make
  make install
  EOH
  not_if "/usr/bin/test -x /usr/local/bin/libtool"
end

cookbook_file "/etc/profile.d/libtool.sh" do
  owner "root"
  group "root"
  mode "0755"
  source "libtool.sh"
  backup false
  action :create_if_missing
end
