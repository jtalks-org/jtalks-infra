require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do
  prepare

  install_or_update_tomcat

  install_or_update_jira

  configure
end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraJira.new(@new_resource.name)
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
  crowd_url = "#{current_resource.crowd_url}"
  crowd_app_name = "#{current_resource.crowd_app_name}"
  crowd_app_password = "#{current_resource.crowd_app_password}"
  db_backup_path = "#{current_resource.db_backup_path}"
  license_text = "#{current_resource.license_text}"

  directory "#{data_dir}" do
    owner user
    group user
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end

  directory "#{data_dir}/data" do
    owner user
    group user
    mode "775"
    recursive true
  end

  #if new installation than restore database
  if !(@current_resource.exists)
    # Restore attachments
     execute "unpack_jira_data" do
        user user
        group user
        cwd "#{node[:jtalks][:cookbook_path]}/#{user}"
        command "tar xvfz data.tar.gz -C #{data_dir}/data"
        only_if {  Pathname.new("#{node[:jtalks][:cookbook_path]}/#{user}/data.tar.gz").exist? }
    end

    # Restore database from backup
    if  Pathname.new("#{current_resource.db_backup_path}").exist?
      execute "restore_database_jira" do
        command "
          mysql -u #{db_user} --password='#{db_password}' -b #{db_name} < #{db_backup_path};
        "
        user user
        group user
      end

      mysql_execute "set_license_to_jira" do
        user "#{db_user}"
        password "#{db_password}"
        db "#{db_name}"
        command "update propertytext set propertyvalue='#{license_text}' where id = (select id from propertyentry where property_key = 'License20')"
      end

      mysql_execute "set_crowd_application_name_to_jira" do
        user "#{db_user}"
        password "#{db_password}"
        db "#{db_name}"
        command "update cwd_directory_attribute set attribute_value='#{crowd_app_name}' where attribute_name='application.name'"
      end

      mysql_execute "set_crowd_url_to_jira" do
        user "#{db_user}"
        password "#{db_password}"
        db "#{db_name}"
        command "update cwd_directory_attribute set attribute_value='#{crowd_url}' where attribute_name='crowd.server.url'"
      end

      mysql_execute "set_crowd_application_password_to_jira" do
        user "#{db_user}"
        password "#{db_password}"
        db "#{db_name}"
        command "update cwd_directory_attribute set attribute_value='#{crowd_app_password}' where attribute_name='application.password'"
      end
    end
  end
end

def configure
  user = "#{current_resource.user}"
  app_dir = "#{user_home}/#{service_name}"
  data_dir = "#{current_resource.data_dir}"
  db_name = "#{current_resource.db_name}"
  db_user = "#{current_resource.db_user}"
  db_password = "#{current_resource.db_password}"
  service_name = "#{current_resource.service_name}"

  template "#{data_dir}/dbconfig.xml" do
    source 'jira.dbconfig.xml.erb'
    mode "775"
    owner user
    group user
    variables({
                  :db_name => db_name,
                  :db_user => db_user,
                  :db_password => db_password
              })
    notifies :restart, "service[#{service_name}]", :delayed
  end

  file "#{app_dir}/webapps/ROOT/WEB-INF/classes/jira-application.properties" do
    owner user
    group user
    content "jira.home=#{data_dir}"
    notifies :restart, "service[#{service_name}]", :delayed
  end
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

  mysql_connector "copy_mysql_connector_for_jira" do
    user user
    path "#{app_dir}/lib"
  end
end

def install_or_update_jira
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  service_name = "#{current_resource.service_name}"
  app_dir = "#{dir}/#{service_name}"
  version = "#{current_resource.version}"

  remote_file "#{app_dir}/webapps/jira-#{version}.tar.gz" do
    source "#{current_resource.source_url}"
    owner user
    group user
    notifies :run, "execute[unpack_and_remove_jira]", :immediately
    notifies :restart, "service[#{service_name}]", :delayed
    not_if { Pathname.new("#{app_dir}/webapps/jira-#{version}.tar.gz}").exist? }
  end

  execute "unpack_and_remove_jira" do
    user user
    group user
    cwd "#{app_dir}/webapps"
    command "rm -Rf #{app_dir}/webapps/ROOT; tar xvfz jira-#{version}.tar.gz;
                     mv atlassian-jira-#{version}-war/webapp ROOT; rm -Rf atlassian-jira-#{version}-war"
    action :nothing
  end
end



