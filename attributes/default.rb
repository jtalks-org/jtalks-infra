#Variables of environment
default[:jtalks][:path][:init_script] = "/etc/init.d"
default[:jtalks][:cookbook_path] = "#{Chef::Config[:cookbook_path][0]}/jtalks-infra/files/default"
default[:jtalks][:hostname] = "localhost"
# to generate password use command 'openssl passwd -1' and enter password
default[:jtalks][:users][:masyan][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00"  # 1
default[:jtalks][:users][:qa][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00"  # 1
default[:jtalks][:users][:ctapobep][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
default[:jtalks][:users][:aidjek][:password] = "$1$TJ90WtPC$fKIvRHNzA2ZLWofaFF9w00" # 1
# vagrant user to test only
default[:authorization][:sudo][:users] = ["masyan", "ctapobep", "aidjek", "vagrant"]
default[:authorization][:sudo][:passwordless] = "true"
default[:authorization][:sudo][:include_sudoers_d] = "true"

#Database
default[:mysql][:version] = '5.5'
default[:mysql][:client][:version] = "#{node[:mysql][:version]}"
default[:mysql][:server_root_password] = 'root'
default[:mysql][:server_debian_password] = nil
default[:mysql][:connector][:download_url] = "http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.33.zip"

#Java
default[:java][:install_flavor] = "oracle"
default[:java][:jdk_version] = 7
default[:java][:oracle][:accept_oracle_download_terms] = true

# Maven
default[:maven]['3'][:version] = "3.2.3"
default[:maven]['3'][:url] = "http://apache-mirror.rbc.ru/pub/apache/maven/maven-3/#{node[:maven]['3'][:version]}/binaries/apache-maven-#{node[:maven]['3'][:version]}-bin.tar.gz"


#Tomcat variables
default[:tomcat][:major_version] = "8"
default[:tomcat][:minor_version] = "0.14"
default[:tomcat][:version] = "#{node[:tomcat][:major_version]}.#{node[:tomcat][:minor_version]}"
default[:tomcat][:download_url] = "http://archive.apache.org/dist/tomcat/tomcat-#{node[:tomcat][:major_version]}/v#{node[:tomcat][:version]}/bin/apache-tomcat-#{node[:tomcat][:version]}.zip"

#Atlassian
default[:atlassian][:user][:name] = "atlassian"
default[:atlassian][:user][:home_dir] = "/home/#{node[:atlassian][:user][:name]}/var"
##crowd
default[:tomcat][:instances][:crowd][:port] = 8081
default[:tomcat][:instances][:crowd][:shutdown_port] = 8011
default[:tomcat][:instances][:crowd][:jvm_opts] = "-Xmx256m -XX:MaxPermSize=384m"
default[:crowd][:version] = "2.3.1"
default[:crowd][:download_external_libs] = "http://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-#{node[:crowd][:version]}.tar.gz"
default[:crowd][:download_url] = "http://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-#{node[:crowd][:version]}-war.zip"
default[:crowd][:app][:name] = "crowd"
default[:crowd][:app][:password] = "crowd"
default[:crowd][:app][:server_url] = "http\://#{node[:jtalks][:hostname]}:#{node[:tomcat][:instances][:crowd][:port]}"
default[:crowd][:app][:cookie_domain] = "#{node[:jtalks][:hostname]}"
default[:crowd][:app][:license_text] = "AAABLA0ODAoPeNpNkF1rwjAUhu/zKwq7jtTabkwITNsOBduI1V2MwTirRxetaclHp/9+qVbwIhdJn vfNk/OU1dLLQHlB6AX+OBqOg8CLk7XbDEOSoC6VaIyoJYtV/bf9Gnu8QekVtVUlkrI7G0BpRIvMK IskVggdnoBB1nVQf0SDiMS1NI7L4YRsUuEZL97UgfbYdyxEiVLj+tLgleHLNP8u+GYVp/dsmoGo2 B61RvV2gBYMVEc9UJakLVT2+izbQaWROFIalCBLTM+NUJe7TkT9sNPhag9S6FvmcCuq1Z4Uac7co oH/Onp+iUiBqkU1T9j0YxLS5WT2STdZwSlfvc9689yeflDx3cZpaUaHpP+KCy3myWNZf/FgZGUlT sLglizdPH9B48PcrqL/EVqJKDAtAhUAgQN0plC1AkpMZKHuEOrtquLbeVkCFGJPdhggtLlKzIT+r W95YMQfYec1X02f3"
default[:db][:crowd][:user] = "crowd"
default[:db][:crowd][:name] = "#{node[:db][:crowd][:user]}"
default[:db][:crowd][:password] = "crowd"
default[:db][:crowd][:backup_path] = "#{node[:jtalks][:cookbook_path]}/crowd/crowd.sql"   # for test backup contains all users  from production with password "1"
default[:nginx][:site][:crowd][:name] = "crowd"
default[:nginx][:site][:crowd][:host] = "crowd.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:crowd][:context_path] = "/"

#Jenkins
default[:jenkins][:user][:name] = "jenkins"
default[:jenkins][:user][:known_hosts][:jenkins] = ["github.com"]
default[:jenkins][:user][:known_hosts][:jtalks] = ["213.239.201.68"]
default[:jenkins][:user][:known_hosts][:tomcat] = ["5.9.40.180","176.9.66.108"]
default[:jenkins][:version] = "1.532.3"
default[:jenkins][:download_url] = "http://mirrors.jenkins-ci.org/war-stable/#{node[:jenkins][:version]}/jenkins.war"
default[:jenkins][:plugins_download_url] = "http://updates.jenkins-ci.org/download/plugins"
default[:tomcat][:instances][:jenkins][:port] = 8080
default[:tomcat][:instances][:jenkins][:shutdown_port] = 8010
default[:tomcat][:instances][:jenkins][:jvm_opts] = "-Xmx256m -XX:MaxPermSize=384m"
default[:jenkins][:crowd][:application] = "jenkins"
default[:jenkins][:crowd][:password] = "jenkins"
default[:jenkins][:crowd][:group] = "jira-users"
default[:jenkins][:config][:backup_path] = "#{node[:jtalks][:cookbook_path]}/jenkins"
default[:jenkins][:maven][:backup_path] = "#{node[:jtalks][:cookbook_path]}/jenkins/maven/settings.xml"
default[:nginx][:site][:jenkins][:name] = "#{node[:jenkins][:user][:name]}"
default[:nginx][:site][:jenkins][:host] = "ci.#{node[:jtalks][:hostname]}"
default[:nginx][:site][:jenkins][:context_path] = "/"

## plugins
default[:jenkins][:plugins]["ansicolor"] = "0.3.1"
default[:jenkins][:plugins]["ant"] = "1.2"
default[:jenkins][:plugins]["build-pipeline-plugin"] = "1.3.3"
default[:jenkins][:plugins]["build-name-setter"] = "1.3"
default[:jenkins][:plugins]["copy-to-slave"] = "1.4.3"
default[:jenkins][:plugins]["createjobadvanced"] = "1.8"
default[:jenkins][:plugins]["credentials"] = "1.10"
default[:jenkins][:plugins]["crowd2"] = "1.8"
default[:jenkins][:plugins]["cvs"] = "2.8"
default[:jenkins][:plugins]["description-setter"] = "1.8"
default[:jenkins][:plugins]["email-ext"] = "2.29"
default[:jenkins][:plugins]["extra-columns"] = "1.8"
default[:jenkins][:plugins]["git-client"] = "1.7.0"
default[:jenkins][:plugins]["git"] = "2.1.0"
default[:jenkins][:plugins]["github-api"] = "1.40"
default[:jenkins][:plugins]["github"] = "1.6"
default[:jenkins][:plugins]["greenballs"] = "1.13"
default[:jenkins][:plugins]["groovy"] = "1.14"
default[:jenkins][:plugins]["htmlpublisher"] = "1.3"
default[:jenkins][:plugins]["extended-read-permission"] = "1.0"
default[:jenkins][:plugins]["javadoc"] = "1.1"
default[:jenkins][:plugins]["jira"] = "1.39"
default[:jenkins][:plugins]["jquery"] = "1.7.2-1"
default[:jenkins][:plugins]["mailer"] = "1.11"
default[:jenkins][:plugins]["sonar"] = "2.1"
default[:jenkins][:plugins]["ldap"] = "1.11"
default[:jenkins][:plugins]["mask-passwords"] = "2.7.2"
default[:jenkins][:plugins]["maven-plugin"] = "1.514"
default[:jenkins][:plugins]["external-monitor-job"] = "1.1"
default[:jenkins][:plugins]["nested-view"] = "1.11"
default[:jenkins][:plugins]["pam-auth"] = "1.0"
default[:jenkins][:plugins]["parameterized-trigger"] = "2.17"
default[:jenkins][:plugins]["performance"] = "1.10"
default[:jenkins][:plugins]["rebuild"] = "1.20"
default[:jenkins][:plugins]["remote-terminal-access"] = "1.3"
default[:jenkins][:plugins]["sauce-ondemand"] = "1.78"
default[:jenkins][:plugins]["scm-api"] = "0.2"
default[:jenkins][:plugins]["sectioned-view"] = "1.16"
default[:jenkins][:plugins]["script-realm"] = "1.5"
default[:jenkins][:plugins]["show-build-parameters"] = "1.0"
default[:jenkins][:plugins]["ssh-agent"] = "1.3"
default[:jenkins][:plugins]["ssh-credentials"] = "1.6.1"
default[:jenkins][:plugins]["ssh-slaves"] = "0.25"
default[:jenkins][:plugins]["subversion"] = "1.45"
default[:jenkins][:plugins]["throttle-concurrents"] = "1.8.2"
default[:jenkins][:plugins]["token-macro"] = "1.6"
default[:jenkins][:plugins]["translation"] = "1.10"