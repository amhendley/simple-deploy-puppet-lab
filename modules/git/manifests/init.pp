class git{
    include git::install
}

class git::install{
    package { 'git:':
        ensure => present
    }
}

define git::clone ( $path, $dir){
    exec { "clone-$name-$path":
        command => "git clone git@github.com:$name $path/$dir",
        creates => "$path/$dir",
        require => [Class["git"], File[$path]],
    }
}
