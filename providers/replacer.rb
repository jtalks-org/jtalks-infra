require 'chef/mixin/checksum'
require 'chef/mixin/shell_out'

include Chef::Mixin::Checksum
include Chef::Mixin::ShellOut

def whyrun_supported?
  true
end

use_inline_resources

action :run do
    replace
end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraReplacer.new(@new_resource.name)
  @current_resource.checksum(checksum(@new_resource.file))
  @current_resource.owner(@new_resource.owner)
  @current_resource.group(@new_resource.group)
  @current_resource.file(@new_resource.file)
  @current_resource.replace(@new_resource.replace)
  @current_resource.with(@new_resource.with)
end

def replace
  new_line="<new_line_chef>"
  replace="#{current_resource.replace}".gsub(/\//, "\\/").gsub(/\"/, "\\\"")
  with="#{current_resource.with}".gsub(/\//, "\\/").gsub(/\"/, "\\\"").gsub(/\n/, "#{new_line}")

  shell_out("sed -i ':a;N;$!ba;s/#{replace}/#{with}/g' #{current_resource.file}", :user => "#{current_resource.owner}")
  shell_out("sed -i 's/#{new_line}/\\n/g' #{current_resource.file}", :user => "#{current_resource.owner}")

  after_checksum = checksum(current_resource.file)

  #if not equals then file updated
  unless "#{current_resource.checksum}" == "#{after_checksum}" then
    new_resource.updated_by_last_action(true)
  end

end