
class ruby {
	package { 'ruby2.0':
		ensure => installed,
	}

	package { 'bundler':
		ensure   => 'installed',
		provider => 'gem',
		require => Package['ruby2.0'],
	}
	
}
