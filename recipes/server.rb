node.default['consul']['service_mode'] = 'server'
node.default['consul']['serve_ui'] = true
node.default['consul']['node_name'] = node['hostname']

include_recipe 'consul_services::_search_servers'
include_recipe 'consul::default'

include_recipe 'consul::ui'
include_recipe 'consul_services::_server_services'

include_recipe 'consul_services::_bind'

include_recipe 'consul_services::_dns_config'