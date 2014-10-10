require 'spec_helper'

def consul_server ipaddress
  consul_server = Chef::Node.new()
  consul_server.default[:ipaddress] = ipaddress
  consul_server
end

describe 'consul_services::client' do

  let(:client_run) do
        runner = ChefSpec::Runner.new(platform:'redhat', version:'7.0') do |node|
  
        env = Chef::Environment.new
        env.name 'default'

        allow(Chef::Environment).to receive(:load).and_return(env)

        allow(node).to receive(:chef_environment).and_return(env.name)
      end


    stub_search("node", "recipes:consul_services\\:\\:server AND chef_environment:default")
      .and_return([consul_server("console-ip")])

    runner.converge(described_recipe,"recipe[consul_services::client]")
  end

  it "create service Consul" do
    expect(client_run).to start_service("consul")
  end
end