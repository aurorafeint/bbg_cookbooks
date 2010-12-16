#
# Cookbook Name:: percona
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

percona_pkg = "percona-release-0.0-1.x86_64.rpm"
percona_location = "http://www.percona.com/downloads/percona-release/#{percona_pkg}"

remote_file "/tmp/#{percona_pkg}" do
  source "#{percona_location}"
  mode 0644
  owner "root"
  group "root"
  action :create
  notifies :upgrade, "rpm_package[percona]"
end

rpm_package "percona" do
  source "/tmp/#{percona_pkg}"
  action :install
  only_if {File.exists?("/tmp/#{percona_pkg}")}
end

include_recipe "percona::client"
