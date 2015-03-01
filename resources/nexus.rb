actions :install_or_update

default_action :install_or_update

attribute :service_name       , :name_attribute => true, :required => true,  :kind_of => String
attribute :source_url       , :required => true,  :kind_of => String
attribute :version       , :required => true,  :kind_of => String
attribute :port       , :required => true,  :kind_of => Integer
attribute :shutdown_port       , :required => true,  :kind_of => Integer
attribute :user       , :required => true,  :kind_of => String
attribute :jvm_opts       , :required => true,  :kind_of => String
attribute :crowd_url      , :required => true,  :kind_of => String
attribute :crowd_app_name  , :required => true,  :kind_of => String
attribute :crowd_app_password , :required => true,  :kind_of => String
attribute :crowd_plugin_source_url , :required => true,  :kind_of => String
attribute :crowd_group , :required => true,  :kind_of => String
attribute :admin_password , :required => true,  :kind_of => String

attr_accessor :exists