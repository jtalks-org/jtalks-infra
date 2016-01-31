require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do

  backup

  install_or_update_sonar

  configure
end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraSonar.new(@new_resource.name)
  @current_resource.version(@new_resource.version)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.source_url(@new_resource.source_url)
  @current_resource.user(@new_resource.user)
  @current_resource.port(@new_resource.port)
  @current_resource.jvm_opts(@new_resource.jvm_opts)
  @current_resource.db_name(@new_resource.db_name)
  @current_resource.db_user(@new_resource.db_user)
  @current_resource.db_password(@new_resource.db_password)
  @current_resource.db_backup_path(@new_resource.db_backup_path)
  @current_resource.plugins_map(@new_resource.plugins_map)
  @current_resource.crowd_url(@new_resource.crowd_url)
  @current_resource.crowd_app_name(@new_resource.crowd_app_name)
  @current_resource.crowd_app_password(@new_resource.crowd_app_password)

  if Pathname.new("/home/#{@new_resource.user}/#{@current_resource.service_name}").exist?
    @current_resource.exists = true
  end
end

def backup
  owner = "#{current_resource.user}"
  service_name = "#{current_resource.service_name}"
  app_dir = "/home/#{owner}/#{service_name}"
  db_name = "#{current_resource.db_name}"
  db_user = "#{current_resource.db_user}"
  db_password = "#{current_resource.db_password}"
  version = "#{current_resource.version}"

  stable_backup "backup_stable_sonar" do
    user owner
    service_name service_name
    version version
    db_name db_name
    db_user db_user
    db_pass db_password
    tomcat_container false
    paths [app_dir]
  end
end

def configure
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  app_dir = "#{dir}/#{current_resource.service_name}"
  port = current_resource.port
  jvm_opts = "#{current_resource.jvm_opts}"
  db_name = "#{current_resource.db_name}"
  db_user = "#{current_resource.db_user}"
  db_password = "#{current_resource.db_password}"
  service_name = "#{current_resource.service_name}"
  crowd_url = "#{current_resource.crowd_url}"
  crowd_app = "#{current_resource.crowd_app_name}"
  crowd_password = "#{current_resource.crowd_app_password}"

  # Restore configs
  template "#{app_dir}/conf/sonar.properties" do
    source 'sonar.properties.erb'
    owner user
    group user
    variables({
                  :port => port,
                  :jvm_opts => jvm_opts,
                  :db_name => db_name,
                  :db_user => db_user,
                  :db_password => db_password,
                  :crowd_url => crowd_url,
                  :crowd_app => crowd_app,
                  :crowd_password => crowd_password
              })
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  #if new installation than restore database
  if !(@current_resource.exists)
    execute "restore database_sonar" do
      command "
    mysql -u #{db_user} --password='#{db_password}' -b #{db_name} < #{current_resource.db_backup_path};
    "
      user user
      group user
      only_if { Pathname.new("#{current_resource.db_backup_path}").exist? }
    end

    directory "#{app_dir}/data/es" do
      owner user
      group user
      action :delete
    end
  end
end

def install_or_update_sonar
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  service_name = "#{current_resource.service_name}"
  app_dir = "#{dir}/#{service_name}"
  plugins_map = current_resource.plugins_map
  plugins_dir = "#{app_dir}/extensions/plugins"
  version = "#{current_resource.version}"

  ark "#{current_resource.service_name}-#{version}" do
    url current_resource.source_url
    path "#{dir}/backup"
    owner user
    action :put
    notifies :stop, "service[sonar]", :immediately
    notifies :run, "execute[replace_old_sonar]", :immediately
    notifies :run, "execute[#{service_name}_restart]", :delayed
    not_if  { Pathname.new("#{dir}/backup/#{current_resource.service_name}-#{version}").exist? }
  end

  execute "replace_old_sonar" do
    command "
        chown -R #{user}.#{user}  #{app_dir};
        rm -Rf #{app_dir}/*;
        cp -R #{dir}/backup/#{current_resource.service_name}-#{version}/* #{app_dir}/ ;
        chown -R #{user}.#{user} #{app_dir}
    "
    action :nothing
  end

  directory "#{app_dir}/extensions/jdbc-driver/mysql" do
    user user
    group user
  end

  mysql_connector "copy_mysql_connector_for_sonar" do
    user user
    path "#{app_dir}/extensions/jdbc-driver/mysql"
  end

  template "#{node[:jtalks][:path][:init_script]}/#{service_name}" do
    source 'sonar.service.erb'
    mode '775'
    owner user
    group user
    variables({
                  :dir => app_dir})
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  plugins_map.each do |name, data|
    remote_file "#{plugins_dir}/#{name}-#{data[:version]}.jar" do
      source   "#{data[:url]}"
      owner    user
      group    user
      not_if { Pathname.new("#{plugins_dir}/#{name}-#{data[:version]}.jar").exist? }
      notifies :run, "execute[#{service_name}_restart]", :delayed
    end
  end

  service "#{service_name}" do
    supports :restart => true
    action :enable
  end

  restart_service service_name do
    user user
  end
end



