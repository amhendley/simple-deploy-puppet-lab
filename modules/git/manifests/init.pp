class git {
    package { 'git':
        ensure => installed,
    }
}

define git::clone ( $path, $dir) {
    exec { "clone-$name-$path":
        command => "/usr/bin/git clone $name $path/$dir",
        creates => "$path/$dir",
        require => File[$path],
    }
}
