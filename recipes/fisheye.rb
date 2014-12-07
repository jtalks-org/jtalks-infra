jtalks_infra_fisheye "fisheye" do
  user node[:fisheye][:user]
  data_dir node[:fisheye][:home_dir]
  port node[:fisheye][:port]
  source_url node[:fisheye][:source_url]
  crowd_app_name node[:fisheye][:crowd][:application]
  crowd_app_password node[:fisheye][:crowd][:password]
  db_name node[:fisheye][:db][:name]
  db_user node[:fisheye][:db][:user]
  db_password node[:fisheye][:db][:password]
  db_backup_path node[:fisheye][:db][:backup_path]
  version node[:fisheye][:version]
end