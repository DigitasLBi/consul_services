require 'spec_helper'

def consul_server ipaddress, datacenter
  consul_server = Chef::Node.new()
  consul_server.default['ipaddress'] = ipaddress
  consul_server.default['consul']['datacenter'] = datacenter
  consul_server
end

describe 'consul_services::client' do

  let(:client_run) do
        runner = ChefSpec::Runner.new(platform:'redhat', version:'7.0') do |node|
  
        env = Chef::Environment.new
        env.name 'default'

        node.override['consul']['datacenter'] = "default"

        allow(Chef::Environment).to receive(:load).and_return(env)

        allow(node).to receive(:chef_environment).and_return(env.name)
      end


    stub_search("node", "recipes:consul_services\\:\\:server")
      .and_return([consul_server("console-ip","default")])

    runner.converge(described_recipe,"recipe[consul_services::client]")
  end

  it "create service Consul" do
    expect(client_run).to start_service("consul")
  end

  it "creates resolv.conf with consul servers and domain" do
    expect(client_run).to create_template('/etc/resolv.conf').with_variables(
      {"search"=>"helios", "nameservers"=>["console-ip"], "options"=>{}, "server_role"=>"nameserver"})
  end
end