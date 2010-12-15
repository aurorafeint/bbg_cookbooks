#
# Cookbook Name:: redis
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

# Make sure we can build Redis from source.
include_recipe "build-essential"

# Create the redis group.
group "redis" do
  action :create
end

# Create the redis user.
user "redis" do
  comment "Redis Administrator"
  system true
  shell "/sbin/nologin"
end

# Create the root of our installation.
directory "#{node[:redis][:dir]}" do
  owner "redis"
  group "redis"
  mode "0755"
  action :create
end

# Create the rest of the directories.
node[:redis][:dirs].each do |dir|
  unless File.directory? dir
    directory dir do
      owner "redis"
      group "redis"
      mode "0755"
      recursive true
      action :create
    end
  end
end

# Grab the tarball for our specified version.
remote_file "/tmp/redis-#{node[:redis][:version]}.tar.gz" do
  source "http://redis.googlecode.com/files/redis-#{node[:redis][:version]}.tar.gz"
  backup false
  action :create_if_missing
end

# Compile redis.
bash "compile-redis" do
  cwd "/tmp"
  code <<-EOH
    tar zxf redis-#{node[:redis][:version]}.tar.gz
    cd redis-#{node[:redis][:version]} && make
  EOH
  not_if "test -x #{node[:redis][:dir]}/bin/redis-server"
end

# Move our binaries to the specified redis directory.
node[:redis][:binaries].each do |bin|
  execute "installing-#{bin}" do
    user "root"
    command "cp -a /tmp/redis-#{node[:redis][:version]}/#{bin} #{node[:redis][:dir]}/bin/#{bin}"
    creates "#{node[:redis][:dir]}/bin/#{bin}"
  end
end

# Create profile.d script to add redis directory to $PATH.
template "/etc/profile.d/redis.sh" do
  source "redis.sh"
  mode "0755"
  backup false
  not_if "echo $PATH | grep '#{node[:redis][:dir]}/bin'"
end

# Create init script.
template "/etc/init.d/redis-server" do
  source "redis-init"
  mode "0755"
  backup false
end

# Define our new service.
service "redis-server" do
  supports :start => true, :stop => true, :restart => true
  action :nothing
end

# Create configuration file.
template "#{node[:redis][:dir]}/etc/redis.conf" do
  source "redis.conf"
  mode "0644"
  backup false
  notifies :restart, "service[redis-server]", :immediately
end
