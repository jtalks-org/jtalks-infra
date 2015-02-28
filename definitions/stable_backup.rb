define :stable_backup, :user => nil, :service_name => "", :tomcat_version => "8",:version => nil, :db_name => nil, :db_user => nil, :db_pass => nil, :paths => [] do
  file_separator = "/"
  user = params[:user]
  service_name = params[:service_name]
  backup_dir = "/home/#{user}/backup"
  version = params[:version]
  tomcat_version = params[:tomcat_version]
  paths = params[:paths]
  db_name = params[:db_name]
  db_user = params[:db_user]
  db_pass = params[:db_pass]

  pathsString = ""
  file_names = []
  paths.each do |x|
    pathsString << '"' << x << '" '
    file_names.push(x.split(file_separator).last)
  end
  pathsArrayBash = "( #{pathsString} )"

  bash "check_version_and_update_if_need_#{user}" do
    user user
    cwd backup_dir
    code <<-EOH
       paths=#{pathsArrayBash}
       filename=$(find . -type f -name 'current_*')
       if [ $filename ]; then
         version=$(cut -d '_' -f 2 <<< $filename)
       else
         touch "current_#{version}"
       fi

      if [ ! "#{version}" = $version  ]; then
          echo 'New Version, need update'
          rm -Rf current_*
          touch "current_#{version}"
          rm -Rf "#{backup_dir}/stable"
          mkdir "#{backup_dir}/stable"
          touch "#{backup_dir}/stable/restore"
          chmod +x "#{backup_dir}/stable/restore"
          echo '#/bin/bash \r\n' >> #{backup_dir}/stable/restore

          echo 'echo "Stopping service"' >> #{backup_dir}/stable/restore
          echo 'service #{service_name} stop' >> #{backup_dir}/stable/restore
          echo 'pkill -9 -f #{service_name} \r\n\r\n' >> #{backup_dir}/stable/restore

          #if db_name set do backup
           if [ ! ''#{db_name}'' = '' ]; then
              mysqldump -u #{db_user} --password=\"#{db_pass}\" --opt  #{db_name} >  #{backup_dir}/stable/db.sql
              echo '#Restore db \r\n' >>  #{backup_dir}/stable/restore
              echo 'mysql -u #{db_user} --password=\"#{db_pass}\" -D #{db_name} -e \"drop database #{db_name}; create database #{db_name}; \" '  >>  #{backup_dir}/stable/restore
              echo 'mysql -u #{db_user} --password=\"#{db_pass}\" -D #{db_name}  < #{backup_dir}/stable/db.sql \r\n\r\n'  >>  #{backup_dir}/stable/restore
           fi

         echo '#Restore files \r\n' >>  #{backup_dir}/stable/restore
          for p in ${paths[@]}
          do
             cp -LR $p #{backup_dir}/stable
             echo  'cp -LR #{backup_dir}/stable/'$(basename $p) $p >> #{backup_dir}/stable/restore
             echo  'echo "Restored ' $p '"' >> #{backup_dir}/stable/restore
             echo 'chown -R #{user}.#{user} '$p  >> #{backup_dir}/stable/restore
             echo  'echo "Set owner to ' $p '" \r\n' >> #{backup_dir}/stable/restore
          done

           if [ ! "#{service_name}" = "" ]; then
               echo 'rm -Rf /home/#{user}/#{service_name}'  >> #{backup_dir}/stable/restore
               echo 'ln -s /home/#{user}/apache-tomcat-#{node[:tomcat][tomcat_version][:version] } #{service_name}'  >> #{backup_dir}/stable/restore
               echo  'echo "Recreated link" \r\n' >> #{backup_dir}/stable/restore
          fi

          echo 'echo "Starting service"' >> #{backup_dir}/stable/restore
          echo 'service #{service_name} start' >> #{backup_dir}/stable/restore
      fi
    EOH
  end
end
