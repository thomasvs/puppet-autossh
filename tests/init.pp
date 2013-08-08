Exec {
  path => '/usr/bin:/bin:/usr/sbin:/sbin'
}
exec {'apt-get update': } -> Package<||>

include autossh

$username = "ubuntu"

group { $username:
  ensure => present,
}

user { $username:
  ensure     => present,
  gid        => $username,
  home       => "/home/${username}",
  managehome => true,
}

file {
  "/home/${username}/.ssh":
    ensure => directory,
    owner  => $username;
  "/home/${username}/.ssh/id_rsa":
    ensure => file,
    mode   => "0400",
    source => "puppet:///modules/adcade/id_rsa",
    owner  => $username;
  "/home/${username}/.ssh/id_rsa.pub":
    ensure => present,
    mode   => "0644",
    source => "puppet:///modules/adcade/id_rsa.pub",
    owner  => $username;
}

autossh::tunnel { "jenkins":
  user        => $username,
  group       => $username,
  ssh_id_file => "/home/${username}/.ssh/id_rsa",
  remote_port => 22222,
  remote_host => "vpn.adcade.com",
}

