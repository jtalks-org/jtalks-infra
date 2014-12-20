define :tomcat, :owner => 'root', :base => '/home', :owner_group => nil, :port => 8080, :shutdown_port => 8001,
 :jvm_opts => '-Xmx256m -XX:MaxPermSize=384m', :tomcat_major_v => '8' do
  if params[:owner_group] == nil
    params[:owner_group] = params[:owner]
  end

  setenv_sh = "#{params[:base]}/#{params[:name]}/bin/setenv.sh"
  webapps = "#{params[:base]}/#{params[:name]}/webapps"

  result_folder_name = "apache-tomcat-#{node[:tomcat][params[:tomcat_major_v]][:version]}"

  ark result_folder_name do
    url node[:tomcat][params[:tomcat_major_v]][:download_url]
    path params[:base]
    owner params[:owner]
    action :put
    not_if { File.exists?("#{params[:base]}/#{result_folder_name}") }
  end

  execute "#{params[:name]}_tomcat_chmod" do
    command "chmod u+x startup.sh catalina.sh shutdown.sh"
    cwd "#{params[:base]}/#{result_folder_name}/bin"
    user params[:owner]
  end

  link "#{params[:base]}/#{params[:name]}" do
    to "#{params[:base]}/#{result_folder_name}"
    owner params[:owner]
    group params[:owner_group]
  end

  template "#{params[:base]}/#{params[:name]}/conf/server.xml" do
    source 'tomcat.server.xml.erb'
    owner params[:owner]
    group params[:owner_group]
    variables({
                  :port => params[:port],
                  :shutdown_port => params[:shutdown_port]})
    notifies :restart, "service[#{params[:name]}]", :delayed
  end

  template "#{node[:jtalks][:path][:init_script]}/#{params[:name]}" do
    source 'tomcat.service.erb'
    mode '775'
    variables({
                  :service_name => params[:name],
                  :home_dir => "#{params[:base]}/#{params[:name]}",
                  :owner => params[:owner],
                  :owner_group => params[:owner_group],
                  :jvm_opts => params[:jvm_opts]})
    notifies :restart, "service[#{params[:name]}]", :delayed
  end

  # create service
  service "#{params[:name]}" do
    supports :restart => true, :status => true
    action :enable
  end

  execute "#{params[:name]} tomcat should use faster random generator" do
    command "echo 'CATALINA_OPTS=\"-Djava.security.egd=file:/dev/./urandom $CATALINA_OPTS\"' >> #{setenv_sh}"
    not_if { File.exist?(setenv_sh) }
  end
  %w[examples docs host-manager manager].each do |folder|
    directory "#{webapps}/#{folder}" do
      recursive true
      action :delete
    end
  end
end