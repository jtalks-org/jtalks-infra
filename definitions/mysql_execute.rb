define :mysql_execute, :user => nil, :password => nil, :db => nil, :command => '' do

  command = "mysql -u #{params[:user]} --password='#{params[:password]}' -D #{params[:db]} -e \"#{params[:command]}\""

  execute "execute_mysql_command_to_db_#{params[:db]}" do
    command command
  end
end
