user = node[:git][:user]
dir = "/home/#{user}"

execute "chown -R #{user}.#{user} #{dir}" do
  not_if {File.exists?("#{dir}/repositories") }
end

directory "#{dir}/gitolite" do
  owner user
  group user
  not_if {File.exists?("#{dir}/repositories") }
end

git "/tmp/gitolite" do
  repository node[:gitolite][:repository_url]
  reference "master"
  action :sync
  user user
  not_if {File.exists?("#{dir}/repositories") }
end

execute "/tmp/gitolite/install -to #{dir}/gitolite" do
  user user
  group user
  environment "HOME" => dir
  not_if {File.exists?("#{dir}/repositories") }
end

link "/bin/gitolite" do
  to "#{dir}/gitolite/gitolite"
  owner user
  group user
  not_if {File.exists?("/bin/gitolite") }
end

execute "cp #{dir}/.ssh/id_rsa.pub #{dir}/.ssh/git.pub" do
  user user
  group user
  not_if {File.exists?("#{dir}/repositories") }
end

# execute "sudo -u  #{user} '#{git_server_home}/gitolite/gitolite setup -pk #{dir}/.ssh/id_rsa.pub'" do
execute  "#{dir}/gitolite/gitolite setup -pk #{dir}/.ssh/git.pub" do
  user user
  group user
  environment "HOME" => dir
  not_if {File.exists?("#{dir}/repositories") }
end

execute  "rm -Rf /tmp/gitolite; rm -Rf #{dir}/.ssh/git.pub" do
  only_if {File.exists?("#{dir}/tmp") }
end
