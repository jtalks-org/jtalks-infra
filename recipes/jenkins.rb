jtalks_infra_jenkins "jenkins" do
  version node[:jenkins][:version]
  user node[:jenkins][:user][:name]
  maven_backup_path node[:jenkins][:maven][:backup_path]
  tomcat_port node[:tomcat][:instances][:jenkins][:port]
  tomcat_shutdown_port node[:tomcat][:instances][:jenkins][:shutdown_port]
  tomcat_jvm_opts node[:tomcat][:instances][:jenkins][:jvm_opts]
  download_url node[:jenkins][:download_url]
  plugins_download_url node[:jenkins][:plugins_download_url]
  plugins_map node[:jenkins][:plugins]
  config_backup_path node[:jenkins][:config][:backup_path]
  crowd_url node[:crowd][:app][:server_url]
  crowd_app_name node[:jenkins][:crowd][:application]
  crowd_app_password node[:jenkins][:crowd][:password]
  crowd_group node[:jenkins][:crowd][:group]
  crowd_cookie_domain node[:crowd][:app][:cookie_domain]
  crowd_token node[:crowd][:app][:token]
end
