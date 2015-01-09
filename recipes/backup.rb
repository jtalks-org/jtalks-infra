require 'pathname'

user = "root"
backup_dir = "/root/backup"
exclude_dirs = "#{node[:jtalks][:backup][:exclude_dirs]}"
ftp = "#{node[:jtalks][:backup][:ftp]}"
server_name = "#{node[:jtalks][:hostname]}"
mysql_root_password = "#{node[:mysql][:server_root_password]}"

package "mailx"

directory "#{backup_dir}" do
  owner user
  group user
  not_if { Pathname.new("#{backup_dir}").exist? }
end

template "/root/backup.sh" do
  source 'backup.sh.erb'
  owner user
  group user
  variables({
                :backup_dir => backup_dir,
                :exclude_dirs => exclude_dirs,
                :ftp => ftp,
                :server_name => server_name,
                :mysql_root_password => mysql_root_password
            })
end

cron_d 'backup_server' do
  minute  0
  hour    1
  command "bash -xv /root/backup.sh 2>&1 > /root/backup.log"
  user    user
end