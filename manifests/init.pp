# == Class: corosync
#
# A simple class to configure corosync services.
#
# === Parameters
#
# Document parameters here.
#
# [*bindnetaddr*]
#  The IP to bind the servies to
#
# [*cluster_name*]
#  The cluster name
#
# [*unicast*]
#  Set this to true if you want to use unicast communications
#
# [*broadcast*]
#  Set this to true if you want to use broadcast communications
#
# [*mcastaddr*]
#  The multicast address, if using multicast
#
# [*mcastport*]
#  The multicast port of the cluster
#
# [*nodes*]
#  The cluster members
#
# [*pacemaker_version*]
#  Set this to the value of the pacemaker protocol. Default is 0.
#
# [*secauth*]
#  Enable or disable secure authentication (default false)
#
# [*authkey*]
#  The authentication key
#
# === Examples
#
#  class {'corosync':
#    bindnetaddr       => $ipaddress,
#    mcastaddr         => '226.94.1.1',
#    mcastport         => 5405,
#    secauth           => false,
#    authkey           => 'puppet:///modules/mymodule/authkey',
#    pacemaker_version => 0
#  }
#
# === Authors
#
# Alessandro De Salvo <Alessandro.DeSalvo@roma1.infn.it>
#
# === Copyright
#
# Copyright 2014 Alessandro De Salvo.
#
class corosync (
  $bindnetaddr       = $ipaddress,
  $broadcast         = false,
  $cluster_name      = 'mycluster',
  $mcastaddr         = undef,
  $mcastport         = 5405,
  $secauth           = false,
  $unicast           = false,
  $nodes             = [],
  $pacemaker_version = 0,
  $authkey
) inherits params {
    package { $corosync::params::corosync_packages: ensure => latest }

    if ($secauth) { $secauth_value = 'on' } else { $secauth_value = 'off' }

    file {$corosync::params::corosync_authkey:
      owner   => root,
      group   => root,
      mode    => 0400,
      source  => $authkey,
      require => Package[$corosync::params::corosync_packages],
      notify  => Service[$corosync::params::corosync_service]
    }

    if (size($nodes) == 2) { $two_node = true }

    file {$corosync::params::corosync_conf:
      owner   => root,
      group   => root,
      mode    => 0644,
      content => template("corosync/corosync_conf.erb"),
      require => File[$corosync::params::corosync_authkey],
      notify  => Service[$corosync::params::corosync_service]
    }

    file {$corosync::params::corosync_service_dir:
      ensure => directory
    }

    file {$corosync::params::corosync_pacemaker:
      owner   => root,
      group   => root,
      mode    => 0644,
      content => template("corosync/corosync_pacemaker.erb"),
      require => File[$corosync::params::corosync_service_dir],
      notify  => Service[$corosync::params::corosync_service]
    }
    if ($pacemaker_version == 1) {
      service { $corosync::params::pacemaker_service:
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require    => [Package[$corosync::params::corosync_packages],File[$corosync::params::corosync_pacemaker]]
      }
    }

    service { $corosync::params::corosync_service:
      ensure     => running,
      enable     => true,
      hasrestart => true,
      require    => [Package[$corosync::params::corosync_packages],File[$corosync::params::corosync_conf]]
    }
}
