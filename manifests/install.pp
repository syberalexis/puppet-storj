# @summary This class install Storj requirements and binaries.
#
# @param version
#  Storj release. See https://github.com/storj/storj/releases
# @param os
#  Operating system.
# @param arch
#  Architecture (amd64, arm64 or arm).
# @param base_dir
#  Base directory where Storj is extracted.
# @param bin_dir
#  Directory where binaries are located.
# @param download_extension
#  Extension of Storj binaries archive.
# @param download_url
#  Complete URL corresponding to the Storj release, default to undef.
# @param extract_command
#  Custom command passed to the archive resource to extract the downloaded archive.
# @param manage_user
#  Whether to create user for storj or rely on external code for that.
# @param manage_group
#  Whether to create user for storj or rely on external code for that.
# @param user
#  User running storj.
# @param group
#  Group under which storj is running.
# @param home
#  User's home running storj.
# @param usershell
#  if requested, we create a user for storj. The default shell is false. It can be overwritten to any valid path.
# @param extra_groups
#  Add other groups to the managed user.
# @example
#   include storj::install
class storj::install (
  Pattern[/\d+\.\d+\.\d+/] $version            = $storj::version,
  String                   $os                 = $storj::os,
  String                   $arch               = $storj::arch,
  Stdlib::Absolutepath     $base_dir           = $storj::base_dir,
  Stdlib::Absolutepath     $bin_dir            = $storj::bin_dir,
  String                   $download_extension = $storj::download_extension,
  Stdlib::HTTPUrl          $download_url       = $storj::real_download_url,
  Optional[String]         $extract_command    = $storj::extract_command,

  # User Management
  Boolean                  $manage_user        = $storj::manage_user,
  Boolean                  $manage_group       = $storj::manage_group,
  String                   $user               = $storj::user,
  String                   $group              = $storj::group,
  String                   $home               = $storj::home,
  Stdlib::Absolutepath     $usershell          = $storj::usershell,
  Array[String]            $extra_groups       = $storj::extra_groups,
) {
  archive { "/tmp/identity_${version}.${download_extension}":
    ensure          => 'present',
    extract         => true,
    extract_path    => "${base_dir}/storj-${version}.${os}-${arch}",
    source          => $download_url,
    checksum_verify => false,
    creates         => "${base_dir}/storj-${version}.${os}-${arch}/identity",
    cleanup         => true,
    extract_command => $extract_command,
  }
  file {
    "${base_dir}/storj-${version}.${os}-${arch}":
      ensure => 'directory';
    "${base_dir}/storj-${version}.${os}-${arch}/identity":
      owner => 'root',
      group => 0, # 0 instead of root because OS X uses "wheel".
      mode  => '0555';
    "${bin_dir}/identity":
      ensure => link,
      target => "${base_dir}/storj-${version}.${os}-${arch}/identity";
  }

  File["${base_dir}/storj-${version}.${os}-${arch}"]
  -> Archive["/tmp/identity_${version}.${download_extension}"]
  -> File["${base_dir}/storj-${version}.${os}-${arch}/identity"]
  -> File["${bin_dir}/identity"]

  if $manage_user {
    ensure_resource('user', [ $user ], {
      ensure => 'present',
      system => true,
      home   => $home,
      groups => concat([$group, 'docker'], $extra_groups),
      shell  => $usershell,
    })

    file { $home:
      ensure => 'directory',
      owner  => $user,
      group  => $group,
    }

    User[$user] -> File[$home]

    if $manage_group {
      Group[$group] -> User[$user]
    }
  }
  if $manage_group {
    ensure_resource('group', [ $group ],{
      ensure => 'present',
      system => true,
    })
  }
}
