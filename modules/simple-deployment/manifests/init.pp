class simple-deployment {
	
	git::clone { 'https://github.com/tnh/simple-sinatra-app':
		path => '/var/www',
		dir => $site_name,
	}

	service { 'simple-deployment-daemon':
		ensure => running,
		enable => true,
		require => [
			Exec['site-install'], 
			File['/etc/init.d/simple-deployment-daemon'],
		],
	}
	
	exec { 'site-install':
		cwd => "/var/www/${site_name}",
		path => "/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		command => 'bundle install',
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
		],
	}	
	
	file { '/etc/init.d/simple-deployment-daemon':
		ensure => file,
		content => template('simple-deployment/simple-deployment-daemon'),
		mode => 777,
		require => Exec['site-install'], 
	}	

	file { "/etc/nginx/sites-available/${site_name}":
		require => [
			Package['nginx'],
			File['/var/www'],
			Service['simple-deployment-daemon'],
		],
		ensure => file,
		content => template('simple-deployment/nginx-site.conf.erb'),
		notify => Service['nginx'],
		require => [
			Service['nginx'],
			Exec['site-install'],
		],
	}
	
	file { "/etc/nginx/sites-enabled/${site_name}":
		ensure => link,
		target => "/etc/nginx/sites-available/${site_name}",
		require => [
			Service['simple-deployment-daemon'], 
			File["/etc/nginx/sites-available/${site_name}"]
		],
		notify => Service['nginx'],
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
		require => Exec['site-install'],
	}	

}
