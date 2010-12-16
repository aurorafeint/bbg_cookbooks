#
# Cookbook Name:: membase
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

include_recipe "system-users::membase"
include_recipe "ksh"

if node[:memory][:total].to_i >= 16000000
  memoryquota = 15500000
elsif node[:memory][:total].to_i >= 8000000
  memoryquota = 7500000
elsif node[:memory][:total].to_i >= 4000000
  memoryquota = 3500000
elsif node[:memory][:total].to_i >= 2000000
  memoryquota = 1500000
elsif node[:memory][:total].to_i >= 1000000
  memoryquota = 500000
else
  memoryquota = 400000
end

pkg = "membase-server-community_x86_64_1.6.0.1.rpm"
pkg_location = "http://c2512712.cdn.cloudfiles.rackspacecloud.com/#{pkg}"

remote_file "/tmp/#{pkg}" do
  source "#{pkg_location}"
  mode 0644
  action :create
  notifies :upgrade, "rpm_package[membase]"
end

rpm_package "membase" do
  source "/tmp/#{pkg}"
  action :nothing
  only_if {File.exists?("/tmp/#{pkg}")}
  notifies :run, "bash[initial-setup]"
end

directory "/opt/membase" do
  mode 0755
  owner "membase"
  group "membase"
  action :create
end

directory "/var/opt/membase" do
  mode 0755
  owner "membase"
  group "membase"
  action :create
end

service "membase-server" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

bash "initial-setup" do
  code <<-EOH
    curl -i -d path=/opt/membase/1.6.0.1/data/ns_1 http://localhost:8091/nodes/self/controller/settings
    curl -i -d memoryQuota=#{memoryquota} http://localhost:8091/pools/default
    curl -i -d username=Administrator -d password=#{node[:membase][:password]} -d port=8091 http://localhost:8091/settings/web
  EOH
  not_if "curl -i http://localhost:8091/pools | grep Unauthorized"
end
