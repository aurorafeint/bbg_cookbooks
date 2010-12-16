#
# Cookbook Name:: moxi
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

include_recipe "system-users::moxi"

if node[:moxi][:server_type] == "memcached"
  include_recipe "moxi::memcached"
elsif node[:moxi][:server_type] == "membase"
  include_recipe "moxi::membase"
end

pkg = "moxi-server_x86_64_1.6.0.1.rpm"
pkg_location = "http://c2512712.cdn.cloudfiles.rackspacecloud.com/#{pkg}"

remote_file "/tmp/#{pkg}" do
  source "#{pkg_location}"
  mode 0644
  action :create
  notifies :upgrade, "rpm_package[moxi]"
end

rpm_package "moxi" do
  source "/tmp/#{pkg}"
  action :nothing
  only_if {File.exists?("/tmp/#{pkg}")}
end

directory "/opt/moxi" do
  mode 0755
  owner "moxi"
  group "moxi"
  action :create
end

service "moxi" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
