jtalks_infra_nexus "nexus" do
  user node[:nexus][:user]
  port node[:tomcat][:instances][:nexus][:port]
  shutdown_port node[:tomcat][:instances][:nexus][:shutdown_port]
  jvm_opts node[:tomcat][:instances][:nexus][:jvm_opts]
  source_url node[:nexus][:source_url]
end