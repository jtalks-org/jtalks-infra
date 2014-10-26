actions :install, :update

attribute :service_name       , :name_attribute => true, :required => true,  :kind_of => String
attribute :user       , :required => true,  :kind_of => String
attribute :server_hostname       , :required => true,  :kind_of => String
attribute :maven_backup_path       , :required => true,  :kind_of => String
attribute :maven_backup_path       , :required => true,  :kind_of => String
attribute :tomcat_port     , :required => true, :kind_of => Integer
attribute :tomcat_shutdown_port     , :required => true, :kind_of => Integer
attribute :download_url       , :required => true,  :kind_of => String
attribute :plugins_download_url       , :required => true,  :kind_of => String
attribute :plugins_map       , :required => true,  :kind_of => Hash
attribute :config_backup_path       , :required => true,  :kind_of => String
attribute :crowd_url       , :required => true,  :kind_of => String
attribute :crowd_app_name       , :required => true,  :kind_of => String
attribute :crowd_app_password       , :required => true,  :kind_of => String
attribute :crowd_group       , :required => true,  :kind_of => String
attribute :crowd_cookie_domain       , :required => true,  :kind_of => String

attr_accessor :exists