maintainer       "Blue Box Group, LLC"
maintainer_email "support@blueboxgrp.com"
license          "Apache v2.0"
description      "Installs/Configures memcached"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.0"

%w{centos redhat}.each do |os|
  supports os
end

grouping 'memcached',
  :title => "Memcached options",
  :description => "Tunable memcached options."

attribute 'memcached/port',
  :display_name => "Listening port",
  :description => "The port that memcached is listening on.",
  :default => "11211",
  :type => "string",
  :required => "optional"

attribute 'memcached/bindaddress',
  :display_name => "Bind address",
  :description => "IP address that memcached is listening on.",
  :default => "127.0.0.1",
  :type => "string",
  :required => "recommended"

attribute 'memcached/cache_size',
  :display_name => "Cache size",
  :description => "Size of the cache (in megabytes)",
  :calculated => true,
  :type => "string",
  :required => "optional"
