# Variables of environment
default[:jtalks][:path][:init_script] = '/etc/init.d'

#Java
default[:java][:install_flavor] = 'oracle'
default[:java][:jdk_version] = 7
default[:java][:oracle][:accept_oracle_download_terms] = true

#Common variables of Tomcat
default[:tomcat][:major_version] = '8'
default[:tomcat][:minor_version] = '0.12'
default[:tomcat][:version] = "#{node[:tomcat][:major_version]}.#{node[:tomcat][:minor_version]}"
default[:tomcat][:download_url] = "http://apache-mirror.rbc.ru/pub/apache/tomcat/tomcat-#{node[:tomcat][:major_version]}/" +
    "v#{node[:tomcat][:version]}/bin/apache-tomcat-#{node[:tomcat][:version]}.zip"

#Jenkins
default[:jtalks][:jenkins][:user] = 'jenkins'
default[:tomcat][:instances][:jenkins][:port] = 8080
default[:tomcat][:instances][:jenkins][:shutdown_port] = 8010

