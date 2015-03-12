define autossh::config (
  $user         = 'root',
  $monitor_port = 0,
  $remote_user  = undef,
  $remote_host,
  $remote_port,
  $ssh_config,
  $ssh_id_file,
  $remote_user,
  $autossh_background  = false,
  $autossh_gatetime    = undef,
  $autossh_logfile     = undef,
  $autossh_first_poll  = undef,
  $autossh_poll        = undef,
  $autossh_maxlifetime = undef,
  $autossh_maxstart    = undef,
) {
  $service = $title

  include autossh::params

  if $autossh::params::service == 'upstart' {
    file { "/etc/init/${service}.conf":
      ensure  => file,
      path    => "/etc/init/${service}.conf",
      owner   => $user,
      group   => $group,
      content => template('autossh/service/upstart'),
    }
  }

  if $autossh::params::service == 'systemd' {
    file { "/lib/systemd/system/${service}.service":
      ensure  => file,
      owner   => $user,
      group   => $group,
      content => template('autossh/service/systemd'),
    }
  }

}
