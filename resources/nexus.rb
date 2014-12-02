actions :install_or_update

default_action :install_or_update

attribute :service_name       , :name_attribute => true, :required => true,  :kind_of => String
attribute :source_url       , :required => true,  :kind_of => String
attribute :port       , :required => true,  :kind_of => Integer
attribute :shutdown_port       , :required => true,  :kind_of => Integer
attribute :user       , :required => true,  :kind_of => String
attribute :jvm_opts       , :required => true,  :kind_of => String

attr_accessor :exists