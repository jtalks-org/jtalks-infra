actions :install_or_update

default_action :install_or_update

attribute :service_name       , :name_attribute => true, :required => true,  :kind_of => String
attribute :data_dir       , :required => true,  :kind_of => String
attribute :user       , :required => true,  :kind_of => String
attribute :source_url       , :required => true,  :kind_of => String
attribute :host       , :required => true,  :kind_of => String
attribute :port       , :required => true,  :kind_of => Integer
attribute :control_port       , :required => true,  :kind_of => Integer
attribute :crowd_url       , :required => true,  :kind_of => String
attribute :crowd_app_name       , :required => true,  :kind_of => String
attribute :crowd_app_password       , :required => true,  :kind_of => String
attribute :crowd_groups       , :required => true,  :kind_of => Array
attribute :crowd_admin_group     , :required => true, :kind_of => String
attribute :db_name     , :required => true, :kind_of => String
attribute :db_user     , :required => true, :kind_of => String
attribute :db_password     , :required => true, :kind_of => String
attribute :db_backup_path     , :required => true, :kind_of => String
attribute :version     , :required => true, :kind_of => String
attribute :license_text     , :required => true, :kind_of => String
attribute :crucible_license_text     , :required => true, :kind_of => String
attribute :git_bin_path     , :required => true, :kind_of => String
attribute :smtp_host     , :required => true, :kind_of => String
attribute :smtp_port     , :required => true, :kind_of => String
attribute :smtp_user     , :required => true, :kind_of => String
attribute :smtp_password     , :required => true, :kind_of => String
attribute :repositories     , :required => true, :kind_of => Hash

attr_accessor :exists