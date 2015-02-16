execute "iptables -F" do
  user "root"
  group "root"
end

node[:iptables][:rules].each do|rule|
  execute rule do
    user "root"
    group "root"
  end
end