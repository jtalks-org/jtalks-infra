actions :run
default_action :run

attribute :env_name       , :name_attribute => true, :required => true,  :kind_of => String
attribute :env_value       , :required => true,  :kind_of => String

attr_accessor :exists