service "consul" do
	action [:enable, :start]
end

node['consul_http_checks'].each do |service|
	puts service
	curl_script = "curl -v #{service['url']}"

	if !service['username'].nil?
		split_url = service['url'].split('http://')
		curl_script = "curl -v http://#{service['username']}:#{service['password']}@#{split_url[1]}"
	end

	if service['port'].nil?
		consul_service_def service['name'] do  
			name service['name']
			check(interval: '30s', script: curl_script)
			notifies :restart, 'service[consul]', :delayed
			action :create
		end
	else
		consul_service_def service['name'] do  
			name service['name']
			port service['port']
			notifies :restart, 'service[consul]', :delayed
			action :create
		end
	end
end