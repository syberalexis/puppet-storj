# maeq-storj

[![Build Status Travis](https://img.shields.io/travis/com/syberalexis/puppet-storj/master?label=build%20travis)](https://travis-ci.com/syberalexis/puppet-storj)
[![Build Status AppVeyor](https://img.shields.io/appveyor/ci/syberalexis/puppet-storj/master?label=build%20appveyor)](https://ci.appveyor.com/project/syberalexis/puppet-storj)
[![Puppet Forge](https://img.shields.io/puppetforge/v/maeq/storj.svg)](https://forge.puppetlabs.com/maeq/storj)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/maeq/storj.svg)](https://forge.puppetlabs.com/maeq/storj)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/maeq/storj.svg)](https://forge.puppetlabs.com/maeq/storj)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/maeq/storj.svg)](https://forge.puppetlabs.com/maeq/storj)
[![Apache-2 License](https://img.shields.io/github/license/syberalexis/puppet-storj.svg)](LICENSE)


#### Table of Contents

- [Description](#description)
- [Usage](#usage)
- [Examples](#examples)
- [Limitations](#limitations)
- [Development](#development)

## Description

This module automates the install of [Storj](https://storj.io/) and it's components into a service.  

## Usage

For more information see [REFERENCE.md](REFERENCE.md).

### Install Storj

#### Puppet
```puppet
class { 'storj':
  
}
```

#### Hiera Data
```puppet
include storj
```
```yaml

```

## Limitations



## Development

This project contains tests for [rspec-puppet](http://rspec-puppet.com/).

Quickstart to run all linter and unit tests:
```bash
bundle install --path .vendor/
bundle exec rake test
```
