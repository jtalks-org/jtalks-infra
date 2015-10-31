actions :install_or_update

default_action :install_or_update

attribute :user       , :required => true,  :kind_of => String
attribute :uid       , :required => true,  :kind_of => Integer
attribute :domain       , :required => true,  :kind_of => String
attribute :postfixadmin_host       , :required => true,  :kind_of => String
attribute :postfixadmin_port       , :required => true,  :kind_of => Integer
attribute :postfixadmin_version       , :required => true,  :kind_of => String
attribute :postfixadmin_source_url       , :required => true,  :kind_of => String
attribute :postfixadmin_config       , :required => true,  :kind_of => Hash
attribute :db_host       , :required => true,  :kind_of => String
attribute :db_host       , :required => true,  :kind_of => String
attribute :db_name       , :required => true,  :kind_of => String
attribute :db_user       , :required => true,  :kind_of => String
attribute :db_password       , :required => true,  :kind_of => String
attribute :setup_password      , :required => true,  :kind_of => String
attribute :admins       , :required => true,  :kind_of => Hash
attribute :mailboxes       , :required => true,  :kind_of => Hash
attribute :domains       , :required => true,  :kind_of => Hash
attribute :admin_username       , :required => true,  :kind_of => String
attribute :opendkim_port       , :required => true,  :kind_of => Integer
attribute :opendkim_user       , :required => true,  :kind_of => String
attribute :opendkim_conf_dir       , :required => true,  :kind_of => String

attr_accessor :exists