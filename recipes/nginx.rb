directory node[:nginx][:default_root] do
  owner node[:nginx][:user]
  group node[:nginx][:group]
  mode '0755'
  recursive true
  action :create
end

perm = "0644"

node[:nginx][:site].each do |site_attribute_node|
  site = site_attribute_node[0] #hash with values of attribute

  template "#{node[:nginx][:dir]}/sites-available/#{node[:nginx][:site][site][:name]}" do
    source 'site.conf.erb'
    owner node[:nginx][:user]
    group node[:nginx][:group]
    mode perm
    variables({
                  :destination_port => node[:tomcat][:instances][site][:port],
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