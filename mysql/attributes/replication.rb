#
# Cookbook Name:: mysql
# Attributes:: replication
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

include_attribute "mysql::default"

default[:mysql][:server][:replication][:role] = "standalone"

# Provides unique ID for each machine by transforming every character in the
# node's FQDN to its number representation, and then adding everything up.

sum = 0
node[:fqdn].each_byte {|c| sum += c}
sum = sum % 65000

default[:mysql][:server][:replication][:id] = sum
default[:mysql][:server][:replication][:autoincrementincrement] = 10
default[:mysql][:server][:replication][:autoincrementoffset] = 2
default[:mysql][:server][:replication][:user] = "replication"
