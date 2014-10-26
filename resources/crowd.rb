actions :install, :update

attribute :service_name       , :name_attribute => true, :required => true,  :kind_of => String
attribute :user       , :required => true,  :kind_of => String
attribute :data_dir       , :required => true,  :kind_of => String
attribute :download_url     , :required => true, :kind_of => String
attribute :db_config_name     , :required => true, :kind_of => String
attribute :db_backup_path     , :required => true, :kind_of => String
attribute :tomcat_port     , :required => true, :kind_of => Integer
attribute :tomcat_shutdown_port     , :required => true, :kind_of => Integer
attribute :mysql_connector_url     , :required => true, :kind_of => String
attribute :app_conf_license_text     , :required => true, :kind_of => String
attribute :ext_libs_url     , :required => true, :kind_of => String
attribute :app_conf_name     , :required => true, :kind_of => String
attribute :app_conf_password     , :required => true, :kind_of => String
attribute :app_conf_url     , :required => true, :kind_of => String
attribute :app_conf_cookie_domain     , :required => true, :kind_of => String

attr_accessor :exists