maintainer       "Blue Box Group, LLC"
maintainer_email "support@blueboxgrp.com"
license          "Apache v2.0"
description      "Installs and configures Redis."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.0"
recipe           "redis", "Installs Redis with a base configuration and init script."

depends          "build-essential"

%w{centos redhat debian ubuntu}.each do |os|
  supports os
end

attribute "redis",
  :display_name => "Redis Hash",
  :description => "Hash of Redis attributes",
  :type => "hash"

attribute 'redis/version',
  :display_name => "Redis Version",
  :description => "The version of Redis to install",
  :default => "2.0.3"

attribute 'redis/dir',
  :display_name => "Redis Directory",
  :description => "The Redis installation directory",
  :default => "/usr/local/redis"
  
attribute 'redis/dirs',
  :display_name => "Redis Directories",
  :description => "Additional directories that must be created for a successful installation",
  :type => "array",
  :default => [ "#{default[:redis][:dir]}/bin", "#{default[:redis][:dir]}/etc", "#{default[:redis][:dir]}/log", "/var/run/redis/" ]
  
attribute 'redis/binaries',
  :display_name => "Redis Binaries",
  :description => "Binaries created after compile that should be installed"
  :type => "array",
  :default => [ "redis-benchmark", "redis-cli", "redis-server" ]
  
attribute 'redis/daemonize',
  :display_name => "Redis Daemonize",
  :description => "Run Redis as a daemon",
  :default => "yes"
  
attribute 'redis/pidfile',
  :display_name => "Redis PID File",
  :description => "Path to Redis PID file",
  :default => "/var/run/redis/redis.pid"
  
attribute 'redis/port',
  :display_name => "Redis Port",
  :description => "Accept Redis connections on this port",
  :default => "6379"
  
attribute 'redis/bind',
  :display_name => "Redis Interface",
  :description => "Interface Redis will bind to",
  :default => "127.0.0.1"
  
attribute 'redis/timeout',
  :display_name => "Redis Timeout",
  :description => "Close the connection after a client is idle for N seconds",
  :default => "300"

attribute 'redis/loglevel',
  :display_name => "Redis Log Level",
  :description => "Level of logging to be done by Redis",
  :default => "notice"
  
attribute 'redis/logfile',
  :display_name => "Redis Log File",
  :description => "Path to Redis log file",
  :default => "#{default[:redis][:dir]}/log/redis.log"
  
attribute 'redis/databases',
  :display_name => "Redis Databases",
  :description => "Number of Redis databases",
  :default => "16"
  
attribute 'redis/appendonly',
  :display_name => "Redis Append Only"
  :description => "Append write operations to file on disk",
  :default => "no"
  
attribute 'redis/appendfsync',
  :display => "Redis Append Fsync",
  :description => "Redis fsync mode",
  :default => "everysec"
  
attribute 'redis/vm_enabled',
  :display "Redis Enable VM",
  :description => "Redis virtual memory",
  :default => "no"
  
attribute 'redis/vm_swap_file',
  :display => "Redis VM Swap File",
  :description => "Path to Redis swap file",
  :default => "/tmp/redis.swap"
  
attribute 'redis/vm_max_memory',
  :display => "Redis VM Max Memory",
  :description => "Configures the VM to use at max the specified amount of RAM",
  :default => "0"
  
attribute 'redis/vm_page_size',
  :display => "Redis VM Page Size",
  :description => "Size of Redis VM Pages",
  :default => "32"
  
attribute 'redis/vm_pages',
  :display => "Redis VM Pages",
  :description => "Number of total memory pages in Redis swap file",
  :default => "134217728"
  
attribute 'redis/vm_max_threads',
  :display => "Redis VM Max Threads",
  :description => "Max number of VM I/O threads running at the same time",
  :default => "4"
  
attribute 'redis/glueoutputbuf',
  :display => "Redis Glue Output Buffer",
  :description => "Glue small output buffers together in order to send small replies in a single TCP packet",
  :default => "yes"
  
attribute 'redis/hash_max_zipmap_entries',
  :display => "Redis Hash Max ZipMap Entries",
  :description => "Max number of elements to store in Redis hash",
  :default => "64"
  
attribute 'redis/hash_max_zipmap_value',
  :display => "Redis Hash Max ZipMap Value",
  :description => "Max size of element(s) stored in Redis hash",
  :default => "512"
  
attribute 'redis/activerehashing',
  :display "Redis Active Rehashing",
  :description => "Active rehashing against the main Redis hash table",
  :default => "yes"
