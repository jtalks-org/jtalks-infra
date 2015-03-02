jtalks_infra_pochta "pochta" do
  version node[:pochta][:version]
  http_port node[:pochta][:http][:port]
  smtp_port node[:pochta][:smtp][:port]
  http_threads_count node[:pochta][:http][:threads_count]
  smtp_threads_count node[:pochta][:smtp][:threads_count]
  user node[:pochta][:user]
  url_source node[:pochta][:source_url]
end