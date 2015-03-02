actions :install_or_update

default_action :install_or_update

attribute :service_name       , :name_attribute => true, :required => true,  :kind_of => String
attribute :version       , :required => true,  :kind_of => String
attribute :http_port       , :required => true,  :kind_of => Integer
attribute :smtp_port       , :required => true,  :kind_of => Integer
attribute :http_threads_count       , :required => true,  :kind_of => Integer
attribute :smtp_threads_count       , :required => true,  :kind_of => Integer
attribute :user       , :required => true,  :kind_of => String
attribute :url_source       , :required => true,  :kind_of => String

attr_accessor :exists