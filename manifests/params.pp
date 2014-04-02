# = Class: autossh::params
#
# This class detects parameters for the autossh module.
#
class autossh::params {
  case $::operatingsystem {
    /^(RedHat|CentOS)$/: {
      if $::operatingsystemmajrelease == '6' {
        $init = 'upstart-notnative'
        $configdir = '/etc/autossh'
      } else {
        fail('Unsupported RedHat/CentOS version')
      }
    }
    default: {
      # FIXME: this module was designed to use upstart
      $init = 'upstart'
      # FIXME: for some reason this module created config in /opt/ssh
      $configdir = '/opt/autossh'
    }
  }

}
