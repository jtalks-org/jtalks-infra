define :mysql_connector, :user => nil, :path => nil do
  ark "mysql_connector" do
    url "#{node[:mysql][:connector][:download_url]}"
    path "/tmp"
    owner params[:user]
    group params[:user]
    action :put
    not_if {File.exists?("/tmp/mysql_connector") }
  end

  execute "add_connector_to_tomcat" do
    command "cp mysql-connector*.jar #{params[:path]};"
    cwd "/tmp/mysql_connector"
    user params[:user]
    group params[:user]
  end
end