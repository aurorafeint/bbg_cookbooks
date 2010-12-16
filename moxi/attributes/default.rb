

default[:moxi][:servers] = [
  {
    :address => "foobar.example.com",
    :port => "11211",
    :username => nil,
    :password => nil
  }
]

# All servers in the cluster must be either all memcached-like, or all membase.
default[:moxi][:server_type] = "memcached"
default[:moxi][:port] = "11211"
