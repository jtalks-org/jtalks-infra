require 'pathname'

def whyrun_supported?
  true
end

action :install do
  if @current_resource.exists
    Chef::Log.info "#{ @new_resource } already exists - nothing to do."
  else
    converge_by("Install #{ @new_resource }") do
      install_crowd
    end
  end
end

action :update do
  if @current_resource.exists
    converge_by("Update #{ @new_resource }") do
      update_crowd
    end
  else
    Chef::Log.info "#{ @new_resource } not installed - nothing to do. !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  end
end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraCrowd.new(@new_resource.name)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.download_url(@new_resource.download_url)
  @current_resource.user(@new_resource.user)
  @current_resource.data_dir(@new_resource.data_dir)
  @current_resource.tomcat_port(@new_resource.tomcat_port)
  @current_resource.tomcat_shutdown_port(@new_resource.tomcat_shutdown_port)
  @current_resource.mysql_connector_url(@new_resource.mysql_connector_url)
  @current_resource.ext_libs_url(@new_resource.ext_libs_url)
  @current_resource.db_config_name(@new_resource.db_config_name)
  @current_resource.app_conf_license_text(@new_resource.app_conf_license_text)
  @current_resource.app_conf_name(@new_resource.app_conf_name)
  @current_resource.app_conf_password(@new_resource.app_conf_password)
  @current_resource.app_conf_url(@new_resource.app_conf_url)
  @current_resource.app_conf_cookie_domain(@new_resource.app_conf_cookie_domain)
  @current_resource.db_backup_path(@new_resource.db_backup_path)

  if Pathname.new("/home/#{@new_resource.user}/#{@current_resource.service_name}/webapps/ROOT").exist?
    @current_resource.exists = true
  end
end

#Install method
def install_crowd
  owner = "#{current_resource.user}"
  user_home = "/home/#{owner}"
  app_dir = "#{user_home}/#{current_resource.service_name}"
  data_dir = "#{current_resource.data_dir}/#{current_resource.service_name}"
  db_name = "#{node[:db][current_resource.db_config_name][:name]}"
  db_user = "#{node[:db][current_resource.db_config_name][:name]}"
  db_password = "#{node[:db][current_resource.db_config_name][:name]}"
  license_text = "#{current_resource.app_conf_license_text}"
  tomcat_port = current_resource.tomcat_port
  tomcat_shutdown_port = current_resource.tomcat_shutdown_port
  app_name = "#{current_resource.app_conf_name}"
  app_password = "#{current_resource.app_conf_password}"
  app_url = "#{current_resource.app_conf_url}"
  app_cookie_domain = "#{current_resource.app_conf_cookie_domain}"

  # Database
  jtalks_database "#{current_resource.db_config_name}"

  # Add user
  user owner do
    shell '/bin/bash'
    action :create
    home user_home
    supports :manage_home => true
  end

  group owner do
    action :create
  end

  directory "#{current_resource.data_dir}" do
    owner owner
    group owner
  end

  directory "#{data_dir}" do
    owner owner
    group owner
  end

  #Install Tomcat
  tomcat "#{current_resource.service_name}" do
    owner owner
    base user_home
    port tomcat_port
    shutdown_port tomcat_shutdown_port
  end

# Install Crowd
  ark "mysql_connector" do
    url "#{current_resource.mysql_connector_url}"
    path "/tmp"
    owner owner
    group owner
    action :put
  end

  execute "cp mysql-connector*.jar #{app_dir}/lib; rm -Rf /tmp/mysql_connector" do
    cwd "/tmp/mysql_connector"
    user owner
    group owner
  end

  ark "external_crowd_libs" do
    url  "#{current_resource.ext_libs_url}"
    path "/tmp"
    owner owner
    action :put
  end

  execute "cp activation-* jta-* mail-* #{app_dir}/lib; rm -Rf /tmp/external_crowd_libs" do
    cwd "/tmp/external_crowd_libs/apache-tomcat/lib"
    user owner
    group owner
  end

  # Download ad unpack Crowd
  download_and_unpack

  template "#{data_dir}/crowd.cfg.xml" do
    source 'crowd.cfg.xml.erb'
    owner owner
    group owner
    variables({
                  :db_name => db_name,
                  :db_user => db_user,
                  :db_password => db_password,
                  :license_text => license_text
              })
  end

  template "#{data_dir}/crowd.properties" do
    source 'crowd.properties.erb'
    owner owner
    group owner
    variables({
                  :app_name =>  app_name,
                  :app_password =>  app_password,
                  :server_url => app_url,
                  :cookie_domain => app_cookie_domain
              })
  end

# Restore database from backup
  execute "restore database" do
    command "
  mysql -u #{db_user} --password='#{db_password}' -b #{db_name} < #{current_resource.db_backup_path};
  "
    user owner
    group owner
  end

  mysql_execute "set cookie domain" do
    app_name "#{db_name}"
    command "update cwd_property set property_value='#{app_cookie_domain}' where property_name='domain'"
  end

  service "#{current_resource.service_name}" do
    action :restart
  end
end

#Update method
def update_crowd
  owner = "#{current_resource.user}"
  app_dir = "/home/#{owner}/#{current_resource.service_name}"

  execute "remove_previous_version" do
    user owner
    group owner
    command "rm -Rf #{app_dir}/webapps/ROOT"
  end

  # Download ad unpack Crowd
  download_and_unpack

  service "#{current_resource.service_name}" do
    action :restart
  end
end

def download_and_unpack
  owner = "#{current_resource.user}"
  app_dir = "/home/#{owner}/#{current_resource.service_name}"
  data_dir = "#{current_resource.data_dir}/#{current_resource.service_name}"

  remote_file "#{app_dir}/webapps/crowd.zip" do
    source "#{current_resource.download_url}"
    owner owner
    group owner
  end

  execute "unpack and remove archive" do
    user owner
    group owner
    cwd "#{app_dir}/webapps"
    command "unzip crowd.zip -d #{app_dir}/webapps/ROOT; rm -Rf crowd.zip"
  end

  # Restore configs
  file "#{app_dir}/webapps/ROOT/WEB-INF/classes/crowd-init.properties" do
    owner owner
    group owner
    content "crowd.home=#{data_dir}"
  end
end