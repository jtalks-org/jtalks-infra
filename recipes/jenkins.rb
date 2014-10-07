owner = node[:jtalks][:jenkins][:user]
dir = "/home/#{owner}"

# Add user

user owner do
  shell '/bin/bash'
  action :create
  home dir
end

group owner do
  action :create
end

directory "#{dir}" do
  owner owner
  group owner
  action :create
end

ssh owner do
  user owner
  ssh_dir "#{dir}/.ssh"
  key_name "jtalks-infra"
  cookbook_path "private/keys/#{owner}"
  hostnames ["#{node[:jtalks][:backup][:jenkins][:hostname]}"]
end

# Install Tomcat

tomcat "jenkins" do
  owner owner
  base dir
  port node[:tomcat][:instances][:jenkins][:port]
  shutdown_port node[:tomcat][:instances][:jenkins][:shutdown_port]
end

# Install Jenkins
remote_file File.join("#{dir}/tomcat/webapps", 'jenkins.war') do
  source   node[:jenkins][:source_url]
  owner    owner
  group    owner
  notifies :restart, 'service[jenkins]'
end