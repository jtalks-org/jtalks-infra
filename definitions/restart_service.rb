# create resource execute to restart service by {user}
define :restart_service, :user => 'root', :action => :nothing do

  execute "#{params[:name]}_restart" do
    command "su - #{params[:user]} -c 'service #{params[:name]} stop'; sudo pkill -f #{params[:name]}; su - #{params[:user]} -c 'service #{params[:name]} start'"
    action params[:action]
  end

end
