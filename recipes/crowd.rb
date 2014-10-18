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
ark "mysql_connector" do
  url node[:mysql][:connector][:download_url]
  path "/tmp"
  owner owner
  group owner
  action :put
end

execute "cp mysql-connector*.jar #{dir}/crowd/lib; rm -Rf /tmp/mysql_connector" do
  cwd "/tmp/mysql_connector"
  user owner
  group owner
end

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
  command "unzip crowd.zip -d #{dir}/crowd/webapps/ROOT; rm -Rf crowd.zip"
end

# Restore configs

file "#{dir}/crowd/webapps/ROOT/WEB-INF/classes/crowd-init.properties" do
  owner params[:owner]
  group params[:owner_group]
  content "crowd.home=#{node[:atlassian][:home_dir]}/crowd"
end

template "#{node[:atlassian][:home_dir]}/crowd/crowd.cfg.xml" do
  source 'crowd.cfg.xml.erb'
  owner owner
  group owner
  variables({
                :db_name => node[:db][:crowd][:name],
                :db_user => node[:db][:crowd][:user],
                :db_password => node[:db][:crowd][:password],
                :license_text => node[:crowd][:app][:license_text]})
end

template "#{node[:atlassian][:home_dir]}/crowd/crowd.properties" do
  source 'crowd.properties.erb'
  owner owner
  group owner
  variables({
                :app_name => node[:crowd][:app][:name],
                :app_password => node[:crowd][:app][:password],
                :server_url => node[:crowd][:app][:server_url]})
end

# Restore database from backup
cookbook_file "/tmp/crowd.sql" do
  owner owner
  group owner
  source "#{node[:db][:crowd][:backup_path]}"
end

execute "restore database" do
  command "
  mysql -u #{node[:db][:crowd][:user]} --password='#{node[:db][:crowd][:password]}' -b #{node[:db][:crowd][:name]} < /tmp/crowd.sql;
  rm -Rf /tmp/crowd.sql
  "
  user owner
  group owner
end

service "crowd" do
  action :restart
end
