require 'spec_helper'

def consul_server ipaddress, datacenter
  consul_server = Chef::Node.new()
  consul_server.default['ipaddress'] = ipaddress
  consul_server.default['consul']['datacenter'] = datacenter
  consul_server
end

describe 'consul_services::server' do

  let(:consul_dns_run) do
        runner = ChefSpec::Runner.new(platform:'redhat', version:'6.5') do |node|
  
        env = Chef::Environment.new
        env.name 'default'

        node.override['consul']['datacenter'] = "default"

        allow(Chef::Environment).to receive(:load).and_return(env)

        allow(node).to receive(:chef_environment).and_return(env.name)
      end

    stub_search("node", "recipes:consul_services\\:\\:server")
      .and_return([consul_server("console-ip","default")])

    runner.converge(described_recipe,"recipe[consul_services::server]")
  end

  it "create dns template" do
    expect(consul_dns_run).to create_template("/etc/consul.d/dns_config.json")
    .with_variables({:max_stale => 120, :allow_stale => true, :node_ttl => 240, :service_ttl => 60})
  end

  it "creates service check for dns" do
    expect(consul_dns_run).to create_consul_service_def("default-consul-dns")
        .with(name: 'default-consul-dns')
        .with(port: 8600)
    end

  it "creates service check for ui" do
    expect(consul_dns_run).to create_consul_service_def("default-consul-ui")
        .with(name: 'default-consul-ui')
        .with(check: {:interval=>"30s", :script=>"curl -v http://localhost:8500/ui/consul_ui"})
  end
end