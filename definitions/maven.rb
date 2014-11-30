define :maven, :owner => 'root', :base => '/home', :owner_group => nil, :version => '3' do
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
end