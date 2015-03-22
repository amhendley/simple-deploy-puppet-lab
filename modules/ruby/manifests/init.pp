
class ruby {
	package { 'ruby2.0':
		ensure => installed,
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
	
}
