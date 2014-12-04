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
  @current_resource.crowd_url(@new_resource.crowd_url)
  @current_resource.crowd_app_name(@new_resource.crowd_app_name)
  @current_resource.crowd_app_password(@new_resource.crowd_app_password)
  @current_resource.crowd_plugin_source_url(@new_resource.crowd_plugin_source_url)

  if Pathname.new("/home/#{@new_resource.user}/#{@new_resource.service_name}/webapps/ROOT.war").exist?
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
  crowd_url = "#{current_resource.crowd_url}/"
  crowd_app_name = "#{current_resource.crowd_app_name}"
  crowd_app_password = "#{current_resource.crowd_app_password}"
  crowd_plugin_source_url = "#{current_resource.crowd_plugin_source_url}"

  remote_file "#{app_dir}/webapps/ROOT.war" do
    source "#{current_resource.source_url}"
    owner user
    group user
    notifies :run, "execute[remove_previous_nexus]", :immediately
    notifies :restart, "service[#{service_name}]", :delayed
  end

  #if new installation than start service to deploy (install plugins)
  if !(@current_resource.exists)
    service "#{service_name}" do
      action :restart
    end

    bash "install_nexus_wait_wait_3_minutes_after_start" do
      code  <<-EOH
        sleep 180
      EOH
      user user
      group user
    end

  end

  remote_file "#{dir}/sonatype-work/nexus/plugin-repository/crowd-plugin.zip" do
    source crowd_plugin_source_url
    owner user
    group user
    notifies :restart, "service[#{service_name}]", :delayed
    notifies :run, "execute[unpack_crowd_plugin_to_nexus]", :immediately
  end

  execute "unpack_crowd_plugin_to_nexus" do
    user user
    group user
    cwd "#{dir}/sonatype-work/nexus/plugin-repository"
    command "rm -Rf *crowd-plugin*; unzip crowd-plugin.zip; rm -Rf crowd-plugin.zip"
    action :nothing
  end

  template "#{dir}/sonatype-work/nexus/conf/crowd-plugin.xml" do
    source 'nexus.crowd.plugin.xml.erb'
    mode '775'
    owner user
    group user
    variables({
                  :crowd_url => crowd_url,
                  :crowd_app_name => crowd_app_name,
                  :crowd_app_password => crowd_app_password
              })
    notifies :restart, "service[#{service_name}]", :delayed
  end

  execute "remove_previous_nexus" do
    user user
    group user
    command "rm -Rf #{app_dir}/webapps/ROOT"
    action :nothing
  end

end




