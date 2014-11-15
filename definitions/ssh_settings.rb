# Definition to setting SSH environment to user. Adds ssh keys from /files/default/keys/{username}/{key_name}.
# Tunes config file with mapping hostname to ssh key. Adds hash pair (hostname, key), to known_hosts file. Sets
# permissions to files of SSH environment.
define :ssh_settings, :user => 'root', :ssh_dir => '.ssh', :key_name => 'id_rsa', :source_key_dir => nil, :known_hosts => {} do
 
  private_perm = "0600"
  public_perm = "0754"
  
  directory "#{params[:ssh_dir]}" do
    owner params[:user]
    group params[:user]
    mode public_perm
    action :create
  end

  cookbook_file "#{params[:ssh_dir]}/#{params[:key_name]}" do
    owner params[:user]
    group params[:user]
    source "#{params[:source_key_dir]}/#{params[:key_name]}"
    mode private_perm
    only_if { File.exists?("#{node[:jtalks][:cookbook_path]}/#{params[:source_key_dir]}/#{params[:key_name]}") }
  end

  cookbook_file "#{params[:ssh_dir]}/#{params[:key_name]}.pub" do
    owner params[:user]
    group params[:user]
    source "#{params[:source_key_dir]}/#{params[:key_name]}.pub"
    mode public_perm
    only_if { File.exists?("#{node[:jtalks][:cookbook_path]}/#{params[:source_key_dir]}/#{params[:key_name]}.pub") }
  end

  ["config", "known_hosts"].each do |file|
    file "#{params[:ssh_dir]}/#{file}" do
      action :delete
    end
  end

  params[:known_hosts].each do |user, hostnames|
    hostnames.each do |hostname|
      ssh_util_config "#{hostname}" do
        options 'User' =>  "#{user}", 'IdentityFile' => "#{params[:ssh_dir]}/#{params[:key_name]}"
        user "#{params[:user]}"
      end

      ssh_util_known_hosts "#{hostname}" do
        hashed false
        user "#{params[:user]}"
      end
    end
  end

  execute "chmod #{public_perm} #{params[:ssh_dir]}/config" do
    only_if { File.exists?("#{params[:ssh_dir]}/config") }
  end

  # if user has same key, he has access to this server
  file "#{params[:ssh_dir]}/authorized_keys" do
    owner params[:user]
    group params[:user]
    mode private_perm
    action :create
  end

  execute "rm -Rf #{params[:ssh_dir]}/authorized_keys; cat #{params[:ssh_dir]}/#{params[:key_name]}.pub >>" +
          "#{params[:ssh_dir]}/authorized_keys" do
    user params[:user]
    group params[:user]
    only_if { File.exists?("#{params[:ssh_dir]}/#{params[:key_name]}.pub") }
  end

end
