directory "/etc/named"

cookbook_file "/etc/named/consul.conf" do
  source "consul.conf"
  action :create
end

include_recipe 'bind'
