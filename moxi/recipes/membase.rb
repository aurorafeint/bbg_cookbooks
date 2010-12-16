include_recipe "moxi::default"

raise "server_type not set to membase!" if node[:moxi][:server_type] != "membase"

# FIXME: Do nothing for now - we need to configure membase server, then have
# moxi curl a specific URL.
