name             'serf-munin'
maintainer       'ikeda-y'
maintainer_email ''
license          'All rights reserved'
description      'Installs/Configures serf-munin'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'monit'
depends 'munin'

recipe 'serf-munin::master', 'Setup serf, munin-master and monit'
recipe 'serf-munin::node', 'Setup serf, munin-node and monit'
