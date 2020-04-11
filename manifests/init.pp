# @summary This module manages Storj
#
# Init class of Storj module. It can installes Storj binaries and single Service.
#
# @param authorization_token
#  Received personal single-use authorization token. See https://documentation.storj.io/before-you-begin/auth-token
# @param wallet
#  Your wallet address. See https://support.storj.io/hc/en-us/articles/360026611692-How-do-I-hold-STORJ-What-is-a-valid-address-or-compatible-wallet-
# @param mail
#  Your mail address.
# @param host
#  Your node hostname / DNS altname (required to be accessible). See https://documentation.storj.io/dependencies/port-forwarding
# @param storage
#  Amount of dedicated storage.
# @param storage_path
#  Mounted device location.
# @param version
#  Storj release. See https://github.com/storj/storj/releases
# @param os
#  Operating system.
# @param base_dir
#  Base directory where Storj is extracted.
# @param bin_dir
#  Directory where binaries are located.
# @param base_url
#  Base URL for storj.
# @param download_extension
#  Extension of Storj binaries archive.
# @param download_url
#  Complete URL corresponding to the Storj release, default to undef.
# @param extract_command
#  Custom command passed to the archive resource to extract the downloaded archive.
# @param config_dir
#  Directory where configuration are located.
# @param manage_user
#  Whether to create user for storj or rely on external code for that.
# @param manage_group
#  Whether to create user for storj or rely on external code for that.
# @param user
#  User running storj.
# @param group
#  Group under which storj is running.
# @param usershell
#  if requested, we create a user for storj. The default shell is false. It can be overwritten to any valid path.
# @param extra_groups
#  Add other groups to the managed user.
# @param service_ensure
#  State ensured from storagenode service.
# @param docker_tag
#  Docker inage tag of storj storagenode.
#    Default to beta.
# @param port
#  Storagenode port (required to be accessible). See https://documentation.storj.io/dependencies/port-forwarding
# @param dashboard_port
#  Dashboard port.
# @param manage_docker
#  Whether to install docker or rely on external code for that.
#  Docker is required to run storagenode image.
# @example
#   include storj
class storj (
  Storj::Authorization_token                       $authorization_token,
  String                                           $wallet,
  String                                           $mail,
  Stdlib::Host                                     $host,
  String                                           $storage,
  Stdlib::Absolutepath                             $storage_path,
  Pattern[/\d+\.\d+\.\d+/]                         $version            = '1.1.1',
  String                                           $os                 = downcase($facts['kernel']),

  # Installation
  Stdlib::Absolutepath                             $base_dir           = '/opt',
  Stdlib::Absolutepath                             $bin_dir            = '/usr/local/bin',
  Stdlib::HTTPUrl                                  $base_url           = 'https://github.com/storj/storj/releases/download',
  String                                           $download_extension = 'zip',
  Optional[Stdlib::HTTPUrl]                        $download_url       = undef,
  Optional[String]                                 $extract_command    = undef,
  Stdlib::Absolutepath                             $config_dir         = '/etc/storj',

  # User Management
  Boolean                                          $manage_user        = true,
  Boolean                                          $manage_group       = true,
  String                                           $user               = 'storj',
  String                                           $group              = 'storj',
  Stdlib::Absolutepath                             $usershell          = '/bin/false',
  Array[String]                                    $extra_groups       = [],

  # Service
  Variant[Stdlib::Ensure::Service, Enum['absent']] $service_ensure     = 'running',
  String                                           $docker_tag         = 'beta',
  Stdlib::Port                                     $port               = 28967,
  Stdlib::Port                                     $dashboard_port     = 14002,

  # Extra Management
  Boolean                                          $manage_docker      = true,
) {
  case $facts['architecture'] {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'aarch64'        : { $arch = 'arm64' }
    'armv7l'         : { $arch = 'arm'   }
    default: {
      fail("Unsupported kernel architecture: ${facts['architecture']}")
    }
  }

  if $download_url {
    $real_download_url = $download_url
  } else {
    $real_download_url = "${base_url}/v${version}/identity_${os}_${arch}.${download_extension}"
  }

  include storj::install
  include storj::config
  include storj::service

  Class['storj::install'] -> Class['storj::config'] -> Class['storj::service']

  if $manage_docker {
    include docker

    Class['docker'] -> Class['storj::install']
  }
}
