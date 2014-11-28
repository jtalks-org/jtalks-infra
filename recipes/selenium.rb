jtalks_infra_selenium "selenium" do
  source_url node[:selenium][:source_url]
  user node[:selenium][:user]
  version node[:selenium][:version]
end