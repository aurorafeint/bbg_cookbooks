maintainer       "Blue Box Group, LLC"
maintainer_email "support@blueboxgrp.com"
license          "Apache v2.0"
description      "Installs/Configures mysql"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.5.0"

depends          "system-users"

%w{centos redhat}.each do |os|
  supports os
end

grouping 'mysql/server/replication',
  :title => "MySQL Replication Options",
  :description => "Describe MySQL replication settings below."

attribute 'mysql/server/replication/role',
  :display_name => "MySQL Replication Role",
  :description => "Describes what role the MySQL machine is set to (slave/master/dualmaster)",
  :choice => \[ 'slave', 'master', 'standalone', 'dualmaster' \],
  :type => "string",
  :required => "recommended",
  :recipes => \[ 'mysql::master', 'mysql::slave', 'mysql::dualmaster' \],
  :default => "standalone"

attribute 'mysql/server/replication/user',
  :display_name => "MySQL Replication User",
  :description => "Username that should be created and used on a master server for replication.",
  :type => "string",
  :required => "optional",
  :recipes => \[ 'mysql::master', 'mysql::slave', 'mysql::dualmaster' \],
  :default => "replication"

attribute 'mysql/server/replication/password',
  :display_name => "MySQL Replication Password",
  :description => "Password for connecting to a master server with the replication user.",
  :type => "string",
  :required => "required",
  :recipes => \[ 'mysql::master', 'mysql::slave', 'mysql::dualmaster' \]

attribute 'mysql/server/replication/id',
  :display_name => "MySQL server ID",
  :description => "The 'server-id' configuration setting set for each machine in a specific cluster.",
  :type => "string",
  :calculated => true,
  :required => "optional"

attribute 'mysql/server/replication/autoincrementincrement',
  :display_name => "MySQL 'auto_increment_increment'",
  :description => "The 'auto_increment_increment' configuration setting set for each machine in
 a specific cluster.",
  :type => "string",
  :calculated => true,
  :required => "optional"

attribute 'mysql/server/replication/autoincrementoffset',
  :display_name => "MySQL 'auto_increment_offset'",
  :description => "The 'auto_increment_offset' configuration setting set for each machine in
 a specific cluster.",
  :type => "string",
  :calculated => true,
  :required => "optional"

attribute 'mysql/server/replication/log_file',
  :display_name => "MySQL master log file",
  :description => "Last recorded MySQL master log file.",
  :type => "string",
  :calculated => true,
  :required => "optional"

attribute 'mysql/server/replication/log_pos',
  :display_name => "MySQL master log position",
  :description => "Last recorded MySQL master log position.",
  :type => "string",
  :calculated => true,
  :required => "optional"

grouping 'mysql/server',
  :title => "General MySQL Options",
  :description => "Describe general MySQL options below."

attribute 'mysql/server/datadir',
  :display_name => "MySQL data directory",
  :description => "Where your MySQL databases live.",
  :type => "string",
  :required => "optional",
  :recipes => \[ 'mysql::server' \],
  :default => "/var/lib/mysql"

attribute 'mysql/server/logdir',
  :display_name => "MySQL log directory",
  :description => "Where your MySQL logs are stored.",
  :type => "string",
  :required => "optional",
  :recipes => \[ 'mysql::server' \],
  :default => "/var/log/mysql"

attribute 'mysql/server/bindaddress',
  :display_name => "MySQL bind address",
  :description => "Which IP address MySQL will bind to.",
  :type => "string",
  :required => "recommended",
  :recipes => \[ 'mysql::server' \],
  :default => "127.0.0.1"
