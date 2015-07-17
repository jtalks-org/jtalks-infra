include_recipe 'java'

java_ark "oracle-jdk8-x86_64" do
  url node[:java][:jdk]["8"]["x86_64"][:url]
  app_home '/usr/lib/jvm/jdk1.8.0_51'
  default false
  alternatives_priority 1
  bin_cmds node[:java][:jdk]["8"][:bin_cmds]
  action :install
end