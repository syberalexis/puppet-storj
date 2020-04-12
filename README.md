# maeq-storj

[![Build Status Travis](https://img.shields.io/travis/com/syberalexis/puppet-storj/master?label=build%20travis)](https://travis-ci.com/syberalexis/puppet-storj)
[![Puppet Forge](https://img.shields.io/puppetforge/v/maeq/storj.svg)](https://forge.puppetlabs.com/maeq/storj)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/maeq/storj.svg)](https://forge.puppetlabs.com/maeq/storj)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/maeq/storj.svg)](https://forge.puppetlabs.com/maeq/storj)
[![Apache-2 License](https://img.shields.io/github/license/syberalexis/puppet-storj.svg)](LICENSE)


#### Table of Contents

- [Description](#description)
- [Usage](#usage)
- [Examples](#examples)
- [Limitations](#limitations)
- [Development](#development)

## Description

This module automates the install of [Storj](https://storj.io/) and it's components.  

## Usage

For more information see [REFERENCE.md](REFERENCE.md).

### Before running

#### Request your authorization token

Before all things, you need to request your authorization token to each node [HERE](https://storj.io/sign-up-node-operator/).

#### Create identity key
You need to create a identity key. This operation take many time and this module don't manage it.  
Refer to the documentation https://documentation.storj.io/dependencies/identity#create-an-identity

### Install Storj

#### Puppet
```puppet
class { 'storj':
    authorization_token => '[YOUR AUTHORIZATION TOKEN]',
    wallet              => '[YOUR WALLET ADDRESS]',
    mail                => '[YOUR EMAIL]',
    host                => '[THE NODE HOSTNAME OR ALTNAME]',
    storage             => '[THE DEDICATED ANOUT OF STORAGE]',
    storage_path        => '[THE DEDICATED STORAGE LOCATION]',
}
```

#### Hiera Data
```puppet
include storj
```
```yaml
storj::authorization_token: '[YOUR AUTHORIZATION TOKEN]' 
storj::wallet: '[YOUR WALLET ADDRESS]'
storj::mail: '[YOUR EMAIL]'
storj::host: '[THE NODE HOSTNAME OR ALTNAME]'
storj::storage: '[THE DEDICATED ANOUT OF STORAGE]'
storj::storage_path: '[THE DEDICATED STORAGE LOCATION]'
```

## Examples

#### Default installation

```yaml
storj::authorization_token: 'test.test@test.test:T3sT' 
storj::wallet: '0x00000000000000000000'
storj::mail: 'test.test@test.test'
storj::host: 'my_storj_storagenode'
storj::storage: '1TB'
storj::storage_path: '/dev/sdb1'
```

#### Personal docker installation

```yaml
storj::authorization_token: 'test.test@test.test:T3sT' 
storj::wallet: '0x00000000000000000000'
storj::mail: 'test.test@test.test'
storj::host: 'my_storj_storagenode'
storj::storage: '1TB'
storj::storage_path: '/dev/sdb1'
storj::manage_docker: false
```

## Limitations

This module don't create the identity key. Please see [documentation](https://documentation.storj.io/dependencies/identity#create-an-identity)

## Development

This project contains tests for [rspec-puppet](http://rspec-puppet.com/).

Quickstart to run all linter and unit tests:
```bash
bundle install --path .vendor/
bundle exec rake test
```
