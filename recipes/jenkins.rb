owner = node[:jtalks][:jenkins][:user]
dir = "/home/#{owner}"

user owner do
  shell '/bin/bash'
  action :create
  home dir
end

group owner do
  action :create
end

directory dir do
  owner owner
  mode 00700
  action :create
end

tomcat "jenkins" do
  owner owner
  base dir
  port node[:tomcat][:instances][:jenkins][:port]
  shutdown_port node[:tomcat][:instances][:jenkins][:shutdown_port]
end
