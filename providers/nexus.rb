require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do

  install_or_update_tomcat

  install_or_update_nexus

end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraNexus.new(@new_resource.name)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.source_url(@new_resource.source_url)
  @current_resource.user(@new_resource.user)
  @current_resource.port(@new_resource.port)
  @current_resource.shutdown_port(@new_resource.shutdown_port)
  @current_resource.jvm_opts(@new_resource.jvm_opts)

  if Pathname.new("/home/#{@new_resource.user}/#{@new_resource.service_name}").exist?
    @current_resource.exists = true
  end
end

def install_or_update_tomcat
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  service_name = "#{current_resource.service_name}"
  port = "#{current_resource.port}"
  shutdown_port = "#{current_resource.shutdown_port}"
  jvm_opts = "#{current_resource.jvm_opts}"

  tomcat "#{service_name}" do
    owner user
    base dir
    port port
    shutdown_port shutdown_port
    jvm_opts jvm_opts
  end

end

def install_or_update_nexus
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  service_name = "#{current_resource.service_name}"
  app_dir = "#{dir}/#{service_name}"

  remote_file "#{app_dir}/webapps/ROOT.war" do
    source "#{current_resource.source_url}"
    owner user
    group user
    notifies :run, "execute[remove_previous_nexus]", :immediately
    notifies :restart, "service[#{service_name}]", :delayed
  end

  execute "remove_previous_nexus" do
    user user
    group user
    command "rm -Rf #{app_dir}/webapps/ROOT"
    action :nothing
  end

end




