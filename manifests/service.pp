define autossh::service (
  $user         = "root",
  $monitor_port = 0,
  $remote_user  = undef,
  $remote_host,
  $remote_port,
  $ssh_config,
  $ssh_id_file,
  $real_remote_user
) {

  file { "/etc/init/${service}.conf":
    ensure  => file,
    path    => "/etc/init/${service}.conf",
    owner   => $user,
    group   => $group,
    content => template('autossh/tunnel.conf.erb'),
  }

  service { $service:
    ensure  => $ensure,
    enable  => true,
    require => File[$ssh_config, "/etc/init/${service}.conf"],
  }

}
