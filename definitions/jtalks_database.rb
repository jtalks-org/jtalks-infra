define :jtalks_database do
  app_name = params[:name]
  root_connection_info = {
      :host     => '127.0.0.1',
      :username => 'root',
      :password => node[:mysql][:server_root_password]
  }

  mysql_database node[:db][app_name][:name] do
    connection root_connection_info
    encoding 'utf8'
    action :create
  end

  mysql_database_user node[:db][app_name][:user] do
    connection root_connection_info
    password node[:db][app_name][:password]
    database_name node[:db][app_name][:name]
    privileges [:all]
    host '%'
    action [:drop, :create, :grant]
  end
end