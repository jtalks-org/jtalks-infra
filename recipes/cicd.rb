package "lftp" do
  action :install
end

package "python-dev" do
  action :install
end

package "libmysqlclient-dev" do
  action :install
end

python_pip "mysql-connector-python" do
  options "--allow-external mysql-connector-python"
  action :install
end

python_pip "jtalks-cicd" do
  action :remove
end

python_pip "jtalks-cicd" do
  action :install
end

python_pip "GitPython" do
  action :install
  version "0.3.2.RC1"
  end

python_pip "paramiko" do
  action :install
  version "1.7.5"
end
