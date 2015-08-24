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
  end

remote_file "/tmp/Oracle_VM_VirtualBox_Extension_Pack-#{node[:virtualbox][:guest_additions][:virtualbox_version]}.vbox-extpack" do
  source node[:virtualbox][:guest_additions][:ext_pack_uri]
  not_if { Pathname.new("/tmp/Oracle_VM_VirtualBox_Extension_Pack-#{node[:virtualbox][:guest_additions][:virtualbox_version]}.vbox-extpack").exist? }
end

# Create the mount point
directory node[:virtualbox][:guest_additions][:mount_point] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  not_if { Pathname.new("/tmp/vboxAdditions.iso").exist? }
end

# mount the iso
mount node[:virtualbox][:guest_additions][:mount_point] do
  action [:mount, :enable]
  device "/tmp/vboxAdditions.iso"
  fstype "iso9660"
  options "loop"
  only_if { Dir["#{node[:virtualbox][:guest_additions][:mount_point]}/*"].empty? }
end

# The VBoxLinuxAdditions script returns 1 even though it doesn't report any errors
# both in the output and in the logs. After running the script, the additions
# seem to be properly installed anyway... This is the best way to determine if
# there were any issues with the installation as this is probably a bug.
execute "install vbox guest additions" do
  command "! sh #{node[:virtualbox][:guest_additions][:mount_point]}}/VBoxLinuxAdditions.run | grep -E -i 'error|fail'"
end

# unmount the ISO
mount node[:virtualbox][:guest_additions][:mount_point] do
  action [:umount]
  device "/tmp/vboxAdditions.iso"
  mounted true
  enabled true
end

# install ext pack
execute "install vbox ext pack" do
  command "VBoxManage extpack install /tmp/Oracle_VM_VirtualBox_Extension_Pack-#{node[:virtualbox][:guest_additions][:virtualbox_version]}.vbox-extpack"
end

execute "vboxdrv kernel module" do
  command "sudo /etc/init.d/vboxdrv setup"
end

# # Delete the mount point
directory node[:virtualbox][:guest_additions][:mount_point] do
  action :delete
end
