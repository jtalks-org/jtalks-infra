require 'pathname'
require 'net/http'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do

  install_or_update_postfix

end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraPostfix.new(@new_resource.name)
  @current_resource.user(@new_resource.user)
  @current_resource.uid(@new_resource.uid)
  @current_resource.domain(@new_resource.domain)
  @current_resource.postfixadmin_host(@new_resource.postfixadmin_host)
  @current_resource.postfixadmin_port(@new_resource.postfixadmin_port)
  @current_resource.postfixadmin_version(@new_resource.postfixadmin_version)
  @current_resource.postfixadmin_source_url(@new_resource.postfixadmin_source_url)
  @current_resource.postfixadmin_config(@new_resource.postfixadmin_config)
  @current_resource.db_host(@new_resource.db_host)
  @current_resource.db_name(@new_resource.db_name)
  @current_resource.db_user(@new_resource.db_user)
  @current_resource.db_password(@new_resource.db_password)
  @current_resource.setup_password(@new_resource.setup_password)
  @current_resource.admins(@new_resource.admins)
  @current_resource.mailboxes(@new_resource.mailboxes)
  @current_resource.domains(@new_resource.domains)
  @current_resource.admin_username(@new_resource.admin_username)

  if Pathname.new("/home/#{@new_resource.user}/postfixadmin").exist?
    @current_resource.exists = true
  end
end


def install_or_update_postfix
  chef_gem 'sequel'

  user = current_resource.user
  dir = "/home/#{user}"
  uid = current_resource.uid
  domain = current_resource.domain
  host = current_resource.postfixadmin_host
  port = current_resource.postfixadmin_port
  postfixadmin_version = current_resource.postfixadmin_version
  postfixadmin_source_url = current_resource.postfixadmin_source_url
  postfixadmin_config = current_resource.postfixadmin_config
  db_host = current_resource.db_host
  db_name = current_resource.db_name
  db_user = current_resource.db_user
  db_password = current_resource.db_password
  admins = current_resource.admins
  mailboxes = current_resource.mailboxes
  domains = current_resource.domains
  setup_password = current_resource.setup_password
  admin_username = current_resource.admin_username
  mail_dir = "#{dir}/mailbox"

  directory mail_dir do
    owner user
    group user
    not_if { Pathname.new("#{mail_dir}").exist? }
  end

  @db = PostfixAdmin::DB.new(db_user, db_password, db_name, db_host, "3306")

  if !(@current_resource.exists)
    execute "apt-get install -y  php5-fpm php5-imap php5-mysql php5-mcrypt php5-intl"
    execute "php5enmod imap"
  end

  #create php socket
  file "/etc/php5/fpm/pool.d/www.conf" do
    action :delete
    only_if {Pathname.new("/etc/php5/fpm/pool.d/www.conf").exist?}
  end

  template "/etc/php5/fpm/pool.d/postfix.conf" do
    source 'postfix.sock.conf.erb'
    variables({
                  :user=> user,
                  :group=> user
              })
  end

  template "#{node[:jtalks][:path][:init_script]}/php5-fpm" do
    source 'php.fpm.service.erb'
    mode '775'
  end

  #install postfixadmin
  ark "postfixadmin-#{postfixadmin_version}" do
    url  postfixadmin_source_url
    path dir
    owner user
    action :put
    not_if {Pathname.new("#{dir}/postfixadmin-#{postfixadmin_version}").exist?}
    notifies :create, "link[#{dir}/postfixadmin]", :immediately
  end

  link "#{dir}/postfixadmin" do
    to "#{dir}/postfixadmin-#{postfixadmin_version}"
    owner user
    group user
    action :nothing
  end

  if !(@current_resource.exists)
    jtalks_infra_replacer "replace_host_in_postfixadmin_config" do
      owner user
      group user
      file "#{dir}/postfixadmin/config.inc.php"
      replace "change-this-to-your.domain.tld"
      with "#{domain}"
    end
  end

  template "#{dir}/postfixadmin/config.local.php" do
    source 'postfixadmin.config.local.php.erb'
    variables({
                  :config=> postfixadmin_config
              })
  end

  service "php5-fpm" do
    supports :restart => true
    action [:enable, :restart]
  end

  service "nginx" do
    supports :restart => true
    action [:enable, :restart]
  end

  # generate mysql structure to postfixadmin
  ruby_block "setup_postfix_admin" do
    block do
      uri = URI("http://#{host}:#{port}/setup.php")
      Net::HTTP.get(uri)
    end
    action :run
    only_if {Pathname.new("#{dir}/postfixadmin/setup.php").exist?}
  end

  # install postfix
  bash "install_postfix" do
    code "debconf-set-selections <<< \"postfix postfix/mailname string #{domain}\";
        debconf-set-selections <<< \"postfix postfix/main_mailer_type string 'Internet Site'\";
        apt-get install -y postfix postfix-mysql"
  end

  template "/etc/postfix/main.cf" do
    source "postfix.main.cf.erb"
    variables({
                  :host=> domain,
                  :uid=> uid,
                  :mail_dir=> mail_dir
              })
  end

  template "/etc/postfix/mysql_virtual_mailbox_domains.cf" do
    source "postfix.mysql_virtual_mailbox_domains.cf.erb"
    variables({
                  :db_host=> db_host,
                  :db_name=> db_name,
                  :db_user=> db_user,
                  :db_password=> db_password
              })
  end

  template "/etc/postfix/mysql_virtual_mailbox_maps.cf" do
    source "postfix.mysql_virtual_mailbox_maps.cf.erb"
    variables({
                  :db_host=> db_host,
                  :db_name=> db_name,
                  :db_user=> db_user,
                  :db_password=> db_password
              })
  end

  template "/etc/postfix/mysql_virtual_alias_maps.cf" do
    source "postfix.mysql_virtual_alias_maps.cf.erb"
    variables({
                  :db_host=> db_host,
                  :db_name=> db_name,
                  :db_user=> db_user,
                  :db_password=> db_password
              })
  end

  template "/etc/postfix/mysql_relay_domains.cf" do
    source "postfix.mysql_relay_domains.cf.erb"
    variables({
                  :db_host=> db_host,
                  :db_name=> db_name,
                  :db_user=> db_user,
                  :db_password=> db_password
              })
  end

  # install dovecot
  bash "install_dovecot" do
    code "debconf-set-selections <<< \"dovecot dovecot-core/create-ssl-cert boolean false\";
        apt-get install -y dovecot-imapd dovecot-pop3d dovecot-mysql dovecot-lmtpd"
  end

  template "/etc/dovecot/dovecot-mysql.conf.ext" do
    source "dovecot.mysql.conf.ext.erb"
    variables({
                  :db_host=> db_host,
                  :db_name=> db_name,
                  :db_user=> db_user,
                  :db_password=> db_password,
                  :mail_dir=>  mail_dir,
                  :uid=> uid
              })
  end

  template "/etc/dovecot/conf.d/10-auth.conf" do
    source "dovecot.auth.conf.erb"
  end

  template "/etc/dovecot/conf.d/10-mail.conf" do
    source "dovecot.mail.conf.erb"
    variables({
                  :mail_dir=>mail_dir
              })
  end

  template "/etc/dovecot/conf.d/10-ssl.conf" do
    source "dovecot.ssl.conf.erb"
  end

  template "/etc/dovecot/conf.d/20-imap.conf" do
    source "dovecot.imap.conf.erb"
  end

  template "/etc/dovecot/conf.d/20-imap.conf" do
    source "dovecot.imap.conf.erb"
  end

  template "/etc/dovecot/conf.d/auth-sql.conf.ext" do
    source "dovecot.auth.sql.conf.erb"
  end

  template "/etc/dovecot/conf.d/10-master.conf" do
    source "dovecot.master.conf.erb"
  end

  service "dovecot" do
    supports :restart => true
    action [:enable, :restart]
  end

  service "postfix" do
    supports :restart => true
    action [:enable, :restart]
  end

  #create admins
  http = Net::HTTP.new(host, port)

  admins.each do |name, data|
      username = "#{name}@#{data[:domain]}"
      unless @db.admin_exist?(username)
        ruby_block "create_admin_#{username}" do
          block do
            uri = URI("http://#{host}:#{port}/setup.php")
            request = Net::HTTP::Post.new(uri)
            request.set_form_data({"form" =>"createadmin", "setup_password" => setup_password,
                                   "username"=> username, "password" => data[:password],
                                   "password2"=>data[:password], "submit"=>"Add+Admin"})
            Chef::Log.info("request_body: " + request.body)
            response = http.request(request)
            Chef::Log.info("response_body: " + response.body)
          end
          action :run
          only_if {Pathname.new("#{dir}/postfixadmin/setup.php").exist?}
        end
      end
  end

  cookie = nil

  ruby_block "login_#{admin_username}" do
    username = "#{admin_username}@#{node[:jtalks][:postfix][:admins][admin_username][:domain]}"
    block do
      uri = URI("http://#{host}:#{port}/login.php")
      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = "application/x-www-form-urlencoded"
      request.set_form_data({"fUsername" => username , "fPassword" => "#{node[:jtalks][:postfix][:admins][admin_username][:password]}",
                            "lang"=> "en",  "submit"=>"Login"})
      Chef::Log.info(request.body)
       response = http.request(request)
      Chef::Log.info(response.body)
      if response['Set-Cookie'].is_a?(String)
        cookie = response['set-cookie'].split(';')[0]
      end
    end
    action :run
  end

  #create domains
  domains.each do |name, data|
     unless @db.domain_exist?(data[:name])
       ruby_block "create_domain_#{data[:name]}" do
         block do
           uri = URI("http://#{host}:#{port}/edit.php?table=domain")
           request = Net::HTTP::Post.new(uri)
           request['Cookie'] = cookie
           request['Content-Type'] = "application/x-www-form-urlencoded"
           request.set_form_data({"table" => "domain","value[domain]" =>data[:name], "value[description]" => data[:description],
                                     "value[aliases]"=> 0, "value[mailboxes]" => 0, "value[quota]" => 0,"value[active]" => 1,
                                     "value[default_aliases]" => 1, "submit"=>"Add+Domain"})
           response = http.request(request)
           Chef::Log.info(response.body)
         end
         action :run
       end
     end
  end

  #create mailboxes and aliases
  mailboxes.each do |name, data|
    username = "#{name}@#{data[:domain]}"
    unless @db.mailbox_exist?(username)
      ruby_block "create_mailbox_and_aliases_#{username}" do
        block do
          uri = URI("http://#{host}:#{port}/edit.php?table=mailbox")
          request = Net::HTTP::Post.new(uri)
          request['Cookie'] = cookie
          request['Content-Type'] = "application/x-www-form-urlencoded"
          request.set_form_data({"table" => "mailbox", "value[local_part]" => name,"value[domain]" =>data[:domain], "value[password]" => data[:password],
                                "value[password2]" => data[:password], "value[name]" => name, "value[quota]" => 0, "value[active]" => 1, "value[welcome_mail]" => 0,
                                "submit"=>"Add+Mailbox"})
          response = http.request(request)
          Chef::Log.info(response.body)

          if data[:aliases]
            goto = data[:aliases].join("\r\n")
            uri = URI("http://#{host}:#{port}/edit.php?table=alias&edit=#{username}")
            request = Net::HTTP::Post.new(uri)
            request['Cookie'] = cookie
            request['Content-Type'] = "application/x-www-form-urlencoded"
            request.set_form_data({"table" => "alias", "value[goto]" => goto,"value[goto_mailbox]" =>1, "value[active]" => 1, "submit"=>"Save changes"})
            response = http.request(request)
            Chef::Log.info(response.body)
          end
        end
        action :run
      end
    end
  end

  execute "postfixadmin_remove_setup_script" do
    command "rm -Rf setup.php"
    cwd "#{dir}/postfixadmin"
    user user
    group user
    only_if {Pathname.new("#{dir}/postfixadmin/setup.php").exist?}
  end
end