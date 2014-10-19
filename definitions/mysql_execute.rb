define :mysql_execute, :app_name => nil, :command => '' do

  command = "mysql -u #{node[:db][params[:app_name]][:user]} --password='#{node[:db][params[:app_name]][:password]}' -D #{node[:db][params[:app_name]][:name]} -e \"#{params[:command]}\""

  execute "execute_mysql_command_to_application_#{params[:app_name]}" do
    command command
  end
end
