require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do
  prepare

  install_or_update_tomcat

  install_or_update_crowd

  configure
end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraCrowd.new(@new_resource.name)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.version(@new_resource.version)
  @current_resource.download_url(@new_resource.download_url)
  @current_resource.user(@new_resource.user)
  @current_resource.data_dir(@new_resource.data_dir)
  @current_resource.tomcat_port(@new_resource.tomcat_port)
  @current_resource.tomcat_shutdown_port(@new_resource.tomcat_shutdown_port)
  @current_resource.tomcat_jvm_opts(@new_resource.tomcat_jvm_opts)
  @current_resource.ext_libs_url(@new_resource.ext_libs_url)
  @current_resource.db_name(@new_resource.db_name)
  @current_resource.db_user(@new_resource.db_user)
  @current_resource.db_password(@new_resource.db_password)
  @current_resource.app_conf_license_text(@new_resource.app_conf_license_text)
  @current_resource.app_conf_name(@new_resource.app_conf_name)
  @current_resource.app_conf_password(@new_resource.app_conf_password)
  @current_resource.app_conf_url(@new_resource.app_conf_url)
  @current_resource.app_conf_cookie_domain(@new_resource.app_conf_cookie_domain)
  @current_resource.db_backup_path(@new_resource.db_backup_path)

  if Pathname.new("/home/#{@new_resource.user}/#{@current_resource.service_name}/#{current_resource.service_name}/webapps/ROOT").exist?
    @current_resource.exists = true
  end
end

def prepare
  owner = "#{current_resource.user}"
  data_dir = "#{current_resource.data_dir}"

  directory "/home/#{owner}/#{current_resource.service_name}" do
    owner owner
    group owner
  end

  directory "#{data_dir}" do
    owner owner
    group owner
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end
end

# Configure crowd
def configure
  owner = "#{current_resource.user}"
  user_home = "/home/#{owner}"
  app_dir = "#{user_home}/#{current_resource.service_name}"
  data_dir = "#{current_resource.data_dir}"
  db_name = "#{current_resource.db_name}"
  db_user = "#{current_resource.db_user}"
  db_password = "#{current_resource.db_password}"
  license_text = "#{current_resource.app_conf_license_text}"
  app_name = "#{current_resource.app_conf_name}"
  app_password = "#{current_resource.app_conf_password}"
  app_url = "#{current_resource.app_conf_url}"
  app_cookie_domain = "#{current_resource.app_conf_cookie_domain}"

  # Restore configs
  file "#{app_dir}/webapps/ROOT/WEB-INF/classes/crowd-init.properties" do
    owner owner
    group owner
    content "crowd.home=#{data_dir}"
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end

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
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
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
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end

  #if new installation than restore database
  if !(@current_resource.exists)
    # Restore database from backup
    # execute "restore database" do
    #   command "
    # mysql -u #{db_user} --password='#{db_password}' -b #{db_name} < #{current_resource.db_backup_path};
    # "
    #   user owner
    #   group owner
    # end
  end

  mysql_execute "set cookie domain" do
    user "#{db_user}"
    password "#{db_password}"
    db "#{db_name}"
    command "update cwd_property set property_value='#{app_cookie_domain}' where property_name='domain'"
  end
end

def install_or_update_tomcat
  owner = "#{current_resource.user}"
  user_home = "/home/#{owner}"
  service_name = "#{current_resource.service_name}"
  app_dir = "#{user_home}/#{service_name}"
  tomcat_port = current_resource.tomcat_port
  tomcat_shutdown_port = current_resource.tomcat_shutdown_port
  tomcat_jvm_opts = "#{current_resource.tomcat_jvm_opts}"

  tomcat "#{service_name}" do
    owner owner
    base "#{user_home}"
    port tomcat_port
    shutdown_port tomcat_shutdown_port
    jvm_opts tomcat_jvm_opts
  end

  #libraries copying always but notify restart server only if have change (need to update tomcat)
  mysql_connector "copy_mysql_connector_for_crowd" do
    user owner
    path "#{app_dir}/lib"
  end

  ark "external_crowd_libs" do
    url  "#{current_resource.ext_libs_url}"
    path "/tmp"
    owner owner
    action :put
    not_if {Pathname.new("/tmp/external_crowd_libs").exist?}
    notifies :restart, "service[#{service_name}]", :delayed
  end

  execute "add_external_libs_to_tomcat" do
    command "cp activation-* jta-* mail-* #{app_dir}/lib;"
    cwd "/tmp/external_crowd_libs/apache-tomcat/lib"
    user owner
    group owner
  end
end

def install_or_update_crowd
  owner = "#{current_resource.user}"
  app_dir = "/home/#{owner}/#{current_resource.service_name}"
  version = "#{current_resource.version}"

  remote_file "#{app_dir}/webapps/crowd-#{version}.zip" do
    source "#{current_resource.download_url}"
    owner owner
    group owner
    notifies :run, "execute[remove_previous_version]", :immediately
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
    not_if { Pathname.new("#{app_dir}/webapps/crowd-#{version}.zip}").exist? }
  end

  execute "remove_previous_version" do
    user owner
    group owner
    command "rm -Rf #{app_dir}/webapps/ROOT"
    action :nothing
    notifies :run, "execute[unpack_and_remove_archive]", :immediately
  end

  execute "unpack_and_remove_archive" do
    user owner
    group owner
    cwd "#{app_dir}/webapps"
    command "rm -Rf #{app_dir}/webapps/ROOT; unzip crowd-#{version}.zip -d #{app_dir}/webapps/ROOT"
    action :nothing
  end
end



