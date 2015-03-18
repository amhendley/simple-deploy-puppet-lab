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
		],
		ensure => file,
		content => template('nginx/simple-deployment.conf.erb'),
		require => Exec['site-run'],
		notify => Service['nginx'],
	}
	
	file { "/etc/nginx/sites-enabled/${site_name}":
		require => File["/etc/nginx/sites-available/${site_name}"],
		ensure => link,
		target => "/etc/nginx/sites-available/${site_name}",
		require => Exec['site-run'],
		notify => Service['nginx'],
	}	

}
