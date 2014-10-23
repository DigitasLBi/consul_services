user 'consul' do
	action :create
end

node.default['consul_http_checks'] = [ 
    { "name" => "consul-ui", 
  		"url" => "http://localhost:8500/ui/consul_ui" },
  	{ "name" => "consul-dns", "port" => 8600 }

]

include_recipe 'consul_services::services'