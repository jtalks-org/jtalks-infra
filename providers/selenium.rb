require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do

  install_or_update_selenium

end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraSelenium.new(@new_resource.name)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.source_url(@new_resource.source_url)
  @current_resource.user(@new_resource.user)
  @current_resource.version(@new_resource.version)

  if Pathname.new("/home/#{@new_resource.user}/#{@new_resource.service_name}").exist?
    @current_resource.exists = true
  end
end

def install_or_update_selenium
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  service_name = "#{current_resource.service_name}"
  bin_path = "#{dir}/#{current_resource.service_name}/selenium-server-standalone-#{current_resource.version}.jar"

  directory "#{dir}/#{current_resource.service_name}" do
    owner user
    group user
    not_if {Pathname.new("#{dir}/#{service_name}").exist?}
  end

  template "#{node[:jtalks][:path][:init_script]}/#{service_name}" do
    source 'selenium.service.erb'
    mode '775'
    owner user
    group user
    variables({
                  :dir => "#{dir}/#{service_name}",
                  :bin_path => "#{bin_path}"})
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  service "#{service_name}" do
    supports :restart => true
    action :enable
  end

  remote_file "#{bin_path}" do
    source "#{current_resource.source_url}"
    owner user
    group user
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  restart_service service_name do
    user user
  end

end




