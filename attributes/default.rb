#Variables of environment
default[:jtalks][:path][:init_script] = "/etc/init.d"
default[:jtalks][:cookbook_path] = "#{Chef::Config[:cookbook_path][0]}/jtalks-infra/files/default"
default[:jtalks][:hostname] = "localhost"
default[:jtalks][:logs_instances_web] = ["qa","dev","preprod","beginintesting","performance","autotests"]
default[:jtalks][:smtp][:host] = "smpt.host"
default[:jtalks][:smtp][:port] = "587"
# sysctl
default[:sysctl][:params][:net][:core][:rmem_max] = 512000
# apt
default[:apt][:compile_time_update] = true
# backup
default[:jtalks][:backup][:ftp] = "u99356@u99356.your-backup.de"
default[:jtalks][:backup][:exclude_dirs] = "/home/aidjek /home/masyan /home/ctapobep /home/*/backup /home/*/.jtalks"
#to generate password use command 'openssl passwd -1' and enter password
default[:jtalks][:users][:root][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00"  # 1
default[:jtalks][:users][:git][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00"  # 1
default[:jtalks][:users][:masyan][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00"  # 1
default[:jtalks][:users][:qa][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00"  # 1
default[:jtalks][:users][:ctapobep][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:aidjek][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:jenkins][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:jenkins][:additional_groups] = ["docker"]
default[:jtalks][:users][:crowd][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:confluence][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:jira][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:i_javatalks][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:i_beginintesting][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:i_autotests][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:i_performance][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:i_preprod][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:i_dev][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:i_qa][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:site][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:pochta][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:selenium][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:sonar][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:nexus][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:fisheye][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:docker][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:docker][:system] = true
default[:jtalks][:users][:postfix][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:postfix][:uid] = 3000 # uid = gid
default[:jtalks][:users][:git][:known_hosts][:git] = ["localhost"]
default[:jtalks][:users][:jenkins][:known_hosts][:jenkins] = ["github.com"]
default[:jtalks][:users][:fisheye][:known_hosts][:fisheye] = ["github.com"]
default[:jtalks][:users][:jenkins][:known_hosts][:jtalks] = ["213.239.201.68"]
default[:jtalks][:users][:jenkins][:known_hosts][:antarcticle] = ["jtalks.org","#{node[:jtalks][:hostname]}"]
default[:jtalks][:users][:i_beginintesting][:known_hosts][:i_beginintesting] = ["jtalks.org","#{node[:jtalks][:hostname]}"]
default[:jtalks][:users][:i_autotests][:known_hosts][:i_autotests] = ["jtalks.org","#{node[:jtalks][:hostname]}"]
default[:jtalks][:users][:i_performance][:known_hosts][:i_performance] = ["jtalks.org","#{node[:jtalks][:hostname]}"]
default[:jtalks][:users][:pochta][:known_hosts][:pochta] = ["jtalks.org","#{node[:jtalks][:hostname]}"]
default[:jtalks][:users][:site][:known_hosts][:site] = ["jtalks.org","#{node[:jtalks][:hostname]}"]
default[:jtalks][:users][:i_preprod][:known_hosts][:u98642] = ["u98642.your-backup.de"]
default[:jtalks][:users][:i_javatalks][:known_hosts][:antarcticle] = ["jtalks.org","github.com"]
default[:jtalks][:users][:root][:known_hosts][:u99356] = ["u99356.your-backup.de"]

default[:jtalks][:dbs] = ["crowd","autotests","beginintesting","performance","preprod","preprod_antarcticle","dev_jcommune",
                          "dev_poulpe","dev_antarcticle","qa","qa_antarcticle","sonar","fisheye", "confluence","jira","postfix"]
default[:jtalks][:db_users][:crowd][:password] = "crowd"
default[:jtalks][:db_users][:crowd][:dbs][:crowd][:privileges] = [:all]
default[:jtalks][:db_users][:confluence][:password] = "confluence"
default[:jtalks][:db_users][:confluence][:dbs][:confluence][:privileges] = [:all]
default[:jtalks][:db_users][:jira][:password] = "jira"
default[:jtalks][:db_users][:jira][:dbs][:jira][:privileges] = [:all]
default[:jtalks][:db_users][:fisheye][:password] = "fisheye"
default[:jtalks][:db_users][:fisheye][:dbs][:fisheye][:privileges] = [:all]
default[:jtalks][:db_users][:autotests_admin][:password] = "autotests_admin"
default[:jtalks][:db_users][:autotests_admin][:dbs][:autotests][:privileges] = [:all]
default[:jtalks][:db_users][:autotests_reader][:password] = "autotests_reader"
default[:jtalks][:db_users][:autotests_reader][:dbs][:autotests][:privileges] = [:select]
default[:jtalks][:db_users][:bgntstng_admin][:password] = "bgntstng_admin"
default[:jtalks][:db_users][:bgntstng_admin][:dbs][:beginintesting][:privileges] = [:all]
default[:jtalks][:db_users][:bgntstng_reader][:password] = "bgntstng_reader"
default[:jtalks][:db_users][:bgntstng_reader][:dbs][:beginintesting][:privileges] = [:select]
default[:jtalks][:db_users][:perfrmnce_admin][:password] = "perfrmnce_admin"
default[:jtalks][:db_users][:perfrmnce_admin][:dbs][:performance][:privileges] = [:all]
default[:jtalks][:db_users][:perfrmnce_reader][:password] = "perfrmnce_reader"
default[:jtalks][:db_users][:perfrmnce_reader][:dbs][:performance][:privileges] = [:select]
default[:jtalks][:db_users][:preprod_admin][:password] = "preprod_admin"
default[:jtalks][:db_users][:preprod_admin][:dbs][:preprod][:privileges] = [:all]
default[:jtalks][:db_users][:preprod_admin][:dbs][:preprod_antarcticle][:privileges] = [:all]
default[:jtalks][:db_users][:preprod_reader][:password] = "preprod_reader"
default[:jtalks][:db_users][:preprod_reader][:dbs][:preprod][:privileges] = [:select]
default[:jtalks][:db_users][:preprod_reader][:dbs][:preprod_antarcticle][:privileges] = [:select]
default[:jtalks][:db_users][:dev_admin][:password] = "dev_admin"
default[:jtalks][:db_users][:dev_admin][:dbs][:dev_jcommune][:privileges] = [:all]
default[:jtalks][:db_users][:dev_admin][:dbs][:dev_poulpe][:privileges] = [:all]
default[:jtalks][:db_users][:dev_admin][:dbs][:dev_antarcticle][:privileges] = [:all]
default[:jtalks][:db_users][:dev_reader][:password] = "dev_reader"
default[:jtalks][:db_users][:dev_reader][:dbs][:dev_jcommune][:privileges] = [:select]
default[:jtalks][:db_users][:dev_reader][:dbs][:dev_poulpe][:privileges] = [:select]
default[:jtalks][:db_users][:dev_reader][:dbs][:dev_antarcticle][:privileges] = [:select]
default[:jtalks][:db_users][:qa_admin][:password] = "qa_admin"
default[:jtalks][:db_users][:qa_admin][:dbs][:qa][:privileges] = [:all]
default[:jtalks][:db_users][:qa_admin][:dbs][:qa_antarcticle][:privileges] = [:all]
default[:jtalks][:db_users][:qa_reader][:password] = "qa_reader"
default[:jtalks][:db_users][:qa_reader][:dbs][:qa][:privileges] = [:select]
default[:jtalks][:db_users][:qa_reader][:dbs][:qa_antarcticle][:privileges] = [:select]
default[:jtalks][:db_users][:sonar][:password] = "sonar"
default[:jtalks][:db_users][:sonar][:dbs][:sonar][:privileges] = [:all]
default[:jtalks][:db_users][:postfix][:password] = "postfix"
default[:jtalks][:db_users][:postfix][:dbs][:postfix][:privileges] = [:all]

# vagrant user to test only
default[:authorization][:sudo][:users] = ["masyan", "ctapobep", "aidjek", "jenkins", "vagrant", "docker"]
default[:authorization][:sudo][:passwordless] = "true"
default[:authorization][:sudo][:include_sudoers_d] = "true"

#Database
default[:mysql][:version] = "5.5"
default[:mysql][:client][:version] = "#{node[:mysql][:version]}"
default[:mysql][:server_root_password] = 'root'
default[:mysql][:server_debian_password] = nil
default[:mysql][:connector][:download_url] = "http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.33.zip"

#Java
default[:java][:install_flavor] = "oracle"
default[:java][:jdk_version] = 7
default[:java][:oracle][:accept_oracle_download_terms] = true
default[:java][:jdk]["7"]["x86_64"][:url] = "http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz"
default[:java][:jdk]["8"]["x86_64"][:url] = "http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.tar.gz"
default[:java][:jdk]["8"][:home]="/usr/lib/jvm/jdk1.8.0_51"

# Maven
default[:maven]['3'][:version] = "3.2.3"
default[:maven]['3'][:url] = "http://apache-mirror.rbc.ru/pub/apache/maven/maven-3/#{node[:maven]['3'][:version]}/binaries/apache-maven-#{node[:maven]['3'][:version]}-bin.tar.gz"

# Tomcat variables
default[:tomcat]['8'][:major_version] = "8"
default[:tomcat]['8'][:minor_version] = "0.14"
default[:tomcat]['8'][:version] = "#{node[:tomcat]['8'][:major_version]}.#{node[:tomcat]['8'][:minor_version]}"
default[:tomcat]['8'][:download_url] = "http://archive.apache.org/dist/tomcat/tomcat-#{node[:tomcat]['8'][:major_version]}/v#{node[:tomcat]['8'][:version]}/bin/apache-tomcat-#{node[:tomcat]['8'][:version]}.zip"
default[:tomcat]['7'][:major_version] = "7"
default[:tomcat]['7'][:minor_version] = "0.57"
default[:tomcat]['7'][:version] = "#{node[:tomcat]['7'][:major_version]}.#{node[:tomcat]['7'][:minor_version]}"
default[:tomcat]['7'][:download_url] = "http://archive.apache.org/dist/tomcat/tomcat-#{node[:tomcat]['7'][:major_version]}/v#{node[:tomcat]['7'][:version]}/bin/apache-tomcat-#{node[:tomcat]['7'][:version]}.zip"

# Crowd
default[:crowd][:user] = "crowd"
default[:crowd][:home_dir] = "/home/#{node[:crowd][:user]}/var"
default[:tomcat][:instances][:crowd][:port] = 8081
default[:tomcat][:instances][:crowd][:shutdown_port] = 8011
default[:tomcat][:instances][:crowd][:jvm_opts] = "-Xmx256m -XX:MaxPermSize=384m"
default[:crowd][:version] = "2.8.0"
default[:crowd][:download_external_libs] = "http://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-#{node[:crowd][:version]}.tar.gz"
default[:crowd][:download_url] = "http://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-#{node[:crowd][:version]}-war.zip"
default[:crowd][:app][:name] = "crowd"
default[:crowd][:app][:password] = "1"
default[:crowd][:app][:server_url] = "http\\://#{node[:jtalks][:hostname]}:#{node[:tomcat][:instances][:crowd][:port]}"
default[:crowd][:app][:cookie_domain] = "#{node[:jtalks][:hostname]}"
default[:crowd][:app][:token] = "fake"
default[:crowd][:app][:license_text] = "fake"
default[:crowd][:db][:name] = "crowd"
default[:crowd][:db][:user] = "crowd"
default[:crowd][:db][:password] = "#{node[:jtalks][:db_users][:crowd][:password]}"
default[:crowd][:db][:backup_path] = "#{node[:jtalks][:cookbook_path]}/crowd/crowd.sql"   # for test backup contains all users  from production with password "1"


# Confluence
default[:confluence][:user] = "confluence"
default[:confluence][:home_dir] = "/home/#{node[:confluence][:user]}/var"
default[:confluence][:port] = 8050
default[:confluence][:control_port] = 8051
default[:confluence][:jvm_opts] = "-Xmx1024m -XX:MaxPermSize=384m"
default[:confluence][:version] = "5.6.5"
# page with build numbers https://developer.atlassian.com/display/CONFDEV/Confluence+Build+Information
# it version need to check database version
default[:confluence][:build_number] = "5510"
default[:confluence][:source_url] = "http://downloads.atlassian.com/software/confluence/downloads/atlassian-confluence-#{node[:confluence][:version]}.tar.gz"
default[:confluence][:crowd][:application] = "confluence"
default[:confluence][:crowd][:password] = "1"
default[:confluence][:license_text] = "fake"
default[:confluence][:db][:name] = "confluence"
default[:confluence][:db][:user] = "confluence"
default[:confluence][:db][:password] = "#{node[:jtalks][:db_users][:confluence][:password]}"
default[:confluence][:db][:backup_path] = "#{node[:jtalks][:cookbook_path]}/confluence/confluence.sql"  # in dev version change password and url to crowd
default[:confluence][:url] = "http://localhost:#{node[:confluence][:port]}"

# Jira
default[:jira][:user] = "jira"
default[:jira][:home_dir] = "/home/#{node[:jira][:user]}/var"
default[:tomcat][:instances][:jira][:port] = 8045
default[:tomcat][:instances][:jira][:shutdown_port] = 8046
default[:tomcat][:instances][:jira][:jvm_opts] = "-Xmx1G -XX:MaxPermSize=384m"
default[:jira][:version] = "6.3.12"
default[:jira][:source_url] = "http://downloads.atlassian.com/software/jira/downloads/atlassian-jira-#{node[:jira][:version]}-war.tar.gz"
default[:jira][:source_external_libs_url] = "https://downloads.atlassian.com/software/jira/downloads/jira-jars-tomcat-distribution-6.4-m12-tomcat-7x.zip"
default[:jira][:crowd][:application] = "jira"
default[:jira][:crowd][:password] = "1"
default[:jira][:license_text] = "fake"
default[:jira][:db][:name] = "jira"
default[:jira][:db][:user] = "jira"
default[:jira][:db][:password] = "#{node[:jtalks][:db_users][:jira][:password]}"
default[:jira][:db][:backup_path] = "#{node[:jtalks][:cookbook_path]}/jira/jira.sql"  # in dev version change password,url to crowd and license (jira + plugins)

# Pochta
default[:pochta][:http][:port] = 9088
default[:pochta][:smtp][:port] = 9025
default[:pochta][:http][:threads_count] = 5
default[:pochta][:smtp][:threads_count] = 5
default[:pochta][:user] = "pochta"
default[:pochta][:version] = "1.4"
default[:pochta][:source_url] = "http://repo.jtalks.org/content/repositories/releases/org/jtalks/jtalks-pochta/#{node[:pochta][:version]}/jtalks-pochta-#{node[:pochta][:version]}.jar"

# Selenium
default[:selenium][:version] = "2.30.0"
default[:selenium][:source_url] = "http://selenium.googlecode.com/files/selenium-server-standalone-#{node[:selenium][:version]}.jar"
default[:selenium][:user] = "selenium"

#Jenkins
default[:jenkins][:user][:name] = "jenkins"
default[:jenkins][:version] = "1.596.3"
default[:jenkins][:download_url] = "http://mirrors.jenkins-ci.org/war-stable/#{node[:jenkins][:version]}/jenkins.war"
default[:jenkins][:plugins_download_url] = "http://updates.jenkins-ci.org/download/plugins"
default[:tomcat][:instances][:jenkins][:port] = 8080
default[:tomcat][:instances][:jenkins][:shutdown_port] = 8010
default[:tomcat][:instances][:jenkins][:jvm_opts] = "-Xmx256m -XX:MaxPermSize=384m"
default[:jenkins][:crowd][:application] = "jenkins"
default[:jenkins][:crowd][:password] = "1"
default[:jenkins][:crowd][:group] = "jira-users"
default[:jenkins][:config][:backup_path] = "#{node[:jtalks][:cookbook_path]}/jenkins"
default[:jenkins][:maven][:users][:deployment][:name] = "nexus-deployment"
default[:jenkins][:maven][:users][:deployment][:password] = "fake"
default[:jenkins][:maven][:users][:antarcticle][:name] = "jtalks"
default[:jenkins][:maven][:users][:antarcticle][:password] = "fake"

## plugins
default[:jenkins][:plugins]["ansicolor"] = "0.4.1"
default[:jenkins][:plugins]["ant"] = "1.2"
default[:jenkins][:plugins]["build-pipeline-plugin"] = "1.4.7"
default[:jenkins][:plugins]["build-name-setter"] = "1.3"
default[:jenkins][:plugins]["conditional-buildstep"] = "1.3.3"
default[:jenkins][:plugins]["copy-to-slave"] = "1.4.4"
default[:jenkins][:plugins]["config-file-provider"] = "2.8.1"
default[:jenkins][:plugins]["createjobadvanced"] = "1.8"
default[:jenkins][:plugins]["credentials"] = "1.22"
default[:jenkins][:plugins]["crowd2"] = "1.8"
default[:jenkins][:plugins]["cvs"] = "2.12"
default[:jenkins][:plugins]["dashboard-view"] = "2.9.5"
default[:jenkins][:plugins]["description-setter"] = "1.10"
default[:jenkins][:plugins]["email-ext"] = "2.40.5"
default[:jenkins][:plugins]["external-monitor-job"] = "1.4"
default[:jenkins][:plugins]["extra-columns"] = "1.15"
default[:jenkins][:plugins]["git-client"] = "1.17.1"
default[:jenkins][:plugins]["git"] = "2.3.5"
default[:jenkins][:plugins]["github-api"] = "1.68"
default[:jenkins][:plugins]["github"] = "1.11.3"
default[:jenkins][:plugins]["greenballs"] = "1.14"
default[:jenkins][:plugins]["htmlpublisher"] = "1.4"
default[:jenkins][:plugins]["extended-read-permission"] = "1.0"
default[:jenkins][:plugins]["groovy"] = "1.25"
default[:jenkins][:plugins]["javadoc"] = "1.3"
default[:jenkins][:plugins]["jira"] = "1.41"
default[:jenkins][:plugins]["jquery"] = "1.11.2-0"
default[:jenkins][:plugins]["junit"] = "1.6"
default[:jenkins][:plugins]["ldap"] = "1.11"
default[:jenkins][:plugins]["mailer"] = "1.15"
default[:jenkins][:plugins]["mapdb-api"] = "1.0.6.0"
default[:jenkins][:plugins]["mask-passwords"] = "2.7.3"
default[:jenkins][:plugins]["matrix-auth"] = "1.2"
default[:jenkins][:plugins]["matrix-project"] = "1.6"
default[:jenkins][:plugins]["maven-plugin"] = "2.10"
default[:jenkins][:plugins]["nested-view"] = "1.14"
default[:jenkins][:plugins]["antisamy-markup-formatter"] = "1.3"
default[:jenkins][:plugins]["pam-auth"] = "1.2"
default[:jenkins][:plugins]["parameterized-trigger"] = "2.27"
default[:jenkins][:plugins]["performance"] = "1.13"
default[:jenkins][:plugins]["rebuild"] = "1.25"
default[:jenkins][:plugins]["remote-terminal-access"] = "1.6"
default[:jenkins][:plugins]["run-condition"] = "1.0"
default[:jenkins][:plugins]["sauce-ondemand"] = "1.129"
default[:jenkins][:plugins]["scm-api"] = "0.2"
default[:jenkins][:plugins]["sectioned-view"] = "1.19"
default[:jenkins][:plugins]["script-realm"] = "1.5"
default[:jenkins][:plugins]["script-security"] = "1.14"
default[:jenkins][:plugins]["show-build-parameters"] = "1.0"
default[:jenkins][:plugins]["sonar"] = "2.2.1"
default[:jenkins][:plugins]["ssh-agent"] = "1.7"
default[:jenkins][:plugins]["ssh-credentials"] = "1.11"
default[:jenkins][:plugins]["ssh-slaves"] = "1.9"
default[:jenkins][:plugins]["subversion"] = "2.5.1"
default[:jenkins][:plugins]["throttle-concurrents"] = "1.8.4"
default[:jenkins][:plugins]["token-macro"] = "1.10"
default[:jenkins][:plugins]["translation"] = "1.12"
default[:jenkins][:plugins]["windows-slaves"] = "1.1"
default[:jenkins][:plugins]["ws-cleanup"] = "0.26"

# NewRelic
# license key neen to sysmond
default["newrelic-sysmond"][:package_action] = "upgrade"
default["newrelic-sysmond"][:license_key] = "fake"

# Sonar
default[:sonar][:user] = "sonar"
default[:sonar][:version] = "5.0.1"
default[:sonar][:source_url] = "http://dist.sonar.codehaus.org/sonarqube-#{node[:sonar][:version]}.zip"
default[:sonar][:port] = 9000
default[:sonar][:jvm_opts] = "-Xmx768m -XX:MaxPermSize=384m"
default[:sonar][:db][:name] = "sonar"
default[:sonar][:db][:user] = "sonar"
default[:sonar][:db][:password] = "#{node[:jtalks][:db_users][:sonar][:password]}"
default[:sonar][:db][:backup_path] = "#{node[:jtalks][:cookbook_path]}/sonar/sonar.sql" # for test backup user "admin" with password "1111"
default[:sonar][:crowd][:application] = "sonar"
default[:sonar][:crowd][:password] = "1"
default[:sonar][:repo] = "http://repository.codehaus.org/org/codehaus/sonar-plugins"
default[:sonar][:plugins][:java][:version] = "3.2"
default[:sonar][:plugins][:java][:url] = "#{node[:sonar][:repo]}/java/sonar-java-plugin/#{node[:sonar][:plugins][:java][:version]}/sonar-java-plugin-#{node[:sonar][:plugins][:java][:version]}.jar"
default[:sonar][:plugins][:squid][:version] = "3.0"
default[:sonar][:plugins][:squid][:url] = "#{node[:sonar][:repo]}/java/java-squid/#{node[:sonar][:plugins][:squid][:version]}/java-squid-#{node[:sonar][:plugins][:squid][:version]}.jar"
default[:sonar][:plugins][:checkstyle][:version] = "2.3"
default[:sonar][:plugins][:checkstyle][:url] = "#{node[:sonar][:repo]}/java/sonar-checkstyle-plugin/#{node[:sonar][:plugins][:checkstyle][:version]}/sonar-checkstyle-plugin-#{node[:sonar][:plugins][:checkstyle][:version]}.jar"
default[:sonar][:plugins][:findbugs][:version] = "3.2"
default[:sonar][:plugins][:findbugs][:url] = "#{node[:sonar][:repo]}/java/sonar-findbugs-plugin/#{node[:sonar][:plugins][:findbugs][:version]}/sonar-findbugs-plugin-#{node[:sonar][:plugins][:findbugs][:version]}.jar"
default[:sonar][:plugins][:pmd][:version] = "2.4"
default[:sonar][:plugins][:pmd][:url] = "#{node[:sonar][:repo]}/java/sonar-pmd-plugin/#{node[:sonar][:plugins][:pmd][:version]}/sonar-pmd-plugin-#{node[:sonar][:plugins][:pmd][:version]}.jar"
default[:sonar][:plugins][:surefire][:version] = "3.0"
default[:sonar][:plugins][:surefire][:url] = "#{node[:sonar][:repo]}/java/java-surefire/#{node[:sonar][:plugins][:surefire][:version]}/java-surefire-#{node[:sonar][:plugins][:surefire][:version]}.jar"
default[:sonar][:plugins][:crowd][:version] = "2.0"
default[:sonar][:plugins][:crowd][:url] = "#{node[:sonar][:repo]}/sonar-crowd-plugin/#{node[:sonar][:plugins][:crowd][:version]}/sonar-crowd-plugin-#{node[:sonar][:plugins][:crowd][:version]}.jar"
default[:sonar][:plugins][:cobertura][:version] = "1.6.3"
default[:sonar][:plugins][:cobertura][:url] = "#{node[:sonar][:repo]}/sonar-cobertura-plugin/#{node[:sonar][:plugins][:cobertura][:version]}/sonar-cobertura-plugin-#{node[:sonar][:plugins][:cobertura][:version]}.jar"
default[:sonar][:plugins][:issues_density][:version] = "1.0"
default[:sonar][:plugins][:issues_density][:url] = "#{node[:sonar][:repo]}/sonar-issues-density-plugin/#{node[:sonar][:plugins][:issues_density][:version]}/sonar-issues-density-plugin-#{node[:sonar][:plugins][:issues_density][:version]}.jar"

# Nexus
default[:nexus][:user] = "nexus"
default[:nexus][:port] = 8082
# version > 2.11.2-06
default[:nexus][:version] = "2.11.2-06"
default[:nexus][:source_url] = "https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-#{node[:nexus][:version]}-bundle.tar.gz"
default[:nexus][:admin_password] = "$shiro1$SHA-512$1024$HFmQ+Qwygzm0Yy1jJjKTUw==$6Wim7rxO++llnf6DG5b5JtdYQSH9FzgWv4FJKu/pJCiPsZADP3al9fBmLaBYvLyySURYcqGSVk66J8ts22Rb8g==" # for test backup user "admin" with password "1"
default[:nexus][:crowd][:application] = "nexus"
default[:nexus][:crowd][:password] = "1"
default[:nexus][:crowd][:group] = "nexus"
default[:nexus][:crowd][:plugin][:version] = "2.9.0"
default[:nexus][:crowd][:plugin][:source_url] = "http://github.com/PatrickRoumanoff/nexus-crowd-plugin/wiki/nexus-crowd-plugin-#{node[:nexus][:crowd][:plugin][:version]}-bundle.zip"

# Fisheye
default[:fisheye][:user] = "fisheye"
default[:fisheye][:home_dir] = "/home/#{node[:fisheye][:user]}/var"
default[:fisheye][:port] = 8085
default[:fisheye][:control_port] = 8059
default[:fisheye][:version] = "3.6.1"
default[:fisheye][:source_url] = "http://www.atlassian.com/software/crucible/downloads/binary/crucible-#{node[:fisheye][:version]}.zip"
default[:fisheye][:crowd][:application] = "fisheye"
default[:fisheye][:crowd][:password] = "1"
default[:fisheye][:crowd][:groups] = ["jira-users", "fisheye"]
default[:fisheye][:crowd][:admin_group] = "fisheye"
default[:fisheye][:db][:name] = "fisheye"
default[:fisheye][:db][:user] = "fisheye"
default[:fisheye][:db][:password] = "#{node[:jtalks][:db_users][:fisheye][:password]}"
default[:fisheye][:db][:backup_path] = "#{node[:jtalks][:cookbook_path]}/fisheye/fisheye.sql"
default[:fisheye][:license_text] = "fake"
default[:fisheye][:crucible_license_text] = "fake"
default[:fisheye][:git_bin_path] = "/usr/bin/git"
default[:jtalks][:smtp][:users][:fisheye][:name] = "fake"
default[:jtalks][:smtp][:users][:fisheye][:password] = "fake"
default[:fisheye][:repositories][:antarctice][:location] = "git@github.com:jtalks-org/antarcticle-scala.git"
default[:fisheye][:repositories][:antarctice][:key_name] = "id_rsa"
default[:fisheye][:repositories][:functional_tests][:location] = "git@github.com:jtalks-org/functional-tests.git"
default[:fisheye][:repositories][:functional_tests][:key_name] = "id_rsa"
default[:fisheye][:repositories][:jcommune][:location] = "git@github.com:jtalks-org/jcommune.git"
default[:fisheye][:repositories][:jcommune][:key_name] = "id_rsa"
default[:fisheye][:repositories][:jtalks_common][:location] = "git@github.com:jtalks-org/jtalks-common.git"
default[:fisheye][:repositories][:jtalks_common][:key_name] = "id_rsa"
default[:fisheye][:repositories][:poulpe][:location] = "git@github.com:jtalks-org/poulpe.git"
default[:fisheye][:repositories][:poulpe][:key_name] = "id_rsa"
default[:fisheye][:url] = "http://fisheye.jtalks.org"

# Mail
default[:jtalks][:postfix][:user] = "postfix"
default[:jtalks][:postfix][:domain] = "mail.jtalks.org"
default[:jtalks][:postfix][:database][:host] = "127.0.0.1"
default[:jtalks][:postfix][:database][:name] = "postfix"
default[:jtalks][:postfix][:database][:user] = "postfix"
default[:jtalks][:postfix][:database][:password] = "#{node[:jtalks][:db_users][:postfix][:password]}"
default[:jtalks][:postfix][:admin][:username] = "admin"
default[:jtalks][:postfix][:admins][:admin][:password] = "pas11"
default[:jtalks][:postfix][:admins][:admin][:domain] = "jtalks.org"
default[:jtalks][:postfix][:domains][:jtalks_org][:name] = "jtalks.org"
default[:jtalks][:postfix][:domains][:jtalks_org][:description] = "Description jtalks.org"
default[:jtalks][:postfix][:mailboxes][:info][:domain] = "jtalks.org"
default[:jtalks][:postfix][:mailboxes][:info][:password] = "pas11"
default[:jtalks][:postfix][:mailboxes][:info][:aliases] = ["test@ya.ru", "test2@ya.ru"]
default[:jtalks][:postfixadmin][:host] = "localhost"
default[:jtalks][:postfixadmin][:port] = 8000
default[:jtalks][:postfixadmin][:setup_password] = "pas11"
default[:jtalks][:postfixadmin][:setup_password_encoded] = "252baecffd29d699a58e159af148fb45:fd60f0cc48a587d233b06d92cd12cd21fc7ceb7c"
default[:jtalks][:postfixadmin][:version] = "2.92"
default[:jtalks][:postfixadmin][:source_url] = "http://sourceforge.net/projects/postfixadmin/files/postfixadmin/postfixadmin-#{node[:jtalks][:postfixadmin][:version]}/postfixadmin-#{node[:jtalks][:postfixadmin][:version]}.tar.gz"
default[:jtalks][:postfixadmin][:conf][:encrypt] = "'md5crypt'"
default[:jtalks][:postfixadmin][:conf][:domain_path] = "'YES'"
default[:jtalks][:postfixadmin][:conf][:domain_in_mailbox] = "'NO'"
default[:jtalks][:postfixadmin][:conf][:fetchmail] = "'NO'"
default[:jtalks][:postfixadmin][:conf][:configured] = true
default[:jtalks][:postfixadmin][:conf][:setup_password] = "'#{node[:jtalks][:postfixadmin][:setup_password_encoded]}'"
default[:jtalks][:postfixadmin][:conf][:postfix_admin_url] = "''"
default[:jtalks][:postfixadmin][:conf][:alias_control] = "'YES'"
default[:jtalks][:postfixadmin][:conf][:default_aliases] = "array ()"
default[:jtalks][:postfixadmin][:conf][:database_type] = "'mysqli'"
default[:jtalks][:postfixadmin][:conf][:database_host] = "'#{node[:jtalks][:postfix][:database][:host]}'"
default[:jtalks][:postfixadmin][:conf][:database_user] = "'#{node[:jtalks][:postfix][:database][:user]}'"
default[:jtalks][:postfixadmin][:conf][:database_password] = "'#{node[:jtalks][:postfix][:database][:password]}'"
default[:jtalks][:postfixadmin][:conf][:database_name] = "'#{node[:jtalks][:postfix][:database][:name]}'"

# Git
default[:git][:user] = "git"
default[:git][:server][:base_path] = "/home/#{node[:git][:user]}"
default[:gitolite][:repository_url] = "git://github.com/sitaramc/gitolite.git"

# Nginx
default[:jtalks][:nginx][:custom_configs] = ["site", "dev", "qa", "preprod","selenium","logs","postfixadmin", "qala"]
default[:nginx][:user] = "root"
default[:nginx][:site][:confluence][:name] = "confluence"
default[:nginx][:site][:confluence][:host] = "wiki.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:confluence][:context_path] = "/"
default[:nginx][:site][:jira][:name] = "jira"
default[:nginx][:site][:jira][:host] = "jira.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:jira][:context_path] = "/"
default[:nginx][:site][:fisheye][:port]= node[:fisheye][:port]
default[:nginx][:site][:fisheye][:name] = "fisheye"
default[:nginx][:site][:fisheye][:host] = "fisheye.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:fisheye][:context_path] = "/"
default[:nginx][:site][:nexus][:name] = "nexus"
default[:nginx][:site][:nexus][:host] = "repo.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:nexus][:context_path] = "/"
default[:nginx][:site][:pochta][:port] = node[:pochta][:http][:port]
default[:nginx][:site][:pochta][:name] = "pochta"
default[:nginx][:site][:pochta][:host] = "pochta.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:pochta][:context_path] = "/"
default[:nginx][:site][:sonar][:port] = node[:sonar][:port]
default[:nginx][:site][:sonar][:name] = "sonar"
default[:nginx][:site][:sonar][:host] = "sonar.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:sonar][:context_path] = "/"
default[:nginx][:site][:jenkins][:name] = "jenkins"
default[:nginx][:site][:jenkins][:host] = "ci.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:jenkins][:context_path] = "/"
default[:nginx][:site][:crowd][:name] = "crowd"
default[:nginx][:site][:crowd][:host] = "crowd.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:crowd][:context_path] = "/"
default[:nginx][:site][:performance][:port] =4090
default[:nginx][:site][:performance][:name] = "performance"
default[:nginx][:site][:performance][:host] = "performance.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:performance][:context_path] = "/"
default[:nginx][:site][:beginintesting][:port] =4085
default[:nginx][:site][:beginintesting][:name] = "beginintesting"
default[:nginx][:site][:beginintesting][:host] = "beginintesting.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:beginintesting][:context_path] = "/"
default[:nginx][:site][:autotests][:port] =4080
default[:nginx][:site][:autotests][:name] = "autotests"
default[:nginx][:site][:autotests][:host] = "autotests.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:autotests][:context_path] = "/"

# Docker
default[:docker][:group_members] = ["docker"]
default[:docker][:install_type] = "binary"
default[:docker][:binary][:version] = "1.5.0"
default[:docker][:binary][:url] = "http://get.docker.io/builds/#{node[:kernel][:name]}/#{node[:docker][:arch]}/docker-#{node[:docker][:binary][:version]}"
default[:docker][:binary][:checksum] =
    case node[:docker][:binary][:version]
      when '0.10.0' then
        'ce1f5bc88a99f8b2331614ede7199f872bd20e4ac1806de7332cbac8e441d1a0'
      when '0.11.0' then
        'f80ba82acc0a6255960d3ff6fe145a8fdd0c07f136543fcd4676bb304daaf598'
      when '0.11.1' then
        'ed2f2437fd6b9af69484db152d65c0b025aa55aae6e0991de92d9efa2511a7a3'
      when '0.12.0' then
        '0f611f7031642a60716e132a6c39ec52479e927dfbda550973e1574640135313'
      when '1.0.0' then
        '55cf74ea4c65fe36e9b47ca112218459cc905ede687ebfde21b2ba91c707db94'
      when '1.0.1' then
        '1d9aea20ec8e640ec9feb6757819ce01ca4d007f208979e3156ed687b809a75b'
      when '1.4.1' then
        'b4fb75be087eafe6cda26038a045854ab2d497adad9276a45c37d7d55da764fc'
      when '1.5.0' then
        '5729164f6ed53c47b5c18e0c0a64fe03b8548e3fd16028fa961ea5ae5e5946c6'
    end
default[:docker][:install_dir] = "/bin"
default[:docker][:graph] = "/home/docker/var"
default[:docker][:group] = "docker"
default[:docker][:dns] = ["8.8.8.8", "8.8.4.4"]

#Hubot
default[:jtalks][:hubot][:token] = "fake"

# iptables
default[:iptables][:install_rules] = false
default[:iptables][:rules] =[
    "iptables -I INPUT 1 -p tcp -m state --state NEW -m multiport --dports ssh,smtp,http,https -j ACCEPT"
]
