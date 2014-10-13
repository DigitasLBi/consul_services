query = "recipes:consul_services\\:\\:server"

Chef::Log.info("Query " + query)

nodes = search(:node,query)

Chef::Log.info("Nodes " + nodes.to_s)

servers = []

nodes.each do |n|
	puts node['consul']['datacenter']
	puts n['consul']['datacenter']
	if n['consul']['datacenter'] == node['consul']['datacenter']
		servers << n['ipaddress']
	end
end

Chef::Log.info("Servers " + servers.to_s)

node.default['consul']['servers'] = servers