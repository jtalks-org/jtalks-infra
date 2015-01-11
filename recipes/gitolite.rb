user = node[:git][:user]
dir = "/home/#{user}"

git_user user do
  full_name user
  email "#{user}@jtalks.org"
end

execute "chown -R #{user}.#{user} #{dir}" do
  not_if {File.exists?("#{dir}/repositories") }
end

first_install = true
if File.exists?("#{dir}/repositories")
    first_install = false
end

if first_install
  directory "#{dir}/gitolite" do
    owner user
    group user
  end

  git "/tmp/gitolite" do
    repository node[:gitolite][:repository_url]
    reference "master"
    action :sync
    user user
  end

  execute "/tmp/gitolite/install -to #{dir}/gitolite" do
    user user
    group user
  end

  link "/bin/gitolite" do
    to "#{dir}/gitolite/gitolite"
    owner user
    group user
  end

  execute "cp #{dir}/.ssh/id_rsa.pub #{dir}/git.pub" do
    user user
    group user
  end

  execute  "gitolite setup -pk #{dir}/git.pub" do
    user user
    group user
    environment "HOME" => dir
  end

  execute "chown -R #{user}.#{user} #{dir}"

  execute  "rm -Rf /tmp/gitolite; rm -Rf #{dir}/git.pub"

end


