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
  source_key_dir "keys/#{owner}"
  # *.hostname to all subdomains
  hostnames ["*.#{node[:jtalks][:hostname]}", "#{node[:jtalks][:hostname]}"]
end

# Install Maven

maven "maven" do
  owner owner
  base dir
  version "3"
  settings_path node[:jenkins][:maven][:backup_path]
end

# Install Tomcat

tomcat "jenkins" do
  owner owner
  base dir
  port node[:tomcat][:instances][:jenkins][:port]
  shutdown_port node[:tomcat][:instances][:jenkins][:shutdown_port]
end

# Install Jenkins

remote_file File.join("#{dir}/jenkins/webapps/ROOT.war") do
  source   node[:jenkins][:sources][:url]
  owner    owner
  group    owner
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

service "jenkins" do
  action :restart
end

#Configuration
bash "install_plugins_before_add_config_and_wait_2_minutes_after_start" do
code  <<-EOH
     wget -t 100 localhost:#{node[:tomcat][:instances][:jenkins][:port]}/jenkins;
     sleep 120
EOH
user owner
group owner
end


execute "restore-jenkins-config-and-jobs" do
  command "
    rm -Rf #{dir}/.jenkins/*.xml; rm -Rf #{dir}/.jenkins/jobs;
    cp -R #{node[:jenkins][:config][:backup_path]}/*.xml #{dir}/.jenkins;
    cp -R #{node[:jenkins][:config][:backup_path]}/*.key #{dir}/.jenkins;
    cp -R #{node[:jenkins][:config][:backup_path]}/jobs #{dir}/.jenkins;
    cp -R #{node[:jenkins][:config][:backup_path]}/secrets #{dir}/.jenkins;
    cp -R #{node[:jenkins][:config][:backup_path]}/users #{dir}/.jenkins;"
  user owner
  group owner
end

execute "chown -R #{owner}.#{owner} #{dir}/.jenkins"

# Replace configs
replace_config "replace repo path" do
  search_pattern "<securityRealm.*</cookieDomain>"
  replace_string "<securityRealm class=\"de.theit.jenkins.crowd.CrowdSecurityRealm\" plugin=\"crowd2@1.8\">
    <url>#{node[:crowd][:app][:server_url]}</url>
    <applicationName>#{node[:jenkins][:crowd][:application]}</applicationName>
    <password>#{node[:jenkins][:crowd][:password]}</password>
    <group>#{node[:jenkins][:crowd][:group]}</group>
    <nestedGroups>false</nestedGroups>
    <useSSO>true</useSSO>
    <sessionValidationInterval>2</sessionValidationInterval>
    <cookieDomain>#{node[:jenkins][:crowd][:cookie_domain]}</cookieDomain>"
  path "#{dir}/.jenkins/config.xml"
  user owner
end

service "jenkins" do
  action :restart
end
