#
# Cookbook Name:: percona
# Definition:: master
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

# Example:
# master "ohai" do
#   replication_user replication
#   replication_password foobar
#   master_log_pos 510523
#   master_log_file mysql-bin-log.100
#   ip_address 127.0.0.1
#   port 3306
#   action :create
# end

define :master, :action => :create, :port => "3306", :replication_user => "replication" do
  if params[:action] == :create
    ruby_block "connect-to-master-#{params[:name]}" do
      block do
        Chef::Log.info("Setting master host to #{params[:ip_address]} on port #{params[:port]}, with user #{params[:replication_user]}, log file at #{params[:master_log_file]}, position #{params[:master_log_pos]}")
        %x[mysql -u root -e "CHANGE MASTER TO master_host='#{params[:ip_address]}', master_port=#{params[:port]}, master_user='#{params[:replication_user]}', master_password='#{params[:replication_password]}', master_log_file='#{params[:master_log_file]}', master_log_pos=#{params[:master_log_pos]};"]
        %x[mysql -u root -e "START SLAVE;"]
      end
      not_if "mysql -u root -e \"show slave status;\" | wc -l | grep -v 0"
      action :create
    end
  end
end
