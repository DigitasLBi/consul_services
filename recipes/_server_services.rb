user 'consul' do
	action :create
end

node.default['consul_dns_config']['max_stale'] = 60

node.default['consul_http_checks'] = [ 
    { "name" => "consul-ui", 
  		"url" => "http://localhost:8500/ui/consul_ui" }
]

include_recipe 'consul_services::services'

consul_service_def 'consul-dns' do  
	name 'consul-dns'
	port 8600	
	notifies :restart, 'service[consul]', :delayed
	action :create
end