maintainer       "Blue Box Group, LLC"
maintainer_email "support@blueboxgrp.com"
license          "Apache v2.0"
description      "Installs/Configures git"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.0"

%w{centos redhat}.each do |os|
  supports os
end
