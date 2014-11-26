# create resource execute to restart service by {user}
define :restart_service, :user => 'root' do

  execute "#{params[:name]}_restart" do
    command "su - #{params[:user]} -c 'service #{params[:name]} restart'"
    action :nothing
  end

end
