actions :install_or_update

default_action :install_or_update

attribute :service_name       , :name_attribute => true, :required => true,  :kind_of => String
attribute :version       , :required => true,  :kind_of => String
attribute :source_url     , :required => true, :kind_of => String
attribute :user       , :required => true,  :kind_of => String
attribute :data_dir       , :required => true,  :kind_of => String
attribute :port       , :required => true,  :kind_of => Integer
attribute :control_port       , :required => true,  :kind_of => Integer
attribute :jvm_opts          , :required => false, :kind_of => String
attribute :crowd_url     , :required => true, :kind_of => String
attribute :crowd_app_name     , :required => true, :kind_of => String
attribute :crowd_app_password     , :required => true, :kind_of => String
attribute :db_name     , :required => true, :kind_of => String
attribute :db_user     , :required => true, :kind_of => String
attribute :db_password     , :required => true, :kind_of => String
attribute :license_text     , :required => true, :kind_of => String
attribute :db_backup_path     , :required => true, :kind_of => String
attribute :host     , :required => true, :kind_of => String
attribute :build_number       , :required => true,  :kind_of => String
attribute :java_home       , :required => true,  :kind_of => String

attr_accessor :exists