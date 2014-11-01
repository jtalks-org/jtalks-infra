Chef Cookbook of JTalks's infrastructure
----

## Develop

- Clone repository
- `cd jtalks-infra`
- Install ruby   `apt-get install build-essential autoconf ruby ruby-bundler`
- Install depends `bundle install`

## testing

- add content from private repository (jtalks-infra-files) to files/.
- replace dummy backups of databases
- Run `kitchen converge` to startup a VM with the cookbooks and kitchen verify to run the integration tests.


## Using on server

- Install Chef  `apt-get install build-essential autoconf ruby ruby-bundler chef`
- create solo.rb (config file)
	`log_level          :info
	log_location       STDOUT
	file_cache_path    "/var/chef/cookbooks"
	cookbook_path      "/var/chef/cookbooks"`
- actualize directory of project <files> (from private git repository and from previosly server)
- copy all files of project to target server
- install dependencies (gems: Berkshelf, etc) `cd <directory of project files>; bundle install`
- install cookbook (from directory of project files) `berks vendor /var/chef/cookbooks`
- check attributes and recipes in server.json
- run chef   `chef-solo -j attributes/server.json`