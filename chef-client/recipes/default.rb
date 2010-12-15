#
# Cookbook Name:: chef-client
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

gem_packages = [ "chef" ]

gem_packages.each do |gempkg|
  gem_package "#{gempkg}" do
    action :install
  end
end

directory "/var/log/chef" do
  mode "0755"
  owner "root"
  group "root"
  action :create
end

directory "/etc/chef" do
  mode "0755"
  owner "root"
  group "root"
  action :create
end

cookbook_file "/etc/init.d/chef-client" do
  source "chef-client-initd"
  mode "0755"
  owner "root"
  group "root"
  action :create
end

cookbook_file "/etc/sysconfig/chef-client" do
  source "chef-client-sysconfig"
  mode "0644"
  owner "root"
  group "root"
  action :create
end

cookbook_file "/etc/logrotate.d/chef-client" do
  source "chef-client-logrotated"
  mode "0644"
  owner "root"
  group "root"
  action :create
end

service "chef-client" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
