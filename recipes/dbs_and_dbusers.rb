root_connection_info = {
    :host     => '127.0.0.1',
    :username => 'root',
    :password => node[:mysql][:server_root_password]
}

node[:jtalks][:dbs].each do |db|
  mysql_database db do
    connection root_connection_info
    encoding 'utf8'
    collation 'utf8_bin'
    action :create
  end
end

node[:jtalks][:db_users].each do |user, data|
   data[:dbs].each do |db_name, db_data|
     mysql_database_user user do
       connection root_connection_info
       password data[:password]
       database_name db_name
       privileges db_data[:privileges]
       host "%"
       action [:create, :grant]
     end
     mysql_database_user user do
       connection root_connection_info
       password data[:password]
       database_name db_name
       privileges db_data[:privileges]
       host "localhost"
       action [:create, :grant]
     end
   end
end