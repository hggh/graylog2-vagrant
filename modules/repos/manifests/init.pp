class repos($distribution = "wheezy") {
  include apt
  apt::source { "${distribution}-backports":
    ensure   => present,
    location => 'http://http.debian.net/debian',
    release  => "${distribution}-backports",
    repos    => 'main',
  }
}
