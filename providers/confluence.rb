require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do

  prepare

  backup

  install_or_update_confluence

  configure
end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraConfluence.new(@new_resource.name)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.version(@new_resource.version)
  @current_resource.source_url(@new_resource.source_url)
  @current_resource.user(@new_resource.user)
  @current_resource.data_dir(@new_resource.data_dir)
  @current_resource.port(@new_resource.port)
  @current_resource.control_port(@new_resource.control_port)
  @current_resource.jvm_opts(@new_resource.jvm_opts)
  @current_resource.crowd_url(@new_resource.crowd_url)
  @current_resource.crowd_app_name(@new_resource.crowd_app_name)
  @current_resource.crowd_app_password(@new_resource.crowd_app_password)
  @current_resource.db_name(@new_resource.db_name)
  @current_resource.db_user(@new_resource.db_user)
  @current_resource.db_password(@new_resource.db_password)
  @current_resource.license_text(@new_resource.license_text)
  @current_resource.db_backup_path(@new_resource.db_backup_path)
  @current_resource.host(@new_resource.host)
  @current_resource.build_number(@new_resource.build_number)
  @current_resource.java_home(@new_resource.java_home)

  if Pathname.new("/home/#{@new_resource.user}/#{@current_resource.service_name}").exist?
    @current_resource.exists = true
  end
end

def backup
  owner = "#{current_resource.user}"
  service_name = "#{current_resource.service_name}"
  app_dir = "/home/#{owner}/#{service_name}"
  data_dir = "#{current_resource.data_dir}"
  db_name = "#{current_resource.db_name}"
  db_user = "#{current_resource.db_user}"
  db_password = "#{current_resource.db_password}"
  version = "#{current_resource.version}"

  stable_backup "backup_stable_confluence" do
    user owner
    service_name service_name
    version version
    db_name db_name
    db_user db_user
    db_pass db_password
    tomcat_container false
    paths [data_dir, app_dir]
  end
end

def prepare
  user = "#{current_resource.user}"
  data_dir = "#{current_resource.data_dir}"
  db_name = "#{current_resource.db_name}"
  db_password = "#{current_resource.db_password}"
  db_user = "#{current_resource.db_user}"

  #if new installation than restore database
  if !(@current_resource.exists)
    execute "restore_database_to_confluence" do
      command "
        mysql -u #{db_user} --password='#{db_password}' -b #{db_name} < #{current_resource.db_backup_path};
      "
      user user
      group user
      only_if { Pathname.new("#{current_resource.db_backup_path}").exist? }
    end
  end

  directory "#{data_dir}" do
    owner user
    group user
    recursive true
    notifies :restart, "service[#{@current_resource.service_name}]", :delayed
  end

 end

def configure
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  app_dir = "#{dir}/#{current_resource.service_name}"
  data_dir = "#{current_resource.data_dir}"
  build_number = current_resource.build_number
  db_name = "#{current_resource.db_name}"
  db_password = "#{current_resource.db_password}"
  db_user = "#{current_resource.db_user}"
  control_port = current_resource.control_port
  port = current_resource.port
  jvm_opts = current_resource.jvm_opts
  license = "#{current_resource.license_text}"
  url = "#{current_resource.host}"
  crowd_url = "#{current_resource.crowd_url}"
  crowd_app_name = "#{current_resource.crowd_app_name}"
  crowd_app_password = "#{current_resource.crowd_app_password}"
  java_home = "#{current_resource.java_home}"

  template "#{data_dir}/confluence.cfg.xml" do
    source 'confluence.cfg.xml.erb'
    mode '644'
    owner user
    group user
    variables({
                  :build_number=> build_number,
                  :license_text=> license,
                  :db_name => db_name,
                  :db_user => db_user,
                  :db_password => db_password
              })
    notifies :restart, "service[#{@current_resource.service_name}]", :delayed
  end

  template "#{app_dir}/confluence/WEB-INF/classes/confluence-init.properties" do
    source 'confluence.init.properties.erb'
    mode '775'
    owner user
    group user
    variables({
                  :data_dir=> data_dir
              })
    notifies :restart, "service[#{@current_resource.service_name}]", :delayed
  end

  template "#{app_dir}/confluence/WEB-INF/classes/crowd.properties" do
    source 'confluence.crowd.properties.erb'
    mode '775'
    owner user
    group user
    variables({
                  :crowd_url => crowd_url,
                  :crowd_app_name => crowd_app_name,
                  :crowd_app_password => crowd_app_password
              })
    notifies :restart, "service[#{@current_resource.service_name}]", :delayed
  end

  template "#{app_dir}/conf/server.xml" do
    source 'confluence.server.xml.erb'
    mode '775'
    owner user
    group user
    variables({
                  :port => port,
                  :control_port => control_port
              })
    notifies :restart, "service[#{@current_resource.service_name}]", :delayed
  end

  template "#{app_dir}/bin/setenv.sh" do
    source 'confluence.setenv.sh.erb'
    mode '775'
    owner user
    group user
    variables({
                  :jvm_opts => jvm_opts,
                  :java_home => java_home
              })
    notifies :restart, "service[#{current_resource.service_name}]", :delayed
  end
end

def install_or_update_confluence
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  service_name = "#{current_resource.service_name}"
  app_dir = "#{dir}/#{service_name}"
  version = "#{current_resource.version}"
  data_dir = "#{current_resource.data_dir}"

  template "#{node[:jtalks][:path][:init_script]}/#{service_name}" do
    source 'confluence.service.erb'
    mode '775'
    owner user
    group user
    variables({
                  :dir => app_dir
              })
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  ark "#{service_name}-#{version}" do
    url current_resource.source_url
    path "#{dir}/backup"
    owner user
    action :put
    notifies :sto, "service[#{service_name}]", :immediately
    notifies :start, "service[#{service_name}]", :delayed
    notifies :run, "execute[replace_old_confluence]", :delayed
    not_if  { Pathname.new("#{dir}/backup/#{service_name}-#{version}").exist? }
  end

  execute "replace_old_confluence" do
    command "
        rm -Rf #{app_dir};
        cp -R #{dir}/backup/#{service_name}-#{version} #{app_dir} ;
        chown -R #{user}.#{user} #{app_dir};
        chown -R #{user}.#{user} #{data_dir};
            "
    action :nothing
  end

  #libraries copying always but notify restart server only if have change (need to update tomcat)
  mysql_connector "copy_mysql_connector_for_confluence" do
    user user
    path "#{app_dir}/confluence/WEB-INF/lib"
  end

  service "#{service_name}" do
    supports :restart => true
    action :enable
  end
end