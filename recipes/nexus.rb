jtalks_infra_nexus "nexus" do
  user node[:nexus][:user]
  port node[:tomcat][:instances][:nexus][:port]
  shutdown_port node[:tomcat][:instances][:nexus][:shutdown_port]
  jvm_opts node[:tomcat][:instances][:nexus][:jvm_opts]
  source_url node[:nexus][:source_url]
  crowd_url node[:crowd][:app][:server_url]
  crowd_app_name node[:nexus][:crowd][:application]
  crowd_app_password node[:nexus][:crowd][:password]
  crowd_plugin_source_url node[:nexus][:crowd][:plugin][:source_url]
end