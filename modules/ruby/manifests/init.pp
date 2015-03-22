
class ruby {
	package { 'ruby2.0':
		ensure => installed,
	}

	package { 'bundler':
		ensure   => 'installed',
		provider => 'gem',
		require => Package['ruby2.0'],
	}

	package { 'ruby-rack':
		ensure   => 'installed',
		provider => 'gem',
		require => Package['ruby2.0'],
	}

	package { 'ruby-rack-protection':
		ensure   => 'installed',
		provider => 'gem',
		require => Package['ruby2.0'],
	}

	package { 'ruby-tilt':
		ensure   => 'installed',
		provider => 'gem',
		require => Package['ruby2.0'],
	}

	package { 'ruby-sinatra':
		ensure   => 'installed',
		provider => 'gem',
		require => Package['ruby2.0'],
	}
	
}
