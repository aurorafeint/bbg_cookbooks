#
# Cookbook Name:: percona
# Recipe:: master
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

include_recipe "percona::server"

raise "Machine role is #{node[:mysql][:server][:replication][:role]}; set it to master.  Aborting run." if node[:mysql][:server][:replication][:role] != "master"

# Figure out if there's any other machines that are configured as masters.
# If so, raise an exception - we shouldn't have more than one.

masters = search(:node, "mysql_server_replication_role:master")

raise "Only allowing one master to be configured per cluster!  Aborting run." if masters.length >= 1

# Store master log information in node attributes.

ruby_block "master-log" do
  block do
    logs = %x[mysql -u root -e "show master status;" | grep mysql].strip.split
    unless node[:mysql][:server][:replication][:log_file]
      node.set[:mysql][:server][:replication][:log_file] = logs[0]
    end
    unless node[:mysql][:server][:replication][:log_pos]
      node.set[:mysql][:server][:replication][:log_pos] = logs[1]
    end
    node.save
  end
  action :create
end

# Figure out which machines are configured as slaves, and then configure
# the master to allow the slave machines to connect to it.

slaves = search(:node, "mysql_server_replication_role:slave")

slaves.each do |slave|
  slave_ip = slave[:ipaddress]
  slave "create-slave-#{slave[:fqdn]}" do
    replication_user slave[:mysql][:server][:replication][:user]
    replication_password slave[:mysql][:server][:replication][:password]
    ip_address slave_ip
    action :create
  end
end
