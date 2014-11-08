jtalks_infra_crowd "crowd" do
  version node[:crowd][:version]
  user node[:atlassian][:user][:name]
  data_dir node[:atlassian][:user][:home_dir]
  download_url node[:crowd][:download_url]
  db_config_name "crowd"
  db_backup_path node[:db][:crowd][:backup_path]
  tomcat_port node[:tomcat][:instances][:crowd][:port]
  tomcat_shutdown_port node[:tomcat][:instances][:crowd][:shutdown_port]
  tomcat_jvm_opts node[:tomcat][:instances][:crowd][:jvm_opts]
  mysql_connector_url node[:mysql][:connector][:download_url]
  app_conf_license_text node[:crowd][:app][:license_text]
  ext_libs_url node[:crowd][:download_external_libs]
  app_conf_name node[:crowd][:app][:name]
  app_conf_password node[:crowd][:app][:password]
  app_conf_url node[:crowd][:app][:server_url]
  app_conf_cookie_domain node[:crowd][:app][:cookie_domain]
  init_scripts_path node[:jtalks][:path][:init_script]
end