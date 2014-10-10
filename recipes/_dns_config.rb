template "/etc/consul.d/dns_config.json" do
	source "dns_config.json.erb"
	variables(
		:allow_stale => node['consul_dns_config']['allow_stale'],
		:service_ttl => node['consul_dns_config']['service_ttl'],
		:node_ttl => node['consul_dns_config']['node_ttl'],
		:max_stale => node['consul_dns_config']['max_stale']

	)
	notifies :restart, 'service[consul]', :delayed
end