class sscontroller {
  package { 'rng-tools':
    ensure => 'installed',
  }

  exec {'rng-setup':
    command => 'rngd -r /dev/urandom',
    path => '/usr/sbin',
    require => Package['rng-tools'],
  }

  file {['/opt/ss', '/opt/ss/etc']:
    ensure => 'directory',
  }
  file {'/opt/ss/etc/ssman.conf.sh':
    content => template('sscontroller/ssman.conf.sh.erb'),
    require => File['/opt/ss/etc'],
  }

  exec {'swiftstack-files':
    creates => '/tmp/swiftstack',
    command => 'mkdir /tmp/swiftstack; cd /tmp/swiftstack;
	for f in setup-swiftstack-2.24.0.2_ebay_2014-06-28.sh SwiftStackController-4.1.0.tar.gz; do
	   wget http://os-swift-proxy.vip.lvs03.paypalc3.com:8080/v1/KEY_0a20f3fbeaf2450a809c107ffa687baf/swiftstack/swiftstack/$f;
	done;
	chmod +x *sh',
    path => ['/bin', '/usr/bin'],
    require => [File['/opt/ss/etc/ssman.conf.sh'],User['swiftstack'],Exec['rng-setup']],
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

  file {'/tmp/swiftstack/configinput':
    source => 'puppet:///modules/sscontroller/configinput',
    require => Exec['swiftstack-files'],
  }

  exec { 'setup-sscontroller':
    command => 'bash /tmp/swiftstack/setup-swiftstack-2.24.0.2_ebay_2014-06-28.sh --skip filesystem 2>&1 >> /tmp/swiftstack/install-output',
    timeout => 0,
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    require => [Exec['swiftstack-files'], File['/tmp/swiftstack/configinput']],
  }

  exec {'reset-localadmin-password':
    require => Exec['setup-sscontroller'],
    creates => '/tmp/swiftstack/localadmin-pw',
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    command => 'sg swiftstack "/deploy/ssman/current/ssman/manage.py user localadmin --traceback --generate-password" > /tmp/swiftstack/localadmin-pw',
  }
}




