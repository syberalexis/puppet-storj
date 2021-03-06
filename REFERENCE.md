# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

* [`storj`](#storj): This module manages Storj
* [`storj::config`](#storjconfig): This class manages configuration files
* [`storj::install`](#storjinstall): This class install Storj requirements and binaries.
* [`storj::service`](#storjservice): This class manages service

**Data types**

* [`Storj::Authorization_token`](#storjauthorization_token): Storj authorization token. See https://documentation.storj.io/before-you-begin/auth-token

## Classes

### storj

Init class of Storj module. It can installes Storj binaries and single Service.

#### Examples

##### 

```puppet
include storj
```

#### Parameters

The following parameters are available in the `storj` class.

##### `authorization_token`

Data type: `Storj::Authorization_token`

Received personal single-use authorization token. See https://documentation.storj.io/before-you-begin/auth-token

##### `wallet`

Data type: `String`

Your wallet address. See https://support.storj.io/hc/en-us/articles/360026611692-How-do-I-hold-STORJ-What-is-a-valid-address-or-compatible-wallet-

##### `mail`

Data type: `String`

Your mail address.

##### `host`

Data type: `Stdlib::Host`

Your node hostname / DNS altname (required to be accessible). See https://documentation.storj.io/dependencies/port-forwarding

##### `storage`

Data type: `String`

Amount of dedicated storage.

##### `storage_path`

Data type: `Stdlib::Absolutepath`

Mounted device location.

##### `version`

Data type: `Pattern[/\d+\.\d+\.\d+/]`

Storj release. See https://github.com/storj/storj/releases

Default value: '1.1.1'

##### `os`

Data type: `String`

Operating system.

Default value: downcase($facts['kernel'])

##### `base_dir`

Data type: `Stdlib::Absolutepath`

Base directory where Storj is extracted.

Default value: '/opt'

##### `bin_dir`

Data type: `Stdlib::Absolutepath`

Directory where binaries are located.

Default value: '/usr/local/bin'

##### `base_url`

Data type: `Stdlib::HTTPUrl`

Base URL for storj.

Default value: 'https://github.com/storj/storj/releases/download'

##### `download_extension`

Data type: `String`

Extension of Storj binaries archive.

Default value: 'zip'

##### `download_url`

Data type: `Optional[Stdlib::HTTPUrl]`

Complete URL corresponding to the Storj release, default to undef.

Default value: `undef`

##### `extract_command`

Data type: `Optional[String]`

Custom command passed to the archive resource to extract the downloaded archive.

Default value: `undef`

##### `config_dir`

Data type: `Stdlib::Absolutepath`

Directory where configuration are located.

Default value: '/etc/storj'

##### `manage_user`

Data type: `Boolean`

Whether to create user for storj or rely on external code for that.

Default value: `true`

##### `manage_group`

Data type: `Boolean`

Whether to create user for storj or rely on external code for that.

Default value: `true`

##### `user`

Data type: `String`

User running storj.

Default value: 'storj'

##### `group`

Data type: `String`

Group under which storj is running.

Default value: 'storj'

##### `user_shell`

Data type: `Stdlib::Absolutepath`

if requested, we create a user for storj. The default shell is false. It can be overwritten to any valid path.

Default value: '/bin/false'

##### `extra_groups`

Data type: `Array[String]`

Add other groups to the managed user.

Default value: []

##### `service_ensure`

Data type: `Variant[Stdlib::Ensure::Service, Enum['absent']]`

State ensured from storagenode service.

Default value: 'running'

##### `docker_tag`

Data type: `String`

Docker inage tag of storj storagenode.
  Default to beta.

Default value: 'beta'

##### `port`

Data type: `Stdlib::Port`

Storagenode port (required to be accessible). See https://documentation.storj.io/dependencies/port-forwarding

Default value: 28967

##### `dashboard_port`

Data type: `Stdlib::Port`

Dashboard port.

Default value: 14002

##### `manage_docker`

Data type: `Boolean`

Whether to install docker or rely on external code for that.
Docker is required to run storagenode image.

Default value: `true`

### storj::config

This class manages configuration files

#### Examples

##### 

```puppet
include storj::config
```

#### Parameters

The following parameters are available in the `storj::config` class.

##### `authorization_token`

Data type: `Storj::Authorization_token`

Received personal single-use authorization token. See https://documentation.storj.io/before-you-begin/auth-token

Default value: $storj::authorization_token

##### `bin_dir`

Data type: `Stdlib::Absolutepath`

Directory where binaries are located.

Default value: $storj::bin_dir

##### `config_dir`

Data type: `Stdlib::Absolutepath`

Directory where configuration are located.

Default value: $storj::config_dir

##### `user`

Data type: `String`

User running storj.

Default value: $storj::user

##### `group`

Data type: `String`

Group under which storj is running.

Default value: $storj::group

### storj::install

This class install Storj requirements and binaries.

#### Examples

##### 

```puppet
include storj::install
```

#### Parameters

The following parameters are available in the `storj::install` class.

##### `version`

Data type: `Pattern[/\d+\.\d+\.\d+/]`

Storj release. See https://github.com/storj/storj/releases

Default value: $storj::version

##### `os`

Data type: `String`

Operating system.

Default value: $storj::os

##### `arch`

Data type: `String`

Architecture (amd64, arm64 or arm).

Default value: $storj::arch

##### `base_dir`

Data type: `Stdlib::Absolutepath`

Base directory where Storj is extracted.

Default value: $storj::base_dir

##### `bin_dir`

Data type: `Stdlib::Absolutepath`

Directory where binaries are located.

Default value: $storj::bin_dir

##### `download_extension`

Data type: `String`

Extension of Storj binaries archive.

Default value: $storj::download_extension

##### `download_url`

Data type: `Stdlib::HTTPUrl`

Complete URL corresponding to the Storj release, default to undef.

Default value: $storj::real_download_url

##### `extract_command`

Data type: `Optional[String]`

Custom command passed to the archive resource to extract the downloaded archive.

Default value: $storj::extract_command

##### `config_dir`

Data type: `Stdlib::Absolutepath`

Directory where configuration are located.

Default value: $storj::config_dir

##### `manage_user`

Data type: `Boolean`

Whether to create user for storj or rely on external code for that.

Default value: $storj::manage_user

##### `manage_group`

Data type: `Boolean`

Whether to create user for storj or rely on external code for that.

Default value: $storj::manage_group

##### `user`

Data type: `String`

User running storj.

Default value: $storj::user

##### `group`

Data type: `String`

Group under which storj is running.

Default value: $storj::group

##### `user_shell`

Data type: `Stdlib::Absolutepath`

if requested, we create a user for storj. The default shell is false. It can be overwritten to any valid path.

Default value: $storj::user_shell

##### `extra_groups`

Data type: `Array[String]`

Add other groups to the managed user.

Default value: $storj::extra_groups

### storj::service

This class manages service

#### Examples

##### 

```puppet
include storj::service
```

#### Parameters

The following parameters are available in the `storj::service` class.

##### `ensure`

Data type: `Variant[Stdlib::Ensure::Service, Enum['absent']]`

State ensured from storagenode service.

Default value: $storj::service_ensure

##### `user`

Data type: `String`

User running storj.

Default value: $storj::user

##### `group`

Data type: `String`

Group under which storj is running.

Default value: $storj::group

##### `port`

Data type: `Stdlib::Port`

Storagenode port (required to be accessible). See https://documentation.storj.io/dependencies/port-forwarding

Default value: $storj::port

##### `dashboard_port`

Data type: `Stdlib::Port`

Dashboard port.

Default value: $storj::dashboard_port

##### `wallet`

Data type: `String`

Your wallet address. See https://support.storj.io/hc/en-us/articles/360026611692-How-do-I-hold-STORJ-What-is-a-valid-address-or-compatible-wallet-

Default value: $storj::wallet

##### `mail`

Data type: `String`

Your mail address.

Default value: $storj::mail

##### `host`

Data type: `Stdlib::Host`

Your node hostname / DNS altname (required to be accessible). See https://documentation.storj.io/dependencies/port-forwarding

Default value: $storj::host

##### `storage`

Data type: `String`

Amount of dedicated storage.

Default value: $storj::storage

##### `config_dir`

Data type: `Stdlib::Absolutepath`

Storj identity node directory. See https://documentation.storj.io/dependencies/identity

Default value: $storj::config_dir

##### `storage_path`

Data type: `Stdlib::Absolutepath`

Mounted device location.

Default value: $storj::storage_path

##### `docker_tag`

Data type: `String`

Docker inage tag of storj storagenode.
  Default to beta.

Default value: $storj::docker_tag

## Data types

### Storj::Authorization_token

Storj authorization token. See https://documentation.storj.io/before-you-begin/auth-token

Alias of `Pattern[/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}:[A-Za-z0-9]+/]`

