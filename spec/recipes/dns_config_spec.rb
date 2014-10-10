require 'spec_helper'

def consul_server ipaddress
  consul_server = Chef::Node.new()
  consul_server.default[:ipaddress] = ipaddress
  consul_server
end

describe 'consul_services::server' do

  let(:consul_dns_run) do
        runner = ChefSpec::Runner.new(platform:'redhat', version:'6.5') do |node|
  
        env = Chef::Environment.new
        env.name 'default'

        allow(Chef::Environment).to receive(:load).and_return(env)

        allow(node).to receive(:chef_environment).and_return(env.name)
      end

    stub_search("node", "recipes:consul_services\\:\\:server AND chef_environment:default")
      .and_return([consul_server("console-ip")])

    runner.converge(described_recipe,"recipe[consul_services::server]")
  end

  it "create dns template" do
    expect(consul_dns_run).to create_template("/etc/consul.d/dns_config.json")
    .with_variables({:max_stale => 60, :allow_stale => true, :node_ttl => 60, :service_ttl => 60})
  end
end