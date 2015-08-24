require 'pathname'

include_recipe 'virtualbox'

# Install dependencies
node[:virtualbox][:guest_additions][:packages].each do |p|
  package p do
    action :install
  end
end

# Get additions iso file
remote_file "/tmp/vboxAdditions.iso" do
  source node[:virtualbox][:guest_additions][:iso_uri]
  not_if { Pathname.new("/tmp/vboxAdditions.iso").exist? }
  notifies :create, "directory[#{node[:virtualbox][:guest_additions][:mount_point]}]", :immediately
  end

remote_file "/tmp/Oracle_VM_VirtualBox_Extension_Pack-#{node[:virtualbox][:guest_additions][:virtualbox_version]}.vbox-extpack" do
  source node[:virtualbox][:guest_additions][:ext_pack_uri]
  not_if { Pathname.new("/tmp/Oracle_VM_VirtualBox_Extension_Pack-#{node[:virtualbox][:guest_additions][:virtualbox_version]}.vbox-extpack").exist? }
  notifies :run, "execute[install_vbox_ext_pack]", :immediately
end

# Create the mount point
directory node[:virtualbox][:guest_additions][:mount_point] do
  owner "root"
  group "root"
  mode "0755"
  action :nothing
  notifies :mount, "mount[#{node[:virtualbox][:guest_additions][:mount_point]}]", :immediately
  notifies :enable, "mount[#{node[:virtualbox][:guest_additions][:mount_point]}]", :immediately
end

# mount the iso
mount node[:virtualbox][:guest_additions][:mount_point] do
  action :nothing
  device "/tmp/vboxAdditions.iso"
  fstype "iso9660"
  options "loop"
  notifies :run, "execute[install_vbox_guest_additions]", :immediately
  only_if { Dir["#{node[:virtualbox][:guest_additions][:mount_point]}/*"].empty? }
end

# The VBoxLinuxAdditions script returns 1 even though it doesn't report any errors
# both in the output and in the logs. After running the script, the additions
# seem to be properly installed anyway... This is the best way to determine if
# there were any issues with the installation as this is probably a bug.
execute "install_vbox_guest_additions" do
  command "! sh #{node[:virtualbox][:guest_additions][:mount_point]}}/VBoxLinuxAdditions.run | grep -E -i 'error|fail'"
  action :nothing
  notifies :umount, "mount[#{node[:virtualbox][:guest_additions][:mount_point]}]", :immediately
  notifies :run, "execute[vboxdrv_kernel_module]", :immediately
end

# unmount the ISO
mount node[:virtualbox][:guest_additions][:mount_point] do
  action :nothing
  device "/tmp/vboxAdditions.iso"
  mounted true
  enabled true
  notifies :delete, "directory[#{node[:virtualbox][:guest_additions][:mount_point]}]", :delayed
end

# install ext pack
execute "install_vbox_ext_pack" do
  command "VBoxManage extpack install /tmp/Oracle_VM_VirtualBox_Extension_Pack-#{node[:virtualbox][:guest_additions][:virtualbox_version]}.vbox-extpack"
  action :nothing
end

execute "vboxdrv_kernel_module" do
  action :nothing
  command "sudo /etc/init.d/vboxdrv setup"
end

# # Delete the mount point
directory node[:virtualbox][:guest_additions][:mount_point] do
  action :nothing
end
