maintainer       "Blue Box Group, LLC"
maintainer_email "support@blueboxgrp.com"
license          "Apache v2.0"
description      "Installs/Configures membase"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.0"

depends          "system-users"

%w{centos redhat}.each do |os|
  supports os
end

grouping 'membase',
  :title => "membase attributes",
  :description => "Sets membase tunable attributes."

attribute 'membase/password',
  :display_name => "Password for Administrator",
  :description => "Password for the Administrator user.",
  :type => "string",
  :required => "required",
  :recipes => \[ 'membase::default' \]
