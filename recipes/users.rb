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

# add to additional groups
node[:jtalks][:users].each do |user, data|
  additional_groups = data[:additional_groups] || nil
  if additional_groups then
    additional_groups.each do |group|
      group group do
        append true
        members [user]
        action :manage
      end
    end
  end
end

#additional users
sudo "mixas" do
  user      "mixas"
  runas     "i_dev"
end

#create directories to QA command
user = "qa"
perm = "0755"
full_perm = "0777"

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

instances = ["preprod", "performance", "autotests", "beginintesting", "dev", "qa"]

instances.each do | instance |
  directory "/home/#{user}/.jtalks/plugins/#{instance}" do
    owner user
    group user
    mode full_perm
    recursive true
  end
end
