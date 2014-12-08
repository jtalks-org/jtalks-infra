def whyrun_supported?
  true
end

use_inline_resources

action :run do
  set_variable
end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraEnvironment.new(@new_resource.name)
  @current_resource.env_name(@new_resource.env_name)
  @current_resource.env_value(@new_resource.env_value)
end

def set_variable
  name = current_resource.env_name
  value = current_resource.env_value

  ruby_block "set_environment_variable_#{name}" do
    var_line = %{#{name}="#{value}"}

    block do
      file = Chef::Util::FileEdit.new("/etc/environment")
      file.search_file_replace_line(name, var_line)
      file.insert_line_if_no_match(name, var_line)
      file.write_file
    end

    current_resource.updated_by_last_action(true)

    not_if "grep '#{var_line}' /etc/environment"
  end

end