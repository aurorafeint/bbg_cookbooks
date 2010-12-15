#
# Cookbook Name:: rvm
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

packages = case node[:platform]
  when "centos","redhat","fedora"
    %w{gcc-c++ patch zlib-devel openssl-devel readline-devel libyaml-devel libffi-devel git}
  when "ubuntu","debian"
    %w{bison openssl libreadline5 libreadline-dev curl git-core zlib1g zlib1g-dev libssl-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev}
  end
  
packages.each do |pkg|
  package pkg
end

bash "rvm-install" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    wget --no-check-certificate http://www.github.com/wayneeseguin/rvm/raw/master/contrib/install-system-wide
    bash install-system-wide
    rm install-system-wide
  EOH
  not_if "[[ -x /usr/local/bin/rvm ]]"
end

cookbook_file "/etc/profile.d/rvm.sh" do
  source "rvm.sh"
  path "/etc/profile.d/rvm.sh"
  owner "root"
  group "root"
  mode 0755
  backup false
end

cookbook_file "/etc/rvmrc" do
  source "rvmrc"
  path "/etc/rvmrc"
  owner "root"
  group "rvm"
  mode 0664
  backup false
end  
  
node[:rvm][:rubies].each do |ruby|
  execute "rvm-install-#{ruby}" do
    # Install our various ruby versions.
    command "/usr/local/bin/rvm install #{ruby}"
    user "root"
    # Unless we already have that version installed.
    not_if "/usr/local/bin/rvm list | grep #{ruby}"
  end
end

execute "rvm-set-default" do
  # Set our default ruby install.
  command "/usr/local/bin/rvm --default #{node[:rvm][:default]}"
  # Unless the version is already set.
  not_if "/usr/local/bin/rvm list default | grep #{node[:rvm][:default]}"
end
