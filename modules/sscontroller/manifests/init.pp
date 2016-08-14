class sscontroller {
  file { '/tmp/testfile':
	ensure => file,
	source => 'puppet:///modules/sscontroller/testfile',
  }
}




