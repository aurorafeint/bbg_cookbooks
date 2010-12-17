#
# Cookbook Name:: percona
# Recipe:: dualmaster
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

raise "Machine role is #{node[:mysql][:server][:replication][:role]}; set it to dualmaster.  Aborting run." if node[:mysql][:server][:replication][:role] != "dualmaster"

# Figure out if there's any other machines that are configured as masters.
# If so, raise an exception - we shouldn't have more than one.

dualmasters = search(:node, "mysql_server_replication_role:dualmaster")

raise "We only allow two dualmasters to be configured per cluster!  Aborting run." if dualmasters.length > 2

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

# Choose an increment offset value that is < increment increment and !=
# the increment offset value of the other dual master.

unless node[:mysql][:server][:replication][:autoincrementoffset]
  for i in 1...node[:mysql][:server][:replication][:autoincrementincrement]
    dualmasters.each do |master|
      node.set[:mysql][:server][:replication][:autoincrementoffset] = i if (master[:mysql][:server][:replication][:autoincrementoffset] != i && master[:fqdn] != node[:fqdn])
    end
  end
  node.save
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

# Similarly, we want to make sure that we grab master binlog info from the
# other dual master and use that information for the dual master we're now
# configuring.  We need to make sure that auto_increment_increment is set to
# >= number of masters, auto_increment_offset unique for each master.

dualmasters.each do |dualmaster|
  next if dualmaster[:fqdn] == slave[:fqdn]
  master_log_file = dualmaster[:mysql][:server][:replication][:log_file]
  master_log_pos = dualmaster[:mysql][:server][:replication][:log_pos]
  master_ip = dualmaster[:ipaddress]
  # Create replication user for the dual master.
  slave "create-dualmaster-#{dualmaster[:fqdn]}" do
    replication_user dualmaster[:mysql][:server][:replication][:user]
    replication_password dualmaster[:mysql][:server][:replication][:password]
    ip_address master_ip
    action :create
  end

  # Now hook into the peer.
  master "create-dualmaster-peer-#{dualmaster[:fqdn]}" do
    replication_user node[:mysql][:server][:replication][:user]
    replication_password node[:mysql][:server][:replication][:password]
    master_log_pos dualmaster[:mysql][:server][:replication][:log_pos]
    master_log_file dualmaster[:mysql][:server][:replication][:log_file]
    ip_address master_ip
    port 3306
    action :create
  end
end
