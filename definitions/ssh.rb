define :ssh, :user => 'root', :ssh_dir => '.ssh', :key_name => 'id_rsa', :cookbook_path => nil, :hostnames => [],
       :private_perm => '0600', :public_perm => '0754'  do

  directory "#{params[:ssh_dir]}" do
    owner params[:user]
    group params[:user]
    mode params[:public_perm]
    action :create
  end

  cookbook_file "#{params[:ssh_dir]}/#{params[:key_name]}" do
    owner params[:user]
    group params[:user]
    source "#{params[:cookbook_path]}/#{params[:key_name]}"
    mode params[:private_perm]
  end

  cookbook_file "#{params[:ssh_dir]}/#{params[:key_name]}.pub" do
    owner params[:user]
    group params[:user]
    source "#{params[:cookbook_path]}/#{params[:key_name]}.pub"
    mode params[:public_perm]
  end

  params[:hostnames].each do |hostname|
    ssh_util_config "#{hostname}" do
      options 'User' =>  "#{params[:user]}", 'IdentityFile' => "#{params[:ssh_dir]}/#{params[:key_name]}"
      user "#{params[:user]}"
    end

    ssh_util_known_hosts "#{hostname}" do
      hashed true
      user "#{params[:user]}"
    end
  end

  execute "chmod #{params[:public_perm]} #{params[:ssh_dir]}/config"

  # if user has same key, he has access to this server
  file "#{params[:ssh_dir]}/authorized_keys" do
    owner params[:user]
    group params[:user]
    mode params[:private_perm]
    action :create
  end
  execute "cat #{params[:ssh_dir]}/#{params[:key_name]}.pub >> #{params[:ssh_dir]}/authorized_keys"
end
