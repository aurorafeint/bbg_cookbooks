#
# Cookbook Name:: memcached
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

packages = [ "memcached" ]

cache_size = ((node[:memory][:total] * 0.9375) / 1024) / 1024

packages.each do |pkg|
  package "#{pkg}" do
    action :install
  end
end

service "memcached" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/sysconfig/memcached" do
  source "memcached.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :cache_size => cache_size
  )
  action :create
  notifies :restart, "service[memcached]"
end
