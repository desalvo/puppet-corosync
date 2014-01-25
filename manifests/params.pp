class corosync::params {

  case $::osfamily {
    'RedHat': {
      $corosync_packages = [ 'corosync', 'pacemaker', 'pcs' ]
      $corosync_service = 'corosync'
      $corosync_conf = '/etc/corosync/corosync.conf'
      $corosync_service_dir = '/etc/corosync/service.d' 
      $corosync_pacemaker = "${corosync_service_dir}/pacemaker"
      $corosync_authkey = '/etc/corosync/authkey'
    }
    default:   {
    }
  }

}
