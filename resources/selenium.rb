actions :install_or_update

default_action :install_or_update

attribute :service_name       , :name_attribute => true, :required => true,  :kind_of => String
attribute :source_url       , :required => true,  :kind_of => String
attribute :version       , :required => true,  :kind_of => String
attribute :user       , :required => true,  :kind_of => String

attr_accessor :exists