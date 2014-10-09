owner = node[:jenkins][:user]
dir = "/home/#{owner}"

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

ssh_settings owner do
  user owner
  ssh_dir "#{dir}/.ssh"
  key_name "jtalks-infra"
  source_key_dir "private/keys/#{owner}"
  # *.hostname to all subdomains
  hostnames ["*.#{node[:jtalks][:backup][:hostname]}", "#{node[:jtalks][:backup][:hostname]}"]
end

# Install Tomcat

tomcat "jenkins" do
  owner owner
  base dir
  port node[:tomcat][:instances][:jenkins][:port]
  shutdown_port node[:tomcat][:instances][:jenkins][:shutdown_port]
end

# Install Jenkins
remote_file File.join("#{dir}/tomcat/webapps/jenkins.war") do
  source   node[:jenkins][:sources][:url]
  owner    owner
  group    owner
  notifies :restart, 'service[jenkins]'
end

# Install plugins
# creates directory if jenkins not deploed yet
directory "#{dir}/.jenkins/plugins" do
  owner owner
  group owner
  recursive true
  not_if { File.exists?("#{dir}/.jenkins") }
end

execute "chown -R #{owner}.#{owner} #{dir}/.jenkins"

node[:jenkins][:plugins].each do |name, version|
  remote_file File.join("#{dir}/.jenkins/plugins/#{name}.hpi") do
    source   "#{node[:jenkins][:sources][:plugins_url]}/#{name}/#{version}/#{name}.hpi"
    owner    owner
    group    owner
    not_if { File.exists?("#{dir}/.jenkins/plugins/#{name}.hpi") }
  end
end

# Restore configs
git "#{dir}/#{node[:jenkins][:configs][:git][:repository_name]}" do
  user    owner
  group    owner
  repository node[:jenkins][:configs][:git][:source_url]
  revision node[:jenkins][:configs][:git][:branch]
end

execute "rm -Rf #{dir}/.jenkins/*.xml; rm -Rf #{dir}/.jenkins/jobs; mv * #{dir}/.jenkins;" do
  user owner
  group owner
  cwd "#{dir}/#{node[:jenkins][:configs][:git][:repository_name]}/jenkins-config"
end

execute "rm -Rf #{node[:jenkins][:configs][:git][:repository_name]}" do
  user owner
  group owner
  cwd dir
end

service "jenkins" do
  action :restart
end


