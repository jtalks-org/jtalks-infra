jtalks_infra_yandex_disk "yadisk" do
  user node[:yandex_disk][:user]
  disk_dir node[:yandex_disk][:dir]
  disk_login node[:yandex_disk][:login]
  disk_password node[:yandex_disk][:password]
  disk_repo_url node[:yandex_disk][:repo][:url]
  disk_repo_components node[:yandex_disk][:repo][:components]
  disk_repo_key node[:yandex_disk][:repo][:key]
end
