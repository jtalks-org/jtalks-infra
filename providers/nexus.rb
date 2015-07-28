require 'pathname'

def whyrun_supported?
  true
end

use_inline_resources

action :install_or_update do

  backup

  install_or_update_nexus

  configure

end

def load_current_resource
  @current_resource = Chef::Resource::JtalksInfraNexus.new(@new_resource.name)
  @current_resource.service_name(@new_resource.service_name)
  @current_resource.version(@new_resource.version)
  @current_resource.source_url(@new_resource.source_url)
  @current_resource.user(@new_resource.user)
  @current_resource.port(@new_resource.port)
  @current_resource.crowd_url(@new_resource.crowd_url)
  @current_resource.crowd_app_name(@new_resource.crowd_app_name)
  @current_resource.crowd_app_password(@new_resource.crowd_app_password)
  @current_resource.crowd_plugin_source_url(@new_resource.crowd_plugin_source_url)
  @current_resource.crowd_group(@new_resource.crowd_group)
  @current_resource.admin_password(@new_resource.admin_password)

  if Pathname.new("/home/#{@new_resource.user}/#{@new_resource.service_name}").exist?
    @current_resource.exists = true
  end
end

def backup
  owner = "#{current_resource.user}"
  service_name = "#{current_resource.service_name}"
  app_dir = "/home/#{owner}/#{service_name}"
  data_dir = "/home/#{owner}/sonatype-work/nexus"
  version = "#{current_resource.version}"

  stable_backup "backup_stable_nexus" do
    user owner
    service_name service_name
    version version
    tomcat_container false
    paths [app_dir, "#{data_dir}/conf", "#{data_dir}/plugin-repository"]
  end
end

def install_or_update_nexus
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  service_name = "#{current_resource.service_name}"
  app_dir = "#{dir}/#{service_name}"
  data_dir = "/home/#{user}/sonatype-work"
  crowd_plugin_source_url = "#{current_resource.crowd_plugin_source_url}"
  version = "#{current_resource.version}"

  directory "#{data_dir}" do
    owner user
    group user
  end

  directory "#{data_dir}/nexus" do
    owner user
    group user
  end

  directory "#{data_dir}/nexus/plugin-repository" do
    owner user
    group user
  end

  directory "#{data_dir}/nexus/conf" do
    owner user
    group user
  end

  template "#{node[:jtalks][:path][:init_script]}/#{service_name}" do
    source 'nexus.service.erb'
    mode '775'
    owner user
    group user
    variables({
                  :dir => app_dir})
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  service "#{service_name}" do
    supports :restart => true
    action :enable
  end

  restart_service service_name do
    user user
  end

  ark "#{service_name}-#{version}" do
    url current_resource.source_url
    path "#{dir}/backup"
    owner user
    action :put
    strip_components 1
    notifies :stop, "service[#{service_name}]", :immediately
    notifies :run, "execute[replace_old_nexus]", :immediately
    not_if  { Pathname.new("#{dir}/backup/#{service_name}-#{version}").exist? }
  end

  execute "replace_old_nexus" do
    command "
        rm -Rf #{app_dir};
        cp -R #{dir}/backup/#{service_name}-#{version}/ #{app_dir} ;
        chown -R #{user}.#{user} #{app_dir};
        chown -R #{user}.#{user} #{data_dir};
            "
    action :nothing
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  #if new installation than start service to deploy (install plugins)
  if !(@current_resource.exists)
    restart_service service_name do
      user user
      action :run
    end

    bash "install_nexus_wait_wait_3_minutes_after_start" do
      code  <<-EOH
        sleep 180
      EOH
      user user
      group user
    end
  end

  remote_file "#{dir}/sonatype-work/nexus/plugin-repository/crowd-plugin.zip" do
    source crowd_plugin_source_url
    owner user
    group user
    notifies :run, "execute[unpack_crowd_plugin_to_nexus]", :immediately
  end

  execute "unpack_crowd_plugin_to_nexus" do
    user user
    group user
    cwd "#{dir}/sonatype-work/nexus/plugin-repository"
    command "rm -Rf nexus-crowd-plugin*; unzip crowd-plugin.zip; rm -Rf crowd-plugin.zip"
    action :nothing
  end

end

def configure
  user = "#{current_resource.user}"
  dir = "/home/#{user}"
  port = "#{current_resource.port}"
  service_name = "#{current_resource.service_name}"
  app_dir = "/home/#{user}/#{service_name}"
  crowd_url = "#{current_resource.crowd_url}/".gsub(/\\/, "")
  crowd_app_name = "#{current_resource.crowd_app_name}"
  crowd_app_password = "#{current_resource.crowd_app_password}"
  crowd_group = "#{current_resource.crowd_group}"
  admin_password = "#{current_resource.admin_password}"
  conf_dir = "#{dir}/sonatype-work/nexus/conf"

  template "#{conf_dir}/crowd-plugin.xml" do
    source 'nexus.crowd.plugin.xml.erb'
    mode '775'
    owner user
    group user
    variables({
                  :crowd_url => crowd_url,
                  :crowd_app_name => crowd_app_name,
                  :crowd_app_password => crowd_app_password
              })
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  jtalks_infra_replacer "nexus_repositories_config" do
    owner user
    group user
    file "#{conf_dir}/nexus.xml"
    replace "<repositories.*<repositoryGrouping>"
    with "<repositories>
            <repository>
              <id>central</id>
              <name>Maven Central</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheActive>true</notFoundCacheActive>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <remoteStorage>
                <url>http://repo1.maven.org/maven2/</url>
              </remoteStorage>
              <externalConfiguration>
                <proxyMode>ALLOW</proxyMode>
                <cleanseRepositoryMetadata>false</cleanseRepositoryMetadata>
                <downloadRemoteIndex>true</downloadRemoteIndex>
                <checksumPolicy>WARN</checksumPolicy>
                <repositoryPolicy>RELEASE</repositoryPolicy>
                <autoBlockActive>true</autoBlockActive>
                <fileTypeValidation>true</fileTypeValidation>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
              </externalConfiguration>
            </repository>
            <repository>
              <id>google</id>
              <name>Google Code</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheActive>true</notFoundCacheActive>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <remoteStorage>
                <url>http://google-maven-repository.googlecode.com/svn/repository/</url>
              </remoteStorage>
              <externalConfiguration>
                <proxyMode>ALLOW</proxyMode>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <cleanseRepositoryMetadata>false</cleanseRepositoryMetadata>
                <downloadRemoteIndex>false</downloadRemoteIndex>
                <checksumPolicy>WARN</checksumPolicy>
                <repositoryPolicy>RELEASE</repositoryPolicy>
              </externalConfiguration>
            </repository>
            <repository>
              <id>java.net-m2</id>
              <name>java.net - Maven 2</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheActive>true</notFoundCacheActive>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <remoteStorage>
                <url>http://download.java.net/maven/2/</url>
              </remoteStorage>
              <externalConfiguration>
                <proxyMode>ALLOW</proxyMode>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <cleanseRepositoryMetadata>false</cleanseRepositoryMetadata>
                <downloadRemoteIndex>false</downloadRemoteIndex>
                <checksumPolicy>WARN</checksumPolicy>
                <repositoryPolicy>RELEASE</repositoryPolicy>
              </externalConfiguration>
            </repository>
            <repository>
              <id>java.net-m1</id>
              <name>java.net-m1</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven1</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheActive>true</notFoundCacheActive>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <remoteStorage>
                <url>http://download.java.net/maven/1/</url>
              </remoteStorage>
              <externalConfiguration>
                <repositoryPolicy>RELEASE</repositoryPolicy>
                <checksumPolicy>WARN</checksumPolicy>
                <downloadRemoteIndex>false</downloadRemoteIndex>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <proxyMode>ALLOW</proxyMode>
              </externalConfiguration>
            </repository>
            <repository>
              <id>apache-snapshots</id>
              <name>Apache Snapshots</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheActive>true</notFoundCacheActive>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <remoteStorage>
                <url>http://repository.apache.org/snapshots/</url>
              </remoteStorage>
              <externalConfiguration>
                <proxyMode>ALLOW</proxyMode>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <cleanseRepositoryMetadata>false</cleanseRepositoryMetadata>
                <downloadRemoteIndex>false</downloadRemoteIndex>
                <checksumPolicy>WARN</checksumPolicy>
                <repositoryPolicy>SNAPSHOT</repositoryPolicy>
              </externalConfiguration>
            </repository>
            <repository>
              <id>releases</id>
              <name>Releases</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>ALLOW_WRITE</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <externalConfiguration>
                <proxyMode>ALLOW</proxyMode>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <cleanseRepositoryMetadata>false</cleanseRepositoryMetadata>
                <downloadRemoteIndex>false</downloadRemoteIndex>
                <checksumPolicy>WARN</checksumPolicy>
                <repositoryPolicy>RELEASE</repositoryPolicy>
              </externalConfiguration>
            </repository>
            <repository>
              <id>builds</id>
              <name>Builds</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>ALLOW_WRITE</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <externalConfiguration>
                <proxyMode>ALLOW</proxyMode>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <cleanseRepositoryMetadata>false</cleanseRepositoryMetadata>
                <downloadRemoteIndex>false</downloadRemoteIndex>
                <checksumPolicy>WARN</checksumPolicy>
                <repositoryPolicy>RELEASE</repositoryPolicy>
              </externalConfiguration>
            </repository>
            <repository>
              <id>snapshots</id>
              <name>Snapshots</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>ALLOW_WRITE</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <externalConfiguration>
                <proxyMode>ALLOW</proxyMode>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <cleanseRepositoryMetadata>false</cleanseRepositoryMetadata>
                <downloadRemoteIndex>false</downloadRemoteIndex>
                <checksumPolicy>WARN</checksumPolicy>
                <repositoryPolicy>SNAPSHOT</repositoryPolicy>
              </externalConfiguration>
            </repository>
            <repository>
              <id>thirdparty</id>
              <name>3rd party</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>ALLOW_WRITE_ONCE</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <externalConfiguration>
                <proxyMode>ALLOW</proxyMode>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <cleanseRepositoryMetadata>false</cleanseRepositoryMetadata>
                <downloadRemoteIndex>false</downloadRemoteIndex>
                <checksumPolicy>WARN</checksumPolicy>
                <repositoryPolicy>RELEASE</repositoryPolicy>
              </externalConfiguration>
            </repository>
            <repository>
              <id>central-m1</id>
              <name>Central M1 shadow</name>
              <providerRole>org.sonatype.nexus.proxy.repository.ShadowRepository</providerRole>
              <providerHint>m2-m1-shadow</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheTTL>15</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <externalConfiguration>
                <masterRepositoryId>central</masterRepositoryId>
                <syncAtStartup>false</syncAtStartup>
              </externalConfiguration>
            </repository>
            <repository>
              <id>java.net-m1-m2</id>
              <name>java.net-m1 M2 shadow</name>
              <providerRole>org.sonatype.nexus.proxy.repository.ShadowRepository</providerRole>
              <providerHint>m1-m2-shadow</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheTTL>15</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <externalConfiguration>
                <masterRepositoryId>java.net-m1</masterRepositoryId>
                <synchronizeAtStartup>false</synchronizeAtStartup>
              </externalConfiguration>
            </repository>
            <repository>
              <id>public</id>
              <name>Public Repositories</name>
              <providerRole>org.sonatype.nexus.proxy.repository.GroupRepository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheTTL>15</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <indexable>true</indexable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <externalConfiguration>
                <mergeMetadata>true</mergeMetadata>
                <memberRepositories>
                  <memberRepository>releases</memberRepository>
                  <memberRepository>snapshots</memberRepository>
                  <memberRepository>thirdparty</memberRepository>
                  <memberRepository>central</memberRepository>
                  <memberRepository>java.net-m2</memberRepository>
                  <memberRepository>java.net-m1-m2</memberRepository>
                  <memberRepository>google</memberRepository>
                  <memberRepository>apache-snapshots</memberRepository>
                  <memberRepository>JTalks</memberRepository>
                  <memberRepository>ZK</memberRepository>
                  <memberRepository>terracota</memberRepository>
                  <memberRepository>Restlets</memberRepository>
                  <memberRepository>nuxeo</memberRepository>
                  <memberRepository>opencast</memberRepository>
                </memberRepositories>
              </externalConfiguration>
            </repository>
            <repository>
              <id>JTalks</id>
              <name>JTalks Repository</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheActive>true</notFoundCacheActive>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <remoteStorage>
                <url>http://repo.jtalks.org/</url>
              </remoteStorage>
              <externalConfiguration>
                <repositoryPolicy>SNAPSHOT</repositoryPolicy>
                <checksumPolicy>WARN</checksumPolicy>
                <fileTypeValidation>true</fileTypeValidation>
                <downloadRemoteIndex>true</downloadRemoteIndex>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <autoBlockActive>true</autoBlockActive>
                <proxyMode>ALLOW</proxyMode>
              </externalConfiguration>
            </repository>
            <repository>
              <id>ZK</id>
              <name>ZK</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheActive>true</notFoundCacheActive>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <remoteStorage>
                <url>http://mavensync.zkoss.org/maven2/</url>
              </remoteStorage>
              <externalConfiguration>
                <repositoryPolicy>RELEASE</repositoryPolicy>
                <checksumPolicy>WARN</checksumPolicy>
                <fileTypeValidation>true</fileTypeValidation>
                <downloadRemoteIndex>true</downloadRemoteIndex>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <autoBlockActive>true</autoBlockActive>
                <proxyMode>ALLOW</proxyMode>
              </externalConfiguration>
            </repository>
            <repository>
              <id>terracota</id>
              <name>terracota</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheActive>true</notFoundCacheActive>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <remoteStorage>
                <url>http://repository.opencastproject.org/nexus/content/repositories/terracotta/</url>
              </remoteStorage>
              <externalConfiguration>
                <repositoryPolicy>RELEASE</repositoryPolicy>
                <checksumPolicy>WARN</checksumPolicy>
                <fileTypeValidation>true</fileTypeValidation>
                <downloadRemoteIndex>true</downloadRemoteIndex>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <autoBlockActive>true</autoBlockActive>
                <proxyMode>ALLOW</proxyMode>
              </externalConfiguration>
            </repository>
            <repository>
              <id>Restlets</id>
              <name>Restlets</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheActive>true</notFoundCacheActive>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <remoteStorage>
                <url>http://maven.restlet.org/</url>
              </remoteStorage>
              <externalConfiguration>
                <repositoryPolicy>RELEASE</repositoryPolicy>
                <checksumPolicy>WARN</checksumPolicy>
                <fileTypeValidation>true</fileTypeValidation>
                <downloadRemoteIndex>true</downloadRemoteIndex>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <autoBlockActive>true</autoBlockActive>
                <proxyMode>BLOCKED_AUTO</proxyMode>
              </externalConfiguration>
            </repository>
            <repository>
              <id>deployment-pipeline</id>
              <name>deployment-pipeline</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>ALLOW_WRITE</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <externalConfiguration>
                <repositoryPolicy>RELEASE</repositoryPolicy>
              </externalConfiguration>
            </repository>
            <repository>
              <id>nuxeo</id>
              <name>Nuxeo</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheActive>true</notFoundCacheActive>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <remoteStorage>
                <url>https://maven-us.nuxeo.org/nexus/content/groups/public/</url>
              </remoteStorage>
              <externalConfiguration>
                <repositoryPolicy>RELEASE</repositoryPolicy>
                <checksumPolicy>WARN</checksumPolicy>
                <fileTypeValidation>true</fileTypeValidation>
                <downloadRemoteIndex>true</downloadRemoteIndex>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <autoBlockActive>true</autoBlockActive>
                <proxyMode>ALLOW</proxyMode>
              </externalConfiguration>
            </repository>
            <repository>
              <id>opencast</id>
              <name>opencast</name>
              <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
              <providerHint>maven2</providerHint>
              <localStatus>IN_SERVICE</localStatus>
              <notFoundCacheActive>true</notFoundCacheActive>
              <notFoundCacheTTL>1440</notFoundCacheTTL>
              <userManaged>true</userManaged>
              <exposed>true</exposed>
              <browseable>true</browseable>
              <writePolicy>READ_ONLY</writePolicy>
              <indexable>true</indexable>
              <searchable>true</searchable>
              <localStorage>
                <provider>file</provider>
              </localStorage>
              <remoteStorage>
                <url>http://repository.opencastproject.org/nexus/content/repositories/public/</url>
              </remoteStorage>
              <externalConfiguration>
                <repositoryPolicy>RELEASE</repositoryPolicy>
                <checksumPolicy>STRICT_IF_EXISTS</checksumPolicy>
                <fileTypeValidation>true</fileTypeValidation>
                <downloadRemoteIndex>true</downloadRemoteIndex>
                <artifactMaxAge>-1</artifactMaxAge>
                <metadataMaxAge>-1</metadataMaxAge>
                <itemMaxAge>-1</itemMaxAge>
                <autoBlockActive>true</autoBlockActive>
                <proxyMode>ALLOW</proxyMode>
              </externalConfiguration>
            </repository>
          </repositories>
          <repositoryGrouping>"
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  jtalks_infra_replacer "nexus_realm_config" do
    owner user
    group user
    file "#{conf_dir}/security-configuration.xml"
    replace "<realms.*</realms>"
    with "<realms>
            <realm>XmlAuthenticatingRealm</realm>
            <realm>XmlAuthorizingRealm</realm>
            <realm>NexusCrowdAuthenticationRealm</realm>
          </realms>"
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  template "#{conf_dir}/security.xml" do
    source 'nexus.security.xml.erb'
    mode '775'
    owner user
    group user
    variables({
                  :crowd_group => crowd_group,
                  :admin_password => admin_password
              })
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  template "#{app_dir}/conf/nexus.properties" do
    source 'nexus.app.conf.properties.erb'
    mode '775'
    owner user
    group user
    variables({
                  :port => port
              })
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end

  template "#{app_dir}/nexus/WEB-INF/classes/nexus.properties" do
    source 'nexus.webapp.conf.properties.erb'
    mode '775'
    owner user
    group user
    variables({
                  :work_dir => "/home/#{user}/sonatype-work/nexus"
              })
    notifies :run, "execute[#{service_name}_restart]", :delayed
  end
end




