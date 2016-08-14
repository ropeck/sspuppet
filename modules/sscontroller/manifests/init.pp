class sscontroller {
  file { '/tmp/testfile':
	ensure => file,
	source => 'puppet:///modules/sscontroller/testfile',
  }

  package { 'rng-tools':
    ensure => 'installed',
  }

  exec {'rng-setup':
    command => 'rngd -r /dev/urandom',
    path => '/usr/sbin',
    require => Package['rng-tools'],
  }
}




