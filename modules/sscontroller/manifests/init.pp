class sscontroller {
  package { 'rng-tools':
    ensure => 'installed',
  }

  exec {'rng-setup':
    command => 'rngd -r /dev/urandom',
    path => '/usr/sbin',
    require => Package['rng-tools'],
  }

  file {'/opt/ss/etc/ssman.conf.sh':
    source => 'puppet:///modules/sscontroller/ssman.conf.sh',
  }

  exec {'swiftstack-files':
    creates => '/tmp/swiftstack',
    command => 'mkdir /tmp/swiftstack; cd /tmp/swiftstack;
	for f in setup-swiftstack-2.24.0.2_ebay_2014-06-28.sh SwiftStackController-4.1.0.tar.gz; do
	   wget http://os-swift-proxy.vip.lvs03.paypalc3.com:8080/v1/KEY_0a20f3fbeaf2450a809c107ffa687baf/swiftstack/swiftstack/$f;
	done;
	chmod +x *sh',
    path => ['/bin', '/usr/bin'],
    require => [File['/opt/ss/etc/ssman.conf.sh'],User['swiftstack']],
  }


  group { 'swiftstack':
    gid => 1001,
  }

  user { 'swiftstack':
    ensure     => 'present',
    managehome => true,
    uid => 1001,
    groups => 'swiftstack',
    require => Group['swiftstack'],
  }
}




