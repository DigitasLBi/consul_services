query = "recipes:consul_services\\:\\:server AND chef_environment:#{node.chef_environment}"

Chef::Log.info("Query " + query)
puts query

nodes = search(:node,query)

Chef::Log.info("Nodes " + nodes.to_s)
puts nodes.to_s

servers = []

nodes.each do |node|
	servers << node['ipaddress']
end

Chef::Log.info("Servers " + servers.to_s)
puts servers.to_s

node.default['consul']['servers'] = servers