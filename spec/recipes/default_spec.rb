require 'spec_helper'

def consul_server ipaddress, datacenter
  consul_server = Chef::Node.new()
  consul_server.default['ipaddress'] = ipaddress
  consul_server.default['consul']['datacenter'] = datacenter
  consul_server
end

describe 'consul_services::bootstrap' do

  let(:bootstrap_run) do
        runner = ChefSpec::Runner.new(platform:'redhat', version:'6.5') do |node|
  
        env = Chef::Environment.new
        env.name 'default'

        node.override['consul_http_checks'] = [ 
          { "name" => "app_name_with_port", "port" => 8888 },
          { "name" => "app_name", "url" => "http://app_url" },
          { "name" => "app_name_with_password", "url" => "http://app_url", "username" => "username", "password" => "password" }
        ]

        node.override['consul']['datacenter'] = "default"

        allow(Chef::Environment).to receive(:load).and_return(env)

        allow(node).to receive(:chef_environment).and_return(env.name)
      end


    stub_search("node", "recipes:consul_services\\:\\:server")
      .and_return([consul_server("console-ip","default"),consul_server("console-another-dc","another_dc")])

    runner.converge(described_recipe,"recipe[consul_services::bootstrap]")
  end

  it "create service Consul" do
    expect(bootstrap_run).to start_service("consul")
  end

  it "Ensure consul only adds server on same DC" do
    expect(bootstrap_run.node['consul']['servers']).to eq(["console-ip"])
  end

  it "creates service check" do
    expect(bootstrap_run).to create_consul_service_def("default-app_name")
        .with(name: 'default-app_name')
        .with(check: {:interval=>"30s", :script=>"curl -v http://app_url"})
  end

  it "creates service check with port" do
    expect(bootstrap_run).to create_consul_service_def("default-app_name_with_port")
        .with(name: 'default-app_name_with_port')
        .with(port: 8888)
  end

  it "creates service check with user/password" do
    expect(bootstrap_run).to create_consul_service_def("default-app_name_with_password")
        .with(name: 'default-app_name_with_password')
        .with(check: {:interval=>"30s", :script=>"curl -v http://username:password@app_url"})
  end

  it "create user for consul services" do
    expect(bootstrap_run).to create_user("consul")
  end

   it 'creates a cookbook_file with an explicit action' do
    expect(bootstrap_run).to create_directory('/etc/named')
    expect(bootstrap_run).to create_cookbook_file('/etc/named/consul.conf')
  end
end