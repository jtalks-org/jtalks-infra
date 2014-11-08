actions :run
default_action :run

attribute :file       , :name_attribute => true, :required => true,  :kind_of => String
attribute :owner       , :required => true,  :kind_of => String
attribute :group       , :required => true,  :kind_of => String
attribute :replace       , :required => true,  :kind_of => String
attribute :with       , :required => true,  :kind_of => String
attribute :checksum       , :required => true,  :kind_of => String