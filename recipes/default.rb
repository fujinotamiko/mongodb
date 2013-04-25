template "/etc/yum.repos.d/10gen.repo" do  # (2)
   owner "root"
   group "root"
   mode "0644"
end

%w{
	mongo-10gen 
	mongo-10gen-server
}.each do |pkg_name|
	filename = "#{pkg_name}-2.4.0-mongodb_1.x86_64.rpm"
	cookbook_file "/tmp/#{filename}" do
		source "#{filename}"
	end
	package pkg_name do
		action :install
		provider Chef::Provider::Package::Rpm
		source "/tmp/#{filename}"
	end
end

service "mongod" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
