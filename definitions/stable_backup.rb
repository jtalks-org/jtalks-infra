define :stable_backup, :user => nil, :service_name => "", :tomcat_version => "8", :tomcat_container => true, :version => nil, :db_name => nil, :db_user => nil, :db_pass => nil, :paths => [] do
  init_dir = "#{node[:jtalks][:path][:init_script]}"
  file_separator = "/"
  user = params[:user]
  service_name = params[:service_name]
  backup_dir = "/home/#{user}/backup"
  version = params[:version]
  tomcat_version = params[:tomcat_version]
  tomcat_container = params[:tomcat_container]
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
          rm -Rf "#{backup_dir}/stable"
          mkdir "#{backup_dir}/stable"
          cp current_* "#{backup_dir}/stable"
          rm -Rf current_*
          touch "current_#{version}"

          touch "#{backup_dir}/stable/restore"
          chmod +x "#{backup_dir}/stable/restore"
          echo '#/bin/bash \n' >> #{backup_dir}/stable/restore

          echo 'echo "Stopping service"' >> #{backup_dir}/stable/restore
          echo '#{init_dir}/#{service_name} stop' >> #{backup_dir}/stable/restore
          echo 'pkill -9 -f #{service_name} \n\n' >> #{backup_dir}/stable/restore

          #if db_name set do backup
           if [ ! ''#{db_name}'' = '' ]; then
              mysqldump -u #{db_user} --password=\"#{db_pass}\" --opt  #{db_name} >  #{backup_dir}/stable/db.sql
              echo '#Restore db \n' >>  #{backup_dir}/stable/restore
              echo 'mysql -u #{db_user} --password=\"#{db_pass}\" -D #{db_name} -e \"drop database #{db_name}; create database #{db_name}; \" '  >>  #{backup_dir}/stable/restore
              echo 'mysql -u #{db_user} --password=\"#{db_pass}\" -D #{db_name}  < #{backup_dir}/stable/db.sql \n\n'  >>  #{backup_dir}/stable/restore
           fi

         echo '#Restore files \n' >>  #{backup_dir}/stable/restore
         for p in ${paths[@]}
          do

            filesByRegex=$(find p -maxdepth 0)
            if [ ! "${filesByRegex[@]}" = "0" ]; then
               for fileByRegex in ${p[@]}
                 do
                   fileByRegex=$(echo $fileByRegex | sed -r 's/ /\\ /g')

                   if [ "#{tomcat_container}" = "true" ]; then
                     fileByRegex=$(echo $fileByRegex | sed -r 's/#{service_name}$/apache-tomcat-#{node[:tomcat][tomcat_version][:version]}/g')
                   fi

                   cp -LR $fileByRegex #{backup_dir}/stable
                   echo  'rm -R ' $fileByRegex >> #{backup_dir}/stable/restore
                   echo  'cp -R #{backup_dir}/stable/'$(basename $fileByRegex) $fileByRegex >> #{backup_dir}/stable/restore
                   echo  'echo "Restored ' $fileByRegex '"' >> #{backup_dir}/stable/restore
                   echo 'chown -R #{user}.#{user} '$fileByRegex  >> #{backup_dir}/stable/restore
                   echo  'echo "Set owner to ' $fileByRegex '" \n' >> #{backup_dir}/stable/restore
                 done
            fi
          done

           if [ "#{tomcat_container}" = "true" ]; then
               echo 'rm -Rf /home/#{user}/#{service_name}'  >> #{backup_dir}/stable/restore
               echo 'ln -s /home/#{user}/apache-tomcat-#{node[:tomcat][tomcat_version][:version]} /home/#{user}/#{service_name}'  >> #{backup_dir}/stable/restore
               echo  'echo "Recreated link" \n' >> #{backup_dir}/stable/restore
          fi

          echo 'echo "Starting service"' >> #{backup_dir}/stable/restore
          echo '#{init_dir}/#{service_name} start' >> #{backup_dir}/stable/restore

          echo 'rm -Rf #{backup_dir}/current*' >> #{backup_dir}/stable/restore
          echo 'cp -f #{backup_dir}/stable/current_* #{backup_dir}'  >> #{backup_dir}/stable/restore
      fi
    EOH
  end
end
