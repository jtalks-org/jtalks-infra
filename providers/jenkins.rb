require 'pathname'

def whyrun_supported?
  true
end

action :install do
  if @current_resource.exists
    Chef::Log.info "#{ @new_resource } already exists - nothing to do."
  else
    converge_by("Install #{ @new_resource }") do
      install_jenkins
    end
  end
end

action :update do
  if @current_resource.exists
    converge_by("Update #{ @new_resource }") do
      update_jenkins
    end
  else
    Chef::Log.info "#{ @new_resource } not installed - nothing to do."
  end
end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraJenkins.new(@new_resource.name)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.user(@new_resource.user)
  @current_resource.server_hostname(@new_resource.server_hostname)
  @current_resource.maven_backup_path(@new_resource.maven_backup_path)
  @current_resource.tomcat_port(@new_resource.tomcat_port)
  @current_resource.tomcat_shutdown_port(@new_resource.tomcat_shutdown_port)
  @current_resource.download_url(@new_resource.download_url)
  @current_resource.plugins_download_url(@new_resource.plugins_download_url)
  @current_resource.plugins_map(@new_resource.plugins_map)
  @current_resource.config_backup_path(@new_resource.config_backup_path)
  @current_resource.crowd_url(@new_resource.crowd_url)
  @current_resource.crowd_app_name(@new_resource.crowd_app_name)
  @current_resource.crowd_app_password(@new_resource.crowd_app_password)
  @current_resource.crowd_group(@new_resource.crowd_group)
  @current_resource.crowd_cookie_domain(@new_resource.crowd_cookie_domain)

  if Pathname.new("/home/#{@new_resource.user}/#{@current_resource.service_name}/webapps/ROOT").exist?
    @current_resource.exists = true
  end
end

#Install method
def install_jenkins
  owner = "#{current_resource.user}"
  dir = "/home/#{owner}"
  tomcat_port = current_resource.tomcat_port
  tomcat_shutdown_port = current_resource.tomcat_shutdown_port
  server_hostname = current_resource.server_hostname
  maven_backup_path = current_resource.maven_backup_path

  crowd_url = "#{current_resource.crowd_url}"
  crowd_app_name = "#{current_resource.crowd_app_name}"
  crowd_app_password = "#{current_resource.crowd_app_password}"
  crowd_group = "#{current_resource.crowd_group}"
  crowd_cookie_domain = "#{current_resource.crowd_cookie_domain}"

# Add user
  user owner do
    shell '/bin/bash'
    action :create
    home dir
    supports :manage_home => true
  end

  group owner do
    action :create
  end

  ssh_settings owner do
    user owner
    ssh_dir "#{dir}/.ssh"
    key_name "jtalks-infra"
    source_key_dir "keys/#{owner}"
    # *.hostname to all subdomains
    hostnames ["*.#{server_hostname}", "#{server_hostname}"]
  end

# Install Maven

  maven "maven" do
    owner owner
    base dir
    version "3"
    settings_path "#{maven_backup_path}"
  end

# Install Tomcat

  tomcat "#{current_resource.service_name}" do
    owner owner
    base dir
    port tomcat_port
    shutdown_port tomcat_shutdown_port
  end

  download_and_unpack_app_and_plugins

  service "#{current_resource.service_name}" do
    action :restart
  end

#Configuration
  bash "install_plugins_before_add_config_and_wait_2_minutes_after_start" do
    code  <<-EOH
     wget -t 100 localhost:#{tomcat_port}/jenkins;
     sleep 120
    EOH
    user owner
    group owner
  end


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
  end

  execute "chown -R #{owner}.#{owner} #{dir}/.jenkins"

# Replace configs
  replace_config "replace repo path" do
    search_pattern "<securityRealm.*</cookieDomain>"
    replace_string "<securityRealm class=\"de.theit.jenkins.crowd.CrowdSecurityRealm\" plugin=\"crowd2@1.8\">
    <url>#{crowd_url}</url>
    <applicationName>#{crowd_app_name}</applicationName>
    <password>#{crowd_app_password}</password>
    <group>#{crowd_group}</group>
    <nestedGroups>false</nestedGroups>
    <useSSO>true</useSSO>
    <sessionValidationInterval>2</sessionValidationInterval>
    <cookieDomain>#{crowd_cookie_domain}</cookieDomain>"
    path "#{dir}/.jenkins/config.xml"
    user owner
  end

  service "#{current_resource.service_name}" do
    action :restart
  end
end

#Update method
def update_jenkins
  owner = "#{current_resource.user}"
  dir = "/home/#{owner}"
  app_dir = "/home/#{owner}/#{current_resource.service_name}"

  execute "remove_previous_version" do
    user owner
    group owner
    command "rm -Rf #{app_dir}/webapps/ROOT; rm -Rf #{dir}/.jenkins/plugins/*;"
  end

  # Download ad unpack Jenkins
  download_and_unpack_app_and_plugins

  service "#{current_resource.service_name}" do
    action :restart
  end
end

def download_and_unpack_app_and_plugins
  owner = "#{current_resource.user}"
  dir = "/home/#{owner}"
  plugins_map = current_resource.plugins_map

  # Install Jenkins

  remote_file ::File.join("#{dir}/#{current_resource.service_name}/webapps/ROOT.war") do
    source   "#{current_resource.download_url}"
    owner    owner
    group    owner
  end

# Install plugins

# creates directory if jenkins not deploed yet
  directory "#{dir}/.jenkins/plugins" do
    owner owner
    group owner
    recursive true
    not_if { Pathname.new("#{dir}/.jenkins").exist? }
  end

  execute "chown -R #{owner}.#{owner} #{dir}/.jenkins"

  plugins_map.each do |name, version|
    remote_file ::File.join("#{dir}/.jenkins/plugins/#{name}.hpi") do
      source   "#{current_resource.plugins_download_url}/#{name}/#{version}/#{name}.hpi"
      owner    owner
      group    owner
      not_if { Pathname.new("#{dir}/.jenkins/plugins/#{name}.hpi").exist? }
    end
  end
end