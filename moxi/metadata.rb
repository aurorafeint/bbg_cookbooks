maintainer       "Blue Box Group, LLC"
maintainer_email "support@blueboxgrp.com"
license          "Apache v2.0"
description      "Installs/Configures moxi"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.0"

%w{centos redhat}.each do |os|
  supports os
end

depends          "system-users"

grouping 'moxi',
  :title => "Moxi options",
  :description => "Tunable moxi options."

attribute 'moxi/servers',
  :display_name => "memcached/membase servers",
  :description => "Servers that moxi should connect to.",
  :type => "hash",
  :required => "required",
  :recipes => [ 'moxi::default', 'moxi::memcached', 'moxi::membase' ]

attribute 'moxi/server_type',
  :display_name => "Server type",
  :description => "Types of servers that moxi is connecting to.",
  :type => "string",
  :required => "recommended",
  :recipes => [ 'moxi::default' ]

attribute 'moxi/port',
  :display_name => "Server port",
  :description => "Which port moxi should bind to.",
  :type => "string",
  :required => "optional",
  :recipes => [ 'moxi::default', 'moxi::membase', 'moxi::memcached' ]
