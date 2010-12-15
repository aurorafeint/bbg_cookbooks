#
# Cookbook Name:: mysql
# Recipe:: client
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

case node[:platform]
when "centos","redhat","fedora"
  bash "mysql-fetch-client" do
    user "root"
    cwd "/tmp"
    code <<-EOH
    (cd /tmp; wget http://mirror.services.wisc.edu/mysql/Downloads/MySQL-5.1/MySQL-devel-community-5.1.51-1.rhel5.x86_64.rpm)
    (cd /tmp; wget http://mirror.services.wisc.edu/mysql/Downloads/MySQL-5.1/MySQL-client-community-5.1.51-1.rhel5.x86_64.rpm)
    EOH
    not_if "test -f /tmp/MySQL-client-community-5.1.51-1.rhel5.x86_64.rpm"
  end
  
  bash "mysql-install-client" do
    user "root"
    cwd "/tmp"
    code <<-EOH
    (cd /tmp; rpm -Uvh MySQL-devel-community-5.1.51-1.rhel5.x86_64.rpm)
    (cd /tmp; rpm -Uvh MySQL-client-community-5.1.51-1.rhel5.x86_64.rpm)
    EOH
    not_if "rpm -qa | grep 'MySQL-client-community-5.1.51'"
  end

  bash "mysql-fetch-shared-compat" do
    user "root"
    cwd "/tmp"
    code <<-EOH
    (cd /tmp; wget http://mirror.services.wisc.edu/mysql/Downloads/MySQL-5.1/MySQL-shared-compat-5.1.51-1.rhel5.x86_64.rpm)
    EOH
    not_if "test -f /tmp/MySQL-shared-compat-5.1.51-1.rhel5.x86_64.rpm"
  end

  bash "mysql-install-shared-compat" do
    user "root"
    cwd "/tmp"
    code <<-EOH
    (cd /tmp; rpm -Uvh MySQL-shared-compat-5.1.51-1.rhel5.x86_64.rpm)
    EOH
    not_if "rpm -qa | grep 'MySQL-shared-compat-5.1.51'"
  end
when "debian","ubuntu"
  packages = %w{libmysqlclient15-dev mysql-client}
  packages.each do |pkg|
    package pkg
  end
end
