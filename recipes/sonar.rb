jtalks_infra_sonar "sonar" do
  user node[:sonar][:user]
  port node[:sonar][:port]
  jvm_opts node[:sonar][:jvm_opts]
  source_url node[:sonar][:source_url]
  db_name node[:sonar][:db][:name]
  db_user node[:sonar][:db][:user]
  db_password node[:sonar][:db][:password]
  db_backup_path node[:sonar][:db][:backup_path]
  plugins_map node[:sonar][:plugins]
  crowd_url node[:crowd][:app][:server_url]
  crowd_app_name node[:sonar][:crowd][:application]
  crowd_app_password node[:sonar][:crowd][:password]
end