default['consul']['domain'] = 'helios'

default['consul']['log_level'] = "warn"

include_attribute 'bind'
default['bind']['masters'] = []
default['bind']['ipv6_listen'] = true
default['bind']['zonetype'] = 'forward'
default['bind']['included_files'] = [ 'consul.conf', 'named.options' ]
default['bind']['options'] = [
    'listen-on port 53 {  any; };',
    'listen-on-v6 port 53 { any; };',
    'recursion yes;',
    'dnssec-enable no;',
    'dnssec-validation no;',
    'bindkeys-file "/etc/named.iscdlv.key";',
    'managed-keys-directory "/var/named/dynamic";',
    'forward first;',
    'forwarders { 169.254.169.253; };',
    'allow-recursion { "any"; };'
]

default['consul_dns_config']['node_ttl'] = 240
default['consul_dns_config']['service_ttl'] = 60
default['consul_dns_config']['allow_stale'] = true
default['consul_dns_config']['max_stale'] = 120

default['consul_http_checks'] = [ 
    { "name" => "app_name_with_port", "port" => 8888 },
    { "name" => "app_name", "url" => "http://app_url" },
    { "name" => "app_name_with_password", "url" => "http://app_url", "username" => "username", "password" => "password" }
]