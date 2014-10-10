if defined?(ChefSpec)
  ChefSpec::Runner.define_runner_method :consul_service_def

  def create_consul_service_def(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new("consul_service_def", :create, resource_name)
  end
end