Chef Cookbook of JTalks's infrastructure
----

## Develop

- Clone repository
- `cd jtalks-infra`
- Install ruby   `apt-get install build-essential autoconf ruby ruby-bundler`
- Install depends `bundle install`

## Testing

- add content from private repository (jtalks-infra-files) to files/.
- replace dummy backups of databases
- Run `kitchen converge` to startup a VM with the cookbooks and kitchen verify to run the integration tests.


## Usage on server

- install Chef  `apt-get install build-essential autoconf ruby ruby-bundler chef`
- create solo.rb (config file)
	    `log_level          :info
     	log_location	   STDOUT
     	file_cache_path    "/var/chef/cache"
        file_backup_path   "/var/chef/backup"
     	cookbook_path      "/var/chef/cookbooks"
     	checksum_path      "/var/chef/checksums"
     	sandbox_path	   "var/chef/tmp"`
- actualize directory of project <files> (from private git repository and from previosly server)
- copy all files of project to target server
- install dependencies (gems: Berkshelf, etc) `cd <directory of project files>; bundle install`
- install cookbook (from directory of project files) `rm -Rf /var/chef/cookbooks; berks vendor /var/chef/cookbooks`
- check attributes and recipes in server.json
- run chef   `chef-solo -j /var/chef/cookbooks/jtalks-infra/files/default/attributes/server.json`
- additional actions
  * check pernissions to git, github
  * if sonar have new version, need upgrade DB => <host>:<port>/setup
  * check Application Links to applications (Atlassian)
  * check plugins to applications (Atlassian)
  * copy jira-home/plugins/installed-plugins to new server
  * open Jira on web browser. And do reindex (System - Advanced - Indexing)
  * move git repositories
