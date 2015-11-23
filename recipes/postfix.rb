jtalks_infra_postfix "postfix" do
  user node[:jtalks][:postfix][:user]
  uid node[:jtalks][:users]["#{node[:jtalks][:postfix][:user]}"][:uid]
  domain node[:jtalks][:postfix][:domain]
  postfixadmin_host  node[:jtalks][:postfixadmin][:host]
  postfixadmin_port  node[:jtalks][:postfixadmin][:port]
  postfixadmin_version  node[:jtalks][:postfixadmin][:version]
  postfixadmin_source_url  node[:jtalks][:postfixadmin][:source_url]
  postfixadmin_config node[:jtalks][:postfixadmin][:conf]
  db_host  node[:jtalks][:postfix][:database][:host]
  db_name node[:jtalks][:postfix][:database][:name]
  db_user  node[:jtalks][:postfix][:database][:user]
  db_password  node[:jtalks][:postfix][:database][:password]
  setup_password  node[:jtalks][:postfixadmin][:setup_password]
  admins node[:jtalks][:postfix][:admins]
  mailboxes  node[:jtalks][:postfix][:mailboxes]
  domains  node[:jtalks][:postfix][:domains]
  admin_username  node[:jtalks][:postfix][:admin][:username]
  opendkim_port  node[:jtalks][:opendkim][:port]
  opendkim_user  node[:jtalks][:opendkim][:user]
  opendkim_conf_dir  node[:jtalks][:opendkim][:conf_dir]
end




