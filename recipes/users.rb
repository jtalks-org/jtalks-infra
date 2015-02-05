node[:jtalks][:users].each do |user, data|
  user = user
  perm = "0770"
  if user == "root" then
    dir = "/root"
  else
    dir = "/home/#{user}"
  end

  password = node[:jtalks][:users][user][:password]
  uid = node[:jtalks][:users][user][:uid]
  system = data[:system] || false

  # Add user
  user user do
    shell '/bin/bash'
    password password
    action :create
    home dir
    system system
    uid uid
    supports :manage_home => true
  end

  group user do
    gid uid
    system system
  end

  directory dir do
    owner user
    group user
    mode perm
  end

  directory "#{dir}/backup" do
    owner user
    group user
  end

  ssh_settings user do
    user user
    ssh_dir "#{dir}/.ssh"
    key_name "id_rsa"
    source_key_dir "keys/#{user}"
  end
end

#create directories to QA command
user = "qa"
perm = "0755"

directory "/home/#{user}" do
  owner user
  group user
  recursive true
  mode perm
end

directory "/home/#{user}/.jtalks" do
  owner user
  group user
  mode perm
end

directory "/home/#{user}/.jtalks/plugins" do
  owner user
  group user
  mode perm
end

instances = ["preprod", "performance", "beginintesting", "dev", "qa"]

instances.each do | instance |
  directory "/home/#{user}/.jtalks/plugins/#{instance}" do
    owner user
    group user
    mode perm
  end
end
