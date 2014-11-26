# create resource execute to restart service by {user}
define :restart_service, :user => 'root', :ssh_dir => '.ssh', :key_name => 'id_rsa', :source_key_dir => nil do

  execute "#{params[:name]}_restart" do
    command "su - #{params[:user]} -c 'service #{params[:name]} restart'"
    action :nothing
  end

end
