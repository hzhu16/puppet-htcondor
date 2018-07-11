class htcondorce::osg (
  $backend_scheduler = hiera('htcondorce::backend_scheduler'),
) inherits htcondorce::params {

  package { "osg-ca-certs":
    ensure  => latest,
  }
  package { "osg-version":
    ensure  => present,
  }

  package { "osg-configure":
    ensure => present,
  }
  package { "osg-configure-ce":
    ensure => present,
  }
  package { "osg-configure-gateway":
    ensure => present,
  }
  package { "osg-configure-gip":
    ensure => present,
  }
  package { "osg-configure-gratia":
    ensure => present,
  }
  package { "osg-configure-infoservices":
    ensure => present,
  }
  package { "osg-configure-managedfork":
    ensure => present,
  }
  package { "osg-configure-misc":
    ensure => present,
  }
  package { "osg-configure-network":
    ensure => present,
  }
  package { "osg-configure-${backend_scheduler}":
    ensure => present,
  }
  package { "osg-configure-squid":
    ensure => present,
  }

  file { '01-squid.ini':
    ensure  => file,
    path    => '/etc/osg/config.d/01-squid.ini',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('htcondorce/osg/config.d/01-squid.ini.erb'),
    require => Package['osg-configure-squid'],
    notify  => Exec['osg-configure'],
  }

  file { '10-gateway.ini':
    ensure  => file,
    path    => '/etc/osg/config.d/10-gateway.ini',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/htcondorce/osg/config.d/10-gateway.ini',
    require => Package['osg-configure-gateway'],
    notify  => Exec['osg-configure'],
  }

  file { '10-misc.ini':
    ensure  => file,
    path    => '/etc/osg/config.d/10-misc.ini',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('htcondorce/osg/config.d/10-misc.ini.erb'),
    require => Package['osg-configure-misc'],
    notify  => Exec['osg-configure'],
  }

  file { '10-storage.ini':
    ensure  => file,
    path    => '/etc/osg/config.d/10-storage.ini',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content  => template('htcondorce/osg/config.d/10-storage.ini.erb'),
    require => Package['osg-configure-ce'],
    notify  => Exec['osg-configure'],
  }

  file { "20-${backend_scheduler}.ini":
    ensure  => file,
    path    => "/etc/osg/config.d/20-${backend_scheduler}.ini",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("htcondorce/osg/config.d/20-${backend_scheduler}.ini.erb"),
    require => Package["osg-configure-${backend_scheduler}"],
    notify  => Exec['osg-configure'],
  }

  file { '30-gip.ini':
    ensure  => file,
    path    => '/etc/osg/config.d/30-gip.ini',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("htcondorce/osg/config.d/30-gip.ini.erb"),
    require => Package['osg-configure-gip'],
    notify  => Exec['osg-configure'],
  }

  file { '30-infoservices.ini':
    ensure  => file,
    path    => '/etc/osg/config.d/30-infoservices.ini',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/htcondorce/osg/config.d/30-infoservices.ini',
    require => Package['osg-configure-infoservices'],
    notify  => Exec['osg-configure'],
  }

  file { '30-gratia.ini':
    ensure  => file,
    path    => '/etc/osg/config.d/30-gratia.ini',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('htcondorce/osg/config.d/30-gratia.ini.erb'),
    require => Package['osg-configure-gratia'],
    notify  => Exec['osg-configure'],
  }

  file { '40-siteinfo.ini':
    ensure  => file,
    path    => '/etc/osg/config.d/40-siteinfo.ini',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('htcondorce/osg/config.d/40-siteinfo.ini.erb'),
    notify  => Exec['osg-configure'],
    require => Package['osg-configure-ce'],
  }

  exec {"osg-configure":
      path        => "/bin:/usr/bin:/sbin:/usr/sbin",
      command     => "osg-configure -c",
      notify      => Service["condor-ce"],
      refreshonly => true,
      logoutput   => "on_failure",
  }

}
