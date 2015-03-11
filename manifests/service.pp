define autossh::service (
  $ensure       = 'running',
  $enable       = 'true',
  $user         = 'root',
  $ssh_config,
) {
  $service = $title

  include autossh::params

  if $autossh::params::service == 'upstart' {
 
    service { $service:
      ensure  => $ensure,
      enable  => $enable,
      require => File[
        $ssh_config,
        "/etc/init/${service}.conf"
      ],
    }
  }

  if $autossh::params::service == 'systemd' {
  
    service { $service:
      ensure  => $ensure,
      enable  => $enable,
      require => File[
        $ssh_config,
        "/lib/systemd/system/${service}.service"
      ],
    }
  }

}
