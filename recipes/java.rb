include_recipe 'java'

java_ark "oracle-jdk7-x86_64" do
  url node[:java][:jdk]["7"]["x86_64"][:url]
  app_home node[:java][:jdk]["7"][:home]
  default false
  alternatives_priority 1
  bin_cmds node[:java][:jdk]["7"][:bin_cmds]
  action :install
end