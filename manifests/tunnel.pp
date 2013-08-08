define autossh::tunnel (
  $service     = $title,
  $ensure      = 'running',
  $user        = "root",
  $group       = "root",
  $ssh_id_file = "~/.ssh/id_rsa",
  $bind_addr   = undef,
  $host        = "localhost",
  $host_port   = 22,
  $remote_user = $user,
  $remote_host,
  $remote_port,
  $monitor_port        = 0,
  $autossh_background  = false,
  $autossh_gatetime    = undef,
  $autossh_logfile     = undef,
  $autossh_first_poll  = undef,
  $autossh_poll        = undef,
  $autossh_maxlifetime = undef,
  $autossh_maxstart    = undef,
) {

  $ssh_config = "/opt/autossh/${service}"

  file { $ssh_config:
    ensure  => file,
    path    => $ssh_config,
    owner   => $user,
    group   => $group,
    content => template('autossh/ssh_config.erb'),
    require => File["/opt/autossh/"],
  }

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
