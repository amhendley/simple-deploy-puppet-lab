class simple-deployment {
	
	git::clone { 'https://github.com/tnh/simple-sinatra-app':
		path => '/var/www',
		dir => $site_name,
	}

	exec { 'site-install':
		cwd => "/var/www/${site_name}",
		path => "/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		command => 'bundle install',
		provider => shell,
		user => "www-data",
		group => "www-data",
		logoutput => true,
		environment => [
			"HOME=/root",
			"LOGNAME=www-data",
			"USER=www-data",
		],
		require => [
			File['/var/www'],
			Git::Clone['https://github.com/tnh/simple-sinatra-app'],
			Package['bundler'],
		],
	}	
	
	file { '/var/www/simple-deployment/unicorn-launcher.rb':
		ensure => file,
		content => template('simple-deployment/unicorn.rb.erb'),
		mode => 440,
		require => [
			Exec['site-install'],
			Package['unicorn'],
		],
	}
	
	file { '/usr/bin/simple-deployment.rb':
		ensure => file,
		content => template('simple-deployment/exec-simple-deployment.rb.erb'),
		mode => 777,
		require => Exec['site-install'],
	}	

	file { '/usr/bin/simple-deployment':
		ensure => file,
		content => template('simple-deployment/exec-simple-deployment'),
		mode => 777,
		require => [
			File['/var/www/simple-deployment/unicorn-launcher.rb'],
			Exec['site-install'],
		],
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
