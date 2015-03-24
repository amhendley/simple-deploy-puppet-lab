
class ruby {
	package { 'ruby2.0':
		ensure => installed,
	}
	
	package { 'ruby2.0-dev':
		ensure => installed,
		require => Package['ruby2.0'],
	}

	file { '/var/lib/gems/2.1.0/cache':
		mode => 777,
	}
	
	package { 'bundler':
		ensure   => 'installed',
		provider => 'gem',
		require => [
			Package['ruby2.0'],
			File['/var/lib/gems/2.1.0/cache'],
		],
	}

	package { 'rack':
		ensure   => 'installed',
		provider => 'gem',
		require => [
			Package['ruby2.0'],
			File['/var/lib/gems/2.1.0/cache'],
		],
	}

	package { 'rack-protection':
		ensure   => 'installed',
		provider => 'gem',
		require => [
			Package['ruby2.0'],
			File['/var/lib/gems/2.1.0/cache'],
		],
	}

	package { 'tilt':
		ensure   => 'installed',
		provider => 'gem',
		require => [
			Package['ruby2.0'],
			File['/var/lib/gems/2.1.0/cache'],
		],
	}

	package { 'sinatra':
		ensure   => 'installed',
		provider => 'gem',
		require => [
			Package['ruby2.0'],
			File['/var/lib/gems/2.1.0/cache'],
		],
	}
	
	package { 'unicorn':
		ensure => 'installed',
		require => Package['ruby2.0-dev'],
	}
}
