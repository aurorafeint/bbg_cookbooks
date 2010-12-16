include_recipe "moxi::default"

directory "/opt/moxi/config" do
  mode 0755
  owner "root"
  group "root"
  action :create
end

template "/opt/moxi/config/memcached.cfg" do
  source "moxi-memcached.cfg.erb"
  mode 0644
  owner "root"
  group "root"
  action :create
  notifies :restart, "service[moxi-server]"
end

cookbook_file "/etc/init.d/moxi-server" do
  source "moxi-init"
  mode 0755
  owner "root"
  group "root"
  action :create
end

service "moxi-server" do
  supports :restart => true, :reload => true, :status => true
  action [ :enable, :start ]
end
