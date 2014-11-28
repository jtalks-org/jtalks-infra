require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do

  prepare

  install_or_update_yandex_disk

  configure

end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraYandexDisk.new(@new_resource.name)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.user(@new_resource.user)
  @current_resource.disk_dir(@new_resource.disk_dir)
  @current_resource.disk_login(@new_resource.disk_login)
  @current_resource.disk_password(@new_resource.disk_password)
  @current_resource.disk_repo_url(@new_resource.disk_repo_url)
  @current_resource.disk_repo_components(@new_resource.disk_repo_components)
  @current_resource.disk_repo_key(@new_resource.disk_repo_key)

  if Pathname.new("/home/#{@new_resource.user}/.config/#{current_resource.service_name}").exist?
    @current_resource.exists = true
  end
end

def prepare
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  #if new installation than add repository
  if !(@current_resource.exists)
    apt_repository "yandex-disk" do
      uri        "#{current_resource.disk_repo_url}"
      components current_resource.disk_repo_components
      key        "#{current_resource.disk_repo_key}"
    end
  end

  directory "#{current_resource.disk_dir}" do
    owner user
    group user
    recursive true
  end

  directory "#{dir}/.config" do
    owner user
    group user
    recursive true
  end

end

# Configure yandex disk
def configure
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  service_name = "#{current_resource.service_name}"
  auth_file = "#{dir}/.config/#{service_name}_auth"
  disk_dir = "#{current_resource.disk_dir}"

  if !(@current_resource.exists)
    execute "yandex-disk token --password='#{current_resource.disk_password}' '#{current_resource.disk_login}' #{auth_file}"
    execute "chown #{user}.#{user} #{auth_file}"
  end

  template "#{dir}/.config/#{service_name}" do
    source 'yadisk.config.erb'
    mode '775'
    owner user
    group user
    variables({
                  :dir => "#{disk_dir}",
                  :auth_file => auth_file})
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end
end


def install_or_update_yandex_disk
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  service_name = "#{current_resource.service_name}"

  package "yandex-disk"

  template "#{node[:jtalks][:path][:init_script]}/#{service_name}" do
    source 'yadisk.service.erb'
    mode '775'
    owner user
    group user
    variables({
                   :config => "#{dir}/.config/#{service_name}"})
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  service "#{service_name}" do
    supports :restart => true
    action :enable
  end

  restart_service service_name do
    user user
  end

end




