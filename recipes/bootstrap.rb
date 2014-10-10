node.override['consul']['service_mode'] = 'bootstrap'

include_recipe 'consul_services::server'