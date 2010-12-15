#
# Cookbook Name:: ant
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

include_recipe "build-essential"

remote_file "/tmp/apache-ant-1.8.1-bin.tar.gz" do
  owner "root"
  group "root"
  source "http://www.fightrice.com/mirrors/apache/ant/binaries/apache-ant-1.8.1-bin.tar.gz"
  mode "0644"
  backup false
  action :create_if_missing
end

script "install-ant" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  tar xzvf apache-ant-1.8.1-bin.tar.gz
  mv apache-ant-1.8.1/ /opt/ant
  EOH
  not_if "/usr/bin/test -d /opt/ant"
end

cookbook_file "/etc/profile.d/ant.sh" do
  owner "root"
  group "root"
  mode "0755"
  source "ant.sh"
  backup false
end

script "ant-add-paths" do
  interpreter "bash"
  user "root"
  code <<-EOH
  export ANT_HOME=/opt/ant
  export PATH=/opt/ant/bin:$PATH
  EOH
end
