define :tomcat, :owner => 'root', :base => '/home', :owner_group => nil, :port => 8080, :shutdown_port => 8001 do
  if params[:owner_group] == nil
    params[:owner_group] = params[:owner]
  end
  setenv_sh = "#{params[:base]}/tomcat/bin/setenv.sh"
  webapps = "#{params[:base]}/tomcat/webapps"

  result_folder_name = "apache-tomcat-#{node[:tomcat][:version]}"

  ark result_folder_name do
    url node[:tomcat][:download_url]
    path params[:base]
    owner params[:owner]
    action :put
  end
  execute "chown -R #{params[:owner]}.#{params[:owner_group]} #{result_folder_name}" do
    cwd params[:base]
  end
  execute "chmod -R 755 #{result_folder_name}" do
    cwd params[:base]
    user params[:owner]
  end
  execute "chmod u+x startup.sh catalina.sh shutdown.sh" do
    cwd "#{params[:base]}/#{result_folder_name}/bin"
    user params[:owner]
  end
  link "#{params[:base]}/tomcat" do
    to "#{params[:base]}/#{result_folder_name}"
    owner params[:owner]
    group params[:owner_group]
  end
  template "#{params[:base]}/tomcat/conf/server.xml" do
    source 'tomcat.server.xml.erb'
    mode '0644'
    owner params[:owner]
    group params[:owner_group]
    variables({
                  :port => params[:port],
                  :shutdown_port => params[:shutdown_port]})
  end
  template "#{node[:jtalks][:path][:init_script]}/#{params[:name]}" do
    source 'tomcat.service.erb'
    mode '775'
    variables({
                  :home_dir => "#{params[:base]}/tomcat",
                  :owner => params[:owner],
                  :owner_group => params[:owner_group]})
  end

  # create service
  service "#{params[:name]}" do
    supports :restart => true
    action :enable
  end

  execute "tomcat should use faster random generator" do
    command "echo 'CATALINA_OPTS=\"-Djava.security.egd=file:/dev/./urandom $CATALINA_OPTS\"' >> #{setenv_sh}"
    not_if { File.exist?(setenv_sh) }
  end
  %w[examples docs ROOT host-manager manager].each do |folder|
    directory "#{webapps}/#{folder}" do
      recursive true
      action :delete
    end
  end
end