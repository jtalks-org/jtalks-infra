node[:iptables][:rules].each do|rule|
  execute rule do
    user "root"
    group "root"
  end
end