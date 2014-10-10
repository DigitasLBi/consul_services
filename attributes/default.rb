default['consul']['domain'] = 'helios'
default['consul']['version'] = '0.4.0'

default['consul']['checksums'] = {
  '0.4.0_web_ui'       => '0ee574e616864b658ba6ecf16db1183b63c5a4a36401880fb0404a2ea18536a6',
  '0.4.0_linux_amd64'  => '4f8cd1cc5d90be9e1326fee03d3c96289a4f8b9b6ccb062d228125a1adc9ea0c'
}

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
    'forwarders { 169.254.169.253; };'
]

default['consul_dns_config']['node_ttl'] = 60
default['consul_dns_config']['service_ttl'] = 60
default['consul_dns_config']['allow_stale'] = true
default['consul_dns_config']['max_stale'] = 60

default['consul_http_checks'] = [ 
    { "name" => "app_name_with_port", "port" => 8888 },
    { "name" => "app_name", "url" => "http://app_url" },
    { "name" => "app_name_with_password", "url" => "http://app_url", "username" => "username", "password" => "password" }
]