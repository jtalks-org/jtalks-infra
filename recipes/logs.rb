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
  link "/logs/public/#{instance}" do
    to "/home/i_#{instance}/instance/logs"
    only_if { File.exists?("/home/i_#{instance}/instance/logs") }
  end
end