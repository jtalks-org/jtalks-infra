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

  # Install Maven
  ark result_folder_name do
    url  node[:maven][version][:url]
    path base_dir
    owner params[:owner]
    action :put
    not_if { File.exists?("#{base_dir}/#{result_folder_name}") }
  end

  link "#{base_dir}/maven#{version}" do
    to "#{base_dir}/#{result_folder_name}"
    owner params[:owner]
    group params[:owner_group]
    not_if { File.exists?("#{base_dir}/maven#{version}") }
  end

  # Restore configs
  execute "restore #{base_dir}/maven#{version} settings.xml" do
    command "cp #{params[:settings_path]} #{result_folder_name}/conf/"
    cwd base_dir
    user params[:owner]
    group params[:owner]
    only_if { File.exist?(params[:settings_path]) }
  end

  # Replace configs
  jtalks_infra_replacer "maven_settings_xml" do
    owner params[:owner]
    group params[:owner]
    file "#{base_dir}/#{result_folder_name}/conf/settings.xml"
    replace "<localRepository>.*</localRepository>"
    with "<localRepository>#{base_dir}/maven#{version}-repo</localRepository>"
  end
end