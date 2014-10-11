#Variables of environment
default[:jtalks][:path][:init_script] = "/etc/init.d"

#Variables of backup server. applications might be on different servers with same hostname of first level
default[:jtalks][:backup][:hostname] = "jtalks.org"

#Java
default[:java][:install_flavor] = "oracle"
default[:java][:jdk_version] = 7
default[:java][:oracle][:accept_oracle_download_terms] = true

#Common variables of Tomcat
default[:tomcat][:major_version] = "8"
default[:tomcat][:minor_version] = "0.12"
default[:tomcat][:version] = "#{node[:tomcat][:major_version]}.#{node[:tomcat][:minor_version]}"
default[:tomcat][:download_url] = "http://apache-mirror.rbc.ru/pub/apache/tomcat/tomcat-#{node[:tomcat][:major_version]}/" +
    "v#{node[:tomcat][:version]}/bin/apache-tomcat-#{node[:tomcat][:version]}.zip"

#Jenkins
default[:jenkins][:user] = "jenkins"
default[:jenkins][:version] = "1.566"
default[:jenkins][:sources][:url] = "http://mirrors.jenkins-ci.org/war/#{node[:jenkins][:version]}/jenkins.war"
default[:jenkins][:sources][:plugins_url] = "http://updates.jenkins-ci.org/download/plugins"
default[:tomcat][:instances][:jenkins][:port] = 8080
default[:tomcat][:instances][:jenkins][:shutdown_port] = 8010
## plugins
default[:jenkins][:plugins]["ansicolor"] = "0.3.1"
default[:jenkins][:plugins]["ant"] = "1.2"
default[:jenkins][:plugins]["build-pipeline-plugin"] = "1.4.3"
default[:jenkins][:plugins]["build-name-setter"] = "1.3"
default[:jenkins][:plugins]["copy-to-slave"] = "1.4.3"
default[:jenkins][:plugins]["createjobadvanced"] = "1.8"
default[:jenkins][:plugins]["credentials"] = "1.10"
default[:jenkins][:plugins]["crowd2"] = "1.8"
default[:jenkins][:plugins]["cvs"] = "2.8"
default[:jenkins][:plugins]["description-setter"] = "1.8"
default[:jenkins][:plugins]["email-ext"] = "2.29"
default[:jenkins][:plugins]["envinject"] = "1.88"
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
default[:jenkins][:plugins]["PrioritySorter"] = "2.8"
default[:jenkins][:plugins]["sonar"] = "2.1"
default[:jenkins][:plugins]["ldap"] = "1.11"
default[:jenkins][:plugins]["mailer"] = "1.4"
default[:jenkins][:plugins]["mask-passwords"] = "2.7.2"
default[:jenkins][:plugins]["maven-plugin"] = "1.514"
default[:jenkins][:plugins]["external-monitor-job"] = "1.1"
default[:jenkins][:plugins]["nested-view"] = "1.11"
default[:jenkins][:plugins]["pam-auth"] = "1.2"
default[:jenkins][:plugins]["parameterized-trigger"] = "2.17"
default[:jenkins][:plugins]["performance"] = "1.10"
default[:jenkins][:plugins]["rebuild"] = "1.20"
default[:jenkins][:plugins]["remote-terminal-access"] = "1.3"
default[:jenkins][:plugins]["sauce-ondemand"] = "1.78"
default[:jenkins][:plugins]["scm-api"] = "0.2"
default[:jenkins][:plugins]["sectioned-view"] = "1.16"
default[:jenkins][:plugins]["show-build-parameters"] = "1.0"
default[:jenkins][:plugins]["ssh-agent"] = "1.5"
default[:jenkins][:plugins]["ssh-credentials"] = "1.6.1"
default[:jenkins][:plugins]["ssh-slaves"] = "0.25"
default[:jenkins][:plugins]["subversion"] = "1.45"
default[:jenkins][:plugins]["throttle-concurrents"] = "1.8.2"
default[:jenkins][:plugins]["token-macro"] = "1.6"
default[:jenkins][:plugins]["translation"] = "1.10"