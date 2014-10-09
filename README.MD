Chef Cookbook of JTalks's infrastructure
----

## Installation

- Clone repository
- `cd jtalks-infra`
- Install ruby   `apt-get install build-essential autoconf ruby ruby-bundler`
- Install depends `bundle install`

## Using

- add content of directory private to /files/default/private directory from private
  repository (jtalks-infra-files).
- Run `kitchen converge` to startup a VM with the cookbooks and kitchen verify to run the integration tests.