name             'consul_services'
maintainer       'DigitasLBi'
maintainer_email 'goncalo.pereira@digitaslbi.com'
license          'All rights reserved'
description      'Installs/Configures consul_server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.13'

depends 'consul'
depends 'bind'
depends 'resolver'