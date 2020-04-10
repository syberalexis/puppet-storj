# @summary  This class manages service
#
# @param ensure
#  State ensured from storagenode service.
# @param user
#  User running storj.
# @param group
#  Group under which storj is running.
# @param port
#  Storagenode port (required to be accessible). See https://documentation.storj.io/dependencies/port-forwarding
# @param dashboard_port
#  Dashboard port.
# @param wallet
#  Your wallet address. See https://support.storj.io/hc/en-us/articles/360026611692-How-do-I-hold-STORJ-What-is-a-valid-address-or-compatible-wallet-
# @param mail
#  Your mail address.
# @param host
#  Your node hostname / DNS altname (required to be accessible). See https://documentation.storj.io/dependencies/port-forwarding
# @param storage
#  Amount of dedicated storage.
# @param config_dir
#  Storj identity node directory. See https://documentation.storj.io/dependencies/identity
# @param storage_path
#  Mounted device location.
# @param docker_tag
#  Docker inage tag of storj storagenode.
#    Default to beta.
# @example
#   include storj::service
class storj::service (
  Variant[Stdlib::Ensure::Service, Enum['absent']] $ensure         = $storj::service_ensure,
  String                                           $user           = $storj::user,
  String                                           $group          = $storj::group,
  Stdlib::Port                                     $port           = $storj::port,
  Stdlib::Port                                     $dashboard_port = $storj::dashboard_port,
  String                                           $wallet         = $storj::wallet,
  String                                           $mail           = $storj::mail,
  Stdlib::Host                                     $host           = $storj::host,
  String                                           $storage        = $storj::storage,
  Stdlib::Absolutepath                             $config_dir   = $storj::config_dir,
  Stdlib::Absolutepath                             $storage_path   = $storj::storage_path,
  String                                           $docker_tag     = $storj::docker_tag,
) {
  $_file_ensure    = $ensure ? {
    'running' => file,
    'stopped' => file,
    default   => absent,
  }
  $_service_ensure = $ensure ? {
    'running' => running,
    default   => stopped,
  }

  file { '/lib/systemd/system/storagenode.service':
    ensure  => $_file_ensure,
    content => template('storj/service.erb'),
    notify  => Service['storagenode']
  }
  service { 'storagenode':
    ensure => $_service_ensure,
    enable => true,
  }

  File['/lib/systemd/system/storagenode.service'] -> Service['storagenode']
}
