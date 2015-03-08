require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do

  prepare

  backup

  install_or_update_fisheye

  configure
end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraFisheye.new(@new_resource.name)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.source_url(@new_resource.source_url)
  @current_resource.user(@new_resource.user)
  @current_resource.data_dir(@new_resource.data_dir)
  @current_resource.port(@new_resource.port)
  @current_resource.host(@new_resource.host)
  @current_resource.control_port(@new_resource.control_port)
  @current_resource.crowd_url(@new_resource.crowd_url)
  @current_resource.crowd_app_name(@new_resource.crowd_app_name)
  @current_resource.crowd_app_password(@new_resource.crowd_app_password)
  @current_resource.crowd_groups(@new_resource.crowd_groups)
  @current_resource.crowd_admin_group(@new_resource.crowd_admin_group)
  @current_resource.db_name(@new_resource.db_name)
  @current_resource.db_user(@new_resource.db_user)
  @current_resource.db_password(@new_resource.db_password)
  @current_resource.db_backup_path(@new_resource.db_backup_path)
  @current_resource.version(@new_resource.version)
  @current_resource.license_text(@new_resource.license_text)
  @current_resource.crucible_license_text(@new_resource.crucible_license_text)
  @current_resource.git_bin_path(@new_resource.git_bin_path)
  @current_resource.smtp_host(@new_resource.smtp_host)
  @current_resource.smtp_port(@new_resource.smtp_port)
  @current_resource.smtp_user(@new_resource.smtp_user)
  @current_resource.smtp_password(@new_resource.smtp_password)
  @current_resource.repositories(@new_resource.repositories)

  if Pathname.new("/home/#{@new_resource.user}/#{@current_resource.service_name}").exist?
    @current_resource.exists = true
  end
end

def backup
  owner = "#{current_resource.user}"
  service_name = "#{current_resource.service_name}"
  app_dir = "/home/#{owner}/#{service_name}"
  data_dir = "#{current_resource.data_dir}"
  db_name = "#{current_resource.db_name}"
  db_user = "#{current_resource.db_user}"
  db_password = "#{current_resource.db_password}"
  version = "#{current_resource.version}"

  stable_backup "backup_stable_fisheye" do
    user owner
    service_name service_name
    version version
    db_name db_name
    db_user db_user
    db_pass db_password
    tomcat_container false
    paths [data_dir, app_dir]
  end
end

def prepare
  user = "#{current_resource.user}"
  data_dir = "#{current_resource.data_dir}"
  control_port = current_resource.control_port
  http_port = current_resource.port
  fisheye_license = "#{current_resource.license_text}"
  crusible_license = "#{current_resource.crucible_license_text}"
  git_bin_path = "#{current_resource.git_bin_path}"
  url = "#{current_resource.host}"
  smtp_host = "#{current_resource.smtp_host}"
  smtp_port = "#{current_resource.smtp_port}"
  smtp_user = "#{current_resource.smtp_user}"
  smtp_password = "#{current_resource.smtp_password}"
  crowd_url = "#{current_resource.crowd_url}"
  crowd_app_name = "#{current_resource.crowd_app_name}"
  crowd_app_password = "#{current_resource.crowd_app_password}"
  crowd_groups = current_resource.crowd_groups
  crowd_admin_group = "#{current_resource.crowd_admin_group}"
  repositories = current_resource.repositories
  db_name = "#{current_resource.db_name}"
  db_password = "#{current_resource.db_password}"
  db_user = "#{current_resource.db_user}"

  #if new installation than restore database
  if !(@current_resource.exists)
    execute "restore_database_to_fisheye" do
      command "
        mysql -u #{db_user} --password='#{db_password}' -b #{db_name} < #{current_resource.db_backup_path};
      "
      user user
      group user
      only_if { Pathname.new("#{current_resource.db_backup_path}").exist? }
    end
  end
  
  directory "#{data_dir}" do
    owner user
    group user
    recursive true
    notifies :run, "execute[#{current_resource.service_name}_restart]", :delayed
    end

  directory "#{data_dir}/lib" do
    owner user
    group user
    recursive true
    notifies :run, "execute[#{current_resource.service_name}_restart]", :delayed
  end

  #libraries copying always but notify restart server only if have change (need to update tomcat)
  mysql_connector "copy_mysql_connector_for_fisheye" do
    user user
    path "#{data_dir}/lib"
  end

  directory "#{data_dir}/data" do
    owner user
    group user
    recursive true
    notifies :run, "execute[#{current_resource.service_name}_restart]", :delayed
  end

  directory "#{data_dir}/data/auth" do
    owner user
    group user
    mode "700"
    recursive true
    notifies :run, "execute[#{current_resource.service_name}_restart]", :delayed
  end

  cookbook_file "#{data_dir}/data/auth/id_rsa" do
    owner user
    group user
    source "keys/#{user}/id_rsa"
    mode "600"
    only_if { Pathname.new("#{node[:jtalks][:cookbook_path]}/keys/#{user}/id_rsa").exist? }
    notifies :run, "execute[#{current_resource.service_name}_restart]", :delayed
  end

  template "#{data_dir}/config.xml" do
    source 'fisheye.config.xml.erb'
    mode '775'
    owner user
    group user
    variables({
                  :control_port => control_port,
                  :fisheye_license => fisheye_license,
                  :crusible_license => crusible_license,
                  :git_bin_path => git_bin_path,
                  :url => url,
                  :http_port => http_port,
                  :smtp_host => smtp_host,
                  :smtp_port => smtp_port,
                  :smtp_user => smtp_user,
                  :smtp_password => smtp_password,
                  :crowd_url => crowd_url,
                  :crowd_app_name => crowd_app_name,
                  :crowd_app_password => crowd_app_password,
                  :crowd_groups => crowd_groups,
                  :crowd_admin_group =>crowd_admin_group ,
                  :repositories => repositories,
                  :db_name => db_name,
                  :db_password => db_password,
                  :db_user => db_user
              })
    notifies :run, "execute[#{current_resource.service_name}_restart]", :delayed
  end
end

def configure
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  app_dir = "#{dir}/#{current_resource.service_name}"
  data_dir = "#{current_resource.data_dir}"

  jtalks_infra_replacer "add_fisheye_home_variable" do
    owner user
    group user
    file "#{app_dir}/bin/fisheyectl.sh"
    replace "FISHEYE_INST=$FISHEYE_HOME"
    with "FISHEYE_INST=\"#{data_dir}\""
    notifies :run, "execute[#{current_resource.service_name}_restart]", :delayed
  end
end

def install_or_update_fisheye
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  service_name = "#{current_resource.service_name}"
  app_dir = "#{dir}/#{service_name}"
  version = "#{current_resource.version}"

  template "#{node[:jtalks][:path][:init_script]}/#{service_name}" do
    source 'fisheye.service.erb'
    mode '775'
    owner user
    group user
    variables({
                  :dir => app_dir})
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  ark "#{service_name}-#{version}" do
    url current_resource.source_url
    path dir
    owner user
    action :put
    notifies :create, "link[create_link_to_fisheye]", :immediately
  end

  link "create_link_to_fisheye" do
    target_file "#{app_dir}"
    to "#{dir}/#{service_name}-#{version}"
    owner user
    group user
    action :nothing
  end

  service "#{service_name}" do
    supports :restart => true
    action :enable
  end

  restart_service service_name do
    user user
  end
end



