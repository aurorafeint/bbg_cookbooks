maintainer       "Blue Box Group, LLC"
maintainer_email "support@blueboxgrp.com"
license          "Apache v2.0"
description      "Installs/Configures rvm"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.0"

%w{centos redhat}.each do |os|
  supports os
end

depends          "build-essential"

grouping 'rvm',
  :title => "RVM attributes",
  :description => "Tunable RVM attributes."

attribute 'rvm/rubies',
  :display_name => "RVM managed rubies",
  :description => "Rubies managed by RVM.",
  :type => "array",
  :required => "recommended",
  :recipes => \[ 'rvm::default' \]

attribute 'rvm/default',
  :display_name => "Default RVM Ruby",
  :description => "Set default Ruby to use with RVM.",
  :type => "string",
  :required => "recommended",
  :recipes => \[ 'rvm::default' \]
