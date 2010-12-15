#
# Cookbook Name:: mysql
# Recipe:: slave
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

include_recipe "mysql::server"

raise "Machine role is #{node[:mysql][:server][:replication][:role]}, set to slave to proceed.  Aborting run." if node[:mysql][:server][:replication][:role] != "slave"

# Figure out which machines are masters in the cluster, pull master binlog position and file
# information from the node, then apply information to slave.

masters = search(:node, "mysql_server_replication_role:master")

# For now, assume there's only one master.

master_ip = masters[0][:ipaddress]

master "connect-to-#{masters[0][:fqdn]}-master" do
  replication_user node[:mysql][:server][:replication][:user]
  replication_password node[:mysql][:server][:replication][:password]
  master_log_pos masters[0][:mysql][:server][:replication][:log_pos]
  master_log_file masters[0][:mysql][:server][:replication][:log_file]
  ip_address master_ip
  port 3306
  action :create
end
