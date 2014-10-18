define :replace_config, :path => '', :search_pattern => '', :replace_string => '', :owner => 'root' do

  new_line="<new_line_chef>"
  regex="#{params[:search_pattern]}".gsub(/\//, "\\/").gsub(/\"/, "\\\"")
  replace="#{params[:replace_string]}".gsub(/\//, "\\/").gsub(/\"/, "\\\"").gsub(/\n/, "#{new_line}")

  execute "replace_config" do
    command "
      sed -i ':a;N;$!ba;s/#{regex}/#{replace}/g' #{params[:path]};
      sed -i 's/#{new_line}/\\n/g' #{params[:path]};
    "
    user params[:owner]
  end
end