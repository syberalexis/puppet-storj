# @summary  This class manages configuration files
#
# @param authorization_token
#  Received personal single-use authorization token. See https://documentation.storj.io/before-you-begin/auth-token
# @param bin_dir
#  Directory where binaries are located.
# @param identity_dir
#  Storj identity node directory. See https://documentation.storj.io/dependencies/identity
# @param user
#  User running storj.
# @param group
#  Group under which storj is running.
# @example
#   include storj::config
class storj::config (
  Storj::Authorization_token $authorization_token = $storj::authorization_token,
  Stdlib::Absolutepath       $bin_dir             = $storj::bin_dir,
  Stdlib::Absolutepath       $identity_dir        = $storj::identity_dir,
  String                     $user                = $storj::user,
  String                     $group               = $storj::group,
) {
  exec { 'Request authorization command':
    command   => "${bin_dir}/idetntity authorize storagenode ${authorization_token} --identity-dir ${identity_dir}",
    creates   => "${identity_dir}/storagenode/identity.cert",
    user      => $group,
    group     => $user,
    logoutput => true,
    notify    => Service['storagenode'],
  }
  -> exec { 'Check certs integrity command':
    command   => "/usr/bin/test `grep -c BEGIN ${identity_dir}/storagenode/ca.cert` == 2 &&
                  /usr/bin/test `grep -c BEGIN ${identity_dir}/storagenode/identity.cert` == 3",
    logoutput => true,
    returns   => 0,
  }
}
