user = "root"
instances = node[:jtalks][:logs_instances_web]

directory "/logs" do
  owner user
  group user
end

directory "/logs/public" do
  owner user
  group user
end

instances.each do |instance|
  link "/home/i_#{instance}/instance/logs" do
    to "/logs/public/#{instance}"
    only_if { File.exists?("/home/i_#{instance}/instance/logs") }
  end
end