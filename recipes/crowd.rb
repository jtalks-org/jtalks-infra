owner = node[:crowd][:user]
dir = "/home/#{owner}"

# Database
jtalks_database "crowd"

# Add user
user owner do
  shell '/bin/bash'
  action :create
  home dir
  supports :manage_home => true
end

group owner do
  action :create
end

directory "#{node[:atlassian][:home_dir]}" do
  owner owner
  group owner
end

directory "#{node[:atlassian][:home_dir]}/crowd" do
  owner owner
  group owner
end

# Install Tomcat
tomcat "crowd" do
  owner owner
  base dir
  port node[:tomcat][:instances][:crowd][:port]
  shutdown_port node[:tomcat][:instances][:crowd][:shutdown_port]
end

# Install Crowd
ark "external_crowd_libs" do
  url node[:crowd][:download_external_libs]
  path "/tmp"
  owner owner
  action :put
end

execute "cp activation-* jta-* mail-* #{dir}/crowd/lib; rm -Rf /tmp/external_crowd_libs" do
  cwd "/tmp/external_crowd_libs/apache-tomcat/lib"
  user owner
  group owner
end

remote_file "#{dir}/crowd/webapps/crowd.zip" do
  source node[:crowd][:download_url]
  owner owner
  group owner
end

execute "unpack and remove archive" do
  user owner
  group owner
  cwd "#{dir}/crowd/webapps"
  command "unzip crowd.zip -d #{dir}/crowd/webapps/crowd; rm -Rf crowd.zip"
end

file "#{dir}/crowd/webapps/crowd/WEB-INF/classes/crowd-init.properties" do
  owner params[:owner]
  group params[:owner_group]
  content "crowd.home=#{node[:atlassian][:home_dir]}/crowd"
end

service "crowd" do
  action :restart
end
