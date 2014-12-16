require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do
  prepare

  install_or_update_tomcat

  install_or_update_confluence

  configure
end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraConfluence.new(@new_resource.name)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.version(@new_resource.version)
  @current_resource.source_url(@new_resource.source_url)
  @current_resource.user(@new_resource.user)
  @current_resource.data_dir(@new_resource.data_dir)
  @current_resource.tomcat_port(@new_resource.tomcat_port)
  @current_resource.tomcat_shutdown_port(@new_resource.tomcat_shutdown_port)
  @current_resource.tomcat_jvm_opts(@new_resource.tomcat_jvm_opts)
  @current_resource.crowd_url(@new_resource.crowd_url)
  @current_resource.crowd_app_name(@new_resource.crowd_app_name)
  @current_resource.crowd_app_password(@new_resource.crowd_app_password)
  @current_resource.db_name(@new_resource.db_name)
  @current_resource.db_user(@new_resource.db_user)
  @current_resource.db_password(@new_resource.db_password)
  @current_resource.license_text(@new_resource.license_text)
  @current_resource.db_backup_path(@new_resource.db_backup_path)

  if Pathname.new("/home/#{@new_resource.user}/#{@current_resource.service_name}/webapps/ROOT").exist?
    @current_resource.exists = true
  end
end

def prepare
  user = "#{current_resource.user}"
  data_dir = "#{current_resource.data_dir}"
  db_name = "#{current_resource.db_name}"
  db_user = "#{current_resource.db_user}"
  db_password = "#{current_resource.db_password}"

  directory "#{data_dir}" do
    owner user
    group user
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end

  #if new installation than restore database
  if !(@current_resource.exists)
    # Restore database from backup
    execute "restore_database_confluence" do
      command "
        mysql -u #{db_user} --password='#{db_password}' -b #{db_name} < #{current_resource.db_backup_path};
        "
      user user
      group user
      only_if { Pathname.new("#{current_resource.db_backup_path}").exist? }
    end
  end
end

def configure

end

def install_or_update_tomcat
  user = "#{current_resource.user}"
  user_home = "/home/#{user}"
  service_name = "#{current_resource.service_name}"
  app_dir = "#{user_home}/#{service_name}"
  tomcat_port = current_resource.tomcat_port
  tomcat_shutdown_port = current_resource.tomcat_shutdown_port
  tomcat_jvm_opts = "#{current_resource.tomcat_jvm_opts}"

  tomcat "#{service_name}" do
    owner user
    base "#{user_home}"
    port tomcat_port
    shutdown_port tomcat_shutdown_port
    jvm_opts tomcat_jvm_opts
  end

  #libraries copying always but notify restart server only if have change (need to update tomcat)
  mysql_connector "copy_mysql_connector_for_confluence" do
    user user
    path "#{app_dir}/lib"
  end
end

def install_or_update_confluence

end



