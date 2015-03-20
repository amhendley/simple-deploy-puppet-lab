class simple-deployment {
	
	git::clone { 'https://github.com/tnh/simple-sinatra-app':
		path => '/var/www',
		dir => $site_name,
	}

	exec { 'site-install':
		cwd => "/var/www/${site_name}",
		path => "/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		command => 'bundle install --deployment --system',
		provider => shell,
		user => "root",
		group => "root",
		logoutput => true,
		environment => [
			"HOME=/root",
			"LOGNAME=root",
			"USER=root",
		],
		require => [
			File['/var/www'],
			Git::Clone['https://github.com/tnh/simple-sinatra-app'],
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
		mode => 777,
		require => [
			Exec['site-install'], 
			File['/usr/bin/simple-deployment']
		],
	}	

	service { 'simple-deployment-daemon':
		ensure => running,
		enable => true,
		require => [
			Exec['site-install'], 
			File['/etc/init.d/simple-deployment-daemon'],
		],
	}
	
}
