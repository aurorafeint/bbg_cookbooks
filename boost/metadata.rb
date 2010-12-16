maintainer       "Blue Box Group, LLC"
maintainer_email "support@blueboxgrp.com"
license          "Apache v2.0"
description      "Installs/Configures boost"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.0"

depends          "build-essential"

%w{centos redhat}.each do |os|
  supports os
end

grouping 'boost',
  :title => "Boost options",
  :description => "Tunable boost attributes."

attribute 'boost/source',
  :display_name => "Boost source",
  :description => "URL to Boost folder containing boost/file",
  :type => "string",
  :required => "optional",
  :recipes => [ 'boost::default' ]

attribute 'boost/file',
  :display_name => "Boost tarball file",
  :description => "Name of the Boost tarball file to download.",
  :type => "string",
  :required => "optional",
  :recipes => [ 'boost::default' ]

attribute 'boost/build_dir',
  :display_name => "Boost build directory",
  :description => "Subdirectory for building Boost",
  :type => "string",
  :required => "optional",
  :recipes => [ 'boost::default' ]
