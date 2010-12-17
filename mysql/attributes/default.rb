#
# Cookbook Name:: mysql
# Attributes:: default
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

default[:mysql][:server][:datadir] = "/var/lib/mysql"
default[:mysql][:server][:logdir] = "/var/log/mysql"
default[:mysql][:server][:bindaddress] = "127.0.0.1"

if node.mysql.server.attribute?("replication")
  include_attribute "mysql::replication"
end
