stage { 'first':
  before => Stage['main'],
}

# be hacky first update sources list, before main stage
class apt_update {
  exec { "update_sources_list":
    command => "/usr/bin/apt-get update",
  }
}

class { "apt_update":
  stage   => first,
}

# Graylog2 Dashboard
package { 'apache2':
  ensure => present,
  notify => Service['apache2'],
}

service { 'apache2':
  ensure  => running,
  require => Package['apache2'],
}

file { '/var/www':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
}

file { '/var/www/graylog2-stream-dashboard':
  ensure => link,
  target => '/usr/share/graylog2-stream-dashboard',
}

class { 'mongodb':
  enable_10gen => true,
  noauth       => true,
  fork         => false,
}

# Init Script that 10gen is broken, replace it
file { "/etc/init.d/mongodb":
  ensure => present,
  owner  => "root",
  group  => "root",
  mode   => "0755",
  source => "puppet:///modules/default/mongodb.init",
  before => Class['mongodb'],
}

package { "openjdk-7-jre-headless":
  ensure => latest,
}

class { 'elasticsearch':
  config                 => {
    'cluster'            => {
      'name'             => 'graylog2'
    }
  },
  package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.10.deb',
  require     => Package["openjdk-7-jre-headless"],
}

class { 'graylog2':
  web_graylog2_server_address => "http://${::ipaddress}:12900/",
  web_timezone                => "Europe/Berlin",
  web_secret                  => "G3n133XvTHhvhkEWNMLUgKk0BaYAcpN85eJggjsCr5yyViwuq7y2Bs6U88xHmfG33e5r3IjE38padqS3S49QMRZ8pzZgndfL",
  password_secret             => "kuY4TrWvjYeh3yqrUPXvgtN2fk9ErquTuQFtqiswYF8OhPYoQbNkjQXJuXSXuMzGpUz97v2gl9tImrFnpQZG670cBf0QOlLG",
  root_password_sha2          => "e3c652f0ba0b4801205814f8b6bc49672c4c74e25b497770bb89b22cdeb4e951",
  require                     => [ Class['mongodb'], Class['elasticsearch'] ],
}

package { [ "ruby-gelf", "curl", "moreutils" ]:
  ensure => latest,
}

# Login: http://localhost:9000
# Username: admin
# Password: yourpassword
