require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do

  prepare

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
  @current_resource.crowd_app_name(@new_resource.crowd_app_name)
  @current_resource.crowd_app_password(@new_resource.crowd_app_password)
  @current_resource.db_name(@new_resource.db_name)
  @current_resource.db_user(@new_resource.db_user)
  @current_resource.db_password(@new_resource.db_password)
  @current_resource.db_backup_path(@new_resource.db_backup_path)
  @current_resource.version(@new_resource.version)

  if Pathname.new("/home/#{@new_resource.user}/#{@current_resource.service_name}").exist?
    @current_resource.exists = true
  end
end

def prepare
  user = "#{current_resource.user}"
  data_dir = "#{current_resource.data_dir}"

  directory "#{data_dir}" do
    owner user
    group user
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

  #if new installation than restore database
  if !(@current_resource.exists)

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



