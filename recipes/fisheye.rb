jtalks_infra_fisheye "fisheye" do
  user node[:fisheye][:user]
  data_dir node[:fisheye][:home_dir]
  host node[:fisheye][:url]
  port node[:fisheye][:port]
  control_port node[:fisheye][:control_port]
  source_url node[:fisheye][:source_url]
  crowd_url node[:crowd][:app][:server_url]
  crowd_app_name node[:fisheye][:crowd][:application]
  crowd_app_password node[:fisheye][:crowd][:password]
  crowd_groups node[:fisheye][:crowd][:groups]
  crowd_admin_group node[:fisheye][:crowd][:admin_group]
  db_name node[:fisheye][:db][:name]
  db_user node[:fisheye][:db][:user]
  db_password node[:fisheye][:db][:password]
  db_backup_path node[:fisheye][:db][:backup_path]
  version node[:fisheye][:version]
  license_text node[:fisheye][:license_text]
  crucible_license_text node[:fisheye][:crucible_license_text]
  git_bin_path node[:fisheye][:git_bin_path]
  smtp_host node[:jtalks][:smtp][:host]
  smtp_port node[:jtalks][:smtp][:port]
  smtp_user node[:jtalks][:smtp][:users][:fisheye][:name]
  smtp_password node[:jtalks][:smtp][:users][:fisheye][:password]
  repositories node[:fisheye][:repositories]
  java_home "#{node[:java][:jdk]["8"][:home]}_alt"
end
