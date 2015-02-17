require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do

  install_or_update_pochta

  configure
end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraPochta.new(@new_resource.name)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.http_port(@new_resource.http_port)
  @current_resource.smtp_port(@new_resource.smtp_port)
  @current_resource.http_threads_count(@new_resource.http_threads_count)
  @current_resource.smtp_threads_count(@new_resource.smtp_threads_count)
  @current_resource.user(@new_resource.user)
  @current_resource.url_source(@new_resource.url_source)

  if Pathname.new("/home/#{@new_resource.user}/.pochta").exist?
    @current_resource.exists = true
  end
end

# Configure pochta
def configure
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  http_port = current_resource.http_port
  http_threads_count = current_resource.http_threads_count
  smtp_port = current_resource.smtp_port
  smtp_threads_count = current_resource.smtp_threads_count

  #if new installation than create config
  if !(@current_resource.exists)
    directory "#{dir}/#{current_resource.service_name}" do
      owner user
      group user
    end

    directory "#{dir}/.pochta" do
      owner user
      group user
    end

    directory "/var/run/#{current_resource.service_name}" do
      owner user
      group user
      mode '0775'
    end
  end

  template "#{dir}/.pochta/config.properties" do
    source 'pochta.config.properties.erb'
    owner user
    group user
    variables({
                  :http_port => http_port,
                  :http_threads_count => http_threads_count,
                  :smtp_port => smtp_port,
                  :smtp_threads_count => smtp_threads_count
              })
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end
end


def install_or_update_pochta
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  service_name = "#{current_resource.service_name}"
  bin_path = "#{dir}/#{service_name}/pochta.jar"

  directory "#{dir}/#{current_resource.service_name}" do
    owner user
    group user
    not_if {Pathname.new("#{dir}/#{service_name}").exist?}
  end

  template "#{node[:jtalks][:path][:init_script]}/#{service_name}" do
    source 'pochta.service.erb'
    mode '775'
    owner user
    group user
    variables({
                  :user => user,
                  :bin_path => bin_path,
                  :service_name => service_name})
    notifies :restart, "service[#{service_name}]", :delayed
  end

  service "#{service_name}" do
    supports :restart => true
    action :enable
  end

  remote_file "#{bin_path}" do
    source "#{current_resource.url_source}"
    owner user
    group user
    notifies :restart, "service[#{service_name}]", :delayed
  end

  service service_name do
    supports :restart => true
    action :enable
  end

end




