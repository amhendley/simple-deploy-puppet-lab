
class ruby {
	package { 'ruby2.0':
		ensure => installed,
	}
	
	package { 'ruby2.0-dev':
		ensure => installed,
		require => Package['ruby2.0'],
	}

	package { 'bundler':
		ensure   => 'installed',
		provider => 'gem',
		require => Package['ruby2.0'],
	}

	package { 'rack':
		ensure   => 'installed',
		provider => 'gem',
		require => Package['ruby2.0'],
	}

	package { 'rack-protection':
		ensure   => 'installed',
		provider => 'gem',
		require => Package['ruby2.0'],
	}

	package { 'tilt':
		ensure   => 'installed',
		provider => 'gem',
		require => Package['ruby2.0'],
	}

	package { 'sinatra':
		ensure   => 'installed',
		provider => 'gem',
		require => Package['ruby2.0'],
	}
	
	package { 'unicorn':
		ensure => 'installed',
		provider => 'gem',
		require => Package['ruby2.0-dev'],
	}
}
