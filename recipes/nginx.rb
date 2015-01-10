require 'pathname'

directory node[:nginx][:default_root] do
  owner node[:nginx][:user]
  group node[:nginx][:group]
  mode '0755'
  recursive true
  action :create
end

perm = "0644"

file "/etc/nginx/conf.d/.htpasswd" do
    content "admin:G116jduV/0mwg"
    mode perm
    not_if {Pathname.new("/etc/nginx/conf.d/.htpasswd").exist?}
end

template "#{node[:nginx][:dir]}/locations_default.conf" do
  source 'nginx.default.conf.erb'
  owner node[:nginx][:user]
  group node[:nginx][:group]
 end

node[:nginx][:site].each do |site_attribute_node|
  site = site_attribute_node[0] #hash with values of attribute

  if node[:nginx][:site][site][:port]
    destination_port =  node[:nginx][:site][site][:port]
  else
    destination_port =  node[:tomcat][:instances][site][:port]
  end

  template "#{node[:nginx][:dir]}/sites-available/#{node[:nginx][:site][site][:name]}" do
    source 'nginx.site.conf.erb'
    owner node[:nginx][:user]
    group node[:nginx][:group]
    mode perm
    variables({
                  :destination_port => destination_port,
                  :name => node[:nginx][:site][site][:name],
                  :host => node[:nginx][:site][site][:host],
                  :context_path => node[:nginx][:site][site][:context_path]
              })
  end

  nginx_site node[:nginx][:site][site][:name] do
    enabled = true
  end

end

node[:jtalks][:nginx][:custom_configs].each do |site|

  cookbook_file "#{node[:nginx][:dir]}/sites-available/#{site}" do
    owner node[:nginx][:user]
    group node[:nginx][:user]
    source "nginx/#{site}"
    mode perm
    only_if { File.exists?("#{node[:jtalks][:cookbook_path]}/nginx/#{site}") }
  end

  nginx_site site do
    enabled = true
    only_if { File.exists?("#{node[:nginx][:dir]}/sites-available/#{site}") }
  end
end

service 'nginx' do
  action :restart
end