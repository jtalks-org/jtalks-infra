# to test need add real backup of jira database (files/default/jira/jira.sql)
jtalks_infra_jira "jira" do
  version node[:jira][:version]
  user node[:jira][:user]
  data_dir node[:jira][:home_dir]
  source_url node[:jira][:source_url]
  source_external_libs_url node[:jira][:source_external_libs_url]
  db_name node[:jira][:db][:name]
  db_user node[:jira][:db][:user]
  db_password node[:jira][:db][:password]
  db_backup_path node[:jira][:db][:backup_path]
  tomcat_port node[:tomcat][:instances][:jira][:port]
  tomcat_shutdown_port node[:tomcat][:instances][:jira][:shutdown_port]
  tomcat_jvm_opts node[:tomcat][:instances][:jira][:jvm_opts]
  license_text node[:jira][:license_text]
  crowd_url node[:crowd][:app][:server_url]
  crowd_app_name node[:jira][:crowd][:application]
  crowd_app_password node[:jira][:crowd][:password]
end
