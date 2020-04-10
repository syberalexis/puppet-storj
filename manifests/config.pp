# @summary  This class manages configuration files
#
# @param authorization_token
#  Received personal single-use authorization token. See https://documentation.storj.io/before-you-begin/auth-token
# @param bin_dir
#  Directory where binaries are located.
# @param config_dir
#  Directory where configuration are located.
# @param user
#  User running storj.
# @param group
#  Group under which storj is running.
# @example
#   include storj::config
class storj::config (
  Storj::Authorization_token $authorization_token = $storj::authorization_token,
  Stdlib::Absolutepath       $bin_dir             = $storj::bin_dir,
  Stdlib::Absolutepath       $config_dir          = $storj::config_dir,
  String                     $user                = $storj::user,
  String                     $group               = $storj::group,
) {
  exec { 'Request authorization command':
    command   => "${bin_dir}/identity authorize storagenode ${authorization_token} --identity-dir ${config_dir} --config-dir ${config_dir}",
    onlyif    => "/usr/bin/test `grep -c BEGIN ${config_dir}/storagenode/identity.cert` != 3",
    user      => $group,
    group     => $user,
    logoutput => true,
    notify    => Service['storagenode'],
  }
  -> exec { 'Check certs integrity command':
    command   => "/usr/bin/test `grep -c BEGIN ${config_dir}/storagenode/ca.cert` == 2 &&
                  /usr/bin/test `grep -c BEGIN ${config_dir}/storagenode/identity.cert` == 3",
    logoutput => true,
    returns   => 0,
  }
}
