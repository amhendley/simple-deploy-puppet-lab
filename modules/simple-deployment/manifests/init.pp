class simple-deployment {
	
	git::clone { 'https://github.com/tnh/simple-sinatra-app':
		path => '/var/www',
		dir => $site_name,
	}
	
	exec { 'site-install':
		cwd => "/var/www/${site_name}",
		command => '/usr/local/bin/bundle install',
		user => "root",
		group => "root",
		logoutput => true,
		unless => '/usr/local/bin/bundle check',
		environment => "HOME=/root",
		require => [
			Package['bundler'], 
			Class['ruby'], 
		],
	}	
	
	file { '/usr/bin/simple-deployment':
		ensure => file,
		content => template('simple-deployment/exec-simple-deployment'),
		mode => 777,
		require => Exec['site-install'],
	}	

	file { '/etc/init.d/simple-deployment-daemon':
		ensure => file,
		content => template('simple-deployment/simple-deployment-daemon'),
		* 
		require => [
			Exec['site-install'], 
			File['/usr/bin/simple-deployment']
		],
	}	

	service { 'simple-deployment-daemon':
		ensure => running,
		enable => true,
		require => File['/etc/init.d/simple-deployment-daemon'],
	}
	
}
