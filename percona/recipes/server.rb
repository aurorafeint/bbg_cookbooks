#
# Cookbook Name:: percona
# Recipe:: server
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

include_recipe "percona::client"
include_recipe "system-users::mysql"

template "/etc/init.d/mysql" do
  source "mysql-init.erb"
  owner "root"
  group "root"
  mode "0755"
  backup false
end

directory node[:mysql][:server][:datadir] do
  owner "mysql"
  group "mysql"
  mode "0755"
  recursive true
  action :create
end

directory node[:mysql][:server][:logdir] do
  owner "mysql"
  group "mysql"
  mode "0755"
  recursive true
  action :create
end

directory "/var/run/mysql" do
  owner "mysql"
  group "mysql"
  mode "0755"
  action :create
end

# Assign the proper values to our configuration based on total memory in system.
if node[:memory][:total].to_i >= 16000000
  table_cache = "1024"
  thread_cache = "256"
  innodb_buffer_pool_size = "11G"
  innodb_additional_mem_pool_size = "20M"
elsif node[:memory][:total].to_i >= 8000000
  table_cache = "1024"
  thread_cache = "256"
  innodb_buffer_pool_size = "5G"
  innodb_additional_mem_pool_size = "20M"
elsif node[:memory][:total].to_i >= 4000000
  table_cache = "512"
  thread_cache = "128"
  innodb_buffer_pool_size = "2G"
  innodb_additional_mem_pool_size = "10M"
elsif node[:memory][:total].to_i >= 2000000
  table_cache = "256"
  thread_cache = "64"
  innodb_buffer_pool_size = "1G"
  innodb_additional_mem_pool_size = "4M"
else
  table_cache = "128"
  thread_cache = "32"
  innodb_buffer_pool_size = "512M"
  innodb_additional_mem_pool_size = "2M"
end

template "/etc/my.cnf" do
  source "my.cnf"
  variables(
    :table_cache => table_cache,
    :thread_cache => thread_cache,
    :innodb_buffer_pool_size => innodb_buffer_pool_size,
    :innodb_additional_mem_pool_size => innodb_additional_mem_pool_size
  )
  backup false
end

case node[:platform]
when "centos","redhat","fedora"
  package "Percona-Server-server-51" do
    action :install
  end
end

service "mysql" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/logrotate.d/mysql_slowqueries" do
  source "mysql-server-logrotate"
  owner "root"
  group "root"
  mode "0644"
  backup false
end
