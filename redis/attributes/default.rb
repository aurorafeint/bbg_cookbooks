#
# Cookbook Name:: redis
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

# Installation requirements.
default[:redis][:version] = "2.0.3"
default[:redis][:dir] = "/usr/local/redis"
default[:redis][:dirs] = [ "#{default[:redis][:dir]}/bin", "#{default[:redis][:dir]}/etc", "#{default[:redis][:dir]}/log", "/var/run/redis/" ]
default[:redis][:binaries] = %w(redis-benchmark redis-cli redis-server)

# Configuration requirements.
default[:redis][:daemonize] = "yes"
default[:redis][:pidfile] = "/var/run/redis/redis.pid"
default[:redis][:port] = "6379"
default[:redis][:bind] = "127.0.0.1"
default[:redis][:timeout] = "300"
default[:redis][:loglevel] = "notice"
default[:redis][:logfile] = "#{default[:redis][:dir]}/log/redis.log"
default[:redis][:databases] = "16"
default[:redis][:appendonly] = "no"
default[:redis][:appendfsync] = "everysec"
default[:redis][:no_appendfsync_on_rewrite] = "no"
default[:redis][:vm_enabled] = "no"
default[:redis][:vm_swap_file] = "/tmp/redis.swap"
default[:redis][:vm_max_memory] = "0"
default[:redis][:vm_page_size] = "32"
default[:redis][:vm_pages] = "134217728"
default[:redis][:vm_max_threads] = "4"
default[:redis][:glueoutputbuf] = "yes"
default[:redis][:hash_max_zipmap_entries] = "64"
default[:redis][:hash_max_zipmap_value] = "512"
default[:redis][:activerehashing] = "yes"
