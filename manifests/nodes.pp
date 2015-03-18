node 'puppet-lab' {
	include nginx
	include ruby
	include simple-deployment

	$site_name = 'simple-deployment'
	$site_domain = 'simple-deployment.com'

	file { "/etc/nginx/sites-available/${site_name}":
		require => [
			Package['nginx'],
			File['/var/www'],
			Service['simple-deployment-daemon'],
		],
		ensure => file,
		content => template('nginx/simple-deployment.conf.erb'),
		notify => Service['nginx'],
	}
	
	file { "/etc/nginx/sites-enabled/${site_name}":
		ensure => link,
		target => "/etc/nginx/sites-available/${site_name}",
		require => [
			Exec['simple-deployment-daemon'], 
			File["/etc/nginx/sites-available/${site_name}"]
		],
		notify => Service['nginx'],
	}	

}
