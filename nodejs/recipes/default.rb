#
# Cookbook Name:: nodejs
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

remote_file "/tmp/node-v0.1.104.tar.gz" do
  source "http://nodejs.org/dist/node-v0.1.104.tar.gz"
  action :create_if_missing
end

bash "install_nodejs" do
  cwd "/tmp"
  code <<-EOH
    tar xzf node-v0.1.104.tar.gz
    cd node-v0.1.104 && ./configure
    make && make install
  EOH
  not_if "which node"
end
