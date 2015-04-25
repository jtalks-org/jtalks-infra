jtalks_infra_nexus "nexus" do
  user node[:nexus][:user]
  version node[:nexus][:version]
  port node[:nexus][:port]
  source_url node[:nexus][:source_url]
  admin_password node[:nexus][:admin_password]
  crowd_url node[:crowd][:app][:server_url]
  crowd_app_name node[:nexus][:crowd][:application]
  crowd_app_password node[:nexus][:crowd][:password]
  crowd_group node[:nexus][:crowd][:group]
  crowd_plugin_source_url node[:nexus][:crowd][:plugin][:source_url]
end