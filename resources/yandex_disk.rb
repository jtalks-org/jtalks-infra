actions :install_or_update

default_action :install_or_update

attribute :service_name       , :name_attribute => true, :required => true,  :kind_of => String
attribute :user       , :required => true,  :kind_of => String
attribute :disk_dir       , :required => true,  :kind_of => String
attribute :disk_login       , :required => true,  :kind_of => String
attribute :disk_password       , :required => true,  :kind_of => String
attribute :disk_repo_url       , :required => true,  :kind_of => String
attribute :disk_repo_components       , :required => true,  :kind_of => Array
attribute :disk_repo_key       , :required => true,  :kind_of => String

attr_accessor :exists