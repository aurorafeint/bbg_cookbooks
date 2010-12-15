#
# Cookbook Name:: boost
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

%w{boost boost-devel boost-doc}.each do |pkg|
  package pkg do
    action :purge
  end
end

remote_file "/tmp/#{node[:boost][:file]}" do
  source node[:boost][:source] + node[:boost][:file]
  mode "0644"
  action :create_if_missing
end

script "install-boost" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  tar xzvf #{node[:boost][:file]}
  cd #{node[:boost][:build_dir]}
  ./bootstrap.sh && ./bjam install
  EOH
  not_if "/sbin/ldconfig -v | grep boost"
end

execute "ldconfig" do
  user "root"
  command "/sbin/ldconfig"
  action :nothing
end

cookbook_file "/etc/ld.so.conf.d/boost.conf" do
  owner "root"
  group "root"
  mode "0644"
  source "boost.conf"
  backup false
  notifies :run, resources(:execute => "ldconfig"), :immediately
end
