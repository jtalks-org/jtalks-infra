define :maven, :owner => 'root', :base => '/home', :owner_group => nil, :version => '3', :settings_path => nil do
  if params[:owner_group] == nil
    params[:owner_group] = params[:owner]
  end

  version = "#{params[:version]}"
  result_folder_name = "apache-maven-#{node[:maven][version][:version]}"
  base_dir = "#{params[:base]}"


  # creates directory to store artifacts
  directory "#{base_dir}/maven#{version}-repo" do
    owner params[:owner]
    group params[:owner]
    recursive true
    not_if { File.exists?("#{base_dir}/maven#{version}-repo") }
  end

  execute "chown -R #{params[:owner]}.#{params[:owner]} #{base_dir}/maven#{version}-repo"

  # Install Maven
  ark result_folder_name do
    url  node[:maven][version][:url]
    path base_dir
    owner params[:owner]
    action :put
  end

  link "#{base_dir}/maven#{version}" do
    to "#{base_dir}/#{result_folder_name}"
    owner params[:owner]
    group params[:owner_group]
  end

  # Restore configs
  execute "restore settings.xml" do
    command "cp #{params[:settings_path]} #{result_folder_name}/conf/"
    cwd base_dir
    only_if { File.exist?(params[:settings_path]) }
  end

  execute "chown -R #{params[:owner]}.#{params[:owner_group]} #{result_folder_name}" do
    cwd base_dir
  end
  execute "chmod -R 755 #{result_folder_name}" do
    cwd base_dir
    user params[:owner]
  end

  # Replace configs
  replace_config "replace repo path" do
    search_pattern "<localRepository>.*</localRepository>"
    replace_string "<localRepository>#{base_dir}/maven#{version}-repo</localRepository>"
    path "#{base_dir}/#{result_folder_name}/conf/settings.xml"
    user params[:owner]
  end
end