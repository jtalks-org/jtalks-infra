require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do
  prepare

  install_or_update_tomcat

  install_or_update_jenkins

  configure
end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraJenkins.new(@new_resource.name)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.version(@new_resource.version)
  @current_resource.user(@new_resource.user)
  @current_resource.known_hosts(@new_resource.known_hosts)
  @current_resource.maven_backup_path(@new_resource.maven_backup_path)
  @current_resource.tomcat_port(@new_resource.tomcat_port)
  @current_resource.tomcat_shutdown_port(@new_resource.tomcat_shutdown_port)
  @current_resource.tomcat_jvm_opts(@new_resource.tomcat_jvm_opts)
  @current_resource.download_url(@new_resource.download_url)
  @current_resource.plugins_download_url(@new_resource.plugins_download_url)
  @current_resource.plugins_map(@new_resource.plugins_map)
  @current_resource.config_backup_path(@new_resource.config_backup_path)
  @current_resource.crowd_url(@new_resource.crowd_url)
  @current_resource.crowd_app_name(@new_resource.crowd_app_name)
  @current_resource.crowd_app_password(@new_resource.crowd_app_password)
  @current_resource.crowd_group(@new_resource.crowd_group)
  @current_resource.crowd_cookie_domain(@new_resource.crowd_cookie_domain)
  @current_resource.crowd_token(@new_resource.crowd_token)
  @current_resource.init_scripts_path(@new_resource.init_scripts_path)

  if Pathname.new("/home/#{@new_resource.user}/#{@current_resource.service_name}/webapps/ROOT").exist?
    @current_resource.exists = true
  end
end

def prepare
  owner = "#{current_resource.user}"
  dir = "/home/#{owner}"
  known_hosts = current_resource.known_hosts
  maven_backup_path = current_resource.maven_backup_path
  maven_version = "3"
  # Add user
  user owner do
    shell '/bin/bash'
    action :create
    home dir
    supports :manage_home => true
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end

  group owner do
    action :create
  end

  ssh_settings owner do
    user owner
    ssh_dir "#{dir}/.ssh"
    key_name "id_rsa"
    source_key_dir "keys/#{owner}"
    # *.hostname to all subdomains
    known_hosts known_hosts
  end

  # Install (if not installed) Maven and config

  maven "maven" do
    owner owner
    base dir
    version maven_version
    settings_path "#{maven_backup_path}"
  end
end

# Configure crowd
def configure
  owner = "#{current_resource.user}"
  dir = "/home/#{owner}"
  crowd_url = "#{current_resource.crowd_url}"
  crowd_app_name = "#{current_resource.crowd_app_name}"
  crowd_app_password = "#{current_resource.crowd_app_password}"
  crowd_group = "#{current_resource.crowd_group}"
  crowd_cookie_domain = "#{current_resource.crowd_cookie_domain}"
  crowd_token = "#{current_resource.crowd_token}"
  maven_version = "3"
  java_home = "/usr/lib/jvm/default-java"

  # restore config if new install jenkins
  execute "restore-jenkins-config-and-jobs" do
    command "
    rm -Rf #{dir}/.jenkins/*.xml; rm -Rf #{dir}/.jenkins/jobs;
    cp -R #{current_resource.config_backup_path}/*.xml #{dir}/.jenkins;
    cp -R #{current_resource.config_backup_path}/*.key #{dir}/.jenkins;
    cp -R #{current_resource.config_backup_path}/jobs #{dir}/.jenkins;
    cp -R #{current_resource.config_backup_path}/secrets #{dir}/.jenkins;
    cp -R #{current_resource.config_backup_path}/users #{dir}/.jenkins;"
    user owner
    group owner
    not_if { current_resource.exists }
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end

  jtalks_infra_replacer "jenkins_realm_config" do
    owner owner
    group owner
    file "#{dir}/.jenkins/config.xml"
    replace "<securityRealm.*</securityRealm>"
    with "<securityRealm class=\"de.theit.jenkins.crowd.CrowdSecurityRealm\" plugin=\"crowd2@1.8\">
         <url>#{crowd_url}</url>
         <applicationName>#{crowd_app_name}</applicationName>
         <password>#{crowd_app_password}</password>
         <group>#{crowd_group}</group>
         <nestedGroups>false</nestedGroups>
         <useSSO>true</useSSO>
         <sessionValidationInterval>2</sessionValidationInterval>
         <cookieDomain>#{crowd_cookie_domain}</cookieDomain>
         <cookieTokenkey>#{crowd_token}</cookieTokenkey>
         <useProxy>false</useProxy>
         <httpProxyHost></httpProxyHost>
         <httpProxyPort></httpProxyPort>
         <httpProxyUsername></httpProxyUsername>
         <httpProxyPassword></httpProxyPassword>
         <socketTimeout>20000</socketTimeout>
         <httpTimeout>5000</httpTimeout>
         <httpMaxConnections>200</httpMaxConnections>
      </securityRealm>"
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
    end

  jtalks_infra_replacer "jenkins_env_variables" do
    owner owner
    group owner
    file "#{dir}/.jenkins/config.xml"
    replace "<envVars.*<\/envVars>"
    #IMPORTANT if add new parameter change count <int>31</int>
    with "<envVars serialization=\"custom\">
        <unserializable-parents/>
        <tree-map>
          <default>
            <comparator class=\"hudson.util.CaseInsensitiveComparator\"/>
          </default>
          <int>31</int>
          <string>BACKUP_DB</string>
          <string>/home/jenkins/backup/db</string>
          <string>BACKUP_WAR</string>
          <string>/home/jenkins/backup/war</string>
          <string>DEV_BACKUP_DIR</string>
          <string>/home/tomcat/app_backups</string>
          <string>DEV_IP</string>
          <string>176.9.66.108</string>
          <string>DEV_JTALKS_GROUP</string>
          <string>jtalks</string>
          <string>DEV_JTALKS_USER</string>
          <string>jtalks</string>
          <string>DEV_MYSQL_USER</string>
          <string>root</string>
          <string>DEV_SSH</string>
          <string>tomcat@176.9.66.108</string>
          <string>DEV_SSH_JTALKS</string>
          <string>jtalks@176.9.66.108</string>
          <string>DEV_TOMCAT_DEPLOY</string>
          <string>/home/tomcat/app/tomcat-deploy/webapps</string>
          <string>DEV_TOMCAT_DIR</string>
          <string>/home/tomcat/app</string>
          <string>DEV_TOMCAT_GROUP</string>
          <string>tomcat</string>
          <string>DEV_TOMCAT_JAVATALKS</string>
          <string>/home/tomcat/app/tomcat-javatalks/webapps</string>
          <string>DEV_TOMCAT_UAT</string>
          <string>/home/tomcat/app/tomcat-uat/webapps</string>
          <string>DEV_TOMCAT_USER</string>
          <string>tomcat</string>
          <string>JAVA_HOME</string>
          <string>#{java_home}</string>
          <string>JDK_HOME</string>
          <string>#{java_home}</string>
          <string>M2_HOME</string>
          <string>#{dir}/maven#{maven_version}</string>
          <string>PATH</string>
          <string>/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:#{java_home}/bin:#{dir}/maven#{maven_version}/bin</string>
          <string>PROD_BACKUP_DIR</string>
          <string>/home/jtalks/apps_backup</string>
          <string>PROD_GROUP</string>
          <string>jtalks</string>
          <string>PROD_IP</string>
          <string>213.239.201.68</string>
          <string>PROD_JCOMMUNE_DIR</string>
          <string>/home/jtalks/apps/jcommune/tomcat-jcommune/webapps</string>
          <string>PROD_MYSQL_USER</string>
          <string>root</string>
          <string>PROD_POULPE_DIR</string>
          <string>/home/jtalks/apps/poulpe/tomcat-poulpe/webapps</string>
          <string>PROD_SSH</string>
          <string>jtalks@213.239.201.68</string>
          <string>PROD_USER</string>
          <string>jtalks</string>
          <string>SSH_TO_POCHTA</string>
          <string>pochta@176.9.66.108</string>
          <string>SSH_TO_SITE</string>
          <string>site@176.9.66.108</string>
          <string>TEST_SERVER_ANTARCTICLE_SSH</string>
          <string>antarcticle@5.9.40.180</string>
          <string>TEST_SERVER_TOMCAT_SSH</string>
          <string>tomcat@5.9.40.180</string>
        </tree-map>
      </envVars>"
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end

  jtalks_infra_replacer "jenkins_jdk_config" do
    owner owner
    group owner
    file "#{dir}/.jenkins/config.xml"
    replace "<jdks.*</jdks>"
    with "<jdks>
         <jdk>
           <name>JDK</name>
           <home>#{java_home}</home>
           <properties/>
         </jdk>
       </jdks>"
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end

  jtalks_infra_replacer "jenkins_maven_config" do
    owner owner
    group owner
    file "#{dir}/.jenkins/hudson.tasks.Maven.xml"
    replace "<installations.*</installations>"
     with "<installations>
      <hudson.tasks.Maven_-MavenInstallation>
        <name>maven#{maven_version}</name>
        <home>#{dir}/maven#{maven_version}</home>
        <properties/>
      </hudson.tasks.Maven_-MavenInstallation>
  </installations>"
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end

  jtalks_infra_replacer "cvs_key_config" do
    owner owner
    group owner
    file "#{dir}/.jenkins/hudson.scm.CVSSCM.xml"
    replace "<privateKeyLocation.*</knownHostsLocation>"
    with "<privateKeyLocation>#{dir}/.ssh/id_rsa</privateKeyLocation>
       <privateKeyPassword></privateKeyPassword>
       <knownHostsLocation>#{dir}/.ssh/known_hosts</knownHostsLocation>"
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end

  jtalks_infra_replacer "replace_maven_global_settings" do
    owner owner
    group owner
    file "#{dir}/.jenkins/jenkins.mvn.GlobalMavenConfig.xml"
    replace "<settingsProvider.*</globalSettingsProvider>"
    with "<settingsProvider class=\"jenkins.mvn.FilePathSettingsProvider\">
        <path>#{dir}/maven#{maven_version}/conf/settings.xml</path>
      </settingsProvider>
      <globalSettingsProvider class=\"jenkins.mvn.FilePathGlobalSettingsProvider\">
        <path>#{dir}/maven#{maven_version}/conf/settings.xml</path>
      </globalSettingsProvider>"
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end
end

def install_or_update_tomcat
  owner = "#{current_resource.user}"
  dir = "/home/#{owner}"
  tomcat_port = current_resource.tomcat_port
  tomcat_shutdown_port = current_resource.tomcat_shutdown_port
  tomcat_jvm_opts = "#{current_resource.tomcat_jvm_opts}"

  tomcat "#{current_resource.service_name}" do
    owner owner
    base dir
    port tomcat_port
    shutdown_port tomcat_shutdown_port
    jvm_opts tomcat_jvm_opts
  end

end

def install_or_update_jenkins
  owner = "#{current_resource.user}"
  dir = "/home/#{owner}"
  plugins_map = current_resource.plugins_map
  app_dir = "#{dir}/#{current_resource.service_name}"
  version = "#{current_resource.version}"

  remote_file "#{dir}/#{current_resource.service_name}/webapps/jenkins-#{version}" do
    source   "#{current_resource.download_url}"
    owner owner
    group owner
    notifies :run, "execute[remove_previous_version]", :immediately
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
    not_if { Pathname.new("#{dir}/#{current_resource.service_name}/webapps/jenkins-#{version}").exist? }
  end

  execute "remove_previous_version" do
    user owner
    group owner
    command "
     rm -Rf #{app_dir}/webapps/ROOT;
     cp #{dir}/#{current_resource.service_name}/webapps/jenkins-#{version} #{dir}/#{current_resource.service_name}/webapps/ROOT.war;
     rm -Rf #{dir}/.jenkins/plugins/*;"
    action :nothing
  end

  # Install plugins
  directory "#{dir}/.jenkins" do
    owner owner
    group owner
    not_if { Pathname.new("#{dir}/.jenkins").exist? }
  end

  # creates directory if jenkins not deploy yet
  directory "#{dir}/.jenkins/plugins" do
    owner owner
    group owner
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end

  plugins_map.each do |name, version|
    remote_file "#{dir}/.jenkins/plugins/#{name}.hpi" do
      source   "#{current_resource.plugins_download_url}/#{name}/#{version}/#{name}.hpi"
      owner    owner
      group    owner
      not_if { Pathname.new("#{dir}/.jenkins/plugins/#{name}.hpi").exist? || Pathname.new("#{dir}/.jenkins/plugins/#{name}.jpi").exist? }
      notifies :restart, "service[#{current_resource.service_name}]", :delayed
    end
  end

  #if new installation than start service to deploy (install plugins)
  if !(@current_resource.exists)
    service "#{current_resource.service_name}" do
      action :restart
    end

    bash "install_plugins_before_add_config_and_wait_3_minutes_after_start" do
      code  <<-EOH
        sleep 180
      EOH
      user owner
      group owner
    end
  end
end
