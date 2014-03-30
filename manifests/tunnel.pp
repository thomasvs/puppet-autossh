define autossh::tunnel (
  $service             = $title,
  $ensure              = 'running',
  $user                = 'root',
  $group               = 'root',
  $ssh_id_file         = '~/.ssh/id_rsa',
  $bind_addr           = undef,
  $host                = 'localhost',
  $host_port           = 22,
  $remote_user         = undef,
  $remote_host,
  $remote_port,
  $monitor_port        = 0,
  $remote_forwarding   = true,
  $autossh_background  = false,
  $autossh_gatetime    = undef,
  $autossh_logfile     = undef,
  $autossh_first_poll  = undef,
  $autossh_poll        = undef,
  $autossh_maxlifetime = undef,
  $autossh_maxstart    = undef,
) {

  $ssh_config = "/opt/autossh/${service}.conf"

  if $remote_forwarding == true {
    $template_path = 'autossh/remoteforward.config.erb'
  } else {
    $template_path = 'autossh/localforward.config.erb'
  }

  file { $ssh_config:
    ensure  => file,
    path    => $ssh_config,
    owner   => $user,
    group   => $group,
    content => template($template_path),
    require => File['/opt/autossh/'],
  }

  autossh::tunnel::config::upstart { $service:
    service             => $service,
    user                => $user,
    group               => $group,
    ssh_id_file         => $ssh_id_file,
    remote_user         => $remote_user,
    remote_host         => $remote_host,
    monitor_port        => $monitor_port,
    autossh_background  => $autossh_background,
    autossh_gatetime    => $autossh_gatetime,
    autossh_logfile     => $autossh_logfile,
    autossh_first_poll  => $autossh_first_poll,
    autossh_poll        => $autossh_poll,
    autossh_maxlifetime => $autossh_maxlifetime,
    autossh_maxstart    => $autossh_maxstart,
    ssh_config          => $ssh_config,
  }

  autossh::tunnel::service::upstart { $service:
    ensure     => $ensure,
    ssh_config => $ssh_config,
  }
}
