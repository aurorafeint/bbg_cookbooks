#
# Cookbook Name:: percona
# Definition:: slave
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
# slave "ohai" do
#   replication_user replication
#   replication_password foobar
#   ip_address 127.0.0.1
#   action :create
# end

define :slave, :action => :create, :replication_user => "replication" do
  if params[:action] == :create
    ruby_block "create-replication-#{params[:name]}-user" do
      block do
        %x[mysql -u root -e "GRANT REPLICATION SLAVE ON *.* TO '#{params[:replication_user]}'@'#{params[:ip_address]}' IDENTIFIED BY '#{params[:replication_password]}';"]
      end
      not_if "mysql -u root -e \"SELECT user,host from mysql.user where user='#{params[:replication_user]}';\" | grep #{params[:replication_user]} | grep #{params[:ip_address]}"
      action :create
    end
  end
end
