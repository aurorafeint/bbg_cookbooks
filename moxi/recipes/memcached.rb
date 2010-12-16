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
  notifies :run, "bash[start-moxi-memcached]"
end

bash "start-moxi-memcached" do
  cwd "/opt/moxi/config"
  code <<-EOH
    /opt/moxi/bin/moxi -z ./memcached.cfg &
  EOH
  not_if "ps auxwww | grep moxi"
  action :nothing
end
