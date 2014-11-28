jtalks_infra_yandex_disk "yadisk" do
  user node[:yandex_idsk][:user]
  disk_dir node[:yandex_idsk][:dir]
  disk_login node[:yandex_idsk][:login]
  disk_password node[:yandex_idsk][:password]
  disk_repo_url node[:yandex_idsk][:repo][:url]
  disk_repo_components node[:yandex_idsk][:repo][:components]
  disk_repo_key node[:yandex_idsk][:repo][:key]
end
