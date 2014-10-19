Chef Cookbook of JTalks's infrastructure
----

## Installation

- Clone repository
- `cd jtalks-infra`
- Install ruby   `apt-get install build-essential autoconf ruby ruby-bundler`
- Install depends `bundle install`

## Using

- add content from private repository (jtalks-infra-files) to files/.
- replace dummy backups of databases
- Run `kitchen converge` to startup a VM with the cookbooks and kitchen verify to run the integration tests.