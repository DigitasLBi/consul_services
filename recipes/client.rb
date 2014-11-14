node.default['consul']['service_mode'] = 'client'
node.default['consul']['node_name'] = node['hostname']

include_recipe 'consul_services::_search_servers'
include_recipe 'consul::default'

node.default['resolver']['nameservers'] = node['consul']['servers'] 
node.default['resolver']['search'] = node['consul']['domain']
include_recipe 'resolver::default'