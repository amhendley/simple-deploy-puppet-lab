node 'puppet-lab' {
	include nginx

	$site_name = 'simple-deployment'
	$site_domain = 'simple-deployment.com'

	git::clone { 'https://github.com/tnh/simple-sinatra-app':
		path => '/var/www',
		dir => <%= @site_name %>,
	}
	
	exec { 'site-install':
		cwd => '/var/www/$site_name',
		command => 'bundle install',
	}	


	file { '/etc/nginx/sites-available/$site_name':
		require => [
			Package['nginx'],
			File['/var/www'],
		]
		ensure => 'file',
		content => template('nginx/simple-deployment.conf.erb'),
		
		notify => Service['nginx']
	}
	
	file { '/etc/nginx/sites-enabled/$site_name':
		require => File['/etc/nginx/sites-available/$site_name'],
		ensure => 'link',
		target => '/etc/nginx/sites-available/$site_name',
		notify => Service['nginx']
	}	
}
